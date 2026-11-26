"""Exact search beyond the two-eigenvalue theorem, with a published failure control."""
import argparse
from itertools import combinations
from math import comb
from pathlib import Path
from random import Random
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from lab import load, write

OUT = ROOT / "campaign/bmv-three-level"
COUNTS = ((7, 5), (9, 5), (11, 7))


def identity(d):
    return [[int(i == j) for j in range(d)] for i in range(d)]


def multiply(a, b):
    columns = list(zip(*b))
    return [[sum(x*y for x, y in zip(row, column)) for column in columns] for row in a]


def power(a, k):
    result = identity(len(a))
    for _ in range(k):
        result = multiply(result, a)
    return result


def trace(a):
    return sum(row[i] for i, row in enumerate(a))


def word_sum(a, b, n, m):
    """Trace sum, with each distinct binary word included exactly once."""
    previous = [identity(len(a))]
    for i in range(n + 1):
        current = []
        for j in range(m + 1):
            if i == j == 0:
                current.append(previous[0])
            else:
                left = multiply(a, previous[j]) if i else None
                right = multiply(b, current[j-1]) if j else None
                if left is None or right is None:
                    current.append(right if left is None else left)
                else:
                    current.append([[u+v for u, v in zip(x, y)] for x, y in zip(left, right)])
        previous = current
    return trace(previous[-1])


def controls():
    # Cha–Lee Appendix A, x=1/1000, with both matrices multiplied by 1000.
    a = [[1000,0,0],[0,1,-1],[0,-1,1]]
    b = [[1,-1,0],[-1,1,0],[0,0,1000]]
    words = word_sum(a, b, 5, 5)
    clustered = comb(10,5)*trace(multiply(power(a,5),power(b,5)))
    # Eq. (7) for L-R, scaled by binomial(10,5) and 1000^10.
    exact_difference = 10 * (5475 - 1186*1000 - 975*1000**2 - 626*1000**3
                             - 335*1000**4 + 522*1000**5 - 1000**6)
    if clustered-words != exact_difference or exact_difference >= 0:
        raise ArithmeticError("Published upper-bound counterexample failed")
    if word_sum(a, a, 7, 5) != comb(12,5)*trace(power(a,12)):
        raise ArithmeticError("Commuting equality control failed")


def run(batch):
    controls()
    rng = Random(370350 + batch)
    closest = None
    valid = 0
    total_draws = 0
    while valid < 32:
        total_draws += 1
        d = rng.choice((3, 4, 5))
        roots = sorted(rng.sample(range(1, 8), 3))
        levels = roots + rng.choices(roots, k=d-3)
        gram = [[rng.randint(-5, 5) for _ in range(d)] for _ in range(d)]
        b = multiply(gram, list(zip(*gram)))
        # Require a negative triangle across the three distinct spectral blocks
        # in this basis. Positive-entry path arguments would be uninformative.
        if not any(len({levels[i],levels[j],levels[k]})==3 and b[i][j]*b[j][k]*b[k][i]<0
                   for i,j,k in combinations(range(d),3)):
            continue
        n, m = COUNTS[(batch + valid) % len(COUNTS)]
        a = [[value**m if i == j else 0 for j in range(d)] for i,value in enumerate(levels)]
        balanced_step = [[value**n * entry for entry in row] for value,row in zip(levels,b)]
        balanced = comb(n+m,m)*trace(power(balanced_step,m))
        if balanced <= 0:
            raise ArithmeticError("Nonpositive reference trace for a nonzero input")
        gap = word_sum(a,b,n,m) - balanced
        valid += 1
        if closest is None or gap*closest["reference"] < closest["gap"]*balanced:
            closest = dict(n=n,m=m,roots=levels,gram=gram,gap=gap,reference=balanced)
        if gap < 0:
            break
    return dict(batch=batch,tested=valid,draws=total_draws,closest=closest,
                status="balanced_product_violation" if closest["gap"]<0 else "screen_only")


if __name__ == "__main__":
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action",choices=("advance","replay"))
    action=parser.parse_args().action
    paths=sorted(OUT.glob("*.json"))
    if action=="replay":
        controls()
        for path in paths:
            if run(int(path.stem)) != load(path):
                raise ArithmeticError("Batch mismatch: "+path.name)
    elif len(paths)<6 and not any(load(p)["status"]=="balanced_product_violation" for p in paths):
        result=run(len(paths))
        OUT.mkdir(parents=True,exist_ok=True)
        write(OUT/f"{len(paths):06}.json",result)
        print("Three-spectrum BMV search",result["tested"],result["status"])
