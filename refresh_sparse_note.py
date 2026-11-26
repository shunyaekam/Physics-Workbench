"""Refresh the public sparse-state manuscript after exact interval replay."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
from time import monotonic

import excited_pairs as pairs
from lab import write
from paper_build import stage_paper_directory

ROOT = Path(__file__).resolve().parent
PAPERS = ROOT / "papers"
NOTE = PAPERS / "sparse-fock-coherence.tex"
TABLE = PAPERS / "sparse-certified.tex"
LEDGER = pairs.OUT / "paper-replay.json"


def spans(values):
    groups = []
    for value in values:
        if groups and groups[-1][1]+1 == value:
            groups[-1][1] = value
        else:
            groups.append([value, value])
    return ", ".join(str(a) if a==b else f"{a}--{b}" for a,b in groups)


def refresh(seconds=45):
    old = json.loads(LEDGER.read_text()) if LEDGER.exists() else {}
    h = hashlib.sha256()
    for name in ("fock_pairs.py", "excited_pairs.py", "renyi_scan.py", "refresh_sparse_note.py"):
        h.update((ROOT/name).read_bytes())
    key = h.hexdigest()
    known = old.get("pairs", {}) if old.get("checker")==key else {}
    accepted = {}
    deadline = monotonic()+seconds
    by_level = {}
    replay_deferred = False
    for n in range(2, pairs.BOUND+1):
        for m in range(1,n):
            paths = [pairs.LIVE/f"levels-{a:02}-{b:02}.json" for a,b in ((m,n),(n,m))]
            if not all(p.exists() for p in paths):
                continue
            rows = [json.loads(p.read_text()) for p in paths]
            if any(r["pending"] or r["unresolved"] for r in rows):
                continue
            name = f"{m},{n}"
            digest = hashlib.sha256(b"".join(p.read_bytes() for p in paths)).hexdigest()
            if known.get(name) != digest:
                if monotonic() >= deadline:
                    replay_deferred = True
                    continue
                for (a,b),r in zip(((m,n),(n,m)),rows):
                    if pairs.process(a,b,r["tested"]) != r:
                        raise ValueError(f"Unreproducible sparse pair {name}")
            accepted[name] = digest
            by_level.setdefault(n,[]).append(m)
    lines = [r"\paragraph{Replayed excited-level subspaces.}",
             f"The current working paper includes {len(accepted)} fully covered excited-level pairs.",
             r"Each row gives the larger photon count and all certified smaller counts.",
             r"\begin{center}\begin{tabular}{rl}Larger count & Smaller counts\\\hline"]
    lines += [f"{n} & {spans(ms)} " + r"\\" for n,ms in by_level.items()]
    lines += [r"\end{tabular}\end{center}"]
    content = "\n".join(lines)+"\n"
    if not replay_deferred and (not TABLE.exists() or TABLE.read_text() != content):
        with tempfile.TemporaryDirectory(dir=PAPERS) as directory:
            directory=stage_paper_directory(directory,ROOT)
            source=directory/NOTE.name
            source.write_bytes(NOTE.read_bytes())
            tab=directory/TABLE.name
            tab.write_text(content)
            subprocess.run(["tectonic",source.name],cwd=directory,check=True,timeout=90)
            pdf=source.with_suffix(".pdf")
            if not pdf.read_bytes().startswith(b"%PDF"):
                raise ValueError("Sparse manuscript PDF build failed")
            os.replace(tab,TABLE)
            os.replace(pdf,NOTE.with_suffix(".pdf"))
    new = dict(checker=key,pairs=accepted)
    if old != new:
        write(LEDGER,new)
    if replay_deferred:
        print("Partial sparse replay:",len(accepted),"pairs checked so far",flush=True)
    else:
        print("Replayed pairs in the sparse manuscript:",len(accepted),flush=True)


if __name__=="__main__":
    refresh()
