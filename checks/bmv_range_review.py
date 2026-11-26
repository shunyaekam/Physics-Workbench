"""Independent exact coefficient review of Hägele's three-B test in dimension three.

Run from the repository root with:
    uv run --with python-flint==0.9.0 python checks/bmv_range_review.py
"""
import argparse
from hashlib import sha256
from itertools import combinations_with_replacement
from math import comb

from flint import fmpz_mpoly_ctx


def exact_division(top, bottom):
    quotient, remainder = divmod(top, bottom)
    if remainder:
        raise ArithmeticError("A divided difference failed exact divisibility")
    return quotient


def composition_deficit(n, e, roots, triple):
    """Second divided difference of z^(n+2), including confluent arguments."""
    i, j, k = sorted(triple)
    a, b, c = (roots[v] ** e for v in (i, j, k))

    def first(x, y):
        if x == y:
            return (n + 2) * x ** (n + 1)
        return exact_division(x ** (n + 2) - y ** (n + 2), x - y)

    # The triples used below always contain at least two distinct polynomials.
    h = exact_division(first(a, b) - first(b, c), a - c)
    balanced = (roots[i] * roots[j] * roots[k]) ** (e * n // 3)
    return h - comb(n + 2, 2) * balanced


def scalar_test(n, e, gaps):
    """Literal composition sum and original squared expression at one point."""
    first_gap, second_gap = gaps
    roots = (1, 1 + first_gap, 1 + first_gap + second_gap)

    def f(i, j, k):
        a, b, c = (roots[v] ** e for v in (i, j, k))
        homogeneous = sum(a**s * b**t * c**(n - s - t)
                          for s in range(n + 1) for t in range(n + 1 - s))
        return homogeneous - comb(n + 2, 2) * (roots[i]*roots[j]*roots[k])**(e*n//3)

    x, y, z = f(0, 0, 2), f(1, 1, 2), f(0, 1, 2)
    q = f(1, 1, 0)*f(2, 2, 0) + f(0, 0, 1)*f(2, 2, 1)
    return q * (z*(x+y) + 2*x*y)**2 - (z*z-x*y)**2 * (x+y)**2


def review(n):
    if n < 1:
        raise ValueError("Expected positive n")
    e = 1 if n % 3 == 0 else 3
    degree = 6 * e * n
    context = fmpz_mpoly_ctx.get(("first_gap", "second_gap"))
    first_gap, second_gap = context.gens()
    one = context.constant(1)
    # Dehomogenize by setting the *base* root to one. The original program
    # instead fixes the first gap, leaving the base and second gap as variables.
    roots = (one, one + first_gap, one + first_gap + second_gap)
    terms = {triple: composition_deficit(n, e, roots, triple)
             for triple in combinations_with_replacement(range(3), 3)
             if triple[0] != triple[2]}
    x, y, z = terms[0, 0, 2], terms[1, 1, 2], terms[0, 1, 2]
    q = terms[0, 1, 1]*terms[0, 2, 2] + terms[0, 0, 1]*terms[1, 2, 2]
    r, s = x*y, x+y
    # Expanded grouping independent of the direct difference of squares.
    certificate = (q*z*z - (z*z - r)**2)*s*s + 4*q*r*(z*s + r)
    for u, v in ((0, 2), (3, 0), (-2, 3), (1, 2)):
        if certificate(u, v) != scalar_test(n, e, (u, v)):
            raise ArithmeticError(f"Scalar transcription test failed at {(u, v)}")
    # Restore the missing base exponent by homogeneity, and sort by the
    # original program's dehomogenized exponents (base, second gap).
    coefficients = sorted((degree-int(i)-int(j), int(j), int(c))
                          for (i, j), c in certificate.terms())
    if not coefficients or any(a < 0 or c <= 0 for a, _, c in coefficients):
        raise ArithmeticError(f"Invalid coefficient certificate for n={n}")
    digest = sha256()
    for a, j, c in coefficients:
        digest.update(f"{a} {j} {c}\n".encode("ascii"))
    return len(coefficients), min(c for _, _, c in coefficients), digest.hexdigest()


if __name__ == "__main__":
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("degrees", type=int, nargs="*", default=list(range(11, 37)))
    for degree in cli.parse_args().degrees:
        count, minimum, digest = review(degree)
        print(f"{degree} {count} {minimum} {digest}", flush=True)
