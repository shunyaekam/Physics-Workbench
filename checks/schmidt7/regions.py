"""Exact dimension-independent overlap certificates for three spectral regions."""
import argparse
from fractions import Fraction
from itertools import permutations
import json
from math import prod
from verify import HERE, SUBSETS, PLANE, KEYS, rows

REGIONS=("bounded_ratio","bounded_second","fourth_gap")


def entry(region,i,j):
    """Entry i of the jth generating ray, indices are one-based."""
    if region=="bounded_ratio":
        return 1 if j==7 else 1+2*int(i<=j)
    if region=="bounded_second":
        return 1 if j==7 else int(i<=j)+2*int(j>=2)
    if region=="fourth_gap":
        return 1+int(i<=4) if j==7 else int(i<=j)
    raise ValueError("Unknown spectral region")


def weights(region,key):
    return [sum(prod(entry(region,i+1,j) for i,j in zip(order,key))
                for order in permutations(subset)) for subset in SUBSETS]


def verify_cert(region,records):
    constraints=[(a,b) for a,b,small in rows() if not small]
    if [tuple(r["key"]) for r in records]!=list(KEYS):
        raise ValueError("Incomplete region coverage")
    for record in records:
        w=weights(region,record["key"])
        cover=[Fraction(0)]*len(w)
        budget=Fraction(0)
        for index,mu in record["dual"]:
            if not 0<=index<len(constraints): raise ValueError("Unsupported physical row")
            row,b=constraints[index]
            m=Fraction(mu)
            if m<=0: raise ValueError("Invalid dual weight")
            budget+=b*m
            cover=[a+c*m for a,c in zip(cover,row)]
        if any(a<b for a,b in zip(cover,w)) or budget!=sum(a for a,is_plane in zip(w,PLANE) if is_plane):
            raise ArithmeticError(f"Invalid dual for {region}, {record['key']}")


def make(region):
    # LP output is a proposal. Only exact inequalities can admit a certificate.
    from scipy.optimize import linprog
    import numpy as np
    constraints=[(a,b) for a,b,small in rows() if not small]
    A,b=zip(*constraints)
    records=[]
    for key in KEYS:
        objective=np.array(weights(region,key))
        lp=linprog(-objective,A_ub=A,b_ub=b,bounds=(0,None),method="highs")
        if not lp.success: raise ArithmeticError(lp.message)
        terms=[[i,str(Fraction(float(-v)).limit_denominator(100000))] for i,v in enumerate(lp.ineqlin.marginals) if v < -1e-9]
        records.append(dict(key=key,dual=terms))
    verify_cert(region,records)
    return records


def sharpness():
    # Average a feasible fractional maximizer over swaps of the leading pair
    # and permutations of the five trailing labels; only the overlap size matters.
    coords=[Fraction(a,b) for a,b in [(1,5),(1,8),(1,4)]]
    # Group totals 1, 5/2, 5/2 respectively. Coordinate totals 1, 4, 2.
    x=[coords[len(set(f)&{0,1})] for f in SUBSETS]
    for row,b,small in rows():
        if not small and sum(a*z for a,z in zip(row,x))>b: raise ArithmeticError("Infeasible sharpness witness")
    counts=[sum((x[k]-int(PLANE[k]) for k,f in enumerate(SUBSETS) if len(set(f)&{0,1})==r),Fraction(0)) for r in range(3)]
    if counts!=[0,Fraction(-3,2),Fraction(1,2)]:raise ArithmeticError(f"Wrong objective polynomial: {counts}")
    return counts


if __name__=="__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("--generate",action="store_true")
    args=parser.parse_args()
    for region in REGIONS:
        path=HERE/(region+".json")
        if args.generate:
            records=make(region)
            path.write_text("[\n"+",\n".join(json.dumps(r,separators=(",",":")) for r in records)+"\n]\n")
        verify_cert(region,json.loads(path.read_text()))
        print(f"{region}: {len(KEYS)} exact quartic certificates")
    sharpness()
    print("Sharpness for the dimension-independent linear relaxation checked")
