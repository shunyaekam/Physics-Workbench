"""Index source records and editorial archives at immutable Git revisions."""
import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tempfile
from urllib.parse import quote

ROOT = Path(__file__).resolve().parents[1]
OQP = "jpbruneton/open_quantum_problems"
JGM = "jgmcm/problems"
AIM = "MColbrook/AIM"
PATHS = {OQP: ["/app/data/", "/README.md"], JGM: ["/catalogue/"],
         AIM: ["/catalogue.json", "/CATALOG.md", "/data/"]}
AIM_PHYSICS = re.compile(
    r"physic|quantum|relativi|thermodynam|mechanic|electromagnet|electrochem|"
    r"hydrodynam|fluid|vortic|elastic|diffusion|kinetic|plasma|spin chain|ising|"
    r"wave equation|navier.stokes|schr[öo]dinger|boltzmann", re.I)


def check(ok, message):
    if not ok:
        raise ValueError(message)


def git(root, *args):
    return subprocess.check_output(["git", *args], cwd=root, text=True,
                                   stderr=subprocess.PIPE, timeout=90).strip()


def file_link(repo, sha, path, line=None):
    url = f"https://github.com/{repo}/blob/{sha}/{quote(path)}"
    return url if line is None else f"{url}#L{line}"


def js_string(block, field):
    match = re.search(r"\b" + field + r':\s*("(?:[^"\\]|\\.)*")', block)
    check(match, f"Missing {field} in {block[:90]}")
    return json.loads(match[1])


def quantum(root, sha):
    directory = root / "app/data"
    agg = (directory / "problems.js").read_text()
    categories = {slug: name for slug, name in re.findall(
        r'\{ slug: "([^"]+)", code: "[^"]+", name: "([^"]+)"', agg)}
    by_code = {code: categories[slug] for slug, code in re.findall(
        r'\{ slug: "([^"]+)", code: "([^"]+)"', agg)}
    files = sorted(directory.glob("cat-*.js"))
    imports = set(re.findall(r'from "\./(cat-[^"]+)"', agg))
    check({p.stem for p in files} == imports, "Category files differ from catalogue imports")
    rows = []
    for path in files + sorted(directory.glob("proposals*.js")):
        data = path.read_text()
        proposal = path.name.startswith("proposals")
        field = "key" if proposal else "id"
        pattern = r'^ *\{\s*' + field + r':\s*"([A-Z]+\d+)"'
        if not proposal:
            pattern += r',\s*cat:'
        starts = list(re.finditer(pattern, data, re.M))
        check(starts, f"Unrecognized source syntax in {path.name}")
        for i, match in enumerate(starts):
            block = data[match.start():starts[i + 1].start() if i + 1 < len(starts) else len(data)]
            key = match[1]
            line = data.count("\n", 0, match.start()) + 1
            permalink = file_link(OQP, sha, path.relative_to(root).as_posix(), line)
            title = js_string(block, "title")
            if proposal:
                secondary = key.startswith("S")
                topic = by_code[re.fullmatch(r'[PS]([A-Z]+)\d+', key)[1]]
                kind = "secondary lead" if secondary else "proposal"
                status = "withdrawn" if re.search(r'^ +withdrawal:', block, re.M) else "proposed"
                url = permalink if secondary else "https://openquantumproblems.com/np/" + key
            else:
                topic = categories[js_string(block, "cat")]
                archived = re.search(r'^    archive:\s*\{\s*kind:\s*"([^"]+)"', block, re.M)
                kind = "archive" if archived else "catalogue"
                # Only the object-level field belongs to this problem. Cross-references carry their own statuses.
                properties = block.splitlines()[0] + "\n" + "\n".join(re.findall(r'^    status:.*$', block, re.M))
                status = archived[1] if archived else js_string(properties, "status") if "status:" in properties else "open"
                url = "https://openquantumproblems.com/p/" + key
            row = dict(id="oqp:" + key, source_id=key, title=title, url=url, source=OQP,
                       source_url=permalink, topics=[topic], physics=True, kind=kind, status=status)
            if re.search(r'\bhorizon:\s*"', block):
                row["horizon"] = js_string(block, "horizon")
            rows.append(row)
    readme = (root / "README.md").read_text()
    total = re.search(r'\*\*(\d+) active entries\*\*', readme)
    check(total and int(total[1]) == sum(r["kind"] == "catalogue" for r in rows),
          "Active entry count differs from the upstream README")
    return rows


def physics_open(root, sha):
    files = sorted((root / "catalogue/problems").glob("*.txt"))
    ids = set()
    rows = []
    for path in files:
        text = path.read_text().strip()
        lines = [line.strip() for line in text.splitlines() if line.strip()]
        label = re.fullmatch(r"#(\d+)\s+(.+)", lines[1])
        check(label and label[1] == path.name.split("_")[0], f"Unexpected ID in {path.name}")
        key, title = label.groups()
        def after(name):
            return lines[lines.index(name) + 1]
        status = lines[0].lower()
        machine = json.loads(after("MACHINE-READABLE STATEMENT"))
        check(machine["id"] == key and machine["status"] == status, f"Conflicting metadata at {key}")
        url = file_link(JGM, sha, path.relative_to(root).as_posix())
        rows.append(dict(id="jgmcm:" + key, source_id=key, title=title, url=url, source=JGM,
                         topics=[after("AREA"), *[t.strip() for t in after("TAGS").split(";") if t.strip()]],
                         physics=True, kind="catalogue", status=status, difficulty=after("DIFFICULTY"),
                         formalizability=after("FORMALIZABILITY")))
        ids.add(key)
    manifest = root / "catalogue/MACHINE_INDEX.jsonl"
    listed = {json.loads(line)["id"] for line in manifest.read_text().splitlines() if line.strip()}
    check(ids == listed and len(ids) == len(files), "Problem pages differ from machine index")
    return rows


