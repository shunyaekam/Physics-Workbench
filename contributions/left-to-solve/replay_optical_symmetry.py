"""Replay the strengthened six-photon diagonal-edge support certificate, with no SAT solver."""
from itertools import combinations, permutations, product
from collections import Counter

edges = list(combinations(range(6), 2))
matchings = [m for m in combinations(range(15), 3) if len({v for e in m for v in edges[e]}) == 6]
s = lambda c, e: 1 + 15*c + e
t = lambda c, e: 46 + 15*c + e
p = lambda c, m: 91 + 15*c + m

def clauses():
    cuts = {frozenset(e for e, (u, v) in enumerate(edges) if x[u]+x[v]) for x in product((-1, 0, 1), repeat=6) if sum(x)>0}
    cuts = [a for a in cuts if not any(b < a for b in cuts)]
    cnf=[]
    for c in range(3):
        for e in range(15):
            for d in range(3):
                cnf.append([-t(c,e), s(c,e) if c==d else -s(d,e)])
        for i, m in enumerate(matchings):
            for e in m:
                cnf.append([-p(c,i), s(c,e)])
        for cut in cuts:
            cnf.append([t(c,e) for e in sorted(cut)])
    for m in matchings:
        for i,j,k in permutations(m):
            cnf.append([-s(0,i),-s(1,j),-s(2,k)])
    return cnf

def unit_conflict(cnf, assumed):
    values=set(assumed)
    while True:
        fresh=set()
        for cl in cnf:
            if any(v in values for v in cl):
                continue
            rest=[v for v in cl if -v not in values]
            if not rest:
                return True
            if len(rest)==1:
                fresh.add(rest[0])
        if any(-v in fresh for v in fresh):
            return True
        if not fresh:
            return False
        values.update(fresh)

def main():
    cnf=clauses()
    assert len(cnf)==621 and len(matchings)==15
    actions={}
    for perm in permutations(range(6)):
        edgeperm=[edges.index(tuple(sorted((perm[u],perm[v])))) for u,v in edges]
        actions[perm]=[matchings.index(tuple(sorted(edgeperm[e] for e in m))) for m in matchings]
    representatives={}
    for triple in product(range(15),repeat=3):
        if triple in representatives:
            continue
        for sigma in actions.values():
            for perm in permutations(range(3)):
                representatives[tuple(sigma[triple[c]] for c in perm)]=triple
    sizes=Counter(representatives.values())
    blocked={m for m in sizes if unit_conflict(cnf,[p(c,j) for c,j in enumerate(m)])}
    assert len(blocked)==7
    for (a,b,c) in sorted(sizes.keys()-blocked):
        common=set(matchings[a]) & set(matchings[b]) & set(matchings[c])
        assert len(common)==1
        e,=common
        assert all(representatives[m,b,c] in blocked for m in range(15) if e not in matchings[m])
    print('triples',len(representatives),'orbits',len(sizes),'unit refutations',len(blocked),
          'remainder discharged by changing the red matching')
if __name__=='__main__': main()
