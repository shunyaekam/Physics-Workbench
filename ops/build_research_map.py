"""Publish catalogue results as ordinary subject nodes and canonical paper readers."""
from collections import defaultdict
from hashlib import sha256
from html import escape
from pathlib import Path
import importlib.util
import json
import re

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "site/left-to-solve"
SUBJECTS = {
    "Quantum optics": ("optics", "Quantum optics"),
    "Quantum information": ("foundations", "Quantum information"),
    "Statistical mechanics": ("statistical", "Statistical mechanics"),
    "Atomic physics": ("atomic", "Atomic physics"),
    "Wave physics": ("waves", "Wave physics"),
}
KIND = {"open": "Catalogue result", "known": "Formalization", "warmup": "Warm-up"}


def new_entry(row):
    ident = row["id"]
    stem = re.sub(r"[^a-z0-9]+", "-", ident.lower()).strip("-")[:72]
    slug = "lts-" + stem + "-" + sha256(ident.encode()).hexdigest()[:8]
    refuted = row["polarity"] == "disproof"
    role = ("contributed to" if row["credit"] == "contributor" else "submitted")
    action = "refutation" if refuted else "proof"
    summary = f"@shunyaekam {role} the Lean-checked {action} of this catalogue problem."
    entry = dict(id=ident, slug=slug, title=row["title"], field=row.get("field") or "Mathematics",
                summary=summary, scope=row.get("variant_note") or "", source=row["source"],
                method=KIND[row["outcome"]] + " · Lean " + action, path=f"papers/{slug}/",
                proof=row["proof"], links=[dict(label="Accepted proof", url=row["proof"])])
    if (ident == "MonochromaticQuantumGraph.eqSystem_no_solution_ge6_ge3"
            and row["proof"] == "https://github.com/GuillaumeBAUD-coder/open-math-agents/pull/2251"):
        entry.update(title="The GHZ obstruction for every even number of outputs from six onward",
                     field="Quantum optics", method="Attributed proof port · Lean",
                     summary="Rishi Rajasekaran proved the all-orders GHZ obstruction. We adapted his proof to the benchmark’s exact complex-weight graph definitions.",
                     scope="The theorem concerns exact preparation in the pair-source perfect-matching model.")
        entry["links"].extend([
            dict(label="Rajasekaran’s original formalization",url="https://github.com/google-deepmind/formal-conjectures/pull/6627"),
            dict(label="Independent pinned replay",url="https://github.com/shunyaekam/oo-research/actions/runs/45933802254")])
    entry["statement"] = row.get("statement") or ""
    if row.get("primary_source"):
        entry["links"].append(dict(label="Original source",url=row["primary_source"]))
    if row.get("model") or row.get("agent"):
        entry["credit"] = row.get("model") or row["agent"]
    return entry


def merge_entries(curated, accepted):
    entries = {entry["id"]:dict(entry) for entry in curated}
    if len(entries) != len(curated):
        raise ValueError("Duplicate curated entry")
    for row in accepted:
        entry = entries.get(row["id"])
        if entry is None:
            entry = new_entry(row)
            entries[row["id"]] = entry
        entry["accepted"] = row
    if len({entry["slug"] for entry in entries.values()}) != len(entries):
        raise ValueError("A reader slug is used twice")
    return list(entries.values())


def replace_block(page, name, content):
    start, end = f"<!-- {name}:start -->", f"<!-- {name}:end -->"
    if page.count(start) != 1 or page.count(end) != 1:
        raise ValueError("Missing or duplicate map section: " + name)
    return page[:page.index(start)+len(start)]+"\n"+content+"\n"+page[page.index(end):]


def update_map(page, entries):
    groups = defaultdict(list)
    notes = []
    for entry in entries:
        key, field = SUBJECTS.get(entry["field"], (None, entry["field"]))
        if key is None:
            key = "subject-" + re.sub(r"[^a-z0-9]+", "-", field.lower()).strip("-") + "-" + sha256(field.encode()).hexdigest()[:5]
        slug = entry["slug"]
        if not re.fullmatch("[a-z0-9-]+",slug):
            raise ValueError("Invalid paper slug")
        title, summary, scope, method, area = (escape(entry.get(k, "")) for k in ("title","summary","scope","method","field"))
        path = "papers/" + slug + "/"
        groups[(key,field)].append(f'<li class="paper" id="{slug}"><a class="read" href="{path}">{title}</a><a class="evidence" href="#note/{slug}" aria-label="Evidence for {title}" title="Evidence">ⓘ</a></li>')
        proof = entry.get("accepted")
        credit = ''
        if proof:
            credit = f' <a href="{escape(proof.get("certificate") or proof["proof"],quote=True)}">Upstream {escape(proof["polarity"])} and credit</a>'
        notes.append(f'<article data-paper="{slug}" data-area="{area}" data-method="{method}"><h3><a href="{path}">{title}</a></h3><p>{summary}</p><details><summary>Verification</summary><p>{scope or method}</p><a href="{escape(entry["source"],quote=True)}">Catalogue problem</a>{credit}</details></article>')
    new_subjects = []
    for (key, field), rows in groups.items():
        if key == "optics":
            page = replace_block(page,"synced optics","\n".join(rows))
            continue
        name = escape(field)
        new_subjects.append(f'<section class="field" data-field="{key}" data-questions="" aria-label="{name}"><h2><span class="junction" aria-hidden="true"></span>{name}</h2><ul>\n' + "\n".join(rows) + '\n<li class="feed-branch" hidden><a></a></li></ul></section>')
    page = replace_block(page, "synced subjects", "\n".join(new_subjects))
    page = replace_block(page, "synced papers", "\n".join(notes))
    return re.sub(r'(<p id="inventory">)\d+ papers', lambda m:m[1]+str(page.count('<li class="paper"'))+" papers", page)


def main():
    curated = json.loads((ASSETS/"entries.json").read_text())
    accepted = json.loads((ASSETS/"accepted.json").read_text())["solutions"]
    entries = merge_entries(curated, accepted)
    spec = importlib.util.spec_from_file_location("research_reader", ASSETS/"build.py")
    renderer = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(renderer)
    for entry in entries:
        slug = entry["slug"]
        if not re.fullmatch("[a-z0-9-]+",slug):
            raise ValueError("Invalid paper slug")
        dest = ROOT/"papers"/slug/"index.html"
        if dest.exists() and 'name="oo-research-catalogue-id"' not in dest.read_text() and slug not in {r["slug"] for r in curated}:
            raise ValueError("Refusing to replace existing paper: " + slug)
        dest.parent.mkdir(exist_ok=True)
        page = renderer.render_entry(entry, root=ROOT)
        if 'name="oo-research-catalogue-id"' not in page:
            page = page.replace("</head>",f'<meta name="oo-research-catalogue-id" content="{escape(entry["id"],quote=True)}"></head>')
        dest.write_text(page)
    catalogue = ROOT/"catalogue.html"
    catalogue.write_text(update_map(catalogue.read_text(),entries))
    print("Published", len(entries), "catalogue readers")


if __name__ == "__main__":
    main()
