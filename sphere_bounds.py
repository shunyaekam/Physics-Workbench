"""Exchange LP search and an independent exact Sturm check of Coulomb minorants."""
from fractions import Fraction
import numpy as np
from scipy.optimize import linprog,minimize_scalar
import sympy as sp

from verify import lower_bound,require


def independent(n,coeff):
    require(all(type(c) is int for c in coeff) and min(coeff[1:],default=0)>=0,"invalid harmonics")
    r=sp.Symbol("r")
    # Use physical chord distance directly. Primary checker expands in r/2.
    poly=sp.Poly(10**9-r*sum(c*sp.legendre(i,1-r*r/2) for i,c in enumerate(coeff) if c),r)
    require(poly.eval(0)>0 and poly.eval(2)>0 and poly.count_roots(0,2)==0,
            "minorant lacks the requested strict sign certificate")
    return Fraction(n*((n-1)*coeff[0]-sum(coeff[1:])),2*10**9)


def experiment(n,degree,seed):
    rng=np.random.default_rng(seed)
    r=np.unique(np.r_[np.linspace(0,2,501),rng.uniform(.01,2,size=150)])
    costs=np.full(degree+1,n/2)
    costs[0]-=n*n/2
    fine=np.linspace(0,2,4097)
    fine_matrix=np.polynomial.legendre.legvander(1-fine*fine/2,degree)
    for turn in range(12):
        constraint=r[:,None]*np.polynomial.legendre.legvander(1-r*r/2,degree)
        sol=linprog(costs,A_ub=constraint,b_ub=np.ones(len(r)),bounds=[(None,None)]+[(0,None)]*degree,
                    method="highs",options={"primal_feasibility_tolerance":1e-10,"dual_feasibility_tolerance":1e-10})
        if not sol.success:
            raise ValueError(sol.message)
        coeff=sol.x
        slack=1-fine*(fine_matrix@coeff)
        valleys=np.flatnonzero((slack[1:-1]<=slack[:-2]) & (slack[1:-1]<=slack[2:]))+1
        added=[]
        for i in valleys:
            fit=minimize_scalar(lambda x:1-x*np.polynomial.legendre.legval(1-x*x/2,coeff),
                                bounds=(fine[i-1],fine[i+1]),method="bounded",options={"xatol":1e-13})
            if fit.fun < -2e-10:
                added.append(fit.x)
        if not added:
            break
        r=np.unique(np.r_[r,added])
    raw=[int(round(c*10**9)) for c in coeff]
    for margin in [1<<i for i in range(19)]:
        saved=[raw[0]-margin]+raw[1:]
        try:
            bound=lower_bound(n,saved)
            require(independent(n,saved)==bound,"independent lower bounds disagree")
        except ValueError:
            continue
        return dict(n=n,degree=degree,seed=seed,lp_solves=turn+1,coeff=saved,lower=str(bound))
    raise ValueError("no doubly certified minorant")
