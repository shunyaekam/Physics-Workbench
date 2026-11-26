"""One bounded research round; launchd handles recurrence and git handles transport."""
import argparse
from datetime import datetime, timezone
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

from paper_build import stage_paper_directory
from archive_supports import read,save
from complex_search import controls,direct,partial_traces,search
from lab import ROOT,load,write
from supports import initial,advance,audit
from verify import require

DATA=ROOT/"campaign"
PAPERS=ROOT/"papers"
ROUNDS=DATA/"rounds"


def read_cases(check=False):
    full={}
    layers={}
    for path in sorted(DATA.glob("support-*.json.gz")):
        r=read(path)
        if check:
            audit(r)
        if r["todo"]:
            continue
        pair=r["d"],r["k"]
        if "orbit" in r:
            layers.setdefault(pair,{})[r["orbit"]]=len(r["best"])
        else:
            full[pair]=len(r["best"])
    for (d,k),values in layers.items():
        if set(values)==set(range(1,k+1)):
            n=max(values.values())
            require(full.get((d,k),n)==n,"layer and full certificates disagree")
            full[d,k]=n
    return full


def render():
    cases=read_cases()
    rows="\n".join(f"{d} & {k} & {cases[d,k]} "+chr(92)*2 for d,k in sorted(cases,key=lambda x:(x[1],x[0])))
    src=(PAPERS/"finite-template.txt").read_text().replace("%%ROWS%%",rows)
    tex=PAPERS/"finite-maxima.tex"
    pdf=tex.with_suffix(".pdf")
    if tex.exists() and tex.read_text()==src and pdf.exists():
        return
    read_cases(check=True)
    with tempfile.TemporaryDirectory() as dirname:
        stage=stage_paper_directory(dirname,ROOT)/tex.name
        stage.write_text(src)
        subprocess.run(["tectonic",str(stage)],check=True,timeout=120,stdout=subprocess.DEVNULL)
        pdf.write_bytes(stage.with_suffix(".pdf").read_bytes())
        tex.write_text(src)


def advance_frontier(nodes):
    # Short layers establish progress quickly. Keep oversized cases for a later
    # stronger relaxation while exploring other sizes within workstation limits.
    cases=read_cases()
    # The companion proofs cover d <= 4 and every three-copy dimension.
    for d,k in [(5,4),(6,4)]:
        if (d,k) in cases:
            continue
        for t in range(1,k+1):
            path=DATA/f"support-{d}-{k}-layer-{t}.json.gz"
            if path.exists():
                r=read(path)
                if not r["todo"] or len(r["closed"])>=60000:
                    continue
            else:
                r=initial(d,k)
                r["orbit"]=t
            advance(r,nodes)
            save(path,r)
            return {"file":path.name,"complete":not r["todo"],"closed":len(r["closed"]),
                    "pending":len(r["todo"]),"lower":len(r["best"])}
    return {"status":"configured layers completed or at workstation checkpoint limit"}


def audit_score(r):
    w=r["witness"]
    score=Fraction(r["score"])
    require(direct(w,r["d"],r["k"])==score==partial_traces(w,r["d"],r["k"]),"score failed independent replay")
    if r.get("arm")=="full-site-variation-v1":
        from complex_search import matrix,varied_on_every_site
        require(varied_on_every_site(matrix(w,r["d"],r["k"]),r["d"],r["k"]),"fixed-site witness in multicopy arm")


