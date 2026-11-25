"""Run, resume, and audit bounded research campaigns on a single machine."""
import argparse
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
import fcntl
from fractions import Fraction as Q
import hashlib
import json
from pathlib import Path
import platform
import re
import sys
import tempfile
import urllib.request

from verify import CHECKERS, require

ROOT = Path(__file__).resolve().parent


def digest(obj):
    return hashlib.sha256(json.dumps(obj, sort_keys=True).encode()).hexdigest()


def load(path):
    return json.loads(path.read_text())


def write(path, obj):
    with tempfile.NamedTemporaryFile(dir=path.parent, mode="w", delete=False) as f:
        json.dump(obj, f, indent=2, allow_nan=False)
        f.write("\n")
    Path(f.name).replace(path)


def catalog():
    cards = load(ROOT/"problems.json")
    for c in cards:
        require(re.fullmatch(r"[a-z0-9-]+",c["id"]) and c["family"] in CHECKERS, "invalid card")
        require(all(c.get(k) for k in ("question","source","prior_art","scope","checked_on")), "missing provenance")
        require(c["role"] in ("control","research"), "invalid role")
    require(len({c["id"] for c in cards}) == len(cards), "duplicate problem ID")
    return sorted(cards,key=lambda c:c["priority"])


def verify_record(record):
    card = record["problem"]
    current = next((c for c in catalog() if c["id"] == card["id"]), None)
    require(current == card, "card differs from independently stored registry")
    result = CHECKERS[card["family"]](card,record["witness"])
    require(result == record["result"], "stored result failed replay")
    if card["role"] == "control":
        if card["family"] == "thomson":
            require(Q(result["lower"]) == Q(result["upper"]) == Q(card["baseline"]), "failed energy control")
        else:
            require(Q(result["score"]) == Q(card["baseline"]), "failed sign control")
    return result


def ollama(path, payload=None, timeout=90):
    req = urllib.request.Request("http://127.0.0.1:11434/api/"+path, data=(
        json.dumps(payload).encode() if payload is not None else None),headers={"Content-Type":"application/json"})
    with urllib.request.urlopen(req,timeout=timeout) as r:
        return json.load(r)


def propose(record, limits, history, model):
    schema = {"type":"object","properties":{key:{"type":"integer","minimum":lo,"maximum":hi}
              for key,(lo,hi,_) in limits.items()},"required":list(limits),"additionalProperties":False}
    prompt = ("Design one bounded computational experiment. Return integer search parameters as JSON. "
              "For sphere instances maximize the lower bound and minimize the upper bound. "
              "degree is the Legendre LP degree, restarts and jitter_pct control the geometry search. "
              "For Werner states minimize the exact score; support is the number of nonzero entries "
              "per factor, mutate_pct is the percentage of local edits, samples is the trial budget. "
              "Use previous attempts to choose a different useful experiment.\n"
              + json.dumps({"problem":record["problem"],"prior_attempts":history,"parameters":limits}))
    record["prompt"] = prompt
    reply = ollama("generate",dict(model=model, prompt=prompt,format=schema,stream=False,
                    options={"num_predict":160,"num_ctx":4096,"seed":record["seed"],"temperature":0.5}))
    record["response"] = {k:reply.get(k) for k in ("model","response","done_reason","prompt_eval_count","eval_count")}
    params = json.loads(reply["response"])
    require(set(params)==set(limits), "model returned incorrect parameter keys")
    for k,(lo,hi,_) in limits.items():
        require(type(params[k]) is int and lo <= params[k] <= hi, "model parameter outside budget")
    return params


def records(out):
    return [load(p) for p in sorted(out.glob("*.json"))]


def run_one(args, card, round_no, version, model_digest, env):
    from search import SEARCH, PARAMS
    seed = args.seed + round_no
    spec = dict(problem=card, seed=seed, engine=args.model or "baseline",model_digest=model_digest,
                implementation=version,environment=env)
    # Each round sees completed earlier rounds plus the paired baseline if present.
    history = [dict(key=r["key"],params=r.get("params"),result=r.get("result"),error=r.get("error"))
               for r in records(args.out) if r["problem"]==card and r["seed"]<=seed
               and ((r["engine"]=="baseline" and args.model) or
                    (r["engine"]==spec["engine"] and r["seed"]<seed))][-8:] if args.model else []
    key = digest([spec,history])
    path = args.out/(card["id"]+"-"+key[:16]+".json")
    with (args.out/(".lock-"+key)).open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        if path.exists():
            old = load(path)
            if "error" not in old:
                verify_record(old)
                return "cached"
            if not args.retry_errors:
                raise ValueError("prior error; use --retry-errors: "+old["error"])
            backup = args.out/"failed"
            backup.mkdir(exist_ok=True)
            write(backup/(key+"-"+digest(old)[:12]+".json"),old)
        rec = dict(spec,key=key,history=history,time=datetime.now(timezone.utc).isoformat())
        try:
            family = card["family"]
            limits = PARAMS[family]
            rec["params"] = (propose(rec,limits,history,args.model) if args.model else
                             {k:v[2] for k,v in limits.items()})
            rec["witness"] = SEARCH[family](card,rec["params"],seed)
            rec["result"] = CHECKERS[family](card,rec["witness"])
            verify_record(rec)
        except Exception as exc:
            rec["error"] = str(exc)
            write(path,rec)
            raise
        write(path,rec)
    return rec["result"]["status"]


