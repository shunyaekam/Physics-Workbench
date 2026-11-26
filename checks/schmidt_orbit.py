"""Exact witness test for simultaneous Schmidt-label permutations (Sierant, Conjecture 1)."""
import argparse
from collections import defaultdict
from functools import lru_cache
from fractions import Fraction
import json
from pathlib import Path
from random import Random


def fourth_sum(amplitudes):
    """Unnormalized sum of fourth powers over all Hermitian Paulis on both registers."""
    size = len(amplitudes)
    total = 0
    for shift in range(size):
        products = [value * amplitudes[x ^ shift] for x, value in enumerate(amplitudes)]
        step = 1
        while step < size:
            for start in range(0, size, 2 * step):
                for i in range(start, start + step):
                    a, b = products[i], products[i + step]
                    products[i], products[i + step] = a + b, a - b
            step *= 2
        total += sum(value ** 4 for value in products)
    return size * total


@lru_cache(maxsize=3)
def local_paulis(size):
    """Actions of the Hermitian tensor products of I, X, Y, Z on the basis."""
    cache = [([], [])]
    for _ in range(size.bit_length() - 1):
        cache = [(flips + [flip], phases + [phase]) for flips, phases in cache
                 for flip, phase in ((0, (0, 0)), (1, (0, 0)), (1, (1, 3)), (0, (0, 2)))]
    actions = []
    for flips, phases in cache:
        shift = sum(flip << i for i, flip in enumerate(flips))
        turns = [sum(phase[(x >> i) & 1] for i, phase in enumerate(phases)) % 4
                 for x in range(size)]
        actions.append((shift, turns))
    return actions


