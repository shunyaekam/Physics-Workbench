import unittest
from fractions import Fraction
from itertools import product
from unittest.mock import patch

from checks import schmidt_orbit as orbit


class OrbitTest(unittest.TestCase):
    def test_pauli_moments(self):
        a = [7, 6, 5, 4, 3, 2, 1, 0]
        self.assertEqual(orbit.check(dict(sorted=a, permuted=a))["sorted_purity"], "134539/214375")
        for b in ([1,0,0,0], [1]*16):
            result = orbit.check(dict(sorted=b, permuted=b))
            self.assertEqual(result["alternative_purity"], "1")
            self.assertFalse(result["decisive"])

    def test_strict_direction_and_input_validation(self):
        a = [4,3,2,1,1,0,0,0]
        b = [4,3,2,0,1,1,0,0]
        result = orbit.check(dict(sorted=a, permuted=b))
        self.assertFalse(result["decisive"])
        self.assertLess(Fraction(result["alternative_purity"]), Fraction(result["sorted_purity"]))
        for bad in ([True]+a[1:], [-4]+a[1:], a[:-1], a[::-1], [0]*8):
            with self.assertRaises(ValueError):
                orbit.check(dict(sorted=bad, permuted=b))
        for mutation in (dict(sorted=a, permuted=a, decisive=True),dict(sorted=a,permuted=b[:-1]+[1])):
            with self.assertRaises(ValueError):
                orbit.check(mutation)
        with patch.object(orbit,"fourth_sum", return_value=0), self.assertRaises(ArithmeticError):
            orbit.check(dict(sorted=a,permuted=b))

    def test_rational_rotation(self):
        a = [1,0,0,0]
        w = dict(sorted=a,left=[0,1,3,4,5],right=[2,3,3,4,5])
        result = orbit.check(w)
        # State is (3|0>+4|1>)/5 with the other three qubits in |0>.
        expected = (1 + Fraction(24,25)**4 + Fraction(-7,25)**4) / 2
        self.assertEqual(Fraction(result["alternative_purity"]), expected)
        for plane in ([0,1,4,4,5], [0,4,3,4,5], [1,1,3,4,5], [0,1,0,0,0], [0,1,True,0,1]):
            with self.assertRaises(ValueError):
                orbit.check(dict(w,right=plane))
        with patch.object(orbit,"cube_sum",return_value=10**40), self.assertRaises(ArithmeticError):
            orbit.check(w)

    def test_compression_coefficients(self):
        for mask in range(256):
            signs = []
            for shift, linear in product(range(2), range(8)):
                parity = sum(shift + bin(v & linear).count("1") for v in range(8) if mask >> v & 1)
                signs.append((-1)**parity)
            self.assertIn(sum(signs), (0,16))

    def test_seeded_replay(self):
        for run in (orbit.search, orbit.search_rotations):
            result = run(20261125,8)
            self.assertEqual(result["result"], orbit.check(result["witness"]))
            self.assertEqual(result, run(20261125,8))
            self.assertEqual(result["tested"],8)
