"""Certify a finite Pauli generating set using no third-party packages."""
import itertools
import json
from pathlib import Path

ALPHABET = "IXZY"  # Phase-free multiplication is xor in this ordering.
ROOT = Path(__file__).resolve().parent

def require(condition, message):
    if not condition:
        raise ValueError(message)

def anticommute(left, right):
    return sum(x and y and x != y for x, y in zip(left, right)) % 2

def inspect(generators, distance):
    n = len(generators[0])
    valid = all(len(r) == n and set(r) <= set(ALPHABET) for r in generators)
    require(valid, "Malformed Pauli word")
    rows = [tuple(ALPHABET.index(p) for p in r) for r in generators]
    for a, b in itertools.combinations(rows, 2):
        require(not anticommute(a, b), "Noncommuting generators")
    span = {(0,) * n}
    for r in rows:
        require(r not in span, "Dependent generator")
        span.update([tuple(x ^ y for x, y in zip(r, s)) for s in span])

    counts, examples = [], []
    for weight in range(1, distance + 1):
        count, first = 0, None
        for support in itertools.combinations(range(n), weight):
            for letters in itertools.product(range(1, 4), repeat=weight):
                error = [0] * n
                for qubit, letter in zip(support, letters):
                    error[qubit] = letter
                if tuple(error) in span or any(anticommute(error, r) for r in rows):
                    continue
                count += 1
                if first is None:
                    first = "".join(ALPHABET[i] for i in error)
        counts.append(count)
        examples.append(first)
    require(not any(counts[:-1]) and counts[-1] > 0, "Wrong claimed distance")
    return dict(n=n, k=n-len(rows), distance=distance,
                W=max(n-r.count("I") for r in generators), logical_counts=counts,
                logical_example=examples[-1], generators=generators)

if __name__ == "__main__":
    for expected in json.loads((ROOT / "witnesses.json").read_text()):
        result = inspect(expected["generators"], expected["distance"])
        require(result == expected, "Metadata disagrees with enumeration")
        print("[[{n},{k},{distance}]]  W={W}  logical counts {logical_counts}".format(**result))
