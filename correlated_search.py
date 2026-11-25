"""Follow up the zero-score Werner runs with factors entangled across copies."""
import argparse
from fractions import Fraction
import json
from pathlib import Path
import random
import subprocess
import sys
import tempfile

from lab import ROOT, catalog
from verify import integer, werner


def sample(card, trials, seed):
    rng = random.Random(seed)
    k, d = card["copies"], card["d"]
    size = d**k
    best = None
    for _ in range(trials):
        # Two components differing on two copies cannot factor over all copies.
        i = rng.randrange(size)
        axes = rng.sample(range(k), 2)
        j = i
        for a in axes:
            digit = i // d**a % d
            new = (digit + rng.randrange(1, d)) % d
            j += (new-digit) * d**a
        x, y = rng.sample([s for s in range(size) if s not in (i,j)], 2)
        u = rng.choice([1, 2, 4, 8, 16])
        sign = rng.choice([-1,1])
        # Second term is diagonal. The first can have different left and right supports.
        right_second = rng.choice([j,y])
        w = {"terms":[[[[i,u],[j,1]],[[i,u],[right_second,sign]]],
                      [[[x,u]],[[x,rng.choice([-u,u])]]]]}
        score = Fraction(werner(card,w)["score"])
        if best is None or score < best[0]:
            best = score,w
    return best


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--seed",type=int,default=103)
    ap.add_argument("--trials",type=int,default=500)
    ap.add_argument("--out",type=Path,default=ROOT/"followup")
    args = ap.parse_args()
    integer(args.trials,1,100000)
    for c in catalog():
        if c["family"]!="werner" or c["role"]!="research":
            continue
        score, witness = sample(c,args.trials,args.seed)
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp)/"witness.json"
            path.write_text(json.dumps(witness))
            subprocess.run([sys.executable,str(ROOT/"submit.py"),c["id"],str(path),
                            "--out",str(args.out),"--credit",
                            f"correlated_search.py, seed {args.seed}, {args.trials} trials"],check=True)
