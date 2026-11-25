"""Outward-rounded endpoint certificate for the cubic-phase optical bound.

Run: uv run --no-project --python 3.12 --with python-flint==0.8.0 checks/cubic_range.py
The accompanying proof gives the continuum reductions and Airy quadrature error.
"""
from fractions import Fraction as F

from flint import arb, ctx


K = F(3, 20)
HUSIMI_FLOOR = F(966, 1000)
WIGNER_CEILING = F(964, 1000)


def require(condition, message):
    if not condition:
        raise ArithmeticError(message)


def ball(q):
    return arb(q.numerator) / q.denominator


def husimi_floor():
    # For s outside [4/5, 5/4], g >= 41/40 by reciprocity and monotonicity.
    require(F(1, 40) > K**2 * HUSIMI_FLOOR, "outer squeezing interval")
    # g is smallest at s=1; A decreases throughout this range (s > 1/sqrt(2)).
    def a(s):
        return 36*s*s/(1+s*s)**3

    lower_bounds = []
    step = 4096
    for i in range(step):
        lo = F(4, 5) + F(9*i, 20*step)
        hi = lo + F(9, 20*step)
        nearest = min(max(F(1), lo), hi)
        g = (nearest+1/nearest)/2
        coefficient = a(hi)/4 - 21*a(lo)**2*K**2/64
        require(coefficient > 0, "sign needed to multiply by lower g")
        lower_bounds.append((g-1)/K**2 + g*coefficient)
    bound = min(lower_bounds)
    require(bound > HUSIMI_FLOOR, "inner squeezing interval")
    return bound


def wigner_estimates():
    ctx.prec = 96
    b = (1/(36*ball(K)**2)).root(3)
    require(3/b - b*b < 2, "monotonicity of the scaled negative mass")
    require(arb.airy_ai_zero(1) < -2, "first Airy zero")
    # For f(x)=Ai(-x), f^2 + f'^2/x decreases on x>0.
    ai, derivative, _, _ = arb(-2).airy()
    require(ai**2 + derivative**2/2 < 1, "Airy envelope")
    count_per_unit = 512
    h = arb(1)/count_per_unit

    def negative_upper(x):
        return max(arb(0), (-(-x).airy_ai()).upper())

    # The same mesh also supplies an obstruction to extending the reflection
    # estimate at kappa=1/5. This calculation needs a lower Wigner bound.
    stress_k = arb(1)/5
    stress_b = (1/(36*stress_k**2)).root(3)
    lower_stress = arb(0)
    prev = negative_upper(arb(2))
    total = arb(0)
    for j in range(2*count_per_unit, 16*count_per_unit):
        left = j*h
        nxt = negative_upper(left+h)
        # Interpolate Ai, then use convexity of the negative part. On this
        # interval |Ai''| <= 16. Bound the weight by its left endpoint.
        total += (-b*left).exp()*h*((prev+nxt)/2 + 2*h*h)
        # |f'| < sqrt(x) <= 4 by the energy check. A midpoint lower
        # bound stays valid across sign changes of the negative part.
        midpoint = left+h/2
        min_negative = max(arb(0), (-(-midpoint).airy_ai()-2*h).lower())
        lower_stress += (-stress_b*(left+h)).exp()*h*min_negative
        prev = nxt
    total += (-16*b).exp()/b
    upper = 2*(-b**3/3).exp()*total/ball(K)**2
    require(upper < ball(WIGNER_CEILING), "Airy endpoint ceiling")
    stress_wigner = 1+2*(-stress_b**3/3).exp()*lower_stress
    proxy_upper = (1+arb(9)/2*stress_k**2).root(4)
    require(stress_wigner > proxy_upper, "reflection obstruction at 1/5")
    return upper, stress_wigner, proxy_upper


if __name__ == "__main__":
    lower = husimi_floor()
    upper, stress_w, stress_h = wigner_estimates()
    print(f'Husimi inner-range lower coefficient > {int(lower*10**6)/10**6:.6f}')
    print(f'Enclosure of the Wigner upper estimate: {upper}')
    print(f'At 1/5 the Wigner norm exceeds {stress_w.lower()}, while '
          f'the reflection proxy is at most {stress_h.upper()}.')
    print(f'Guaranteed gap coefficient >= {HUSIMI_FLOOR-WIGNER_CEILING} '
          f'for 0 < |kappa| <= {K}.')
