"""Retrieve the classified connected graph-state representatives and expand to length ten.

Usage: python3 graphs.py [output-directory]
Existing input files are reused only after validating their SHA-256 digest.
"""
import hashlib
from pathlib import Path
import sys
from urllib.request import urlopen

BASE = "https://www.codetables.de/larsed/vncorbits/"
COUNTS = (0,1,1,1,2,4,11,26,101,440,3132)
DIGESTS = (
    "",
    "ecf5de1a2ecc66a1876a832804c64f6b5125784e94c82285d9720621c613ab46",
    "fae4bfc454bd04363dcd5222772f2973b1193e1ff6f676e822a427323a677ef9",
    "881159da90c6f28631b6a3eafd6d6d13cda0d0e4cc09d828374719d272f3da34",
    "9879efc8c9b3235f2c57306a13c1f9548cf56e9795671a542f04b2a4dfc3c547",
    "cb031d9b7c45046642715d9456b22b909624185e3abb0103e7e79cf8c33d53af",
    "5a6dba6aec9a4ad3c02e0abcdca6af9589d8cd5cca44714c0a07cc60430ed222",
    "db980752c571699473a557f689321bbd499e4c12ff75b38da8b3bed3bb6fda80",
    "f8a6c82c4293a57352f83c8dda2248fb8d02fefcfba6a883ae5f329b1437321f",
    "4a15f367e53ae2cdd6bd715d3570f44a3ac0e38fcec5caf945c4a3da51512ab0",
    "57f6ef1769d7fc20114e1c9a996c23523b90e36635e051f95e81f1a09e354f5f",
)
ALL10 = "b1a7d75bd683b1f2f54f245d312e6df593a6c6355dd6b9903ac5e508a49e0763"

def disjoint_graphs(parts, remaining=10, minimum=1):
    if remaining == 0:
        yield []
        return
    for order in range(minimum, remaining+1):
        for tail in disjoint_graphs(parts, remaining-order, order):
            for i, graph in enumerate(parts[order]):
                if tail and order == tail[0][0] and i > tail[0][1]:
                    continue
                yield [(order,i,graph)] + tail

def graph6_rows(word, n):
    if ord(word[0])-63 != n or len(word) != 1+(n*(n-1)//2+5)//6:
        raise ValueError("Malformed graph6 order or payload length")
    bits = "".join(format(ord(c)-63, "06b") for c in word[1:])
    rows = [0]*n
    for j in range(n):
        for i in range(j):
            if bits[j*(j-1)//2+i] == "1":
                rows[i] |= 1 << j
                rows[j] |= 1 << i
    return rows

def generate(directory):
    directory.mkdir(parents=True, exist_ok=True)
    parts = {}
    for n in range(1, 11):
        name = f"vncorbits{n}.g6"
        path = directory/name
        data = path.read_bytes() if path.exists() else urlopen(BASE+name, timeout=60).read()
        if hashlib.sha256(data).hexdigest() != DIGESTS[n]:
            raise ValueError(f"Unexpected checksum for {name}")
        rows = data.decode("ascii").splitlines()
        if len(rows) != COUNTS[n]:
            raise ValueError(f"Wrong number of representatives in {name}")
        if not path.exists():
            path.write_bytes(data)
        parts[n] = [graph6_rows(word,n) for word in rows]
    parents = []
    for partition in disjoint_graphs(parts):
        rows = []
        for _, _, graph in partition:
            offset = len(rows)
            rows.extend(x << offset for x in graph)
        parents.append(" ".join(map(str, rows)))
    data = ("\n".join(parents)+"\n").encode("ascii")
    if len(parents) != 3990 or hashlib.sha256(data).hexdigest() != ALL10:
        raise ValueError("Length-ten orbit inventory mismatch")
    (directory/"all10.txt").write_bytes(data)
    print("3990 representatives: 3132 connected, 858 disconnected")

if __name__ == "__main__":
    if len(sys.argv)>2:
        raise SystemExit("Usage: python3 graphs.py [output-directory]")
    generate(Path(sys.argv[1]) if len(sys.argv)==2 else Path.cwd())
