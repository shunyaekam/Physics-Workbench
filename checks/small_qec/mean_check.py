"""Replay the conditional minimum total check weight for [[12,4,4]], issue 24."""
import json
from pathlib import Path
from dual import upper_bounds, FOUR_LOGICAL
from fractions import Fraction
from verify import verify


def replay():
    # Replay the coefficient identities and every multiplier sign.
    mixed_limit = int(upper_bounds(4)["128"])
    penalties = {int(key[1:]): -Fraction(value) for key, value in FOUR_LOGICAL[1][2].items()
                 if key.startswith("A") and key != "A0"}
    # One word at weight j<=6 costs 1+penalty units of the dual budget.
    # This dominates the 7-j incidence saving of that word in any basis.
    for j in range(1, 7):
        if 1 + penalties.get(j, 0) < 7-j:
            raise ValueError("Dual does not bound the basis saving")
    # An all-even group with cap seven has only basis words <=6.
    if int(upper_bounds(4)["256"]) >= 8:
        raise ValueError("All-even case was not excluded")
    rows = json.loads(Path(__file__).with_name("twelve-four.json").read_text())["generators"]
    verified = verify(dict(n=12,k=4,d=4,weight=7,generators=rows))
    weights = [sum(p != "I" for p in word) for word in rows]
    lower = 8*7 - mixed_limit
    if sum(weights) != lower:
        raise ValueError("The verified construction does not attain the bound")
    return dict(lower=lower, upper=sum(weights), weights=weights,
                logicals_by_weight=verified["logicals_by_weight"])


if __name__ == "__main__":
    print(json.dumps(replay()))
