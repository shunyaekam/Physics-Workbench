"""Publish an isolated, independently replayed full certificate, then close its issue."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
from urllib.request import urlopen

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from ops.witness import contracts,fingerprint

REPO="shunyaekam/oo-research"
SITE="https://shunyaekam.github.io/oo-research/"


def git(root,*args):
    return subprocess.check_output(["git",*args],cwd=root,text=True).strip()


def show(root,ref,path):
    return json.loads(git(root,"show",ref+":"+path))


def publish(root=ROOT):
    research=git(root,"rev-parse","HEAD")
    if git(root,"rev-parse","origin/research")!=research:
        raise RuntimeError("Publish from a synchronized research commit")
    main=git(root,"rev-parse","origin/main")
    index=show(root,main,"certificates/index.json")
    issues=show(root,main,"discovery/proof-issues.json")
    ready=[]
    for pid,c in contracts(root).items():
        key=fingerprint(c)[:16]
        path="campaign/proof-flow/"+pid+"-"+key+".json"
        if not (root/path).is_file() or pid in index:
            continue
        record=show(root,research,path)
        if record["status"]=="ready_for_replay":
            ready.append(record)
    if ready:
        remote=git(root,"remote","get-url","origin")
        with tempfile.TemporaryDirectory() as temp:
            dest=Path(temp)/"main"
            git(root,"clone","--quiet","--no-checkout",remote,str(dest))
            git(dest,"checkout","--quiet","--detach",main)
            packet=Path(temp)/"receipt.json"
            for record in ready:
                packet.write_text(json.dumps(record))
                outcome=subprocess.run([sys.executable,"ops/release_witness.py",str(packet),research,main],
                               cwd=dest,timeout=240)
                if outcome.returncode:
                    print("Release replay rejected",record["problem_id"],flush=True)
            git(dest,"add","--","certificates")
            git(dest,"diff","--cached","--check")
            if git(dest,"diff","--cached","--name-only"):
                git(dest,"commit","-qm","Publish independently replayed physics witnesses")
                git(dest,"push",remote,"HEAD:refs/heads/main")
            git(root,"fetch","origin","main")
            main=git(root,"rev-parse","origin/main")
            index=show(root,main,"certificates/index.json")
    # A failed deployment or issue transition is retried on the next cycle.
    for pid,entry in index.items():
        path="certificates/"+entry["file"]
        with urlopen(SITE+path+"?revision="+main,timeout=15) as response:
            deployed=json.load(response)
        if deployed!=show(root,main,path):
            raise RuntimeError("Pages has not served the released certificate yet")
        number=str(issues[pid])
        args=["gh","issue","view",number,"--repo",REPO,"--json","state","--jq",".state"]
        if subprocess.check_output(args,text=True).strip()=="OPEN":
            subprocess.run(["gh","issue","close",number,"--repo",REPO,"--comment",
                            "The registered statement has a replayed certificate. "+SITE+path],
                           check=True)


if __name__=="__main__":
    publish()
