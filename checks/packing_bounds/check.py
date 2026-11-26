"""Certify each construction against its signed rational pair inequalities."""
from decimal import Decimal, localcontext
from fractions import Fraction
from functools import reduce
from itertools import combinations
from pathlib import Path
from math import gcd
import csv
import json
import sys


def directions(path, n, d):
    rows = []
    with path.open() as f:
        for row in csv.reader(f):
            values = [Fraction(x) for x in row]
            if len(values) != d:
                raise ValueError("Wrong dimension")
            common = reduce(lambda a,b: a*b//gcd(a,b), (x.denominator for x in values), 1)
            point = [x.numerator*(common//x.denominator) for x in values]
            if not any(point):
                raise ValueError("Zero direction")
            rows.append(point)
    if len(rows) != n:
        raise ValueError("Wrong number of directions")
    return rows


def largest_squared(points):
    squared = [sum(a*a for a in v) for v in points]
    hi, lo, pair = 0, 1, None
    for i,j in combinations(range(len(points)),2):
        dot = sum(a*b for a,b in zip(points[i],points[j]))
        if dot <= 0:
            continue
        p = dot*dot
        q = squared[i]*squared[j]
        if p*lo > hi*q:
            hi,lo,pair = p,q,[i,j]
    if pair is None:
        raise ValueError("Expected a positive maximum")
    return Fraction(hi,lo),pair


def verify(root, record):
    n,d = record["n"],record["d"]
    if type(n) is not int or type(d) is not int or n < 2 or d < 2:
        raise ValueError("Invalid dimensions")
    directory=root/f"{d}-{n}"
    own,pair = largest_squared(directions(directory/"points.csv",n,d))
    prior,prior_pair = largest_squared(directions(directory/"baseline.csv",n,d))
    upper = Fraction(record["certified_upper"])
    table = Fraction(record["table_cosine"])
    if not 0 < upper < table < 1 or not own < upper**2:
        raise ValueError("Candidate does not certify the reported bound")
    if not (table-Fraction(1,10**11))**2 < prior <= table**2:
        raise ValueError("Baseline coordinate set differs from table")
    if not own < (table-Fraction(1,10**10))**2 or own >= prior:
        raise ValueError("No certified improvement")
    with localcontext() as ctx:
        ctx.prec=52
        display=(Decimal(own.numerator)/Decimal(own.denominator)).sqrt()
    return dict(d=d,n=n,pairs=n*(n-1)//2,closest_pair=pair,old_pair=prior_pair,
                strict_upper=str(record["certified_upper"]),maximum_cosine=str(display))


if __name__ == "__main__":
    base = Path(__file__).resolve().parent
    records = json.loads((base/"comparisons.json").read_text())
    print(json.dumps([verify(base,rec) for rec in records],indent=2))
