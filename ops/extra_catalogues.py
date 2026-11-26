"""Import external quantum catalogues, directory routes, and the lab's recorded literature intake."""
import hashlib
import html
import io
import json
import re
import tarfile
from pathlib import Path
from urllib.parse import quote, urljoin, urlsplit
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "campaign/catalogue-index/other.json"
VIENNA = "https://oqp.iqoqi.oeaw.ac.at/"
ZOO = "https://qiqc-op.com/"
ZOO_REPO = "Naixu-Guo/quantum-open-problems"
CLAY = "https://www.claymath.org/millennium-problems/"
RULE = "https://rule30prize.org/"
DIRECTORY = "https://www.openproblems.net/"
SPINS = "https://arxiv.org/html/2504.00987v1"
INTAKE = "https://github.com/shunyaekam/Physics-Workbench/tree/research/campaign/intake"


def fetch(url):
    request = Request(url, headers={"User-Agent": "oo-research-catalogue-index/1.0"})
    with urlopen(request, timeout=20) as res:
        return res.read()


def plain(markup):
    return " ".join(html.unescape(re.sub(r"<[^>]+>", "", markup)).split())


def cells(markup, tag):
    return re.findall(r"<" + tag + r"\b[^>]*>(.*?)</" + tag + ">", markup, re.I | re.S)


def anchored(markup):
    return re.findall(r'<a\b[^>]*href="([^"]+)"[^>]*>(.*?)</a>', markup, re.I | re.S)


def dataset(name, url, scope, rows, **provenance):
    if not rows or len(rows) != len({row["id"] for row in rows}):
        raise ValueError(f"Empty or duplicate inventory for {name}")
    for row in rows:
        if not row["title"] or urlsplit(row["url"]).scheme not in {"http", "https"}:
            raise ValueError(f"Missing title or URL for {row['id']}")
        row["source"] = name
    return dict(name=name, url=url, count=len(rows), scope=scope, **provenance), rows


def vienna():
    rows = []
    digests = {}
    for section, status in (("open-quantum-problems", "open"), ("solved-quantum-problems", "solved")):
        data = fetch(VIENNA + section)
        digests[section] = hashlib.sha256(data).hexdigest()
        table, = cells(data.decode(), "tbody")
        for tr in cells(table, "tr"):
            fields = cells(tr, "td")
            code = plain(fields[0])
            (url, title), = anchored(fields[1])
            if not code.isdigit():
                raise ValueError("Unnumbered Vienna problem")
            rows.append(dict(id="vienna-" + code, title=plain(title), url=html.unescape(url),
                             status=status, kind="problem", topics=[plain(fields[-1])]))
    return dataset("IQOQI Vienna", VIENNA, "Every numbered entry in the open and solved tables. Status is the catalogue's own classification.",
                   rows, page_hashes=digests)


def zoo():
    base = "https://api.github.com/repos/" + ZOO_REPO
    sha = json.loads(fetch(base + "/commits/HEAD"))["sha"]
    if not re.fullmatch(r"[a-f0-9]{40}", sha):
        raise ValueError("Invalid QIQCOP revision")
    tree = json.loads(fetch(base + "/git/trees/" + sha + "?recursive=1"))
    if tree["truncated"]:
        raise ValueError("Incomplete QIQCOP repository tree")
    pattern = r"database/problems_json/(op_[a-f0-9]+)\.json"
    ids = {m[1] for entry in tree["tree"] if (m := re.fullmatch(pattern, entry["path"]))}
    archive = fetch("https://codeload.github.com/" + ZOO_REPO + "/tar.gz/" + sha)
    rows = []
    with tarfile.open(fileobj=io.BytesIO(archive), mode="r:gz") as files:
        for member in files:
            match = re.fullmatch(r"[^/]+/" + pattern, member.name)
            if not match:
                continue
            record = json.load(files.extractfile(member))
            if record["id"] != match[1]:
                raise ValueError("QIQCOP record ID does not match its filename")
            rows.append(dict(id="qiqc-" + match[1], title=record["title"], url=ZOO+"problem/"+match[1]+"/",
                             kind="problem", status=record["status"].lower(), topics=record["fields"]+record["topics"]))
    if {r["id"].removeprefix("qiqc-") for r in rows} != ids:
        raise ValueError("QIQCOP archive differs from first-party tree inventory")
    return dataset("QIQCOP Zoo", ZOO,
                   "Every current database/problems_json record in the maintainer repository, including solved questions. Merged aliases have no separate row.",
                   sorted(rows, key=lambda r: r["id"]), revision=sha, expected=len(ids),
                   repository="https://github.com/"+ZOO_REPO+"/tree/"+sha+"/database/problems_json")


