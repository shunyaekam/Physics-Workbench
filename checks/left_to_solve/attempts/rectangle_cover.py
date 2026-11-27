"""MO 338936. Exact uniform-vector search on a restricted family of rectangle covers."""
from math import comb
from sympy import Matrix

def choose(n,k):
    return comb(n,k) if 0 <= k <= n else 0

def objective(r):
    # The r-subsets of [2r-1] intersect. Each symbol defines a square block of
    # subsets containing it. Inside a block delete that symbol to get J(2p,p).
    p = r-1
    # E_k[I,J] = binom(|I intersect J|, k). In the j-th eigenspace of the
    # Johnson scheme, this inclusion-matrix Gram operator has eigenvalue below.
    restricted = Matrix([[choose(p-j,k-j)*choose(2*p-k-j,p-k) for k in range(p+1)]
                         for j in range(p+1)])
    uniform = Matrix([[sum(choose(r,l)*choose(r-1,r-l)*choose(l-1,k)
                           for l in range(1,r+1)) for k in range(p+1)]])
    # In block-eigenvalue coordinates the constraint is a cube of radius one.
    # The maximum of a linear functional on it is the sum of absolute coefficients.
    return sum(abs(entry) for entry in uniform*restricted.inv())

if __name__ == '__main__':
    for r in range(2,19):
        best = objective(r)
        assert best == r
        print(r, best, 'vs required strict excess over', 2*r-1)
