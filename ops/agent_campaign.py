"""Advance one hosted proposal or adversarial review for an admitted target."""
from datetime import datetime, timezone
import fcntl
import json
import math
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from lab import ROOT, digest, load, write
from ops.hosted import generate, HourlyLimit, MODEL

OUT = ROOT / "campaign/agent-lanes"
VERSION = 2
PROPOSE = ("target_implication", "proposed_object", "derivation", "decisive_check")
REVIEW = ("scope_mismatch", "counterexample_attempt", "weakest_step", "replay_needed")
# The two ongoing campaigns have different evidence and success conditions.
# A changed argument or a new enrolled target produces a new packet.
EVIDENCE = {
    "gagatsos-2026-c1": "discovery/cubic-strength.md",
    "refined-bmv": "discovery/sources/next-intake.md",
    "werner-endpoint": "checks/referee-audit.md",
    "e27-schmidt": "checks/schmidt7/pair_extension.md",
}


def packet(card):
    evidence_path = EVIDENCE.get(card["id"])
    evidence = (ROOT/evidence_path).read_text() if evidence_path else ""
    return dict(question=card["question"], source=card["source"], locator=card["locator"],
                experiment=card["experiment"], known=card["known"], scope=card["full_vs_partial"],
                evidence_path=evidence_path, evidence_excerpt=evidence[:3200],
                evidence_sha=digest(evidence))


def evaluate_state(state):
    from three_level_search import quantities
    if not isinstance(state, dict) or set(state) != {"components"}:
        raise ValueError("Expected an object with a components array")
    terms = state["components"]
    if not isinstance(terms, list) or not 3 <= len(terms) <= 8:
        raise ValueError("Expected 3 to 8 nonzero Fock components")
    occupied = {}
    for term in terms:
        if not isinstance(term, dict) or set(term) != {"level", "real", "imag"}:
            raise ValueError("Each component requires level, real and imag")
        n, a, b = (term[k] for k in ("level", "real", "imag"))
        if any(type(x) is not int for x in (n,a,b)) or not 0 <= n <= 24:
            raise ValueError("Levels must be integers from 0 to 24 and amplitudes must be integers")
        if max(abs(a),abs(b)) > 32 or (a,b) == (0,0) or n in occupied:
            raise ValueError("Repeated level, zero amplitude or amplitude outside [-32,32]")
        occupied[n] = complex(a,b)
    levels = tuple(sorted(occupied))
    coefficients = [occupied[n] for n in levels]
    checks = []
    for radial, angular in ((256,192),(512,384)):
        w, h = quantities(levels,coefficients,radial,angular)
        if not (math.isfinite(w) and math.isfinite(h) and h > 0):
            raise ArithmeticError("Nonfinite optical quadrature")
        checks.append(dict(radial=radial,angular=angular,wigner_norm=w,husimi_bound=h,residual=w-h))
    return checks


def witness_attempt(rec):
    integer = {"type":"integer","minimum":-32,"maximum":32}
    term = {"type":"object","required":["level","real","imag"],"additionalProperties":False,
            "properties":{"level":{"type":"integer","minimum":0,"maximum":24},"real":integer,"imag":integer}}
    schema = {"type":"object","required":["components"],"additionalProperties":False,
              "properties":{"components":{"type":"array","minItems":3,"maxItems":8,"items":term}}}
    prompt = ("Choose ONE explicit pure optical state to try to refute the target after reading the "
              "solver and critic. You choose 3 to 8 DIFFERENT photon numbers from 0 through 24. "
              "For each output level, give the real and imaginary INTEGER parts of its Fock amplitude, "
              "each in [-32,32]. At least one part must be nonzero at every occupied level. "
              "A checker will normalize the vector and compute the residual. Return only the state.\n" +
              json.dumps(dict(target=rec["context"]["question"],solver=rec["proposal"]["text"],
                              critic=rec["critique"]["text"])))
    state = generate(prompt, schema)
    attempt = dict(prompt=prompt,raw=json.dumps(state),checker_hash=digest((ROOT/"three_level_search.py").read_text()))
    try:
        attempt["state"] = state
        checks = evaluate_state(attempt["state"])
    except ValueError as exc:
        attempt.update(status="witness_rejected",reason=str(exc))
    else:
        attempt["checks"] = checks
        attempt["status"] = ("needs_rigorous_enclosure" if any(r["residual"] > 0 for r in checks)
                             else "witness_screened")
    return attempt


def response(prompt, fields):
    schema = {"type":"object", "properties":{k:{"type":"string"} for k in fields},
              "required":list(fields), "additionalProperties":False}
    data = generate(prompt, schema)
    if not isinstance(data, dict) or set(data) != set(fields) or not all(
            isinstance(v, str) and v.strip() for v in data.values()):
        raise ValueError("Incomplete hosted research response")
    return {"prompt":prompt, "text":data}


def advance():
    cards = load(ROOT/"discovery/targets.json")
    closed={entry["problem_id"] for entry in load(ROOT/"discovery/pipeline-results.json").get("solutions",[])}
    for card in cards:
        if card["id"] in closed:
            continue
        context = packet(card)
        key = digest([VERSION, context, MODEL])
        path = OUT/(card["id"]+"-"+key[:16]+".json")
        rec = load(path) if path.exists() else dict(
            problem_id=card["id"], source=card["source"], input_hash=key, context=context,
            model=MODEL, provider="OpenAI via signed-in Codex", status="proposal_pending")
        if "witness_attempt" in rec or (rec["status"] == "needs_math_review" and card["id"] != "gagatsos-2026-c1"):
            continue
        if rec.get("failed_at"):
            elapsed = datetime.now(timezone.utc) - datetime.fromisoformat(rec["failed_at"])
            if elapsed.total_seconds() < 3600:
                continue
        try:
            if rec["status"] == "proposal_pending":
                prompt = ("You are the solver. Use only the supplied facts. Suggest one precise "
                          "falsifiable witness or lemma for the ORIGINAL question. Identify its "
                          "logical scope and a reproducible failure test. Never assume execution.\n"
                          + json.dumps(context))
                rec["proposal"] = response(prompt, PROPOSE)
                rec["status"] = "critique_pending"
            elif rec["status"] == "critique_pending":
                prompt = ("You are a skeptical mathematical reviewer in a fresh context. Test this "
                          "untrusted proposal against the original question. Work out a special case, "
                          "check quantifiers and name the first unsupported step. Report what must "
                          "be verified by an exact checker. You cannot execute or browse.\n"
                          + json.dumps([context, rec["proposal"]["text"]]))
                rec["critique"] = response(prompt, REVIEW)
                rec["status"] = "needs_math_review"
            elif rec["status"] == "needs_math_review" and card["id"] == "gagatsos-2026-c1":
                rec["witness_attempt"] = witness_attempt(rec)
                rec["status"] = rec["witness_attempt"]["status"]
            else:
                raise ValueError("Unexpected lane status: "+str(rec["status"]))
            rec.pop("failed_at", None)
            rec.pop("error", None)
        except HourlyLimit as exc:
            print(exc, flush=True)
            return
        except (ValueError, RuntimeError, OSError) as exc:
            rec["error"] = str(exc)
            rec["failed_at"] = datetime.now(timezone.utc).isoformat()
        rec["updated_at"] = datetime.now(timezone.utc).isoformat()
        write(path, rec)
        print(card["id"], rec["status"], rec.get("error", ""), flush=True)
        return
    print("No new agent packet due.")


if __name__ == "__main__":
    OUT.mkdir(parents=True, exist_ok=True)
    with (OUT/".lock-campaign").open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        advance()
