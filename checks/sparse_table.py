"""Bind the printed excited-state subspaces to both directional proof receipts."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
TABLE = Path("papers/sparse-certified.tex")
LEDGER = Path("campaign/fock-pairs/paper-replay.json")
RECEIPTS = LEDGER.parent / "excited"


def table_pairs(text):
    counts = re.findall(r"includes ([0-9]+) fully covered excited-level pairs", text)
    bodies = re.findall(r"\\begin\{tabular\}\{rl\}.*?\\hline\s*\n(.*?)\\end\{tabular\}", text, re.S)
    if len(bodies) != 1:
        raise ValueError("Expected a single excited-pair table")
    pairs = set()
    for line in bodies[0].splitlines():
        row = re.fullmatch(r"([0-9]+) & ([0-9 ,\-]+) \\\\", line.strip())
        if row is None:
            raise ValueError("Unrecognized printed table row")
        high, low_entries = row.groups()
        n = int(high)
        for span in low_entries.split(", "):
            bounds = [int(x) for x in span.split("--")]
            if len(bounds) > 2 or not 1 <= bounds[0] <= bounds[-1] < n:
                raise ValueError("Invalid photon range in printed table")
            for m in range(bounds[0], bounds[-1]+1):
                if (m, n) in pairs:
                    raise ValueError("Duplicate pair in printed table")
                pairs.add((m, n))
    if counts != [str(len(pairs))]:
        raise ValueError("Printed total disagrees with printed rows")
    return pairs


def audit(root, recompute=False):
    pairs = table_pairs((root/TABLE).read_text())
    entries = json.loads((root/LEDGER).read_text())["pairs"]
    if {f"{m},{n}" for m,n in pairs} != set(entries):
        raise ValueError("Printed subspaces disagree with replay ledger")
    if not {(m,n) for n in range(2,6) for m in range(1,n)} <= pairs:
        raise ValueError("Printed evidence omits a six-level corollary pair")
    if recompute:
        from excited_pairs import process
    for m,n in sorted(pairs, key=lambda mn: (mn[1],mn[0])):
        digest = hashlib.sha256()
        for a,b in ((m,n),(n,m)):
            path = root/RECEIPTS/f"levels-{a:02}-{b:02}.json"
            content = path.read_bytes()
            row = json.loads(content)
            if (row["m"],row["n"]) != (a,b) or row["pending"] or row["unresolved"]:
                raise ValueError(f"Incomplete or misidentified receipt: {path}")
            if recompute and process(a,b,row["tested"]) != row:
                raise ValueError(f"Dyadic replay failed: {path}")
            digest.update(content)
        if digest.hexdigest() != entries[f"{m},{n}"]:
            raise ValueError(f"Receipt digest mismatch for ({m},{n})")
    return len(pairs)


def negative_controls(root):
    with tempfile.TemporaryDirectory() as directory:
        temp = Path(directory)
        (temp/TABLE).parent.mkdir(parents=True)
        (temp/RECEIPTS).mkdir(parents=True)
        shutil.copy(root/TABLE, temp/TABLE)
        shutil.copy(root/LEDGER, temp/LEDGER)
        for row in (root/RECEIPTS).glob("levels-*.json"):
            shutil.copy(row,temp/RECEIPTS)
        count = audit(temp)
        page = temp/TABLE
        original = page.read_bytes()
        receipt = temp/RECEIPTS/"levels-06-02.json"
        data = receipt.read_bytes()
        changes = [
            (page, original.replace(b"2 & 1 ", b"17 & 1 ")),
            (page, original.replace(f"includes {count} ".encode(), b"includes 0 ")),
            (receipt, None),
            (receipt, json.dumps({**json.loads(data), "tested": 0}).encode()),
        ]
        for target, new in changes:
            old = target.read_bytes()
            if new is None:
                target.unlink()
            else:
                target.write_bytes(new)
            try:
                audit(temp)
            except (ValueError, FileNotFoundError):
                pass
            else:
                raise RuntimeError(f"Accepted corrupted proof evidence: {target}")
            target.write_bytes(old)
    print("Rejected an altered table row, incorrect count, missing direction, and altered receipt.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--replay", action="store_true", help="Recompute every printed interval cover")
    parser.add_argument("--self-test", action="store_true", help="Try four corruptions on temporary copies")
    args = parser.parse_args()
    print("Published pairs bound to complete receipts:", audit(ROOT, args.replay), flush=True)
    if args.self_test:
        negative_controls(ROOT)
