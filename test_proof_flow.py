"""Exercise the hosted handoff and the trusted, source-bound publication path."""
import copy
from io import BytesIO
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from checks import golay_certificate, werner_witness
from ops import proof_flow as flow
from ops import publish_checked as publish
from ops import release_witness as release
from ops.witness import contracts, fingerprint


ROOT = Path(__file__).resolve().parent
GOLAY = "golay43"
PUBLICATION_SHA = "1" * 40
RESEARCH_SHA = "2" * 40
CARD = {"known": "Test-only packet", "evidence_checked": ["https://example.org/source"]}
MATH = {"verdict": "pass", "hypotheses": "All fixed hypotheses compared", "weakest_step": "Forward replay"}
PRIOR = {"verdict": "clear_within_search", "sources": '["https://example.org/source"]',
         "comparison": "Fixture scoped comparison"}


def proposal(witness):
    return {"approach": "direct construction", "witness_json": json.dumps(witness),
            "derivation": "Apply the registered checker", "what_would_change": "A different exact result"}


def submitted_solution(pid, witness):
    """Synthetic all-pass review metadata; the real checker must still decide."""
    contract = contracts()[pid]
    obj = flow.new_record(pid, contract)
    attempt = flow.execute(pid, contract, proposal(witness), [])
    attempt.update(math_review=dict(MATH), priority_review=dict(PRIOR))
    obj.update(status="ready_for_replay", attempts=[attempt])
    return obj


