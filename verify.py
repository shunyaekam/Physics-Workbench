"""Witness checking. Only Python's standard library and exact arithmetic are used."""
from fractions import Fraction as Q
from math import comb, isqrt
from itertools import combinations


def require(condition, message):
    if not condition:
        raise ValueError(message)


def integer(x, low, high):
    require(type(x) is int and low <= x <= high, "integer outside its allowed range")
    return x


def add(a, b):
    c = [Q(0)] * max(len(a), len(b))
    for p in (a, b):
        for i, v in enumerate(p):
            c[i] += v
    return c


def scale(a, k):
    return [k * v for v in a]


def legendre_in_s(k):
    # r = 2s, cos(theta) = 1 - 2s². Coefficients in ascending powers of s.
    prev, curr = [Q(1)], [Q(1), Q(0), Q(-2)]
    yield prev
    if k:
        yield curr
    for j in range(1, k):
        prod = add(curr, [0, 0] + scale(curr, -2))
        prev, curr = curr, scale(add(scale(prod, 2*j+1), scale(prev, -j)), Q(1, j+1))
        yield curr


def bernstein_positive(values, depth=0):
    if min(values) >= 0:
        return True
    if min(values[0], values[-1]) < 0 or depth == 16:
        return False
    left, right, row = [], [], values
    while row:
        left.append(row[0])
        right.append(row[-1])
        row = [(a+b)/2 for a, b in zip(row, row[1:])]
    return bernstein_positive(left, depth+1) and bernstein_positive(right[::-1], depth+1)


def lower_bound(n, coeff):
    require(1 <= len(coeff) <= 13, "unsupported polynomial degree")
    c = [Q(integer(x, -10**12, 10**12), 10**9) for x in coeff]
    require(all(x >= 0 for x in c[1:]), "negative Legendre coefficient")
    h = [Q(0)]
    for p, v in zip(legendre_in_s(len(c)-1), c):
        h = add(h, scale(p, v))
    power = [Q(1)] + scale(h, -2)
    m = len(power)-1
    bern = [sum(power[j]*Q(comb(i,j), comb(m,j)) for j in range(i+1)) for i in range(m+1)]
    require(bernstein_positive(bern), "polynomial minorant failed continuum check")
    return (n*n*c[0] - n*sum(c))/2


def thomson(problem, witness):
    n = integer(problem["n"], 2, 200)
    require(len(witness["points"]) == n, "incorrect charge count")
    points = []
    for side, a, b in witness["points"]:
        require(type(side) is int and side in (-1, 1), "invalid chart")
        a, b = (Q(integer(t, -10**12, 10**12), 10**7) for t in (a,b))
        s = a*a + b*b
        points.append((2*a/(1+s), 2*b/(1+s), side*(1-s)/(1+s)))
    units = 10**14
    floor_sum = ceil_sum = 0
    for a, b in combinations(points, 2):
        d2 = sum((x-y)**2 for x, y in zip(a, b))
        require(d2 > 0, "coincident charges")
        num = units**2 * d2.denominator
        k = isqrt(num // d2.numerator)
        floor_sum += k
        ceil_sum += k + int(k*k*d2.numerator != num)
    lower = lower_bound(n, witness["coeff"])
    upper = Q(ceil_sum, units)
    require(lower <= upper, "inconsistent bounds")
    return dict(lower=str(lower), upper=str(upper), configuration_lower=str(Q(floor_sum, units)),
                status="bounds_checked" if lower < upper else "bounds_coincide")


def werner(problem, witness):
    d, k = integer(problem["d"], 2, 10), integer(problem["copies"], 1, 8)
    p, q = problem["alpha"]
    require(0 < p <= q and d*p > q, "requires an NPT Werner state")
    require(1 <= len(witness["terms"]) <= 2, "Schmidt rank exceeds two-term representation")
    amplitude = {}
    for a, b in witness["terms"]:
        for v in (a,b):
            require(1 <= len(v) <= 5, "unsupported sparsity")
            for idx, value in v:
                integer(idx, 0, d**k-1)
                integer(value, -256, 256)
        for i, x in a:
            for j, y in b:
                amplitude[i,j] = amplitude.get((i,j), 0) + x*y
    norm2 = sum(v*v for v in amplitude.values())
    require(norm2 > 0, "zero vector")
    digits = {i: tuple(i//d**r % d for r in range(k)) for pair in amplitude for i in pair}
    entries = [(digits[i], digits[j], v) for (i,j),v in amplitude.items() if v]
    total = 0
    for i,j,v in entries:
        for l,m,w in entries:
            z = v*w
            for a,b,c,e in zip(i,j,l,m):
                z *= q*int(a == c and b == e) - p*int(a == b and c == e)
                if not z:
                    break
            total += z
    return dict(score=str(Q(total, q**k*norm2)), norm2=norm2,
                status="negative_witness" if total < 0 else "nonnegative_sample")


CHECKERS = {"thomson": thomson, "werner": werner}
