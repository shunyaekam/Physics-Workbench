"""Exact Bernasconi-chain benchmarks. Run 'advance', 'all', or 'replay'."""
import argparse
from heapq import heappop, heappush
from itertools import combinations, islice
from math import comb
from pathlib import Path
import sys

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from lab import load, write

DIRECTORY = ROOT / "campaign/finite-spins"
PAPER = "https://arxiv.org/html/2504.00987v1#S4.T2"
CONTROL = "https://oeis.org/A102780/b102780.txt"
# Zhang et al., Table 2. Hexadecimal strings retain leading zeroes and pad on the right.
SEEDS = [
    (99, "0CF30C003783CBCC8DA92AAD4", 553),
    (107, "A78785B8D72AEA6D99DECDFD004", 673),
    (92, "EE01C0E77667DD34DAE94B5", 490),
    (92, "BB5495B2233288618FBC1E0", 490),
    (98, "993A76393CDB4BCF78FF00AA8", 529),
    (104, "0F80F3C20AAB1844295B6ED666", 600),
    (106, "696D27CA748C66071EAFDD1177C", 645),
    (108, "F2401F3D9FF1CF46D58D96AA959", 670),
    (110, "33F83762F128DF55064B5B7BE79C", 707),
    (112, "A0496A493FAECCC8AFC3D50E738F", 728),
    (114, "B6C3648DB19C8C387A9EAA8578000", 777),
    (116, "52DF72096B92DCC87407044C8E1D5", 802),
    (118, "E003FB9F87C674E5CD6D34CCB2AD54", 807),
]
JOBS = [(13, None, 6), (16, None, 24)] + SEEDS
RADIUS = 3


def job_id(n, seed):
    return f"chain-{n}-" + (seed.lower() if seed else "global")


def energies(states):
    # Direct sum of spin products for each displacement; no periodic wrapping.
    total = np.zeros(len(states), dtype=np.int64)
    for k in range(1, states.shape[1]):
        corr = (states[:, :-k] * states[:, k:]).sum(axis=1, dtype=np.int32)
        total += corr.astype(np.int64) ** 2
    return total


def bit_energy(bits, n, masks):
    # Independent representation: each disagreement subtracts two from the correlation.
    return sum((n-k - 2 * popcount((bits ^ (bits >> k)) & mask)) ** 2
               for k, mask in enumerate(masks, 1))


popcount = getattr(int, "bit_count", lambda x: bin(x).count("1"))


def escape_barrier(original, n, scores):
    """Smallest possible peak energy before first reaching three changed spins."""
    cost = {original: scores[original]}
    parent = {}
    queue = [(cost[original], original)]
    while queue:
        peak, state = heappop(queue)
        if peak != cost[state]:
            continue
        if popcount(original ^ state) == RADIUS:
            break
        for bit in range(n):
            neighbor = state ^ (1 << bit)
            next_peak = max(peak, scores[neighbor])
            if neighbor not in cost or next_peak < cost[neighbor]:
                cost[neighbor] = next_peak
                parent[neighbor] = state
                heappush(queue, (next_peak, neighbor))
    # An explicit single-flip path establishes the upper bound.
    path = [state]
    while path[-1] != original:
        path.append(parent[path[-1]])
    path.reverse()
    if (popcount(original ^ path[-1]) != RADIUS or max(scores[x] for x in path) != peak
            or any(popcount(a ^ b) != 1 for a,b in zip(path,path[1:]))):
        raise ArithmeticError("Invalid escape path")
    # Separate decision check: below the claimed peak, the reachable component
    # has no state at radius three. All neighbors of interior nodes were scored.
    reachable = {original} if scores[original] < peak else set()
    todo = list(reachable)
    while todo:
        x = todo.pop()
        if popcount(x ^ original) == RADIUS:
            raise ArithmeticError("Found a cheaper escape")
        for bit in range(n):
            y = x ^ (1 << bit)
            if scores[y] < peak and y not in reachable:
                reachable.add(y)
                todo.append(y)
    return dict(peak=peak, rise=peak-scores[original], reachable_below_peak=len(reachable),
                flips_from_left=[n-(a^b).bit_length()+1 for a,b in zip(path,path[1:])],
                path_energies=[scores[x] for x in path])


def solve(n, seed, baseline):
    masks = [(1 << (n-k))-1 for k in range(1, n)]
    original = int(seed, 16) >> ((-n) % 4) if seed else 0
    if seed and (len(seed) != (n+3)//4 or int(seed, 16) != original << ((-n) % 4)
                 or bit_energy(original, n, masks) != baseline):
        raise ValueError("Published sequence or baseline transcription mismatch")
    def neighbors(k):
        for positions in combinations(range(n), k):
            yield original ^ sum(1 << i for i in positions)
    groups = [(k, neighbors(k), comb(n,k)) for k in range(RADIUS+1)] if seed else [(None, range(1 << n), 1 << n)]
    shells = []
    landscape = {}
    for distance, cases, expected in groups:
        best, ties, checked, witness = None, 0, 0, None
        iterator = iter(cases)
        while True:
            batch = list(islice(iterator, 1024))
            if not batch:
                break
            width = (n+7)//8
            packed = np.frombuffer(b"".join(x.to_bytes(width, "big") for x in batch), dtype=np.uint8)
            binary = np.unpackbits(packed.reshape(-1,width), axis=1)[:, -n:]
            scores = energies(1 - 2 * binary.astype(np.int8))
            independent = [bit_energy(x,n,masks) for x in batch]
            if not np.array_equal(scores, independent):
                raise ArithmeticError("Integer checkers disagree")
            if seed:
                landscape.update(zip(batch, independent))
            low = int(scores.min())
            if best is None or low < best:
                best, ties, witness = low, 0, format(batch[int(scores.argmin())], f"0{n}b")
            if low == best:
                ties += int(np.count_nonzero(scores == best))
            checked += len(batch)
        if checked != expected:
            raise ArithmeticError("Incomplete enumeration")
        shells.append(dict(flips=distance, cases=checked, minimum=best, minimizers=ties, witness_bits=witness))
    if not seed and shells[0]["minimum"] != baseline:
        raise ArithmeticError("Published control mismatch")
    result = dict(id=job_id(n,seed), n=n, seed_hex=seed, baseline=baseline, source=PAPER if seed else CONTROL,
                domain="up to three flips from the published sequence" if seed else "all binary sequences",
                bit_convention="0 is +1; 1 is -1; open chain", shells=shells,
                checked=sum(s["cases"] for s in shells), minimum=min(s["minimum"] for s in shells))

    if seed:
        result["escape"] = escape_barrier(original, n, landscape)
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=("advance","all","replay"))
    args = parser.parse_args()
    DIRECTORY.mkdir(parents=True, exist_ok=True)
    for job in JOBS:
        path = DIRECTORY / (job_id(*job[:2]) + ".json")
        if args.mode == "replay" and not path.exists():
            continue
        if args.mode != "replay" and path.exists():
            continue
        result = solve(*job)
        if args.mode == "replay":
            if result != load(path):
                raise ArithmeticError(f"Receipt mismatch: {path}")
        else:
            write(path, result)
        print(result["id"], result["checked"], result["minimum"], flush=True)
        if args.mode == "advance":
            break
