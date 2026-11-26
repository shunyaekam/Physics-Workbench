"""Stage the print edition's shared inputs in a disposable repository layout."""
from pathlib import Path
from shutil import copyfile


def stage_paper_directory(directory, root):
    directory = Path(directory)
    for name in ("papers/oo-journal.sty", "site/assets/fonts/play-regular.ttf", "site/assets/torus.png"):
        destination = directory / name
        destination.parent.mkdir(parents=True, exist_ok=True)
        copyfile(root / name, destination)
    return directory / "papers"
