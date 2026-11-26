"""Exact chain dynamic program and attaining spectral labels for integral q >= 1."""
import argparse
from fractions import Fraction
from itertools import combinations
import json


def solve(levels,q):
    x=list(map(Fraction,levels))
    if len(x)<1 or any(a>=b for a,b in zip(x,x[1:])) or type(q) is not int or q<1:
        raise ValueError("Provide strictly increasing rational levels and a positive integer exponent")
    n=len(x)
    if n==1:return Fraction(0),[0],[Fraction(0)]
    d=[[abs(a-b)**q for b in x] for a in x]
    # For k segments, minimize the sum of forward costs on a chain with fixed
    # extreme endpoints. Convex increments justify extending to both extremes.
    prev=[Fraction(0)]+[None]*(n-1)
    back=[{}]
    delta=Fraction(0)
    winning_k=1
    for k in range(1,n):
        current=[None]*n
        layer={}
        for j in range(k,n):
            cost,i=min((prev[i]+d[i][j],i) for i in range(k-1,j) if prev[i] is not None)
            current[j]=cost
            layer[j]=i
        back.append(layer)
        candidate=(d[0][-1]-current[-1])/(k+1)
        if candidate>delta:
            delta=candidate
            winning_k=k
        prev=current
    chain=[n-1]
    for k in range(winning_k,0,-1):
        chain.append(back[k][chain[-1]])
    chain.reverse()
    # Potentials meet each lower and upper bound, including monotonicity.
    edges=[]
    for i,j in combinations(range(n),2):
        edges.extend(((i,j,d[i][j]+delta),(j,i,-max(0,d[i][j]-delta))))
    y=[Fraction(0)]*n
    for _ in range(n-1):
        changed=False
        for i,j,cap in edges:
            if y[j]>y[i]+cap:
                y[j]=y[i]+cap
                changed=True
        if not changed:break
    if any(y[j]>y[i]+cap for i,j,cap in edges):raise ArithmeticError("Infeasible at computed bound")
    labels=[z-y[0] for z in y]
    err=max(abs(d[i][j]-(labels[j]-labels[i])) for i,j in combinations(range(n),2))
    if err!=delta:raise ArithmeticError("Upper and lower certificates disagree")
    return delta,chain,labels


if __name__=="__main__":
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("q",type=int)
    parser.add_argument("levels",nargs="+",type=Fraction)
    args=parser.parse_args()
    delta,chain,y=solve(args.levels,args.q)
    print(json.dumps(dict(error=str(delta),maximizing_chain=[str(args.levels[i]) for i in chain],
                          optimal_labels=list(map(str,y))),indent=2))
