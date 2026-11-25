"""Check a rank-seven overlap certificate with the Python standard library."""
from fractions import Fraction
from functools import reduce
from itertools import combinations, combinations_with_replacement, permutations
import json
from math import prod
from operator import xor
from pathlib import Path

HERE=Path(__file__).resolve().parent
LABELS=tuple(range(7))
SUBSETS=tuple(combinations(LABELS,4))
PLANE=tuple(reduce(xor,f)==0 for f in SUBSETS)
KEYS=tuple(combinations_with_replacement(range(1,8),4))


def rows():
    result=[]
    def add(predicate,bound,dimension8=False):
        result.append(([int(predicate(set(f))) for f in SUBSETS],bound,dimension8))
    for size in (3,5,6):
        for chosen in combinations(LABELS,size):
            u=set(chosen)
            if size==3: add(lambda f:u<=f,1)
            if size==5: add(lambda f:f<=u,1)
            if size==6:
                add(lambda f:f<=u,3)
                for i in chosen:
                    add(lambda f:f<=u and i in f,2)
    for pair in combinations(LABELS,2):
        add(lambda f:set(pair)<=f,2,True)
    return result


def verify():
    cert=json.loads((HERE/"duals.json").read_text())
    if list(map(tuple,(r["key"] for r in cert)))!=list(KEYS):
        raise ValueError("Missing, duplicated or out-of-order quartic")
    constraints=rows()
    exceptional=[]
    for entry in cert:
        key=entry["key"]
        # Each repeated gap is temporarily distinguished; this multiplies both
        # sides of the coefficient inequality by the same positive factorial.
        weights=[sum(all(i<k for i,k in zip(p,key)) for p in permutations(f)) for f in SUBSETS]
        target=sum(w for w,active in zip(weights,PLANE) if active)
        lhs=[Fraction(0)]*35
        bound=Fraction(0)
        needs_pair=False
        for row_id,multiplier in entry["dual"]:
            m=Fraction(multiplier)
            if m<=0 or not 0<=row_id<len(constraints): raise ValueError("Invalid multiplier")
            row,limit,pair=constraints[row_id]
            bound+=m*limit
            lhs=[old+m*x for old,x in zip(lhs,row)]
            needs_pair|=pair
        if bound!=target or any(a<b for a,b in zip(lhs,weights)):
            raise ArithmeticError(f"Invalid certificate for {key}")
        if needs_pair: exceptional.append(tuple(key))
    print(f"Exact certificates verified for {len(KEYS)} coefficients in dimension 8")
    print(f"{len(KEYS)-len(exceptional)} use only dimension-independent rows")
    return exceptional


def occupation_check():
    # Entries of Pi/q in the coordinate wedge basis from Eq. (39).
    labels=set(range(8))
    planes={frozenset(f) for f in combinations(range(8),4) if reduce(xor,f)==0}
    for k,expected in ((2,3),(3,1)):
        sets=list(map(frozenset,combinations(range(8),k)))
        for a in sets:
            for b in sets:
                entry=0
                for rest in combinations(sorted(labels-a-b),4-k):
                    r=frozenset(rest)
                    f,h=a|r,b|r
                    if f in planes and (h==f or h==labels-f):
                        inversions=sum(i>j for i in a for j in r)+sum(i>j for i in b for j in r)
                        entry+=(-1)**inversions
                if entry!=(expected if a==b else 0): raise ArithmeticError("Occupation identity failed")
    print("Exact two- and three-particle occupation matrices agree with the identities")


def formula(amplitudes):
    t=[Fraction(x*x,sum(y*y for y in amplitudes)) for x in amplitudes]
    invariant=7*sum(x*x for x in t)**2-6*sum(x**4 for x in t)
    return invariant+168*sum(prod(t[i] for i in f) for f,is_plane in zip(SUBSETS,PLANE) if is_plane)


def pauli_purity(vector):
    n=len(vector)
    norm=sum(v*v for v in vector)
    parity=[(-1)**bin(i).count("1") for i in range(n)]
    acc=0
    for x in range(n):
        for z in range(n):
            raw=sum(v*vector[i^x]*parity[i&z] for i,v in enumerate(vector))
            acc+=raw**4  # Pauli phase disappears in the fourth power.
    return Fraction(acc,n*norm**4)


def direct_checks():
    def reflection(v):
        norm=sum(x*x for x in v)
        return [[norm*int(i==j)-2*a*b for j,b in enumerate(v)] for i,a in enumerate(v)]
    left=reflection([1,2,-1,3,0,1,4,-2])
    right=reflection([1,0,3,-1,2,2,1,4])
    for amplitudes in ([1]*7,[7,6,5,4,3,2,1],[8,8,8,6,4,3,2]):
        diagonal=[amplitudes[i] if i==j and i<7 else 0 for i in range(8) for j in range(8)]
        rotated=[sum(left[i][k]*right[j][k]*a for k,a in enumerate(amplitudes))
                 for i in range(8) for j in range(8)]
        exact=formula(amplitudes)
        if pauli_purity(diagonal)!=exact or pauli_purity(rotated)>exact:
            raise ArithmeticError("Six-qubit direct Pauli check failed")
        print("Exact optimal purity for amplitudes",amplitudes,"=",exact)


if __name__=="__main__":
    occupation_check()
    exceptional=verify()
    if any(1 not in k and 2 not in k for k in exceptional) or any(2 not in k and 3 not in k for k in exceptional):
        raise ArithmeticError("Claimed equal-amplitude families need a dimension-specific row")
    direct_checks()
