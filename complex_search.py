"""Explore genuine complex Schmidt-rank-two candidates and check finalists twice."""
from collections import defaultdict
from fractions import Fraction
from random import Random
from itertools import combinations

from verify import require


def matrix(terms,d,k):
    require(1<=len(terms)<=2,"rank bound")
    cells=defaultdict(lambda:[0,0])
    for a,b in terms:
        for v in (a,b):
            require(1<=len(v)<=8,"sparsity")
            for i,r,j in v:
                require(type(i) is int and 0<=i<d**k and all(type(t) is int and abs(t)<=65536 for t in (r,j)),"bad factor")
        for i,u,v in a:
            for j,x,y in b:
                z=cells[i,j]
                z[0]+=u*x-v*y
                z[1]+=u*y+v*x
    result={ij:z for ij,z in cells.items() if any(z)}
    require(result,"zero vector")
    return result


def digits(i,d,k):
    return tuple(i//d**j % d for j in range(k))


def direct(w,d,k,p=1,q=2):
    cells=matrix(w,d,k)
    vec=[(digits(i,d,k),digits(j,d,k),u,v) for (i,j),(u,v) in cells.items()]
    total=0
    for i,j,u,v in vec:
        for a,b,x,y in vec:
            prod=u*x+v*y
            for l in range(k):
                prod*=q*int(i[l]==a[l] and j[l]==b[l])-p*int(i[l]==j[l] and a[l]==b[l])
                if not prod:
                    break
            total+=prod
    return Fraction(total,q**k*sum(u*u+v*v for i,j,u,v in vec))


def partial_traces(terms,d,k,p=1,q=2):
    # Expand the rank-two factors anew, using little-endian arithmetic on
    # indices to implement all subset contractions without the pair kernel.
    mat={}
    for a,b in terms:
        for i,x,y in a:
            for j,u,v in b:
                re,im=mat.get((i,j),(0,0))
                mat[i,j]=(re+x*u-y*v,im+y*u+x*v)
    norm=sum(x*x+y*y for x,y in mat.values())
    total=0
    for mask in range(1<<k):
        contracted=defaultdict(lambda:[0,0])
        for (i,j),(x,y) in mat.items():
            a=b=0
            for pos in range(k):
                if mask>>pos & 1:
                    if i%d!=j%d:
                        break
                else:
                    a=a*d+i%d
                    b=b*d+j%d
                i//=d
                j//=d
            else:
                z=contracted[a,b]
                z[0]+=x
                z[1]+=y
        m=bin(mask).count("1")
        total+=(-p)**m*q**(k-m)*sum(x*x+y*y for x,y in contracted.values())
    return Fraction(total,q**k*norm)


def search(d,k,seed,trials,previous=None):
    rng=Random(seed)
    size=d**k
    best=previous
    value=direct(best,d,k) if best else None
    tested=0
    for _ in range(trials):
        # Build on both parties' odd triples. A shared-coordinate permutation
        # preserves the problem; other copies vary to escape one-copy cases.
        a=rng.randrange(size)
        stride=d**rng.randrange(k)
        start=a-(a//stride%d)*stride
        ids=[start+j*stride for j in range(3)]+[rng.randrange(size)]
        if rng.randrange(2):
            axis=rng.choice([d**i for i in range(k) if d**i!=stride])
            for n in (1,2):
                src=ids[n]
                ids[n]=src+((src//axis%d+1)%d-src//axis%d)*axis
        def factor():
            subset=rng.sample(sorted(set(ids)),rng.randint(2,3))
            return [[j,rng.choice([-3,-1,1,3]),rng.randrange(-2,3)] for j in subset]
        candidate=[[factor(),factor()],[factor(),factor()]]
        if best and rng.randrange(2):
            import copy
            candidate=copy.deepcopy(best)
            t=rng.choice(rng.choice(rng.choice(candidate)))
            if rng.randrange(5)==0:
                t[0]=rng.choice(ids)
            else:
                idx=rng.choice([1,2])
                t[idx]=max(-65536,min(65536,t[idx]+rng.choice([-2,-1,1,2])))
        try:
            nonzero=matrix(candidate,d,k)
            for side in (0,1):
                words=[digits(i,d,k) for i in {pair[side] for pair in nonzero}]
                if not any(sum(len(set(t))==3 for t in zip(*triple))%2
                           for triple in combinations(words,3)):
                    break
            else:
                score=direct(candidate,d,k)
                tested+=1
                if value is None or score<value:
                    best,value=candidate,score
        except ValueError as e:
            if str(e)=="zero vector":
                continue
            raise
    require(value==partial_traces(best,d,k),"independent contractions disagree")
    return dict(d=d,k=k,seed=seed,trials=trials,evaluated=tested,witness=best,score=str(value))


def controls():
    for k in (1,2,3):
        pair=[[[[i,0,1]],[[i,0,-1]]] for i in (0,1)]
        for p,q in ((1,2),(2,3)):
            expected=Fraction((q-p)**(k-1)*(q-2*p),q**k)
            require(direct(pair,3,k,p,q)==expected==partial_traces(pair,3,k,p,q),"known sign failed")
    w=[[[[1,1,2],[3,2,1]],[[1,0,1],[3,1,-2]]],[[[0,2,1]],[[1,1,3],[0,1,1]]]]
    require(direct(w,3,2)==partial_traces(w,3,2),"complex interference control failed")
