"""Replay both sides of the minimum check weight of the two registered length-twelve stabilizer codes."""
from .dual import upper_bounds
from .verify import verify


def check(witness, k=3):
    weight = {3:6, 4:7}[k]
    rank = 12-k
    if type(witness) is not dict or set(witness) != {"generators"}:
        raise ValueError("Expected a generator list")
    rows = witness["generators"]
    if type(rows) is not list or len(rows) != rank or any(type(s) is not str or len(s)!=12 for s in rows):
        raise ValueError(f"Expected {rank} twelve-site Pauli strings")
    result = verify(dict(n=12,k=k,d=4,weight=weight,generators=rows))
    return dict(result, light_stabilizer_weight_limit=weight-1,
                light_stabilizer_upper_bounds_by_even_subgroup_size=upper_bounds(k),
                required_rank=rank, optimal_check_weight=weight, decisive=True)
