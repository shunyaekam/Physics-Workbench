"""Rebuild both two-dimensional compact covers in the sharp qubit order theorem."""
from fractions import Fraction as F
from math import factorial
from pathlib import Path
import json
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from order_bands import process


def certificate():
    # Exact constants for the large-radius estimate and the one-photon edge.
    for x, lower in [(F(15,4), 42), (F('10.08'), 20000)]:
        assert sum(x**k/factorial(k) for k in range(16)) > lower
    assert F(7,50)*F(9,10)**2 > 2*F('2.52')*F('11.08')/20000 + F(9,84)
    assert (F('.30')-F('.28')**2*F('.98'))/F('.70') < F(8,25)
    assert 2*F('.206')*F(5,4)/(F(33,32)*F(49,32)) > F(8,25)
    assert 2*sum(F(-1,2)**k/factorial(k) for k in range(6))-1 > F('.21')
    rows = []
    for low, high, first in [(F('.29'), F('.5'), F(0)), (F('.28870'), F('.29'), F(1,32))]:
        for shell in range(9):
            start = first if shell==0 else F(shell)
            state = process(shell, 2000000, low=low, high=high, start=start)
            if any(state[key] for key in ('negative','pending','unresolved')):
                raise RuntimeError(f"Cover incomplete for orders {low}, {high} and shell {shell}")
            rows.append(dict(orders=[str(low),str(high)],s=[str(start),str(shell+1)],
                             positive_leaves=state["positive"],tested=state["tested"]))
    return rows


if __name__ == "__main__":
    rows = certificate()
    path = ROOT/'campaign/single-rail/sharp-domain.json'
    if sys.argv[1:] == ['--build']:
        path.write_text(json.dumps(rows, indent=2)+'\n')
    elif json.loads(path.read_text()) != rows:
        raise ValueError("Sharp qubit certificate changed")
    print("Certified",len(rows),"parameter strips and",sum(r['positive_leaves'] for r in rows),"leaves.")
