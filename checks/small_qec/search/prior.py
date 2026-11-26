"""Compute minimum basis weights of archived groups and reconstruct Steane's code."""
import json
from pathlib import Path
from verify import inspect, require

def weight(v, n):
    return bin(((v >> n) | v) & ((1 << n)-1)).count("1")

def parity(v):
    return bin(v).count("1") % 2

def pauli(v, n):
    return "".join("IXZY"[((v >> (n+i)) & 1) + 2*((v >> i) & 1)] for i in range(n))

def binary(s):
    return sum((int(p in "XY") << (len(s)+i)) | (int(p in "ZY") << i)
               for i, p in enumerate(s))

def span(basis):
    group = [0]
    for g in basis:
        group += [v ^ g for v in group]
    return group

def light_basis(group, n):
    generated, result = {0}, []
    for v in sorted(group, key=lambda x: (weight(x, n), x)):
        if v not in generated:
            result.append(v)
            generated.update([g ^ v for g in generated])
    require(generated == set(group), "Input group is not a vector space")
    return result

def reconstruct_steane():
    # The four support rows and five displacement rows of G, followed by S.
    U = [int(s, 2) for s in ("01010101100", "00110011010", "00001111001", "11111111000")]
    V = [int(s, 2) for s in ("11000000000", "10100000000", "10001000000", "00000000110", "00000000101")]
    signs = [0x3333, 0x0F0F, 0x55AA, 0x0FF0, 0x3333]
    support, offsets, phases = span(U), span(V), span(signs)
    n, group = 11, []
    for j, x in enumerate(support):
        for z in range(1 << n):
            if any(parity(z & u) for u in U):
                continue
            if all(parity(z & v) == (((s >> j) ^ s) & 1) for s, v in zip(signs, V)):
                # Verify action X(x)Z(z) directly on each of the 32 encoded basis
                # vectors, each a signed sum of 16 different computational words.
                for c, sign in zip(offsets, phases):
                    for t, u in enumerate(support):
                        observed = ((sign >> t) & 1) ^ parity(z & (u ^ c))
                        require(observed == ((sign >> (j ^ t)) & 1),
                                "Does not fix an encoded state")
                group.append((x << n) | z)
    require(len(group) == 64, "Expected a rank-six group")
    return [pauli(v, n) for v in light_basis(group, n)]

if __name__ == "__main__":
    root = Path(__file__).resolve().parent
    for record in json.loads((root / "prior_groups.json").read_text()):
        rows, n = record["generators"], record["n"]
        basis = light_basis(span(map(binary, rows)), n)
        checked = inspect([pauli(v, n) for v in basis], record["d"])
        require(checked["k"] == record["k"], "Archived dimension mismatch")
        w = max(weight(v, n) for v in basis)
        require(w == record["minimum_basis_weight"], "Basis weight disagrees with archive")
        print(record["source"], w)
    for parent, logical, target in [
        ((10, 2), "IZXIZZZIZI", 4),
        ((12, 4), "XXIIIIZZIIII", 6),
    ]:
        n, k = parent
        ref = f"https://codetables.de/QECC.php?q=4&n={n}&k={k}"
        archive = json.loads((root / "prior_groups.json").read_text())
        rows = next(r["generators"] for r in archive if r["source"] == ref)
        basis = light_basis(span(map(binary, rows + [logical])), n)
        result = inspect([pauli(g, n) for g in basis], 4)
        require((result["k"], result["W"]) == (k-1, target), "Subcode mismatch")
        print("Distance-four subcode of", ref, "with extra generator", logical, "W =", target)
    steane = inspect(reconstruct_steane(), 3)
    require((steane["W"], steane["logical_counts"]) == (7, [0, 0, 75]), "Steane code mismatch")
    print("Steane 1996", json.dumps(steane))
