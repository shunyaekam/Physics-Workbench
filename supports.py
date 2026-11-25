"""A resumable exact clique search for positive Werner endpoint compressions."""
from itertools import product
from functools import lru_cache
from pathlib import Path
import json

from lab import write
from verify import require


@lru_cache(maxsize=16)
def geometry(d, k):
    return list(product(range(d), repeat=k))


def graph(d, k, audit=False):
    words=geometry(d,k)
    rows=[]
    for i,x in enumerate(words):
        mask=0
        for j,y in enumerate(words):
            if j<=i:
                continue
            if audit:
                parity=sum(a!=b for a,b in zip(x,y))+sum(a!=0 for a in x)+sum(b!=0 for b in y)
            else:
                parity=sum(bool(a and b and a!=b) for a,b in zip(x,y))
            if parity%2==0:
                mask |= 1<<j
        rows.append(mask)
    for i,mask in enumerate(rows):
        while mask:
            bit=mask & -mask
            rows[bit.bit_length()-1] |= 1<<i
            mask-=bit
    return rows


def indices(mask):
    while mask:
        bit=mask & -mask
        yield bit.bit_length()-1
        mask-=bit


def greedy_clique(candidates,rows):
    clique=[]
    while candidates:
        v=max(indices(candidates),key=lambda i:bin(candidates & rows[i]).count("1"))
        clique.append(v)
        candidates &= rows[v]
    return clique


def coloring(mask,rows):
    colors=[]
    while mask:
        group=0
        avail=mask
        while avail:
            bit=avail & -avail
            group |= bit
            avail &= ~bit & ~rows[bit.bit_length()-1]
        colors.append(group)
        mask &= ~group
    return colors


def initial(d,k):
    return dict(d=d,k=k,best=[0],todo=[""],closed={})


def state(path,rows,root,base):
    candidates=root
    chosen=list(base)
    for digit in path:
        require(candidates!=0 and digit in "01","invalid split path")
        v=candidates.bit_length()-1
        candidates ^= 1<<v
        if digit=="1":
            chosen.append(v)
            candidates &= rows[v]
    return chosen,candidates


def advance(record,budget):
    rows=graph(record["d"],record["k"])
    base=[0]
    root=(1<<len(rows))-2
    if "orbit" in record:
        t=record["orbit"]
        words=geometry(record["d"],record["k"])
        fixed=words.index((1,)*t+(0,)*(record["k"]-t))
        base.append(fixed)
        root=rows[fixed] & sum(1<<i for i,w in enumerate(words) if i and sum(bool(a) for a in w)<=t)
    for _ in range(budget):
        if not record["todo"]:
            break
        path=record["todo"].pop()
        chosen,mask=state(path,rows,root,base)
        witness=chosen+greedy_clique(mask,rows)
        if len(witness)>len(record["best"]):
            record["best"]=witness
        colors=coloring(mask,rows)
        if len(chosen)+len(colors)<=len(record["best"]):
            record["closed"][path]=[hex(c) for c in colors]
        else:
            record["todo"].extend([path+"0",path+"1"])


def audit(record):
    # Decode the certificate with an independently formulated compatibility test
    # and ordinary sets. Prefix coverage is checked independently of traversal.
    d,k=record["d"],record["k"]
    rows=graph(d,k,True)
    best=record["best"]
    require(len(set(best))==len(best) and 0 in best,"bad anchored witness")
    words=geometry(d,k)
    require(all(type(v) is int and 0<=v<len(words) for v in best),"bad word")
    for n,v in enumerate(best):
        require(all(rows[v] & (1<<u) for u in best[:n]),"witness conflict")
    paths=list(record["closed"])+record["todo"]
    ordered=sorted(paths)
    require(bool(paths) and all(set(p)<=set("01") for p in paths),"invalid leaf")
    require(all(not b.startswith(a) for a,b in zip(ordered,ordered[1:])),"overlapping leaves")
    depth=max(map(len,paths))
    require(sum(1<<(depth-len(p)) for p in paths)==1<<depth,"missing branch")
    base={0}
    allowed=set(range(1,len(words)))
    if "orbit" in record:
        t=record["orbit"]
        require(type(t) is int and 1<=t<=k,"invalid layer")
        fixed=next(i for i,w in enumerate(words) if all(a==int(j<t) for j,a in enumerate(w)))
        base.add(fixed)
        allowed={i for i in allowed if i!=fixed and rows[fixed] & (1<<i)
                 and words[i].count(0)>=k-t}
        require(base<=set(best) and set(best)<=allowed|base,"lower witness outside layer")
    for path,colors in record["closed"].items():
        remaining=set(allowed)
        taken=len(base)
        for decision in path:
            vertex=max(remaining)
            remaining.remove(vertex)
            if decision=="1":
                taken+=1
                remaining={u for u in remaining if rows[vertex] & (1<<u)}
        require(taken+len(colors)<=len(best),"insufficient upper bound")
        for c in colors:
            bits=int(c,16)
            require(0<bits<(1<<len(rows)),"color mask outside universe")
            group=set(indices(bits))
            require(bool(group) and group<=remaining,"invalid coloring coverage")
            for v in group:
                require(all(u==v or not (rows[v] & (1<<u)) for u in group),"nonindependent color")
            remaining-=group
        require(not remaining,"missing color vertices")
    return not record["todo"]


if __name__=="__main__":
    import argparse
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument("certificate",type=Path)
    p=ap.parse_args()
    r=json.loads(p.certificate.read_text())
    print("complete" if audit(r) else "partial",r["d"],r["k"],len(r["best"]))
