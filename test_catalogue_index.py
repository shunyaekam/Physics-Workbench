"""Regression checks for reused IDs and scope in the source index."""
from collections import Counter
import json
from pathlib import Path
import tempfile
import unittest

from ops.catalogue_index import ROOT, aim, quantum


class CatalogueIndexTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data = json.loads((ROOT / "campaign/catalogue-index/catalogues.json").read_text())
        cls.rows = cls.data["rows"]

    def test_distinct_rows_and_per_source_accounting(self):
        self.assertEqual(len(self.rows), len({row["id"] for row in self.rows}))
        by_source = Counter(row["source"] for row in self.rows)
        self.assertEqual(by_source, {s["name"]: s["count"] for s in self.data["sources"]})
        for source in self.data["sources"]:
            matching = [r for r in self.rows if r["source"] == source["name"]]
            self.assertEqual(Counter(r["kind"] for r in matching), source["kinds"])
            self.assertRegex(source["revision"], r"^[0-9a-f]{40}$")
            self.assertTrue(all(r["title"] and r["url"].startswith("https://") for r in matching))

    def test_aim_reused_slots_do_not_merge_archived_topics(self):
        with tempfile.TemporaryDirectory() as tmp:
            repo = Path(tmp)
            manifest = dict(groups=[dict(key="g", title="Mathematical relativity")],
                            batches=[dict(ids=["045"])], retired=[], editorial_archive=[], further_archive=[],
                            cut=[dict(id="045", title="Older question", record="cut/045.md", status="Solved")])
            (repo / "data").mkdir()
            (repo / "data/g.json").write_text(json.dumps([dict(id="045", title="Current question",
                area="Example", file="problems/045.md", status="Open")]))
            (repo / "catalogue.json").write_text(json.dumps(manifest, indent=2))
            (repo / "CATALOG.md").write_text("| 045 | Current question |")
            rows = aim(repo, "a" * 40)
        self.assertEqual({row["source_id"] for row in rows}, {"045"})
        self.assertEqual(len({row["id"] for row in rows}), 2)
        self.assertEqual({row["kind"] for row in rows}, {"catalogue", "archive"})

    def test_cross_reference_status_does_not_override_own_status(self):
        with tempfile.TemporaryDirectory() as tmp:
            repo = Path(tmp)
            files = repo / "app/data"
            files.mkdir(parents=True)
            (repo / "README.md").write_text("**1 active entries**")
            (files / "problems.js").write_text('import { X } from "./cat-test";\n'
                '{ slug: "test", code: "T", name: "Example category" }')
            (files / "cat-test.js").write_text('  { id: "T1", cat: "test", horizon: "sharp",\n'
                '    title: "Test question",\n    catalogues: [{ status: "solved" }], }')
            rows = quantum(repo, "a" * 40)
        self.assertEqual([(row["id"], row["status"]) for row in rows], [("oqp:T1", "open")])
