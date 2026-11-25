"""Continue one graph batch and exhaust its delete-two/insert-one neighborhood."""
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory

import graph_campaign as graphs
import repair_campaign as repairs
import splice_campaign as splices
from lab import load


def main():
    graphs.OUT.mkdir(exist_ok=True)
    if (any(load(p)["cost"]<=43 for p in graphs.OUT.glob("*.json"))
        or any(load(p)["found"] for root in (repairs.OUT,splices.OUT,splices.TAIL_OUT) for p in root.glob("*.json"))):
        print("Golay candidate already recorded for review.")
        return
    with TemporaryDirectory() as temp:
        def compile_search(name):
            exe=Path(temp)/name
            subprocess.run(["c++","-O3","-std=c++17",str(graphs.HERE/(name+".cpp")),"-o",str(exe)],check=True)
            return exe
        files=sorted(graphs.OUT.glob("*.json"))
        pending=[p.stem for p in files if load(p)["cost"]==44 and not all((d/p.name).exists() for d in (splices.OUT,splices.TAIL_OUT))]
        if not all((d/"published.json").exists() for d in (splices.OUT,splices.TAIL_OUT)):
            pending.insert(0,"published")
        if not pending:
            batch=int(files[-1].stem)+1 if files else 0
            graphs.advance(compile_search("graph_walk"),batch)
            path=graphs.OUT/f"{batch:06d}.json"
            if load(path)["cost"]!=44:
                return
            pending.append(path.stem)
        splice_exe=compile_search("splice")
        result=splices.advance(splice_exe,pending[0])
        print("Golay splice",result["source"],result["trials"],"edits, candidate",result["found"])
        if not result["found"]:
            result=splices.advance(splice_exe,pending[0],tail=True)
            print("Golay splice with terminal gate",result["source"],result["trials"],"candidate",result["found"])


if __name__=="__main__":
    main()
