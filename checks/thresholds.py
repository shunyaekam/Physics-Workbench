"""Cross-check three-word critical parameters by exact physical compressions."""
from itertools import combinations,product
from fractions import Fraction
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from verify import require
from checks.scrutiny import psd


def check():
    total=0
    for k in (1,2,3):
        words=list(product(range(3),repeat=k))
        attained={}
        for xs in combinations(words,3):
            distances=sorted(sum(i!=j for i,j in zip(x,y)) for x,y in combinations(xs,2))
            if sum(distances)%2==1:
                attained.setdefault(min(distances),set()).add(tuple(distances))
            for p,q in ((1,3),(2,5),(3,7),(1,2)):
                # Each local factor is computed directly from I-alpha |Omega><Omega|.
                block=[]
                for x in xs:
                    row=[]
                    for y in xs:
                        value=1
                        for a,b in zip(x,y):
                            value*=q*int(a==b)-p
                        row.append(value)
                    block.append(row)
                a,b,c=distances
                t=Fraction(p,q-p)
                predicted=(sum(distances)%2==0 or
                           t**(2*a)+t**(2*b)+t**(2*c)+2*t**(a+b+c)<=1)
                require(psd(block)==predicted,"threshold contradicts physical matrix")
                total+=1
        for ell in range(1,k+1):
            candidates={ds for sep,items in attained.items() if sep>=ell for ds in items}
            if ell==k and k%2==0:
                require(not candidates,"unexpected odd full-distance triple")
            else:
                extremal=(ell,ell,ell+int(ell%2==0))
                require(extremal in candidates and all(all(i>=j for i,j in zip(ds,extremal)) for ds in candidates),
                        "sharp distance claim failed")
    print(total,"exact matrix/threshold comparisons passed")


if __name__=="__main__":
    check()
