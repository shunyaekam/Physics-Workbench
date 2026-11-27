"""Render the catalogue's paper readers. Curated Markdown uses the lab's Pandoc 3 toolchain."""
import argparse
import hashlib
import html
import json
import re
import shutil
import subprocess
from pathlib import Path
from urllib.parse import urljoin, urlsplit

ROOT = Path(__file__).resolve().parents[2]
PROFILE = "https://lefttosolve.com/a/shunyaekam"
PROJECT = "https://shunyaekam.github.io/oo-research/"
esc = html.escape


def href(value):
    if not isinstance(value, str) or urlsplit(value).scheme not in {"http", "https"}:
        return ""
    return esc(value, quote=True)


def link(label, url):
    return f'<a href="{href(url)}">{esc(label)}</a>' if href(url) else ""


def note_html(entry, root, pandoc):
    if not entry.get("note"):
        return ""
    note = (root / entry["note"]).resolve()
    if not note.is_relative_to(root.resolve()):
        raise ValueError("Note must be inside the repository")
    text = note.read_text()
    # The generated HTML doubles as a content-addressed cache for upstream review updates.
    digest = hashlib.sha256((entry["note"] + "\n" + text).encode()).hexdigest()
    marker = f"<!--begin-note {digest}-->"
    end = "<!--end-note-->"
    old = root / "papers" / entry["slug"] / "index.html"
    if old.is_file():
        page = old.read_text()
        if marker in page and end in page.split(marker, 1)[1]:
            return marker + page.split(marker, 1)[1].split(end, 1)[0] + end
    program = pandoc or shutil.which("pandoc")
    if not program:
        raise RuntimeError("Pass --pandoc or install Pandoc 3 to render revised Markdown.")
    text = re.sub(r"\A#{1,2} [^\n]+\n+", "", text)
    compiled = subprocess.run([str(program), "-f", "markdown", "-t", "html5", "--mathml",
                               "--wrap=none"], text=True, input=text, capture_output=True, check=True).stdout
    base = PROJECT + str(note.relative_to(root.resolve()).parent) + "/"
    def resolve(match):
        target = html.unescape(match.group(1))
        if target.startswith("#") or urlsplit(target).scheme:
            return match.group(0)
        # Relative references are relative to the original Markdown file.
        resolved = urljoin(base, target)
        if resolved.startswith(PROJECT):
            resolved = "../../" + resolved[len(PROJECT):]
        return f'href="{esc(resolved)}"'
    return marker + re.sub(r'href="([^"]*)"', resolve, compiled) + end


def render_entry(entry, root=ROOT, pandoc=None):
    root = Path(root)
    slug = entry["slug"]
    if not re.fullmatch(r"[a-z0-9][a-z0-9-]*", slug):
        raise ValueError(f"Invalid paper slug {slug!r}")
    title, summary = entry["title"], entry["summary"]
    accepted = entry.get("accepted") or {}
    source = entry.get("source") or accepted.get("source")
    evidence = list(entry.get("links") or [])
    for label, url in (("Source", source), ("Proof", entry.get("proof")), ("Accepted proof", accepted.get("proof")), ("Contributor certificate", accepted.get("certificate"))):
        if href(url) and not any(item["url"] == url for item in evidence):
            evidence.append({"label": label, "url": url})
    evidence_html = " ".join(link(row["label"], row["url"]) for row in evidence)
    review_html = []
    for review in entry.get("reviews", []):
        url = review["url"]
        number = re.fullmatch(r"https://github.com/GuillaumeBAUD-coder/open-math-agents/pull/(\d+)", url)
        bits = f' data-review="{number[1]}" data-kind="{esc(review["kind"])}" data-head="{esc(review["head"])}"' if number else ""
        review_html.append(f'<p{bits}>{link(review["label"],url)} <span>{esc(review["status"])}</span></p>')
    accepted_html = ""
    if accepted:
        fields = [str(accepted[k]) for k in ("outcome", "polarity", "accepted_at") if accepted.get(k)]
        accepted_html = "<p>Upstream acceptance" + (" · " + esc(" · ".join(fields)) if fields else "") + ".</p>"
        if accepted.get("credit"):
            accepted_html += "<p>Upstream proof credit · " + "@shunyaekam (" + esc(str(accepted["credit"])) + ")" + "</p>"
        if accepted.get("source") and accepted["source"] != source:
            evidence_html += " " + link("Acceptance record", accepted["source"])
    model = entry.get("credit")
    byline = f'<div><strong>{esc(str(model))}</strong> <span>{("AI research and verification" if entry.get("credit") else "Upstream proof credit")}</span></div>' if model else ""
    if entry.get("director"):
        byline += '<small>Project initiated and directed by <a href="https://www.researchgate.net/profile/Aryan-Singh-101">' + esc(entry["director"]) + '</a> · oo research</small>'
    pdf = root / "papers" / (slug + ".pdf")
    pdf_link = f'<a href="../{slug}.pdf">PDF ↗</a>' if pdf.is_file() else ""
    pdf_meta = f'<meta name="citation_pdf_url" content="{PROJECT}papers/{slug}.pdf">' if pdf.is_file() else ""
    # Embed only the data needed for this paper's instrument.
    widget = json.dumps({k:entry[k] for k in ("headline","summary","scope","frames") if k in entry},ensure_ascii=False).replace("<", "\\u003c")
    full_note = note_html(entry,root,pandoc)
    if not full_note:
        statement = entry.get("statement")
        excerpt = f'<h2>Catalogue statement</h2><p>{esc(statement)}</p>' if statement else ""
        full_note = f'<p>{esc(summary)}</p>' + excerpt
    scope = entry.get("scope", "")
    method = entry.get("method","")
    records = "".join(review_html) + accepted_html
    return f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>{esc(title)} · oo research</title><meta name="citation_title" content="{esc(title)}"><meta name="oo-research-catalogue-id" content="{esc(entry['id'])}"><meta name="description" content="{esc(summary)}">{pdf_meta}
