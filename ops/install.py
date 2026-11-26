"""Install a ten-minute per-user macOS launch agent with an isolated checkout."""
import argparse
import json
import shutil
import os
from pathlib import Path
import plistlib
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[1]
HOME=Path.home()
SERVICE=HOME/"Library/Application Support/Physics Workbench"
RUNTIME=SERVICE/"checkout"
LABEL="local.physics-workbench.research"
DOMAIN="gui/"+str(os.getuid())
PLIST=HOME/"Library/LaunchAgents"/(LABEL+".plist")
SERVICE.mkdir(parents=True,exist_ok=True)
ref=subprocess.check_output(["git","remote","get-url","origin"],cwd=ROOT,text=True).strip()
if not RUNTIME.exists():
    subprocess.run(["git","clone","--branch","research",ref,str(RUNTIME)],check=True)
else:
    existing=subprocess.check_output(["git","remote","get-url","origin"],cwd=RUNTIME,text=True).strip()
    if existing!=ref:
        raise SystemExit("Dedicated checkout remote differs from this project.")
parser=argparse.ArgumentParser(description=__doc__)
mode=parser.add_mutually_exclusive_group()
mode.add_argument("--hosted-hourly",action="store_true",help="Use one signed-in hosted Codex request per hour")
mode.add_argument("--checks-only",action="store_true",help="Disable scheduled model requests")
args=parser.parse_args()
settings_path=SERVICE/"settings.json"
settings=json.loads(settings_path.read_text()) if settings_path.exists() else {}
settings["editable"]=str(ROOT)
if args.hosted_hourly:
    executable=shutil.which("codex")
    if not executable:
        raise SystemExit("Codex CLI is required for hosted hourly research")
    settings["hosted_codex"]=executable
elif args.checks_only:
    settings.pop("hosted_codex",None)
settings_path.write_text(json.dumps(settings))
PLIST.parent.mkdir(parents=True,exist_ok=True)
spec=dict(Label=LABEL,ProgramArguments=[sys.executable,str(RUNTIME/"ops/worker.py")],
          WorkingDirectory=str(RUNTIME),StartInterval=600,RunAtLoad=True,ProcessType="Background",
          EnvironmentVariables={"PATH":"/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
                                "OPENBLAS_NUM_THREADS":"1","OMP_NUM_THREADS":"1"})
if PLIST.exists() and plistlib.loads(PLIST.read_bytes())!=spec:
    subprocess.run(["launchctl","bootout",DOMAIN+"/"+LABEL],check=False)
PLIST.write_bytes(plistlib.dumps(spec))
running=subprocess.run(["launchctl","print",DOMAIN+"/"+LABEL],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
if running.returncode:
    subprocess.run(["launchctl","bootstrap",DOMAIN,str(PLIST)],check=True)
print(PLIST)
