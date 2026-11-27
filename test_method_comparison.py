import unittest

from ops.method_report import cost, render
from ops.method_trial import improves, SEEDS_PER_SPLIT


class MethodsTests(unittest.TestCase):
    def test_improvement_requires_effect_size_and_keeps_best(self):
        before = [48] * SEEDS_PER_SPLIT
        self.assertTrue(improves(before, [47] * SEEDS_PER_SPLIT))
        self.assertFalse(improves(before, [47] + before[1:]))
        self.assertFalse(improves([43] + [52] * (SEEDS_PER_SPLIT-1), [47] * SEEDS_PER_SPLIT))
        with self.assertRaises(ValueError):
            improves([], [])

    def test_partial_usage_and_cached_input(self):
        base = dict(model="hosted", elapsed_seconds=3, usage_complete=True,
                    usage=dict(input_tokens=50, cached_input_tokens=40, output_tokens=5))
        self.assertEqual(cost([base, {**base, "usage_complete": False}, {"model":None,"elapsed_seconds":1}]),
                         ("7.0","50 / 5","1/2"))

    def test_certificates_predating_meter_are_unmeasured(self):
        self.assertIn("Unmeasured", render([], {"old":(1000,"https://example.org")}, []))
