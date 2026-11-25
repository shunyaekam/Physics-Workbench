"""Cross-check tensor factors against Stim's graph form and run positive controls."""
import json
from pathlib import Path
from random import Random
import subprocess
from tempfile import TemporaryDirectory

from graph_campaign import HERE
from graph_inputs import decompose, g, target_sim, apply_pauli_gate


def components(graph):
    unseen=set(range(len(graph)))
    parts=set()
    while unseen:
        group=set()
        queue=[next(iter(unseen))]
        while queue:
            i=queue.pop()
            if i not in unseen: continue
            unseen.remove(i)
            group.add(i)
            queue.extend(j for j in unseen if graph[i]>>j&1)
        parts.add(frozenset(group))
    return parts


def test_partitions(exe):
    seed=g.seed_schedule()
    rng=Random(1943)
    schedules=[[],seed]+[seed[:i] for i in range(1,len(seed))]
    for _ in range(200):
        omit=set(rng.sample(range(44),rng.randrange(1,11)))
        schedules.append([op for i,op in enumerate(seed) if i not in omit])
    inputs=[]
    expected=[]
    for schedule in schedules:
        sim=target_sim()
        for op in schedule: apply_pauli_gate(sim,op)
        generators=sim.canonical_stabilizers()
        columns=[[sum(1<<r for r,row in enumerate(generators) if row[i] in axes)
                  for i in range(23)] for axes in ((1,2),(2,3))]
        inputs.append(" ".join(str(c) for col in columns for c in col))
        expected.append(components(decompose(schedule)[0]))
    lines=subprocess.check_output([exe,"--components"],input="\n".join(inputs)+"\n",text=True).splitlines()
    if len(lines)!=len(expected): raise ArithmeticError("Missing tensor factor output")
    for labels,want in zip(lines,expected):
        ids=list(map(int,labels.split()))
        parts={frozenset(i for i,other in enumerate(ids) if other==label) for label in ids}
        if parts!=want: raise ArithmeticError("Tensor partition mismatch")
    print(f"Stim graph components agree on {len(schedules)} states")


def controls(splice,repair):
    # A GHZ on three sites requires two entanglers; a Bell pair requires one.
    def state(edges):
        x=[1<<i for i in range(23)]
        z=[0]*23
        for i,j in edges:
            z[i]^=1<<j
            z[j]^=1<<i
        return " ".join(map(str,x+z))+"\n"
    empty_gates="0 1 2 2\n"
    def check(args,data,expected):
        receipt=json.loads(subprocess.check_output(args,input=data,text=True))
        if receipt["found"]!=expected: raise ArithmeticError("Synthetic control failed")
    bell=state([(0,1)])
    ghz=state([(0,1),(1,2)])
    check([splice,"--check"],bell+empty_gates*2,True)
    check([splice,"--check"],ghz+empty_gates*2,False)
    check([splice,"--tail","--check"],ghz+empty_gates*3,True)
    check([repair,"2","1"],bell+empty_gates*2,True)
    check([repair,"2","1"],ghz+empty_gates*2,False)
    print("Five synthetic search controls passed")


if __name__=="__main__":
    with TemporaryDirectory() as temp:
        def compile_search(name):
            exe=Path(temp)/name
            subprocess.run(["c++","-O3","-std=c++17",str(HERE/(name+".cpp")),"-o",str(exe)],check=True)
            return exe
        repair=compile_search("repair")
        test_partitions(repair)
        controls(compile_search("splice"),repair)
