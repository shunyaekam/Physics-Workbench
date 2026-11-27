"""Independent finite search for the first disk and walk records, integer lattice geometry."""
from fractions import Fraction as Q
from functools import lru_cache
from itertools import combinations
from collections import defaultdict

# Cartesian coordinates are (X/2, sqrt(3)*Y/2). A lattice point has X = Y mod 2.
P = [(x,y) for x in range(-3,7) for y in range(-2,4) if not (x-y)%2]
def dist4(p,q): return (p[0]-q[0])**2+3*(p[1]-q[1])**2
def quad(p): return dist4(p,(0,0))
def circle3(a,b,c):
    # Subtract a's equal-distance equation from those for b and c.
    u,v = 2*(b[0]-a[0]), 6*(b[1]-a[1])
    s,t = 2*(c[0]-a[0]), 6*(c[1]-a[1])
    h,k = quad(b)-quad(a), quad(c)-quad(a)
    d=u*t-s*v
    return (Q(h*t-k*v,d), Q(u*k-s*h,d)) if d else None
events=defaultdict(set)
def add(center,p):
    if center is None:return
    x,y=center
    if not (0<=y<1 and 0<=x-y<2):return
    d=dist4(center,p)
    if d<=13:events[d].add(center)
for a in P: add(a,a)
for a,b in combinations(P,2): add(tuple(Q(i+j,2) for i,j in zip(a,b)),a)
for a,b,c in combinations(P,3): add(circle3(a,b,c),a)

def best_walk(points):
    N=len(points)
    graph=[sum(1<<k for k,q in enumerate(points) if dist4(p,q)==4) for p in points]
    best=0
    for start in range(N):
        @lru_cache(None)
        def run(i,seen):
            vertices=bin(seen).count("1")
            # A cycle can close to the starting vertex with a fresh edge iff it has >=3 vertices.
            length=vertices-1+int(vertices>=3 and (graph[i]>>start)&1)
            nexts=graph[i]&~seen
            while nexts:
                bit=nexts&-nexts; nexts^=bit
                length=max(length,run(bit.bit_length()-1,seen|bit))
                if length==N:break
            return length
        best=max(best,run(start,1<<start))
        if best==N:break
    return best

record_points=[]; record_lengths=[]; max_points=max_length=-1
for d,centers in sorted(events.items()):
    point_count=0; length=0
    for c in centers:
        pts=[p for p in P if dist4(c,p)<=d]
        point_count=max(point_count,len(pts))
        if len(pts)>length:length=max(length,best_walk(pts))
    if point_count>max_points:
        max_points=point_count; record_points.append((d/4,point_count))
    if length>max_length:
        max_length=length; record_lengths.append((d/4,length))
print('Disk records',record_points)
print('Walk records',record_lengths)
assert [m for _,m in record_points]==[1,2,3,4,7,8,9,10,12,13,14]
assert [m for _,m in record_lengths]==[0,1,3,4,7,8,9,10,12,14]
