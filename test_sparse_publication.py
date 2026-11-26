import hashlib
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import refresh_sparse_note as note


class SparsePublicationTests(unittest.TestCase):
    def test_timed_replay_resumes_without_replacing_published_evidence(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name in ("fock_pairs.py", "excited_pairs.py", "renyi_scan.py", "refresh_sparse_note.py"):
                (root / name).write_text(name)
            table = root / "table.tex"
            table.write_text(
                "\\paragraph{Replayed excited-level subspaces.}\n"
                "The current working paper includes 3 fully covered excited-level pairs.\n"
                "Each row gives the larger photon count and all certified smaller counts.\n"
                "\\begin{center}\\begin{tabular}{rl}Larger count & Smaller counts\\\\\\hline\n"
                "2 & 1 \\\\\n3 & 1--2 \\\\\n\\end{tabular}\\end{center}\n")
            def receipt(m,n,tested):
                return dict(m=m,n=n,tested=tested,pending=[],unresolved=[])
            entries = {}
            for m,n in [(1,2),(1,3),(2,3)]:
                data = []
                for a,b in [(m,n),(n,m)]:
                    content = json.dumps(receipt(a,b,7)).encode()
                    (root / f"levels-{a:02}-{b:02}.json").write_bytes(content)
                    data.append(content)
                entries[f"{m},{n}"] = hashlib.sha256(b"".join(data)).hexdigest()
            ledger = root / "published.json"
            original = json.dumps(dict(checker="older revision",pairs=entries))
            ledger.write_text(original)
            with patch.multiple(note,ROOT=root,LEDGER=ledger,TABLE=table), patch.multiple(
                    note.pairs,BOUND=3,LIVE=root), patch.object(note.pairs,"process",side_effect=receipt) as replay:
                with patch.object(note,"monotonic",side_effect=[0,0,2,2]):
                    note.refresh(seconds=1)
                self.assertEqual(ledger.read_text(),original)
                self.assertEqual(replay.call_count,2)
                replay.reset_mock()
                note.refresh(seconds=10)
                self.assertEqual(replay.call_count,4)
                self.assertEqual(json.loads(ledger.read_text())["pairs"],entries)
                self.assertFalse((root / ".runtime/sparse-paper-replay.json").exists())
