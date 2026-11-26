"""Reconstruct one candidate from its attributed catalogue neighbor (Python, NumPy, SciPy, C compiler)."""
import argparse
import ctypes as ct
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile

import numpy as np
from scipy.optimize import minimize
from scipy.spatial import ConvexHull

HERE = Path(__file__).resolve().parent


def ptr(array):
    return array.ctypes.data_as(ct.POINTER(ct.c_double))


def improve(x, threshold, iters, evaluate, sparse):
    n, dim = x.shape
    edges = np.empty((0, 2), dtype="i")
    if sparse:
        near = x @ x.T > 1 - 3.75 * (1-threshold)
        edges = np.ascontiguousarray(np.argwhere(np.triu(near, k=1)), dtype="i")
    edge_count = len(edges) if sparse else -1
    def objective(flat):
        v = flat.reshape(n,dim)
        lengths = np.linalg.norm(v, axis=1)[:,None]
        unit = v / lengths
        g = np.empty_like(unit)
        value = evaluate(n, dim, threshold, ptr(unit), ptr(g), edge_count,
                         edges.ctypes.data_as(ct.POINTER(ct.c_int)))
        g = (g - unit*(unit*g).sum(axis=1)[:,None])/lengths
        return value*1e8, (g*1e8).ravel()
    res = minimize(objective, x.ravel(), jac=True, method="L-BFGS-B",
                   options=dict(maxiter=iters, ftol=1e-21 if sparse else 1e-22, gtol=1e-12,
                                maxcor=9 if sparse else 16, maxls=30 if sparse else 45))
    unit = res.x.reshape(n,dim)
    unit = unit/np.linalg.norm(unit, axis=1)[:,None]
    return unit, (unit @ unit.T - 2*np.eye(n)).max()


def construct(seed, record, evaluate):
    n, dim = record["n"], record["d"]
    table = float(record["table_cosine"])
    if dim == 7:
        z, _ = improve(np.delete(seed,16,axis=0), table-3e-7, 550, evaluate, False)
        # The pilot saved the initial hit at 17 significant digits.
        best = (z @ z.T-2*np.eye(n)).max()
        step = 1e-5
    else:
        facets = ConvexHull(seed).equations
        best = 2
        for j in np.argsort(-facets[:,3])[:12]:
            guess = np.vstack([seed,facets[j,:3]])
            y, value = improve(guess, table-2e-5, 350, evaluate, True)
            if value < best:
                best, z = value, y
            if best < table-1e-8:
                break
        if best < table+0.00012:
            for delta in [3e-6,2e-6,1e-6,3e-7]:
                y,value = improve(z, table-delta, 1800, evaluate, True)
                if value < best:
                    best,z = value,y
        step = max(1e-6,table-best)
    for _ in range(19 if dim==7 else 17):
        y,value = improve(z, best-step, 1800 if dim==7 else 1200, evaluate, dim==3)
        if value < best:
            gain = best - value
            best,z = value,y
            step = (min(2e-4,max(1e-7,2*gain)) if dim==7
                    else max(5e-8,min(1e-4,1.9*gain)))
        else:
            step *= 0.4 if dim==7 else 0.45
    return z,best


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("dimension",type=int)
    parser.add_argument("count",type=int)
    parser.add_argument("output",type=Path)
    args = parser.parse_args()
    records = json.loads((HERE.parent/"comparisons.json").read_text())
    rec = next(r for r in records if (r["d"],r["n"])==(args.dimension,args.count))
    path = HERE.parent/f'{args.dimension}-{args.count}'/"seed.csv"
    if hashlib.sha256(path.read_bytes()).hexdigest()!=rec["seed_sha256"]:
        raise ValueError("Seed differs from pinned source")
    seed = np.loadtxt(path,delimiter=",")
    seed = seed/np.linalg.norm(seed,axis=1)[:,None]
    with tempfile.TemporaryDirectory() as tmp:
        lib = Path(tmp)/"penalty.so"
        subprocess.run(["cc","-O3","-shared","-fPIC",str(HERE/"penalty.c"),"-o",str(lib)],check=True)
        evaluate = ct.CDLL(str(lib)).penalty
        evaluate.argtypes = [ct.c_int,ct.c_int,ct.c_double,ct.POINTER(ct.c_double),
                             ct.POINTER(ct.c_double),ct.c_int,ct.POINTER(ct.c_int)]
        evaluate.restype = ct.c_double
        result,value=construct(seed,rec,evaluate)
    np.savetxt(args.output,result,delimiter=",",fmt="%.17g")
    print("Maximum pair cosine",value)
if __name__=="__main__":
    main()
