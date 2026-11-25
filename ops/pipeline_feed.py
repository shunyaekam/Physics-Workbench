"""Build the public read-only dashboard feed from the completed research receipts."""
from datetime import datetime, timezone
from fractions import Fraction
from pathlib import Path
from urllib.parse import urlsplit
import json
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from lab import load, write
from verify import require

GITHUB = "https://github.com/shunyaekam/Physics-Workbench/blob/"
OPTICAL = "gagatsos-2026-c1"
WERNER = "werner-endpoint"
TITLES = {OPTICAL: "Wigner–Husimi inequality", WERNER: "Undistillable entanglement"}


def source_key(url):
    parsed = urlsplit(url)
    require(parsed.scheme == "https" and parsed.hostname, "Expected an HTTPS source")
    if parsed.hostname == "arxiv.org":
        match = re.fullmatch(r"/(?:abs|html|pdf)/(\d{4}\.\d{4,5})(?:v\d+)?(?:\.pdf)?", parsed.path)
        if match:
            return "arxiv:" + match[1]
    return url.rstrip("/")


def artifact(root, relative):
    path = relative.partition("#")[0]
    require(not Path(path).is_absolute() and ".." not in Path(path).parts
            and (root/path).is_file(), f"Missing evidence file {relative}")
    return GITHUB + "research/" + relative


def row(ident, title, status, url, detail, **extra):
    require(all(isinstance(x, str) and x.strip() for x in (ident, title, status, detail)), "Incomplete row")
    source_key(url)
    return dict(id=ident, title=title, status=status, url=url, detail=detail, **extra)


def tally(value):
    require(type(value) is int and value >= 0, "Invalid evaluation count")
    return value


def published_solution(root, solution, targets):
    """An explicit editorial record must point to artifacts already landed on main."""
    pid = solution["problem_id"]
    target = targets[pid]
    sha = solution["publication_commit"]
    require(re.fullmatch(r"[0-9a-f]{40}", sha), "Expected full publication revision")
    require(re.fullmatch(r"[a-z0-9-]+",pid), "Invalid resolution id")
    subprocess.run(["git","merge-base","--is-ancestor",sha,"origin/main"], cwd=root, check=True)
    # The editorial decision itself must have landed on main. Search output
    # and editable research-branch metadata cannot determine this decision.
    manifest = "discovery/resolutions/" + pid + ".json"
    solution = json.loads(subprocess.check_output(["git","show",sha+":"+manifest], cwd=root, text=True))
    require(solution["problem_id"] == pid and solution["scope"] == "full"
            and solution["statement"] == target["question"] and solution["source"] == target["source"]
            and solution["decision"] == "accepted" and solution["prior_art_verdict"] == "cleared"
            and solution["math_verdict"] == "accepted", "Solution scope or decision mismatch")
    require(solution["proof_author"].strip() and solution["math_reviewer"].strip()
            and solution["proof_author"].strip().casefold() != solution["math_reviewer"].strip().casefold(),
            "Independent reviewer attribution required")
    links = {}
    paths = [solution[key] for key in ("proof","independent_review","priority_audit")]
    require(len(set(paths)) == 3, "Separate proof, review and prior-art records required")
    for key, path in zip(("proof","independent_review","priority_audit"), paths):
        require(re.fullmatch(r"[\w./-]+", path) and not Path(path).is_absolute()
                and ".." not in Path(path).parts, "Invalid evidence path")
        size = subprocess.check_output(["git","cat-file","-s",sha+":"+path], cwd=root, text=True)
        kind = subprocess.check_output(["git","cat-file","-t",sha+":"+path], cwd=root, text=True)
        require(kind.strip()=="blob" and int(size)>0, "Empty publication evidence")
        links[key] = GITHUB+sha+"/"+path
    return row(target["id"],solution["title"],"reviewed_resolution",links["proof"],
               solution["statement"],problem_id=target["id"],source=target["source"],evidence=links,decision_url=GITHUB+sha+"/"+manifest)