<link rel="canonical" href="{PROJECT}papers/{slug}/"><link rel="icon" href="../../site/assets/oo-mark.png">
<link rel="stylesheet" href="../../site/flowly.css"><link rel="stylesheet" href="../../site/reader/paper.css"><link rel="stylesheet" href="../../site/navigation.css"><link rel="stylesheet" href="../../site/left-to-solve/paper.css">
<script defer src="../../site/navigation.js"></script><script defer src="../../site/flowly.js"></script><script type="module" src="../../site/reader/explore.mjs"></script></head>
<body data-paper="{slug}" data-contribution="{esc(entry['id'])}" data-followup="{esc(entry.get('followup',''))}"{(' data-article-only' if not entry.get("frames") else '')}>
<header class="reader-head lab-header"><a class="lab-mark" href="../../" aria-label="oo research home"><img src="../../site/assets/torus.png" width="42" height="42" alt=""></a><nav aria-label="Paper navigation"><a href="../../catalogue.html">Research map</a><a id="view-link" href="#full-text" hidden>Full text</a>{pdf_link}</nav></header>
<main><section id="explore" aria-labelledby="exhibit-title" hidden><div class="explainer"><div class="story"><h1 id="exhibit-title">{esc(entry.get('headline',title))}</h1><p id="lead">{esc(summary)}</p><p id="scope">{esc(scope)}</p></div><figure class="experiment"><div id="visual"></div><div id="controls" aria-label="Explore the result" role="group"></div><figcaption id="caption" aria-live="polite"></figcaption></figure></div></section>
<article id="full-text" tabindex="-1"><p class="date">{esc(entry['field'])}</p><h1 class="paper-title">{esc(title)}</h1>
{full_note}
<section id="evidence"><h2>Evidence</h2><p>{esc(method)}</p><nav aria-label="Evidence and sources">{evidence_html}</nav>{records}</section></article></main>
<footer class="paper-credit">{byline}<details id="more" hidden><summary>Scope &amp; credits</summary></details></footer>
<script type="application/json" id="result-instrument">{widget}</script></body></html>
"""


def legacy(entries):
    # Hashes never reach the server. Keep a static directory too, for readers without JS.
    mapping = {e["id"]: "../../" + e["path"] for e in entries}
    payload = json.dumps(mapping, ensure_ascii=True).replace("<", "\\u003c")
    links = "".join(f'<li><a href="{esc(mapping[e["id"]])}">{esc(e["title"])}</a></li>' for e in entries)
    return f"""<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Left to Solve · oo research</title>
<script>const papers={payload};const id=location.hash.slice(1);location.replace(Object.hasOwn(papers,id)?papers[id]:'{PROFILE}');</script></head>
<body><main><h1>Left to Solve</h1><a href="{PROFILE}">@shunyaekam</a><ul>{links}</ul></main></body></html>
"""


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pandoc")
    opts = parser.parse_args()
    entries = json.loads(Path(__file__).with_name("entries.json").read_text())
    for entry in entries:
        target = ROOT / "papers" / entry["slug"] / "index.html"
        target.parent.mkdir(exist_ok=True)
        target.write_text(render_entry(entry,pandoc=opts.pandoc))
    (ROOT/"contributions/left-to-solve/index.html").write_text(legacy(entries))
