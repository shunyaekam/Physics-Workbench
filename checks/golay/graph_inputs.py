"""Generate graph-state frontiers from the independently specified cyclic target."""
import random
import sys
from pathlib import Path
import stim

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
import golay43 as g
from golay_oracle import pauli


def target_sim():
    code=[sum(1<<(k+i) for k in (0,2,4,5,6,10,11)) for i in range(12)]
    sim=stim.TableauSimulator()
    sim.set_state_from_stabilizers([pauli(code[i]^code[i+1],"X") for i in range(11)]
                                   +[pauli(v,"Z") for v in code])
    return sim


def apply_pauli_gate(sim, gate):
    a,b,p,q=gate
    name=p.lower()+"c"+q.lower() if p!="Z" else {"X":"cnot","Y":"cy","Z":"cz"}[q]
    getattr(sim,name)(a,b)


def decompose(prefix):
    sim=target_sim()
    for gate in prefix:
        apply_pauli_gate(sim,gate)
    graph=stim.Tableau.from_stabilizers(sim.canonical_stabilizers()).to_circuit("graph_state")
    edges=[0]*23
    local=stim.Circuit()
    for inst in graph:
        wires=[t.value for t in inst.targets_copy()]
        if inst.name=="CZ":
            for a,b in zip(wires[::2],wires[1::2]):
                edges[a]^=1<<b;edges[b]^=1<<a
        elif inst.name not in ("RX","TICK"):
            if len(stim.gate_data(inst.name).tableau)!=1: raise ValueError("Unexpected graph preparation")
            local.append(inst)
    return edges,local


def frontiers(batch, seed=None):
    rng=random.Random(12043+batch)
    if seed is None: seed=g.seed_schedule()
    result=[seed[:k] for k in range(0,42)]
    if batch:
        result=[]
        for i in range(128):
            k=rng.randrange(9,43)
            drop=set(rng.sample(range(k),1+i%3))
            result.append([gate for j,gate in enumerate(seed[:k]) if j not in drop])
    return result


if __name__=="__main__":
    for prefix in frontiers(int(sys.argv[1])):
        print(len(prefix),*decompose(prefix)[0])
