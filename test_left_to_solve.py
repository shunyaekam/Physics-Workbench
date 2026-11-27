"""The hourly contributor may submit a prepared proof only for its reviewed statement."""
import hashlib
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest
from unittest.mock import patch
from ops import left_to_solve as lts


class FollowUp(unittest.TestCase):
    def setUp(self):
        folder = TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        self.root = Path(folder.name)
        self.name = "oeis-a293452"
        self.row = {"problem": self.name, "submission": 1071, "issue": "https://example.org/lab",
                    "statement_sha256": hashlib.sha256(b"reviewed statement").hexdigest()}
        (self.root / (self.name + ".lean")).write_text("prepared proof")
        self.stored = b"reviewed statement"
        self.pulls = []
        self.merged = True
        self.mutations = []
        self.requests = []
        for key, value in (("QUEUE", self.root), ("github", self.github), ("desk", self.desk)):
            ctx = patch.object(lts, key, value)
            ctx.start()
            self.addCleanup(ctx.stop)
        ctx = patch.object(lts.time, "sleep")
        ctx.start()
        self.addCleanup(ctx.stop)

    def github(self, path, payload=None, raw=False):
        if payload is not None:
            self.mutations.append((path, payload))
            if path.endswith("/pulls"):
                self.pulls.append({"html_url": "https://example.org/pull/1"})
                return self.pulls[0]
            return {"sha": "created"}
        if path.endswith("/pulls/1071"):
            return {"merged_at": "now" if self.merged else None, "state": "open"}
        if "/pulls?" in path:
            return self.pulls
        if path.endswith("/git/ref/heads/main"):
            return {"object": {"sha": "base"}}
        if "/contents/statements/" in path:
            return self.stored
        if path == "user":
            return {"login": "shunyaekam"}
        if "/git/matching-refs/" in path:
            return []
        if "/git/commits/" in path:
            return {"tree": {"sha": "tree"}}
        self.fail(path)

    def desk(self, path, params=None, post=False):
        self.requests.append(path)
        if path.startswith("/api/problems/"):
            return {"solution": None, "kind": "open", "decl": "OMA.S_oeis_a293452.main"}
        if path.endswith("/next"):
            return {"lease": "test", "problem": {"id": self.name}, "file": "proofs/"+self.name+".lean"}
        if path.endswith("/release"):
            return {}
        self.fail(path)

    def test_unmerged_or_changed_statement_is_never_submitted(self):
        self.merged = False
        lts.submit(self.row)
        self.assertEqual(self.requests, [])
        self.merged = True
        self.stored = b"changed target"
        lts.submit(self.row)
        self.assertNotIn("/api/desk/next", self.requests)
        self.assertEqual(self.mutations, [])

    def test_retry_after_success_does_not_duplicate_lease_or_proof(self):
        lts.submit(self.row)
        lts.submit(self.row)
        self.assertEqual(len(self.pulls), 1)
        self.assertEqual(self.requests.count("/api/desk/next"), 1)
        self.assertEqual(self.requests.count("/api/desk/release"), 1)
        self.assertTrue(self.pulls[0]["html_url"])
