"""Recompile the transport example, type-check its public contract, and audit its axioms."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1]))
from formal.replay import pinned_lean

MODULES = ("Mathlib.Data.Real.Sqrt", "Mathlib.Tactic.NormNum", "Mathlib.Tactic.Linarith")
CLAIMS = ("LiteralContract.exactCuts", "LiteralContract.threeCosts", "LiteralContract.optimum")
FOUNDATIONS = {"propext", "Classical.choice", "Quot.sound"}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def dependencies(lean, prepare):
    base = Path(os.environ.get("XDG_CACHE_HOME", Path.home() /
                ("Library/Caches" if sys.platform == "darwin" else ".cache")))
    project = base / "Physics-Workbench/transport-literal" / sha(HERE / "lake-manifest.json")[:16]
    if prepare:
        project.mkdir(parents=True, exist_ok=True)
        for name in ("lake-manifest.json", "lakefile.toml", "lean-toolchain"):
            shutil.copyfile(HERE / name, project / name)
        bindir = Path(lean).resolve().parent
        lake = str(bindir / "lake")
        env = {**os.environ, "PATH": str(bindir) + os.pathsep + os.environ["PATH"],
               "MATHLIB_NO_CACHE_ON_UPDATE": "1"}
        # Reuse the locked revisions. Building only the Lean cache module avoids
        # relying on the host linker when fetching the upstream binary cache.
        subprocess.run([lake, "build", "Cache.Main"], cwd=project, env=env, check=True)
        subprocess.run([lake, "env", "lean", "--run", ".lake/packages/mathlib/Cache/Main.lean",
                        "get", *MODULES], cwd=project, env=env, check=True)
    manifest = json.loads((HERE / "lake-manifest.json").read_text())
    libs = []
    for p in manifest["packages"]:
        package = project / ".lake/packages" / p["name"]
        if not package.exists():
            raise RuntimeError("Install pinned mathlib once with replay.py --prepare")
        rev = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=package, text=True).strip()
        if rev != p["rev"]:
            raise RuntimeError("Unexpected revision of " + p["name"])
        libs.append(str(package / ".lake/build/lib/lean"))
    return libs


def compile_contract(lean, libs, proof, contract, recheck_imports=False):
    with tempfile.TemporaryDirectory() as tmp:
        path = Path(tmp)
        (path / "TransportLiteral.lean").write_text(proof)
        (path / "Verify.lean").write_text(contract)
        env = {**os.environ, "LEAN_PATH": os.pathsep.join([tmp, *libs])}
        command = [lean, "-DwarningAsError=true"]
        for args in (["-o", "TransportLiteral.olean", "TransportLiteral.lean"],
                     (["--trust=0"] if recheck_imports else []) + ["Verify.lean"]):
            proc = subprocess.run([*command, *args], cwd=path, env=env,
                                  stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
            if proc.returncode:
                raise ValueError(proc.stdout.strip() or f"Lean exited {proc.returncode}")
        audit = {}
        for line in proc.stdout.splitlines():
            match = re.fullmatch(r"'([^']+)' depends on axioms: \[([^\]]*)\]", line)
            if not match or match[1] in audit:
                raise ValueError("Unexpected axiom report: " + line)
            used = match[2].split(", ")
            if set(used) - FOUNDATIONS:
                raise ValueError("Nonstandard axioms: " + line)
            audit[match[1]] = used
        if set(audit) != set(CLAIMS):
            raise ValueError("Missing or unexpected audited theorem")
        return audit


def replay(prepare=False, self_test=False, recheck_imports=False):
    lean, version = pinned_lean()
    libs = dependencies(lean, prepare)
    proof = (HERE / "TransportLiteral.lean").read_text()
    contract = (HERE / "Verify.lean").read_text()
    audit = compile_contract(lean, libs, proof, contract, recheck_imports)
    controls = []
    if self_test:
        # The first two controls change the public contract, leaving the proof
        # untouched. The third case adds a new axiom to an otherwise true result.
        original = "  have := lower a b c 0 h\n  linarith"
        forged = proof.replace("theorem noExactLine", "axiom bogus : False\n\ntheorem noExactLine")
        forged = forged.replace("  rintro ⟨a, b, c, h⟩\n" + original, "  exact bogus.elim")
        cases = [("wrong uniform error", proof, contract.replace("(2 : ℝ)/3 ≤ e", "(3 : ℝ)/4 ≤ e")),
                 ("wrong projector height", proof, contract.replace("then 81 else 0", "then 16 else 0")),
                 ("extra axiom", forged, contract)]
        for name, p, c in cases:
            try:
                compile_contract(lean, libs, p, c)
            except ValueError as exc:
                if name == "extra axiom" and "Nonstandard axioms" not in str(exc):
                    raise
                controls.append(name)
            else:
                raise AssertionError("Accepted faulty evidence: " + name)
    return {"toolchain": version, "axioms": audit, "rechecked_imports": recheck_imports,
            "rejected_controls": controls,
            "sha256": {name: sha(HERE / name) for name in
                       ("TransportLiteral.lean", "Verify.lean", "lake-manifest.json")}}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prepare", action="store_true", help="Install pinned dependencies before replay")
    parser.add_argument("--self-test", action="store_true", help="Challenge the type and axiom checks")
    parser.add_argument("--recheck-imports", action="store_true", help="Ask Lean to type-check imports")
    args = parser.parse_args()
    print(json.dumps(replay(args.prepare, args.self_test, args.recheck_imports), indent=2))
