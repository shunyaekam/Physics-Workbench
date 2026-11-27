"""Compare Golay encoder search policies on fresh paired seeds once per UTC week."""
from datetime import datetime, timezone
from hashlib import sha256
from pathlib import Path
import random
import subprocess
import sys
from time import monotonic

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from checks.golay import css_peeling as css
from lab import load, write

# Change the sequence of extraction geometries, with six candidate pivots per step.
# Depth 23 reproduces the earlier all-tree search. Depth 0 gives pure stars.
TREE_DEPTHS = (23, 12, 6, 18, 3, 0)
SEEDS_PER_SPLIT = 12
FANOUT = 6
VERSION = 1
OUT = ROOT / "campaign" / "method-trials"


def encoder(initial, depth, seed):
    rng = random.Random(seed)
    first = list(css.steps(initial, rng, FANOUT, True, depth))
    remaining = first[-1][-1] if first else initial
    tail = css.steps(remaining, rng, FANOUT, False, 23 - depth)
    return css.circuit([*first, *tail])


def improves(before, after):
    """Predeclared rule for this search lane, independent of either measurement clock."""
    gains = [a - b for a, b in zip(before, after)]
    if len(gains) != SEEDS_PER_SPLIT or len(after) != len(before):
        raise ValueError("Incomplete paired comparison")
    return (min(after) <= min(before) and sum(gains) >= len(gains)
            and sum(g > 0 for g in gains) > sum(g < 0 for g in gains))


def run(week, sequence, incumbent, seen):
    challenger = next(d for d in TREE_DEPTHS if d not in seen)
    start = monotonic()
    initial = css.spaces()
    arms = {depth: {"tree_depth": depth, "seconds": 0, "screen": [], "holdout": []}
            for depth in (incumbent, challenger)}
    best = None
    for split in ("screen", "holdout"):
        for i in range(SEEDS_PER_SPLIT):
            seed = int.from_bytes(sha256(f"golay-method-{VERSION}|{week}|{split}|{i}".encode()).digest()[:8], "big")
            order = (incumbent, challenger) if i % 2 == 0 else (challenger, incumbent)
            for depth in order:
                t = monotonic()
                witness = encoder(initial, depth, seed)
                result = css.check(witness)
                if not result["target_prepared"]:
                    raise ArithmeticError("Encoder failed signed replay")
                cost = result["cnot_count"]
                arm = arms[depth]
                arm["seconds"] += monotonic() - t
                arm[split].append(cost)
                if best is None or cost < best["result"]["cnot_count"]:
                    best = dict(seed=seed, tree_depth=depth, split=split, witness=witness, result=result)
    winner = incumbent
    if all(improves(arms[incumbent][s], arms[challenger][s]) for s in ("screen", "holdout")):
        winner = challenger
    return dict(version=VERSION, week=week, sequence=sequence, problem_id="golay43",
                revision=subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT,text=True).strip(),
                method="paired CSS encoder comparison", stage="method_evaluation", model_tokens=0,
                seeds_per_split=SEEDS_PER_SPLIT, fanout=FANOUT, elapsed_seconds=monotonic()-start,
                incumbent=arms[incumbent], challenger=arms[challenger], next_incumbent=winner,
                best=best, goal_cnot=43)


def advance(week):
    OUT.mkdir(exist_ok=True, parents=True)
    history = [load(p) for p in sorted(OUT.glob(f"v{VERSION}-*.json"))]
    def nominate(row):
        if row["best"]["result"]["decisive"]:
            write(ROOT/"campaign/golay-focus"/f"method-{row['week']}.json", row)
    if history and week <= history[-1]["week"]:
        nominate(history[-1])
        return
    seen = {TREE_DEPTHS[0], *(h["challenger"]["tree_depth"] for h in history)}
    if seen == set(TREE_DEPTHS):
        return
    incumbent = history[-1]["next_incumbent"] if history else TREE_DEPTHS[0]
    row = run(week, len(history)+1, incumbent, seen)
    write(OUT/f"v{VERSION}-{week}.json", row)
    nominate(row)


if __name__ == "__main__":
    advance(datetime.now(timezone.utc).strftime("%G-W%V"))
