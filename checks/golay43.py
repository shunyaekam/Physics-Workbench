"""Seek a 43-CNOT-equivalent circuit by reversing it on the exact cyclic Golay state."""
import argparse
from hashlib import sha256
from itertools import product
import json
import math
from pathlib import Path
import random
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from lab import write,load

OUT = ROOT/"campaign/golay43"
SEED = ROOT/"discovery/inputs/golay-44.json"
N = 23
AXES = list(product("XYZ",repeat=2))


def target():
    # X generators span the even-weight subcode (dual); Z generators span C.
    g = sum(1<<k for k in (0,2,4,5,6,10,11))
    code = [g<<i for i in range(12)]
    dual = [code[i]^code[i+1] for i in range(11)]
    if any(bin(a&b).count("1")%2 for a in code for b in dual):
        raise ArithmeticError("Generators fail to commute")
    def columns(rows,shift):
        return [sum(((r>>j)&1)<<(i+shift) for i,r in enumerate(rows)) for j in range(N)]
    return columns(dual,0),columns(code,11)


def seed_schedule():
    raw=SEED.read_bytes()
    if sha256(raw).hexdigest()!="99706fa2a1172f94de17a3eef6dbd8f0f72e8a5c53a6026b77fadb296f4b42eb":
        raise ValueError("Deposited circuit hash mismatch")
    # Move all local Cliffords to the end of the inverse circuit. The maps
    # below take physical Pauli axes into this moving frame.
    frames=[dict(zip("XYZ","XYZ")) for _ in range(N)]
    ops=[]
    for gate,a,*rest in reversed(json.loads(raw)["gates"]):
        f=frames[a]
        if gate=="CX":
            b=rest[0]
            ops.append((a,b,f["Z"],frames[b]["X"]))
        elif gate=="H":
            f["X"],f["Z"]=f["Z"],f["X"]
        elif gate in ("S","SDG"):
            f["X"],f["Y"]=f["Y"],f["X"]
        elif gate not in ("X","Y","Z"):
            raise ValueError("Unknown gate")
    if len(ops)!=44: raise ValueError("Unexpected baseline length")
    return ops


def mixed(ops):
    x,z=BASE[0].copy(),BASE[1].copy()
    for a,b,P,Q in ops:
        # Bit i indicates anticommutation of stabilizer generator i with that axis.
        left = z[a] if P=="X" else x[a] if P=="Z" else x[a]^z[a]
        right = z[b] if Q=="X" else x[b] if Q=="Z" else x[b]^z[b]
        if P!="Z": x[a]^=right
        if P!="X": z[a]^=right
        if Q!="Z": x[b]^=left
        if Q!="X": z[b]^=left
    # A pure stabilizer qubit is an eigenstate of a local Pauli precisely when
    # these two binary columns are dependent. Local signs are free to correct.
    return sum(bool(i and j and i!=j) for i,j in zip(x,z))


BASE=target()


def run(batch):
    ops=seed_schedule()
    if mixed(ops)!=0 or mixed([])!=N: raise ArithmeticError("Baseline or negative control failed")
    best=N; tested=0; lead=None; hits=[]
    rng=random.Random(230043+batch)
    if batch >= 2:
        # Start near the best one-deletion state and allow both wire pairs and
        # axes to change. Every proposal still has exactly 43 entanglers.
        for restart in range(12):
            skip=rng.randrange(44) if restart%3 else 12
            circuit=ops[:skip]+ops[skip+1:]
            score=mixed(circuit)
            for step in range(4000):
                attempt=circuit[:]
                i=rng.randrange(43);a,b,P,Q=attempt[i]
                move=rng.randrange(5)
                if move < 2: P,Q=rng.choice(AXES)
                elif move == 2:
                    a=rng.choice([j for j in range(N) if j!=b])
                elif move == 3:
                    b=rng.choice([j for j in range(N) if j!=a])
                else:
                    attempt.insert(rng.randrange(43),attempt.pop(i))
                if move!=4: attempt[i]=(a,b,P,Q)
                value=mixed(attempt);tested+=1
                if value<best: best=value;lead=dict(inverse_schedule=attempt)
                if value==0: hits.append(attempt);break
                temperature=0.25+0.65*(1-step/4000)
                if value<=score or rng.random()<math.exp((score-value)/temperature):
                    circuit,score=attempt,value
            if hits: break
    for skip in range(len(ops)) if batch < 2 else []:
        start=ops[:skip]+ops[skip+1:]
        if batch==0:
            changes=[[]]+[[(i,axis)] for i,(a,b,P,Q) in enumerate(start) for axis in AXES if axis!=(P,Q)]
        else:
            changes=[[(i,rng.choice(AXES)) for i in rng.sample(range(43),rng.choice((2,3,4)))]
                     for _ in range(450)]
        for edits in changes:
            attempt=start[:]
            for i,(P,Q) in edits:
                attempt[i]=(*attempt[i][:2],P,Q)
            value=mixed(attempt);tested+=1
            if value<best:
                best=value;lead=dict(omitted_inverse_gate=skip,edits=edits)
            if value==0:
                hits.append(attempt)
                break
        if hits: break
    return dict(problem_id="golay43",batch=batch,baseline_entanglers=44,trial_entanglers=43,
                attempts=tested,best_mixed=best,best_mutation=lead,candidates=hits,
                scope=("Fixed wire pairs from a one-gate deletion, with local Pauli-axis changes. Repeated random proposals can occur." if batch < 2 else "Seeded local walk changing axes, wire pairs and order at 43 gates. Repeated proposals can occur."))


if __name__=="__main__":
    parser=argparse.ArgumentParser();parser.add_argument("action",choices=["advance","replay"]);args=parser.parse_args()
    OUT.mkdir(exist_ok=True)
    for batch in range(8):
        path=OUT/f"{batch:03d}.json"
        if args.action=="advance" and not path.exists():
            write(path,run(batch));break
        if path.exists():
            saved=load(path)
            if args.action=="replay" and json.loads(json.dumps(run(batch)))!=saved:
                raise ArithmeticError("Replay failed")
            if saved["candidates"]:break
