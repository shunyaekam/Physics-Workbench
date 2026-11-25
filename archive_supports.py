"""Portable compressed branch certificates with independently replayed color classes."""
import gzip
import json
import os
import tempfile
from pathlib import Path
from supports import audit


def read(path):
    with gzip.open(path,"rt") as f:
        return json.load(f)


def save(path,r):
    audit(r)
    with tempfile.NamedTemporaryFile(dir=path.parent,delete=False) as tmp:
        with gzip.GzipFile(filename="",fileobj=tmp,mode="wb",mtime=0) as f:
            f.write(json.dumps(r,separators=(",",":")).encode())
    os.replace(tmp.name,path)


if __name__=="__main__":
    import sys
    for name in sys.argv[1:]:
        r=read(Path(name))
        print(name,"exact" if audit(r) else "partial",len(r["best"]))
