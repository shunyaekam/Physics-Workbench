"""Certify the order-one-half bound on each two-excited-level optical subspace."""
from datetime import datetime
from fractions import Fraction as F
from functools import lru_cache
from math import comb, factorial, isqrt
from time import monotonic
import json

from fock_pairs import (OUT, SCALE, MASS, STEP, STOP, angular_upper, ceil,
                        ceildiv, cosines, radial)
from lab import write
from renyi_scan import transcendental

BOUND = 16
LIVE = OUT / "excited"


@lru_cache(2)
def pair_data(m, n):
    a, b = sorted((m,n))
    k = b-a
    coeff = [F((-2)**j * comb(b,a-j),factorial(j)) for j in range(a+1)]
    cells = []
    left, _ = radial(m)
    right, _ = radial(n)
    for i, (first, second) in enumerate(zip(left,right)):
        x, y = F(i,STEP), F(i+1,STEP)
        # An interval enclosure for L_a^k(2x), expanded at the cell's left edge.
        co = [sum(coeff[j]*comb(j,h)*x**(j-h) for j in range(h,a+1))/STEP**h
              for h in range(a+1)]
        pol = max(abs(co[0]+sum(min(0,c) for c in co[1:])),
                  abs(co[0]+sum(max(0,c) for c in co[1:])))
        sq = F(factorial(a),factorial(b))*(2*y)**k*pol**2*SCALE**2
        cross = isqrt(sq.numerator//sq.denominator)+1
        cells.append((first[0],first[1],*first[2:5],*second[2:5],cross))
    # Bound the signed Wigner polynomials by absolute monomial sums in the tail.
    # 2^k x^k has no fractional powers after bounding sqrt(y) <= (1+y)/2.
    def moment(j):
        return factorial(j)*sum(F(STOP**h,factorial(h)) for h in range(j+1))
    total = sum(sum(F(comb(level,j)*2**j,factorial(j))*moment(j) for j in range(level+1))
                for level in (m,n))
    total += sum(abs(c)*(moment(j)+F(factorial(a),factorial(b))*2**k*moment(j+k))
                 for j,c in enumerate(coeff))
    return cells, ceil(total*transcendental(-STOP,'exp')[1]*MASS*SCALE)


def positive(m,n,lo,hi):
    # Coefficient of |m> is t, coefficient of |n> is one, 0 <= t <= 1.
    assert 0 <= lo <= hi <= 1 and (lo*SCALE).denominator == (hi*SCALE).denominator == 1
    t0,t1 = int(lo*SCALE),int(hi*SCALE)
    c,sums = cosines()
    cells,wnorm = pair_data(m,n)
    mean = 0
    for wl,wh,d0,d1,r0,e0,e1,r1,cross in cells:
        lower = min(t0*t0*d0,t1*t1*d0)//SCALE**2 + e0
        upper = ceildiv(max(t0*t0*d1,t1*t1*d1),SCALE**2) + e1
        wnorm += wh*angular_upper(max(abs(lower),abs(upper)),ceildiv(2*t1*cross,SCALE),c,sums)
        small,large = sorted((t0*r0//SCALE,r1))
        if large:
            mean += wl*(large + small**2//(4*large) + small**4//(64*large**3))
    return mean**2 > wnorm*MASS*SCALE


def process(m,n,budget,state=None,deadline=None):
    state = state or dict(m=m,n=n,tested=0,positive=0,unresolved=[],pending=[[0,0]])
    while budget and state["pending"] and (deadline is None or monotonic()<deadline):
        d,i=state["pending"].pop()
        if positive(m,n,F(i,2**d),F(i+1,2**d)):
            state["positive"] += 1
        elif d>=8:
            state["unresolved"].append([d,i])
        else:
            state["pending"].extend([[d+1,2*i+1],[d+1,2*i]])
        budget-=1
        state["tested"]+=1
    return state


def report():
    rows = [json.loads(p.read_text()) for p in LIVE.glob("*.json")]
    closed = {(r['m'],r['n']) for r in rows if not r['pending'] and not r['unresolved']}
    pairs = sorted({tuple(sorted((m,n))) for m,n in closed if (n,m) in closed})
    open_ends = sum(len(r['unresolved']) for r in rows)
    today = datetime.now().astimezone().date().isoformat()
    names = ", ".join(f"({m}, {n})" for m,n in pairs) or "None yet"
    msg = f"""# Optical physics results for {today}

The sharp lower-order threshold for the full zero–one-photon qubit is proved. Four further vacuum-plus-photon subspaces, with 2, 3, 4 or 5 photons in the excited component, satisfy the order-one-half conjecture.

The next search covers both amplitude orderings for pairs of excited photon levels from 1 through {BOUND}. Completed subspaces with a continuum certificate: {len(pairs)} of {BOUND*(BOUND-1)//2}. Completed pairs: {names}. Terminal intervals requiring a sharper estimate: {open_ends}.

A companion search tests coherent triples within levels 0 through 5 and saves the exact integer amplitudes for follow-up. Numerical nominations require a rigorous enclosure before they can establish a violation.

Each completed pair includes arbitrary relative phase and all mixtures on its two-level subspace. The data contribute to one sparse-state note. Reproduce the current results with `python3 excited_pairs.py replay`. Domain-wide claims and independent expert review are tracked separately.
"""
    status = OUT/'status.md'
    status.write_text(msg)
    daily = OUT/'daily'
    daily.mkdir(exist_ok=True)
    (daily/(today+'.md')).write_text(msg)


def advance():
    LIVE.mkdir(parents=True,exist_ok=True)
    deadline=monotonic()+50
    for high in range(2,BOUND+1):
        for low in range(1,high):
            for m,n in ((low,high),(high,low)):
                if monotonic() >= deadline:
                    report()
                    return
                path=LIVE/f"levels-{m:02}-{n:02}.json"
                prior=json.loads(path.read_text()) if path.exists() else None
                if prior and not prior['pending']:
                    continue
                state=process(m,n,600,prior,deadline=deadline)
                write(path,state)
                if state['pending']:
                    report()
                    return
    report()


def replay():
    for path in sorted(LIVE.glob('*.json')):
        row=json.loads(path.read_text())
        m,n=row['m'],row['n']
        if path.name != f"levels-{m:02}-{n:02}.json" or row!=process(m,n,row['tested']):
            raise ValueError(f"Excited-state certificate mismatch in {path}")
    for high in range(2,6):
        for low in range(1,high):
            for m,n in ((low,high),(high,low)):
                row=json.loads((LIVE/f"levels-{m:02}-{n:02}.json").read_text())
                if row['unresolved'] or row['pending']:
                    raise ValueError("Six-level coherence-number corollary is incomplete")
    print("All saved excited-state intervals and the six-level corollary reproduced.")


if __name__=='__main__':
    import argparse
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action',choices=('advance','replay'))
    if parser.parse_args().action=='advance':
        advance()
    else:
        replay()