def clay():
    data = fetch(CLAY)
    parts = re.split(r"<h2>(Active problems|Unsolved problems|Solved problems)</h2>", data.decode(), flags=re.I)
    rows = []
    for group, section in zip(parts[1::2], parts[2::2]):
        for match in re.finditer(r'<a class="tile\s*" href="([^"]+)"[^>]*>.*?<h3>(.*?)</h3>', section, re.S):
            url, title = match.groups()
            slug = urlsplit(url).path.rstrip("/").split("/")[-1]
            rows.append(dict(id="clay-"+slug, title=plain(title), url=url, kind="problem",
                             topics=["mathematical physics"] if slug.startswith(("yang-mills", "navier-stokes")) else ["mathematics"],
                             status=group.lower().split()[0]))
    if len(rows) != 7:
        raise ValueError("Incomplete seven-problem Clay list")
    return dataset("Clay Millennium Prize Problems", CLAY,
                   "All seven historical prize problems. The source distinguishes active, unsolved, and solved. The collection includes pure mathematics.",
                   rows, expected=7, sha256=hashlib.sha256(data).hexdigest())


def rule30():
    data = fetch(RULE)
    rows = []
    for code, title in re.findall(r'<h2 id="problem(\d+)">\s*<span>Problem \d+</span><br>\s*(.*?)</h2>', data.decode(), re.S):
        rows.append(dict(id="rule30-"+code, title=plain(title), url=RULE+"#problem"+code,
                         kind="problem", status="sponsor-listed", topics=["cellular automata"]))
    if {r["id"] for r in rows} != {"rule30-1", "rule30-2", "rule30-3"}:
        raise ValueError("Rule 30 sponsor list changed")
    return dataset("Wolfram Rule 30 Prizes", RULE,
                   "All three sponsor statements. This cellular-automaton collection is archived in the lab's physics intake.",
                   rows, expected=3, sha256=hashlib.sha256(data).hexdigest())


# Searchable descriptions for legacy lines without a source-provided title.
PROMPT_TITLES = {
    "problem of continuous approaches": "Diffeomorphism-invariant parameters for continuous quantum gravity",
    "problem of infinity of vacua": "Infinitely many possible vacua",
    "are all the": "Calculability of dimensionless physical parameters",
    "how can quantum gravity": "Quantum gravity and the origin of the universe",
    "what is the lifetime": "Proton lifetime",
    "is nature supersymmetric": "Supersymmetry and its breaking",
    "why does the universe appear": "Why spacetime has three space dimensions and one time dimension",
    "why does the cosmological": "Magnitude and constancy of the cosmological constant",
    "what are the fundamental degrees": "Fundamental degrees of freedom of M-theory",
    "what is the resolution": "Black hole information paradox",
    "what physics explains": "Hierarchy between gravitational and elementary particle mass scales",
    "can we quantitatively": "Quark and gluon confinement and the QCD mass gap",
    "problems: construct": "Quantum gravity from noncommutative geometry",
    "problem: show": "Recovery of smooth classical spacetime",
    "problem: cannot": "Recovery of general relativity at large scales",
    "unnaturalness problem:": "Naturalness of Higgs and electroweak masses",
    "flavour problem:": "Number of fermion generations and their masses",
    "hierarchy problem:": "Energy scales and possible unification of fundamental forces",
}


