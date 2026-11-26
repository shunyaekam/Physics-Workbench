"""Independent integer decoding and exact complex-matrix tests of the (12,3) case."""
from itertools import product
from math import comb
from random import Random


def kernel(a, b, c, absolute=False):
    # Extract z^12 in 1/[(1-az)(1-bz)(1-cz)] by three univariate recursions.
    h = [1] + [0] * 12
    for eigenvalue in (a, b, c):
        for j in range(1, 13):
            h[j] += eigenvalue * h[j - 1]
    balanced = comb(14, 2) * (a * b * c)**4
    return h[12] + balanced if absolute else h[12] - balanced


def polynomial(x, t, absolute=False):
    a, b, c = x, x + 1, x + 1 + t
    def f(u, v, w):
        return kernel(u, v, w, absolute)
    one = f(b, b, a) * f(c, c, a)
    two = f(a, a, b) * f(c, c, b)
    u, v, w = f(a, a, c), f(b, b, c), f(a, b, c)
    product_uv = u * v
    denominator = w * (u + v) + 2 * product_uv
    remainder = w*w + product_uv if absolute else w*w - product_uv
    left = (one + two) * denominator**2
    right = (remainder * (u + v))**2
    return left + right if absolute else left - right


def signed_digits(number, base):
    while number:
        remainder = number % base
        if remainder > base // 2:
            remainder -= base
        yield remainder
        number = (number - remainder) // base


def decode_certificate():
    degree = 72
    # Each variable polynomial x, x+1, x+1+t has nonnegative coefficients.
    # Every intermediate polynomial's coefficient l1 norm is bounded by the
    # same expression with all subtractions replaced by addition at x=t=1.
    max_coefficient = polynomial(1, 1, absolute=True)
    base = 1 << (2 * max_coefficient).bit_length()
    if list(signed_digits(base**2 - 3 * base + 2, base)) != [2, -3, 1]:
        raise ArithmeticError('Signed-digit negative control failed')
    encoded = polynomial(base, base**(degree + 1))
    digits = list(signed_digits(encoded, base))
    nonzero = {}
    for index, coef in enumerate(digits):
        t_deg, x_deg = divmod(index, degree + 1)
        if coef:
            if x_deg + t_deg > degree:
                raise ArithmeticError('Decoded degree exceeds the analytical bound')
            nonzero[x_deg, t_deg] = coef
    if len(nonzero) != 2324 or min(nonzero.values()) != 2912:
        raise ArithmeticError('Decoded coefficient certificate differs')
    # Check at points away from the nonnegative cone as a transcription control.
    for x, t in ((-3, 2), (4, -5), (0, 0), (2, 7)):
        if sum(v * x**i * t**j for (i, j), v in nonzero.items()) != polynomial(x, t):
            raise ArithmeticError('Direct scalar evaluation disagrees with decoded polynomial')
    return len(nonzero), min(nonzero.values()), base.bit_length()-1


def zeros(n):
    return [[0]*n for _ in range(n)]


def eye(n):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def add(a, b):
    return [[x+y for x, y in zip(row, col)] for row, col in zip(a, b)]


def mul(a, b):
    return [[sum(x*y for x, y in zip(row, col)) for col in zip(*b)] for row in a]


def power(a, k):
    b = eye(len(a))
    for _ in range(k):
        b = mul(b, a)
    return b


def trace(a):
    # Realification doubles the trace of a product whose complex trace is real.
    return sum(a[i][i] for i in range(len(a)))


def realify(real, imag):
    return [r+[-x for x in s] for r, s in zip(real, imag)] + [s+r for r, s in zip(real, imag)]


def diagonal(values):
    return [[v if i == j else 0 for j in range(3)] for i, v in enumerate(values)]


def gram(rng, rank):
    real = [[rng.randint(-2, 2) for _ in range(rank)] for _ in range(3)]
    imag = [[rng.randint(-2, 2) for _ in range(rank)] for _ in range(3)]
    data = realify(real, imag)
    return mul(data, list(zip(*data)))


