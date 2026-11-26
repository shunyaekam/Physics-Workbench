"""Independent high-precision check using the normalization specified by the benchmark."""
import csv
import itertools
import json
from pathlib import Path

import mpmath as mp


def maximum(path,dim,count):
    rows=[]
    with path.open() as f:
        for values in csv.reader(f):
            row=list(map(mp.mpf,values))
            if len(row)!=dim or len(rows)>=count: raise ValueError("Invalid shape")
            l=mp.sqrt(mp.fdot(row,row))
            rows.append([x/l for x in row])
    if len(rows)!=count: raise ValueError("Invalid count")
    return max(mp.fdot(a,b) for a,b in itertools.combinations(rows,2))

if __name__=="__main__":
    mp.mp.dps=50
    root=Path(__file__).resolve().parent
    for record in json.loads((root/"comparisons.json").read_text()):
        dim,count=record["d"],record["n"]
        directory=root/f"{dim}-{count}"
        x=maximum(directory/"points.csv",dim,count)
        old=maximum(directory/"baseline.csv",dim,count)
        published=mp.mpf(record["table_cosine"])
        if abs(old-published)>mp.mpf("1e-11") or not x<mp.mpf(record["certified_upper"]) or published-x<mp.mpf("1e-10"):
            raise ValueError("Comparison failed")
        print(dim,count,mp.nstr(x,45),mp.nstr(mp.degrees(mp.acos(x)),40))