def direct_fourth_sum(state, size):
    """Enumerate full Pauli strings and compute the expectation on the sparse tensor state."""
    overlaps = defaultdict(list)
    for x, ax in state.items():
        for y, ay in state.items():
            overlaps[x ^ y].append((x // size, x % size, ax * ay))
    total = 0
    for left_shift, left_phase in local_paulis(size):
        for right_shift, right_phase in local_paulis(size):
            shift = left_shift * size + right_shift
            if shift not in overlaps:
                continue
            bins = [0] * 4
            for x, y, product in overlaps[shift]:
                bins[(left_phase[x] + right_phase[y]) % 4] += product
            if bins[1] != bins[3]:
                raise ArithmeticError("Hermitian Pauli expectation has an imaginary part")
            total += (bins[0] - bins[2]) ** 4
    return total


def diagonal(values):
    return {x*(len(values)+1): v for x,v in enumerate(values) if v}


def validate_rotation(values, size):
    if type(values) is not list or len(values) != 5 or any(type(x) is not int for x in values):
        raise ValueError("Supply a rotation [i,j,c,s,h] of integers")
    i, j, c, s, h = values
    if not (0 <= i < j < size and 1 <= h <= 255 and c*c+s*s == h*h):
        raise ValueError("Invalid plane or Pythagorean rotation")


def images(x, rotation):
    i, j, c, s, h = rotation
    if x == i:
        return ((i,c), (j,s))
    if x == j:
        return ((i,-s), (j,c))
    return ((x,h),)


def rotated_state(a, left, right):
    size = len(a)
    result = defaultdict(int)
    for x, value in enumerate(a):
        for i, u in images(x, left):
            for j, v in images(x, right):
                result[i*size+j] += value*u*v
    return {index:value for index,value in result.items() if value}


def rotation_matrix(plane, size):
    i, j, c, s, h = plane
    matrix = [[h if row == col else 0 for col in range(size)] for row in range(size)]
    matrix[i][i], matrix[j][j] = c,c
    matrix[i][j], matrix[j][i] = -s,s
    return matrix


def cube_sum(state):
    """Sum the products over all affine 3-cubes of a real amplitude function."""
    products = defaultdict(dict)
    for x, a in state.items():
        for y, b in state.items():
            products[x ^ y][x] = a*b
    total = 0
    for values in products.values():
        faces = defaultdict(int)
        for x, a in values.items():
            for y, b in values.items():
                faces[x ^ y] += a*b
        total += sum(count**2 for count in faces.values())
    return total


def check(witness):
    permutation = {"sorted", "permuted"}
    rotation = {"sorted", "left", "right"}
    if type(witness) is not dict or set(witness) not in (permutation, rotation):
        raise ValueError("Supply sorted amplitudes and either permuted amplitudes or two rotations")
    a = witness["sorted"]
    if type(a) is not list or len(a) not in (4, 8, 16):
        raise ValueError("Use 4, 8 or 16 amplitudes")
    if any(type(x) is not int or not 0 <= x <= 255 for x in a) or a != sorted(a, reverse=True) or a[0] == 0:
        raise ValueError("Require nonzero sorted integer amplitudes in the range 0 through 255")
    size = len(a)
    reference_state = diagonal(a)
    q0 = fourth_sum(a)
    if q0 != direct_fourth_sum(reference_state, size):
        raise ArithmeticError("Independent reference-state enumeration failed")
    scale = 1
    if set(witness) == permutation:
        b = witness["permuted"]
        if (type(b) is not list or len(b) != size or any(type(v) is not int for v in b)
                or a != sorted(b, reverse=True)):
            raise ValueError("Require a permutation of the same amplitudes")
        state = diagonal(b)
        q1 = fourth_sum(b)
    else:
        left, right = witness["left"], witness["right"]
        for plane in (left, right):
            validate_rotation(plane, size)
        scale = left[4] * right[4]
        state = rotated_state(a, left, right)
        left_matrix, right_matrix = (rotation_matrix(p, size) for p in (left, right))
        for i in range(size):
            for j in range(size):
                entry = sum(u*v*t for u, v, t in zip(left_matrix[i], right_matrix[j], a))
                if state.get(i*size+j, 0) != entry:
                    raise ArithmeticError("Sparse state differs from the rotated Schmidt matrix")
        q1 = size**2 * cube_sum(state)
    norm = sum(x*x for x in a) * scale**2
    if sum(v*v for v in state.values()) != norm or q1 != direct_fourth_sum(state, size):
        raise ArithmeticError("Independent norm or tensor-Pauli check failed")
    q0 *= scale**8
    denominator = size**2 * norm**4
    outcome = dict(sorted_fourth_sum=q0, alternative_fourth_sum=q1, denominator=denominator,
                   sorted_purity=str(Fraction(q0, denominator)), alternative_purity=str(Fraction(q1, denominator)),
                   decisive=q1 > q0)
    if set(witness) == permutation:
        outcome.update(permuted_fourth_sum=q1, permuted_purity=outcome["alternative_purity"])
    return outcome


def search(seed=1, trials=512):
    """Take a reproducible sample from the four-qubit-per-party proposal and replay its best pair."""
    if type(seed) is not int or type(trials) is not int or not 1 <= trials <= 100000:
        raise ValueError("Use an integer seed and a trial budget from 1 to 100000")
    rng = Random(seed)
    best = None
    equal = 0
    tested = 0
    for _ in range(trials):
        a = sorted((rng.randrange(5) for _ in range(16)), reverse=True)
        if a[0] == 0:
            continue
        b = a.copy()
        rng.shuffle(b)
        difference = Fraction(fourth_sum(b) - fourth_sum(a), 256 * sum(x*x for x in a)**4)
        tested += 1
        equal += difference == 0
        if best is None or difference > best:
            best = difference
            witness = {"sorted": a, "permuted": b}
        if difference > 0:
            break
    if best is None:
        raise ArithmeticError("Sample contained no normalized state")
    return dict(seed=seed, budget=trials, tested=tested, equal=equal, witness=witness,
                result=check(witness), domain="four qubits per party, integer amplitudes 0..4, same label permutation",
                coverage="seeded sample", full_finite_search_size=5**16-1)


def search_rotations(seed=1, trials=64):
    """Test independently chosen rational local Givens rotations on the two parties."""
    if type(seed) is not int or type(trials) is not int or not 1 <= trials <= 10000:
        raise ValueError("Use an integer seed and a rotation budget from 1 to 10000")
    rng = Random(seed)
    angles = ((3,4,5), (5,12,13), (7,24,25), (8,15,17))
    best = None
    equal = 0
    for index in range(trials):
        # Keep a nondegenerate part of the spectrum on each plane, avoiding trivial ties.
        a = sorted((rng.randrange(1,33) for _ in range(15)), reverse=True) + [0]
        planes = []
        for _ in range(2):
            i,j = sorted(rng.sample(range(16), 2))
            while a[i] == a[j]:
                i,j = sorted(rng.sample(range(16), 2))
            c,s,h = rng.choice(angles)
            if rng.getrandbits(1):
                c,s = s,c
            if rng.getrandbits(1):
                s = -s
            planes.append([i,j,c,s,h])
        left, right = planes
        scale = left[4]*right[4]
        norm = sum(x*x for x in a)
        rotated = rotated_state(a, left, right)
        diff = Fraction(cube_sum(rotated), (norm*scale**2)**4) - Fraction(fourth_sum(a), 256*norm**4)
        equal += diff == 0
        if best is None or diff > best:
            witness = dict(sorted=a, left=left, right=right)
            best = diff
        if diff > 0:
            break
    return dict(seed=seed, budget=trials, tested=index+1, equal=equal, witness=witness,
                result=check(witness), domain="four qubits per party, two independent rational plane rotations",
                coverage="seeded sample")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--witness", type=Path, help="Replay a JSON object containing sorted and permuted arrays")
    parser.add_argument("--rotations", action="store_true", help="Search real local basis rotations")
    parser.add_argument("--seed", type=int, default=1)
    parser.add_argument("--trials", type=int, default=512)
    args = parser.parse_args()
    result = check(json.loads(args.witness.read_text())) if args.witness else (
        search_rotations(args.seed, args.trials) if args.rotations else search(args.seed, args.trials))
    print(json.dumps(result, indent=2))
