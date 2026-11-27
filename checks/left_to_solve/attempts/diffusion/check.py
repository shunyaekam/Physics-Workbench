"""Exact finite checks for Erdős 1164's discounted hitting lemma, using only stdlib."""
from collections import defaultdict
from fractions import Fraction
from math import comb

DIRECTIONS = ((1, 0), (-1, 0), (0, 1), (0, -1))
ORIGIN = (0, 0)


def advance(paths):
    expanded = defaultdict(int)
    for (x, y), count in paths.items():
        for dx, dy in DIRECTIONS:
            expanded[x + dx, y + dy] += count
    return expanded


def hit_counts(target, horizon):
    # Removing target paths after each step gives first arrivals by time.
    surviving = {ORIGIN: 1}
    first = [0]
    for time in range(1, horizon + 1):
        total = sum(surviving.values())
        surviving = advance(surviving)
        first.append(surviving.pop(target, 0))
        assert sum(surviving.values()) + first[-1] == 4 * total
    return first


def kernel_count(a, time):
    if (time + a) % 2 or abs(a) > time:
        return 0
    return comb(time, (time + a) // 2) ** 2


def main():
    horizon = 64
    offsets = (-20, -8, -4, 4, 6, 8, 16, 32, 66)
    unrestricted = {ORIGIN: 1}
    histories = {a: [int(a == 0)] for a in (0, *offsets)}
    for t in range(1, horizon + 1):
        unrestricted = advance(unrestricted)
        assert sum(unrestricted.values()) == 4 ** t
        for a, counts in histories.items():
            counts.append(unrestricted.get((a, 0), 0))
            assert counts[-1] == kernel_count(a, t)
    for j in range(1, horizon // 2 + 1):
        p = Fraction(histories[0][2*j], 4 ** (2*j))
        assert Fraction(1, 4*j) <= p <= Fraction(1, j+1)
    examples = 0
    for a in offsets:
        first = hit_counts((a, 0), horizon)
        for t in range(horizon + 1):
            assert histories[a][t] == sum(first[r] * histories[0][t-r] for r in range(1, t+1))
            assert histories[0][t] >= histories[a][t]
        for n in (4, 6, 7, 8, 16, 31, 32, 64):
            s = Fraction(n-1, n)
            lower = 1 - sum(Fraction(v, 4**t) * s**t for t,v in enumerate(first)) - s**(horizon+1)
            for d in range(4, min(n, abs(a))+1):
                # log(d) / log(n) <= 1 on this grid.
                assert lower >= Fraction(1, 48), (n,d,a)
                examples += 1
    print(f"Exact hit-time convolution and unrestricted path counts through {horizon} steps.")
    print(f"Infinite-tail lower bound passed for {examples} admissible (n,d,a) triples.")


if __name__ == "__main__":
    main()
