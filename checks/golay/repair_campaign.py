"""Enumerate deletion masks and try shorter inverse tails; optionally use graph-walk seeds."""
import argparse
from math import comb
from pathlib import Path
import subprocess
import json
from tempfile import TemporaryDirectory

from graph_campaign import OUT as GRAPHS, HERE, verify
from graph_replay import controlled_pauli, signed_forward
import stim
from graph_inputs import g
from lab import load,write

OUT=g.ROOT/"campaign/golay-repairs"
AXIS={"X":1,"Z":2,"Y":3}
NAMES={i:a for a,i in AXIS.items()}


def evaluate(exe,source,drop):
    if source=="published":
        seed=g.seed_schedule()
    else:
        seed=verify(load(GRAPHS/(source+".json")))
    encoded=[*g.BASE,*[(a,b,AXIS[p],AXIS[q]) for a,b,p,q in seed]]
    data="\n".join(" ".join(map(str,row)) for row in encoded)+"\n"
    save=len(seed)-43
    if not 0<save<=drop: raise ValueError("Invalid repair budget")
    result=json.loads(subprocess.check_output([str(exe),str(drop),str(save)],input=data,text=True))
    if not result["found"] and result["masks"]!=comb(len(seed),drop):
        raise ArithmeticError("Incomplete subset enumeration")
    if result["found"]:
        omitted=set(result["omitted"])
        inverse=[gate for i,gate in enumerate(seed) if i not in omitted]
        inverse.extend((a,b,NAMES[p],NAMES[q]) for a,b,p,q in result["tail"])
        if len(inverse)>43 or g.mixed(inverse)!=0: raise ArithmeticError("Unverified repair")
        undo=stim.Circuit()
        for gate in inverse: controlled_pauli(undo,*gate)
        result["forward_stim"]=str(signed_forward(undo,len(inverse)))
    return dict(source=source,deleted=drop,budget=drop-save,**result)


if __name__=="__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("source",help="published or the six-digit graph batch")
    parser.add_argument("drops",type=int,nargs="+")
    args=parser.parse_args()
    OUT.mkdir(exist_ok=True)
    with TemporaryDirectory() as temp:
        exe=Path(temp)/"repair"
        subprocess.run(["c++","-std=c++17","-O3",str(HERE/"repair.cpp"),"-o",str(exe)],check=True)
        for k in args.drops:
            result=evaluate(exe,args.source,k)
            path=OUT/f"{args.source}-d{k}.json"
            if path.exists() and load(path)!=result: raise ArithmeticError("Replay mismatch")
            write(path,result)
            print(path.name,result["masks"],result["found"])
            if result["found"]:break
