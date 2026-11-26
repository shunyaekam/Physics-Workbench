"""Try a bounded Lean tactic script against the frozen cycle-counting proposition."""
import argparse
from hashlib import sha256
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1]))
from formal.replay import pinned_lean

GOAL = "TransportCounting.CountingBound"
CONTROL = "∀ (a : Nat) (cycle : List Nat), TransportCounting.demand (a,a+1) cycle = 0"
SYMBOLS = {"CountingBound", "positiveSum", "demand", "walk", "edge", "disjointInterior",
           "adjacentBalance", "List.sum_cons", "List.sum_nil", "List.length_cons",
           "List.length_nil", "List.map_cons", "List.map_nil", "Int.sub_self"}
ATOMIC = {"rfl", "assumption", "contradiction", "constructor", "left", "right", "omega",
          "simp", "simp_all", "grind", "decide", "all_goals omega", "all_goals simp_all"}


def statement():
    return {"target": GOAL, "definitions": (HERE / "Counting.lean").read_text(),
            "scope": "All simple directed cycles; a supporting counting lemma for quantum transport.",
            "grammar": {"atomic": sorted(ATOMIC), "symbols": sorted(SYMBOLS),
                        "commands": ["intro NAME ...", "cases NAME", "induction NAME",
                                     "exact SYMBOL_OR_NAME", "apply SYMBOL_OR_NAME", "unfold SYMBOL",
                                     "simp only [SYMBOL, SYMBOL]"],
                        "names": "fresh lowercase ASCII identifiers, at most 16 letters/digits",
                        "limit": "32 steps; each step within 160 characters"}}


def render(witness):
    if not isinstance(witness, dict) or set(witness) != {"steps"}:
        raise ValueError("Expected a steps object")
    steps = witness["steps"]
    if not isinstance(steps, list) or not 1 <= len(steps) <= 32:
        raise ValueError("Expected 1 through 32 tactics")
    names = set()
    for s in steps:
        if not isinstance(s, str) or len(s) > 160 or not re.fullmatch(r"[a-zA-Z0-9_., \[\]]+", s):
            raise ValueError("Unexpected tactic syntax")
        if s in ATOMIC:
            continue
        fields = s.split(" ")
        if fields[0] == "intro" and len(fields) >= 2:
            if any(not re.fullmatch("[a-z][a-z0-9]{0,15}", n) for n in fields[1:]):
                raise ValueError("Invalid binder name")
            names.update(fields[1:])
            continue
        if len(fields) == 2 and (fields[0] in {"cases", "induction"} and fields[1] in names
                                 or fields[0] in {"exact", "apply"} and fields[1] in names | SYMBOLS
                                 or fields[0] == "unfold" and fields[1] in SYMBOLS):
            continue
        match = re.fullmatch(r"simp only \[([A-Za-z0-9.,_ ]+)\]", s)
        if match and all(k.strip() in SYMBOLS | names for k in match[1].split(",")):
            continue
        raise ValueError("Tactic outside the finite grammar")
    return "\n".join("  " + s for s in steps)


def _attempt(witness, goal):
    steps = render(witness)
    lean, version = pinned_lean()
    definition = (HERE / "Counting.lean").read_bytes()
    contract = f"import Counting\nopen TransportCounting\ntheorem submitted : {goal} := by\n"
    result = {"target": goal, "scope": "supporting lemma", "decisive": False,
              "toolchain": version, "statement_sha256": sha256(definition + contract.encode()).hexdigest()}
    with tempfile.TemporaryDirectory() as work:
        root = Path(work)
        (root / "Counting.lean").write_bytes(definition)
        (root / "Proof.lean").write_text(contract + steps + "\n#print axioms submitted\n")
        import os
        env = {**os.environ, "LEAN_PATH": str(root)}
        flags = [lean, "-DmaxHeartbeats=300000", "-DwarningAsError=true"]
        subprocess.run(flags + ["-o", "Counting.olean", "Counting.lean"], cwd=root, env=env,
                       capture_output=True, text=True, check=True, timeout=30)
        try:
            run = subprocess.run(flags + ["--trust=0", "Proof.lean"], cwd=root, env=env, timeout=30,
                                 stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        except subprocess.TimeoutExpired:
            return {**result, "kernel_checked": False, "diagnostic": "Lean exceeded 30 seconds"}
        if run.returncode:
            return {**result, "kernel_checked": False, "diagnostic": run.stdout[:2500]}
        report = run.stdout.strip()
        match = re.fullmatch(r"'submitted' depends on axioms: \[([^\]]+)\]", report)
        if report != "'submitted' does not depend on any axioms" and not (
                match and set(match[1].split(", ")) <= {"propext", "Quot.sound", "Classical.choice"}):
            raise ValueError("Unexpected axiom report: " + report)
        return {**result, "kernel_checked": True, "axiom_report": report}


def check(witness):
    return _attempt(witness, GOAL)


def smoke():
    known = _attempt({"steps": ["exact adjacentBalance"]}, CONTROL)
    if not known["kernel_checked"] or known["decisive"]:
        raise AssertionError(known)
    short = check({"steps": ["unfold CountingBound", "intro cycle family j"]})
    if short["kernel_checked"] or "unsolved goals" not in short["diagnostic"]:
        raise AssertionError(short)
    for bad in (["sorry"], ["run_tac IO.println"], ["rfl\naxiom fake : False"], ["exact sorryAx"]):
        try:
            render({"steps": bad})
        except ValueError:
            continue
        raise AssertionError("Unexpected acceptance: " + str(bad))
    return {"proved_control": known, "open_target": short,
            "rejected_instructions": 4}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("witness", type=Path, nargs="?")
    parser.add_argument("--smoke", action="store_true")
    args = parser.parse_args()
    result = smoke() if args.smoke else check(json.loads(args.witness.read_text())) if args.witness else statement()
    print(json.dumps(result, indent=2))
