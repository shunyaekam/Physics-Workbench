"""Independent finite stress test of the interval-chain certificate in the transport proof."""
from argparse import ArgumentParser
from itertools import combinations, permutations


def check_cycles(n):
    if n < 2:
        raise ValueError('At least two sites required')
    intervals = sorted(combinations(range(n), 2), key=lambda ab: (ab[1], ab[0]))
    spanning = {(u, v): tuple((int(v <= a < b <= u) - int(u <= a < b <= v))
                               for a, b in intervals)
                for u in range(n) for v in range(n) if u != v}
    total = 0
    positive = 0
    max_demand = 0
    for k in range(2, n + 1):
        for sites in combinations(range(n), k):
            for tail in permutations(sites[1:]):
                cycle = (sites[0], *tail)
                hm = [sum(row) for row in zip(*(spanning[cycle[i - 1], cycle[i]]
                                                  for i in range(k)))]
                total += 1
                r = max(0, max(hm))
                if not r:
                    continue
                positive += 1
                max_demand = max(r, max_demand)
                # Independent greedy multicover: plug each unmet interval demand
                # at its rightmost interior site. Explicitly inspect the resulting
                # chains, including repeated demands and skipped cycle vertices.
                points = []
                for (a, b), h in zip(intervals, hm):
                    if b == a + 1 and h:
                        raise ValueError(('adjacent atom', cycle, a, b, h))
                    deficiency = h - sum(a < t < b for t in points)
                    if deficiency > 0:
                        points.extend([b - 1] * deficiency)
                points.sort()
                chains = [set(points[j::r]) for j in range(r)]
                if sum(2 + len(s) for s in chains) > k:
                    raise ValueError(('cycle budget', cycle, chains))
                for (a, b), h in zip(intervals, hm):
                    if sum(any(a < t < b for t in cut) for cut in chains) < h:
                        raise ValueError(('deficient atom', cycle, a, b, h))
    return total, positive, max_demand


if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('--sites', type=int, default=8)
    args = parser.parse_args()
    total, positive, highest = check_cycles(args.sites)
    print(f'{total} directed simple cycles, {positive} with positive demand, maximum '
          f'atom demand {highest}; all reconstructed chains satisfy every atom and the cycle budget.')
