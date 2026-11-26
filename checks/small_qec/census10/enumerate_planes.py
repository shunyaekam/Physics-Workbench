#!/usr/bin/env python3
"""Replay the [[10,2,4]] minimum check-weight census using the connected graph6 catalog.

Usage: python3 review.py /path/to/vncorbits-files
Python 3.8+; no external dependencies. See Danielsen and Parker's classification
of self-dual additive codes over GF(4), https://doi.org/10.1016/j.jcta.2005.12.004 .
"""
import argparse
import json
from collections import Counter
from pathlib import Path
from itertools import combinations, combinations_with_replacement

N = 10
SIZE = 1 << N
POP = tuple(bin(i).count("1") for i in range(SIZE))
EXPECTED_CONNECTED = (1, 1, 1, 2, 4, 11, 26, 101, 440, 3132)


def decode_graph6(record, n):
    if ord(record[0]) - 63 != n:
        raise ValueError("wrong order")
    edges = []
    for c in record[1:]:
        k = ord(c) - 63
        if not 0 <= k < 64:
            raise ValueError("invalid graph6 byte")
        edges.extend((k >> b) & 1 for b in range(5, -1, -1))
    if len(edges) != 6 * ((n * (n - 1) // 2 + 5) // 6):
        raise ValueError("unexpected graph6 length")
    rows = [0] * n
    for j in range(n):
        for i in range(j):
            if edges[(j * (j - 1) // 2) + i]:
                rows[i] |= 1 << j
                rows[j] |= 1 << i
    return tuple(rows)


def components(path):
    catalog = {}
    for n, count in enumerate(EXPECTED_CONNECTED, start=1):
        lines = (path / ("vncorbits%d.g6" % n)).read_text().splitlines()
        graphs = [decode_graph6(s, n) for s in lines if s]
        if len(graphs) != count or len(set(graphs)) != count:
            raise ValueError("unexpected component count at order %d" % n)
        catalog[n] = graphs
    return catalog


def partitions(n, low=1):
    if not n:
        yield ()
    for first in range(low, n + 1):
        for tail in partitions(n - first, first):
            yield (first,) + tail


def graph_parents(catalog):
    for parts in partitions(N):
        profile = sorted(Counter(parts).items())

        def assemble(suffix, rows):
            if suffix == len(profile):
                yield tuple(rows)
                return
            n, mult = profile[suffix]
            for selected in combinations_with_replacement(catalog[n], mult):
                graph = rows.copy()
                for component in selected:
                    offset = len(graph)
                    graph.extend(r << offset for r in component)
                yield from assemble(suffix + 1, graph)
        yield from assemble(0, [])


def rank(vectors):
    pivots = [0] * N
    result = 0
    for value in vectors:
        while value:
            t = value.bit_length() - 1
            if pivots[t]:
                value ^= pivots[t]
            else:
                pivots[t] = value
                result += 1
                break
    return result


def analyze(rows, counts, ranks):
    # Within the parent, element a has X mask a and Z mask neighbors[a].
    neighbors = [0] * SIZE
    for v in range(1, SIZE):
        bit = v & -v
        neighbors[v] = neighbors[v ^ bit] ^ rows[bit.bit_length() - 1]
    weights = [POP[a | z] for a, z in enumerate(neighbors)]
    # Every error on <=3 sites. The syndrome here means z + Gamma*x.
    sites = [((1 << i), rows[i], (1 << i) ^ rows[i]) for i in range(N)]
    banned = {0}
    for letters in sites:
        banned.update(letters)
    for l, r in combinations(sites, 2):
        banned.update(x ^ y for x in l for y in r)
    for l, m, r in combinations(sites, 3):
        banned.update(x ^ y ^ z for x in l for y in m for z in r)
    missing = sorted(set(range(1, SIZE)) - banned)
    if not missing:
        return
    counts["parents_with_missing_syndrome"] += 1
    short = [t for t in range(1, SIZE) if weights[t] <= 3]
    # Any parent Pauli of weight <=3 must be in the stabilizer, i.e. all
    # labels of K pair trivially with its coefficient mask.
    admissible = [label for label in missing if all(not (POP[t & label] & 1) for t in short)]
    allowed = set(admissible)
    light = [t for t in range(1, SIZE) if weights[t] <= 5]
    valid = False
    for a, b in combinations(admissible, 2):
        # The sorted nonzero labels of this plane must be a < b < a xor b.
        c = a ^ b
        if c <= b or c not in allowed:
            continue
        valid = True
        counts["parent_plane_pairs_distance_at_least_four"] += 1
        subrank = rank(t for t in light if not ((POP[t & a] | POP[t & b]) & 1))
        ranks[subrank] += 1
    counts["parents_with_any_distance_at_least_four"] += int(valid)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("catalog", type=Path)
    args = parser.parse_args()
    catalog = components(args.catalog)
    counts = Counter()
    ranks = Counter()
    for rows in graph_parents(catalog):
        counts["parents"] += 1
        analyze(rows, counts, ranks)
    assert counts["parents"] == 3990
    print(json.dumps({"counts": counts, "rank_histogram_at_weight_five": dict(sorted(ranks.items()))}, sort_keys=True))


if __name__ == "__main__":
    main()
