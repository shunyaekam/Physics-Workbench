"""Exact search on Pitchford 7.7 for q>1, including lower and upper certificates."""
from argparse import ArgumentParser
from datetime import datetime, timezone
from fractions import Fraction as Q
from itertools import combinations, permutations, product
from pathlib import Path
import random
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from lab import load, write

PID = "transport-polygon"
OUT = ROOT / "campaign" / PID


def verify_outer_endpoint(x):
    # At p=1/4, q=1/2 spectral gaps 9,16,25 have exact costs 3,4,5.
    edges = list(combinations(range(3), 2))
    costs = [3, 5, 4]
    if [c*c for c in costs] != [x[j]-x[i] for i,j in edges]:
        raise ValueError("Incorrect powers")
    masses = [2,1,3]
    if [masses[i]+masses[j] for i,j in edges] != costs or max(costs)*2 == sum(costs):
        raise ValueError("Incorrect cut or collinearity test")
    return dict(spectrum=x,p="1/4",q="1/2",costs_01_02_12=costs,cut_weights=masses,
                cone_distance=0, single_real_function_attains=False)


def polygon(x, q):
    # Clamps and exact bounds for every increasing chain, all endpoints included.
    n = len(x)
    bound, witness = Q(0), ()
    for length in range(3,n+1):
        for path in combinations(range(n),length):
            long = (x[path[-1]]-x[path[0]])**q
            small = sum((x[j]-x[i])**q for i,j in zip(path,path[1:]))
            e = Q(long-small,length)
            if e > bound:
                bound,witness=e,path
    return bound,witness


def line(x,q,delta,order):
    # Integer difference constraints on the scaled line coordinates.
    scale, err=delta.denominator,delta.numerator
    n=len(x)
    edges=[]
    for i,j in combinations(order,2):
        target=scale*abs(x[i]-x[j])**q
        edges.extend([(i,j,target+err),(j,i,-max(0,target-err))])
    y=[0]*n
    for _ in range(n):
        changed=False
        for i,j,cap in edges:
            if y[j]>y[i]+cap:
                y[j]=y[i]+cap
                changed=True
        if not changed:
            break
    # A feasible labeling is a directly replayable upper-bound witness.
    if any(y[j]>y[i]+cap for i,j,cap in edges):
        return None
    if max(abs(abs(y[i]-y[j])-scale*abs(x[i]-x[j])**q) for i,j in combinations(range(n),2))>err:
        raise ArithmeticError("Bad line certificate")
    return [str(Q(z-y[0],scale)) for z in y]


def inspect(x,q):
    delta,chain=polygon(x,q)
    order=tuple(range(len(x)))
    cert=line(x,q,delta,order)
    if cert is None and len(x)<=7:
        for perm in permutations(order):
            if perm[0] < perm[-1]:
                cert=line(x,q,delta,perm)
                if cert is not None:
                    break
    status = ("attained" if cert is not None else
              "all_line_orders_infeasible" if len(x)<=7 else "ordered_line_infeasible")
    return dict(x=x,q=q,bound=str(delta),chain=chain,coordinates=cert,status=status)


def run(batch):
    rng=random.Random(51000+batch)
    cases=[]
    if batch==0:
        for gaps in product(range(1,5),repeat=3):
            x=[0,gaps[0],sum(gaps[:2]),sum(gaps)]
            cases.extend((x,q) for q in (2,3,6))
    else:
        for _ in range(128):
            x=sorted(rng.sample(range(128),rng.randint(4,9)))
            cases.append(([v-x[0] for v in x],rng.choice([2,3,4,6,10])))
    results=[inspect(x,q) for x,q in cases]
    return dict(problem_id=PID,batch=batch,checked=len(results),utc=datetime.now(timezone.utc).isoformat(),
                attained=sum(v["status"]=="attained" for v in results),
                flags=[v for v in results if v["status"]!="attained"],
                literal_clause=verify_outer_endpoint([0,9,25]),results=results)


if __name__=="__main__":
    parser=ArgumentParser();parser.add_argument("action",choices=["advance","replay"]);args=parser.parse_args()
    OUT.mkdir(exist_ok=True)
    if args.action=="advance":
        # Rotate away from unchanged screens after eight batches; new strategies can open a new campaign.
        for batch in range(8):
            path=OUT/f"{batch:03d}.json"
            if not path.exists():
                write(path,run(batch))
                break
    else:
        for path in sorted(OUT.glob("*.json")):
            old=load(path);new=run(old["batch"]);new["utc"]=old["utc"]
            import json
            if json.loads(json.dumps(new))!=old:
                raise ArithmeticError(f"Replay mismatch in {path}")
