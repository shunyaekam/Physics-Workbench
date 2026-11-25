"""Independent finite audits and tests which deliberately corrupt valid evidence."""
import copy
from itertools import combinations, product
from math import gcd
from functools import reduce
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
import supports
from verify import require


def psd(matrix):
    # Exact Schur complements, on positive integer multiples of each residual.
    m=matrix
    while m:
        p=m[0][0]
        if p<0 or (p==0 and any(m[0])):
            return False
        if p:
            tail=[[p*m[i][j]-m[i][0]*m[0][j] for j in range(1,len(m))] for i in range(1,len(m))]
            divisor=reduce(gcd,(abs(x) for row in tail for x in row),0) or 1
            m=[[x//divisor for x in row] for row in tail]
        else:
            m=[row[1:] for row in m[1:]]
    return True


def dense_checks():
    import numpy as np
    d=3
    omega=np.eye(d,dtype=int).ravel()
    one=2*np.eye(d*d,dtype=int)-np.outer(omega,omega)
    matrix=np.kron(one,one)
    words=list(product(range(d),repeat=2))
    groups=[]
    # An independent block decomposition found by graph connectivity of the
    # dense physical matrix. No assumed Hamming or mismatch sector formula.
    pending=set(range(len(matrix)))
    while pending:
        block=set()
        todo=[pending.pop()]
        while todo:
            v=todo.pop()
            block.add(v)
            more=pending.intersection(np.flatnonzero(matrix[v]))
            pending-=more
            todo.extend(more)
        groups.append(sorted(block))
    by_alice=[(i//27,i//3%3) for i in range(81)]
    positives=0
    for mask in range(1<<9):
        selected={w for i,w in enumerate(words) if mask & (1<<i)}
        predicted=all(sum(len(set(t))==3 for t in zip(*triple))%2==0 for triple in combinations(selected,3))
        ps=True
        for block in groups:
            ids=[i for i in block if by_alice[i] in selected]
            if not psd(matrix[np.ix_(ids,ids)].tolist()):
                ps=False
                break
        require(ps==predicted,"full physical matrix contradicts the parity criterion")
        positives+=ps
    return positives


def enumerate_ternary(k):
    words=list(product(range(3),repeat=k))
    origin=words[0]
    largest=outside=0
    def visit(chosen,candidates):
        nonlocal largest,outside
        largest=max(largest,len(chosen))
        if any(len(set(col))==3 for col in zip(*chosen)):
            outside=max(outside,len(chosen))
        for i,w in enumerate(candidates):
            allowed=[v for v in candidates[i+1:]
                     if sum(len(set(t))==3 for t in zip(origin,w,v))%2==0]
            visit(chosen+[w],allowed)
    visit([origin],words[1:])
    require(largest==2**k and outside==(3*2**(k-2) if k>=2 else 0),"extremal claim failed")
    return largest,outside


def mutation_checks():
    r=supports.initial(3,2)
    supports.advance(r,100000)
    require(supports.audit(r),"valid control did not finish")
    mutations=[]
    t=copy.deepcopy(r)
    del t["closed"][next(iter(t["closed"]))]
    mutations.append(t)
    t=copy.deepcopy(r)
    t["best"]=[0,1,2]
    mutations.append(t)
    t=copy.deepcopy(r)
    key=next(k for k,c in t["closed"].items() if c)
    t["closed"][key]=[]
    mutations.append(t)
    t=copy.deepcopy(r)
    t["todo"].append(next(iter(t["closed"])))
    mutations.append(t)
    # Put the whole root graph in one color. The cardinality bound passes,
    # but adjacent vertices cannot occupy the same color.
    t=copy.deepcopy(r)
    t.update(todo=[],closed={"":[hex((1<<9)-2)]})
    mutations.append(t)
    for t in mutations:
        try:
            supports.audit(t)
        except ValueError:
            continue
        raise AssertionError("corrupted evidence accepted")
    return len(mutations)


if __name__=="__main__":
    print("Dense tensor, 512 supports:",dense_checks(),"PSD including empty")
    for k in (1,2,3):
        print("All anchored ternary supports, k =",k,"maxima:",enumerate_ternary(k))
    print("Corruptions rejected:",mutation_checks())
