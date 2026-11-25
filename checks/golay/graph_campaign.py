"""Run or verify repeatable Golay graph rewrites, preserving a signed circuit per batch."""
import argparse
from hashlib import sha256
import json
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory

import stim

from graph_inputs import frontiers, g, decompose, target_sim
from graph_replay import construct,inverse_axes
from lab import load, write

HERE=Path(__file__).resolve().parent
OUT=g.ROOT/"campaign/golay-graphs"
SCHEMA=1


def verify(receipt):
    if sha256(receipt["forward_stim"].encode()).hexdigest()!=receipt["forward_sha256"]:
        raise ArithmeticError("Stored circuit digest mismatch")
    circuit=stim.Circuit(receipt["forward_stim"])
    if any(op.name!="CX" and len(stim.gate_data(op.name).tableau)!=1 for op in circuit):
        raise ArithmeticError("Gate outside CNOT and free local Cliffords")
    if circuit.num_qubits!=23 or circuit.num_measurements: raise ArithmeticError("Wrong circuit model")
    sim=stim.TableauSimulator();sim.do(circuit)
    count=sum(len(op.targets_copy())//2 for op in circuit if op.name=="CX")
    if count!=receipt["cost"] or sim.canonical_stabilizers()!=target_sim().canonical_stabilizers():
        raise ArithmeticError("Stored forward circuit misses the signed target")
    axes=inverse_axes(circuit)
    if g.mixed(axes)!=0: raise ArithmeticError("Binary stabilizer check failed")
    return axes


def run(exe,batch):
    # The first five runs reproduce the initial screen. Four separate lineages
    # then feed previously verified circuits back into the search.
    parent=batch-4 if batch>=5 else None
    seed=g.seed_schedule()
    if parent is not None:
        previous=load(OUT/f"{parent:06d}.json")
        if previous["cost"]==44:
            seed=verify(previous)
        else:
            parent=None
    prefixes=frontiers(batch,seed)
    rows=[" ".join(map(str,[len(p),*decompose(p)[0]])) for p in prefixes]
    trials=8000 if batch==0 else 100000 if batch<=4 else 20000
    result=json.loads(subprocess.check_output([str(exe),str(17043+batch),str(trials)],
                           input="\n".join(rows)+"\n",text=True))
    forward=construct(prefixes[result["frontier"]],result)
    receipt=dict(schema=SCHEMA,batch=batch,parent=parent,trials=result["trials"],cost=result["cost"],
                 frontier=result["frontier"],moves=result["moves"],forward_stim=str(forward),
                 forward_sha256=sha256(str(forward).encode()).hexdigest())
    verify(receipt)
    return receipt


def advance(exe,batch):
    path=OUT/f"{batch:06d}.json"
    if path.exists(): return
    if any(load(p)["cost"]<=43 for p in OUT.glob("*.json")): return
    receipt=run(exe,batch)
    write(path,receipt)
    print(batch,receipt["trials"],receipt["cost"],flush=True)


if __name__=="__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("action",choices=["advance","check","replay"])
    parser.add_argument("--batch",type=int)
    args=parser.parse_args();OUT.mkdir(exist_ok=True)
    paths=sorted(OUT.glob("*.json"))
    if args.action=="check":
        for path in paths: verify(load(path))
        print("Verified signed circuits:",len(paths))
    else:
        with TemporaryDirectory() as temp:
            exe=Path(temp)/"golay-graph"
            subprocess.run(["c++","-std=c++17","-O3",str(HERE/"graph_walk.cpp"),"-o",str(exe)],check=True)
            if args.action=="replay":
                for path in paths:
                    old=load(path)
                    if run(exe,old["batch"])!=old: raise ArithmeticError(f"Replay failed: {path}")
            else:
                advance(exe,len(paths) if args.batch is None else args.batch)
