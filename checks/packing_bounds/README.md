# Five improvements to published spherical packing bounds

Four constructions place equal spherical caps on the ordinary unit sphere. A fifth is a spherical code in seven Euclidean dimensions. For each parameter pair, this packet gives coordinates whose worst pairwise cosine is strictly below the corresponding November 25, 2026 entry in Henry Cohn's table. Smaller maximum cosine gives a larger guaranteed least angle. The records below are feasible bounds at five sizes. The best possible least angle at each size remains unknown.

| Dimension | Points | Cohn table | Certified new upper bound | Previous least angle | New least angle |
|---:|---:|---:|---:|---:|---:|
| 3 | [327](https://spherical-codes.org/code/3/327) | 0.979170695575 | 0.979170312 | 11.7147155° | 11.7148240° |
| 3 | [418](https://spherical-codes.org/code/3/418) | 0.983664967676 | 0.983637642 | 10.3702826° | 10.3789768° |
| 3 | [577](https://spherical-codes.org/code/3/577) | 0.988154316960 | 0.988152320 | 8.8276952° | 8.8284410° |
| 3 | [636](https://spherical-codes.org/code/3/636) | 0.989239710497 | 0.989234488 | 8.4127853° | 8.4148307° |
| 7 | [151](https://spherical-codes.org/code/7/151) | 0.545859542775 | 0.545833304 | 56.9165786° | 56.9183729° |

For 418 points, the certified change moves the least separation from about 10.3703° to 10.3790°. A cap of half the least separation centered on each point has interior disjoint from the others. This is a hard-cap packing result and concerns the closest pair. It does not imply a lower electrostatic energy.

## Bounds that can be replayed

Run `python3 check.py` from this directory. The input is a finite list of signed decimal directions. The checker clears denominators row by row and scales each direction to unit length implicitly. For a pair of resulting integer directions \(a,b\) with positive dot product, the squared cosine is exactly \((a\cdot b)^2/(\lVert a\rVert^2\lVert b\rVert^2)\). The checker compares integer products across every pair to obtain the true maximum. It repeats the computation on the deposited prior coordinates, checks those against the displayed table precision, and requires each new upper bound to improve the old configuration. Negative dots cannot be maximal since each file contains a positive pair.

The independent check `python3 check50.py` reads the 39-significant-digit decimal coordinates, normalizes them in mpmath 1.3.0 at 50 decimal digits, recomputes all pairwise cosines and emits the maximum and angular separation. The saved outputs are [the integer replay](receipt.json) and [the 50-digit replay](receipt50.txt).

## How we found the packings

For ordinary spheres we ranked trial sizes 95 through 691 by the jump in published cosine from the preceding size, divided by an estimate of the local spacing of consecutive records. For the top 135, we inserted a point near a large empty spherical cap of the preceding configuration, using the outward normals of its convex hull. We considered up to twelve holes and let the entire configuration move. A squared-hinge penalty punishes pairs with cosine above a threshold. Sparse close-pair gradients accelerate the numerical search. The final check includes every pair. Four of the 135 sizes beat the published value. A different 65-size deletion sweep in three dimensions had no hits.

For the seven-dimensional code we deleted row 16 (zero-based) of Borisov's 152-point code and relaxed the remaining 151 directions. We rounded all successful directions to integer components at scale 10^16, re-normalized them at 55 digits, and recorded the resulting 39-significant-digit directions as the inputs to the two checks. The certificate applies to the decimal rows as supplied.

The captured `seed.csv` for each result is the curator's attributed neighbor. The archived `baseline.csv` is the actual prior code at the same size. URLs, SHA-256 digests, source attributions, prior-art comparisons and thresholds are in [comparisons.json](comparisons.json). Every baseline and seed in this packet is attributed by the table to **Vadim Borisov (2026)**. Source collection maintained by Henry Cohn. [Curator's archive](https://dspace.mit.edu/handle/1721.1/153543) · [Current index](https://spherical-codes.org/)

With NumPy, SciPy and a C compiler installed, try `OPENBLAS_NUM_THREADS=1 VECLIB_MAXIMUM_THREADS=1 python3 search/reproduce.py 3 418 rebuilt.csv`. The optimizer uses floating point, so systems can follow different numerical paths. The saved witnesses have deterministic integer checks.

## Scope and priority

The external benchmark asks for an improvement of at least 10^-10 in maximum cosine over an unstarred live row without a “needs more optimization” caveat. The dimension-three subcase is also listed as its p1 target. At the time of the check, all five source rows satisfied the table conditions, and the per-instance pages and plain CSV agreed. An entry in this note establishes a fresh comparison to that dated published row. Others have met the standing challenge on earlier rows. No code was submitted to the curator, and no priority over unpublished work is asserted. [Published challenge](https://github.com/elder-plinius/V3R1T4S/blob/main/known-unknowns/packings-physics/spherical-codes-cohn-table.md) · [Live plain table](https://spherical-codes.org/plain)

We checked Vahteristo's per-parameter combined data and Meadows's November 19 version 1.6 manifest. All matching published values in those two artifacts are weaker. Empty Meadows lists in the manifest indicate no corresponding record in its cells.csv. In a separate Canli census, the archived (7,151) code had maximum cosine 0.5459706806063939. Literature searches used the problem name, dimensions, sizes and published cosine. This bounded review cannot establish a world record across unknown archives. [Vahteristo](https://doi.org/10.5281/zenodo.23270586) · [Meadows](https://doi.org/10.5281/zenodo.24386804) · [Canli](https://github.com/arhancanli/quantavane-spherical-codes/blob/main/certify/census/results_v4/d7_n151.json)
