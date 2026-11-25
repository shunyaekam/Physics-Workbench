"""Accumulate rigorous rectangles in photon population and Husimi entropy order."""
from datetime import datetime
from fractions import Fraction as F
from functools import lru_cache
import json
from time import monotonic

from lab import write
from single_rail_regions import DEST, enclose
from renyi_scan import scaled, transcendental

LOW, HIGH = F(29, 100), F(1, 2)
SHELLS = 24  # The analytic large-radius argument covers s >= 24.
OUT = DEST / "bands"
TILES_PER_ROUND = 3500


@lru_cache(4096)
def vacuum_offset(a):
    # h_a(Q_vac) = log(pi) + log(a)/(a-1).
    return scaled(transcendental(a, "log"), 1/(a-1))


def process(shell, budget, state=None, deadline=None):
    state = state or dict(shell=shell, domain=[str(LOW), str(HIGH)], tested=0,
                          positive=0, negative=[], unresolved=[], pending=[[0, 0, 0, 0]])
    while budget and state["pending"]:
        if deadline is not None and monotonic() >= deadline:
            break
        ds, i, da, j = tile = state["pending"].pop()
        l, h = shell+F(i, 2**ds), shell+F(i+1, 2**ds)
        u = LOW+(HIGH-LOW)*F(j, 2**da)
        v = LOW+(HIGH-LOW)*F(j+1, 2**da)
        # h_a(Q) decreases in a, for every fixed Q. Its vacuum-subtracted
        # counterpart need not. Subtract the vacuum entropy at the other end.
        loss = vacuum_offset(u)[1] - vacuum_offset(v)[0]
        if enclose(l, h, v)[0] > loss:
            state["positive"] += 1
        elif enclose(l, h, u)[1] < -loss:
            state["negative"].append(tile)
        elif ds+da >= 40:
            state["unresolved"].append(tile)
        elif 3*(v-u) >= (h-l)/(1+l):
            state["pending"].extend([[ds, i, da+1, 2*j+1], [ds, i, da+1, 2*j]])
        else:
            state["pending"].extend([[ds+1, 2*i+1, da, j], [ds+1, 2*i, da, j]])
        budget -= 1
        state["tested"] += 1
    return state


def advance():
    OUT.mkdir(parents=True, exist_ok=True)
    for shell in range(SHELLS):
        path = OUT / f"shell-{shell:03}.json"
        saved = json.loads(path.read_text()) if path.exists() else None
        if saved and not saved["pending"]:
            continue
        state = process(shell, TILES_PER_ROUND, saved, deadline=monotonic()+55)
        write(path, state)
        print("Renyi band", shell, "certified positive/negative, unresolved, pending:",
              state["positive"], *(len(state[k]) for k in ("negative", "unresolved", "pending")))
        return


def report():
    rows = [json.loads(p.read_text()) for p in sorted(OUT.glob("shell-*.json"))]
    finished = {r["shell"] for r in rows if not any(r[k] for k in ("pending", "negative", "unresolved"))}
    upto = 0
    while upto in finished:
        upto += 1
    neg = sum(len(r["negative"]) for r in rows)
    unresolved = sum(len(r["unresolved"]) for r in rows)
    today = datetime.now().astimezone().date().isoformat()
    summary = f"""# Optical research status for {today}

The search tests every entropy order from 0.29 to 0.50 on optical qubits. Each closed rectangle covers a continuum of states and orders. The written large-radius argument covers squared amplitude ratio s ≥ 24. The remaining interval calculation covers 0 ≤ s ≤ 24.

Completed compact shells: {len(finished)} of {SHELLS}. The contiguous cover reaches s = {upto}. Certified negative rectangles: {neg}. Unresolved terminal rectangles: {unresolved}. The unfinished stack resumes on the next scheduled cycle.

Three Wigner–Husimi research notes have written proofs. The active interval search contributes to the Rényi-order note. Distinct proof regions and reruns are supporting evidence within that note. Independent expert review and priority remain open.
"""
    if upto == SHELLS:
        summary += "\nThe compact cover and analytic tail together establish the bound on the entire optical qubit throughout this order band. Reproduce the saved cover with `python3 order_bands.py replay`.\n"
    daily = DEST / "daily"
    daily.mkdir(parents=True, exist_ok=True)
    for path in (DEST / "status.md", daily / (today + ".md")):
        path.write_text(summary)


def replay():
    for path in sorted(OUT.glob("shell-*.json")):
        row = json.loads(path.read_text())
        shell = int(path.stem.split("-")[-1])
        if row != process(shell, row["tested"]):
            raise ValueError(f"Band certificate mismatch in {path}")
    print("Reproduced all saved order-band subdivisions.")


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("advance", "replay"))
    if parser.parse_args().action == "advance":
        advance()
        report()
    else:
        replay()
