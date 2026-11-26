"""Independent signed-Pauli audit of the exhibited eleven-qubit stabilizer."""
from collections import Counter
from itertools import combinations, product
import hashlib
import json
from math import comb
from pathlib import Path
import sys

# Phase is an exponent of i. These are the exact single-site Pauli products.
single = {}
for p in 'IXYZ':
    single[p, 'I'] = single['I', p] = (0, p)
    single[p, p] = (0, 'I')
for a,b,c in ('XYZ','YZX','ZXY'):
    single[a,b],single[b,a] = (1,c),(3,c)


def compose(left, right):
    phase = left[0]+right[0]
    letters = []
    for a,b in zip(left[1],right[1]):
        extra,c = single[a,b]
        phase += extra
        letters.append(c)
    return (phase % 4, ''.join(letters))


def run(path):
    gs = [(0,s) for s in path.read_text().splitlines() if s]
    n = 11
    assert len(gs) == 6 and all(len(s)==n and set(s)<=set('IXYZ') for _,s in gs)
    identity = (0,'I'*n)
    for a,b in combinations(gs,2):
        assert compose(a,b)==compose(b,a)
    group = {identity}
    for g in gs:
        doubled = {compose(s,g) for s in group}
        assert len(group|doubled)==2*len(group)
        group |= doubled
    assert (2,identity[1]) not in group and len({s for _,s in group})==len(group)==64
    signed_codespace_trace=2**n//len(group)
    belongs = {s for _, s in group}
    normalizer,logicals=Counter(),Counter()
    samples={}
    for w in range(4):
        for sites in combinations(range(n),w):
            for labels in product('XYZ',repeat=w):
                sitestring=['I']*n
                for i,p in zip(sites,labels):
                    sitestring[i]=p
                x=(0,''.join(sitestring))
                if all(compose(x,g)==compose(g,x) for g in gs):
                    normalizer[w]+=1
                    if x[1] not in belongs:
                        logicals[w]+=1
                        samples.setdefault(w,x[1])
    # Character orthogonality projects each error shell onto the commutant.
    # Each supported site of a stabilizer contributes 1-z (one commute, two anticommute);
    # each trivial site contributes 1+3z. Mean over the whole group.
    hist=Counter(n-s.count('I') for _,s in group)
    dual=[]
    for w in range(n+1):
        acc=0
        for k,count in hist.items():
            acc+=count*sum((-1)**t*3**(w-t)*comb(k,t)*comb(n-k,w-t)
                           for t in range(max(0,w-(n-k)),min(k,w)+1))
        assert acc%64==0
        dual.append(acc//64)
    assert dual[:4]==[normalizer[i] for i in range(4)] and sum(dual)==4**n//64
    assert signed_codespace_trace==32 and [logicals[i] for i in range(3)]==[0,0,0] and logicals[3]>0
    return dict(generator_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                generator_weights=[n-s.count('I') for _,s in gs],
                group_order=len(group),dimension=signed_codespace_trace,
                stabilizer_weights=[hist[w] for w in range(n+1)],normalizer_weights=dual,
                logical_weight_3_count=logicals[3],first_logical_weight_3=samples[3])


if __name__ == '__main__':
    print(json.dumps(run(Path(sys.argv[1])),indent=2))