def round_once(nodes):
    ROUNDS.mkdir(exist_ok=True,parents=True)
    previous=sorted(ROUNDS.glob("*.json"))
    number=int(previous[-1].stem)+1 if previous else 1
    seed=17000+number
    hist=[load(p) for p in previous[-3:]]
    controls()
    plan=dict(trials4=6000,trials5=6000)
    from discovery_queue import select
    dispatch=select(number,hist)
    wigner_runs=[]
    if dispatch["primary"]=="gagatsos-2026-c1":
        # Different Sobol blocks per round, including after a pause or restart.
        from wigner_search import search as search_wigner
        for block in range(4*number-3,4*number+1):
            wigner_runs.append(search_wigner(block))
        plan={name:min(n,1500) for name,n in plan.items()}
    if any(r["status"]=="needs_interval_check" for r in wigner_runs):
        write(DATA/f"wigner-needs-enclosure-{number}.json",wigner_runs)
    results=[]
    for k in (4,5):
        incumbent=next((r["witness"] for r in hist[-1]["quantum"] if r["k"]==k),None) if hist else None
        r=search(3,k,seed,plan[f"trials{k}"],incumbent)
        audit_score(r)
        results.append(r)
        if Fraction(r["score"])<0:
            # Preserve review material for every strict negative discovery.
            path=DATA/f"negative-{k}-{number}.json"
            write(path,r)
            (PAPERS/f"negative-{k}-{number}.md").write_text(
                f"# Candidate negative expectation at {k} copies\n\nTwo integer formulations returned {r['score']}. "
                f"The factorization and replay inputs are in [the witness](../campaign/{path.name}). "
                "Independent physical-statement mapping and external replication are pending.\n")
    from sphere_bounds import experiment
    # Cover each case at each degree before cycling to different starting grids.
    n=(11,13,10,14)[(number-1)%4]
    degree=(12,10,11,9,8,7,6,5)[((number-1)//4)%8]
    try:
        sphere=experiment(n,degree,seed)
    except ValueError as exc:
        sphere={"n":n,"degree":degree,"seed":seed,"error":str(exc)}
    frontier=(advance_frontier(nodes) if dispatch["support_benchmark_due"] else
              {"status":"support enumeration deferred to eighth-round benchmark slot"})
    render()
    receipt=dict(round=number,utc=datetime.now(timezone.utc).isoformat(),allocation=plan,model={},
                 code={n:hashlib.sha256((ROOT/n).read_bytes()).hexdigest() for n in
                       ("supports.py","archive_supports.py","complex_search.py","continuous.py","sphere_bounds.py","wigner_search.py","discovery_queue.py","discovery/targets.json")},
                 quantum=results,sphere=sphere,frontier=frontier,dispatch=dispatch,wigner=wigner_runs)
    write(ROUNDS/f"{number:08}.json",receipt)
    print("Round",number,"direct/partial trace scores:",[r["score"] for r in results],frontier,flush=True)


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("action",choices=["run","audit","render"])
    p.add_argument("--nodes",type=int,default=4500)
    a=p.parse_args()
    if a.action=="run":
        require(1<=a.nodes<=25000,"invalid node budget")
        import fcntl
        with (DATA/".lock-continuous").open("w") as f:
            fcntl.flock(f,fcntl.LOCK_EX)
            round_once(a.nodes)
    elif a.action=="render":
        render()
    else:
        controls()
        subprocess.run([sys.executable,str(ROOT/"checks/scrutiny.py")],check=True)
        subprocess.run([sys.executable,str(ROOT/"checks/thresholds.py")],check=True)
        print("Verified exact maxima:",read_cases(check=True))
        for path in sorted(ROUNDS.glob("*.json")):
            receipt=load(path)
            for result in receipt["quantum"]:
                audit_score(result)
            if "sphere" in receipt and "error" not in receipt["sphere"]:
                from sphere_bounds import independent
                from verify import lower_bound
                s=receipt["sphere"]
                require(Fraction(s["lower"])==lower_bound(s["n"],s["coeff"])==independent(s["n"],s["coeff"]),
                        "saved Coulomb bound verification failed")
        from sphere_bounds import independent
        from verify import lower_bound
        for path in (DATA/"coulomb").glob("*.json"):
            s=load(path)
            require(Fraction(s["lower"])==lower_bound(s["n"],s["coeff"])==independent(s["n"],s["coeff"]),
                    "standalone Coulomb bound failed")
        print("All retained complex witnesses and Coulomb certificates replayed.")


if __name__=="__main__":
    main()
