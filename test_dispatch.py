import unittest
from ops.proof_flow import dispatch


class DispatchTests(unittest.TestCase):
    def test_launchd_entrypoint_loads(self):
        from ops import worker
        self.assertTrue(callable(worker.run))

    def test_physics_rotation_and_intake_share_slots(self):
        golay=(True,False,"b","golay43")
        older=(True,False,"a","refined-bmv")
        ready=(False,False,"z","e27-schmidt")
        self.assertEqual(dispatch([golay,older],True,None),("scout",None))
        self.assertEqual(dispatch([golay,older],True,"scout"),("rotation",older))
        self.assertEqual(dispatch([golay,older,ready],True,None),("review",ready))
        self.assertEqual(dispatch([],False,None),("idle",None))
