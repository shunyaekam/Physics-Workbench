from datetime import datetime, timezone
import unittest

from ops.lts_standings import candidates, rank_candidates, recent, standings
from ops.proof_flow import dispatch


class ScoringTests(unittest.TestCase):
    def test_official_order_includes_tied_and_case_variant_handles(self):
        names = ["Guest", "guest"] + [f"u{i}" for i in range(3,21)] + ["shunyaekam"]
        html = "".join("<tr>"+ "".join(f"<td>{x}</td>" for x in
            (i,"@"+name,"model",300-i if i<20 else 231,1,2))+"</tr>" for i,name in enumerate(names,1))
        data = standings(html)
        self.assertEqual((data["owner"]["rank"],data["cutoff"]["points"],data["points_to_pass"]), (21,231,1))
        self.assertIsNone(standings(html, "absent")["points_to_pass"])

    def test_screen_scored_steps_separately_and_respect_active_work(self):
        base = dict(id="x",kind="open",points=48,statement="A",steps=[
            dict(id="x.R1.H1", points=24, k=1, statement="B", solved=False)])
        item = dict(title="physics",difficulty=48)
        self.assertEqual([r["id"] for r in candidates(item,base,{},set(),["Prove x.R1.H1"])],["x"])
        self.assertEqual([r["id"] for r in candidates(item,base,{"x":1},set(),[])],["x.R1.H1"])
        self.assertEqual(candidates(item,base,{},{"x"},[]),[])
        self.assertEqual(candidates(item,{**base,"kind":"unformalized","steps":[]},{},set(),[]),[])
        ordered = rank_candidates(candidates(item,base,{},set(),[]))
        self.assertEqual(ordered[0]["kind"],"step")
        self.assertFalse(recent(dict(checked_at="2025-01-01T01:00:00+00:00"),
                               datetime(2026,1,1,tzinfo=timezone.utc),2))

    def test_decisive_reviews_still_win(self):
        focus = (True,False,"b","golay43")
        positive = (False,False,"z","other")
        self.assertEqual(dispatch([focus],True,"focus",scored=True),("board_first",None))
        self.assertEqual(dispatch([focus],True,"board_first",scored=True),("board_second",None))
        self.assertEqual(dispatch([focus],True,"board_second",scored=True),("rotation",focus))
        self.assertEqual(dispatch([],True,"board_second",scored=True),("board_first",None))
        self.assertEqual(dispatch([focus,positive],True,"focus",scored=True),("review",positive))

    def test_resume_same_scored_statement_once(self):
        from pathlib import Path
        from tempfile import TemporaryDirectory
        from lab import write
        from ops.scout import pending

        with TemporaryDirectory() as directory:
            root = Path(directory)
            for name in ("discovery", "campaign/left-to-solve", "campaign/scouting"):
                (root/name).mkdir(parents=True)
            write(root/"discovery/targets.json", [])
            row = dict(id="x", statement="claim one", title="Lattice", kind="step",
                       points=7, difficulty=5, source="https://example.org/paper")
            queue = root/"campaign/left-to-solve/proof-queue.json"
            stamp = datetime.now(timezone.utc).isoformat()
            write(queue, dict(checked_at=stamp, targets=[row]))
            _, first = pending(root)
            review = dict(verdict="shortlist", proof_or_witness="reduction",
                          remaining_obligation="prove the finite cylinder identity",
                          primary_sources='["https://example.org/paper"]')
            write(first, dict(review=review))
            lead, second = pending(root)
            self.assertNotEqual(first, second)
            self.assertEqual(lead["prior_attempt"]["remaining_obligation"], review["remaining_obligation"])
            write(second, dict(review=review))
            self.assertIsNone(pending(root))
            write(queue, dict(checked_at=stamp, targets=[dict(row, statement="changed")]))
            self.assertNotIn("prior_attempt", pending(root)[0])
