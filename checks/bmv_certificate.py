"""Rigorous comparison of the two sides of the registered lower trace bound."""
from fractions import Fraction as F
from itertools import combinations
from math import ceil, comb, factorial

from checks.bmv_search import identity, multiply, trace, word_sum


def norm(a):
    return max(sum(map(abs, row)) for row in a)


def exponential(a, degree):
    """Taylor polynomial and induced infinity-norm error, all rational."""
    d = len(a)
    total = identity(d)
    term = identity(d)
    for order in range(1, degree + 1):
        term = [[F(x, order) for x in row] for row in multiply(term, a)]
        total = [[x+y for x,y in zip(xs,ys)] for xs,ys in zip(total,term)]
    t = norm(a)
    error = t**(degree+1) / F(factorial(degree+1)) / (1 - F(t, degree+2))
    return total, error


def enclosure(h, k, n, m, direct=False):
    d = len(h)
    joint = [[n*x + m*y for x,y in zip(xs,ys)] for xs,ys in zip(h,k)]
    degree = 28 + 2*ceil(max(norm(h), norm(k), norm(joint))) + 8*direct
    a, ea = exponential(h,degree)
    b, eb = exponential(k,degree)
    rhs, er = exponential(joint,degree)
    if direct:
        words = 0
        for positions in combinations(range(n+m),n):
            product = identity(d)
            for i in range(n+m):
                product = multiply(product, a if i in positions else b)
            words += trace(product)
    else:
        words = word_sum(a,b,n,m)
    center = F(words,comb(n+m,n)) - trace(rhs)
    u,v = norm(a)+ea, norm(b)+eb
    # Telescope the factors of each word. |Tr E| <= d ||E||_infty.
    radius = d*(er + n*ea*u**(n-1)*v**m + m*eb*u**n*v**(m-1))
    return center-radius, center+radius


def check(witness):
    if not isinstance(witness,dict) or set(witness)!={"H","K","den","n","m"}:
        raise ValueError("Expected H, K, den, n, m")
    den,n,m = (witness[x] for x in ("den","n","m"))
    if any(type(i) is not int for i in (den,n,m)) or not (1<=den<=16 and n>=1 and m>=1 and n+m<=12):
        raise ValueError("Invalid denominator or word counts")
    matrices = []
    for key in ("H","K"):
        a = witness[key]
        if not isinstance(a,list) or not 2<=len(a)<=4 or any(
                not isinstance(row,list) or len(row)!=len(a) or any(type(v) is not int or abs(v)>16 for v in row) for row in a):
            raise ValueError("Expected a small square integer numerator matrix")
        if any(a[i][j]!=a[j][i] for i in range(len(a)) for j in range(i)):
            raise ValueError("Hermitian hypothesis failed")
        matrix = [[F(v,den) for v in row] for row in a]
        if norm(matrix)>2:
            raise ValueError("Matrix outside supported norm bound")
        matrices.append(matrix)
    h,k=matrices
    if len(h)!=len(k):
        raise ValueError("Different dimensions")
    lo,hi=enclosure(h,k,n,m)
    decisive = hi<0
    if decisive:
        lo2,hi2=enclosure(h,k,n,m,direct=True)
        if hi2>=0 or max(lo,lo2)>min(hi,hi2):
            raise ArithmeticError("Independent word enumeration disagrees")
    return dict(decisive=decisive, gap_lower=str(lo), gap_upper=str(hi),
                sign="strictly_negative" if decisive else "positive" if lo>0 else "unresolved")
