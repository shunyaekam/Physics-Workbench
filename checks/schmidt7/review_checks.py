"""Independent controls for the rank-seven review. Uses integer arithmetic."""
from fractions import Fraction
from itertools import combinations
from random import Random


def five_cycle():
    support = range(7)
    edges = [(2, 3), (3, 4), (4, 5), (5, 6), (6, 2)]
    # Store just the nonzero weights, in units of one half.
    faces = [set([0, 1, a, b]) for a, b in edges]
    for triple in combinations(support, 3):
        assert sum(set(triple) <= f for f in faces) <= 2
    for size, bound in [(5, 2), (6, 6)]:
        for group in combinations(support, size):
            occupied = [f for f in faces if f <= set(group)]
            assert len(occupied) <= bound
            if size == 6:
                for vertex in group:
                    assert sum(vertex in f for f in occupied) <= 4
    planes = [g for g in combinations(support, 4) if g[0] ^ g[1] ^ g[2] ^ g[3] == 0]
    pair_mass = Fraction(len(faces), 2)
    coordinate_mass = sum({0, 1} <= set(f) for f in planes)
    assert 2 * pair_mass == 5 and 2 * coordinate_mass == 4
    print("Five-cycle relaxed coefficient = 5, coordinate coefficient = 4")


def transform(values):
    step = 1
    while step < len(values):
        for start in range(0, len(values), 2 * step):
            for i in range(start, start + step):
                a, b = values[i], values[i + step]
                values[i], values[i + step] = a + b, a - b
        step *= 2


def purity(real, imag):
    size = len(real)
    norm = sum(a*a + b*b for a, b in zip(real, imag))
    total = 0
    for x in range(size):
        # Fourier transform of the pointwise products gives every Pauli
        # expectation at fixed X mask, up to a scalar of unit modulus.
        r = [real[j ^ x]*real[j] + imag[j ^ x]*imag[j] for j in range(size)]
        m = [real[j ^ x]*imag[j] - imag[j ^ x]*real[j] for j in range(size)]
        transform(r)
        transform(m)
        total += sum((a*a + b*b)**2 for a, b in zip(r, m))
    return Fraction(total, size * norm**4)


def rotate(real, imag, shift, labels):
    # One local two-level unitary proportional to [[3,4i],[4i,3]].
    a, b = labels
    out_r, out_i = [5*x for x in real], [5*x for x in imag]
    for j in range(64):
        if (j >> shift) & 7 == a:
            k = j ^ ((a ^ b) << shift)
            out_r[j], out_i[j] = 3*real[j]-4*imag[k], 3*imag[j]+4*real[k]
            out_r[k], out_i[k] = 3*real[k]-4*imag[j], 3*imag[k]+4*real[j]
    return out_r, out_i


def complex_frames():
    random = Random(725)
    start = [7-i if i == j else 0 for i in range(8) for j in range(8)]
    reference = purity(start, [0]*64)
    assert reference == Fraction(134539, 214375)
    for trial in range(24):
        real, imag = start, [0]*64
        for shift in (3, 0, 3, 0):
            labels = random.sample(range(8), 2)
            real, imag = rotate(real, imag, shift, labels)
        assert purity(real, imag) < reference, trial
    print("24 complex local-rotation trials lie strictly below", reference)


if __name__ == "__main__":
    five_cycle()
    complex_frames()
