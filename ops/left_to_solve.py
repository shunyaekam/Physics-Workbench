"""Submit prepared proofs once the reviewed statement matches the lab's copy."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time
from urllib.parse import urlencode

ROOT = Path(__file__).resolve().parents[1]
QUEUE = ROOT / "checks" / "left_to_solve"
UPSTREAM = "GuillaumeBAUD-coder/open-math-agents"
FORK = "shunyaekam/open-math-agents"
SITE = "https://lefttosolve.com"


def github(path, payload=None, raw=False):
    command = ["gh", "api", path]
    if raw:
        command.extend(["-H", "Accept: application/vnd.github.raw+json"])
    if payload is not None:
        command.extend(["--method", "POST", "--input", "-"])
    result = subprocess.run(command, input=json.dumps(payload).encode() if payload is not None else None,
                            stdout=subprocess.PIPE, check=True, timeout=20)
    return result.stdout if raw else json.loads(result.stdout)


def desk(path, params=None, post=False):
    url = SITE + path + ("?" + urlencode(params) if params else "")
    command = ["curl", "--silent", "--show-error", "--fail", "--max-time", "15"]
    if post:
        command.extend(["-X", "POST"])
    result = subprocess.run(command + [url], stdout=subprocess.PIPE, timeout=18)
    if result.returncode:
        raise RuntimeError("Desk request failed; will retry on the next run")
    return json.loads(result.stdout or b"{}")


def submit(row):
    name = row["problem"]
    pr = github(f"repos/{UPSTREAM}/pulls/{row['submission']}")
    if not pr["merged_at"]:
        print(f"{name}: statement {pr['state']}")
        return
    polarity = row.get("proof_kind", "disproof")
    branch = "oo-" + polarity + "-" + name
    existing = github(f"repos/{UPSTREAM}/pulls?" + urlencode(
        {"head": "shunyaekam:" + branch, "state": "all"}))
    if existing:
        print(name, existing[0]["html_url"])
        return
    task = desk("/api/problems/" + name)
    decl = "OMA.S_" + name.replace("-", "_") + ".main"
    if task.get("solution") or task.get("kind") != "open" or task.get("decl") != decl:
        print(f"{name}: waiting for the unsolved, provable catalogue declaration")
        return
    base = github(f"repos/{UPSTREAM}/git/ref/heads/main")["object"]["sha"]
    source = github(f"repos/{UPSTREAM}/contents/statements/{name}.lean?ref={base}", raw=True)
    if hashlib.sha256(source).hexdigest() != row["statement_sha256"]:
        print(f"{name}: reviewed statement changed; a fresh proof review is required")
        return
    if github("user")["login"] != "shunyaekam":
        raise RuntimeError("The active contributor account differs from the authorised account")
    proof = (QUEUE / (name + ".lean")).read_text()
    file = "proofs/" + name + ".lean"
    refs = github(f"repos/{FORK}/git/matching-refs/heads/{branch}")
    if any(ref["ref"] == "refs/heads/" + branch for ref in refs):
        previous = github(f"repos/{FORK}/contents/{file}?ref={branch}", raw=True)
        if previous != proof.encode():
            raise RuntimeError("Existing contribution branch contains different proof")
    else:
        tree = github(f"repos/{UPSTREAM}/git/commits/{base}")["tree"]["sha"]
        new_tree = github(f"repos/{FORK}/git/trees", {"base_tree": tree, "tree": [
            {"path": file, "mode": "100644", "type": "blob", "content": proof}]})
        commit = github(f"repos/{FORK}/git/commits", {"message": ("Prove " if polarity == "proof" else "Disprove ") + name,
                        "tree": new_tree["sha"], "parents": [base]})
        github(f"repos/{FORK}/git/refs", {"ref": "refs/heads/" + branch, "sha": commit["sha"]})
    # The statement was checked before taking a lease; do not reserve waiting jobs.
    time.sleep(3)
    lease = desk("/api/desk/next", {"handle": "shunyaekam", "agent": "codex", "problem": name})
    if lease["problem"]["id"] != name or lease.get("file") != file:
        raise RuntimeError("Desk returned a different target")
    result = "Lean series proof" if polarity == "proof" else "Exact counterexample"
    body = (f"Lease: {lease['lease']}\nAgent: Codex\nModel: GPT-6 (Codex)\n\n"
            f"{result} for the reviewed statement. [Lab record]({row['issue']}). "
            f"[Independent replay](https://shunyaekam.github.io/oo-research/contributions/left-to-solve/#{name}).")
    pull = github(f"repos/{UPSTREAM}/pulls", {"title": name, "head": "shunyaekam:" + branch,
                  "base": "main", "body": body})
    print(name, pull["html_url"], flush=True)
    time.sleep(3)
    desk("/api/desk/release", {"lease": lease["lease"], "reason": "submitted"}, post=True)


def run():
    state = Path(os.environ.get("OO_LTS_STATE", str(ROOT.parent / "lts-last-check")))
    if state.exists() and time.time() - state.stat().st_mtime < 3600:
        return
    state.touch(mode=0o600)
    for row in json.loads((QUEUE / "targets.json").read_text()):
        if "statement_sha256" in row:
            try:
                submit(row)
            except (RuntimeError, OSError, subprocess.SubprocessError, KeyError, ValueError) as error:
                print(row["problem"], type(error).__name__, "follow-up pending", flush=True)


if __name__ == "__main__":
    run()
