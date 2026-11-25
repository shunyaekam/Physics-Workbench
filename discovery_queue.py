"""Source-matched experimental dispatch. Numerical receipts never promote a theorem."""
from fractions import Fraction
from lab import ROOT, load
from verify import require

FIELDS = ("id","source","locator","question","significance","evidence_checked","known",
          "experiment","full_vs_partial","stop_rule","checked")


def select(number, history):
    cards = load(ROOT / "discovery/targets.json")
    for card in cards:
        require(card.get("role")=="external_problem" and all(card.get(k) for k in FIELDS),
                "Incomplete target dossier")
    required = {"werner-endpoint","gagatsos-2026-c1"}
    ids = {c["id"] for c in cards}
    require(len(cards) == len(ids) and required <= ids, "Duplicate target or missing legacy search dossier")
    scores = [tuple(sorted((r["k"], Fraction(r["score"])) for r in h["quantum"])) for h in history[-3:]]
    same_arm = all(r.get("arm")=="full-site-variation-v1" for h in history[-3:] for r in h["quantum"])
    plateau = same_arm and len(scores)==3 and all(len(s)==2 and s==scores[0] for s in scores)
    first = not any("dispatch" in h for h in history)
    wigner = first or (plateau and number%4!=0) or number%4==2
    return {"primary":"gagatsos-2026-c1" if wigner else "werner-endpoint",
            "reason":("first screened Wigner batch" if first else "three unchanged Werner incumbent pairs" if plateau else "portfolio rotation"),
            "support_benchmark_due": number%8==0}
