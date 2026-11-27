"""Measure one research stage without publishing prompts or private CLI events."""
from contextlib import contextmanager
from datetime import datetime, timezone
from functools import lru_cache
import json
import subprocess
import time
from uuid import uuid4

from lab import write


TOKEN_FIELDS = ("input_tokens", "cached_input_tokens", "output_tokens")


def codex_usage(events, success):
    """Codex reports usage on completed turns. An interrupted final turn can be missing."""
    total = None
    complete = success
    for line in events:
        try:
            event = json.loads(line)
        except (ValueError, UnicodeDecodeError):
            complete = False
            continue
        if not isinstance(event, dict):
            complete = False
            continue
        if event.get("type") == "turn.failed":
            complete = False
        if event.get("type") != "turn.completed":
            continue
        counts = event.get("usage")
        if (not isinstance(counts, dict)
                or not all(type(counts.get(k)) is int and counts[k] >= 0 for k in TOKEN_FIELDS)
                or counts["cached_input_tokens"] > counts["input_tokens"]):
            complete = False
            continue
        if total is None:
            total = dict.fromkeys(TOKEN_FIELDS, 0)
        for key in TOKEN_FIELDS:
            total[key] += counts[key]
    return total, complete and total is not None


@lru_cache(maxsize=4)
def revision(root):
    return subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip()


@contextmanager
def measure(root, problem_id, stage, method, *, model=None, reasoning_effort=None, contract_hash=None):
    """Persist a start before the job, and atomically replace it with the terminal receipt."""
    from ops.hosted import HourlyLimit
    started = time.monotonic()
    identifier = uuid4().hex
    directory = root / "campaign/method-runs"
    directory.mkdir(parents=True, exist_ok=True)
    path = directory / (identifier + ".json")
    row = dict(schema_version=1, run_id=identifier, problem_id=problem_id, stage=stage,
               method=method, model=model, contract_hash=contract_hash, revision=revision(root),
               started_at=datetime.now(timezone.utc).isoformat(timespec="milliseconds"),
               elapsed_seconds=None, status="running", outcome=None, evidence=None,
               usage=None if model else dict.fromkeys(TOKEN_FIELDS, 0), usage_complete=model is None)
    if model:
        row.update(hosted_invoked=False, reasoning_effort=reasoning_effort)
    write(path, row)
    try:
        yield row
    except HourlyLimit:
        # A quota check is not an attempt. No hosted invocation was issued.
        path.unlink()
        raise
    except BaseException as exc:
        row["status"] = "timeout" if isinstance(exc, (TimeoutError, subprocess.TimeoutExpired)) else "failed"
        row["error_type"] = type(exc).__name__
        raise
    else:
        row["status"] = "completed"
    finally:
        if path.exists():
            row["elapsed_seconds"] = round(time.monotonic() - started, 6)
            write(path, row)
