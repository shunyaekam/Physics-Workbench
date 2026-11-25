"""Record weekly catalogue revisions for the next primary-source intake review."""
from datetime import datetime,timezone
import json
from pathlib import Path
import sys
from urllib.request import Request,urlopen

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from lab import load,write

CATALOGUES=("jpbruneton/open_quantum_problems","jgmcm/problems","MColbrook/AIM")
OUT=ROOT/"campaign/catalogue-scans"


def github(path):
    req=Request("https://api.github.com/repos/"+path,headers={"User-Agent":"Physics-Workbench-catalogue-watch"})
    with urlopen(req,timeout=8) as res:
        return json.load(res)


def scan():
    now=datetime.now(timezone.utc)
    OUT.mkdir(exist_ok=True)
    dest=OUT/(now.strftime("%G-W%V")+".json")
    old=load(dest) if dest.exists() else {"sources":{}}
    history=sorted(f for f in OUT.glob("*.json") if f<dest)
    prior=load(history[-1])["sources"] if history else {}
    for repo in CATALOGUES:
        if repo in old["sources"]:continue
        sha=github(repo+"/commits/HEAD")["sha"]
        base=prior.get(repo,{}).get("sha")
        url="https://github.com/"+repo
        old["sources"][repo]=dict(sha=sha,previous=base,checked=now.isoformat(),
              review_url=(url+"/compare/"+base+"..."+sha if base and base!=sha else url+"/tree/"+sha))
        write(dest,old)


if __name__=="__main__":
    scan()
