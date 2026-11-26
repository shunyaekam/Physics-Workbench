"""Build the full-text web editions from papers/*.tex with Pandoc 3 and native MathML."""
import argparse
import re
import subprocess
from pathlib import Path
from os.path import relpath

ROOT = Path(__file__).resolve().parents[2]
PAPERS = ROOT / "papers"
TEMPLATE = Path(__file__).with_name("paper.template")


def reader_source(source):
    """Give Pandoc explicit targets for LaTeX citations and numbered displays."""
    # The reader owns its title and abstract layout. Leave TeX's print-only style to Tectonic.
    source = re.sub(r"^\\(?:usepackage\{oo-journal\}|(?:ooshorttitle|ooprojectcredit)\{[^\n]*\})\s*$", "", source, flags=re.M)
    source = re.sub(r"\{\\rm\s+([^{}]*)\}", r"\\mathrm{\1}", source).replace(r"\tbinom", r"\binom")
    source = re.sub(r"\\(?:small|footnotesize|enspace)\b", " ", source)
    source = re.sub(r"\\tag\{(\d+)\}", r"\\qquad (\1)", source)
    bibliography = {key: i for i, key in enumerate(re.findall(r"\\bibitem\{([^}]+)\}", source), 1)}
    for key, number in bibliography.items():
        source = source.replace(r"\bibitem{" + key + "}", rf"\item \hypertarget{{bib-{key}}}{{}}")
    source = re.sub(r"\\begin\{thebibliography\}\{[^}]*\}", r"\\section*{References}\n\\begin{enumerate}", source)
    source = source.replace(r"\end{thebibliography}", r"\end{enumerate}")

    def cite(match):
        keys = match[1].split(",")
        return "[" + ", ".join(rf"\hyperlink{{bib-{k}}}{{{bibliography[k]}}}" for k in keys) + "]"

    source = re.sub(r"\\cite\{([^}]+)\}", cite, source)
    for environment in ["equation", "theorem"]:
        pattern = rf"\\begin\{{{environment}\}}(.*?)\\end\{{{environment}\}}"
        for number, match in enumerate(list(re.finditer(pattern, source, re.S)), 1):
            label = re.search(r"\\label\{([^}]+)\}", match[1])
            if not label:
                continue
            key = label[1]
            target = "ref-" + key
            block = re.sub(r"[ \t]*" + re.escape(label[0]), "", match[0])
            if environment == "equation":
                block = block.replace(r"\end{equation}", rf"\qquad ({number})\end{{equation}}")
            source = source.replace(match[0], rf"\hypertarget{{{target}}}{{}}" + "\n" + block)
            for command, text in [("eqref", f"({number})"), ("ref", str(number))]:
                source = source.replace(rf"\{command}{{{key}}}", rf"\hyperlink{{{target}}}{{{text}}}")
    return source


def build(pandoc):
    for pdf in sorted(PAPERS.rglob("*.pdf")):
        source = pdf.with_suffix(".tex")
        input_format = "latex"
        if source.is_file():
            body = reader_source(source.read_text())
        elif pdf.relative_to(PAPERS).as_posix() == "sphere-packing/sphere-packing.pdf":
            source = TEMPLATE.with_name("sphere-packing.md")
            input_format = "markdown"
            body = source.read_text()
        else:
            continue
        target = PAPERS / pdf.stem / "index.html"
        target.parent.mkdir(exist_ok=True)
        command = [pandoc, "-f", input_format, "-t", "html5", "--mathml", "--standalone",
                   "--fail-if-warnings", "--shift-heading-level-by=1", "--wrap=none",
                   "--template", str(TEMPLATE), "-V", "pdfpath=" + pdf.relative_to(PAPERS).as_posix(),
                   "-V", "pdfhref=" + relpath(pdf, target.parent), "-o", str(target)]
        subprocess.run(command, input=body, text=True, cwd=PAPERS, check=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pandoc", default="pandoc")
    build(parser.parse_args().pandoc)
