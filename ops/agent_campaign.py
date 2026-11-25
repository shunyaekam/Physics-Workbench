"""Advance one local proposal or adversarial review for an admitted target."""
from datetime import datetime, timezone
import fcntl
import json
from pathlib import Path
import sys
from urllib.error import URLError

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from lab import ROOT, digest, load, ollama, write
from research import response

OUT = ROOT / "campaign/agent-lanes"
MODEL = "llama3.2:3b"
VERSION = 1
PROPOSE = ("target_implication", "proposed_object", "derivation", "decisive_check")
REVIEW = ("scope_mismatch", "counterexample_attempt", "weakest_step", "replay_needed")
# The two ongoing campaigns have different evidence and success conditions.
# A changed argument or a new enrolled target produces a new packet.
EVIDENCE = {
    "gagatsos-2026-c1": "discovery/cubic-strength.md",
    "werner-endpoint": "checks/referee-audit.md",
}


def packet(card):
    evidence_path = EVIDENCE.get(card["id"])
    evidence = (ROOT/evidence_path).read_text() if evidence_path else ""
    return dict(question=card["question"], source=card["source"], locator=card["locator"],
                experiment=card["experiment"], known=card["known"], scope=card["full_vs_partial"],
                evidence_path=evidence_path, evidence_excerpt=evidence[:3200],
                evidence_sha=digest(evidence))


def advance():
    cards = load(ROOT/"discovery/targets.json")
    installed = {m["name"]:m["digest"] for m in ollama("tags")["models"]}
    if MODEL not in installed:
        print("Proposal and critic waiting for installed model", MODEL)
        return
    for card in cards:
        context = packet(card)
        key = digest([VERSION, context, MODEL, installed[MODEL]])
        path = OUT/(card["id"]+"-"+key[:16]+".json")
        rec = load(path) if path.exists() else dict(
            problem_id=card["id"], source=card["source"], input_hash=key, context=context,
            model=MODEL, model_digest=installed[MODEL], status="proposal_pending")
        if rec["status"] == "needs_math_review":
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
                rec["proposal"] = response(MODEL, prompt, PROPOSE, 37)
                rec["status"] = "critique_pending"
            elif rec["status"] == "critique_pending":
                prompt = ("You are a skeptical mathematical reviewer in a fresh context. Test this "
                          "untrusted proposal against the original question. Work out a special case, "
                          "check quantifiers and name the first unsupported step. Report what must "
                          "be verified by an exact checker. You cannot execute or browse.\n"
                          + json.dumps([context, rec["proposal"]["text"]]))
                rec["critique"] = response(MODEL, prompt, REVIEW, 83)
                rec["status"] = "needs_math_review"
            else:
                raise ValueError("Unexpected lane status: "+str(rec["status"]))
            rec.pop("failed_at", None)
            rec.pop("error", None)
        except (ValueError, RuntimeError, URLError, TimeoutError) as exc:
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
        try:
            advance()
        except (URLError, TimeoutError) as exc:
            print("Local model unavailable; the next cycle retries:", exc)
