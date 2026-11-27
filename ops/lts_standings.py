"""Read public standings and prepare a lease-free queue of scored physics proof targets."""
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone, timedelta
from html.parser import HTMLParser
import json
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from lab import load, write
from ops.left_to_solve import SITE, UPSTREAM, desk

FOLDER = ROOT/"campaign/left-to-solve"
HANDLE = "shunyaekam"


class Standings(HTMLParser):
    def __init__(self):
        super().__init__()
        self.rows = []
        self.cells = []
        self.cell = None

    def handle_starttag(self, tag, attrs):
        if tag == "tr":
            self.cells = []
        if tag == "td":
            self.cell = []

    def handle_data(self, data):
        if self.cell is not None:
            self.cell.append(data)

    def handle_endtag(self, tag):
        if tag == "td" and self.cell is not None:
            self.cells.append("".join(self.cell).strip())
            self.cell = None
        if tag == "tr" and len(self.cells) >= 6 and self.cells[1].startswith("@"):
            rank, owner, _, points, solved, taken = self.cells[:6]
            self.rows.append(dict(rank=int(rank), handle=owner[1:], points=int(points),
                                  solved=int(solved.split()[0]), taken=int(taken)))


def standings(page, handle=HANDLE):
    board = Standings()
    board.feed(page)
    rows = board.rows
    if [r["rank"] for r in rows] != list(range(1, len(rows)+1)) or len(rows)<20:
        raise ValueError("Incomplete leaderboard")
    if len({r["handle"] for r in rows}) != len(rows) or any(a["points"]<b["points"] for a,b in zip(rows,rows[1:])):
        raise ValueError("Inconsistent leaderboard")
    owner = next((r for r in rows if r["handle"]==handle), None)
    cutoff = rows[19]
    gap = max(0, cutoff["points"]+1-owner["points"]) if owner and owner["rank"]>20 else 0 if owner else None
    return dict(owner=owner, cutoff=cutoff, points_to_pass=gap, listed=len(rows))


def candidates(item, detail, active, solved, pending):
    parent = detail["id"]
    if detail.get("solution") or parent in solved:
        return []
    rows = []
    for r in [detail, *detail.get("steps", [])]:
        name = r["id"]
        is_step = name != parent or detail["kind"] == "step"
        kind = "step" if is_step else detail["kind"]
        if (kind not in {"step","known","warmup","open"} or not r.get("points")
                or name in solved or r.get("solved") or active.get(name) or r.get("liveAgents")
                or any(re.search(r"(?<![\w.])"+re.escape(name)+r"(?![\w.])",title,re.I) for title in pending)):
            continue
        rows.append(dict(id=name, title=item["title"] + (f" · step {r['k']}" if is_step else ""),
                         kind=kind, points=r["points"], statement=r.get("lean") or r.get("statement"),
                         source=item.get("primary_source"), parent=r.get("parent",parent), difficulty=item.get("difficulty")))
        if item.get("notebook"):
            rows[-1]["notebook"] = item["notebook"]
    return rows


def rank_candidates(rows):
    # Share the first pass among physical questions instead of exhausting dimension variants.
    tiers = {"step":0,"known":1,"warmup":2,"open":3}
    def family(row):
        return row["parent"].split(".")[0] if "." in row["parent"] else row["parent"]
    ordered = sorted(rows, key=lambda r:(tiers[r["kind"]], not bool(r.get("notebook")), r["difficulty"] or 100, -r["points"], r["id"]))
    seen = {}
    def order(row):
        key = (tiers[row["kind"]], family(row))
        position = seen.get(key,0)
        seen[key] = position+1
        return (tiers[row["kind"]],position)
    return sorted(ordered, key=order)


def recent(data, now, hours):
    delta = now-datetime.fromisoformat(data["checked_at"])
    return timedelta(0) <= delta < timedelta(hours=hours)


def refresh(force=False):
    now = datetime.now(timezone.utc)
    path = FOLDER/"standings.json"
    queue_path = FOLDER/"proof-queue.json"
    if (not force and path.exists() and queue_path.exists() and recent(load(path), now, 1)
            and recent(load(queue_path), now, 1)):
        return
    html = subprocess.check_output(["curl","-fsSL","--max-time","20",SITE+"/contributors"],text=True)
    board = standings(html)
    stamp = now.isoformat(timespec="seconds")
    write(path,dict(checked_at=stamp,source=SITE+"/contributors",**board))
    index = load(ROOT/"campaign/catalogue-index/left-to-solve.json")
    targets = [r for r in index["rows"] if r["physics"] and r["task_kind"] in {"known","warmup","open"}
               and r["status"] not in {"checked","prior resolution reported"}]
    # Reviewed statistical-physics problems can sit outside the catalogue's subject tags.
    extra = ROOT/"checks/left_to_solve/scored-targets.json"
    if extra.exists():
        targets.extend(row for row in load(extra) if row["id"] not in {r["id"] for r in targets})
    active = desk("/api/map")
    solved = set(active["solved"])
    titles = subprocess.check_output(["gh","api","--paginate",f"repos/{UPSTREAM}/pulls?state=open&per_page=100",
                                     "--jq",".[].title"],text=True,timeout=100).splitlines()
    def inspect(row):
        name = row["id"].removeprefix("lts-")
        if name in solved:
            return []
        detail = desk("/api/problems/"+name)
        if detail["id"] != name:
            raise ValueError("Desk returned a different problem")
        return candidates(row, detail, active["live"], solved, titles)
    with ThreadPoolExecutor(max_workers=3) as executor:
        groups = list(executor.map(inspect, targets))
    queue = rank_candidates([r for group in groups for r in group])
    write(queue_path, dict(checked_at=stamp,targets=queue))
    print("Standing",board["owner"],"20th",board["cutoff"]["points"],"available scored targets",len(queue))


if __name__ == "__main__":
    refresh(force=sys.argv[1:]==["--refresh"])
