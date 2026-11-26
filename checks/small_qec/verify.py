"""Verify finite-code certificates using only the Python standard library."""
import itertools
import json
import sys
from pathlib import Path


def require(test, message):
    if not test:
        raise ValueError(message)


def anticommutes(a, b):
    return sum(x != 'I' and y != 'I' and x != y for x, y in zip(a, b)) % 2


def product(a, b):
    # Pauli multiplication modulo its scalar phase, with I=0,X=1,Y=2,Z=3.
    alphabet = 'IXYZ'
    return ''.join(alphabet[alphabet.index(x) ^ alphabet.index(y)] for x, y in zip(a,b))


def verify(case):
    n,k,d = case['n'],case['k'],case['d']
    rows = case['generators']
    require(len(rows)==n-k and all(len(s)==n and set(s)<=set('IXYZ') for s in rows), 'generator shape')
    require(all(not anticommutes(a,b) for a,b in itertools.combinations(rows,2)), 'noncommuting checks')
    group={'I'*n}
    for row in rows:
        require(row not in group,'dependent check')
        group.update([product(base,row) for base in group])
    require(len(group)==2**(n-k), 'rank')
    counts=[]
    first=None
    for w in range(1,d+1):
        logical=0
        for sites in itertools.combinations(range(n),w):
            for ops in itertools.product('XYZ',repeat=w):
                word=['I']*n
                for site,op in zip(sites,ops): word[site]=op
                word=''.join(word)
                if word not in group and all(not anticommutes(word,g) for g in rows):
                    logical+=1
                    if first is None: first=word
        counts.append(logical)
    require(all(c==0 for c in counts[:-1]) and counts[-1]>0,'distance differs')
    weight=max(sum(x!='I' for x in row) for row in rows)
    require(weight == case['weight'],'maximum check weight differs')
    return dict(n=n,k=k,d=d,weight=weight,group_size=len(group),logicals_by_weight=counts,example_logical=first)


if __name__=='__main__':
    data=Path(sys.argv[1]) if len(sys.argv)>1 else Path(__file__).with_name('codes.json')
    for entry in json.loads(data.read_text()):
        print(json.dumps(verify(entry),sort_keys=True))
