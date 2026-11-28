"""Screen one external intake lead against primary sources within the shared model quota."""
from datetime import datetime, timezone
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
    scored_path = root/"campaign/left-to-solve/proof-queue.json"
    if scored_path.exists():
        from ops.lts_standings import recent
        scored = load(scored_path)
        fresh = recent(scored, datetime.now(timezone.utc), 2)
        from ops import lean_loop, proof_portfolio
        for i, row in enumerate(scored["targets"]):
            name = "lts-"+row["id"]
            helper = proof_portfolio.checked_helper(root) if name == lean_loop.TARGET else None
            if not fresh and not helper:
                continue
            lead = dict(id=name, source="https://lefttosolve.com/p/"+row["id"],
                        question=row["statement"], title=row["title"], catalogue="Left to Solve",
                        listed_status="scored-proof", task_kind=row["kind"], primary_source=row["source"],
                        points=row["points"], desk_difficulty=row["difficulty"], notebook=row.get("notebook", []))
            if helper:
                lead["checked_helper"] = helper
                lead["board_snapshot_fresh"] = fresh
            pool.append((-10000+i,lead))
    for index in sorted((root/"campaign/catalogue-index").glob("*.json")):
        for row in load(index)["rows"]:
            if not eligible(row) or source_key(row["url"]) in catalogue_links:
                continue
            title=row["title"].lower()
            # This is a reading order for a literature scout, not a difficulty estimate.
            concrete=any(word in title for word in ("counterexample","construction","circuit","finite-dimensional","smallest"))
            lead=dict(id=row["id"],source=row["url"],question=row["title"],title=row["title"],
                      catalogue=row["source"],listed_status=row.get("status"),topics=row.get("topics",[]))
            manageable=str(row.get("difficulty","")).startswith(("1/5","2/5"))
            if row["source"] == "Left to Solve":
                lead["primary_source"] = row.get("primary_source")
                lead["task_kind"] = row["task_kind"]
                lead["desk_difficulty"] = row.get("difficulty")
                candidate=frontier.get(row["id"].removeprefix("lts-"))
                if candidate:
                    lead.update(question=candidate["target"],decisive_test=candidate["decisive_test"],
                                prior_source=candidate["prior_source"],blocker=candidate["blocker"],
                                previous_attempt=candidate.get("attempt"))
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
    # Alternate completed scouting briefs; either queue can use an empty slot.
    history = sorted((root/"campaign/scouting").glob("*.json"),
                     key=lambda path: path.stat().st_mtime_ns, reverse=True)
    prefer_lab = not history or load(history[0])["lead"].get("catalogue") == "Left to Solve"
    def order(item):
        priority, lead = item
        lab = lead.get("catalogue") != "Left to Solve"
        subject = " ".join([lead.get("catalogue",""), lead["title"], *lead.get("topics",[])]).lower()
        focus = any(word in subject for word in ("quantum", "quant-ph", "gr-qc", "gravit", "spacetime",
                                                 "black hole", "entangl", "foundations", "relativity"))
        return (lab != prefer_lab, lab and not focus, priority, lead.get("desk_difficulty") or 100, lead["id"])
    for _,lead in sorted(pool,key=order):
        if source_key(lead["source"]) in admitted:
            continue
        identity=([lead["catalogue"],lead["id"],lead["question"],lead["listed_status"]] if "catalogue" in lead
                  else [lead["source"],lead["question"]])
        key=fingerprint(identity)[:24]
        path=root/"campaign/scouting"/(key+".json")
        if not path.exists():
            if lead.get("board_snapshot_fresh") is False:
                continue
            return lead,path
        if lead.get("listed_status") == "scored-proof":
            # Resume an exact live declaration once. The identity binds the prior
            # result to this statement, so changed declarations start fresh.
            followup = path.with_name(key + "-lemma.json")
            review = load(path)["review"]
            if followup.exists():
                if not lead.get("checked_helper"):
                    continue
                review = load(followup)["review"]
                followup = path.with_name(key + "-" + lead["checked_helper"][:16] + ".json")
                if followup.exists():
                    # Two bounded repair slots after a checked advance. A repeated source
                    # hash cannot consume another slot, even if the previous draft failed.
                    from hashlib import sha256
                    from ops.hosted import SERVICE
                    checkpoint = lean_loop.checkpoint_path(SERVICE,lead["id"])
                    previous = sorted(path.parent.glob(followup.stem+"-repair-*.json"))
                    if len(previous) >= 2 or not checkpoint.is_file():
                        continue
                    review = load(previous[0] if previous else followup)["review"]
                    source_hash = sha256(checkpoint.read_bytes()).hexdigest()[:16]
                    followup = path.with_name(followup.stem+"-repair-"+source_hash+".json")
                    if followup.exists():
                        continue
                if review["verdict"] in {"duplicate", "prior_resolution"}:
                    continue
            if (review["verdict"] == "shortlist" or lead.get("checked_helper")) and all(
                    review.get(field, "").strip() for field in ("proof_or_witness", "remaining_obligation")):
                lead["prior_attempt"] = {field: review[field] for field in
                                         ("primary_sources", "proof_or_witness", "remaining_obligation")}
                return lead,followup
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
        if lead.get("listed_status") == "scored-proof":
            prompt += (" The live queue listed this target as point-bearing. Verify the current statement "
                       "and existing proofs/PRs, then return the full Lean file in proof_or_witness "
                       "if you can close it. Cite earlier authors for a formalization. Record the exact "
                       "remaining lemma if unfinished. Only an independent kernel replay can certify it.")
        prior_files = {}
        if "prior_attempt" in lead:
            prior_files["prior_proof"] = lead["prior_attempt"]["proof_or_witness"]
            compact = dict(lead, prior_attempt=dict(lead["prior_attempt"], proof_or_witness="See PreviousAttempt.txt if needed"))
            prompt = ("Continue the attributed proof attempt on this frozen declaration. Start with "
                      "remaining_obligation and the "
                      "existing notebook. Produce Lean for that lemma and then the target if possible. "
                      "Reuse the cited literature unless a specific issue requires another source. "
                      "Distinguish compiled code from proposed code. Report the precise advance or "
                      "failure in attempt, the proof in proof_or_witness and any remaining obligation. "
                      "Use the same verdicts (shortlist, prior_resolution, duplicate, insufficient_evidence) "
                      "and return primary_sources as a JSON list of consulted HTTPS URLs.\n" + json.dumps(compact))
        files = tuple(lead.get("notebook", []))
        continued = "prior_attempt" in lead
        if continued:
            # The scout already reviewed these primary sources. Spend this slot on the named lemma.
            prompt += ("\nThis is an offline continuation. The cited URLs are inherited from the prior "
                       "scout. Return that provenance in primary_sources; do not claim a fresh search. "
                       "Use the newest notebook and checked helpers wherever they supersede the old blocker.")
        from ops import lean_loop
        if not files and lead["id"] not in lean_loop.TARGETS:
            files = ("checks/left_to_solve/targets.json",)
        result=ask(prompt,fields,sources=not continued,notebook=files,**prior_files)
    else:
        fields += ("attempt", "remaining_obligation", "human_brief")
        prompt += (" For an open tractable case, try the smallest decisive calculation now. For a hard "
                   "case, isolate one testable lemma. Report exactly what you checked in attempt and what "
                   "remains in remaining_obligation. In human_brief use at most 120 words: teach the "
                   "physical setup from scratch, give one worked toy example, and identify one choice "
                   "where an intuition or experimental constraint would change the next test. If the "
                   "source already settles the question, cite it and skip further search.")
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
