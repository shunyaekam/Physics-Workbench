"""Exact noncommuting control for the two-eigenvalue refined BMV corollary."""
from itertools import product
from math import comb
from fractions import Fraction

from bmv_review import add, eye, mul, power, trace, zeros


def expansion(a, b, total, copies):
    coeff = [eye(len(a))] + [zeros(len(a)) for _ in range(copies)]
    for _ in range(total):
        coeff = [mul(coeff[0], a)] + [add(mul(coeff[k], a), mul(coeff[k - 1], b))
                                     for k in range(1, copies + 1)]
    return trace(coeff[copies])


def complete_mean(profile, n):
    coeff = [1] + [0] * n
    for value in profile:
        for k in range(1, n + 1):
            coeff[k] += value * coeff[k - 1]
    return Fraction(coeff[-1], comb(n + len(profile) - 1, len(profile) - 1))


def run():
    a = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 2, 0], [0, 0, 0, 2]]
    b = [[100, 190, 2, 0], [190, 400, 0, 1], [2, 0, 100, -190], [0, 1, -190, 400]]
    # Positive definiteness by exact positive LDL pivots.
    reduced = [[Fraction(x) for x in row] for row in b]
    for p in range(4):
        if reduced[p][p] <= 0:
            raise ArithmeticError('B failed positivity')
        for i in range(p + 1, 4):
            for j in range(p + 1, 4):
                reduced[i][j] -= reduced[i][p] * reduced[p][j] / reduced[p][p]
    n, m = 12, 6
    projected = [[[v if i//2 == label else 0 for v in row] for i, row in enumerate(b)]
                 for label in range(2)]
    hist = [0] * (m + 1)
    example = None
    for order in product(range(2), repeat=m):
        word = eye(4)
        for i in order:
            word = mul(word, projected[i])
        weight = trace(word)
        hist[sum(order)] += weight
        if order == (0, 0, 1, 1, 0, 1):
            example = weight
    if example != -41000 or min(hist) < 0 or sum(hist) != trace(power(b, m)):
        raise ArithmeticError('Negative word or histogram failed')
    values = [complete_mean([1]*(m-j)+[2]*j, n) for j in range(m + 1)]
    word_mean = Fraction(expansion(a, b, n + m, m), comb(n + m, m))
    grouped_mean = sum(c * w for c, w in zip(hist, values))
    balanced = trace(power(mul(power(a, n//m), b), m))
    end = trace(mul(power(a, n), power(b, m)))
    grouped_balanced = sum(weight * 2**(n*j//m) for j, weight in enumerate(hist))
    grouped_end = sum(weight * Fraction(m-j+j*2**n, m) for j, weight in enumerate(hist))
    if (word_mean != grouped_mean or grouped_balanced != balanced or grouped_end != end
            or not balanced < word_mean < end):
        raise ArithmeticError('Direct and grouped sandwich disagree')
    print('Signed individual word:', example)
    print('Sum at three visits:', hist[3])
    print('Word mean minus balanced word:', word_mean - balanced)
    print('Clustered word minus word mean:', end - word_mean)


if __name__ == '__main__':
    run()
