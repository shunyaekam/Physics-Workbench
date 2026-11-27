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
        self.assertEqual(dispatch([focus],True,"focus",scored=True),("scout",None))
        self.assertEqual(dispatch([focus],True,"scout",scored=True),("focus",focus))
        self.assertEqual(dispatch([focus,positive],True,"focus",scored=True),("review",positive))
