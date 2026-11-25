"""Recompute the radial moment, normalization and comparison in the Wigner note."""
from collections import defaultdict
from fractions import Fraction
from math import comb, factorial

import sympy as s


def main():
    n = s.symbols("n", integer=True, nonnegative=True)
    # Apply multiplication by u four times in the orthonormal Laguerre basis.
    # Paths that cross below index zero carry a zero factor on the crossing.
    terms = {0: s.Integer(1)}
    for _ in range(4):
        result = defaultdict(int)
        for offset, weight in terms.items():
            j = n + offset
            result[offset - 1] -= j * weight
            result[offset] += (2*j + 1) * weight
            result[offset + 1] -= (j + 1) * weight
        terms = result
    moment = s.expand(terms[0])
    assert s.Poly(moment, n).all_coeffs() == [70, 140, 170, 100, 24]
    difference = s.Poly((n+2)**8 * moment - (n+1)**8 * moment.subs(n, n+2), n)
    assert all(c > 0 for c in difference.all_coeffs())
    # Independent exact integration using the explicit series for L_k, including
    # the boundary cases k=0,1. Integral of u^j exp(-u) equals j!.
    for k in range(16):
        coeffs = [Fraction((-1)**j * comb(k, j), factorial(j)) for j in range(k+1)]
        direct = sum(a*b*factorial(i+j+4) for i, a in enumerate(coeffs)
                     for j, b in enumerate(coeffs))
        assert direct == moment.subs(n, k)
        signed = sum(a*2**j*factorial(j) for j, a in enumerate(coeffs))
        assert (-1)**k * signed == 1

    assert 3**4 * 1728 > 2**8 * moment.subs(n, 1)
    assert Fraction(22, 7)**4 < 100
    assert 2**8 * 1728 > 100 * moment.subs(n, 2)
    u = s.symbols("u", positive=True)
    weight_integral = s.integrate(1 / (1 + u**4), (u, 0, s.oo))
    assert s.simplify(weight_integral - s.pi / (2*s.sqrt(2))) == 0
    coefficient = ((1+s.Rational(1,3)) * weight_integral / 4)**4 * 3
    assert s.simplify(coefficient - s.pi**4 / 1728) == 0
    one_photon = (s.integrate((1-u)*s.exp(-u/2), (u, 0, 1)) +
                  s.integrate((u-1)*s.exp(-u/2), (u, 1, s.oo))) / 2
    assert s.simplify(one_photon - (4*s.exp(-s.Rational(1,2))-1)) == 0
    print("Fourth moment:", moment)
    print("Step difference coefficients, descending:", difference.all_coeffs())
    print("Exact moment and Wigner normalization cross-checks passed for n=0..15.")
    print("Both parity bases, quartic integral, power-of-eight constant and one-photon check passed.")


if __name__ == "__main__":
    main()
