"""Independent signed-state check using Stim 1.16.0."""
import json
import random

import stim

import golay43 as search


def pauli(mask, axis):
    return stim.PauliString("".join(axis if mask >> j & 1 else "_" for j in range(23)))


def check():
    code = [sum(1 << (k+i) for k in (0,2,4,5,6,10,11)) for i in range(12)]
    stabilizers = [pauli(code[i]^code[i+1], "X") for i in range(11)]
    stabilizers.extend(pauli(row, "Z") for row in code)
    target = stim.TableauSimulator()
    target.set_state_from_stabilizers(stabilizers)

    forward = stim.TableauSimulator()
    for gate,*indices in json.loads(search.SEED.read_bytes())["gates"]:
        op = {"SDG":"s_dag", "CX":"cnot"}.get(gate,gate.lower())
        getattr(forward,op)(*indices)
    if forward.canonical_stabilizers() != target.canonical_stabilizers():
        raise ArithmeticError("Signed target mismatch")

    rng = random.Random(14)
    seed = search.seed_schedule()
    for k in range(80):
        ops = seed.copy()
        if k:
            del ops[rng.randrange(44)]
        if k > 1:
            ops[rng.randrange(43)] = (*rng.sample(range(23),2), *rng.choice(search.AXES))
        sim = target.copy()
        for a,b,p,q in ops:
            gate = p.lower()+"c"+q.lower() if p != "Z" else {"X":"cnot","Y":"cy","Z":"cz"}[q]
            getattr(sim,gate)(a,b)
        if sum(sim.peek_bloch(i).weight == 0 for i in range(23)) != search.mixed(ops):
            raise ArithmeticError("Independent simulators disagree")


if __name__ == "__main__":
    check()
    print("Signed reference state verified. Both simulators agree on 80 schedules.")
