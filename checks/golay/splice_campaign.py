"""Exhaustive delete-two/insert-one search around verified graph-walk circuits."""
from math import comb
from pathlib import Path
from tempfile import TemporaryDirectory
from itertools import combinations,product
import argparse
import json
import subprocess
import stim
from graph_campaign import HERE,OUT as GRAPHS,verify
from repair_campaign import AXIS,NAMES
from graph_inputs import g
from graph_replay import controlled_pauli,signed_forward
from lab import load,write

OUT=g.ROOT/"campaign/golay-splices"


TAIL_OUT=g.ROOT/"campaign/golay-splice-tails"


def search(exe,source,check=False,tail=False):
    seed=g.seed_schedule() if source=="published" else verify(load(GRAPHS/(source+".json")))
    if len(seed)!=44: raise ValueError("Need an exact 44-gate seed")
    rows=[*g.BASE,*[(a,b,AXIS[p],AXIS[q]) for a,b,p,q in seed]]
    encoded="\n".join(" ".join(map(str,row)) for row in rows)+"\n"
    result=json.loads(subprocess.check_output([str(exe)]+(["--check"] if check else [])+(["--tail"] if tail else []),input=encoded,text=True))
    if result["found"]:
        ops=[op for i,op in enumerate(seed) if i not in result["omit"]]
        a,b,p,q=result["gate"];ops.insert(result["insert_at"],(a,b,NAMES[p],NAMES[q]))
        if tail and g.mixed(ops):
            # Only a single entangled pair remains. Recover an explicit last gate.
            closing=next(((i,j,p,q) for i,j in combinations(range(23),2)
                          for p,q in product("XYZ",repeat=2) if g.mixed(ops+[(i,j,p,q)])==0),None)
            if closing is None: raise ArithmeticError("Could not close remaining pair")
            ops.append(closing)
            result["closing_gate"]=list(closing)
        if len(ops)>43 or g.mixed(ops)!=0: raise ArithmeticError("Splice candidate failed")
        undo=stim.Circuit()
        for op in ops: controlled_pauli(undo,*op)
        result["forward_stim"]=str(signed_forward(undo,len(ops)))
        result["cost"]=len(ops)
    elif result["trials"]!=comb(44,3 if tail else 2)*(42 if tail else 43)*comb(23,2)*9:
        raise ArithmeticError("Incomplete splice enumeration")
    return dict(source=source,**({"allow_final_gate":True} if tail else {}),**result)


def advance(exe,source,tail=False):
    out=TAIL_OUT if tail else OUT
    out.mkdir(exist_ok=True)
    path=out/(source+".json")
    if path.exists():return load(path)
    result=search(exe,source,tail=tail);write(path,result)
    return result


if __name__=="__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("source")
    parser.add_argument("--check",action="store_true")
    parser.add_argument("--tail",action="store_true")
    args=parser.parse_args()
    with TemporaryDirectory() as temp:
        exe=Path(temp)/"splice"
        subprocess.run(["c++","-std=c++17","-O3",str(HERE/"splice.cpp"),"-o",str(exe)],check=True)
        print(search(exe,args.source,args.check,args.tail))
