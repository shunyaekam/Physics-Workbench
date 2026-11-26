"""Replay the independent exact checks when a manuscript changes."""
import hashlib
import json
import subprocess
import sys

from lab import ROOT,write
from verify import require


def review():
    papers=[ROOT/"papers"/f for f in ("coordinate-supports.tex","finite-maxima.tex")]
    hashes={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in papers}
    key=hashlib.sha256(json.dumps(hashes,sort_keys=True).encode()).hexdigest()
    directory=ROOT/"campaign/reviews"
    directory.mkdir(exist_ok=True)
    path=directory/(key+".json")
    if path.exists():
        saved=json.loads(path.read_text())
        require(saved.get("theorem_matched",True),"open theorem contradiction; inspect archived case")
        return
    rec=dict(manuscript_sha256=hashes, method="exact replay", mathematical_review="pending")
    for script in ("scrutiny.py","thresholds.py"):
        run=subprocess.run([sys.executable,str(ROOT/"checks"/script)],capture_output=True,text=True,check=True)
        rec[script]=run.stdout.splitlines()
    from continuous import read_cases
    rec["independently_replayed_maxima"]={f"{d},{k}":n for (d,k),n in read_cases(check=True).items()}
    write(path,rec)
    require(rec.get("theorem_matched",True),"physical matrix contradicts theorem; review incident saved")
    print("Manuscript review archived",key[:12])


if __name__=="__main__":
    review()
