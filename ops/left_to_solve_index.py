"""Index physical subjects from a pinned Left to Solve checkout, for literature scouting."""
import gzip
import json
from pathlib import Path
import re
import subprocess
from tempfile import TemporaryDirectory

ROOT = Path(__file__).resolve().parents[1]
UPSTREAM = "https://github.com/GuillaumeBAUD-coder/open-math-agents"
PRIOR_RESULTS = {"oeis-a348567": "https://github.com/guillochon/oeis-results/tree/main/A348567"}
FIELDS = {"Quantum Theory", "Mechanics", "Optics"}
SUBJECT = re.compile(r"\b(?:quantum|spin chain|sandpiles?|Ising|superconduct\w*|thermodynamic\w*|"
                     r"Schr[oö]dinger|Boltzmann|Navier.Stokes|Rydberg|hydrogen spectrum|entanglement|"
                     r"self.avoiding (?:walks?|paths?|polygons?|(?:closed |open )?loops?)|prudent walks?|percolation|statistical mechanics|harmonic oscillator|"
                     r"Bose.Einstein|photons?|black holes?|electrostatics|Riemannian Penrose)\b", re.I)


def index(checkout):
    data = checkout / "data"
    def read(name):
        return json.loads((data / name).read_bytes())
    core = read("catalog.json")["problems"] + read("extra.json")["problems"]
    extra = read("extra2.json")
    for id_, title, source, fields, _, ref, _, _, difficulty, *_ in extra["rows"]:
        core.append(dict(id=id_, title=title, source=extra["sources"][source], fields=fields,
                         ref=ref, difficulty=difficulty, kind="unformalized"))
    with gzip.open(data / "extra3.json.gz", "rt") as archive:
        for number, title, fields, *_ in json.load(archive)["rows"]:
            core.append(dict(id=f"mo-{number}", title=title, source="MathOverflow", fields=fields,
                             ref=f"https://mathoverflow.net/questions/{number}", kind="unformalized"))
    overrides = {r["id"]:r["status"] for r in read("status_overrides.json")["entries"]}
    active = {r["problem"] for r in json.loads((ROOT/"checks/left_to_solve/targets.json").read_text())}
    active_candidates = {r["problem"] for r in json.loads((ROOT/"checks/left_to_solve/frontier.json").read_text())}
    rows = {}
    for item in core:
        key = item["id"]
        if key in rows or not (FIELDS.intersection(item["fields"]) or SUBJECT.search(item["title"]) or key in active or key in active_candidates):
            continue
        kind = item["kind"]
        if kind == "unformalized" and (checkout/"statements"/(key+".lean")).is_file():
            kind = "open"
        status = overrides.get(key, "active")
        if (checkout/"proofs"/(key+".lean")).is_file():
            status = "checked"
        elif key in active and status == "active":
            status = "tracked"
        rows[key] = dict(id="lts-"+key, title=item["title"], url="https://lefttosolve.com/p/"+key,
                         primary_source=item.get("ref"), origin=item["source"], source="Left to Solve",
                         kind="problem", task_kind=kind, topics=item["fields"], status=status,
                         physics=True, difficulty=item.get("difficulty"))
        if key in PRIOR_RESULTS:
            rows[key]["status"] = "prior resolution reported"
            rows[key]["prior_source"] = PRIOR_RESULTS[key]
    revision = subprocess.check_output(["git","rev-parse","HEAD"],cwd=checkout,text=True).strip()
    result = dict(schema_version=1, sources=[dict(name="Left to Solve", url=UPSTREAM+"/tree/"+revision,
                  revision=revision, count=len(rows), scope="Quantum Theory, Mechanics or Optics field, "
                  "or physics terms in the title, plus enrolled targets and reviewed candidates. Catalogue leads require primary-source review.")],
                  rows=sorted(rows.values(), key=lambda r:(r["difficulty"] is None,r["difficulty"] or 0,r["id"])))
    dest = ROOT/"campaign/catalogue-index/left-to-solve.json"
    temp = dest.with_suffix(".tmp")
    temp.write_text(json.dumps(result,ensure_ascii=False,separators=(",",":"))+"\n")
    temp.replace(dest)
    print(len(rows), "physics leads", revision)


if __name__ == "__main__":
    with TemporaryDirectory() as folder:
        checkout = Path(folder)/"source"
        subprocess.run(["git","clone","--quiet","--depth=1",UPSTREAM+".git",str(checkout)],check=True,timeout=90)
        index(checkout)
