"""Certify continuum regions of the optical Bloch ball at Renyi order 29/100."""
from fractions import Fraction as F
from functools import lru_cache
import json
from math import factorial
from pathlib import Path

from renyi_scan import log_gamma_one_plus, scaled, total, transcendental

ROOT = Path(__file__).resolve().parent
DEST = ROOT / "campaign/single-rail"
ORDER = F(29, 100)
MAX_SHELL = 64
STEPS_PER_ROUND = 240


@lru_cache(None)
def delta_coefficient(k, degree):
    # Integrate (1-2u) u^k / k! times the Taylor polynomial for exp(-u)
    # on [0,1/2]. Odd and even degrees give lower and upper bounds.
    return sum(F((-1)**j, factorial(k)*factorial(j)*2**(k+j+1)*(k+j+1)*(k+j+2))
               for j in range(degree+1))


@lru_cache(1024)
def negative_part(s):
    t = s/2
    K = int(t)+16
    weight = F(1)
    lower = upper = F(0)
    for k in range(K+1):
        lower += weight*delta_coefficient(k, 11)
        upper += weight*delta_coefficient(k, 12)
        weight *= t/(k+1)
    # d_k <= (1/4) 6^-k; the remaining weighted series has decreasing ratios.
    upper += weight / (4*6**(K+1)) / (1-t/(6*(K+2)))
    exp_lo, exp_hi = transcendental(-t, "exp")
    return lower*exp_lo, upper*exp_hi


@lru_cache(1024)
def raw_log(s, a):
    v = a*s
    # Poisson mean of (1+a)_k/k! is increasing with v.
    K = 2*int(v)+24
    term = subtotal = F(1)
    for k in range(1, K+1):
        term *= v*(k+a)/k**2
        subtotal += term
    first_omitted = term*v*(K+1+a)/(K+1)**2
    ratio = v*(K+2+a)/(K+2)**2
    assert ratio < 1
    upper = subtotal + first_omitted/(1-ratio)
    return transcendental(subtotal, "log")[0]-v, transcendental(upper, "log")[1]-v


@lru_cache(None)
def constant(a):
    return total(log_gamma_one_plus(a), scaled(transcendental(a, "log"), -a))


def enclose(l, h, a=ORDER):
    # Entropy minus log norm. Bound the positive and negative contributions
    # at separate endpoints, respecting stochastic monotonicity.
    raw = (raw_log(l, a)[0], raw_log(h, a)[1])
    normal = (transcendental(1+l, "log")[0], transcendental(1+h, "log")[1])
    entropy = scaled(total(constant(a), raw, scaled(normal, -a)), 1/(1-a))
    w_lo = 1 + 2*negative_part(h)[0]/(1+h)
    w_hi = 1 + 2*negative_part(l)[1]/(1+l)
    return total(entropy, scaled((transcendental(w_lo, "log")[0],
                                  transcendental(w_hi, "log")[1]), -1))


def analyze(shell, budget, state=None):
    # Dyadic [shell+i/2^d, shell+(i+1)/2^d]. Certified leaves plus the
    # pending stack partition the entire shell. A replay starts from its root.
    state = state or dict(shell=shell, order=str(ORDER), tested=0,
                          positive=[], negative=[], unresolved=[], pending=[[0, 0]])
    while state["pending"] and budget:
        depth, i = state["pending"].pop()
        l = shell + F(i, 2**depth)
        h = shell + F(i+1, 2**depth)
        lower, upper = enclose(l, h)
        if lower > 0:
            state["positive"].append([depth, i])
        elif upper < 0:
            state["negative"].append([depth, i])
        elif depth >= 22:
            state["unresolved"].append([depth, i])
        else:
            state["pending"].extend([[depth+1, 2*i+1], [depth+1, 2*i]])
        state["tested"] += 1
        budget -= 1
    return state


def replay():
    rows = json.loads((DEST / "order-029.json").read_text())
    if [row["shell"] for row in rows] != list(range(MAX_SHELL)):
        raise ValueError("Incomplete interval cover")
    for row in rows:
        rebuilt = analyze(row["shell"], row["tested"])
        if rebuilt != row or any(row[k] for k in ("negative", "unresolved", "pending")):
            raise ValueError(f"Unproved shell {row['shell']}")
    print("All 64 compact intervals certified at order 29/100.")


if __name__ == "__main__":
    replay()
