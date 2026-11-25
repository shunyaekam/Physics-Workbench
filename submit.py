"""Archive a proposed witness and its exact check, including rejections."""
import argparse
from datetime import datetime, timezone
import fcntl
import sys

from lab import Path, ROOT, catalog, digest, load, verify_record, write
from verify import CHECKERS, require


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("problem")
    parser.add_argument("file",type=Path)
    parser.add_argument("--credit",required=True,help="proposer or model, run ID, and source if applicable")
    parser.add_argument("--out",type=Path,default=ROOT/"submissions")
    args=parser.parse_args()
    c=next((r for r in catalog() if r["id"]==args.problem),None)
    require(c is not None,"unknown problem")
    w=load(args.file)
    key=digest([c,w,args.credit])
    args.out.mkdir(exist_ok=True,parents=True)
    with (args.out/(".lock-"+key)).open("w") as lock:
        fcntl.flock(lock,fcntl.LOCK_EX)
        path=args.out/(key+".json")
        rec={"key":key,"problem":c,"witness":w,"credit":args.credit,"engine":"submission","seed":0,
             "time":datetime.now(timezone.utc).isoformat()}
        try:
            rec["result"]=CHECKERS[c["family"]](c,w)
            verify_record(rec)
        except (ValueError,TypeError,KeyError,IndexError) as exc:
            rec["error"]=str(exc)
        if not path.exists():
            write(path,rec)
        print(path,rec.get("result",rec.get("error")))
        return int("error" in rec)


if __name__=="__main__":
    sys.exit(main())
