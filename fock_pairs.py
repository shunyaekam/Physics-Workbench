"""Prove intervals for coherent vacuum-plus-n-photon states at order one half."""
from bisect import bisect_right
from fractions import Fraction as F
from functools import lru_cache
from math import comb, factorial, isqrt
from pathlib import Path
from time import monotonic
import json

from lab import write
from renyi_scan import transcendental

ROOT = Path(__file__).resolve().parent
OUT = ROOT / "campaign/fock-pairs"
SCALE, MASS = 2**24, 2**55
STEP, STOP, ANGLES = 128, 32, 64
LIMITS = {2: 16, 3: 32, 4: 64, 5: 192}


def ceildiv(n, d):
    return -(-n//d)


def ceil(x):
    return ceildiv(x.numerator, x.denominator)


@lru_cache(None)
def cosines():
    # 333/106 < pi. On [0,pi/2] the upper Taylor polynomial through
    # degree 12 at a smaller angle bounds the true cosine from above.
    entries = []
    for k in range(ANGLES):
        angle = F(333*k, 106*2*ANGLES)
        upper = sum((-1)**j * angle**(2*j)/factorial(2*j) for j in range(7))
        entries.append(min(SCALE, ceil(SCALE*upper)))
    entries.sort()
    prefix = [0]
    for entry in entries:
        prefix.append(prefix[-1]+entry)
    return entries, prefix


@lru_cache(None)
def masses():
    exps = [transcendental(-F(i, STEP), "exp") for i in range(STEP*STOP+1)]
    return [(max(0, int(MASS*(a[0]-b[1]))), ceil(MASS*(a[1]-b[0])))
            for a, b in zip(exps, exps[1:])]


@lru_cache(None)
def radial(n):
    coeff = [F((-1)**(n+j)*comb(n,j)*2**j, factorial(j)) for j in range(n+1)]
    out = []
    dx = F(1, STEP)
    for i, (wl, wh) in enumerate(masses()):
        x = F(i, STEP)
        # Coefficients of D_n(x+t*dx) in the Bernstein basis on 0 <= t <= 1.
        power = [dx**k*sum(coeff[j]*comb(j,k)*x**(j-k) for j in range(k,n+1))
                 for k in range(n+1)]
        bern = [sum(power[k]*F(comb(j,k),comb(n,k)) for k in range(j+1)) for j in range(n+1)]
        small, large = min(bern)*SCALE, max(bern)*SCALE
        def radius(z):
            y = SCALE**2*(2*z)**n/factorial(n)
            return isqrt(y.numerator//y.denominator)
        out.append((wl, wh, small.numerator//small.denominator, ceil(large),
                    radius(x), radius(x+dx)+1))
    # At every b the unnormalized negative part is bounded by
    # (r² - D_n)_+, by completing the square in the Wigner expression.
    times_exp = [factorial(k)*sum(F(STOP**j,factorial(j)) for j in range(k+1))
                 for k in range(n+1)]
    tail = sum(abs(c)*times_exp[k] for k,c in enumerate(coeff))
    tail += F(2**n,factorial(n))*times_exp[n]
    return out, ceil(2*tail*transcendental(-STOP,"exp")[1]*MASS*SCALE)


def angular_upper(A,B,angular,sums):
    top = abs(A)
    if B <= top:
        return top
    cut = bisect_right(angular, top*SCALE//B)
    return ceildiv(cut*top*SCALE + B*(sums[-1]-sums[cut]), ANGLES*SCALE)


def positive(n, low, high):
    if not 0 <= low <= high <= LIMITS[n] or (low*SCALE).denominator != 1 or (high*SCALE).denominator != 1:
        raise ValueError("Nonrepresentable parameter interval")
    bl, bh = int(low*SCALE), int(high*SCALE)
    bl2 = bl*bl//SCALE
    angular, sums = cosines()
    cells, neg2sum = radial(n)
    gsum = 0
    for wl, wh, dmin, _, rlo, rhi in cells:
        v, u = max(bh,rlo), min(bh,rlo)
        # The three-term angular mean lower bound minus b is decreasing
        # in b and increasing in r. Retain only its nonnegative surplus.
        mean = v + u*u//(4*v) + u**4//(64*v**3) if v else 0
        gsum += wl*(mean-bh)
        A, B = bl2+dmin, ceildiv(2*bh*rhi,SCALE)
        # Twice the negative part is J(A,B)-A; it decreases in signed A.
        neg2sum += wh*(angular_upper(A,B,angular,sums)-A)
    unit = MASS*SCALE
    return 2*bl*MASS*gsum + gsum**2 > (unit+neg2sum)*unit


def tail_positive(n):
    # One comparison covers all b >= B. Restrict the positive lower moment
    # to r <= B, then bound the Wigner negative part uniformly in b.
    b = LIMITS[n]*SCALE
    cells, tail = radial(n)
    moment = 0
    twice_negative = tail*SCALE
    for wl, wh, dmin, _, rlo, rhi in cells:
        if rhi <= b:
            moment += wl*rlo**2
        twice_negative += 2*wh*max(0,rhi**2-dmin*SCALE-max(0,b-rhi)**2)
    return moment > 2*(MASS*SCALE**2+twice_negative)


def process(n, shell, count, state=None, deadline=None):
    state = state or dict(n=n,shell=shell,tested=0,positive=0,unresolved=[],pending=[[0,0]])
    while count and state["pending"] and (deadline is None or monotonic()<deadline):
        d, i = state["pending"].pop()
        if positive(n,shell+F(i,2**d),shell+F(i+1,2**d)):
            state["positive"] += 1
        elif d>=18:
            state["unresolved"].append([d,i])
        else:
            state["pending"].extend([[d+1,2*i+1],[d+1,2*i]])
        state["tested"] += 1
        count -= 1
    return state


def replay():
    rows = json.loads((OUT / "vacuum-families.json").read_text())
    if [row["n"] for row in rows] != list(LIMITS):
        raise ValueError("Missing vacuum family")
    for row in rows:
        n = row["n"]
        if not tail_positive(n) or len(row["positive_leaves_by_shell"]) != LIMITS[n]:
            raise ValueError("Missing parameter range")
        for shell, leaves in enumerate(row["positive_leaves_by_shell"]):
            state = process(n, shell, 2*leaves-1)
            if state["positive"] != leaves or state["unresolved"] or state["pending"]:
                raise ValueError(f"Vacuum-pair certificate failed for {n}, {shell}")
    print("Reproduced all four vacuum families including their unbounded tails.")


if __name__ == "__main__":
    replay()
