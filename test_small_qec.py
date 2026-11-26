"""Guard the rank, distance, parameter binding and universal-bound halves of publication."""
import copy
import json
from pathlib import Path
import unittest
from unittest.mock import patch

from checks.small_qec import dual
from ops.witness import replay

CASES = Path(__file__).resolve().parent / "checks" / "small_qec"


class QuantumCodeCertificateTest(unittest.TestCase):
    def test_fixed_contracts(self):
        for pid, filename, expected, logicals in (
                ("wei-12-4-4","twelve-four.json",7,225),
                ("wei-12-3-4","twelve-three.json",6,105)):
            with self.subTest(pid=pid):
                data=json.loads((CASES/filename).read_text())
                result=replay(pid,data)
                self.assertEqual(result["optimal_check_weight"],expected)
                self.assertEqual(result["logicals_by_weight"],[0,0,0,logicals])
                invalid=copy.deepcopy(data)
                invalid["generators"][-1]=invalid["generators"][0]
                with self.assertRaises(ValueError):
                    replay(pid,invalid)

    def test_changed_dual_is_rejected(self):
        altered=copy.deepcopy(dual.FOUR_LOGICAL)
        altered[0][2]["H1"]="1/512"
        with patch.object(dual,"FOUR_LOGICAL",altered), self.assertRaises(ValueError):
            dual.upper_bounds(4)
