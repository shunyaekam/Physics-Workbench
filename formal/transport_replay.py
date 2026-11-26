"""Check the transport lemmas with the project-pinned kernel and inspect their axioms."""
import subprocess

from replay import HERE, pinned_lean


def replay():
    lean, version = pinned_lean()
    report = subprocess.check_output(
        [lean, "-DwarningAsError=true", "TransportPolygon.lean"], cwd=HERE, text=True
    )
    names = ("triangleAlongWalk", "pathError", "polygonLowerBound", "integerPolygonLowerBound", "markedEntryCrossesUp")
    expected = []
    for name in names:
        axioms = "depends on axioms: [propext]" if name == "integerPolygonLowerBound" else "does not depend on any axioms"
        expected.append(f"'Workbench.TransportPolygon.{name}' {axioms}")
    if report.splitlines() != expected:
        raise ValueError("Unexpected transport axiom report: " + report)
    print(version)
    print(report.rstrip())


if __name__ == "__main__":
    replay()
