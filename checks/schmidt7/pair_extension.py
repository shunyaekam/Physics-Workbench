"""Cross-check the all-dimension stabilizer-direction lemma on complex frames."""
from itertools import combinations, permutations
import numpy as np
from scipy.linalg import hadamard


def planes(d):
    """All affine planes grouped by direction, with lexicographic orientation."""
    groups = []
    for i, j in combinations(range(1, d), 2):
        k = i ^ j
        if k <= j:
            continue
        direction = (0, i, j, k)
        groups.append([sorted(t ^ h for h in direction) for t in range(d)
                       if t == min(t ^ h for h in direction)])
    return np.array(groups)


def determinants(blocks):
    # These 3x3/4x4 blocks include exactly singular matrices.
    n = blocks.shape[-1]
    result = np.zeros(blocks.shape[:-2], dtype=complex)
    for order in permutations(range(n)):
        sign = (-1) ** sum(i > j for i, j in combinations(order, 2))
        result += sign * blocks[..., range(n), order].prod(axis=-1)
    return result


def projector_score(frame, groups):
    score = 0.
    for a, b in combinations(range(2, frame.shape[1]), 2):
        minors = determinants(frame[:, [0, 1, a, b]][groups])
        score += np.linalg.norm(minors.sum(axis=1)) ** 2
    return float(score)


def triple_occupation(frame, triples):
    proj = frame @ frame.conj().T
    blocks = proj[triples[:, :, None], triples[:, None, :]]
    return float(determinants(blocks).real.sum())


def random_isometry(d, k, rng):
    a = rng.normal(size=(d, k)) + 1j * rng.normal(size=(d, k))
    return np.linalg.qr(a)[0]


def check():
    rng = np.random.default_rng(701105)
    count = 0
    worst_error = 0.
    for d in (8, 16, 32):
        groups = planes(d)
        triples = groups[:, 0, 1:]
        for m in (3, 4, 5, 6):
            for trial in range(3):
                frame = np.eye(d, m + 2, dtype=complex)
                if trial:
                    frame[1:, 1:] = random_isometry(d - 1, m + 1, rng)
                delta = (triple_occupation(frame[:, 1:], triples) -
                         triple_occupation(frame[:, 2:], triples))
                raw = projector_score(frame, groups)
                # A tensor product of Hadamards and single-qubit phase gates is Clifford.
                phase = np.array([1j ** bin(i).count("1") for i in range(d)])
                rotated = phase[:, None] * (hadamard(d) @ frame / np.sqrt(d))
                rotated[:, :2] = rotated[:, :2] @ random_isometry(2, 2, rng)
                transformed = projector_score(rotated, groups)
                error = max(abs(delta - raw), abs(delta - transformed))
                if not all(map(np.isfinite, (raw, delta, transformed))) or error > 1e-10 or delta > m // 2 + 1e-10:
                    raise ArithmeticError((d, m, trial, raw, delta, transformed))
                if trial == 0 and abs(raw - m // 2) > 1e-10:
                    raise ArithmeticError("Coordinate extremizer missed equality")
                worst_error = max(worst_error, error)
                count += 1
    print(f"{count} frames compared before and after Clifford/pair rotations; "
          f"largest disagreement {worst_error:.3g}.")


if __name__ == "__main__":
    check()
