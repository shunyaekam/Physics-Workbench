"""Search rank-seven hyperplane neighbors of Grassl's [[12,4,4]] group.

Python 3.9+, standard library. Source matrix, reversing the order of its sites:
https://codetables.de/QECC.php?q=4&n=12&k=4
"""
from itertools import combinations, product
import json

N = 12
MASK = (1 << N) - 1
PARENT = [
    "XZIZXIZYXIIX", "ZYIYZIYXZIIZ", "ZXZIXIYZXIXI", "YZYIZIXYZIZI",
    "ZZXXIIXXXXII", "YYZZIIZZZZII", "XXXXXXIIIIII", "ZZZZZZIIIIII",
]

def parity(v):
    return bin(v).count("1") % 2

def packed(s):
    return sum((int(p in "XY") << (N+i)) | (int(p in "ZY") << i)
               for i, p in enumerate(s))

def string(v):
    return "".join("IXZY"[((v >> (N+i)) & 1) + 2*((v >> i) & 1)] for i in range(N))

def swap(v):
    return ((v & MASK) << N) | (v >> N)

def weight(v):
    return bin(((v >> N) | v) & MASK).count("1")

def span(rows):
    elements = [0]
    for v in rows:
        elements += [s ^ v for s in elements]
    return elements

def independent(rows):
    pivots, chosen = {}, []
    for row in rows:
        v = row
        while v and v.bit_length() in pivots:
            v ^= pivots[v.bit_length()]
        if v:
            pivots[v.bit_length()] = v
            chosen.append(row)
    return chosen

def affine_solutions(equations):
    """Return one particular solution and generators of the homogeneous space."""
    nbits = 2*N
    mask = (1 << nbits)-1
    pivots = {}
    for coeff, rhs in equations:
        row = coeff | (rhs << nbits)
        while row & mask:
            i = (row & mask).bit_length()-1
            if i not in pivots:
                pivots[i] = row
                break
            row ^= pivots[i]
        else:
            if row >> nbits:
                return None, []
    solutions = []
    for free in [1 << nbits] + [1 << i for i in range(nbits) if i not in pivots]:
        v = free
        for i, row in sorted(pivots.items()):
            if parity(v & row):
                v |= 1 << i
        solutions.append(v & mask)
    return solutions[0], solutions[1:]

def search():
    parent = list(map(packed, PARENT))
    group = span(parent)
    buckets = [[] for _ in range(256)]
    for w in (1, 2, 3):
        for sites in combinations(range(N), w):
            for letters in product("XYZ", repeat=w):
                word = ["I"]*N
                for site, p in zip(sites, letters):
                    word[site] = p
                error = swap(packed(word))
                syndrome = sum(parity(error & g) << i for i,g in enumerate(parent))
                buckets[syndrome].append(error)
    if buckets[0]:
        raise ValueError("Parent has a short commuting error")
    for h in range(1, 256):
        subgroup = [g for i,g in enumerate(group) if not parity(i & h)]
        basis = independent(subgroup)
        # Short errors commute with the whole hyperplane exactly when their old
        # syndrome is h. Demand that every one anticommutes with its new check.
        eq = [(swap(v),0) for v in basis] + [(e,1) for e in buckets[h]]
        representative, kernel = affine_solutions(eq)
        if representative is None:
            continue
        # Representatives that differ by a subgroup element generate the same group.
        quotient = independent(basis + kernel)[len(basis):]
        for delta in span(quotient):
            r = representative ^ delta
            if r in subgroup:
                continue
            neighbor = subgroup + [g ^ r for g in subgroup]
            candidate = independent(sorted(neighbor, key=weight))
            if len(candidate) == 8 and max(map(weight, candidate)) <= 7:
                return dict(h=h, replacement=string(r),
                            generators=[string(v) for v in candidate])
    raise ValueError("Search found no neighbor reaching weight seven")

if __name__ == "__main__":
    print(json.dumps(search(), indent=2))