def aim(root, sha):
    raw = (root / "catalogue.json").read_text()
    manifest = json.loads(raw)
    rows = []
    groups = {group["key"]: group["title"] for group in manifest["groups"]}
    for key, group in groups.items():
        path = root / "data" / (key + ".json")
        for entry in json.loads(path.read_text()):
            row = dict(id="aim:" + entry["id"], source_id=entry["id"], title=entry["title"],
                       url=file_link(AIM, sha, entry["file"]), source=AIM, kind="catalogue",
                       topics=[group, entry["area"]], status=entry["status"].lower())
            rows.append(row)
    for entry in manifest["retired"]:
        rows.append(dict(id="aim:" + entry["id"], source_id=entry["id"], title=entry["title"],
                         source=AIM, url=file_link(AIM, sha, entry["record"]), kind="catalogue",
                         topics=[groups[entry["group"]], entry["area"]], status=entry["status"].lower()))
    table = (root / "CATALOG.md").read_text()
    catalogue_ids = set(re.findall(r'^\| (\d+) \| ', table, re.M))
    batch_ids = {key for batch in manifest["batches"] for key in batch["ids"]}
    check({r["source_id"] for r in rows} == catalogue_ids == batch_ids and len(rows) == len(catalogue_ids),
          "AIM problem pages, catalogue table and publication batches disagree")
    # Numbered slots can be reused after an editorial cut. Namespace historical entries by source record.
    for section in ("cut", "editorial_archive", "further_archive"):
        for entry in manifest[section]:
            title = entry["title"]
            source_id = entry.get("source_key") or entry["id"]
            marker = '"title": ' + json.dumps(title, ensure_ascii=False)
            char = raw.index(marker, raw.index('"' + section + '":'))
            permalink = file_link(AIM, sha, "catalogue.json", raw.count("\n", 0, char) + 1)
            digest = hashlib.sha256(entry["record"].encode()).hexdigest()[:12]
            rows.append(dict(id="aim:archive:" + digest, source_id=source_id, title=title, source=AIM,
                             url=permalink, topics=[t for t in (groups.get(entry.get("group")), entry.get("area")) if t],
                             kind="archive", status=entry.get("status", "archived").lower()))
    for row in rows:
        row["physics"] = bool(AIM_PHYSICS.search(" ".join([row["title"], *row["topics"]])))
    return rows


def refresh(root=ROOT, mirrors=None, revisions=None):
    """Refresh all sources together; any fetch or validation failure leaves the previous file intact.

    mirrors may point to a directory with one unmodified clone per repo basename.
    revisions maps repository names to commits, e.g. the weekly watcher's SHA values.
    """
    output = Path(root) / "campaign/catalogue-index/catalogues.json"
    with tempfile.TemporaryDirectory() as work:
        def collect(repo):
            mirror = Path(mirrors) / repo.split("/")[-1] if mirrors else None
            remote = "https://github.com/" + repo + ".git"
            sha = revisions[repo] if revisions is not None else (
                git(mirror, "rev-parse", "HEAD") if mirror else git(None, "ls-remote", remote, "HEAD").split()[0])
            check(re.fullmatch(r"[0-9a-f]{40}", sha), "Expected a pinned commit")
            directory = Path(work) / repo.split("/")[-1]
            if mirror:
                # Archive the pinned Git tree; exclude any uncommitted changes in the mirror.
                git(None, "clone", "--quiet", "--no-checkout", "--shared", str(mirror), str(directory))
                git(directory, "sparse-checkout", "set", "--no-cone", *PATHS[repo])
            else:
                git(None, "init", "--quiet", str(directory))
                git(directory, "remote", "add", "origin", remote)
                git(directory, "sparse-checkout", "set", "--no-cone", *PATHS[repo])
                git(directory, "fetch", "--quiet", "--depth=1", "--filter=blob:none", "origin", sha)
            git(directory, "checkout", "--quiet", "--detach", sha)
            rows = {OQP: quantum, JGM: physics_open, AIM: aim}[repo](directory, sha)
            check(rows and len({r["id"] for r in rows}) == len(rows), f"Duplicate or missing rows from {repo}")
            source = dict(name=repo, revision=sha, url=f"https://github.com/{repo}/tree/{sha}", count=len(rows),
                          kinds=dict(sorted(Counter(r["kind"] for r in rows).items())))
            return source, rows
        with ThreadPoolExecutor(max_workers=3) as pool:
            batches = list(pool.map(collect, PATHS))
    result = dict(schema_version=1, sources=[s for s, _ in batches],
                  rows=[r for _, records in batches for r in sorted(records, key=lambda r: r["id"])])
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode="w", dir=output.parent, delete=False, encoding="utf-8") as f:
        json.dump(result, f, ensure_ascii=False, indent=2)
        f.write("\n")
    Path(f.name).replace(output)
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mirrors", type=Path)
    args = parser.parse_args()
    for source in refresh(mirrors=args.mirrors)["sources"]:
        print(source["name"], source["revision"][:12], source["count"], source["kinds"])
