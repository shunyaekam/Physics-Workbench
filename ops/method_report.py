"""Summarise instrumented worker runs alongside the independent public certificate register."""
from collections import defaultdict
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from lab import load, write


def git(*args):
    return subprocess.check_output(["git", *args], cwd=ROOT, text=True).strip()


def stamp(value):
    return datetime.fromisoformat(value.replace("Z", "+00:00")).timestamp()


def cost(rows):
    hosted = [r for r in rows if r.get("model")]
    known = [r for r in hosted if r.get("usage_complete") and r.get("usage")
             and all(isinstance(r["usage"].get(k),int) for k in ("input_tokens","output_tokens"))]
    amounts = [sum(r["usage"][k] for r in known) for k in ("input_tokens", "output_tokens")]
    seconds = [r["elapsed_seconds"] for r in rows if r.get("elapsed_seconds") is not None]
    clock = f"{sum(seconds):,.1f}" if seconds else "—"
    tokens = f"{amounts[0]:,} / {amounts[1]:,}" if known else "—"
    return clock, tokens, f"{len(known)}/{len(hosted)}" if hosted else "—"


def render(rows, certificates, trials):
    groups = defaultdict(list)
    for path, row in rows:
        groups[row["problem_id"]].append(row)
    lines = ["# Research methods", "",
             "Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. "
             "Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. "
             "The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.",
             "", "| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |",
             "|---|---:|---:|---:|---:|---:|"]
    for pid, group in sorted(groups.items()):
        clock,tokens,coverage = cost(group)
        failures = sum(r["status"] in ("failed","timeout") for r in group)
        lines.append(f"| {pid} | {len(group)} | {failures} | {clock} | {tokens} | {coverage} |")
    if not rows:
        lines += ["", "The first instrumented worker cycle is pending."]
    lines += ["", "## Time to certificate", "",
              "The endpoint is the first public commit containing a full target certificate. "
              "Calendar time starts at the first logged job for that target. Earlier work and costs outside the worker remain unmeasured.",
              "", "| Certified target | Observed hours to release | Job seconds before release | Input / output tokens | Token coverage |",
              "|---|---:|---:|---:|---:|"]
    for pid,(released,url) in sorted(certificates.items()):
        preceding = [r for r in groups[pid] if stamp(r["started_at"]) <= released]
        span = (released-min(stamp(r["started_at"]) for r in preceding))/3600 if preceding else None
        finished = [r for r in preceding if r.get("elapsed_seconds") is not None
                    and stamp(r["started_at"])+r["elapsed_seconds"]<=released]
        clock,tokens,coverage = cost(finished)
        elapsed = f"{span:.2f}" if span is not None else "Unmeasured"
        lines.append(f"| [{pid}]({url}) | {elapsed} | {clock} | {tokens} | {coverage} |")
    lines += ["", "## Latest attempts", "",
              "| Started (UTC) | Problem | Stage | Method | Status / outcome | Job seconds | Input / output tokens |",
              "|---|---|---|---|---|---:|---:|"]
    for path,r in sorted(rows, key=lambda item:item[1]["started_at"],reverse=True)[:40]:
        clock,tokens,_ = cost([r])
        lines.append(f"| [{r['started_at']}]({path}) | {r['problem_id']} | {r['stage']} | {r['method']} | "
                     f"{r['status']} / {r.get('outcome') or 'pending'} | {clock} | {tokens} |")
    lines += ["", "## Search policy experiments", "",
              "Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. "
              "Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. "
              "The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, "
              "and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.","",
              "| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |",
              "|---|---|---:|---:|---:|---:|"]
    for path,r in reversed(trials):
        lines.append(f"| [{r['week']}]({path}) | {r['incumbent']['tree_depth']} vs {r['challenger']['tree_depth']} | "
                     f"{r['best']['result']['cnot_count']} | {r['next_incumbent']} | {r['elapsed_seconds']:.2f} | 0 |")
    return "\n".join(lines)+"\n"


def build():
    campaign = ROOT/"campaign"
    def read(folder):
        return [(p.relative_to(campaign).as_posix(), load(p)) for p in sorted((campaign/folder).glob("*.json"))]
    ref = "origin/main"
    index = json.loads(git("show",ref+":certificates/index.json"))
    certificates = {}
    for pid, row in index.items():
        path = "certificates/"+row["file"]
        dates = git("log", "--diff-filter=A", "--format=%ct", ref, "--", path).splitlines()
        if dates:
            certificates[pid]=(int(dates[-1]), "https://github.com/shunyaekam/oo-research/blob/main/"+path)
    rows, trials = read("method-runs"), read("method-trials")
    groups = defaultdict(list)
    for _,r in rows:
        groups[r["problem_id"]].append(r)
    problems = []
    for pid, group in sorted(groups.items()):
        seconds, tokens, coverage = cost(group)
        latest = max(group, key=lambda r:r["started_at"])
        problems.append(dict(problem=pid, runs=len(group), seconds=seconds, tokens=tokens,
                             coverage=coverage, stage=latest["stage"], outcome=latest.get("outcome") or latest["status"]))
    trial = trials[-1][1] if trials else None
    peek = dict(week=trial["week"], best=trial["best"]["result"]["cnot_count"], target=trial["goal_cnot"],
                circuits=4*trial["seeds_per_split"], seconds=round(trial["elapsed_seconds"],2),
                changed=trial["next_incumbent"]!=trial["incumbent"]["tree_depth"]) if trial else None
    write(campaign/"method-summary.json",dict(problems=problems,comparison=peek))
    output = render(rows,certificates,trials)
    (campaign/"research-methods.md").write_text(output)


if __name__ == "__main__":
    build()
