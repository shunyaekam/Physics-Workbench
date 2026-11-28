import json
from pathlib import Path
import tempfile
import unittest
from urllib.error import HTTPError
from unittest.mock import patch

from ops import sync_left_to_solve as sync


class FakeDesk:
    def __init__(self):
        self.responses = {}
        self.urls = []

    def get(self, url, missing_ok=False):
        self.urls.append(url)
        if missing_ok and url not in self.responses:
            return None, ""
        return self.responses[url]


class AcceptedFeedTest(unittest.TestCase):
    def test_direct_nested_closed_parent_and_exclusions(self):
        desk = FakeDesk()
        handle = "shunyaekam"
        problem = "Source.variants.x"
        parent = "Closed.Root"
        late = "Archived"
        paths = [f"proofs/{problem}.lean", f"proofs/{parent}.R1.H1.R1.H2.lean",
                 "statements/Proposed.lean", "reductions/Incomplete.R2.lean",
                 f"proofs/{late}.lean", "proofs/Other.R1.H1.lean"]
        evidence = {i: f"{sync.PULL}{i}" for i in range(1, 11)}
        first = f"{sync.API}/issues?creator={handle}&state=closed&per_page=100"
        next_url = first + "&page=2"
        issues = []
        for i, path in enumerate(paths, 1):
            issues.append({"number": i, "pull_request": {"merged_at": "today"}, "user": {"login": handle}})
            endpoint = f"{sync.API}/pulls/{i}"
            desk.responses[endpoint] = ({"html_url": evidence[i], "merged": True, "changed_files": 1,
                                    "user": {"login": handle}, "base": {"ref": "main", "repo": {"full_name": sync.REPO}}}, "")
            desk.responses[endpoint + "/files"] = ([{"filename": path, "status": "added"}], "")
        issues += [{"number": 100}, {"number": 101, "pull_request": {"merged_at": None}}]
        desk.responses[first] = (issues[:1], f'<{next_url}>; rel="next"')
        desk.responses[next_url] = (issues[1:], "")
        stamp = "2026-11-20T10:00:00Z"

        def row(i, ident, outcome, owner=handle, agent="ai"):
            return {"problem_id": ident, "pr_url": evidence[i], "title": ident, "created_at": stamp,
                    "polarity": "proof", "handle": owner, "agent": agent, "step": outcome == "step",
                    "contributors": None, "outcome": outcome}

        direct = row(1, problem, "open")
        direct.update(polarity="disproof", agent="codex", model="declared-model", variantOf="This variant leaves the parent open.")
        closure = row(10, parent, "known", "SomeoneElse", "reduction")
        closure["pr_url"] += "#closed"
        closure["contributors"] = ["ImmediateStepSolver"]
        rows = [direct, closure, row(2, parent+".R1.H1.R1.H2", "step"), row(6, "Other.R1.H1", "step")]
        solved_url = f"{sync.SITE}/api/solved"
        desk.responses[solved_url] = ({"count": 4, "solved": rows[:2], "next": "?page=2"}, "")
        desk.responses[solved_url + "?page=2"] = ({"count": 4, "solved": rows[2:]}, "")

        for ident, kind in [(problem, "open"), (parent, "known"), (late, "warmup")]:
            desk.responses[f"{sync.SITE}/api/problems/{ident}"] = (
                {"id": ident, "title": ident, "fields": ["Statistical mechanics"], "kind": kind,
                 "statement": "Does the identity hold for every n?",
                 "ref": "https://oeis.org/A123456" if ident == problem else "javascript:alert(1)"}, "")
        for ident, i, role, item in [(parent, 2, "step", parent+".R1.H1.R1.H2"), (late, 5, "proof", late)]:
            desk.responses[sync.certificate_url(ident, handle)] = ({"certificate": {
                "type": "left-to-solve/contribution-certificate", "issuer": "lefttosolve.com",
                "problem": {"id": ident}, "solvedAt": stamp, "result": "proof",
                "holder": {"handle": handle, "roles": [{"pr": evidence[i], "role": role, "item": item}]}}}, "")
        cache = {}
        feed = sync.collect(handle, desk.get, cache)
        accepted = {r["id"]:r for r in feed["solutions"]}
        self.assertEqual(set(accepted), {parent, problem, late})
        self.assertEqual((accepted[parent]["credit"], accepted[parent]["proof"]), ("contributor", evidence[10]))
        self.assertEqual((accepted[problem]["polarity"], accepted[problem]["credit"]), ("disproof", "solver"))
        self.assertEqual(accepted[problem]["variant_note"], direct["variantOf"])
        self.assertEqual(accepted[late]["outcome"], "warmup")
        self.assertTrue(accepted[parent]["certificate"])
        self.assertNotIn("agent", accepted[parent])
        self.assertNotIn("primary_source", accepted[parent])
        self.assertEqual(accepted[problem]["primary_source"], "https://oeis.org/A123456")
        self.assertEqual(accepted[problem]["statement"], "Does the identity hold for every n?")
        self.assertEqual((accepted[problem]["agent"], accepted[problem]["model"]), ("codex", "declared-model"))
        self.assertFalse(any("Proposed" in s for s in desk.urls))
        desk.urls.clear()
        self.assertEqual(sync.collect(handle, desk.get, cache), feed)
        self.assertFalse(any("/pulls/" in u for u in desk.urls))

    def test_reclassification_keeps_proof_without_claiming_novelty(self):
        ident = "Example"
        proof = sync.PULL + "1"
        row = dict(step=False, outcome="known", handle="me", pr_url=proof,
                   created_at="2026-11-27T00:00:00Z", polarity="proof")
        meta = dict(id=ident, kind="open", title=ident, fields=["Quantum optics"])
        result = sync.record(ident, row, {proof: ("proof", ident)}, "me", lambda url: (meta, ""))
        self.assertEqual(result["proof"], proof)
        self.assertEqual(result["outcome"], "unclassified")

    def test_cannot_promote_wrong_account_or_wrong_role(self):
        ident = "Parent"
        proof = sync.PULL + "1"
        owned = {proof: ("step", "Parent.R1.H1")}
        cert = {"certificate": {"type": "left-to-solve/contribution-certificate", "issuer": "lefttosolve.com",
                 "problem": {"id": ident}, "holder": {"handle": "other", "roles": []}}}
        get = lambda *args, **kwargs: (cert, "")
        with self.assertRaisesRegex(ValueError, "identity"):
            sync.certificate_credit(ident, "me", owned, get)
        cert["certificate"]["holder"] = {"handle": "me", "roles": [{"pr": proof, "role":"proof", "item": ident}]}
        with self.assertRaisesRegex(ValueError, "matching owned"):
            sync.certificate_credit(ident, "me", owned, get)

    def test_failed_or_incomplete_source_does_not_clear_feed(self):
        for page in ({"count": 4, "solved": [{"problem_id": "F"}]}, {"count":0, "solved":[]}):
            with self.assertRaises(ValueError):
                sync.board(lambda url: (page, ""))
        with self.assertRaisesRegex(ValueError, "continuation"):
            list(sync.pages(sync.SITE + "/api/solved", lambda url: ({"next": "https://example.org/x"}, "")))
        with tempfile.TemporaryDirectory() as tmp:
            p = Path(tmp)/"feed.json"
            initial = {"version":1,"handle":"me","solutions":[{"id":"PreviouslyAccepted"}]}
            sync.save(initial, p)
            before = p.stat().st_mtime_ns
            sync.save(initial, p)
            self.assertEqual(before, p.stat().st_mtime_ns)
            with self.assertRaisesRegex(ValueError, "lost upstream"):
                sync.save(dict(initial, solutions=[]), p)
            self.assertEqual(json.loads(p.read_text()), initial)

    def test_transient_http_error_retries(self):
        url = sync.SITE + "/api/solved"
        with patch.object(sync, "urlopen", side_effect=[
            HTTPError(url, 503, "unavailable", {}, None), HTTPError(url, 404, "absent", {}, None)
        ]) as opened, patch.object(sync.time, "sleep"):
            self.assertEqual(sync.get_json(url, missing_ok=True), (None, ""))
            self.assertEqual(opened.call_count, 2)


if __name__ == "__main__":
    unittest.main()
