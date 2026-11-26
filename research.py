"""Export research briefs for a curated registry, including other fields."""
import argparse
import json
from pathlib import Path

from lab import ROOT, load, records, verify_record
from verify import CHECKERS, require


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
    ap.add_argument("--only",nargs="+")
    ap.add_argument("--packet",action="store_true",help="export prompts for a different model or a human")
    args=ap.parse_args()
    cards=load(args.catalog)
    require(len(cards)==len({c["id"] for c in cards}),"duplicate problem ID")
    if args.only:
        cards=[c for c in cards if c["id"] in args.only]
        require({c["id"] for c in cards}==set(args.only),"unknown problem ID")
    available=records(args.evidence)
    for c in cards:
        require(all(isinstance(c.get(k),str) and c[k].strip()
                    for k in ("id","question","scope","source","prior_art","checked_on")),
                "card needs a scoped question, source, prior art, and status-check date")
        evidence=[{"witness_key":r["key"],"result":verify_record(r)} for r in available
                  if r.get("problem")==c and "error" not in r and c.get("family") in CHECKERS]
        print(json.dumps(brief(c,evidence),indent=2))


if __name__=="__main__":
    raise SystemExit(main())
