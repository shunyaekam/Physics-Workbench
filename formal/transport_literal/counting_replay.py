"""Recompile the frozen counting contract and its proof in a clean directory."""
import argparse
from hashlib import sha256
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile


def replay(lean, source):
    source = Path(source)
    names = ("Counting.lean", "CountingProof.lean", "VerifyCounting.lean")
    allowed = {"propext", "Classical.choice", "Quot.sound"}
    with tempfile.TemporaryDirectory() as name:
        tmp = Path(name)
        for file in names:
            shutil.copyfile(source / file, tmp / file)
        env = dict(os.environ, LEAN_PATH=str(tmp))

        def call(*args, must_pass=True):
            run = subprocess.run([lean, "-DwarningAsError=true", *args], cwd=tmp, env=env,
                                 text=True, capture_output=True, timeout=180)
            if must_pass != (run.returncode == 0):
                raise RuntimeError(run.stdout + run.stderr)
            return run.stdout.strip()

        toolchain = call("--version")
        if "version 4.19.0," not in toolchain:
            raise ValueError("Expected Lean 4.19.0")
        call("-o", "Counting.olean", names[0])
        call("-o", "CountingProof.olean", names[1])
        output = call("--trust=0", names[2])
        label = "'verifiedCounting' depends on axioms: ["
        if not output.startswith(label) or not output.endswith("]"):
            raise ValueError("Missing or unexpected axiom report: " + output)
        used = output[len(label):-1].split(", ")
        if not set(used) <= allowed:
            raise ValueError("Unexpected axiom: " + output)
        # Check the source interface catches a stricter bound contradicted by the three-site cycle.
        f = tmp / "Counting.lean"
        text = f.read_text()
        old = "(cycle.length : Int) - 2 * demand j cycle"
        if text.count(old) != 1:
            raise ValueError("Could not identify the frozen inequality")
        f.write_text(text.replace(old, "(cycle.length : Int) - 3 * demand j cycle"))
        call("-o", "Counting.olean", names[0])
        call("-o", "CountingProof.olean", names[1], must_pass=False)
        return {"target": "TransportCounting.CountingBound", "toolchain": toolchain,
                "checked_at_trust_zero": True, "axioms": used,
                "negative_control": "Coefficient 3 rejected",
                "sha256": {f: sha256((source / f).read_bytes()).hexdigest() for f in names}}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lean", default=os.environ.get("WORKBENCH_LEAN", "lean"))
    args = parser.parse_args()
    print(json.dumps(replay(args.lean, Path(__file__).resolve().parent), indent=2))
