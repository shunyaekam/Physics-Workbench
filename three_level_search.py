"""Screen coherent three-level states in the sector left by the sparse-state theorem."""
from functools import lru_cache
from itertools import combinations
from math import factorial
from pathlib import Path
import json
import numpy as np
from scipy.special import eval_genlaguerre, roots_legendre
from scipy.stats import qmc
from lab import write

OUT = Path(__file__).resolve().parent / "campaign/three-level"
TRIPLES = tuple(combinations(range(6),3))


@lru_cache(6)
def grid(levels, radial, angular):
    nodes, weights = roots_legendre(radial)
    x = (nodes+1)*32
    weights = weights*32*np.exp(-x)
    angle = np.exp(2j*np.pi*np.arange(angular)/angular)
    radii = np.array([np.sqrt((2*x)**n/factorial(n)) for n in levels])
    phases = np.array([angle**n for n in levels])
    diagonal = np.array([(-1)**n*eval_genlaguerre(n,0,2*x) for n in levels])
    cross = []
    for i,j in combinations(range(3),2):
        m,n=levels[i],levels[j]
        coeff = (2*(-1)**m*np.sqrt(factorial(m)/factorial(n)*(2*x)**(n-m))
                 *eval_genlaguerre(m,n-m,2*x))
        cross.append((i,j,coeff,angle**(n-m)))
    return weights,radii,phases,diagonal,cross


def residual(levels, coefficients, radial, angular):
    w,r,p,d,cross=grid(levels,radial,angular)
    c=np.asarray(coefficients,dtype=complex)
    c/=np.linalg.norm(c)
    husimi=np.abs(np.einsum('i,ij,ik->jk',c,r,p)).mean(axis=1)
    base=np.einsum('i,ij->j',np.abs(c)**2,d)
    W=np.broadcast_to(base[:,None],(radial,angular)).copy()
    for i,j,amp,phase in cross:
        W+=amp[:,None]*np.real(c[j]*c[i].conjugate()*phase)
    return float(w@np.abs(W).mean(axis=1)-(w@husimi)**2)


def run(round_id):
    OUT.mkdir(parents=True,exist_ok=True)
    path=OUT/f"batch-{round_id:08}.json"
    if path.exists():
        return
    levels=TRIPLES[(round_id-1)%len(TRIPLES)]
    points=qmc.Sobol(6,scramble=True,seed=991003+round_id).random_base2(6)
    ranked=[]
    for point in points:
        integers=np.rint(30*(point-.5)).astype(int).reshape(3,2)
        if np.any(np.all(integers==0,axis=1)):
            continue
        c=integers[:,0]+1j*integers[:,1]
        ranked.append((residual(levels,c,128,80),integers.tolist()))
    finalists=[]
    for coarse,ints in sorted(ranked,reverse=True)[:3]:
        c=[complex(*pair) for pair in ints]
        vals=[residual(levels,c,256,128),residual(levels,c,512,256)]
        finalists.append(dict(coefficients=ints,coarse=coarse,refined=vals))
    # Exact control for |1>: W1-H1 = 4/sqrt(e)-1-pi/2.
    control=residual((0,1,2),[0,1,0],512,256)
    if abs(control-(4*np.exp(-.5)-1-np.pi/2))>3e-4:
        raise ArithmeticError("One-photon normalization control failed")
    flagged=any(min(v['refined'])>0 for v in finalists)
    write(path,dict(round=round_id,levels=levels,tested=len(ranked),control=control,
                    status="needs_rigorous_enclosure" if flagged else "screen_only",
                    finalists=finalists))


if __name__=='__main__':
    import sys
    if sys.argv[1:] == ['advance']:
        paths=sorted(OUT.glob('batch-*.json'))
        next_round=int(paths[-1].stem.split('-')[-1])+1 if paths else 1
        run(next_round)
    else:
        run(int(sys.argv[1]))
