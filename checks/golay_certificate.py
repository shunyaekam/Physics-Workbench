"""Certify a forward circuit for the 23-qubit cyclic Golay logical zero.

Convention: input |0> on every wire, count each CX once, and allow single-qubit
Cliffords for free. Two signed Pauli calculations compare to the literal CSS
codeword (up to a physically irrelevant global phase).
"""
import argparse
import json
from hashlib import sha256
from pathlib import Path

from checks.golay43 import N, SEED, target
from verify import require


def example():
    """The deposited 44-CNOT positive control, one gate above the target budget."""
    raw = SEED.read_bytes()
    require(sha256(raw).hexdigest() == "99706fa2a1172f94de17a3eef6dbd8f0f72e8a5c53a6026b77fadb296f4b42eb",
            "Deposited cyclic control differs from the registered data")
    return {"gates": json.loads(raw)["gates"]}


def target_rows():
    # Read the existing target's packed columns as positive Hermitian CSS rows.
    cx, cz = target()
    return [(sum(1 << j for j in range(N) if (cx[j] >> i) & 1),
             sum(1 << j for j in range(N) if (cz[j] >> i) & 1)) for i in range(N)]


def forward_image(x, z, gates):
    """Conjugate a Pauli represented as i^p X^x Z^z, with all X's first."""
    phase = 0
    for op, a, *rest in gates:
        ax, az = (x >> a) & 1, (z >> a) & 1
        if op == "CX":
            b, = rest
            x ^= ax << b
            z ^= ((z >> b) & 1) << a
        elif op == "H":
            phase += 2 * ax * az
            x ^= (ax ^ az) << a
            z ^= (ax ^ az) << a
        elif op in ("S", "SDG"):
            phase += ax if op == "S" else -ax
            z ^= ax << a
        else:
            phase += 2 * ((az if op in ("X", "Y") else 0) ^ (ax if op in ("Z", "Y") else 0))
    return x, z, phase % 4


def multiply(left, right):
    x, z, p = left
    y, w, q = right
    anticross = bin(z & y).count("1") % 2
    return x ^ y, z ^ w, (p + q + 2 * anticross) % 4


def reduce_pauli(row, basis):
    while row[0] or row[1]:
        pivot = ((row[0] << N) | row[1]).bit_length() - 1
        if pivot not in basis:
            break
        row = multiply(row, basis[pivot])
    return row


def forward_checks(gates):
    basis = {}
    for i in range(N):
        row = reduce_pauli(forward_image(0, 1 << i, gates), basis)
        pivot = ((row[0] << N) | row[1]).bit_length() - 1
        require(pivot >= 0, "Dependent circuit stabilizers")
        basis[pivot] = row
    return [reduce_pauli((x, z, 0), basis) == (0, 0, 0) for x, z in target_rows()]


def backward_checks(gates):
    """Pull +CSS checks back to |0>. Track the sign of Hermitian Pauli strings.

    The 23 rows are independent: the polynomial g and (1+D)g are monic
    of degrees 11 and 12. Their shifts have distinct leading monomials.
    """
    g = sum(1 << j for j in (0, 2, 4, 5, 6, 10, 11))
    goals = [((g ^ (g << 1)) << i, 0) for i in range(11)]
    goals += [(0, g << i) for i in range(12)]
    result = []
    for x, z in goals:
        negative = 0
        for op, a, *rest in reversed(gates):
            ax, az = (x >> a) & 1, (z >> a) & 1
            if op == "CX":
                b, = rest
                bx, bz = (x >> b) & 1, (z >> b) & 1
                negative ^= ax & bz & (bx ^ az ^ 1)
                x ^= ax << b
                z ^= bz << a
            elif op == "H":
                negative ^= ax & az
                x ^= (ax ^ az) << a
                z ^= (ax ^ az) << a
            elif op in ("S", "SDG"):
                # The pullback uses S-dagger for S and S for S-dagger.
                negative ^= ax & (az ^ int(op == "S"))
                z ^= ax << a
            elif op == "X":
                negative ^= az
            elif op == "Z":
                negative ^= ax
            elif op == "Y":
                negative ^= ax ^ az
        result.append(x == 0 and negative == 0)
    return result


def check(witness):
    require(isinstance(witness, dict) and set(witness) == {"gates"},
            "Expected a forward gates list as the only field")
    gates = witness["gates"]
    require(isinstance(gates, list), "Expected a list of gates")
    for gate in gates:
        require(isinstance(gate, list) and len(gate) in (2, 3), "Invalid gate")
        op, *wires = gate
        require(isinstance(op, str) and op in ("H", "S", "SDG", "X", "Y", "Z", "CX"),
                "Unsupported gate")
        require(len(wires) == (2 if op == "CX" else 1), "Incorrect gate arity")
        require(all(type(i) is int and 0 <= i < N for i in wires) and len(wires) == len(set(wires)),
                "Invalid wire index or repeated wire")
    checks = forward_checks(gates)
    require(checks == backward_checks(gates), "Signed stabilizer replays disagree")
    cost = sum(gate[0] == "CX" for gate in gates)
    return {"qubits": N, "cnot_count": cost, "positive_target_generators": sum(checks),
            "target_prepared": all(checks), "decisive": all(checks) and cost <= 43}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("witness", type=Path, nargs="?", help="JSON file, default: the 44-CNOT control")
    args = parser.parse_args()
    print(json.dumps(check(json.loads(args.witness.read_text()) if args.witness else example()), indent=2))
