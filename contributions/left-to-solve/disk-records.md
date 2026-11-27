# A missing disk on the triangular lattice

The tenth strict record for the number of triangular-lattice sites in a freely placed closed disk is **13**, at squared radius **3**. The ninth positive record for self-avoiding walk length is **14**, at squared radius **13/4**. The proposed equality of these two records for every index greater than two fails at index ten. The displayed table of point records goes directly from 12 sites to 14. [Source entry and displayed table](https://oeis.org/A346784) · [Walk definition](https://oeis.org/A346126)

## Why the two counts separate

Take unit basis vectors meeting at 60 degrees. The squared norm of axial coordinates is $Q(x,y)=x^2+xy+y^2$. At a lattice site, a disk of squared radius 3 contains the center, six nearest neighbors and six outer tips. To visit all 13 sites in **13 unit steps**, a self-avoiding walk would have to close. Each outer tip has exactly two possible neighbors. A cycle through the six tips is forced to use their twelve edges. These edges already form a cycle that misses the center. The longest permissible walk on this placement has twelve steps.

To refute a conjecture about the *best possible* disk, one must also allow other centers and establish where the records fall. Here are all the changes through squared radius 13/4. Walk length counts edges. A closed walk may repeat its starting vertex only at the end.

| Squared radius | Maximum sites | Maximum walk length |
|---|---:|---:|
| 0 | 1 | 0 |
| 1/4 | 2 | 1 |
| 1/3 | 3 | 3 |
| 3/4 | 4 | 4 |
| 1 | 7 | 7 |
| 7/4 | 8 | 8 |
| 49/25 | 9 | 9 |
| 9/4 | 10 | 10 |
| 7/3 | 12 | 12 |
| **3** | **13** | **12** |
| 13/4 | 14 | 14 |

## How the continuum of centers is exhausted

Any finite set with at least two points has a smallest enclosing disk. Its center lies in the convex hull of the boundary points, since otherwise one could move it toward their convex hull and reduce the radius. Thus some diametrically opposite pair, or some three noncollinear boundary points, determine that disk. Translate one boundary site to the origin. Every covered site then has squared norm at most four times the squared radius, hence at most 13 in this calculation. Since $Q(x,y)\ge 3x^2/4$ and $Q(x,y)\ge 3y^2/4$, both integer coordinates lie between −4 and 4. Singletons contribute the radius-zero case.

The replay enumerates all pair midpoints and noncollinear triple circumcenters in that box, using exact fractions, then collects every site inside each resulting disk. Extra circumcenters are harmless because they describe feasible disks. Any feasible walk or point set can be enclosed by its own minimum disk, so every first attainment of either record occurs among the enumerated disks. For each induced unit-neighbor graph the replay enumerates simple paths by their starting vertex, current vertex and visited set. A return edge to the start adds one step when at least three distinct vertices have been visited. Taking the maxima and keeping only strict increases gives the table above. No estimate of a floating-point boundary enters the test.

Run `python3 replay_disk_records.py` to regenerate and assert both rows of records. The index for sites starts with the single point at radius zero. The positive walk list starts with length one. The full geometric argument uses exact arithmetic and finite enumeration. The upstream Lean submission is the problem statement. No claim of priority is made for the 13-site graph or its failure to have a Hamiltonian cycle. [Replay](replay_disk_records.py) · [Earlier triangular graph theorem](https://doi.org/10.1007/s004540010051) · [Upstream submission](https://github.com/GuillaumeBAUD-coder/open-math-agents/pull/1209)

## Independent checks and prior work

Splitting the triangular lattice into three colors gives a geometric proof that *no* smaller disk can hold 13 sites. The independent replay also enumerates the centers inside a single fundamental cell, using a different coordinate system. [Three-color argument](disk-audit.md) · [Separate implementation](replay_disk_independent.py)

Kittipassorn, Phetmak and Sriamorn independently reported this **point-count threshold** in November 2026. In their convention the disk has unit radius and the lattice spacing is $d$, so our radius is $1/d$. Appendix rows 54–56 give 12, 13 and 14 at the corresponding thresholds. Our contribution here connects these point records to the self-avoiding walk problem and identifies the resulting discrepancy in the published OEIS table. [Primary paper and tables](https://arxiv.org/html/2611.13535v1)
