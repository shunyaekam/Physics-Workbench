"""Enumerate the necessary syndrome-count conditions derived in the accompanying proof."""
from collections import Counter
from math import comb


def exclusion(n, repeated):
    rank = n - 5
    distinct = 3*n - repeated
    # Rank counts the independent check operators after stripping fixed factors.
    words = sorted(bin(i).count('1') for i in range(1, 2**rank))
    if distinct > len(words):
        return 'too few nonzero syndromes'
    cheapest = words[:distinct]
    lower = sum(cheapest) + repeated
    upper = 2 * ((rank-repeated)*6 + 2*repeated)
    if lower > upper:
        return 'incidence budget exceeded'
    # At equality with no repetitions the syndrome weights have this unique multiset,
    # even if the choice of individual bit strings at the last weight is nonunique.
    if lower == upper and repeated == 0 and sum(comb(w,2) for w in cheapest) % 2:
        return 'violates commuting-pair parity'
    return None


def bound():
    reasons = Counter()
    for n in range(5, 12):
        for repeated in range(n-5+1):
            reason = exclusion(n, repeated)
            if reason is None:
                raise ValueError(f'Surviving case at n={n}, repetitions={repeated}')
            reasons[reason] += 1
    return dict(sorted(reasons.items()))


if __name__ == '__main__':
    print(bound())
