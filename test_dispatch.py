import unittest
from ops.proof_flow import dispatch


class DispatchTests(unittest.TestCase):
    def test_launchd_entrypoint_loads(self):
        from ops import worker
        self.assertTrue(callable(worker.run))

    def test_focus_shares_slots_and_yields_to_a_decisive_witness(self):
        focus=(True,False,"b","golay43")
        other=(True,False,"a","refined-bmv")
        ready=(False,False,"z","e27-schmidt")
        self.assertEqual(dispatch([focus,other],True,None),("focus",focus))
        self.assertEqual(dispatch([focus,other],True,"focus"),("scout",None))
        self.assertEqual(dispatch([focus,other],False,"focus"),("rotation",other))
        self.assertEqual(dispatch([focus,other,ready],True,None),("review",ready))
        self.assertEqual(dispatch([other],False,None),("rotation",other))
        self.assertEqual(dispatch([],False,None),("idle",None))
