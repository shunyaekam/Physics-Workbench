"""Exact rank-two witness replay for the finite-copy qutrit Werner endpoint."""
import argparse
from fractions import Fraction
import json
from pathlib import Path

from complex_search import direct, matrix, partial_traces
from verify import require


def example():
    """Two Schmidt terms at the one-copy threshold, padded to four copies."""
    return {"copies": 4, "terms": [[[[i, 1, 0]], [[i, 1, 0]]] for i in (0, 1)]}


def check(witness):
    require(isinstance(witness, dict) and set(witness) == {"copies", "terms"},
            "Expected only copies and terms; the registered state fixes d=3 and alpha=1/2")
    copies, terms = witness["copies"], witness["terms"]
    require(type(copies) is int and copies in (4, 5), "Expected four or five copies")
    require(isinstance(terms, list) and 1 <= len(terms) <= 2,
            "Supply one or two product terms to certify Schmidt rank at most two")
    # matrix() enforces integer labels and coefficients, coefficient magnitude,
    # support limits and a nonzero total vector before either contraction runs.
    for term in terms:
        require(isinstance(term, list) and len(term) == 2, "Expected two local factors per term")
        for factor in term:
            require(isinstance(factor, list) and 1 <= len(factor) <= 8, "Expected 1 to 8 entries per factor")
            require(all(isinstance(e, list) and len(e) == 3 for e in factor),
                    "Each entry is [basis index, real part, imaginary part]")
    cells = matrix(terms, 3, copies)
    norm2 = sum(re**2 + im**2 for re, im in cells.values())
    kernel = direct(terms, 3, copies, 1, 2)
    traces = partial_traces(terms, 3, copies, 1, 2)
    require(kernel == traces, "Exact pair-element and partial-trace contractions disagree")
    return {
        "dimension": 3, "copies": copies, "alpha": "1/2",
        "norm_squared": norm2, "schmidt_rank_at_most": len(terms),
        "score": str(kernel), "density_matrix_expectation": str(kernel / Fraction(15, 2)**copies),
        "finite_copy_distillability_certified": kernel < 0,
        # Distilling this particular state cannot decide whether some *other*
        # NPT state is undistillable for all finite copy counts.
        "decisive": False,
        "scope": "strict negativity certifies distillability for this state and copy count",
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("witness", type=Path, nargs="?", help="JSON witness; defaults to the zero-score control")
    args = parser.parse_args()
    data = json.loads(args.witness.read_text()) if args.witness else example()
    print(json.dumps(check(data), indent=2))