class ProofFlowTest(unittest.TestCase):
    def test_real_object_runs_before_review_and_retry_remembers_results(self):
        contract = contracts()[GOLAY]
        r = flow.new_record(GOLAY, contract)
        p = proposal(golay_certificate.example())
        with patch.object(flow, "answer", side_effect=[p, MATH, p]) as hosted:
            flow.advance_one(r, contract, CARD)
            self.assertEqual(r["status"], "math_review")
            first, = r["attempts"]
            self.assertEqual(first["result"]["cnot_count"], 44)
            self.assertTrue(first["result"]["target_prepared"])
            self.assertFalse(first["result"]["decisive"])
            flow.advance_one(r, contract, CARD)
            self.assertIn('"cnot_count": 44', hosted.call_args.args[0])
            self.assertEqual(r["status"], "solve")
            flow.advance_one(r, contract, CARD)
            self.assertIn('"cnot_count": 44', hosted.call_args.args[0])
            self.assertIn("rejection", r["attempts"][-1])
            self.assertEqual(sum("result" in x for x in r["attempts"]), 1)
        with patch.object(flow, "answer", return_value={**MATH, "verdict": "park"}):
            flow.advance_one(r, contract, CARD)
        self.assertEqual(r["status"], "parked")

    def test_release_replays_instead_of_trusting_reported_score(self):
        ordinary = submitted_solution(GOLAY, golay_certificate.example())
        wrong_score = copy.deepcopy(ordinary)
        wrong_score["attempts"][0]["result"].update(cnot_count=43, decisive=True)
        changed_object = copy.deepcopy(ordinary)
        changed_object["attempts"][0]["witness"]["gates"] = []
        stale_contract = {**ordinary, "contract_hash": "wrong"}
        scoped = submitted_solution("werner-endpoint", werner_witness.example())
        scoped["attempts"][0]["result"]["decisive"] = True
        for case in (ordinary, wrong_score, changed_object, stale_contract, scoped):
            with self.subTest(pid=case["problem_id"]), self.assertRaises(ValueError):
                release.package(case, RESEARCH_SHA, PUBLICATION_SHA)

    def test_only_both_reviews_allow_final_replay(self):
        # This mocked decisive object checks routing only. No physical conclusion.
        fixture = {"decisive": True, "fixture": "routing only"}
        c = contracts()[GOLAY]
        for verdict, expected in (("unresolved", "priority_unresolved"),
                                  ("prior_resolution", "prior_resolution"),
                                  ("clear_within_search", "ready_for_replay")):
            rec = flow.new_record(GOLAY, c)
            with patch.object(flow, "replay", return_value=fixture), patch.object(flow, "answer",
                    side_effect=[proposal({"fixture": 1}), MATH, {**PRIOR, "verdict": verdict}]):
                flow.advance_one(rec, c, CARD)
                flow.advance_one(rec, c, CARD)
                self.assertEqual(rec["status"], "priority_review")
                flow.advance_one(rec, c, CARD)
                self.assertEqual(rec["status"], expected)
            with patch.object(release, "replay", return_value=fixture):
                if expected == "ready_for_replay":
                    self.assertEqual(release.package(rec, RESEARCH_SHA, PUBLICATION_SHA)["result"], fixture)
                else:
                    with self.assertRaises(ValueError):
                        release.package(rec, RESEARCH_SHA, PUBLICATION_SHA)

    def test_branch_publication_fixture(self):
        """Synthetic checker ONLY in temp Git. No live service, real result, or real issue."""
        with tempfile.TemporaryDirectory() as name, patch.dict(os.environ, {
                "GIT_AUTHOR_NAME": "Test", "GIT_AUTHOR_EMAIL": "lab@example.invalid",
                "GIT_COMMITTER_NAME": "Test", "GIT_COMMITTER_EMAIL": "lab@example.invalid"}):
            root = Path(name)
            remote, editor, worker = [root / s for s in ("remote.git", "editor", "worker")]

            def git(cwd, *args):
                return subprocess.check_output(["git", *args], cwd=cwd, text=True, stderr=subprocess.PIPE).strip()

            git(root, "init", "--quiet", "--bare", "-b", "main", str(remote))
            git(root, "clone", "--quiet", str(remote), str(editor))
            for path in ("lab.py", "verify.py", "ops/witness.py", "ops/release_witness.py"):
                dest = editor / path
                dest.parent.mkdir(exist_ok=True)
                shutil.copyfile(ROOT / path, dest)
            (editor / "discovery").mkdir()
            (editor / "certificates").mkdir()
            (editor / "checks").mkdir()
            contract = contracts()[GOLAY]
            (editor / "discovery/proof-contracts.json").write_text(json.dumps({GOLAY: contract}))
            (editor / "discovery/proof-issues.json").write_text(json.dumps({GOLAY: 123}))
            (editor / "certificates/index.json").write_text("{}")
            # The positive branch exercises export mechanics only. Every other test above
            # uses the actual signed Golay checker except the explicitly labeled routing test.
            mocked = 'def check(witness):\n    return {"decisive": witness == {"fixture": 1}, "fixture": "branch test"}\n'
            (editor / "checks/golay_certificate.py").write_text(mocked)
            git(editor, "add", ".")
            git(editor, "commit", "-qm", "common ancestor")
            git(editor, "branch", "research")
            (editor / "public-only").write_text("main has diverged")
            git(editor, "add", "public-only")
            git(editor, "commit", "-qm", "main-only revision")
            main_before = git(editor, "rev-parse", "HEAD")
            git(editor, "push", "-q", "origin", "main", "research")
            git(root, "clone", "--quiet", "-b", "research", str(remote), str(worker))
            data = {"fixture": 1}
            with patch.object(flow, "replay", return_value={"decisive": True, "fixture": "branch test"}):
                record = submitted_solution(GOLAY, data)
            out = worker / "campaign/proof-flow"
            out.mkdir(parents=True)
            packet = out / (GOLAY + "-" + fingerprint(contract)[:16] + ".json")
            packet.write_text(json.dumps(record))
            # The researcher may change any local checker. Publication must use main's copy.
            (worker / "checks/golay_certificate.py").write_text('raise RuntimeError("untrusted research checker")')
            git(worker, "add", ".")
            git(worker, "commit", "-qm", "scored fixture")
            git(worker, "push", "-q", "origin", "research")
            research = git(worker, "rev-parse", "HEAD")
            real_output, real_run = subprocess.check_output, subprocess.run
            closes = []

            def fake_output(argv, **kwargs):
                if argv[0] == "gh":
                    return "CLOSED" if closes else "OPEN"
                return real_output(argv, **kwargs)

            def fake_run(argv, *args, **kwargs):
                if argv[:3] == ["gh", "issue", "close"]:
                    closes.append(argv[3])
                    return subprocess.CompletedProcess(argv, 0)
                return real_run(argv, *args, **kwargs)

            def fake_urlopen(url, timeout):
                path = url.split("certificates/", 1)[1].split("?", 1)[0]
                data = git(remote, "show", "main:certificates/" + path)
                return BytesIO(data.encode())

            with patch.object(publish, "urlopen", side_effect=fake_urlopen), \
                    patch.object(subprocess, "check_output", side_effect=fake_output), \
                    patch.object(subprocess, "run", side_effect=fake_run):
                publish.publish(worker)
                published = git(remote, "rev-parse", "main")
                publish.publish(worker)
            self.assertEqual(git(remote, "rev-parse", "main"), published)
            self.assertEqual(closes, ["123"])
            self.assertEqual(git(remote, "rev-parse", "main^"), main_before)
            self.assertEqual(git(remote, "rev-parse", "research"), research)
            cert = json.loads(git(remote, "show", "main:certificates/golay43.json"))
            self.assertEqual((cert["research_commit"], cert["checker_commit"]), (research, main_before))
            self.assertEqual(cert["witness"], data)
            self.assertEqual(cert["result"]["fixture"], "branch test")


if __name__ == "__main__":
    unittest.main()