def build(root, now):
    cards = load(root/"discovery/targets.json")
    targets = {c["id"]: c for c in cards}
    require(len(cards) == len(targets), "Duplicate external problem id")
    problems, leads, candidates, partial, activity = [], [], [], [], []
    seen = set()
    for tid, t in targets.items():
        require(t["role"] == "external_problem", "Unscreened target")
        seen.add(source_key(t["source"]))
        problems.append(row(tid, t.get("title") or TITLES.get(tid,tid), "under_investigation",
                            t["source"], t["significance"], source=t["source"], question=t["question"],
                            decisive_test=t["full_vs_partial"]))
    for file in sorted((root/"campaign/intake").glob("[0-9]*-W[0-9]*.json"), reverse=True):
        for card in load(file):
            key = source_key(card["source"])
            if key not in seen:
                leads.append(row(card["id"],card["title"],"unreviewed_lead",card["source"],
                                 card["question"].removeprefix("Extract a small falsifiable subproblem from this attributed abstract sentence: "),
                                 receipt=artifact(root,str(file.relative_to(root)))))
                seen.add(key)

    ledger = load(root/"discovery/pipeline-results.json")
    exclusions = []
    for claim in ledger.get("exclusions", []):
        require(claim["problem_id"] in targets and claim["status"] == "prior_art", "Invalid excluded claim")
        evidence = {key: artifact(root,claim[key]) for key in ("proof","math_review","priority_audit")}
        exclusions.append(row(claim["id"],claim["title"],claim["status"],evidence["priority_audit"],
                              claim["detail"], problem_id=claim["problem_id"], reviewed_on=claim["reviewed_on"],
                              review_url=evidence["math_review"], priority_url=evidence["priority_audit"],
                              evidence=evidence))
    excluded_ids = {item["id"] for item in exclusions}
    require(len(excluded_ids) == len(exclusions), "Duplicate exclusion")
    for pid, ident, title, detail, path in ledger["partial_results"]:
        require(ident not in excluded_ids, "Excluded claim listed as a partial result")
        require(pid in targets,"Unregistered claim target")
        result = row(ident,title,"scoped_result",artifact(root,path),detail,problem_id=pid)
        partial.append(result)
    solutions = [published_solution(root,s,targets) for s in ledger["solutions"]]
    solved = {s["id"] for s in solutions}
    require(len(solved)==len(solutions),"Duplicate full resolution")
    for problem in problems:
        if problem["id"] in solved:
            problem["status"] = "reviewed_resolution"

    counts = {"werner":0, "coherent-cats":0, "coherent-bands":0, "three-level":0}
    def record(path, ident, title, status, detail, pid, flag=False, date=None):
        item = row(ident,title,status,artifact(root,str(path.relative_to(root))),detail,problem_id=pid)
        if date:
            item["updated_at"] = date
        if flag:
            candidates.append(item)
        return item

    # Each optical arm numbers its batches independently. Show the most recent
    # batch in each arm without inferring a cross-arm order from file mtimes.
    for family, label in (("coherent-bands","Coherent-band screen"),("three-level","Three-level screen")):
        recent = None
        for file in sorted((root/"campaign"/family).glob("*.json")):
            r = load(file)
            n = tally(r["tested"])
            counts[family] += n
            flag = r["status"] == "needs_rigorous_enclosure"
            require(flag or r["status"]=="screen_only", "Unknown optical screen status")
            recent = record(file,family+"-"+file.stem,label,r["status"],
                            f"{n} states tested on photon levels {', '.join(map(str,r['levels']))}.",
                            OPTICAL,flag)
        if recent:
            activity.append(recent)

    last_round = None
    for file in sorted((root/"campaign/rounds").glob("*.json")):
        r = load(file)
        for q in r["quantum"]:
            counts["werner"] += tally(q["evaluated"])
            if Fraction(q["score"]) < 0:
                record(file,f"werner-{r['round']}-{q['k']}","Negative Werner expectation",
                       "needs_scope_review",f"Exact score {q['score']} at {q['k']} copies.",WERNER,True,r["utc"])
        for i, w in enumerate(r.get("wigner",[])):
            counts["coherent-cats"] += tally(w["states"])
            if w["status"]=="needs_interval_check":
                record(file,f"cats-{r['round']}-{i}","Positive optical residual",
                       w["status"],"A numerical finalist requires certified integration.",OPTICAL,True,r["utc"])
            else:
                require(w["status"]=="no_positive_refined_residual","Unknown Wigner screen status")
        last_round = record(file,"round-"+str(r["round"]),f"Research round {r['round']}","completed",
                            f"{sum(q['evaluated'] for q in r['quantum']):,} Werner vectors evaluated.",
                            WERNER,date=r["utc"])
    if last_round:
        activity.insert(0,last_round)
    lane_rows = []
    for file in sorted((root/"campaign/agent-lanes").glob("*.json")):
        lane = load(file)
        pid = lane["problem_id"]
        require(pid in targets,"Unknown lane target")
        lane_rows.append(record(file,"lane-"+file.stem,TITLES.get(pid,pid)+" agent handoff",
                           lane["status"],"AI research proposal and critique workflow.",
                           pid,date=lane["updated_at"]))
    activity.extend(sorted(lane_rows,key=lambda x:x["updated_at"],reverse=True)[:4])

    return dict(schema_version=1,updated_at=now,counts=dict(leads=len(leads),problems=len(problems),
        attempts=sum(counts.values()),candidates=len(candidates),partial_results=len(partial),solutions=len(solutions),exclusions=len(exclusions)),
        evaluations=counts,attempts_definition="Recorded search evaluations across the four listed arms. Repeated states may occur.",
        problems=problems,leads=leads,partial_results=partial,solutions=solutions,
        candidates=candidates,activity=activity,exclusions=exclusions)


if __name__ == "__main__":
    feed = build(ROOT, datetime.now(timezone.utc).isoformat(timespec="seconds"))
    write(ROOT/"campaign/pipeline.json", feed)
    print("Dashboard feed:",feed["counts"])
