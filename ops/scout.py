"""Screen one external intake lead against primary sources within the shared model quota."""
import json
import re
from pathlib import Path
import sys
from urllib.parse import urlsplit

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from lab import load,write
from ops.witness import fingerprint


def source_key(url):
    parsed=urlsplit(url)
    if parsed.hostname=="arxiv.org":
        match=re.fullmatch(r"/(?:abs|html|pdf)/(\d{4}\.\d{4,5})(?:v\d+)?(?:\.pdf)?",parsed.path)
        if match:
            return "arxiv:"+match[1]
    return url.rstrip("/").replace("open-quantum-problems.vercel.app","openquantumproblems.com")


def eligible(row):
    scope=row.get("physics") or row["source"] in {"IQOQI Vienna","QIQCOP Zoo"} or "mathematical physics" in row.get("topics",[])
    status=row.get("status","").lower()
    return scope and row.get("kind") in {"problem","catalogue"} and status in {
        "open","unsolved","active","improved","partially resolved","partially solved","partial","partially open"}


def pending(root):
    cards=load(root/"discovery/targets.json")
    admitted={source_key(c["source"]) for c in cards}
    catalogue_links={source_key(url) for c in cards for url in c["evidence_checked"]}
    frontier_path=root/"checks/left_to_solve/frontier.json"
    frontier={r["problem"]:r for r in load(frontier_path)} if frontier_path.exists() else {}
    pool=[]
    for index in sorted((root/"campaign/catalogue-index").glob("*.json")):
        for row in load(index)["rows"]:
            if not eligible(row) or source_key(row["url"]) in catalogue_links:
                continue
            title=row["title"].lower()
            # This is a reading order for a literature scout, not a difficulty estimate.
            concrete=any(word in title for word in ("counterexample","construction","circuit","finite-dimensional","smallest"))
            lead=dict(id=row["id"],source=row["url"],question=row["title"],title=row["title"],
                      catalogue=row["source"],listed_status=row.get("status"))
            manageable=str(row.get("difficulty","")).startswith(("1/5","2/5"))
            if row["source"] == "Left to Solve":
                lead["primary_source"] = row.get("primary_source")
                lead["task_kind"] = row["task_kind"]
                lead["desk_difficulty"] = row.get("difficulty")
                candidate=frontier.get(row["id"].removeprefix("lts-"))
                if candidate:
                    lead.update(question=candidate["target"],decisive_test=candidate["decisive_test"],
                                prior_source=candidate["prior_source"],blocker=candidate["blocker"])
                    pool.append((-2,lead))
                    continue
                # Finite-width models admit exact transfer-matrix tests at every length.
                finite_strip = any(token in title for token in ("grid", "strip", "prudent")) and (
                    any(token in title for token in ("self-avoiding", "self avoiding", "prudent")))
                if finite_strip:
                    pool.append((-1,lead))
                    continue
                # An existing exact target or an elementary OEIS claim can be checked first.
                if row.get("difficulty") is not None and row["difficulty"] <= 45 and (
                        row["task_kind"] in {"known", "warmup"} or row["origin"].startswith("OEIS")):
                    pool.append((0,lead))
                    continue
            pool.append((0 if manageable and concrete else 1 if concrete else 3,lead))
    for batch in sorted((root/"campaign/intake").glob("*.json"),reverse=True):
        pool.extend((2,lead) for lead in load(batch))
    for _,lead in sorted(pool,key=lambda pair:(pair[0],pair[1].get("desk_difficulty") or 100,pair[1]["id"])):
        if source_key(lead["source"]) in admitted:
            continue
        identity=([lead["catalogue"],lead["id"],lead["question"],lead["listed_status"]] if "catalogue" in lead
                  else [lead["source"],lead["question"]])
        key=fingerprint(identity)[:24]
        path=root/"campaign/scouting"/(key+".json")
        if not path.exists():
            return lead,path
    return None


def screen(job,ask):
    lead,path=job
    fields=("statement","significance","settlement_test","aliases","verdict","primary_sources")
    prompt=("Search primary sources for the exact statement, alternative names, later versions and prior "
            "solutions. State the quantifiers and what finding would settle it. Return verdict shortlist, "
            "prior_resolution, duplicate or insufficient_evidence. Record primary_sources as a JSON list "
            "of HTTPS URLs you consulted. This is intake, with no automatic solution credit.\n"+json.dumps(lead))
    if lead.get("catalogue") == "Left to Solve":
        fields += ("attempt", "proof_or_witness", "remaining_obligation")
        prompt += ("\nAttempt the physics problem in this same session. Consult its /agent.txt brief "
                   "and the original source. For an existing Lean target, work against its exact "
                   "declaration, including all hypotheses; for an unformalized one, derive or refute "
                   "the source statement. Use the isolated notebook for calculations. Preserve a "
                   "candidate proof or explicit counterexample, or the strongest concrete failure. "
                   "State what remains for an independent checker. Identify earlier solutions with "
                   "attribution. This output is a research draft.")
        result=ask(prompt,fields,sources=True,notebook=("checks/left_to_solve/targets.json",))
    else:
        result=ask(prompt,fields,sources=True)
    links=json.loads(result["primary_sources"])
    if (result["verdict"] not in ("shortlist","prior_resolution","duplicate","insufficient_evidence")
         or not isinstance(links,list) or not links or not all(isinstance(u,str) and urlsplit(u).scheme=="https"
                                                              and urlsplit(u).hostname for u in links)):
        raise ValueError("Incomplete source screen")
    path.parent.mkdir(exist_ok=True)
    write(path,dict(lead=lead,review=result))

    if lead.get("catalogue") == "Left to Solve":
        feed = path.parents[1]/"left-to-solve"/"latest.json"
        feed.parent.mkdir(exist_ok=True)
        receipts = load(feed) if feed.exists() else []
        receipt = dict(key=path.stem, title=lead["title"], verdict=result["verdict"])
        write(feed, [receipt]+[r for r in receipts if r["key"]!=receipt["key"]][:19])
