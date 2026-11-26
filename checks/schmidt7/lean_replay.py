"""Ask the Lean kernel to check each rational witness after clearing denominators."""
from concurrent.futures import ThreadPoolExecutor
from fractions import Fraction
from itertools import combinations,combinations_with_replacement
from math import gcd
from pathlib import Path
from tempfile import TemporaryDirectory
import json
import os
import shutil
import subprocess


HERE=Path(__file__).resolve().parent


def replay():
    version=(HERE.parents[1]/"formal/lean-toolchain").read_text().strip().split(":v")[1]
    cached=Path.home()/"Library/Caches/Physics-Workbench"/f"lean-{version}-darwin_aarch64/bin/lean"
    lean=os.environ.get("WORKBENCH_LEAN") or shutil.which("lean") or str(cached)
    if f"version {version}," not in subprocess.check_output([lean,"--version"],text=True):
        raise ValueError("Toolchain version mismatch")
    rows=[]
    for k in (3,5,6,2):
        for s in combinations(range(7),k):
            mask=sum(1<<i for i in s)
            rows.append(({3:0,5:1,6:2,2:4}[k],mask,0))
            if k==6: rows.extend((3,mask,i) for i in s)
    source=(HERE/"Certificate.lean").read_text()
    records=json.loads((HERE/"duals.json").read_text())
    if [tuple(r["key"]) for r in records]!=list(combinations_with_replacement(range(1,8),4)):
        raise ValueError("Incomplete quartic coverage")
    chunks=[]
    for r in records:
        terms=[(rows[i],Fraction(m)) for i,m in r["dual"]]
        den=1
        for _,m in terms: den=den*m.denominator//gcd(den,m.denominator)
        packed=",".join(f"⟨{kind},{mask},{pin},{int(m*den)}⟩" for (kind,mask,pin),m in terms)
        small=any(row[0]==4 for row,m in terms)
        key=r["key"]
        if small and (not ({1,2}&set(key)) or not ({2,3}&set(key))):
            raise ValueError("Invalid dimension-specific degeneracy claim")
        name="case_"+"".join(map(str,key))
        chunks.append((name,f"theorem {name} : check {key} {den} [{packed}] {str(small).lower()} = true := by decide"))
    with TemporaryDirectory() as tmp:
        def check_batch(offset):
            batch=chunks[offset:offset+10]
            path=Path(tmp)/f"Batch{offset}.lean"
            path.write_text(source+"\nnamespace SchmidtSeven\nset_option maxRecDepth 10000\nset_option maxHeartbeats 4000000\n"
                            +"\n".join(s+"\n#print axioms "+n for n,s in batch)+"\nend SchmidtSeven\n")
            out=subprocess.run([lean,"-DwarningAsError=true",str(path)],text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
            if out.returncode: raise RuntimeError(out.stdout)
            for name,_ in batch:
                line=next((x for x in out.stdout.splitlines() if f"'SchmidtSeven.{name}'" in x),"")
                if "does not depend on any axioms" not in line and not line.endswith("depends on axioms: [propext]"):
                    raise ValueError("Unexpected axiom report: "+line)
            return len(batch)
        with ThreadPoolExecutor(max_workers=4) as pool:
            count=sum(pool.map(check_batch,range(0,len(chunks),10)))
    print(f"Lean {version} kernel checked {count} cleared-denominator certificate inequalities.")


if __name__=="__main__": replay()