def difference(a, b):
    # Noncommutative expansion on the right: the k-th matrix coefficient
    # accumulates words ending in A and words ending in B separately.
    c = [eye(6)] + [zeros(6) for _ in range(3)]
    for _ in range(15):
        c = [mul(c[0], a)] + [add(mul(c[k], a), mul(c[k - 1], b)) for k in range(1, 4)]
    balanced = power(mul(power(a, 4), b), 3)
    doubled = trace(c[3]) - comb(15, 3) * trace(balanced)
    if doubled % 2:
        raise ArithmeticError('Realification produced a nonintegral trace')
    return doubled // 2


def path_difference(eigs, b):
    # Compute all ordered triangle paths, including both complex orientations.
    # Here the scalar denominator is 91, while the word denominator is 455.
    total = 0
    for i, j, k in product(range(3), repeat=3):
        re, im = 1, 0
        for u, v in ((i, j), (j, k), (k, i)):
            r, s = b[u][v], b[3 + u][v]
            re, im = re*r-im*s, re*s+im*r
        total += re * kernel(eigs[i], eigs[j], eigs[k])
    return 5 * total


def matrix_tests():
    rng = Random(150312)
    samples = []
    negative_triangles = 0
    # Include singular, repeated, diagonal and non-diagonal spectra, plus
    # non-real B and negative triangle terms in the diagonal-A path formula.
    spectra = [(0, 0, 0), (1, 1, 1), (0, 0, 4), (0, 2, 2), (0, 2, 5),
               (1, 4, 9), (8, 1, 3)]
    b_real = [[2, -1, -1], [-1, 2, -1], [-1, -1, 2]]
    b_bad_triangle = realify(b_real, zeros(3))  # graph Laplacian, eigenvalues 0,3,3
    # Strictly diagonally dominant Hermitian B, with triangle product -1+i.
    b_complex_triangle = realify([[4, 1, 1], [1, 4, -1], [1, -1, 4]],
                                 [[0, 0, 0], [0, 0, 1], [0, -1, 0]])
    commuting = realify(diagonal((2, 5, 9)), zeros(3))
    for eigs in spectra:
        a = realify(diagonal(eigs), zeros(3))
        matrices = [b_bad_triangle, b_complex_triangle, commuting]
        matrices += [gram(rng, r) for r in (1, 2, 3)]
        for b in matrices:
            gap = difference(a, b)
            if gap != path_difference(eigs, b):
                raise ArithmeticError('Ordered triangle formula disagrees with the raw word sum')
            if (b == commuting or len(set(eigs)) == 1) and gap != 0:
                raise ArithmeticError('Commuting controls require exact equality')
            samples.append(gap)
            if b == b_bad_triangle or b == b_complex_triangle:
                negative_triangles += 1
    for _ in range(12):
        samples.append(difference(gram(rng, 3), gram(rng, 3)))
    if min(samples) != 0 or not any(g > 0 for g in samples):
        raise ArithmeticError('PSD boundary/strictness tests failed')
    # Dropping positivity of B must be detected by the exact matrix evaluator:
    # replacing B by -B negates both sides (three B occurrences).
    a = realify(diagonal((1, 2, 5)), zeros(3))
    b = b_bad_triangle
    strict = difference(a, b)
    if strict <= 0 or difference(a, [[-x for x in row] for row in b]) != -strict:
        raise ArithmeticError('Non-PSD negative control failed')
    grouped = trace(mul(power(a, 12), power(b, 3))) // 2
    balanced = trace(power(mul(power(a, 4), b), 3)) // 2
    if strict + comb(15, 3) * (balanced - grouped) >= 0:
        raise ArithmeticError('Changing to the grouped comparator should fail this ordering control')
    return len(samples), sum(g == 0 for g in samples), negative_triangles


if __name__ == '__main__':
    n, minimum, bits = decode_certificate()
    print(f'Signed Kronecker decoding: {n} nonzero coefficients, minimum {minimum}, base 2^{bits}.')
    n, equality, negative = matrix_tests()
    print(f'Exact PSD tests: {n} matrix pairs, {equality} equalities, {negative} negative-triangle controls.')
