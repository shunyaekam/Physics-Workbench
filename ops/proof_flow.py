"""Persist one executable attempt, independent reviews, and the next scientific decision."""
from datetime import datetime, timezone
import fcntl
import json
import subprocess
import shutil
from pathlib import Path
import sys

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from lab import load, write
from ops.hosted import generate, HourlyLimit, MODEL
from ops.witness import contracts, fingerprint, replay

OUT=ROOT/"campaign/proof-flow"
LIMIT=4
PRIORITY_FIELDS=("verdict","sources","comparison")
MATH_FIELDS=("verdict","hypotheses","weakest_step")
SOLVER_FIELDS=("approach","witness_json","derivation","what_would_change")
NOTEBOOK={
    "wei-12-3-4":["checks/small_qec/target.py","checks/small_qec/verify.py","checks/small_qec/dual.py"],
    "wei-12-4-4":["checks/small_qec/target.py","checks/small_qec/verify.py","checks/small_qec/dual.py"],
    "transport-polygon":["formal/transport_literal/attempt.py","papers/transport-polygon.md"],
    "e27-schmidt":["checks/schmidt_orbit.py","checks/schmidt-orbit.md"],
    "golay43":["checks/golay43.py","checks/golay_certificate.py","checks/golay/frontier_v2.md","checks/golay/css_peeling.py","checks/golay/css_peeling.md","discovery/inputs/golay-44.json","lab.py","verify.py"],
    "refined-bmv":["checks/bmv_certificate.py","checks/bmv_search.py","lab.py","verify.py"],
    "werner-endpoint":["checks/werner_witness.py","complex_search.py","verify.py"],
    "gagatsos-2026-c1":["three_level_search.py","wigner_search.py","lab.py","verify.py"]}


def now():
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def answer(prompt, fields, **opts):
    schema={"type":"object","properties":{k:{"type":"string"} for k in fields},
            "required":list(fields),"additionalProperties":False}
    result=generate(prompt,schema,**opts)
    if not isinstance(result,dict) or set(result)!=set(fields) or not all(
            isinstance(v,str) and 0<len(v.strip())<=80000 for v in result.values()):
        raise ValueError("Incomplete or oversized research response")
    return result


def execute(pid,contract,proposal,earlier):
    item=dict(proposal=proposal,checked_at=now())
    try:
        data=json.loads(proposal["witness_json"])
        key=fingerprint(data)
        if any(e.get("witness_hash")==key for e in earlier):
            raise ValueError("This exact object was already tested")
        item.update(witness=data,witness_hash=key)
        item["result"]=replay(pid,data)
        if item["result"]["decisive"] and not contract["mode"].startswith("full_"):
            raise ArithmeticError("Checker tried to exceed its registered scope")
    except (ValueError,KeyError,TypeError) as err:
        item["rejection"]=str(err)
    return item


def new_record(pid,contract):
    return dict(problem_id=pid,contract_hash=fingerprint(contract),model=MODEL,
                status="solve",attempts=[],updated_at="")


def summaries(record):
    return [{k:v for k,v in item.items() if k in ("proposal","result","rejection","math_review")}
            for item in record["attempts"][-LIMIT:]]


