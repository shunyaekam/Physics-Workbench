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


def records(out):
    return [load(p) for p in sorted(out.glob("*.json"))]


def run_one(args, card, round_no, version, env):
    from search import SEARCH, PARAMS
    seed = args.seed + round_no
    spec = dict(problem=card, seed=seed, engine="baseline",model_digest=None,
                implementation=version,environment=env)
    history = []
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
            rec["params"] = {k:v[2] for k,v in limits.items()}
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
    version = {f:hashlib.sha256((ROOT/f).read_bytes()).hexdigest() for f in ("search.py","verify.py","lab.py")}
    env = dict(python=platform.python_version(),numpy=numpy.__version__,scipy=scipy.__version__)
    args.out.mkdir(parents=True,exist_ok=True)
    failed = 0
    for round_no in range(args.rounds):
        for role in ("control","research"):
            group = [c for c in cards if c["role"]==role]
            with ThreadPoolExecutor(args.workers) as pool:
                jobs = [(c,pool.submit(run_one,args,c,round_no,version,env)) for c in group]
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
