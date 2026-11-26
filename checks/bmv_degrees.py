"""Exact ordered-gap coefficient certificates for Hägele's dimension-three criterion.

Replay with: uv run --with python-flint==0.9.0 python checks/bmv_degrees.py
"""
import argparse
from math import comb

from flint import fmpz_mpoly_ctx


def certificate(n):
    if n < 1:
        raise ValueError("A positive number of first factors is required")
    ring = fmpz_mpoly_ctx.get(("x", "t"))
    x, t = ring.gens()
    roots = (x, x + 1, x + 1 + t)
    power = 1 if n % 3 == 0 else 3
    levels = tuple(root ** power for root in roots)

    def deficit(i, j, k):
        # Coefficients of 1 / ((1-az)(1-bz)(1-cz)), truncated after degree n.
        sums = [ring.constant(1)] + [ring.constant(0) for _ in range(n)]
        for level in (levels[i], levels[j], levels[k]):
            for degree in range(1, n + 1):
                sums[degree] += level * sums[degree - 1]
        product = roots[i] * roots[j] * roots[k]
        geometric_term = comb(n + 2, 2) * product ** (power * n // 3)
        return sums[n] - geometric_term

    a, b, mixed = deficit(0, 0, 2), deficit(1, 1, 2), deficit(0, 1, 2)
    q = deficit(1, 1, 0) * deficit(2, 2, 0) + deficit(0, 0, 1) * deficit(2, 2, 1)
    d = mixed**2 - a * b
    h = mixed * (a + b) + 2 * a * b
    coefficients = (q * h**2 - d**2 * (a + b)**2).coeffs()
    return len(coefficients), int(min(coefficients)), sum(c < 0 for c in coefficients)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--degree", type=int, help="check one first-letter count")
    args = parser.parse_args()
    degrees = [args.degree] if args.degree is not None else range(11, 37)
    for degree in degrees:
        terms, minimum, negatives = certificate(degree)
        print(f"n={degree} terms={terms} minimum={minimum} negatives={negatives}", flush=True)
        if negatives or minimum <= 0:
            raise ArithmeticError("Plain coefficient positivity does not certify this degree")
