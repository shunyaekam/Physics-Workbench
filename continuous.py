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
        stage=Path(dirname)/tex.name
        stage.write_text(src)
        subprocess.run(["tectonic",str(stage)],check=True,timeout=120,stdout=subprocess.DEVNULL)
        pdf.write_bytes(stage.with_suffix(".pdf").read_bytes())
        tex.write_text(src)


def advance_frontier(nodes):
    # Short layers establish progress quickly. Keep oversized cases for a later
    # stronger relaxation while exploring other sizes within workstation limits.
    cases=read_cases()
    for d,k in [(7,3),(8,3),(5,4),(9,3),(3,5),(10,3),(6,4),(4,5),(11,3),(12,3)]:
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


def model_plan(number,history):
    from lab import ollama
    fallback=dict(trials4=6000,trials5=6000)
    if number%4:
        return fallback,{}
    prompt=("Allocate a bounded batch of exact rank-two Werner searches between four and five copies. "
            "Each family needs 2000 to 10000 trials and the total is 12000. "
            "We minimize exact expectation. Use the recorded campaign history. Return trials4 only.\n"+
            json.dumps(history))
    schema={"type":"object","properties":{"trials4":{"type":"integer","minimum":2000,"maximum":10000}},
            "required":["trials4"],"additionalProperties":False}
    try:
        reply=ollama("generate",dict(model="llama3.2:3b",prompt=prompt,format=schema,stream=False,
                                     options={"seed":number,"num_predict":50}),timeout=30)
        n=json.loads(reply["response"])["trials4"]
        require(type(n) is int and 2000<=n<=10000,"invalid allocation")
        return dict(trials4=n,trials5=12000-n),dict(prompt=prompt,response=reply["response"],model=reply["model"])
    except Exception as e:
        return fallback,dict(fallback=str(e))


def round_once(nodes):
    ROUNDS.mkdir(exist_ok=True,parents=True)
    previous=sorted(ROUNDS.glob("*.json"))
    number=int(previous[-1].stem)+1 if previous else 1
    seed=17000+number
    hist=[load(p) for p in previous[-3:]]
    controls()
    plan,model=model_plan(number,[{str(r["k"]):r["score"] for r in h["quantum"]} for h in hist])
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
    frontier=advance_frontier(nodes)
    render()
    receipt=dict(round=number,utc=datetime.now(timezone.utc).isoformat(),allocation=plan,model=model,
                 code={n:hashlib.sha256((ROOT/n).read_bytes()).hexdigest() for n in
                       ("supports.py","archive_supports.py","complex_search.py","continuous.py","sphere_bounds.py")},
                 quantum=results,sphere=sphere,frontier=frontier)
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
