"""Change one parent edge in either of the first two tree extractions of a checked circuit."""
from collections import Counter
from itertools import chain
import json
from pathlib import Path
import random

from css_peeling import ROOT, check, circuit, reduce_tree, spaces, steps


def substitutions(root, edges):
    for index, (old, child) in enumerate(edges):
        for parent in [c for _, c in edges[index+1:]] + [root]:
            if parent != old:
                yield index, parent, edges[:index] + [(parent, child)] + edges[index+1:]


def run():
    pilot = json.loads((ROOT/"campaign/golay-focus/css-trees.json").read_text())
    seed = pilot["best"]["seed"]
    initial = spaces()
    baseline = list(steps(initial, random.Random(seed), pilot["fanout"], True, 23))
    if circuit(baseline) != pilot["best"]["witness"] or check(circuit(baseline)) != pilot["best"]["result"]:
        raise ValueError("Cannot reproduce the recorded starting circuit")
    histogram, best, branches = Counter(), None, []
    tails_per_branch = 8
    for depth in range(2):
        state = baseline[depth-1][-1] if depth else initial
        root, axis, edges, _ = baseline[depth]
        for index, parent, changed in substitutions(root, edges):
            reduced = reduce_tree(state, axis, root, changed)
            prefix = baseline[:depth] + [(root, axis, changed, reduced)]
            branch = len(branches)
            best_on_branch = 100
            for sibling in range(tails_per_branch):
                tail_seed = 1000000 + branch * tails_per_branch + sibling
                tail = steps(reduced, random.Random(tail_seed), pilot["fanout"], True, 23-len(prefix))
                witness = circuit(chain(prefix, tail))
                result = check(witness)
                if not result["target_prepared"]:
                    raise ValueError("Candidate failed signed replay")
                cost = result["cnot_count"]
                histogram[cost] += 1
                best_on_branch = min(best_on_branch, cost)
                if best is None or cost < best["result"]["cnot_count"]:
                    best = dict(branch=branch, seed=tail_seed, result=result, witness=witness)
            branches.append(dict(delta_depth=depth, edge=index, parent_wire=parent.bit_length()-1,
                                 best_cost=best_on_branch))
    return dict(problem_id="golay43", method="first-two-tree single-edge branching",
                start_seed=seed, start_cnot_count=pilot["best"]["result"]["cnot_count"],
                trials=sum(histogram.values()), tails_per_branch=tails_per_branch,
                branches=branches, checked_gate_counts=dict(sorted(histogram.items())), best=best,
                scope="Every alternate parent consistent with the existing leaf-removal order in the "
                      "first or second extraction of one starting circuit. Eight sampled suffixes per branch.")


if __name__ == "__main__":
    print(json.dumps(run(), indent=2))
