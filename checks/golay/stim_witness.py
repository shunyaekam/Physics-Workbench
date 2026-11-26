"""Export a saved signed forward Stim circuit to the main verifier's primitive gates."""
import json
import sys
import stim


def export(text):
    gates=[]
    for instruction in stim.Circuit(text).decomposed().flattened():
        op=instruction.name
        targets=instruction.targets_copy()
        if op=="TICK":
            continue
        if op not in ("H","S","CX","X","Y","Z","S_DAG") or not all(t.is_qubit_target for t in targets):
            raise ValueError("Unexpected operation in signed forward circuit: "+op)
        step=2 if op=="CX" else 1
        if len(targets)%step:
            raise ValueError("Incomplete primitive gate")
        for i in range(0,len(targets),step):
            gates.append(["SDG" if op=="S_DAG" else op]+[t.value for t in targets[i:i+step]])
    return {"gates":gates}


if __name__=="__main__":
    print(json.dumps(export(json.load(sys.stdin)["forward_stim"])))
