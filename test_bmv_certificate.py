from decimal import Decimal as D, localcontext
from fractions import Fraction as F
import unittest
from unittest.mock import patch

from checks import bmv_certificate as bmv


def witness():
    return {"H":[[3,0],[0,-3]], "K":[[0,4],[4,0]], "den":8, "n":2, "m":2}


class BmvCertificateTest(unittest.TestCase):
    def test_exact_zero_and_nonzero_commuting(self):
        w = witness()
        zero = [[0,0],[0,0]]
        exact = bmv.check(dict(w,H=zero,K=zero))
        self.assertEqual((F(exact["gap_lower"]),F(exact["gap_upper"])), (0,0))
        self.assertFalse(exact["decisive"])
        commuting = bmv.check(dict(w,H=[[1,1],[1,0]],K=[[2,2],[2,0]],n=3))
        self.assertLessEqual(F(commuting["gap_lower"]),0)
        self.assertGreaterEqual(F(commuting["gap_upper"]),0)
        self.assertFalse(commuting["decisive"])

    def test_independent_analytic_word_average(self):
        # H=x Z, K=y X. Four words have cyclic representative AABB,
        # two have representative ABAB; det(AB)=1 gives the latter trace.
        with localcontext() as ctx:
            ctx.prec = 120
            def cosh(x):
                return (x.exp()+(-x).exp())/2
            x,y = D(3)/8, D(4)/8
            clustered = 2*cosh(2*x)*cosh(2*y)
            alternating = (2*cosh(x)*cosh(y))**2-2
            gap = (4*clustered+2*alternating)/6-2*cosh(D(10)/8)
        test = witness()
        h,k = ([[F(v,8) for v in row] for row in test[key]] for key in ("H","K"))
        primary = bmv.check(test)
        bounds = [(F(primary["gap_lower"]), F(primary["gap_upper"])), bmv.enclosure(h,k,2,2,direct=True)]
        for lo,hi in bounds:
            self.assertGreater(lo,0)
            self.assertLess(lo,F(gap))
            self.assertGreater(hi,F(gap))
        self.assertFalse(primary["decisive"])

    def test_corrupted_fast_word_sum_fails_release(self):
        with patch.object(bmv,"word_sum",return_value=-10**12):
            with self.assertRaises(ArithmeticError):
                bmv.check(witness())

    def test_reject_invalid_hypotheses_and_search_bounds(self):
        w = witness()
        for changes in ({"den":0},{"den":True},{"m":1.0},{"n":8,"m":8},
                        {"H":[[0,2],[1,0]]},{"K":[[True,0],[0,1]]},{"H":[[1],[0,2]]},
                        {"H":[[1,0,0],[0,1,0],[0,0,1]]},{"K":[[8,0],[0,4]],"den":1},
                        {"H":[[17,0],[0,-1]]},{"decisive":True}):
            with self.subTest(changes=changes), self.assertRaises(ValueError):
                bmv.check(dict(w,**changes))
