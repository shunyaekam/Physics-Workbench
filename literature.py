"""Weekly source-backed intake. Leads and model notes have no result status."""
from datetime import datetime,timezone
import re
from urllib.parse import urlencode
from urllib.request import Request,urlopen
from xml.etree import ElementTree as ET

from lab import ROOT,write

BASE=ROOT/"campaign/intake"
NS="{http://www.w3.org/2005/Atom}"
QUERY='(cat:quant-ph OR cat:gr-qc OR cat:math-ph OR cat:cond-mat.stat-mech) AND (abs:"we conjecture" OR abs:"remains open")'


def poll():
    now=datetime.now(timezone.utc)
    prefix=now.strftime('%G-W%V')
    BASE.mkdir(exist_ok=True,parents=True)
    path=BASE/(prefix+".json")
    marker=BASE/("."+prefix+".retry")
    if path.exists() or (marker.exists() and now.timestamp()-marker.stat().st_mtime<86400):
        return
    marker.touch()
    request=Request("https://export.arxiv.org/api/query?"+urlencode(dict(search_query=QUERY,
        sortBy="submittedDate",sortOrder="descending",max_results=6)),
        headers={"User-Agent":"PhysicsWorkbench/1.0 (low-frequency research literature intake)"})
    try:
        with urlopen(request,timeout=20) as response:
            root=ET.fromstring(response.read())
        cards=[]
        for e in root.findall(NS+"entry"):
            locator=e.findtext(NS+"id","").replace("http://","https://",1)
            title=" ".join(e.findtext(NS+"title","").split())
            abstract=" ".join(e.findtext(NS+"summary","").split())
            if not re.fullmatch(r"https://arxiv\.org/abs/\d{4}\.\d{4,5}v\d+",locator):
                continue
            sentences=re.split(r"(?<=[.!?])\s+",abstract)
            lead=next((s for s in sentences if re.search(r"conjectur|remains open",s,re.I)),None)
            if lead:
                cards.append(dict(id="arxiv-"+locator.rsplit("/",1)[1],title=title,
                    topics=[c.get("term", "") for c in e.findall(NS+"category")],
                    question="Extract a small falsifiable subproblem from this attributed abstract sentence: "+lead,
                    scope="Intake only. Verify definitions in the full text and check later work before accepting the conjecture.",
                    source=locator,prior_art=locator,checked_on=now.date().isoformat(),status="unreviewed_lead"))
        if not cards:
            print("No new indexable leads; retry on a later day.")
            return
        write(path,cards)
        print("Saved",len(cards),"literature leads",path.name)
    except (OSError,ET.ParseError) as exc:
        print("Literature lookup deferred:",exc)
        return
if __name__=="__main__":
    poll()
