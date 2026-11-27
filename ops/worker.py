"""Run in the dedicated launchd checkout, outside the user's editable worktree."""
import datetime
import fcntl
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

RUNTIME=Path(__file__).resolve().parents[1]
SERVICE=RUNTIME.parent
sys.path.insert(0, str(RUNTIME))
from ops.method_runs import measure


def call(args,root=RUNTIME,timeout=180,check=True):
    p=subprocess.run(args,cwd=root,timeout=timeout,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    if p.stdout:
        print(p.stdout.rstrip(),flush=True)
    if check:
        p.check_returncode()
    return p


def search(problem, script, folders, args, *, timeout=180):
    """Measure local work including no-op and failed dispatches. Credit stays with the checker."""
    def snapshot():
        return {path: path.stat().st_mtime_ns for folder in folders
                for path in (RUNTIME / "campaign" / folder).glob("*.json")}

    before = snapshot()
    with measure(RUNTIME, problem, "search", script) as run:
        try:
            call(args, timeout=timeout)
            run["outcome"] = "no_new_receipt"
        finally:
            changed = sorted(str(p.relative_to(RUNTIME)) for p, stamp in snapshot().items()
                             if before.get(p) != stamp)
            if changed:
                run["evidence"] = changed[0]
                run["evidence_paths"] = changed
                if run["outcome"] == "no_new_receipt":
                    run["outcome"] = "search_receipt"


def git(*args,**options):
    return call(["git",*args],**options)


def synchronize(ref,local,branch):
    # Only fast-forward the user's editable checkout, with no staged or
    # modified tracked files. Never stage user work or force a push.
    if not local.is_dir() or local.resolve()==RUNTIME:
        return
    options=dict(root=local)
    probe=git("remote","get-url","origin",check=False,**options)
    if probe.returncode:
        print(f"Editable checkout currently inaccessible at {local}. Remote research is synchronized.",flush=True)
        return
    if probe.stdout.strip()!=ref:
        return
    if git("branch","--show-current",**options).stdout.strip()!=branch:
        return
    if git("status","--porcelain","--untracked-files=no",**options).stdout.strip():
        print("Editable checkout has local changes; its working files were preserved.")
        return
    git("fetch","--no-write-fetch-head","origin",branch,**options)
    git("merge","--ff-only","origin/"+branch,**options)


def run():
    ref=git("remote","get-url","origin").stdout.strip()
    branch=git("branch","--show-current").stdout.strip()
    if branch=="main":
        # Rename the dedicated legacy branch in place to preserve pending batches.
        git("branch","-m","research")
    elif branch!="research":
        raise RuntimeError("Unexpected branch in dedicated checkout")
    fetched=git("fetch","origin","research","main",check=False).returncode==0
    if fetched:
        # The dedicated checkout can have completed local batches pending push.
        if git("merge-base","--is-ancestor","origin/research","HEAD",check=False).returncode:
            merge=git("merge","--no-edit","origin/research",check=False)
            if merge.returncode:
                git("merge","--abort",check=False)
                raise RuntimeError("conflicting edits in dedicated checkout; saved both histories")
    call([sys.executable,"-m","unittest","-q"])
    call([sys.executable,"ops/paper_checks.py"],timeout=900)
    search("e27-schmidt", "checks/schmidt7/pair_search.py", ['schmidt-seven-pairs'],
           [sys.executable,"checks/schmidt7/pair_search.py","advance"])
    search("golay43", "checks/golay43.py", ['golay43'],
           [sys.executable,"checks/golay43.py","advance"])
    uv=shutil.which("uv") or str(Path.home()/".local/bin/uv")
    try:
        search("golay43", "checks/golay/advance.py", ["golay-graphs", "golay-splices", "golay-splice-tails"],
               [uv,"run","--offline","--with","stim==1.16.0","python","checks/golay/advance.py"],timeout=150)
    except (OSError,subprocess.SubprocessError) as exc:
        print(f"Golay graph search could not complete this cycle: {exc}",flush=True)
    closed = {entry["problem_id"] for entry in json.loads(
        (RUNTIME/"discovery/pipeline-results.json").read_text())["solutions"]}
    if "transport-polygon" not in closed:
        search("transport-polygon", "checks/transport_polygon.py", ['transport-polygon'],
               [sys.executable,"checks/transport_polygon.py","advance"])
    search("refined-bmv", "checks/bmv_search.py", ['bmv-three-level'],
           [sys.executable,"checks/bmv_search.py","advance"])
    search("bernasconi-table2", "checks/finite_spins.py", ['finite-spins'],
           [sys.executable,"checks/finite_spins.py","advance"],timeout=180)
    call([sys.executable,"checks/scrutiny.py"])
    call([sys.executable,"formal/replay.py"])
    search("gagatsos-2026-c1", "excited_pairs.py", ['fock-pairs/excited'],
           [sys.executable,"excited_pairs.py","advance"],timeout=240)
    search("gagatsos-2026-c1", "three_level_search.py", ['three-level'],
           [sys.executable,"three_level_search.py","advance"],timeout=120)
    search("gagatsos-2026-c1", "coherent_band_search.py", ['coherent-bands'],
           [sys.executable,"coherent_band_search.py"],timeout=120)
    call([sys.executable,"refresh_sparse_note.py"],timeout=180)
    call([sys.executable,"checks/sparse_table.py"])
    call([sys.executable,"continuous.py","run"],timeout=480)
    call([sys.executable,"review_papers.py"],timeout=240)
    call([sys.executable,"literature.py"],timeout=210)
    call([sys.executable,"ops/catalogue_watch.py"],timeout=40,check=False)
    # Fetch full question rows once per week per importer. Keep the last complete snapshot after a failure.
    week=datetime.datetime.now(datetime.timezone.utc).strftime("%G-W%V")
    marker_dir=RUNTIME/"campaign/catalogue-scans"
    for importer in ("catalogue_index","extra_catalogues","left_to_solve_index"):
        marker=marker_dir/(importer+"-"+week+".done")
        if not marker.exists():
            try:
                completed=call([sys.executable,"ops/"+importer+".py"],timeout=180,check=False)
                if completed.returncode==0:
                    marker_dir.mkdir(exist_ok=True)
                    marker.write_text(week+"\n")
            except (OSError,subprocess.TimeoutExpired) as exc:
                print(f"{importer} refresh pending: {exc}",flush=True)
    try:
        call([sys.executable,"ops/lts_standings.py"],timeout=150,check=False)
    except subprocess.TimeoutExpired:
        print("Score refresh timed out; retaining the last snapshot.",flush=True)
    try:
        call([sys.executable,"ops/proof_flow.py"],timeout=360,check=False)
    except subprocess.TimeoutExpired:
        print("Agent campaign timed out; completed research receipts will still synchronize.",flush=True)
    try:
        call([sys.executable,"ops/left_to_solve.py"],timeout=300,check=False)
    except subprocess.TimeoutExpired:
        print("Left to Solve follow-up timed out; retry on the next eligible cycle.",flush=True)
    call([sys.executable,"ops/method_trial.py"],timeout=120)
    call([sys.executable,"ops/method_report.py"])
    call([sys.executable,"ops/pipeline_feed.py"])
    git("add","--","campaign","papers","checks/left_to_solve/lab-crosswalk.json")
    if git("diff","--cached","--quiet",check=False).returncode==1:
        git("commit","-qm","Advance audited physics search and update working papers")
    published = git("push","-u","origin","HEAD:research",check=False)
    if published.returncode:
        # An editor may publish to research while a long search is running.
        # Retain both histories. Conflicting authored edits need reconciliation.
        git("fetch","origin","research","main")
        merge = git("merge","--no-edit","origin/research",check=False)
        if merge.returncode:
            conflicts = git("diff","--name-only","--diff-filter=U").stdout.splitlines()
            derived = {"campaign/pipeline.json","campaign/research-methods.md","campaign/method-summary.json"}
            if not conflicts or not set(conflicts) <= derived:
                git("merge","--abort",check=False)
                raise RuntimeError("Research branch conflict; both histories preserved")
            call([sys.executable,"ops/pipeline_feed.py"])
            call([sys.executable,"ops/method_report.py"])
            git("add","--",*sorted(derived))
            git("commit","--no-edit")
        git("push","-u","origin","HEAD:research")
    call([sys.executable,"ops/publish_checked.py"],timeout=300)
    local=Path(json.loads((SERVICE/"settings.json").read_text())["editable"])
    for checkout, branch in ((local,"main"), (local/".runtime"/"research","research")):
        try:
            synchronize(ref,checkout,branch)
        except (OSError, subprocess.SubprocessError) as exc:
            # GitHub is already synchronized. Retry the optional editable copy next cycle.
            print(f"Editable {branch} copy deferred ({type(exc).__name__}).",flush=True)


if __name__=="__main__":
    os.environ["GIT_TERMINAL_PROMPT"]="0"
    with (SERVICE/"worker.lock").open("w") as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        log=SERVICE/"worker.log"
        if log.exists() and log.stat().st_size>1000000:
            log.replace(log.with_suffix(".previous.log"))
        with log.open("a",buffering=1) as f:
            sys.stdout=sys.stderr=f
            print(datetime.datetime.now().astimezone().isoformat(),"starting")
            try:
                run()
                print("Cycle and GitHub synchronization complete.")
            except Exception:
                import traceback
                traceback.print_exc()
                sys.exit(1)
