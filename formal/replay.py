"""Replay the named Werner and Fock arithmetic lemmas with the pinned Lean kernel."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

HERE = Path(__file__).resolve().parent
VERSION = (HERE / "lean-toolchain").read_text().strip().split(":v")[1]
CLAIMS = ["Workbench.triangle_parity", "Workbench.anchor_iff_all"]


def pinned_lean():
    cached = Path.home() / "Library/Caches/Physics-Workbench" / f"lean-{VERSION}-darwin_aarch64/bin/lean"
    lean = os.environ.get("WORKBENCH_LEAN") or (str(cached) if cached.exists() else shutil.which("lean"))
    if not lean:
        raise SystemExit("Install the toolchain in formal/lean-toolchain or set WORKBENCH_LEAN.")
    version = subprocess.check_output([lean, "--version"], text=True, cwd=HERE).strip()
    if f"version {VERSION}," not in version:
        raise ValueError(f"Expected Lean {VERSION}, got {version}")
    return lean, version


def replay():
    lean, version = pinned_lean()
    file = HERE / "SupportParity.lean"
    result = subprocess.run([lean, "-DwarningAsError=true", file.name], cwd=HERE, capture_output=True,
                            text=True, check=True)
    expected = [f"'{name}' depends on axioms: [propext]" for name in CLAIMS]
    if result.stdout.splitlines() != expected:
        raise ValueError("Unexpected axiom report: " + result.stdout)
    fock = HERE / "FockMoment.lean"
    fock_report = subprocess.check_output([lean, "-DwarningAsError=true", fock.name], cwd=HERE, text=True)
    fock_expected = ["'Workbench.Fock.fourthMoment_step' depends on axioms: [propext, Quot.sound]",
                     "'Workbench.Fock.baseMoments' does not depend on any axioms"]
    if fock_report.splitlines() != fock_expected:
        raise ValueError("Unexpected Fock axiom report: " + fock_report)
    rail = HERE / "SingleRail.lean"
    rail_report = subprocess.check_output([lean, "-DwarningAsError=true", rail.name], cwd=HERE, text=True)
    rail_expected = [f"'Workbench.SingleRail.{name}' does not depend on any axioms"
                     for name in ("lowCoefficients", "tailBound")]
    if rail_report.splitlines() != rail_expected:
        raise ValueError("Unexpected single-rail axiom report: " + rail_report)
    return {"toolchain": version, "single_rail": {"source_sha256": hashlib.sha256(rail.read_bytes()).hexdigest(),
            "axiom_report": rail_expected, "scope": "Seventeen integer coefficient comparisons and one tail comparison"}, "source_sha256": hashlib.sha256(file.read_bytes()).hexdigest(),
            "axiom_report": expected, "scope": "Hamming parity and the anchored triangle equivalence only",
            "fock": {"source_sha256": hashlib.sha256(fock.read_bytes()).hexdigest(),
                     "axiom_report": fock_expected,
                     "scope": "Positive two-step polynomial difference for every n and two base moments"}}


if __name__ == "__main__":
    print(json.dumps(replay(), indent=2))
