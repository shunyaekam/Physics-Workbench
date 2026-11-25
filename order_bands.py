"""Accumulate rigorous rectangles in photon population and Husimi entropy order."""
from fractions import Fraction as F
from functools import lru_cache
import json
from time import monotonic

from single_rail_regions import DEST, enclose
from renyi_scan import scaled, transcendental

LOW, HIGH = F(29, 100), F(1, 2)
SHELLS = 9  # The angular estimate in the paper covers s >= 9.
OUT = DEST / "bands"
TILES_PER_ROUND = 3500


@lru_cache(4096)
def vacuum_offset(a):
    # h_a(Q_vac) = log(pi) + log(a)/(a-1).
    return scaled(transcendental(a, "log"), 1/(a-1))


def process(shell, budget, state=None, deadline=None, low=LOW, high=HIGH, start=None):
    start = F(shell) if start is None else F(start)
    width = shell+1-start
    state = state or dict(shell=shell, domain=[str(low), str(high)], tested=0,
                          positive=0, negative=[], unresolved=[], pending=[[0, 0, 0, 0]])
    while budget and state["pending"]:
        if deadline is not None and monotonic() >= deadline:
            break
        ds, i, da, j = tile = state["pending"].pop()
        l, h = start+width*F(i, 2**ds), start+width*F(i+1, 2**ds)
        u = low+(high-low)*F(j, 2**da)
        v = low+(high-low)*F(j+1, 2**da)
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
    parser.add_argument("action", choices=("replay",))
    parser.parse_args()
    replay()
