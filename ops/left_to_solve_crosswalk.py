"""Refresh reviewed lab-to-catalogue matches against a checkout of Left to Solve."""
import gzip
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import unicodedata

ROOT = Path(__file__).resolve().parents[1]
REPORT = ROOT / "checks/left_to_solve/lab-crosswalk.json"


def normalize(value):
    folded = unicodedata.normalize("NFKD", value.casefold())
    return " ".join("".join(ch for ch in folded if not unicodedata.combining(ch)).split())


def refresh(checkout, report=REPORT):
    crosswalk = json.loads(report.read_text())
    groups = crosswalk["searches"]
    patterns = {name: re.compile(group["regex"]) for name, group in groups.items()}
    existing = {name: {r["id"]: r for r in group["candidates"]} for name, group in groups.items()}
    candidates = {name: {} for name in groups}
    data = checkout / "data"
    catalog_ids = set()
    counts = {}
    statement_path = checkout / "statements"
    lean_statements = {p.stem: p.read_text() for p in statement_path.glob("*.lean")}
    def match_candidate(key, title, content):
        for name, pattern in patterns.items():
            if not pattern.search(content):
                continue
            digest = hashlib.sha256(content.encode()).hexdigest()
            previous = existing[name].get(key, {})
            disposition = "review_required"
            if previous.get("statement_fingerprint") == digest:
                disposition = previous["disposition"]
            candidates[name][key] = {
                "id": key, "title": title, "statement_fingerprint": digest,
                "disposition": disposition,
            }

    for filename in ("catalog.json", "extra.json", "extra2.json", "extra3.json.gz"):
        path = data / filename
        with (gzip.open(path, "rt") if filename.endswith(".gz") else path.open()) as stream:
            table = json.load(stream)
        rows = table["problems"] if "problems" in table else table["rows"]
        counts[filename] = len(rows)
        for row in rows:
            if isinstance(row, dict):
                key, title = row["id"], row["title"]
                source = [row.get(field) or "" for field in ("statement", "lean", "ref")]
            elif filename == "extra2.json":
                key, title = row[:2]
                source = [row[4] or "", row[5] or ""]
            else:
                key, title = f"mo-{row[0]}", row[1]
                source = [row[9] or "", f"https://mathoverflow.net/questions/{row[0]}"]
            if key in catalog_ids:
                continue
            catalog_ids.add(key)
            content = normalize(" ".join([key, title, *source, lean_statements.get(key, "")]))
            match_candidate(key, title, content)

    # Accepted reductions have their own leaseable targets. Search each hypothesis
    # separately; a changed reduction invalidates the stored human/mathematical review.
    steps = 0
    for reduction in sorted((checkout / "reductions").glob("*.lean")):
        body = reduction.read_text()
        heads = list(re.finditer(r"(?m)^(?:def|abbrev) (H[1-4])\s*:\s*Prop\s*:=", body))
        for head in heads:
            steps += 1
            key = reduction.stem + "." + head[1]
            segment = re.split(r"\n(?:def |abbrev |theorem |lemma |end )", body[head.end():], maxsplit=1)[0]
            content = normalize(key + " " + segment)
            match_candidate(key, key, content)

    for name, group in groups.items():
        group["candidates"] = [candidates[name][key] for key in sorted(candidates[name])]
    for paper in crosswalk["papers"]:
        src = ROOT / paper["source_file"]
        fingerprint = hashlib.sha256(src.read_bytes()).hexdigest()
        if paper.get("audited_source_sha256") != fingerprint:
            paper["status"] = "lab_source_changed_review_required"
        elif any(row["disposition"] == "review_required" for row in groups[paper["search"]]["candidates"]):
            paper["status"] = "catalogue_match_review_required"
        else:
            paper["status"] = paper["reviewed_outcome"]
    crosswalk["catalogue"] = {
        "repo": "https://github.com/GuillaumeBAUD-coder/open-math-agents",
        "revision": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=checkout, text=True).strip(),
        "source_rows": counts, "distinct_problem_ids": len(catalog_ids), "merged_reduction_steps": steps,
    }
    targets = json.loads((ROOT / "checks/left_to_solve/targets.json").read_text())
    editorial_queue = []
    for target in targets:
        key = target["problem"]
        proof = report.parent / (key + ".lean")
        if not proof.is_file() or not target.get("submission"):
            continue
        upstream_proof = checkout / "proofs" / proof.name
        upstream_statement = checkout / "statements" / proof.name
        if upstream_proof.is_file():
            status = "check_authorship_and_prepare_editorial_review"
        elif upstream_statement.is_file():
            status = "await_upstream_proof_acceptance"
        else:
            status = "await_upstream_statement_then_proof"
        editorial_queue.append({
            "id": key, "prerequisite_status": status,
            "statement_pr": f"https://github.com/GuillaumeBAUD-coder/open-math-agents/pull/{target['submission']}",
            "local_proof": str(proof.relative_to(ROOT)),
            "local_verification_run": target.get("verification"),
        })
    crosswalk["pending_editorial"] = editorial_queue
    tracked = {p["source_file"] for p in crosswalk["papers"]}
    crosswalk["new_manuscripts_requiring_audit"] = sorted(
        str(p.relative_to(ROOT)) for p in (ROOT / "papers").glob("*.tex")
        if str(p.relative_to(ROOT)) not in tracked and r"\begin{abstract}" in p.read_text()
    )
    payload = json.dumps(crosswalk, ensure_ascii=False, indent=2) + "\n"
    temp = report.with_suffix(".tmp")
    temp.write_text(payload)
    temp.replace(report)
    unresolved = sum(r["disposition"] == "review_required" for group in groups.values() for r in group["candidates"])
    print(f"Outbound audit: {len(catalog_ids)} catalogue IDs, {steps} step IDs, {unresolved} candidates awaiting review")


if __name__ == "__main__":
    refresh(Path(sys.argv[1]))
