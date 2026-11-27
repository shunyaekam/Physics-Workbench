"""Race token-free Lean tactics on frozen goals and reuse checked results in the solver notebook."""
from datetime import datetime, timezone
from hashlib import sha256
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import time

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from lab import write
from ops import lean_loop as lean

OUT = ROOT/"campaign/proof-portfolio"
TACTICS = {
    "simplify": "solve | simp",
    "cardinality": "apply Nat.card_congr\n  first | (apply Equiv.symm; exact?) | exact?",
    "library": "exact?",
    "arithmetic": "omega",
}
HELPER = ROOT/"checks/left_to_solve/attempts/diffusion/CountGoal.lean.in"


def priority(name, rows):
    # Beta(1,1) for a kernel closure, one three-second timing observation as prior.
    tried = [r for r in rows if r["method"] == name and r["status"] in ("checked","miss","timeout")]
    wins = sum(r["status"] == "checked" for r in tried)
    p = (1+wins)/(2+len(tried))
    seconds = (3+sum(r["seconds"] for r in tried))/(1+len(tried))
    return p/seconds


def goals():
    yield "endpoint-count", "helper", "DiffusionSplit.endpoint_count", HELPER.read_text()
    yield lean.MAXWELL, "board", "OMA.solution", f"import {lean.MAXWELL_MODULE}\n\ntheorem OMA.solution : {lean.MAXWELL_TYPE} := by\n"
    # The board target has precisely the official import and statement.
    yield lean.TARGET, "board", "OMA.solution", f"import {lean.MODULE}\n\ntheorem OMA.solution : {lean.GOAL} := by\n  unfold {lean.GOAL}\n"


def signature(stem, method):
    return sha256(json.dumps([stem,method,TACTICS[method],lean.helper_hash().hexdigest()[:16],lean.PIN,lean.BOARD]).encode()).hexdigest()


def run():
    if not (lean.library_dir()/"environment.json").exists():
        return
    OUT.mkdir(parents=True,exist_ok=True)
    rows = [json.loads(p.read_text()) for p in OUT.glob("*.json")]
    for target, scope, decl, stem in goals():
        ids = {name:signature(stem,name) for name in TACTICS}
        previous = [r for r in rows if r["id"] in ids.values()]
        if any(r["status"]=="checked" for r in previous):
            continue
        remaining = [name for name in TACTICS if not (OUT/(ids[name]+".json")).exists()]
        if not remaining:
            continue
        method = max(remaining,key=lambda name:priority(name,[r for r in rows if r["scope"] == scope]))
        source = stem+"  "+TACTICS[method]+"\n"
        with tempfile.TemporaryDirectory() as tmp:
            work=Path(tmp)
            lean.notebook(work)
            (work/"Attempt.lean").write_text(source+"\n#print axioms "+decl+"\n")
            started_at=datetime.now(timezone.utc).isoformat(timespec="milliseconds")
            started=time.monotonic()
            try:
                ret=subprocess.run(["./check","Attempt.lean"],cwd=work,text=True,capture_output=True,timeout=20)
                diagnostic=ret.stdout+ret.stderr
                status="checked" if ret.returncode==0 and lean.clean_axioms(diagnostic,decl) else "miss"
                if status=="miss" and ("object file" in diagnostic or "unknown module prefix" in diagnostic):
                    raise RuntimeError("Pinned proof environment is incomplete: "+diagnostic[:350])
            except subprocess.TimeoutExpired:
                status,diagnostic="timeout","Timed out after 20 seconds"
            elapsed=round(time.monotonic()-started,3)
        row=dict(id=ids[method],problem=target,scope=scope,method=method,status=status,seconds=elapsed,started_at=started_at,
                 tokens=0,diagnostic=diagnostic[:480],pin=lean.PIN,board_revision=lean.BOARD)
        if status=="checked":
            row["proof"]=source
        write(OUT/(row["id"]+".json"),row)
        rows.append(row)
        print(scope,method,status,elapsed)


def checked_helper(root):
    stem = (root/"checks/left_to_solve/attempts/diffusion/CountGoal.lean.in")
    if not stem.exists():
        return None
    for method in TACTICS:
        key = signature(stem.read_text(),method)
        p = root/"campaign/proof-portfolio"/(key+".json")
        if p.exists() and json.loads(p.read_text())["status"] == "checked":
            return key
    return None


def handoff(work, problem=lean.TARGET):
    """Only hand off a proof for the current immutable inputs, with independent score review pending."""
    for target, scope, decl, stem in goals():
        if (scope == "board" and problem != target) or (scope == "helper" and problem != lean.TARGET):
            continue
        for name in TACTICS:
            p=OUT/(signature(stem,name)+".json")
            if p.is_file():
                row=json.loads(p.read_text())
                if row["status"]=="checked":
                    # Reconstruct from reviewed inputs. Avoid executing text from a receipt.
                    filename="Count.lean" if scope=="helper" else "BoardCandidate.lean"
                    (work/filename).write_text(stem+"  "+TACTICS[name]+"\n")


if __name__=="__main__":
    run()
