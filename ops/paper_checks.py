"""Replay paper-specific exact checks when the paper, inputs, or checker changes."""
from hashlib import sha256
import json
from pathlib import Path
import shutil
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from lab import load,write

PACKAGES={
    "transport-literal":(
        ["formal/replay.py","formal/transport_literal/replay.py","formal/transport_literal/Verify.lean",
         "formal/transport_literal/TransportLiteral.lean","formal/transport_literal/lean-toolchain",
         "formal/transport_literal/lake-manifest.json","formal/transport_literal/lakefile.toml"],
        [["formal/transport_literal/replay.py","--recheck-imports","--self-test"]]),
    "transport-polygon":(
        ["papers/transport-polygon.tex","checks/transport_optimum.py","checks/transport_polygon.py",
         "checks/transport_regression.py","checks/transport_review.py","formal/TransportPolygon.lean",
         "formal/replay.py","formal/transport_replay.py","formal/lean-toolchain"],
        [["checks/transport_regression.py"],["checks/transport_review.py","--sites","9"],["formal/transport_replay.py"]]),
    "refined-bmv":(
        ["papers/bmv-trace-12-3.tex","checks/next_intake_bmv.py","checks/bmv_review.py",
         "checks/bmv_degrees.py","checks/bmv_range_review.py","checks/bmv_blocks.py","checks/bmv_search.py"],
        [["checks/bmv_blocks.py"],["checks/next_intake_bmv.py"],["checks/bmv_review.py"],
         ["uv","run","--offline","--with","python-flint==0.9.0","python","checks/bmv_degrees.py"],
         ["uv","run","--offline","--with","python-flint==0.9.0","python","checks/bmv_range_review.py"]]),
    "schmidt-seven":(
        ["papers/schmidt-rank-seven.tex","checks/schmidt7/verify.py","checks/schmidt7/regions.py",
         "checks/schmidt7/two_exceptions.py","checks/schmidt7/review_checks.py","checks/schmidt7/duals.json",
         "checks/schmidt7/bounded_ratio.json","checks/schmidt7/bounded_second.json","checks/schmidt7/fourth_gap.json",
         "checks/schmidt7/Certificate.lean","checks/schmidt7/lean_replay.py","formal/lean-toolchain"],
        [["checks/schmidt7/verify.py"],["checks/schmidt7/regions.py"],["checks/schmidt7/two_exceptions.py"],
         ["checks/schmidt7/review_checks.py"],["checks/schmidt7/lean_replay.py"]])
}


def check(name,inputs,commands):
    hashes={f:sha256((ROOT/f).read_bytes()).hexdigest() for f in [*inputs,"ops/paper_checks.py"]}
    fingerprint=sha256(json.dumps([hashes,commands],sort_keys=True).encode()).hexdigest()
    path=ROOT/"campaign/paper-checks"/name/(fingerprint+".json")
    if path.exists():
        receipt=load(path)
        if receipt["inputs"]!=hashes or [r["command"] for r in receipt["checks"]]!=commands:
            raise ValueError("Paper verification record does not match its inputs")
        print(name,"matches completed exact replay",fingerprint[:12],flush=True)
        return
    checks=[]
    for command in commands:
        print(name,"running",*command,flush=True)
        if command[0]=="uv":
            uv=shutil.which("uv") or str(Path.home()/".local/bin/uv")
            args=[uv,*command[1:]]
        else:
            args=[sys.executable,*command]
        output=subprocess.check_output(args,cwd=ROOT,text=True,timeout=600)
        checks.append(dict(command=command,stdout=output.strip()))
    path.parent.mkdir(parents=True,exist_ok=True)
    write(path,dict(paper=name,inputs=hashes,checks=checks,scope="Computational steps only. Mathematical review is a separate record."))
    print(name,"verified",fingerprint[:12],flush=True)


if __name__=="__main__":
    for name,(inputs,commands) in PACKAGES.items():check(name,inputs,commands)
