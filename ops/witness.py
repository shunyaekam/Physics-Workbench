"""Replay one typed research object against a frozen, source-linked contract."""
import argparse
from hashlib import sha256
import json
from pathlib import Path
import sys

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))


def fingerprint(data):
    return sha256(json.dumps(data, sort_keys=True, separators=(",",":"),allow_nan=False).encode()).hexdigest()


def contracts(root=ROOT):
    return json.loads((root/"discovery/proof-contracts.json").read_text())


def replay(problem, witness):
    if problem=="e27-schmidt":
        from checks.schmidt_orbit import check
    elif problem=="transport-polygon":
        from formal.transport_literal.attempt import check
    elif problem=="golay43":
        from checks.golay_certificate import check
    elif problem=="refined-bmv":
        from checks.bmv_certificate import check
    elif problem=="werner-endpoint":
        from checks.werner_witness import check
    elif problem=="gagatsos-2026-c1":
        from ops.agent_campaign import evaluate_state
        return dict(decisive=False, quadrature=evaluate_state(witness))
    else:
        raise ValueError("This target requires a proof of its universal statement")
    return check(witness)


if __name__=="__main__":
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("problem",choices=contracts())
    p.add_argument("witness",type=Path)
    args=p.parse_args()
    print(json.dumps(replay(args.problem,json.loads(args.witness.read_text())),indent=2))
