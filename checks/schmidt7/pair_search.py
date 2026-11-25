"""Look for a rank-seven physical frame violating the sufficient pair bound in dimension 16."""
import argparse
from fractions import Fraction
from functools import reduce
from itertools import combinations, permutations
from operator import xor
from pathlib import Path
import random
import sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from lab import load,write

LABELS=range(16)
OUT=ROOT/"campaign/schmidt-seven-pairs"
PLANES={}
for f in combinations(LABELS,4):
    if reduce(xor,f)==0:
        PLANES[sum(1<<i for i in f)]=tuple(sorted(f[0]^j for j in f[1:]))
PERMS=[(p,(-1)**sum(i>j for i,j in combinations(p,2))) for p in permutations(range(4))]


def initial(frame):
    return [{sum(1<<i for i in (*frame[:2],a,b)):1} for a,b in combinations(frame[2:],2)]


def rotate(wedges,i,j,c,s,h):
    """Apply the same real Givens rotation to each four-wedge, scaled by h."""
    a,b=1<<i,1<<j
    between=b-2*a  # bits strictly between the two rotated rows
    results=[]
    for wedge in wedges:
        out={}
        for mask,value in wedge.items():
            if bool(mask&a)==bool(mask&b):
                out[mask]=value*h
                continue
            out[mask]=out.get(mask,0)+c*value
            sign=(-1)**bin(mask&between).count("1")
            other=mask^a^b
            out[other]=out.get(other,0)+(s if mask&a else -s)*sign*value
        results.append({m:v for m,v in out.items() if v})
    return results


def score(wedges,den):
    total=0
    for wedge in wedges:
        sums={}
        for mask,value in wedge.items():
            direction=PLANES.get(mask)
            if direction is not None: sums[direction]=sums.get(direction,0)+value
        total+=sum(a*a for a in sums.values())
    return Fraction(total,den*den)


def direct(frame,moves):
    """Independent determinant replay from the actual 16 by 7 one-particle frame."""
    U=[[int(row==coordinate) for coordinate in frame] for row in LABELS]
    scale=1
    for i,j,c,s,h in moves:
        left,right=U[i],U[j]
        U=[[h*a for a in row] for row in U]
        U[i]=[c*a-s*b for a,b in zip(left,right)]
        U[j]=[s*a+c*b for a,b in zip(left,right)]
        scale*=h
    if any(sum(row[a]*row[b] for row in U)!=int(a==b)*scale**2 for a in range(7) for b in range(7)):
        raise ArithmeticError("Local frame lost orthogonality")
    total=0
    for a,b in combinations(range(2,7),2):
        cols=(0,1,a,b)
        sums={}
        for mask,direction in PLANES.items():
            i,j,k,l=[z for z in LABELS if mask>>z&1]
            det=sum(sign*U[i][cols[p]]*U[j][cols[q]]*U[k][cols[r]]*U[l][cols[t]]
                    for (p,q,r,t),sign in PERMS)
            sums[direction]=sums.get(direction,0)+det
        total+=sum(v*v for v in sums.values())
    return Fraction(total,scale**8)


def run(batch):
    rng=random.Random(86007+batch)
    best=Fraction(-1)
    best_state=None
    tested=0
    for family in range(60):
        frame=list(range(7)) if family%2==0 else rng.sample(LABELS,7)
        wedges=initial(frame)
        den=1
        history=[]
        for step in range(9):
            if step:
                i,j=sorted(rng.sample(LABELS,2))
                c,s,h=rng.choice([(3,4,5),(5,12,13),(7,24,25),(8,15,17)])
                if rng.randrange(2): c,s=s,c
                if rng.randrange(2): s=-s
                wedges=rotate(wedges,i,j,c,s,h)
                den*=h
                history.append([i,j,c,s,h])
            value=score(wedges,den)
            tested+=1
            if value>best:
                best=value
                best_state=(frame,history.copy())
            # Cross-check a nontrivial path even when the maximizer is a coordinate frame.
            if family==1 and step==8 and direct(frame,history)!=value:
                raise ArithmeticError("Exterior evolution disagrees with the determinant oracle")
            if best>2: break
        if best>2: break
    frame,history=best_state
    if direct(frame,history)!=best: raise ArithmeticError("Pair-bound witness did not replay")
    return dict(batch=batch,dimension=16,domain="real rational orthonormal seven-frames",evaluations=tested,
                maximum=str(best),violates_sufficient_bound=best>2,initial_frame=frame,rotations=history)


if __name__=="__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("action",choices=["advance","replay"])
    args=parser.parse_args()
    OUT.mkdir(exist_ok=True)
    paths=sorted(OUT.glob("*.json"))
    if args.action=="replay":
        for p in paths:
            if run(int(p.stem))!=load(p): raise ArithmeticError("Pair batch replay failed")
    elif not any(load(p)["violates_sufficient_bound"] for p in paths):
        batch=len(paths)
        result=run(batch)
        write(OUT/f"{batch:06d}.json",result)
        print("Larger-register pair search",result)
