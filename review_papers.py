"""Ask for an executable counterexample when the manuscripts change."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys

from lab import ROOT,ollama,write
from verify import require
from checks.scrutiny import psd


def review():
    papers=[ROOT/"papers"/f for f in ("coordinate-supports.tex","finite-maxima.tex")]
    hashes={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in papers}
    key=hashlib.sha256(json.dumps(hashes,sort_keys=True).encode()).hexdigest()
    directory=ROOT/"campaign/reviews"
    directory.mkdir(exist_ok=True)
    path=directory/(key+".json")
    if path.exists():
        saved=json.loads(path.read_text())
        require(saved.get("theorem_matched",True),"open theorem contradiction; inspect archived case")
        return
    prompt=("You are a referee. Try to falsify the three-word compression or distance-threshold argument. "
            "Supply three DISTINCT length-three ternary words, at alpha=2/5. State your predicted "
            "sign class of the smallest eigenvalue of the diagonal block. Your objection will be "
            "tested by exact arithmetic. The finite values in the companion paper need their own independent replay.\n"
            +papers[0].read_text()+"\n"+papers[1].read_text())
    schema={"type":"object","required":["objection","words","prediction"],"properties":{
        "objection":{"type":"string"},"words":{"type":"array","minItems":3,"maxItems":3,"items":{
            "type":"string","pattern":"^[012]{3}$"}},"prediction":{"type":"string","enum":["PSD","indefinite"]}}}
    try:
        reply=ollama("generate",dict(model="llama3.2:3b",format=schema,prompt=prompt,stream=False,
                    options={"seed":77,"num_predict":400,"num_ctx":8192}),timeout=90)
    except (OSError,TimeoutError) as e:
        print("Local model unavailable; manuscript critique deferred:",e)
        return
    rec=dict(manuscript_sha256=hashes,model=reply["model"],prompt=prompt.split("\n")[0],
             raw=reply["response"],prediction_scope="the submitted three-word case only")
    try:
        note=json.loads(reply["response"])
        words=note["words"]
        require(len(words)==len(set(words))==3 and all(len(w)==3 and set(w)<=set("012") for w in words),
                "invalid ternary triple")
        require(note["prediction"] in ("PSD","indefinite"),"invalid sign prediction")
        block=[]
        distances=[]
        for i,x in enumerate(words):
            row=[]
            for j,y in enumerate(words):
                product=1
                for a,b in zip(x,y):
                    product*=5*int(a==b)-2
                row.append(product)
                if i<j:
                    distances.append(sum(a!=b for a,b in zip(x,y)))
            block.append(row)
        exact="PSD" if psd(block) else "indefinite"
        from fractions import Fraction
        t=Fraction(2,3)
        prediction=(sum(distances)%2==0 or sum(t**(2*h) for h in distances)+2*t**sum(distances)<=1)
        rec.update(dense_integer_matrix=block,exact=exact,reviewer_prediction_matched=(exact==note["prediction"]),
                   theorem_matched=(prediction==(exact=="PSD")))
    except (KeyError,ValueError,TypeError) as exc:
        rec["reviewer_input_rejected"]=str(exc)
    # Even an invalid proposed test is followed by an independently chosen audit.
    for script in ("scrutiny.py","thresholds.py"):
        run=subprocess.run([sys.executable,str(ROOT/"checks"/script)],capture_output=True,text=True,check=True)
        rec[script]=run.stdout.splitlines()
    from continuous import read_cases
    rec["independently_replayed_maxima"]={f"{d},{k}":n for (d,k),n in read_cases(check=True).items()}
    write(path,rec)
    require(rec.get("theorem_matched",True),"physical matrix contradicts theorem; review incident saved")
    print("Manuscript review archived",key[:12])


if __name__=="__main__":
    review()
