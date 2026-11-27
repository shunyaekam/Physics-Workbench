"""Prepare a read-only pinned compiler and a short feedback loop for registered targets."""
import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import stat

from lab import ROOT

PIN = "9097e2f90e66d2f6244209cb1c07f7120d17ec53"
MATHLIB = "0df444a360eaa60ab8c11dca51a86af692955474"
BOARD = "2ae0f49893f50d0e23bda6d61d49bc44307d418e"
CACHE = Path("/opt/homebrew/var/oo-research")
FC = CACHE / "formal-conjectures-9097e2f9"
SDK = CACHE / "lean-4.33.1-darwin_aarch64"
TARGET = "lts-Erdos1164.erdos_1164.R1.H2.R1.H1"
MODULE = "OMAReductions.R_Erdos1164_erdos_1164_R1_H2_R1"
GOAL = "OMA.R_Erdos1164_erdos_1164_R1_H2_R1.H1"
# Versioned library of previously verified diffusion results. Its digest is part of the environment.
HELPERS = ("Cylinder", "Split", "Discount")
MAXWELL = "lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes"
MAXWELL_MODULE = "FormalConjectures.Arxiv.«2607.27197».MaxwellConjecture"
MAXWELL_TYPE = "type_of% @Arxiv.«2607.27197».maxwell_conjecture.variants.three_equal_magnitudes"
TARGETS = {TARGET: (MODULE, GOAL), MAXWELL: (MAXWELL_MODULE, MAXWELL_TYPE)}
ALLOWED = {"propext", "Classical.choice", "Quot.sound"}


def helper_hash():
    import hashlib
    digest = hashlib.sha256()
    for name in HELPERS:
        digest.update((ROOT / f"checks/left_to_solve/attempts/diffusion/{name}.lean").read_bytes())
    return digest


def library_dir():
    digest = helper_hash()
    digest.update(repr(sorted(TARGETS.items())).encode())
    return CACHE / "proof-libraries" / BOARD / digest.hexdigest()[:16]


def prepare():
    """Run once with the pinned local checkout, toolchain, and Mathlib cache installed."""
    from urllib.request import urlopen
    lib = library_dir()
    lib.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, PATH=str(SDK/"bin")+":"+os.environ["PATH"])
    def call(args, **kwargs):
        return subprocess.check_output(args, cwd=FC, env=env, text=True, **kwargs).strip()
    for path, pin in ((FC, PIN), (FC/".lake/packages/mathlib", MATHLIB)):
        if call(["git", "-C", str(path), "rev-parse", "HEAD"]) != pin:
            raise ValueError("Unexpected proof library revision")
    if "4.33.1" not in call([str(SDK/"bin/lean"), "--version"]):
        raise ValueError("Unexpected Lean compiler")
    call(["lake","build","FormalConjecturesUtil"])
    paths = [str((FC/p).resolve()) for p in call(["lake","env","printenv","LEAN_PATH"]).split(os.pathsep) if p]
    env["LEAN_PATH"] = os.pathsep.join([str(lib), *paths])
    for num in ("1165","1164"):
        source = FC/f"FormalConjectures/ErdosProblems/{num}.lean"
        target = lib/f"FormalConjectures/ErdosProblems/{num}.olean"
        target.parent.mkdir(parents=True, exist_ok=True)
        call([str(SDK/"bin/lean"), "-o", str(target), str(source)])
    source = FC/"FormalConjectures/Arxiv/2607.27197/MaxwellConjecture.lean"
    target = lib/"FormalConjectures/Arxiv/2607.27197/MaxwellConjecture.olean"
    target.parent.mkdir(parents=True,exist_ok=True)
    call([str(SDK/"bin/lean"), "-o",str(target),str(source)])
    for reduction in ("Erdos1164.erdos_1164.R1", "Erdos1164.erdos_1164.R1.H2.R1"):
        module = "OMAReductions.R_"+reduction.replace(".","_")
        source = lib.joinpath(*module.split(".")).with_suffix(".lean")
        source.parent.mkdir(exist_ok=True)
        source.write_bytes(urlopen("https://raw.githubusercontent.com/GuillaumeBAUD-coder/open-math-agents/"
                                   +BOARD+"/reductions/"+reduction+".lean",timeout=25).read())
        subprocess.run([str(SDK/"bin/lean"), "-o", str(source.with_suffix(".olean")), str(source)],
                       cwd=lib,env=env,check=True)
    for name in HELPERS:
        source = lib / (name+".lean")
        source.write_bytes((ROOT/f"checks/left_to_solve/attempts/diffusion/{name}.lean").read_bytes())
        subprocess.run([str(SDK/"bin/lean"), "-o", str(lib/(name+".olean")),str(source)],cwd=lib,env=env,check=True)
    # Publish readiness only after all dependencies compiled and the exact theorem type resolves.
    subprocess.run([str(SDK/"bin/lean"),"--stdin"],cwd=lib,env=env,
                   input="import "+MODULE+"\n#check "+GOAL+"\n",text=True,check=True)
    tmp = lib/"environment.tmp"
    tmp.write_text(json.dumps({"lean_path": env["LEAN_PATH"], "pin":PIN}))
    tmp.replace(lib/"environment.json")


def notebook(work, problem=TARGET):
    """Install the pinned feedback command. Only public toolchain and dependency roots need read access."""
    lib = library_dir()
    manifest = lib/"environment.json"
    if not manifest.exists():
        return None
    settings = json.loads(manifest.read_text())
    if settings["pin"] != PIN:
        raise ValueError("Wrong feedback environment")
    runner = work/"check"
    runner.write_text("#!/bin/sh\nexport LEAN_PATH="+shlex.quote(settings["lean_path"])+"\n"+
                      'exec '+shlex.quote(str(SDK/"bin/lean"))+' -T 350000 "$@"\n')
    runner.chmod(0o700)
    module, goal = TARGETS[problem]
    start = "import "+module+"\n"
    if problem == TARGET:
        start += "".join("import "+s+"\n" for s in HELPERS)
    start += "\n-- Local working proof. The official file permits only the desk import.\n"
    start += "theorem OMA.solution : "+goal+" := by\n  skip\n\n#print axioms OMA.solution\n"
    (work/"Candidate.lean").write_text(start)
    return {str(FC):"read", str(SDK):"read", str(lib):"read"}


def save_progress(candidate, original, checkpoint):
    """Save source for another attempt as unverified text, including after a timeout."""
    try:
        fd = os.open(candidate, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK)
    except OSError:
        return False
    with os.fdopen(fd,"rb") as f:
        st = os.fstat(f.fileno())
        if not stat.S_ISREG(st.st_mode) or st.st_nlink != 1 or st.st_size > 80000:
            return False
        data = f.read(80001)
    if not data.strip() or len(data)>80000 or data == original or b"\0" in data:
        return False
    try:
        data.decode("utf-8")
    except UnicodeDecodeError:
        return False
    checkpoint.parent.mkdir(parents=True,exist_ok=True)
    tmp = checkpoint.with_suffix(".tmp")
    tmp.write_bytes(data)
    tmp.replace(checkpoint)
    return True


def clean_axioms(output, name):
    if re.search(r"(?m)^.*:\d+:\d+: error:", output):
        return False
    if f"'{name}' does not depend on any axioms" in output:
        return True
    match = re.search("'"+re.escape(name)+r"' depends on axioms: \[([^\]]*)\]",output)
    return bool(match and set(map(str.strip, match[1].split(","))) <= ALLOWED)


if __name__ == "__main__":
    prepare()
