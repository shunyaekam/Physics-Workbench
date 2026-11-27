"""Reconcile a user's merged Lean files with Left to Solve's public verdicts."""

import argparse
from collections import defaultdict
from datetime import datetime
from email.utils import parsedate_to_datetime
from http.client import IncompleteRead
import json
import os
from pathlib import Path
import re
import socket
import tempfile
import time
from urllib.error import HTTPError, URLError
from urllib.parse import quote, urlencode, urljoin, urlsplit
from urllib.request import Request, urlopen


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "site/left-to-solve/accepted.json"
HANDLE = "shunyaekam"
SITE = "https://lefttosolve.com"
REPO = "GuillaumeBAUD-coder/open-math-agents"
API = f"https://api.github.com/repos/{REPO}"
PULL = f"https://github.com/{REPO}/pull/"
STEP = re.compile(r"\.R\d{1,2}\.H[1-4]$")
REDUCTION = re.compile(r"\.R\d{1,2}$")
KINDS = {"known": "known", "open": "open", "unformalized": "open", "warmup": "warmup"}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def get_json(url, missing_ok=False):
    host = urlsplit(url)
    require(host.scheme == "https" and host.netloc in ("api.github.com", "lefttosolve.com"),
            f"Unexpected API URL: {url}")
    headers = {"User-Agent": "oo-research-accepted-solutions", "Accept": "application/json"}
    token = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
    if host.netloc == "api.github.com" and token:
        headers["Authorization"] = f"Bearer {token}"
    for attempt in range(4):
        delay = 2 ** attempt
        try:
            with urlopen(Request(url, headers=headers), timeout=35) as response:
                return json.load(response), response.headers.get("Link", "")
        except HTTPError as error:
            if missing_ok and error.code == 404:
                return None, ""
            retry = error.code in (408, 429, 500, 502, 503, 504)
            retry |= error.code == 403 and (error.headers.get("Retry-After") is not None or
                                             error.headers.get("X-RateLimit-Remaining") == "0")
            if not retry or attempt == 3:
                raise
            after = error.headers.get("Retry-After")
            if after:
                delay = float(after) if after.isdigit() else parsedate_to_datetime(after).timestamp() - time.time()
            elif error.headers.get("X-RateLimit-Remaining") == "0":
                delay = float(error.headers.get("X-RateLimit-Reset", time.time())) - time.time() + 1
            if delay > 60:
                raise  # Leave the published snapshot intact; the scheduled run will retry.
        except (URLError, TimeoutError, socket.timeout, ConnectionError, IncompleteRead, json.JSONDecodeError):
            if attempt == 3:
                raise
        time.sleep(max(1, delay))


def pages(url, get):
    seen = set()
    origin = urlsplit(url)
    while url:
        require(url not in seen, f"Repeated next page: {url}")
        seen.add(url)
        data, links = get(url)
        yield data
        match = re.search(r'<([^<>]+)>\s*;\s*rel="next"', links)
        next_url = match.group(1) if match else None
        if isinstance(data, dict):
            next_url = next_url or data.get("next")
        if not next_url:
            return
        require(isinstance(next_url, str), "Unrecognized continuation format")
        url = urljoin(url, next_url)
        parsed = urlsplit(url)
        require((parsed.scheme, parsed.netloc, parsed.path) == (origin.scheme, origin.netloc, origin.path),
                "Unexpected continuation endpoint")


def board(get):
    records = {}
    totals = []
    for page in pages(f"{SITE}/api/solved", get):
        require(isinstance(page.get("solved"), list), "Missing public solved list")
        totals.append(page["count"])
        for row in page["solved"]:
            row = dict(row)
            if row.get("agent") == "reduction" and row["pr_url"].endswith("#closed"):
                row["pr_url"] = row["pr_url"][:-len("#closed")]
            key = row["problem_id"]
            require(isinstance(key, str) and key, "Missing solved problem ID")
            require(key not in records or records[key] == row, f"Conflicting board rows for {key}")
            records[key] = row
    require(records and all(isinstance(n, int) and n > 0 for n in totals), "Empty solved board")
    require(max(totals) <= len(records), "Truncated solved board without a continuation")
    return records


def root_id(problem):
    while STEP.search(problem):
        problem = STEP.sub("", problem)
    return problem


