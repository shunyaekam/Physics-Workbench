"""Replay legacy optical candidates; the active scheduler is ops/proof_flow.py."""
import math
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))


def evaluate_state(state):
    from three_level_search import quantities
    if not isinstance(state, dict) or set(state) != {"components"}:
        raise ValueError("Expected an object with a components array")
    terms = state["components"]
    if not isinstance(terms, list) or not 3 <= len(terms) <= 8:
        raise ValueError("Expected 3 to 8 nonzero Fock components")
    occupied = {}
    for term in terms:
        if not isinstance(term, dict) or set(term) != {"level", "real", "imag"}:
            raise ValueError("Each component requires level, real and imag")
        n, a, b = (term[k] for k in ("level", "real", "imag"))
        if any(type(x) is not int for x in (n,a,b)) or not 0 <= n <= 24:
            raise ValueError("Levels must be integers from 0 to 24 and amplitudes must be integers")
        if max(abs(a),abs(b)) > 32 or (a,b) == (0,0) or n in occupied:
            raise ValueError("Repeated level, zero amplitude or amplitude outside [-32,32]")
        occupied[n] = complex(a,b)
    levels = tuple(sorted(occupied))
    coefficients = [occupied[n] for n in levels]
    checks = []
    for radial, angular in ((256,192),(512,384)):
        w, h = quantities(levels,coefficients,radial,angular)
        if not (math.isfinite(w) and math.isfinite(h) and h > 0):
            raise ArithmeticError("Nonfinite optical quadrature")
        checks.append(dict(radial=radial,angular=angular,wigner_norm=w,husimi_bound=h,residual=w-h))
    return checks


if __name__=="__main__":
    import runpy
    runpy.run_module("ops.proof_flow",run_name="__main__")
