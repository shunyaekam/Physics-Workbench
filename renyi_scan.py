"""Certify number-state Renyi crossover brackets. SciPy only proposes roots and orders."""
from decimal import Decimal, localcontext
from fractions import Fraction as F
from math import comb, factorial, lgamma, log
from pathlib import Path
import json

from scipy.optimize import brentq
from scipy.special import roots_laguerre

DIRECTORY = Path(__file__).resolve().parent / "campaign/renyi"
MAX_N = 144
GRID = 2**36
ORDER_GRID = 100000


def transcendental(x, operation):
    """Enclose ln(x) or exp(x) via correctly rounded Decimal and outward neighbors."""
    x = F(x)
    with localcontext() as ctx:
        ctx.prec = 60
        value = Decimal(x.numerator) / Decimal(x.denominator)
        func = ctx.ln if operation == "log" else ctx.exp
        lo = func(value.next_minus()).next_minus()
        hi = func(value.next_plus()).next_plus()
    return F(lo), F(hi)


def scaled(pair, scale):
    left, right = (v*scale for v in pair)
    return (left, right) if scale >= 0 else (right, left)


def total(*pairs):
    return tuple(map(sum, zip(*pairs)))


def polynomial_at(coeff, x):
    """Integer Horner evaluation at a rational argument, with one final division."""
    p, q = x.numerator, x.denominator
    value, denominator = coeff[-1], 1
    for c in reversed(coeff[:-1]):
        denominator *= q
        value = value*p + c*denominator
    return F(value, denominator)


def wigner_norm(n):
    fact = factorial(n)
    coeff = [(-1)**j * comb(n, j) * (fact // factorial(j)) for j in range(n+1)]
    prim = coeff.copy()
    for j in reversed(range(n)):
        prim[j] += 2*(j+1)*prim[j+1]
    centers = [round(float(z)*GRID) for z in roots_laguerre(n)[0]]
    if len(set(centers)) != n or len(centers) != n:
        raise ArithmeticError("Require one disjoint bracket per Laguerre zero")
    last = F(0)
    values = [(F((-1)**n),)*2]
    # The primitive G has derivative -exp(-u/2)L_n(u)/2, whose absolute
    # value is at most 1/2 by the displaced-parity representation.
    for center in centers:
        left, middle, right = (F(center+i, GRID) for i in (-4, 0, 4))
        if left <= last or polynomial_at(coeff, left)*polynomial_at(coeff, right) >= 0:
            raise ArithmeticError("Uncertified root proposal")
        last = right
        p = polynomial_at(prim, middle)/fact
        a, b = scaled(transcendental(-middle/2, "exp"), p)
        values.append((a-F(2, GRID), b+F(2, GRID)))
    values.append((F(0), F(0)))
    lo = hi = F(0)
    for (a, b), (c, d) in zip(values, values[1:]):
        lo += max(F(0), a-d, c-b)
        hi += max(abs(a-d), abs(b-c))
    return lo, hi


def log_gamma_one_plus(x, shift=64):
    """Stirling after a common positive shift; the log(2*pi) terms cancel."""
    m = F(shift)
    y = x+m
    correction = -x + 1/(12*y) - 1/(12*m)
    ratio = total(scaled(transcendental(y, "log"), y+F(1, 2)),
                  scaled(transcendental(m, "log"), -m-F(1, 2)),
                  (correction-1/(360*y**3), correction+1/(360*m**3)))
    return total(ratio, *(transcendental(F(j)/(x+j), "log") for j in range(1, shift+1)))


def residual(n, order, log_norm):
    """Sign of (1-order) * (Husimi entropy excess - Wigner log norm)."""
    return total(log_gamma_one_plus(order*n),
                 scaled(transcendental(factorial(n), "log"), -order),
                 scaled(transcendental(order, "log"), -order*n),
                 scaled(log_norm, order-1))


def certificate(n):
    if not 1 <= n <= MAX_N:
        raise ValueError("photon number outside campaign")
    lo, hi = wigner_norm(n)
    log_norm = transcendental(lo, "log")[0], transcendental(hi, "log")[1]
    w = float((lo+hi)/2)
    def approximate(a):
        return lgamma(1+n*a)-a*lgamma(1+n)-a*n*log(a)-(1-a)*log(w)
    guess = int(brentq(approximate, 1e-7, 0.5)*ORDER_GRID)
    for pad in (0, 1, 2, 4, 8):
        a = F(guess-pad, ORDER_GRID)
        b = F(guess+1+pad, ORDER_GRID)
        if not 0 < a < b < F(1, 2):
            continue
        low_sign, high_sign = residual(n, a, log_norm)[1], residual(n, b, log_norm)[0]
        if low_sign < 0 < high_sign:
            # Round toward the interior of each strict sign certificate and
            # the exterior of each norm interval on a fixed decimal grid.
            scale = 10**12
            floor = lambda x: x.numerator*scale // x.denominator
            ceil = lambda x: -floor(-x)
            signs = [ceil(low_sign), floor(high_sign)]
            if not signs[0] < 0 < signs[1]:
                raise ArithmeticError("Insufficient precision for archived signs")
            return dict(n=n, order_bracket=[str(a), str(b)], norm_scale=scale,
                        norm_enclosure=[floor(lo), ceil(hi)], residual_scale=scale,
                        lower_order_residual_upper=signs[0], upper_order_residual_lower=signs[1])
    raise ArithmeticError("Crossover did not separate")


def replay():
    path = DIRECTORY / "fock-1-to-144.json"
    expected = json.loads(path.read_text())
    if len(expected) != MAX_N:
        raise ValueError("Incomplete number-state table")
    for n, row in enumerate(expected, start=1):
        if certificate(n) != row:
            raise ValueError(f"Certificate mismatch at n={n}")
    minimum = F(expected[0]["order_bracket"][0])
    if any(F(row["order_bracket"][1]) >= minimum for row in expected[1:]):
        raise ValueError("One-photon extremum failed")
    print(f"All {MAX_N} crossover intervals reproduced; single photon has largest threshold.")


if __name__ == "__main__":
    replay()
