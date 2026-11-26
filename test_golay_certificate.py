from unittest import TestCase
from unittest.mock import patch

from checks.golay_certificate import check, example


class GolayCertificateTest(TestCase):
    def test_published_control_and_local_identities(self):
        gates = example()["gates"]
        fixed = check({"gates": gates})
        self.assertEqual(fixed, {"qubits": 23, "cnot_count": 44, "positive_target_generators": 23,
                                 "target_prepared": True, "decisive": False})
        # X Y Z is identity up to global phase.
        identity = [["H", 2], ["H", 2], ["S", 3], ["SDG", 3], ["X", 1], ["Y", 1], ["Z", 1]]
        self.assertEqual(check({"gates": gates + identity}), fixed)
        self.assertEqual(check({"gates": identity + gates}), fixed)

    def test_logical_one_has_the_same_unsigned_stabilizers(self):
        # Transversal X maps cyclic logical zero to logical one. Every
        # weight-seven Z generator now has eigenvalue -1.
        data = check({"gates": example()["gates"] + [["X", i] for i in range(23)]})
        self.assertEqual(data["positive_target_generators"], 11)
        self.assertFalse(data["target_prepared"])
        self.assertFalse(data["decisive"])

    def test_low_cost_does_not_establish_the_target(self):
        empty = check({"gates": []})
        self.assertEqual(empty["positive_target_generators"], 12)
        self.assertFalse(empty["decisive"])
        gates = example()["gates"]
        del gates[next(i for i, g in enumerate(gates) if g[0] == "CX")]
        one_short = check({"gates": gates})
        self.assertEqual(one_short["cnot_count"], 43)
        self.assertFalse(one_short["target_prepared"])
        self.assertFalse(one_short["decisive"])

    def test_reject_ancillas_measurements_and_spoofing(self):
        for bad in ({"gates": [], "cnot_count": 0}, {"gates": [["M", 0]]},
                    {"gates": [["CX", 1, 23]]}, {"gates": [["CX", 1, 1]]},
                    {"gates": [["H", True]]}, {"gates": [["Y", -1]]},
                    {"gates": [["S", 1, 2]]}, {"gates": [["CX", 1]]}):
            with self.subTest(bad=bad), self.assertRaises(ValueError):
                check(bad)

    def test_independent_replay_cannot_be_skipped(self):
        with patch("checks.golay_certificate.backward_checks", return_value=[True] * 23):
            with self.assertRaisesRegex(ValueError, "disagree"):
                check({"gates": []})
