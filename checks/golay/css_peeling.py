"""Construct a Golay encoder directly from low-weight CSS stabilizers, without the 44-gate seed.

At each step choose a short X or Z stabilizer. A CNOT star reduces this
word to a singleton on its root. A second search allows a general tree. That qubit factors from the state, so
project both binary spaces off the root and continue on the remaining wires.
Only the final, independently signed stabilizer check counts a candidate.
"""
import argparse
from collections import Counter
import json
from pathlib import Path
import random
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from checks.golay_certificate import check

weight = getattr(int, "bit_count", lambda value: bin(value).count("1"))


def span(basis):
    result = [0]
    for element in basis:
        result += [word ^ element for word in result]
    return tuple(sorted(result))


def spaces():
    poly = sum(1 << i for i in (0, 2, 4, 5, 6, 10, 11))
    z = [poly << i for i in range(12)]
    return span([z[i] ^ z[i+1] for i in range(11)]), span(z)


def bits(word):
    while word:
        bit = word & -word
        yield bit
        word ^= bit


def star_pivot(state, axis, root):
    # For a chosen X word: each original X word with root set picks up
    # all other positions of the chosen word. On Z words only the root
    # can change. A Z pivot exchanges these transformation rules.
    reduced = []
    for current_axis, space in enumerate(state):
        if axis == current_axis:
            # Exactly one of w and w^word has zero root. The image after
            # clearing the singleton is that representative.
            reduced.append(tuple(w for w in space if not w & root))
        else:
            reduced.append(tuple(w & ~root for w in space))
    return tuple(reduced)


def tree_pivot(state, axis, leaves, root, rng):
    # Remove leaves in order. The parent still carries the same Pauli.
    # Binary CX propagation suffices for this CSS circuit; check() audits signs.
    edges = []
    rng.shuffle(leaves)
    for i, child in enumerate(leaves):
        parent = rng.choice(leaves[i+1:] + [root])
        edges.append((parent, child))
    return reduce_tree(state, axis, root, edges), edges


def reduce_tree(state, axis, root, edges):
    reduced = []
    for current_axis, space in enumerate(state):
        words = tuple(w for w in space if not w & root) if axis == current_axis else space
        for parent, child in edges:
            src, dst = (parent, child) if axis == current_axis else (child, parent)
            words = tuple(w ^ dst if w & src else w for w in words)
        reduced.append(tuple(w & ~root for w in words))
    return tuple(reduced)


def options(state):
    words = [(axis, w) for axis, group in enumerate(state) for w in group if w]
    shortest = min(weight(w) for _, w in words)
    return [(axis, w) for axis, w in words if weight(w) == shortest]


def quality(state):
    # Prefer another cheap factor, then a greater supply of such factors.
    cheapest = 24
    count = 0
    for group in state:
        for w in group:
            if w:
                size = weight(w)
                if size < cheapest:
                    cheapest, count = size, 1
                elif size == cheapest:
                    count += 1
    return cheapest, -count


def steps(state, rng, fanout, tree, count):
    for _ in range(count):
        eligible = options(state)
        candidates = []
        for _ in range(fanout):
            axis, word = rng.choice(eligible)
            root = rng.choice(tuple(bits(word)))
            leaves = list(bits(word ^ root))
            if tree:
                reduced, edges = tree_pivot(state, axis, leaves, root, rng)
            else:
                reduced = star_pivot(state, axis, root)
                edges = [(root, leaf) for leaf in leaves]
            candidates.append((quality(reduced), root, axis, edges, reduced))
        _, root, axis, edges, state = min(candidates, key=lambda c: c[0])
        yield root, axis, edges, state


def circuit(path):
    plus, inverse = [], []
    for root, axis, edges, _ in path:
        q = root.bit_length() - 1
        if axis == 0:
            plus.append(["H", q])
        for parent, child in edges:
            a, b = parent.bit_length()-1, child.bit_length()-1
            inverse.append(["CX", a, b] if axis == 0 else ["CX", b, a])
    return {"gates": plus + list(reversed(inverse))}


def trial(initial, rng, fanout, tree):
    return circuit(steps(initial, rng, fanout, tree, 23))


def run(trials, fanout, seed, tree=False):
    initial = spaces()
    histogram = Counter()
    best = None
    for offset in range(trials):
        circuit = trial(initial, random.Random(seed + offset), fanout, tree)
        result = check(circuit)
        if not result["target_prepared"]:
            raise ArithmeticError("Signed preparation failed")
        count = result["cnot_count"]
        histogram[count] += 1
        if best is None or count < best["result"]["cnot_count"]:
            best = dict(seed=seed + offset, result=result, witness=circuit)
        if result["decisive"]:
            break
    return dict(problem_id="golay43", method="minimum-weight CSS stabilizer " + ("tree" if tree else "star") + " peeling",
                first_seed=seed, requested_trials=trials, trials=sum(histogram.values()),
                fanout=fanout, checked_gate_counts=dict(sorted(histogram.items())), best=best,
                scope="Seeded CSS encoders; each completed circuit passed both signed stabilizer checks. "
                      "The minimum observed here gives no lower bound on unrestricted encoders.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--seed", type=int, default=230043)
    parser.add_argument("--trials", type=int, default=128)
    parser.add_argument("--fanout", type=int, default=6)
    parser.add_argument("--tree", action="store_true", help="sample a rooted tree on each support")
    args = parser.parse_args()
    if min(args.trials, args.fanout) < 1:
        parser.error("trials and fanout must be positive")
    print(json.dumps(run(args.trials, args.fanout, args.seed, args.tree), indent=2))
