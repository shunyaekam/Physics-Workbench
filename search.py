"""Bounded numerical search. Every retained witness must pass verify.py."""
import math
import random
from fractions import Fraction as Q

import numpy as np
from scipy.optimize import minimize, linprog

from verify import lower_bound, werner


PARAMS = {
    "thomson": {"degree": (1, 12, 5), "restarts": (1, 6, 2), "jitter_pct": (0, 80, 20)},
    "werner": {"samples": (1, 1000, 120), "support": (1, 4, 2), "mutate_pct": (0, 100, 60)}
}


def certificate(n, degree):
    grid = np.linspace(-1, 1-1e-5, 4001)
    A = np.polynomial.legendre.legvander(grid, degree)
    obj = np.full(degree+1, n/2)
    obj[0] -= n*n/2
    sol = linprog(obj, A_ub=A, b_ub=1/np.sqrt(2-2*grid),
                  bounds=[(None,None)] + [(0,None)]*degree, method="highs")
    if not sol.success:
        raise RuntimeError(sol.message)
    rounded = [round(v*10**9) for v in sol.x]
    for margin in (1, 10, 100, 1000, 10000, 100000, 1000000):
        coeff = [rounded[0]-margin] + rounded[1:]
        try:
            lower_bound(n, coeff)
            return coeff
        except ValueError:
            continue
    raise ValueError("LP failed exact rational certification")


def thomson(problem, params, seed):
    n = problem["n"]
    if n == 2:
        return {"points":[[1,0,0],[-1,0,0]], "coeff":[500000000]}
    rng = np.random.default_rng(seed)
    i, j = np.triu_indices(n, 1)

    def objective(x):
        raw = x.reshape(n, 3)
        lengths = np.linalg.norm(raw, axis=1)[:,None]
        unit = raw/lengths
        delta = unit[i]-unit[j]
        inv = 1/np.linalg.norm(delta, axis=1)
        g = np.zeros_like(unit)
        force = -delta * inv[:,None]**3
        np.add.at(g, i, force)
        np.add.at(g, j, -force)
        g = (g - unit*(g*unit).sum(axis=1)[:,None])/lengths
        return inv.sum(), g.ravel()

    t = np.arange(n)
    z = (2*t+1)/n-1
    phi = t * math.pi*(3-math.sqrt(5))
    radius = np.sqrt(1-z*z)
    start = np.stack([radius*np.cos(phi),radius*np.sin(phi),z], axis=1)
    best = None
    for _ in range(params["restarts"]):
        x = start + params["jitter_pct"]/100 * rng.normal(size=(n,3))
        result = minimize(objective, x.ravel(), jac=True, method="L-BFGS-B",
                          options={"maxiter":1600, "ftol":1e-15, "gtol":1e-10})
        if math.isfinite(result.fun) and (best is None or result.fun < best.fun):
            best = result
    if best is None:
        raise ValueError("no finite geometry")
    points = []
    for u in best.x.reshape(n, 3):
        a,b,z = u / np.linalg.norm(u)
        points.append([1 if z >= 0 else -1, round(1e7*a/(1+abs(z))), round(1e7*b/(1+abs(z)))])
    return {"points":points, "coeff":certificate(n,params["degree"])}


def werner_search(problem, params, seed):
    import copy
    rng = random.Random(seed)
    size = problem["d"]**problem["copies"]
    support = min(size, params["support"])
    def vector():
        return [[i,rng.choice((-2,-1,1,2))] for i in rng.sample(range(size),support)]
    # A diagonal rank-two seed with adjacent basis labels provides a known control.
    best = {"terms":[[[[i,1]],[[i,1]]] for i in (0,1)]}
    score = Q(werner(problem,best)["score"])
    for _ in range(params["samples"]):
        if rng.randrange(100) < params["mutate_pct"]:
            candidate = copy.deepcopy(best)
            candidate["terms"][rng.randrange(2)][rng.randrange(2)] = vector()
        else:
            candidate = {"terms":[[vector(),vector()], [vector(),vector()]]}
        try:
            energy = Q(werner(problem,candidate)["score"])
        except ValueError as e:
            if str(e) == "zero vector":
                continue
            raise
        if energy < score:
            best,score = candidate,energy
    return best


SEARCH = {"thomson": thomson, "werner": werner_search}