def contribution_file(path):
    match = re.fullmatch(r"(reductions|proofs)/([^/]+)\.lean", path)
    if not match:
        return None
    folder, item = match.groups()
    if folder == "reductions":
        if not REDUCTION.search(item):
            return None
        return root_id(REDUCTION.sub("", item)), "reduction", item
    return root_id(item), "step" if STEP.search(item) else "proof", item


def merged_file(number, handle, get):
    pr_url = f"{PULL}{number}"
    endpoint = f"{API}/pulls/{number}"
    pr, _ = get(endpoint)
    require(pr["html_url"] == pr_url and pr["user"]["login"].casefold() == handle.casefold(),
            f"Unexpected ownership of {pr_url}")
    if not pr["merged"] or pr["base"]["ref"] != "main" or pr["changed_files"] != 1:
        return None
    if pr["base"]["repo"]["full_name"].casefold() != REPO.casefold():
        return None
    files, _ = get(f"{endpoint}/files")
    require(len(files) == 1, f"Missing changed file of {pr_url}")
    return files[0]["filename"] if files[0]["status"] == "added" else None


def merged_files(handle, get, cache):
    owned = defaultdict(dict)
    # The Issues endpoint has a creator filter and no Search API 1,000-hit ceiling.
    query = urlencode({"creator": handle, "state": "closed", "per_page": 100})
    for page in pages(f"{API}/issues?{query}", get):
        require(isinstance(page, list), "Missing GitHub issue list")
        for issue in page:
            merged_at = (issue.get("pull_request") or {}).get("merged_at")
            if not merged_at:
                continue
            number = issue["number"]
            require(issue["user"]["login"].casefold() == handle.casefold(),
                    f"Owner filter mismatch on PR #{number}")
            # Only immutable metadata of a particular merged PR is reusable.
            # The live verdict and credit for each problem are checked on every run.
            key = f"{REPO}/{number}/{handle}/{merged_at}"
            if key not in cache:
                cache[key] = merged_file(number, handle, get)
            parsed = contribution_file(cache[key]) if cache[key] else None
            if parsed:
                problem, role, item = parsed
                owned[problem][f"{PULL}{number}"] = (role, item)
    return owned


def certificate_url(problem, handle):
    return f"{SITE}/api/certificate?" + urlencode({"problem": problem, "handle": handle})


def certificate_credit(problem, handle, evidence, get):
    url = certificate_url(problem, handle)
    envelope, _ = get(url, missing_ok=True)
    if envelope is None:
        return None
    cert = envelope["certificate"]  # Obtained from the issuer over HTTPS.
    holder = cert["holder"]
    require(cert["type"] == "left-to-solve/contribution-certificate" and cert["issuer"] == "lefttosolve.com"
            and cert["problem"]["id"] == problem and holder["handle"].casefold() == handle.casefold(),
            f"Certificate identity mismatch for {problem}")
    relevant = [r for r in holder["roles"] if evidence.get(r["pr"]) == (r["role"], r["item"])]
    require(relevant, f"No matching owned merged Lean file for certificate {problem}")
    return cert, relevant


def https_source(ref):
    if not isinstance(ref, str) or not ref.startswith("https://") or re.search(r"[\s\x00-\x1f\x7f\\]", ref):
        return None
    try:
        parsed = urlsplit(ref)
        if parsed.hostname and parsed.username is None and parsed.password is None and parsed.port != 0:
            return ref
    except ValueError:
        pass
    return None


