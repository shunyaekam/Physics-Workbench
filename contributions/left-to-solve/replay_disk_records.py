"""Exact disk and walk records on the unit triangular lattice up to radius²=13/4."""
from fractions import Fraction as Q
from functools import lru_cache
from itertools import combinations

LIMIT = Q(13, 4)

def norm(x, y):
    return x*x + x*y + y*y

def center_candidates(sites):
    yield Q(0), Q(0), Q(0)
    for x, y in sites:
        yield Q(x, 2), Q(y, 2), Q(norm(x, y), 4)
    for (x,y),(u,v) in combinations(sites, 2):
        a,b,c,d = 2*x+y, x+2*y, 2*u+v, u+2*v
        det = a*d-b*c
        if det:
            r,s = norm(x,y), norm(u,v)
            h,k = Q(r*d-b*s,det), Q(a*s-r*c,det)
            yield h,k,norm(h,k)

@lru_cache(None)
def longest(shape):
    n = len(shape)
    neighbors = [sum(1 << j for j, (u,v) in enumerate(shape) if norm(x-u,y-v)==1)
                 for x,y in shape]
    best = 0
    for start in range(n):
        @lru_cache(None)
        def extend(last, mask):
            length = bin(mask).count('1')-1
            ans = length
            if length >= 2 and neighbors[last] & (1 << start):
                ans = length+1
            allowed = neighbors[last] & ~mask
            while allowed:
                bit = allowed & -allowed
                allowed -= bit
                ans = max(ans, extend(bit.bit_length()-1, mask | bit))
            return ans
        best = max(best, extend(start,1 << start))
        extend.cache_clear()
        if best==n: break
    return best

def records():
    # A minimum disk has an antipodal pair or three boundary sites. Translate
    # one of those sites to (0,0). The other sites have squared norm ≤4*LIMIT.
    # Since norm(x,y)≥3*x²/4 and ≥3*y²/4, every coordinate has |value|≤4.
    sites=[(x,y) for x in range(-4,5) for y in range(-4,5) if norm(x,y)<=4*LIMIT]
    circles=set((x,y,r) for x,y,r in center_candidates([a for a in sites if a!=(0,0)]) if r<=LIMIT)
    by_radius={}
    for x,y,r in circles:
        points=[(u,v) for u,v in sites if norm(x-u,y-v)<=r]
        u,v=min(points)
        shape=tuple(sorted((a-u,b-v) for a,b in points))
        by_radius.setdefault(r,set()).add(shape)
    counts, walks = [], []
    for r, shapes in sorted(by_radius.items()):
        count=max(len(shape) for shape in shapes)
        walk=max(longest(shape) for shape in shapes)
        if not counts or count>counts[-1][1]: counts.append((r,count))
        if not walks or walk>walks[-1][1]: walks.append((r,walk))
    return counts,walks

if __name__=='__main__':
    counts,walks=records()
    print('squared radius | new maximum point count:', [(str(r),n) for r,n in counts])
    print('squared radius | new maximum walk length:', [(str(r),n) for r,n in walks])
    expected_radii = [Q(0), Q(1,4), Q(1,3), Q(3,4), Q(1), Q(7,4), Q(49,25),
                      Q(9,4), Q(7,3), Q(3), Q(13,4)]
    assert counts == list(zip(expected_radii, [1,2,3,4,7,8,9,10,12,13,14]))
    assert walks == list(zip(expected_radii[:9] + expected_radii[-1:], [0,1,3,4,7,8,9,10,12,14]))
    assert counts[9][1] == 13 and [length for _, length in walks if length][8] == 14
