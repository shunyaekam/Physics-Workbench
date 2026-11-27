import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from ops import lean_loop, proof_portfolio


class ProofLoopTests(unittest.TestCase):
    def test_bad_axiom_and_unsolved_goal_fail(self):
        name = "OMA.solution"
        self.assertFalse(lean_loop.clean_axioms(f"'{name}' depends on axioms: [propext, sorryAx]",name))
        good = f"'{name}' depends on axioms: [propext, Classical.choice, Quot.sound]"
        self.assertTrue(lean_loop.clean_axioms(good,name))
        self.assertFalse(lean_loop.clean_axioms("F.lean:1:3: error: unsolved goals\n"+good,name))
        self.assertFalse(lean_loop.clean_axioms(good,"Helper"))

    def test_checkpoint_is_bounded_contained_source(self):
        with tempfile.TemporaryDirectory() as tmp:
            root=Path(tmp)
            p=root/"Candidate.lean"
            original=b"start"
            out=root/"private"/"resume.lean"
            p.write_bytes(original)
            self.assertFalse(lean_loop.save_progress(p,original,out))
            p.write_text("new proof")
            self.assertTrue(lean_loop.save_progress(p,original,out))
            p.unlink()
            p.symlink_to(out)
            self.assertFalse(lean_loop.save_progress(p,original,out))
            p.unlink()
            os.link(out,p)
            self.assertFalse(lean_loop.save_progress(p,original,out))
            self.assertEqual(out.read_text(),"new proof")

    def test_dispatch_prefers_checked_success_per_second(self):
        rows=[dict(method="A",status="checked",seconds=3),dict(method="B",status="miss",seconds=3)]
        self.assertGreater(proof_portfolio.priority("A",rows), proof_portfolio.priority("B",rows))
        rows[0]["seconds"]=120
        self.assertLess(proof_portfolio.priority("A",rows), proof_portfolio.priority("B",rows))

    def test_receipt_reuse_is_bound_to_method_and_goal(self):
        name="simplify"
        first=proof_portfolio.signature("test",name)
        self.assertNotEqual(first,proof_portfolio.signature("other",name))
        with patch.dict(proof_portfolio.TACTICS,{name:"rfl"}):
            self.assertNotEqual(first,proof_portfolio.signature("test",name))
