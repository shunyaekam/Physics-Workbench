"""Exhaustive delete-two/insert-one search around verified graph-walk circuits."""
from math import comb
from hashlib import sha256
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


def source_seed(source):
    seed=g.seed_schedule() if source=="published" else verify(load(GRAPHS/(source+".json")))
    if len(seed)!=44: raise ValueError("Need an exact 44-gate seed")
    return seed


def input_key(seed):
    # Gate order is significant; only swap the two endpoint/axis pairs of an
    # individual controlled phase. Bind both the schedule and target columns.
    normalized=[(a,b,p,q) if a<b else (b,a,q,p) for a,b,p,q in seed]
    return json.dumps([g.BASE,normalized],separators=(",",":"))


def size(tail):
    return comb(44,3 if tail else 2)*(42 if tail else 43)*comb(23,2)*9


def search(exe,source,check=False,tail=False,schema=2):
    if schema not in (1,2): raise ValueError("Unknown splice receipt version")
    seed=source_seed(source)
    rows=[*g.BASE,*[(a,b,AXIS[p],AXIS[q]) for a,b,p,q in seed]]
    encoded="\n".join(" ".join(map(str,row)) for row in rows)+"\n"
    result=json.loads(subprocess.check_output([str(exe)]+(["--check"] if check else [])+(["--tail"] if tail else [])+(["--canonical"] if schema==2 else []),input=encoded,text=True))
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
    elif result["trials"]+result.get("equivalent_skipped",0)!=size(tail):
        raise ArithmeticError("Incomplete splice enumeration")
    if schema==2:
        result.update(schema=2,input_sha256=sha256(input_key(seed).encode()).hexdigest())
    return dict(source=source,**({"allow_final_gate":True} if tail else {}),**result)


def equivalent(source,out,tail,reference=None):
    key=input_key(source_seed(source))
    digest=sha256(key.encode()).hexdigest()
    paths=sorted(out.glob("*.json")) if reference is None else [out/(reference+".json")]
    for path in paths:
        old=load(path)
        if (old["found"] or "equivalent_to" in old or path.stem==source or
            old["trials"]+old.get("equivalent_skipped",0)!=size(tail)):
            continue
        if old.get("input_sha256",digest)!=digest:
            continue
        if input_key(source_seed(old["source"]))==key:
            return dict(source=source,**({"allow_final_gate":True} if tail else {}),
                        schema=2,input_sha256=digest,equivalent_to=old["source"],
                        found=False,trials=0,direct=0,equivalent_skipped=size(tail))
    return None


def advance(exe,source,tail=False):
    out=TAIL_OUT if tail else OUT
    out.mkdir(exist_ok=True)
    path=out/(source+".json")
    if path.exists():return load(path)
    result=equivalent(source,out,tail) or search(exe,source,tail=tail)
    write(path,result)
    return result


if __name__=="__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("source")
    parser.add_argument("--check",action="store_true")
    parser.add_argument("--tail",action="store_true")
    parser.add_argument("--replay",action="store_true",help="Reproduce the stored receipt using its original algorithm")
    args=parser.parse_args()
    with TemporaryDirectory() as temp:
        exe=Path(temp)/"splice"
        subprocess.run(["c++","-std=c++17","-O3",str(HERE/"splice.cpp"),"-o",str(exe)],check=True)
        if args.replay:
            out=TAIL_OUT if args.tail else OUT
            old=load(out/(args.source+".json"))
            if "equivalent_to" in old:
                referenced=load(out/(old["equivalent_to"]+".json"))
                expected=search(exe,old["equivalent_to"],args.check,args.tail,referenced.get("schema",1))
                if (old!=equivalent(args.source,out,args.tail,old["equivalent_to"]) or expected!=referenced or
                    input_key(source_seed(args.source))!=input_key(source_seed(old["equivalent_to"]))):
                    raise ArithmeticError("Referenced exhaustive result disagrees")
            elif search(exe,args.source,args.check,args.tail,old.get("schema",1))!=old:
                raise ArithmeticError("Splice replay disagrees")
            print("Verified splice receipt",args.source)
        else:
            print(search(exe,args.source,args.check,args.tail))
