"""Run in the dedicated launchd checkout, outside the user's editable worktree."""
import datetime
import fcntl
import json
import os
from pathlib import Path
import subprocess
import sys

RUNTIME=Path(__file__).resolve().parents[1]
SERVICE=RUNTIME.parent


def call(args,root=RUNTIME,timeout=180,check=True):
    p=subprocess.run(args,cwd=root,timeout=timeout,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    if p.stdout:
        print(p.stdout.rstrip(),flush=True)
    if check:
        p.check_returncode()
    return p


def git(*args,**options):
    return call(["git",*args],**options)


def synchronize(ref,local,branch):
    # Only fast-forward the user's editable checkout, with no staged or
    # modified tracked files. Never stage user work or force a push.
    if not local.is_dir() or local.resolve()==RUNTIME:
        return
    options=dict(root=local)
    if git("remote","get-url","origin",**options).stdout.strip()!=ref:
        return
    if git("branch","--show-current",**options).stdout.strip()!=branch:
        return
    if git("status","--porcelain","--untracked-files=no",**options).stdout.strip():
        print("Editable checkout has local changes; its working files were preserved.")
        return
    git("fetch","origin",branch,**options)
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
    call([sys.executable,"checks/golay43.py","advance"])
    call([sys.executable,"checks/transport_polygon.py","advance"])
    call([sys.executable,"checks/finite_spins.py","advance"],timeout=180)
    call([sys.executable,"checks/scrutiny.py"])
    call([sys.executable,"formal/replay.py"])
    call([sys.executable,"excited_pairs.py","advance"],timeout=240)
    call([sys.executable,"three_level_search.py","advance"],timeout=120)
    call([sys.executable,"coherent_band_search.py"],timeout=120)
    call([sys.executable,"refresh_sparse_note.py"],timeout=180)
    call([sys.executable,"continuous.py","run"],timeout=480)
    call([sys.executable,"review_papers.py"],timeout=240)
    call([sys.executable,"literature.py"],timeout=210)
    call([sys.executable,"ops/catalogue_watch.py"],timeout=40,check=False)
    try:
        call([sys.executable,"ops/agent_campaign.py"],timeout=210,check=False)
    except subprocess.TimeoutExpired:
        print("Agent campaign timed out; completed research receipts will still synchronize.",flush=True)
    call([sys.executable,"ops/pipeline_feed.py"])
    git("add","--","campaign","papers")
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
            if conflicts != ["campaign/pipeline.json"]:
                git("merge","--abort",check=False)
                raise RuntimeError("Research branch conflict; both histories preserved")
            call([sys.executable,"ops/pipeline_feed.py"])
            git("add","--","campaign/pipeline.json")
            git("commit","--no-edit")
        git("push","-u","origin","HEAD:research")
    local=Path(json.loads((SERVICE/"settings.json").read_text())["editable"])
    synchronize(ref,local,"main")
    synchronize(ref,local/".runtime"/"research","research")


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
