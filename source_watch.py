"""Check the sponsor reference linked from a screened directory lead once a week."""
from datetime import datetime, timezone
import json
import re
from urllib.request import Request, urlopen

from lab import ROOT, load, write

REPO = "WolframInstitute/Rule30PrizeKit"
SCREENED = "5bda6abfa602abee0500700f4c2d60da44cf8ec5"


def poll():
    now = datetime.now(timezone.utc)
    folder = ROOT / "campaign/intake/source-checks"
    folder.mkdir(exist_ok=True, parents=True)
    week = now.strftime("%G-W%V")
    path = folder / f"rule30-{week}.json"
    retry = folder / f".rule30-{week}.retry"
    if path.exists() or (retry.exists() and now.timestamp() - retry.stat().st_mtime < 86400):
        return
    retry.touch()
    request = Request(f"https://api.github.com/repos/{REPO}/commits/main",
                      headers={"User-Agent":"PhysicsWorkbench-source-intake","Accept":"application/vnd.github+json"})
    try:
        with urlopen(request, timeout=12) as response:
            sha = json.load(response)["sha"]
        if not isinstance(sha, str) or not re.fullmatch("[0-9a-f]{40}", sha):
            raise ValueError("Invalid upstream revision")
    except (OSError, KeyError, ValueError, TypeError) as exc:
        print("Rule 30 source check deferred:", exc)
        return
    old = sorted(folder.glob("rule30-*.json"))
    previous = load(old[-1])["revision"] if old else SCREENED
    base = f"https://github.com/{REPO}"
    write(path, {"checked":now.date().isoformat(),"discovery_source":"https://www.openproblems.net/",
                 "revision":sha,"changed_since_previous_check":sha!=previous,
                 "review":"screened_revision" if sha==SCREENED else "requires_source_review",
                 "catalog":f"{base}/blob/{sha}/equivalents/README.md",
                 "changes_since_screening":f"{base}/compare/{SCREENED}...{sha}"})
    print("Recorded Rule 30 sponsor revision", sha[:12])


if __name__ == "__main__":
    poll()