def record(problem, row, evidence, handle, get):
    if row and (row["step"] or row["outcome"] == "step"):
        return None
    direct = row and row["handle"].casefold() == handle.casefold() and evidence.get(row["pr_url"]) == ("proof", problem)
    cert_url = None
    declared = {}
    if direct:
        declared = row
        proof, credit = row["pr_url"], "solver"
    else:
        found = certificate_credit(problem, handle, evidence, get)
        if not found:
            if row:
                listed = [row["handle"]] + (row.get("contributors") or [])
                require(handle.casefold() not in [h.casefold() for h in listed],
                        f"Missing corroboration for listed contributor on {problem}")
            return None
        cert, roles = found
        cert_url = certificate_url(problem, handle)
        direct_role = next((r for r in roles if r["role"] == "proof"), None)
        credit = "solver" if direct_role else "contributor"
        if direct_role:
            declared = direct_role
        proof = row["pr_url"] if row else (direct_role or roles[0])["pr"]
        if row:
            require(row["polarity"] == cert["result"], f"Conflicting verdict on {problem}")
            if direct_role:
                require(row["pr_url"] == direct_role["pr"] and row["handle"].casefold() == handle.casefold(),
                        f"Conflicting direct proof on {problem}")
            else:
                require(row["agent"] == "reduction", f"Parent closure not confirmed for {problem}")
    require(re.fullmatch(re.escape(PULL) + r"[1-9]\d*", proof), f"Invalid proof URL for {problem}")
    meta, _ = get(f"{SITE}/api/problems/{quote(problem, safe='')}")
    require(meta["id"] == problem and meta["kind"] in KINDS, f"Missing catalogue entry for {problem}")
    outcome = KINDS[meta["kind"]]
    variant = None
    if row:
        require(outcome == row["outcome"], f"Inconsistent result category for {problem}")
        variant = row.get("variantOf")
    if not variant and re.search(r"\.variants?\.", problem):
        variant = f"A special case of {meta['title'].split(' — ')[0]}. The certificate covers this variant."
    accepted = row["created_at"] if row else cert["solvedAt"]
    datetime.fromisoformat(accepted.replace("Z", "+00:00"))
    polarity = row["polarity"] if row else cert["result"]
    require(polarity in ("proof", "disproof") and meta["title"].strip(), f"Invalid metadata for {problem}")
    fields = meta["fields"]
    require(isinstance(fields, list) and all(isinstance(f, str) for f in fields), "Invalid fields")
    attribution = {k: declared[k] for k in ("agent", "model")
                   if isinstance(declared.get(k), str) and declared[k].strip()
                   and declared[k].casefold() != "reduction"}
    original = {}
    if isinstance(meta.get("statement"), str) and meta["statement"].strip():
        original["statement"] = meta["statement"]
    if primary_source := https_source(meta.get("ref")):
        original["primary_source"] = primary_source
    return {"id": problem, "title": meta["title"], "source": f"{SITE}/p/{quote(problem, safe='')}",
            "proof": proof, "field": next(iter(fields), "Mathematics"), "outcome": outcome, "credit": credit,
            "polarity": polarity, "accepted_at": accepted, "variant_note": variant, "certificate": cert_url, **attribution, **original}


def collect(handle=HANDLE, get=get_json, cache=None):
    solved = board(get)
    owned = merged_files(handle, get, cache if cache is not None else {})
    for problem, row in solved.items():
        if row.get("step") or STEP.search(problem):
            continue
        listed = [row["handle"]] + (row.get("contributors") or [])
        if any(h.casefold() == handle.casefold() for h in listed):
            require(problem in owned, f"Missing owned GitHub evidence for listed credit on {problem}")
    solutions = []
    for problem, evidence in owned.items():
        result = record(problem, solved.get(problem), evidence, handle, get)
        if result:
            solutions.append(result)
    return {"version": 1, "handle": handle, "solutions": sorted(solutions, key=lambda r: r["id"])}


def save(feed, path):
    content = json.dumps(feed, ensure_ascii=False, indent=2) + "\n"
    if path.exists():
        old = path.read_text()
        if old == content:
            return
        prior = json.loads(old)
        require(prior["version"] == feed["version"] and prior["handle"] == feed["handle"], "Wrong prior feed")
        missing = {s["id"] for s in prior["solutions"]} - {s["id"] for s in feed["solutions"]}
        require(not missing, f"Previously accepted IDs lost upstream; review before removal: {sorted(missing)}")
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=path.parent, delete=False) as f:
        f.write(content)
    os.chmod(f.name, 0o644)
    os.replace(f.name, path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=OUTPUT)
    parser.add_argument("--pr-cache", type=Path, help="Optional local cache of immutable merged PR file paths")
    args = parser.parse_args()
    cache = json.loads(args.pr_cache.read_text()) if args.pr_cache and args.pr_cache.exists() else {}
    feed = collect(cache=cache)
    save(feed, args.output)
    if args.pr_cache:
        args.pr_cache.write_text(json.dumps(cache, sort_keys=True) + "\n")
    print(f"{len(feed['solutions'])} accepted whole problems credited to @{HANDLE}")