def run(args):
    import numpy, scipy
    cards = [c for c in catalog() if not args.only or c["id"] in args.only]
    if args.only:
        require(set(args.only)=={c["id"] for c in cards}, "unknown problem ID")
    require(1<=args.workers<=16 and 1<=args.rounds<=100 and 0<=args.seed<2**31-100, "invalid batch size or seed")
    if args.model:
        installed = {m["name"]:m["digest"] for m in ollama("tags")["models"]}
        require(args.model in installed,"model must already be installed in local Ollama")
    version = {f:hashlib.sha256((ROOT/f).read_bytes()).hexdigest() for f in ("search.py","verify.py","lab.py")}
    env = dict(python=platform.python_version(),numpy=numpy.__version__,scipy=scipy.__version__)
    args.out.mkdir(parents=True,exist_ok=True)
    failed = 0
    for round_no in range(args.rounds):
        for role in ("control","research"):
            group = [c for c in cards if c["role"]==role]
            with ThreadPoolExecutor(args.workers) as pool:
                jobs = [(c,pool.submit(run_one,args,c,round_no,version,installed[args.model] if args.model else None,env)) for c in group]
                for c,job in jobs:
                    try:
                        print(c["id"],job.result(),flush=True)
                    except Exception as exc:
                        print(c["id"],str(exc),file=sys.stderr)
                        failed += 1
            if failed and role=="control":
                raise ValueError("control or infrastructure failure; inspect saved error")
    return int(bool(failed))


def report(out):
    data = records(out)
    require(data,"empty campaign")
    print("# Physics campaign results\n")
    print("Each successful attempt below replayed against the local problem registry. Energy bounds in this table are rounded for display. Witness files contain exact fractions.\n")
    print("| Problem | Role | Attempts | Best checked result | Reference / interpretation |")
    print("|---|---|---:|---|---|")
    for c in catalog():
        rows = [r for r in data if r["problem"]["id"]==c["id"] and "error" not in r]
        if not rows:
            continue
        results = [verify_record(r) for r in rows]
        if c["family"]=="thomson":
            lo = max(Q(r["lower"]) for r in results)
            hi = min(Q(r["upper"]) for r in results)
            require(lo<=hi,"contradictory cross-run bounds")
            val = f"{float(lo):.8f} to {float(hi):.8f}"
            ref = c["baseline"]+" (reference energy)"
        else:
            v = min(Q(r["score"]) for r in results)
            val = f"minimum sampled score {v}"
            ref = ("known distillable control" if c["role"]=="control" else
                   ("negative witness for review" if v<0 else "no negative witness found"))
        print(f'| {c["id"]} | {c["role"]} | {len(rows)} | {val} | {ref} |')
    errors = [r for r in data if "error" in r]
    print(f"\n{len(data)-len(errors)} completed attempts, {len(errors)} current errors.")
    for r in errors:
        print(f'- {r["problem"]["id"]}: {r["error"]}')
    return int(bool(errors))


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out",type=Path,default=ROOT/"pilot")
    sub = ap.add_subparsers(dest="action",required=True)
    p = sub.add_parser("run")
    p.add_argument("--only",nargs="+")
    p.add_argument("--rounds",type=int,default=1)
    p.add_argument("--workers",type=int,default=1)
    p.add_argument("--seed",type=int,default=42)
    p.add_argument("--model",help="locally installed Ollama model tag")
    p.add_argument("--retry-errors",action="store_true")
    sub.add_parser("report")
    sub.add_parser("replay")
    p = sub.add_parser("check",help="check an externally proposed JSON witness against a registered card")
    p.add_argument("problem")
    p.add_argument("witness",type=Path)
    args=ap.parse_args()
    if args.action=="run":
        return run(args)
    if args.action=="report":
        return report(args.out)
    if args.action=="check":
        c = next((c for c in catalog() if c["id"]==args.problem),None)
        require(c is not None,"unknown problem")
        print(json.dumps(CHECKERS[c["family"]](c,load(args.witness)),indent=2))
        return 0
    data = records(args.out)
    require(data,"empty campaign")
    for r in data:
        require("error" not in r,f'failed attempt {r["key"]}')
        verify_record(r)
    print(f"Replayed {len(data)} saved witnesses successfully.")


if __name__=="__main__":
    sys.exit(main())
