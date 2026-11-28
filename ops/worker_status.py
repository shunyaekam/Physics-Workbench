"""Publish a sampled, public-safe heartbeat separately from scientific evidence."""
import base64
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import subprocess
from threading import Event, Thread

ENDPOINT = "repos/shunyaekam/oo-research/contents/worker.json"
BRANCH = "worker-status"
TASKS = {
    "mean_check.py": ("Checking the 54-touch quantum-code bound", "codes"),
    "golay43.py": ("Searching for a 43-gate Golay circuit", "codes"),
    "checks/golay/advance.py": ("Rewriting Golay circuits to remove a gate", "codes"),
    "pair_search.py": ("Testing Schmidt bases for quantum magic", "magic"),
    "bmv_search.py": ("Testing a quantum trace bound", "trace"),
    "continuous.py": ("Running the Werner, optical and sphere searches", "notebook"),
    "proof_flow.py": ("Checking the next hosted research assignment", "notebook"),
    "proof_portfolio.py": ("Checking candidate Lean proofs", "notebook"),
    "lts_standings.py": ("Refreshing Left to Solve standings", "notebook"),
    "left_to_solve.py": ("Checking Left to Solve submissions", "notebook"),
    "excited_pairs.py": ("Bounding optical states with two photon counts", "optics"),
    "coherent_band_search.py": ("Testing optical superpositions", "optics"),
    "three_level_search.py": ("Searching three-level optical states", "optics"),
    "finite_spins.py": ("Checking finite spin chains", "statistical"),
    "literature.py": ("Checking the literature for open problems", "notebook"),
    "git": ("Synchronizing research records", "notebook"),
}


class Heartbeat:
    def __init__(self, service):
        self.service = service
        self.task = ("Starting research cycle", "notebook")
        self.stop = Event()
        self.thread = Thread(target=self.loop, daemon=True)
        self.sha = None
        self.hosted = service/"active-hosted.json"

    def start(self):
        self.hosted.unlink(missing_ok=True)
        os.environ["OO_WORKER_HOSTED_STATUS"] = str(self.hosted)
        self.thread.start()

    def command(self, args):
        self.task = next((value for arg in args for value in
                          [TASKS.get(str(arg)) or TASKS.get(Path(str(arg)).name)] if value),
                         ("Running lab checks and preparing records", "notebook"))

    def send(self, state):
        task, field = self.task
        data = dict(state=state, task=task, field=field,
                    observed_at=datetime.now(timezone.utc).isoformat())
        if state == "running" and self.hosted.exists():
            try:
                host = json.loads(self.hosted.read_text())
                os.kill(host["pid"], 0)
                data.update(task=f'{host["model"]} · {host["problem"]}', hosted=True)
            except (OSError, ValueError, KeyError):
                pass
        try:
            if self.sha is None:
                existing = subprocess.run(["gh","api",ENDPOINT+"?ref="+BRANCH,"--jq",".sha"],
                                          capture_output=True,text=True,timeout=6)
                self.sha = existing.stdout.strip() if existing.returncode == 0 else ""
            payload = dict(branch=BRANCH, message="Report lab worker state",
                           content=base64.b64encode(json.dumps(data).encode()).decode())
            if self.sha:
                payload["sha"] = self.sha
            result = subprocess.run(["gh","api","-X","PUT",ENDPOINT,"--input","-","--jq",".content.sha"],
                                    input=json.dumps(payload),capture_output=True,text=True,timeout=8,check=True)
            self.sha = result.stdout.strip()
        except (OSError,subprocess.SubprocessError):
            self.sha = None
            print("Worker heartbeat unavailable; continuing research.",flush=True)

    def loop(self):
        while not self.stop.is_set():
            self.send("running")
            self.stop.wait(25)

    def finish(self, state):
        self.stop.set()
        self.thread.join()
        self.send(state)
