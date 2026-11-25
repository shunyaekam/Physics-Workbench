"""Install a ten-minute per-user macOS launch agent with an isolated checkout."""
import json
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
    subprocess.run(["git","clone","--branch","main",ref,str(RUNTIME)],check=True)
else:
    existing=subprocess.check_output(["git","remote","get-url","origin"],cwd=RUNTIME,text=True).strip()
    if existing!=ref:
        raise SystemExit("Dedicated checkout remote differs from this project.")
(SERVICE/"settings.json").write_text(json.dumps({"editable":str(ROOT)}))
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
