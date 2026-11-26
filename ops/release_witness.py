"""Trusted main-branch grading. Research receipts are data, never imported code."""
import argparse
import json
from pathlib import Path
import re
import sys
import subprocess
from urllib.parse import urlsplit

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from lab import write
from ops.witness import contracts,fingerprint,replay


def package(record,research_commit,checker_commit):
    for rev in (research_commit,checker_commit):
        if not re.fullmatch(r"[a-f0-9]{40}",rev):
            raise ValueError("Expected an immutable Git revision")
    pid=record["problem_id"]
    contract=contracts()[pid]
    if (contract["mode"] not in ("full_counterexample","full_construction","full_optimum") or
            record["status"]!="ready_for_replay" or record["contract_hash"]!=fingerprint(contract)):
        raise ValueError("Full target, current statement and completed reviews are required")
    last=record["attempts"][-1]
    obj=last["witness"]
    if fingerprint(obj)!=last["witness_hash"] or fingerprint(json.loads(last["proposal"]["witness_json"]))!=last["witness_hash"]:
        raise ValueError("Review and execution identify different witnesses")
    math=last["math_review"]
    prior=last["priority_review"]
    if (math["verdict"]!="pass" or not math["hypotheses"].strip() or not math["weakest_step"].strip()
        or prior["verdict"]!="clear_within_search" or not prior["comparison"].strip()):
        raise ValueError("Mathematical or prior-work review missing")
    sources=json.loads(prior["sources"])
    if not isinstance(sources,list) or not sources or not all(
            isinstance(s,str) and urlsplit(s).scheme=="https" and urlsplit(s).hostname for s in sources):
        raise ValueError("Missing literature comparison sources")
    result=replay(pid,obj)
    if result["decisive"] is not True or fingerprint(result)!=fingerprint(last["result"]):
        raise ValueError("Trusted checker did not reproduce a decisive result")
    return dict(problem_id=pid,scope="full",kind=contract["mode"],statement=contract["statement"],
                source=contract["source"],locator=contract["locator"],implication=contract["implication"],
                contract_hash=fingerprint(contract),witness=obj,result=result,checker_commit=checker_commit,
                research_commit=research_commit,math_review=math,priority_review=prior,
                priority_scope="bounded search; priority is distinct from witness correctness")


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("packet",type=Path)
    parser.add_argument("research_commit")
    parser.add_argument("checker_commit")
    args=parser.parse_args()
    incoming=json.loads(args.packet.read_text())
    record=package(incoming,args.research_commit,args.checker_commit)
    pid=record["problem_id"]
    if subprocess.check_output(["git","rev-parse","HEAD"],cwd=ROOT,text=True).strip()!=args.checker_commit:
        raise ValueError("Checker revision differs from checked-out publication branch")
    ref=args.research_commit+":campaign/proof-flow/"+pid+"-"+record["contract_hash"][:16]+".json"
    original=json.loads(subprocess.check_output(["git","show",ref],cwd=ROOT,text=True))
    if fingerprint(original)!=fingerprint(incoming):
        raise ValueError("Witness packet differs from the recorded research commit")
    directory=ROOT/"certificates"
    path=directory/(pid+".json")
    if path.exists():
        existing=load_existing(path)
        if existing["contract_hash"]!=record["contract_hash"] or replay(pid,existing["witness"])!=existing["result"] or existing["result"]["decisive"] is not True:
            raise ValueError("Conflicting existing certificate")
        record=existing
    else:
        write(path,record)
    index=load_existing(directory/"index.json")
    index[record["problem_id"]]=dict(title=record["statement"],file=path.name,
                                      source=record["source"],kind=record["kind"])
    write(directory/"index.json",index)


def load_existing(path):
    return json.loads(path.read_text())


if __name__=="__main__":
    main()
