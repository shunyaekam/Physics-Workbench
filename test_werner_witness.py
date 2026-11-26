import unittest
from fractions import Fraction
from unittest.mock import patch

from checks.werner_witness import check, example
from complex_search import direct, partial_traces


class WernerWitnessTest(unittest.TestCase):
    def test_exact_boundary_and_positive_controls(self):
        for k in (4, 5):
            w = example()
            w["copies"] = k
            at_boundary = check(w)
            self.assertEqual(at_boundary["norm_squared"], 2)
            self.assertEqual(at_boundary["score"], "0")
            self.assertFalse(at_boundary["finite_copy_distillability_certified"])
            self.assertFalse(at_boundary["decisive"])

            product = {"copies": k, "terms": [[[[0, 0, -3]], [[1, 2, 0]]]]}
            checked = check(product)
            expected = Fraction(1, 2**(k-1))
            self.assertEqual(checked["norm_squared"], 36)
            self.assertEqual(Fraction(checked["score"]), expected)
            self.assertEqual(Fraction(checked["density_matrix_expectation"]), expected / Fraction(15, 2)**k)
            self.assertEqual(checked["schmidt_rank_at_most"], 1)

    def test_known_negative_control_is_a_different_state(self):
        for k in (4, 5):
            w = example()
            w["copies"] = k
            expected = -Fraction(1, 3**k)
            self.assertEqual(direct(w["terms"], 3, k, 2, 3), expected)
            self.assertEqual(partial_traces(w["terms"], 3, k, 2, 3), expected)
            self.assertEqual(check(w)["score"], "0")
            with self.assertRaises(ValueError):
                check({**w, "alpha": "2/3"})

    def test_rejects_wrong_scope_and_malformed_inputs(self):
        w = example()
        bad = [
            {**w, "d": 4}, {**w, "score": "-1"}, {**w, "copies": 4.0},
            {**w, "copies": 1}, {**w, "copies": True}, {**w, "terms": w["terms"] * 2},
            {**w, "terms": [[[[3**4, 1, 0]], [[0, 1, 0]]]]},
            {**w, "terms": [[[[0, 0, 0]], [[0, 1, 0]]]]},
            {**w, "terms": [[[[0, True, 0]], [[0, 1, 0]]]]},
            {**w, "terms": [[[[0, 1, 0]], [[0, 1, 0]]], [[[0, -1, 0]], [[0, 1, 0]]]]},
        ]
        for case in bad:
            with self.subTest(case=case), self.assertRaises(ValueError):
                check(case)

    def test_disagreement_aborts_certification(self):
        with patch("checks.werner_witness.partial_traces", return_value=Fraction(-1)):
            with self.assertRaisesRegex(ValueError, "disagree"):
                check(example())


if __name__ == "__main__":
    unittest.main()
