"""Replay the ten-qubit construction and the full graph-parent exclusion."""
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
from hashlib import sha256
import json
import os
from pathlib import Path
import tempfile
from urllib.request import urlopen

from .enumerate_planes import analyze, components, graph_parents
from ..verify import verify


def census():
    root = Path(__file__).resolve().parent
    hashes = json.loads((root/"catalogue.json").read_text())
    external = os.environ.get("OO_GRAPH_CATALOG")

    def fetch(name):
        if external:
            data = (Path(external)/name).read_bytes()
        else:
            url = "https://www.codetables.de/larsed/vncorbits/" + name
            with urlopen(url, timeout=20) as response:
                data = response.read(65536)
        if sha256(data).hexdigest() != hashes[name]:
            raise ValueError(f"Catalogue digest mismatch for {name}")
        return name, data

    with tempfile.TemporaryDirectory() as work:
        directory = Path(work)
        with ThreadPoolExecutor(max_workers=4) as pool:
            for name, data in pool.map(fetch, hashes):
                (directory/name).write_bytes(data)
        catalog = components(directory)
    counts, ranks = Counter(), Counter()
    for graph in graph_parents(catalog):
        counts["parents"] += 1
        analyze(graph, counts, ranks)
    if (counts["parents"] != 3990 or counts["parents_with_any_distance_at_least_four"] != 10
        or counts["parent_plane_pairs_distance_at_least_four"] != 47 or ranks != {0:47}):
        raise ValueError(f"Ten-qubit exclusion failed: {counts}, {ranks}")
    return dict(counts=counts, light_stabilizer_rank_histogram={str(i):r for i,r in ranks.items()},
                excluded_check_weight=5)


def check(witness):
    if type(witness) is not dict or set(witness) != {"generators"}:
        raise ValueError("Expected a list of stabilizer generators")
    rows = witness["generators"]
    if type(rows) is not list or len(rows) != 8 or any(type(s) is not str or len(s)!=10 for s in rows):
        raise ValueError("Expected eight ten-site Pauli strings")
    upper = verify(dict(n=10,k=2,d=4,weight=6,generators=rows))
    return dict(upper, graph_census=census(), optimal_check_weight=6, decisive=True)