def directory():
    data = fetch(DIRECTORY)
    table, = cells(data.decode(), "table")
    rows = {}
    section = "General"
    named_sections = {"GENERAL", "MATHEMATICS (PHYSICIST'S PERSPECTIVE)", "PHYSICS", "COSMOLOGY AND ASTROPHYSICS",
                      "QUANTUM GRAVITY", "CONDENSED MATTER", "PARTICLE PHYSICS", "COMPLEX AND CHAOTIC SYSTEMS",
                      "PARADOXES", "PHYSICS OF FINANCE", "UNSOLVED PROBLEMS IN BIOLOGY",
                      "SEVENTY OPEN QUESTIONS IN ARCHEOLOGY", "NINE UNDECIPHERED LANGUAGES"}
    for cell in cells(table, "td"):
        label = plain(cell)
        if label in named_sections:
            section = label
        for raw_url, body in anchored(cell):
            url = urljoin(DIRECTORY, html.unescape(raw_url).strip())
            if urlsplit(url).scheme not in {"http", "https"}:
                raise ValueError("Unsupported directory link scheme")
            title = plain(body)
            if title:
                key = hashlib.sha256(url.encode()).hexdigest()[:20]
                rows.setdefault(url, dict(id="opnet-"+key, title=title, url=url, kind="resource",
                                         status="directory link", topics=[section.title()]))
        # Catch the actual enumerated physics prompts that have no dedicated URL.
        # Heading-like prose and bibliographic references cannot establish an open question.
        if section not in {"PHYSICS", "QUANTUM GRAVITY", "COSMOLOGY AND ASTROPHYSICS", "CONDENSED MATTER",
                           "PARTICLE PHYSICS", "COMPLEX AND CHAOTIC SYSTEMS", "PARADOXES"}:
            continue
        for segment in re.split(r"<br\s*/?>", cell, flags=re.I):
            title = plain(segment)
            if anchored(segment) or not ("?" in title or re.search(r"\bproblems?(?: of |\s*:)", title, re.I)):
                continue
            excerpt = " ".join(title.split()[:10])
            url = DIRECTORY+"#:~:text="+quote(excerpt, safe="")
            key = hashlib.sha256(title.encode()).hexdigest()[:20]
            display = next((value for prefix, value in PROMPT_TITLES.items() if title.lower().startswith(prefix)), title)
            rows[key] = dict(id="opnet-text-"+key, title=display,
                             url=url, kind="lead", status="historical directory prompt", topics=[section.title()])
    return dataset("OpenProblems.net", DIRECTORY,
                   "Distinct labelled outbound URLs in the home-page table, plus unlinked physics-section lines with question marks or explicit problem labels. Historical links may have expired. Other narrative and nested websites have no question-level denominator.",
                   list(rows.values()), sha256=hashlib.sha256(data).hexdigest())


def spins():
    data = fetch(SPINS)
    marker = 'id="S4.T2"'
    table = data.decode().split(marker)[1].split("</table>")[0]
    rows = []
    n = None
    for tr in cells(table, "tr"):
        values = [plain(td) for td in cells(tr, "td")]
        if len(values) in (1,2) or values[0] == "N":
            continue
        if len(values) != 7 or not re.fullmatch("[0-9A-F]+", values[5]):
            raise ValueError("Unrecognized Zhang et al. Table 2 entry")
        n = int(values[0]) if values[0] else n
        if not n or len(values[5]) != (n+3)//4:
            raise ValueError("Spin-chain length mismatch")
        rows.append(dict(id="zhang-"+values[5].lower(), title=f"{n}-spin sequence {values[5]}", url=SPINS+"#S4.T2",
                         kind="benchmark", status="published sequence", topics=["statistical physics"]))
    return dataset("Zhang et al. spin sequences", SPINS+"#S4.T2",
                   "Each published sequence in Table 2 of arXiv:2504.00987v1. These are finite benchmark inputs.",
                   rows, sha256=hashlib.sha256(data).hexdigest())


def arxiv_intake(root=ROOT):
    seen = {}
    for batch in sorted((root/"campaign/intake").glob("*.json")):
        for card in json.loads(batch.read_text()):
            key = card["id"]
            seen[key] = dict(id="intake-"+key, title=card["title"], url=card["source"], kind="lead",
                             status=card["status"], topics=[], batch=batch.name)
    return dataset("Recorded arXiv intake", INTAKE,
                   "Every distinct lead saved by the lab's weekly arXiv query. The query samples up to six recent abstracts from three categories and matches open-question language.",
                   list(seen.values()))


def main():
    sources, rows = [], []
    for importer in (vienna, zoo, clay, rule30, directory, spins, arxiv_intake):
        source, batch = importer()
        sources.append(source)
        rows.extend(batch)
    if len({r["id"] for r in rows}) != len(rows):
        raise ValueError("Duplicate external record ID")
    OUT.parent.mkdir(exist_ok=True, parents=True)
    temp = OUT.with_suffix(".json.tmp")
    temp.write_text(json.dumps(dict(sources=sources, rows=rows), ensure_ascii=False, indent=2)+"\n")
    temp.replace(OUT)
    print({s["name"]:s["count"] for s in sources})


if __name__ == "__main__":
    main()