def advance_one(record,contract,card):
    pid=record["problem_id"]
    attempts=record["attempts"]
    stage=record["status"]
    contract=dict(contract)
    if pid=="transport-polygon":
        from formal.transport_literal.attempt import statement
        contract["fixed_lean_target"]=statement()
    packet=json.dumps({"contract":contract,"known":card["known"],"primary_sources":card["evidence_checked"],
                       "previous":summaries(record)},ensure_ascii=False)
    if stage=="solve":
        prompt=("You own this attempt. Read the registered question, derive a candidate from its definitions, "
                "and run a bounded experiment in your disposable notebook. You may write and run mathematical "
                "code there. Return one concrete JSON witness and the derivation, even after a failed search. "
                "Use a materially different construction after a negative result. The supplied checker "
                "will be rerun outside the notebook. State the logical scope of the calculation.\n"+packet)
        files=[name for name in NOTEBOOK[pid] if (ROOT/name).is_file()]
        if pid=="golay43":
            receipts=sorted((ROOT/"campaign/golay-focus").glob("*.json"))
            files.extend(str(path.relative_to(ROOT)) for path in receipts[-4:])
            prompt += ("\nUse the frontier report and the focus receipts if available. "
                       "The 44-gate circuit is the known control. Try a distinct construction "
                       "or a justified pruning argument that makes the 43-gate search smaller.")
        proposal=answer(prompt,SOLVER_FIELDS,notebook=files)
        attempt=execute(pid,contract,proposal,attempts)
        attempt["origin"]=MODEL+" hosted solver"
        attempts.append(attempt)
        record["status"]="math_review"
    elif stage=="math_review":
        review=answer("Independently rederive the implication, test the hypotheses and try to falsify the last "
                      "candidate. Inspect its executed outcome. Return verdict pass, revise, or park. A pass "
                      "for a full answer requires a decisive exact result. Name the critical next test.\n"+packet,
                      MATH_FIELDS)
        if review["verdict"] not in ("pass","revise","park"):
            raise ValueError("Unknown mathematical verdict")
        last=attempts[-1]
        last["math_review"]=review
        positive=last.get("result",{}).get("decisive") is True
        if positive and review["verdict"]=="pass":
            record["status"]="priority_review"
        elif last.get("result",{}).get("kernel_checked"):
            record["status"]="scoped_proof_checked"
        elif len(attempts)>=LIMIT or review["verdict"]=="park":
            record["status"]="parked"
        else:
            record["status"]="solve"
    elif stage=="priority_review":
        audit=answer("Check original sources using web search. Search aliases, source identifiers and existing "
                     "solutions. Compare the exact statement and witness to earlier work. Return verdict "
                     "clear_within_search, prior_resolution, or unresolved. The sources field must contain "
                     "a JSON array of primary HTTPS URLs actually consulted. State search limits.\n"+packet,
                     PRIORITY_FIELDS,sources=True)
        links=json.loads(audit["sources"])
        if (audit["verdict"] not in ("clear_within_search","prior_resolution","unresolved") or
                not isinstance(links,list) or not links or not all(isinstance(s,str) and s.startswith("https://") for s in links)):
            raise ValueError("Priority review lacks a verdict or source links")
        attempts[-1]["priority_review"]=audit
        record["status"]={"clear_within_search":"ready_for_replay","prior_resolution":"prior_resolution",
                          "unresolved":"priority_unresolved"}[audit["verdict"]]
    else:
        raise ValueError("Unknown active stage")
    record["updated_at"]=now()


def add_focus_circuit(rec,contract):
    for path in sorted((ROOT/"campaign/golay-focus").glob("*.json")):
        report=load(path)
        best=report["best"]
        if best["result"]["cnot_count"]>43 or not best["result"]["target_prepared"]:
            continue
        witness=best["witness"]
        if any(a.get("witness_hash")==fingerprint(witness) for a in rec["attempts"]):
            continue
        proposal=dict(approach=report["method"],witness_json=json.dumps(witness),
                      derivation=str(path.relative_to(ROOT)),what_would_change=contract["implication"])
        tested=execute("golay43",contract,proposal,rec["attempts"])
        tested["origin"]="focused circuit construction"
        rec["attempts"].append(tested)
        rec.update(status="math_review",updated_at=now())
        return True
    return False


def add_discovered_circuit(rec,contract):
    # A signed candidate from an unattended search deserves the same reviews as an AI witness.
    for family in ("golay-graphs","golay-splices","golay-splice-tails","golay-repairs"):
        for path in sorted((ROOT/"campaign"/family).glob("*.json")):
            data=load(path)
            if not data.get("forward_stim") or not (data.get("found") or data.get("cost",44)<=43):
                continue
            source=fingerprint(data["forward_stim"])
            if any(a.get("circuit_hash")==source for a in rec["attempts"]):
                continue
            uv=shutil.which("uv") or str(Path.home()/".local/bin/uv")
            run=subprocess.run([uv,"run","--offline","--with","stim==1.16.0","python",
                                str(ROOT/"checks/golay/stim_witness.py")],input=json.dumps(data),
                               text=True,capture_output=True,check=True,timeout=30)
            proposal=dict(approach="Signed circuit from "+family,witness_json=run.stdout,
                          derivation=str(path.relative_to(ROOT)),what_would_change=contract["implication"])
            tested=execute("golay43",contract,proposal,rec["attempts"])
            tested.update(circuit_hash=source,origin="signed circuit search")
            rec["attempts"].append(tested)
            rec.update(status="math_review",updated_at=now())
            return True
    return False


