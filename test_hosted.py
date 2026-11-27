import json
import tempfile
import unittest
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from unittest.mock import patch

from ops import hosted
from ops.hosted import HourlyLimit, reserve


class HostedQuotaTest(unittest.TestCase):
    def test_one_concurrent_start_and_rolling_hour(self):
        with tempfile.TemporaryDirectory() as directory:
            service = Path(directory)

            def start(_):
                try:
                    reserve(service, 10000)
                except HourlyLimit:
                    return False
                return True

            with ThreadPoolExecutor(4) as pool:
                self.assertEqual(sum(pool.map(start, range(8))), 1)
            with self.assertRaises(HourlyLimit):
                reserve(service, 13599.99)
            reserve(service, 13600)
            with self.assertRaises(HourlyLimit):
                reserve(service, 9999)


class HostedRoutingTest(unittest.TestCase):
    def test_cli_receives_problem_model_and_effort(self):
        for problem, stage, model, effort in [
                ("refined-bmv", "solve", "gpt-6.2-astra", "medium"),
                ("refined-bmv", "math_review", "gpt-6.2-astra", "medium"),
                ("refined-bmv", "priority_review", "gpt-6.2-sol", "low"),
                ("refined-bmv", "scout", "gpt-6.2-sol", "low"),
                ("golay43", "solve", "gpt-6.2-sol", "low"),
                ("new-problem", "solve", "gpt-6.2-sol", "low")]:
            with self.subTest(problem=problem, stage=stage), tempfile.TemporaryDirectory() as tmp:
                root = Path(tmp)
                cli = root / "codex"
                cli.write_text("""#!/usr/bin/env python3
import json, sys
from pathlib import Path
if sys.argv[1] == 'login':
    print('Logged in using ChatGPT')
else:
    Path(sys.argv[sys.argv.index('-o')+1]).write_text(json.dumps(sys.argv))
""")
                cli.chmod(0o700)
                (root / "settings.json").write_text(json.dumps({"hosted_codex": str(cli)}))
                with patch.object(hosted, "SERVICE", root):
                    args = hosted.generate("check", {}, problem_id=problem, stage=stage)
                self.assertEqual(args[args.index("--model")+1], model)
                self.assertIn(f'model_reasoning_effort="{effort}"', args)
