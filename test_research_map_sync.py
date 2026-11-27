import json
from pathlib import Path
import unittest

from ops.build_research_map import merge_entries, update_map


class ResearchMapSyncTests(unittest.TestCase):
    def setUp(self):
        self.root = Path(__file__).resolve().parent
        self.curated = json.loads((self.root/"site/left-to-solve/entries.json").read_text())
        self.proof = dict(id="sample-result", title="A & B", field="Quantum optics",
                          source="https://lefttosolve.com/p/sample-result",
                          proof="https://github.com/GuillaumeBAUD-coder/open-math-agents/pull/1",
                          credit="contributor", outcome="known", polarity="proof", accepted_at="2026-11-27")

    def test_new_and_existing_receipts_share_the_regular_map(self):
        existing = dict(self.proof, id=self.curated[0]["id"])
        rows = merge_entries(self.curated, [existing,self.proof])
        self.assertEqual(len(rows),len(self.curated)+1)
        self.assertEqual(rows[0]["slug"],self.curated[0]["slug"])
        self.assertEqual(rows[0]["accepted"],existing)
        page = update_map((self.root/"catalogue.html").read_text(),rows)
        self.assertEqual(update_map(page,rows),page)
        self.assertIn('href="papers/'+rows[-1]["slug"]+'/"',page)
        self.assertIn("A &amp; B",page)
        for row in rows:
            self.assertEqual(page.count('class="paper" id="'+row["slug"]+'"'),1)
            self.assertEqual(page.count('data-paper="'+row["slug"]+'"'),1)
