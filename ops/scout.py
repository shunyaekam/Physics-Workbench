"""Screen one external intake lead against primary sources within the shared model quota."""
import json
from pathlib import Path
import sys
from urllib.parse import urlsplit

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from lab import load,write
from ops.witness import fingerprint


def pending(root):
    admitted={c["source"] for c in load(root/"discovery/targets.json")}
    for batch in sorted((root/"campaign/intake").glob("*.json"),reverse=True):
        for lead in load(batch):
            key=fingerprint([lead["source"],lead["question"]])[:24]
            path=root/"campaign/scouting"/(key+".json")
            if lead["source"] not in admitted and not path.exists():
                return lead,path
    return None


def screen(job,ask):
    lead,path=job
    fields=("statement","significance","settlement_test","aliases","verdict","primary_sources")
    prompt=("Search primary sources for the exact statement, alternative names, later versions and prior "
            "solutions. State the quantifiers and what finding would settle it. Return verdict shortlist, "
            "prior_resolution, duplicate or insufficient_evidence. Record primary_sources as a JSON list "
            "of HTTPS URLs you consulted. This is intake, with no automatic solution credit.\n"+json.dumps(lead))
    result=ask(prompt,fields,sources=True)
    links=json.loads(result["primary_sources"])
    if (result["verdict"] not in ("shortlist","prior_resolution","duplicate","insufficient_evidence")
         or not isinstance(links,list) or not links or not all(isinstance(u,str) and urlsplit(u).scheme=="https"
                                                              and urlsplit(u).hostname for u in links)):
        raise ValueError("Incomplete source screen")
    path.parent.mkdir(exist_ok=True)
    write(path,dict(lead=lead,review=result))
