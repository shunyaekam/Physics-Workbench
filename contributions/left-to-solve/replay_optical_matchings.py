"""Six-vertex, three-colour diagonal-edge obstruction; Python standard library."""
from itertools import combinations, permutations, product
from collections import Counter

EDGES = tuple(combinations(range(6), 2))

def mask(items):
    return sum(1 << e for e in items)

MATCHINGS = tuple(mask(m) for m in combinations(range(15), 3)
                  if len({v for e in m for v in EDGES[e]}) == 6)

def balances_components(s):
    neighbors = [[] for _ in range(6)]
    for i, (u, v) in enumerate(EDGES):
        if s & (1 << i):
            neighbors[u].append(v)
            neighbors[v].append(u)
    sides = {}
    for source in range(6):
        if source in sides:
            continue
        sides[source] = 1
        stack = [source]
        difference = 0
        bipartite = True
        while stack:
            u = stack.pop()
            difference += sides[u]
            for v in neighbors[u]:
                if v not in sides:
                    sides[v] = -sides[u]
                    stack.append(v)
                elif sides[v] == sides[u]:
                    bipartite = False
        if bipartite and difference != 0:
            return False
    return True

def main():
    # Minimal supports of a vector of edge weights whose incident sum is 1
    # are spanned by <= 6 linearly independent incidence columns.
    minimal = []
    for size in range(3, 7):
        for es in combinations(range(15), size):
            m = mask(es)
            if any(t & m == t for t in minimal):
                continue
            if balances_components(m):
                minimal.append(m)

    triples = tuple(tuple(1 << i for i in m) for m in
                    permutations(range(15), 3)
                    if mask(m) in MATCHINGS)

    def rainbow(a, b, c):
        return any((a & i) and (b & j) and (c & k) for i, j, k in triples)

    residual = possible = survivors = 0
    for a, b, c in combinations(minimal, 3):
        if (a & b) or (b & c) or (a & c) or rainbow(a, b, c):
            continue
        residual += 1
        for i, j, k in product(
                (m for m in MATCHINGS if not m & (b | c)),
                (m for m in MATCHINGS if not m & (a | c)),
                (m for m in MATCHINGS if not m & (a | b))):
            possible += 1
            if not rainbow(a | i, b | j, c | k):
                survivors += 1
    print('minimal sizes:', sorted(Counter(bin(m).count("1") for m in minimal).items()))
    print('residual triples:', residual, 'extensions:', possible, 'survivors:', survivors)
    assert survivors == 0

if __name__ == '__main__':
    main()
