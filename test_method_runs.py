import json
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from ops import hosted, worker
from ops.method_runs import codex_usage, measure


class MethodRunTest(unittest.TestCase):
    def test_actual_counters_and_partial_usage(self):
        one = {"input_tokens": 19, "cached_input_tokens": 7, "output_tokens": 5}
        event = json.dumps({"type": "turn.completed", "usage": one}).encode()
        private = b'{"type":"item.completed","item":{"text":"private answer"}}'
        self.assertEqual(codex_usage([private, event], True), (one, True))
        self.assertEqual(codex_usage([event, event], True), ({k: v*2 for k,v in one.items()}, True))
        self.assertEqual(codex_usage([event, b'{"type":"turn.failed"}'], False), (one, False))
        self.assertEqual(codex_usage([private], False), (None, False))
        self.assertEqual(codex_usage([b'{"type":"turn.completed","usage":{}}'], True), (None, False))

    def test_real_cli_entrypoint_without_using_plan_quota(self):
        # This local test executable imitates the CLI wire format and never starts a model.
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            fake = root / "codex"
            fake.write_text("""#!/usr/bin/env python3
import json, sys
from pathlib import Path
if sys.argv[1:3] == ['login', 'status']:
    print('Logged in using ChatGPT')
else:
    assert '--json' in sys.argv
    assert 'scientific task' in sys.stdin.read()
    Path(sys.argv[sys.argv.index('-o')+1]).write_text('{"reply":"done"}')
    print(json.dumps({'type':'item.completed','item':{'text':'transcript sentinel'}}))
    print(json.dumps({'type':'turn.completed','usage':{'input_tokens':100,'cached_input_tokens':20,'output_tokens':9}}))
""")
            fake.chmod(0o700)
            (root / "settings.json").write_text(json.dumps({"hosted_codex": str(fake)}))
            with patch.object(hosted, "SERVICE", root), patch("ops.method_runs.revision", return_value="a"*40):
                with measure(root, "p", "solve", "notebook", model=hosted.MODEL) as run:
                    self.assertEqual(hosted.generate("task", {}, metrics=run), {"reply": "done"})
                    run["outcome"] = "bounded_result"
                with self.assertRaises(hosted.HourlyLimit), measure(root, "p", "solve", "notebook", model=hosted.MODEL) as other:
                    hosted.generate("task", {}, metrics=other)
            receipt, = (root / "campaign/method-runs").glob("*.json")
            self.assertNotIn("transcript sentinel", receipt.read_text())
            row = json.loads(receipt.read_text())
            self.assertEqual(row["status"], "completed")
            self.assertEqual(row["usage"], {"input_tokens":100,"cached_input_tokens":20,"output_tokens":9})
            self.assertTrue(row["usage_complete"])
            self.assertGreaterEqual(row["elapsed_seconds"], row["hosted_elapsed_seconds"])

    def test_provider_refusal_is_a_failed_attempt(self):
        with tempfile.TemporaryDirectory() as temp, patch("ops.method_runs.revision", return_value="a"*40):
            root = Path(temp)
            fake = root / "codex"
            fake.write_text("""#!/bin/sh
if [ "$1" = login ]; then
 echo 'Logged in using ChatGPT'
else
 echo '{"type":"turn.failed","error":{"message":"usage_limit_reached"}}'
 exit 1
fi
""")
            fake.chmod(0o700)
            (root / "settings.json").write_text(json.dumps({"hosted_codex": str(fake)}))
            with patch.object(hosted, "SERVICE", root), self.assertRaises(hosted.ProviderUsageLimit):
                with measure(root, "p", "solve", "notebook", model=hosted.MODEL) as run:
                    hosted.generate("task", {}, metrics=run)
            receipt, = (root / "campaign/method-runs").glob("*.json")
            row = json.loads(receipt.read_text())
            self.assertEqual(row["status"], "failed")
            self.assertTrue(row["hosted_invoked"])
            self.assertEqual(row["error_type"], "ProviderUsageLimit")
            self.assertEqual((row["usage"], row["usage_complete"]), (None, False))

    def test_failed_timeout_and_noop_search(self):
        with tempfile.TemporaryDirectory() as temp, patch("ops.method_runs.revision", return_value="a"*40):
            root = Path(temp)
            def new_row():
                receipt, = (root / "campaign/method-runs").glob("*.json")
                row = json.loads(receipt.read_text())
                receipt.unlink()
                return row
            with self.assertRaises(TimeoutError), measure(root, "p", "solve", "notebook", model=hosted.MODEL):
                raise TimeoutError("sensitive diagnostic")
            row = new_row()
            self.assertEqual((row["status"], row["usage"], row["usage_complete"]), ("timeout", None, False))
            self.assertNotIn("sensitive", str(row))
            with patch.object(worker, "RUNTIME", root), patch.object(worker, "call") as call:
                worker.search("p", "local-search", ["receipts"], ["worker"])
                self.assertEqual(new_row()["outcome"], "no_new_receipt")
                def partial(*args, **kwargs):
                    out = root / "campaign/receipts"
                    out.mkdir()
                    (out / "candidate.json").write_text("{}")
                    raise subprocess.CalledProcessError(1, "worker")
                call.side_effect = partial
                with self.assertRaises(subprocess.CalledProcessError):
                    worker.search("p", "local-search", ["receipts"], ["worker"])
                row = new_row()
                self.assertEqual((row["status"], row["evidence"]), ("failed","campaign/receipts/candidate.json"))
                self.assertTrue(row["usage_complete"])
                self.assertEqual(row["usage"]["input_tokens"], 0)
