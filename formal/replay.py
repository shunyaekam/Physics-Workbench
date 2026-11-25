"""Replay only the two named combinatorial lemmas with the pinned Lean kernel."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

HERE = Path(__file__).resolve().parent
VERSION = (HERE / "lean-toolchain").read_text().strip().split(":v")[1]
CLAIMS = ["Workbench.triangle_parity", "Workbench.anchor_iff_all"]


def replay():
    cached = Path.home() / "Library/Caches/Physics-Workbench" / f"lean-{VERSION}-darwin_aarch64/bin/lean"
    lean = os.environ.get("WORKBENCH_LEAN") or (str(cached) if cached.exists() else shutil.which("lean"))
    if not lean:
        raise SystemExit("Install the toolchain in formal/lean-toolchain or set WORKBENCH_LEAN.")
    version = subprocess.check_output([lean, "--version"], text=True, cwd=HERE).strip()
    if f"version {VERSION}," not in version:
        raise ValueError(f"Expected Lean {VERSION}, got {version}")
    file = HERE / "SupportParity.lean"
    result = subprocess.run([lean, "-DwarningAsError=true", file.name], cwd=HERE, capture_output=True,
                            text=True, check=True)
    expected = [f"'{name}' depends on axioms: [propext]" for name in CLAIMS]
    if result.stdout.splitlines() != expected:
        raise ValueError("Unexpected axiom report: " + result.stdout)
    return {"toolchain": version, "source_sha256": hashlib.sha256(file.read_bytes()).hexdigest(),
            "axiom_report": expected, "scope": "Hamming parity and the anchored triangle equivalence only"}


if __name__ == "__main__":
    print(json.dumps(replay(), indent=2))
