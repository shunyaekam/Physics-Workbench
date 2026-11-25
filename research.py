"""Batch open-ended research notes for a curated registry, including other fields."""
import argparse
import fcntl
import hashlib
import json
from pathlib import Path

from lab import ROOT, digest, load, ollama, records, verify_record, write
from verify import CHECKERS, require


def response(model, prompt, fields, seed):
    schema = {"type":"object","properties":{k:{"type":"string","minLength":1} for k in fields},
              "required":fields,"additionalProperties":False}
    reply = ollama("generate",{"model":model,"prompt":prompt,"format":schema,"stream":False,
                               "options":{"seed":seed,"num_ctx":8192,"num_predict":1200}})
    data = json.loads(reply["response"])
    require(set(data)==set(fields) and all(isinstance(x,str) and x.strip() for x in data.values()),
            "incomplete research note")
    return {"prompt":prompt,"text":data,"tokens_in":reply.get("prompt_eval_count"),
            "tokens_out":reply.get("eval_count")}


def brief(card, evidence):
    return {"question":card["question"],"scope":card["scope"],
            "sources_for_human_check":[card["source"],card["prior_art"]],
            "checked_evidence":evidence,
            "request":"Produce a scoped, falsifiable advance. Specify assumptions, one lemma or witness, "
            "a short derivation, the easiest way it could fail, and an independently executable check. "
            "Use only supplied facts. Treat URLs as pointers. Label unverified statements as conjectural."}


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--catalog",type=Path,default=ROOT/"problems.json")
    ap.add_argument("--evidence",type=Path,default=ROOT/"pilot")
    ap.add_argument("--out",type=Path,default=ROOT/"notes")
    ap.add_argument("--only",nargs="+")
    ap.add_argument("--model",default="llama3.2:3b")
    ap.add_argument("--seed",type=int,default=42)
    ap.add_argument("--packet",action="store_true",help="export prompts for a different model or a human")
    args=ap.parse_args()
    cards=load(args.catalog)
    require(len(cards)==len({c["id"] for c in cards}),"duplicate problem ID")
    if args.only:
        cards=[c for c in cards if c["id"] in args.only]
        require({c["id"] for c in cards}==set(args.only),"unknown problem ID")
    available=records(args.evidence)
    if not args.packet:
        models={m["name"]:m["digest"] for m in ollama("tags")["models"]}
        require(args.model in models,"install the local model before running")
        args.out.mkdir(exist_ok=True,parents=True)
    failed=False
    for c in cards:
        require(all(isinstance(c.get(k),str) and c[k].strip()
                    for k in ("id","question","scope","source","prior_art","checked_on")),
                "card needs a scoped question, source, prior art, and status-check date")
        evidence=[{"witness_key":r["key"],"result":verify_record(r)} for r in available
                  if r.get("problem")==c and "error" not in r and c.get("family") in CHECKERS]
        packet=brief(c,evidence)
        if args.packet:
            print(json.dumps(packet,indent=2))
            continue
        key=digest([c,packet,args.model,models[args.model],args.seed,
                    hashlib.sha256(Path(__file__).read_bytes()).hexdigest()])
        path=args.out/(key+".json")
        with (args.out/(".lock-"+key)).open("w") as lock:
            fcntl.flock(lock,fcntl.LOCK_EX)
            if path.exists() and load(path)["status"]=="needs_review":
                print(c["id"],"cached")
                continue
            rec=dict(problem=c,model=args.model,model_digest=models[args.model],seed=args.seed,
                     status="incomplete",key=key)
            if path.exists():
                rec=load(path)
                rec.pop("error",None)
            try:
                if "proposal" not in rec:
                    rec["proposal"]=response(args.model,json.dumps(packet),
                        ["subclaim","assumptions","derivation","falsifier","next_check"],args.seed)
                    write(path,rec)
                prompt=("Audit this untrusted proposal. Derive a boundary case, identify the earliest "
                        "unsupported step and check whether the subclaim would imply the target. "
                        "State remaining evidence needed. You cannot execute code or access cited sources.\n"
                        +json.dumps({"packet":packet,"proposal":rec["proposal"]["text"]}))
                rec["critique"]=response(args.model,prompt,["boundary_case","gap","scope_match","next_check"],args.seed+1)
                rec["status"]="needs_review"
            except Exception as exc:
                rec["error"]=str(exc)
                failed=True
            write(path,rec)
            print(c["id"],rec["status"],flush=True)
    return int(failed)


if __name__=="__main__":
    raise SystemExit(main())