def dispatch(docket, scout_due, previous):
    """Review a decisive witness first. Alternate the focus investigation with the other work."""
    positives=[row for row in docket if not row[0]]
    if positives:
        return "review",min(positives)
    focus=[row for row in docket if row[3]=="golay43"]
    others=[row for row in docket if row[3]!="golay43"]
    if focus and previous!="focus":
        return "focus",min(focus)
    if scout_due:
        return "scout",None
    if others:
        return "rotation",min(others)
    if focus:
        return "focus",min(focus)
    return "idle",None


def tick():
    OUT.mkdir(exist_ok=True,parents=True)
    cards={c["id"]:c for c in load(ROOT/"discovery/targets.json")}
    docket=[]
    published=subprocess.run(["git","show","origin/main:certificates/index.json"],cwd=ROOT,
                             capture_output=True,text=True)
    closed=json.loads(published.stdout) if published.returncode==0 else {}
    for pid,contract in contracts().items():
        if pid in closed:
            continue
        if contract["statement"]!=cards[pid]["question"] or contract["source"]!=cards[pid]["source"]:
            raise ValueError("Target changed; re-register the exact checker contract: "+pid)
        path=OUT/(pid+"-"+fingerprint(contract)[:16]+".json")
        rec=load(path) if path.exists() else new_record(pid,contract)
        if pid=="golay43" and rec["status"] not in ("priority_review","ready_for_replay") and not (
            rec["attempts"] and rec["attempts"][-1].get("result",{}).get("decisive")
        ) and (add_focus_circuit(rec,contract) or add_discovered_circuit(rec,contract)):
            write(path,rec)
        if rec["status"] in ("solve","math_review","priority_review"):
            pending_positive=bool(rec["attempts"] and rec["attempts"][-1].get("result",{}).get("decisive"))
            docket.append((not pending_positive, rec["status"]=="solve" and bool(rec["attempts"]),
                           rec["updated_at"],pid,path,rec))
    from ops.scout import pending,screen
    lead=pending(ROOT)
    # One intake slot per UTC day if research is still in progress.
    day=now()[:10]
    marker=ROOT/"campaign/scouting"/("day-"+day+".json")
    history=ROOT/"campaign/agent-dispatch.json"
    previous=load(history).get("lane") if history.exists() else None
    lane,job=dispatch(docket,lead is not None and (not marker.exists() or not docket),previous)
    if lane=="scout":
        try:
            screen(lead,answer)
            write(marker,{"lead":lead[0]["source"]})
        except HourlyLimit as exc:
            print(exc)
            return
        except (ValueError, OSError, RuntimeError) as exc:
            marker.parent.mkdir(exist_ok=True)
            write(marker,{"lead":lead[0]["source"],"error":str(exc)})
        write(history,{"lane":lane,"source":lead[0]["source"],"at":now()})
        return
    if job is None:
        print("All registered attempts completed or parked")
        return
    *_,pid,path,rec=job
    assigned_stage=rec["status"]
    try:
        advance_one(rec,contracts()[pid],cards[pid])
        rec.pop("last_error",None)
    except HourlyLimit as err:
        print(err)
        return
    except (OSError,ValueError,RuntimeError) as err:
        rec.update(last_error=str(err),updated_at=now())
    write(path,rec)
    write(history,{"lane":lane,"problem_id":pid,"stage":assigned_stage,"at":now()})
    print(pid,rec["status"],rec.get("last_error",""))


if __name__=="__main__":
    OUT.mkdir(exist_ok=True,parents=True)
    with (OUT/".lock-coordinator").open("a") as lock:
        fcntl.flock(lock,fcntl.LOCK_EX)
        tick()
