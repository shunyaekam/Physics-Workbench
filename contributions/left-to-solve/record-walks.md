# Why every record walk on the triangular lattice closes

Let $r_m$ be the least enclosing radius of a self-avoiding walk of $m$ unit edges, allowing simple cycles. The triangular lattice has six neighbors at each site. A346126 records the lengths $m$ for which $r_m<r_{m+1}$. If $m\ge2$ is a record length, every walk of length $m$ attaining $r_m$ is a cycle. This uses both criteria in Pfoertner and Sigg’s problem: maximal length at that radius and minimal radius for that length. [OEIS A346126](https://oeis.org/A346126) · [Author’s illustrations](https://www.randomwalk.de/sequences/a346126.htm)

**The disk graph.** Let $G$ be the unit-neighbor graph of all triangular-lattice sites in a closed disk of radius $R\ge1$. Each grid line cuts the disk in an interval, so $G$ is linearly convex. To see connectivity, move from any site at distance $d>1/\sqrt3$ from the disk center in a lattice direction within $30^\circ$ of the direction to the center. The new squared distance is at most $d^2+1-\sqrt3 d<d^2$. The moves stay in the disk and terminate because it has finitely many sites. All sites at distance at most $1/\sqrt3$ are mutually adjacent when distinct, since their separation is at most $2/\sqrt3<\sqrt3$ and the next lattice distance after one is $\sqrt3$.

At a site of positive center-distance $d$, the directions of its neighbors inside the disk satisfy
$$
\cos\theta\ge\frac{d^2+1-R^2}{2d}.
$$
Here $\theta$ is measured towards the center. For $0<d\le R$ the right side increases with $d$ and is at most $1/(2R)\le1/2$. Thus the selected directions form either the whole hexagon or a single circular interval at least $120^\circ$ wide. There are at least two directions, and successive selected neighbors are adjacent. A site at the center has all six neighbors. Each vertex therefore has a connected neighborhood. A cut vertex would have neighbors in two different components of its deletion, which is impossible. Thus $G$ is 2-connected.

Reay and Zamfirescu proved that every finite 2-connected linearly convex triangular grid graph is Hamiltonian except the 13-vertex Star of David $D$ (their Fig. 4). [Original theorem, 2000](https://doi.org/10.1007/s004540010051)

**Apply the theorem.** Suppose an optimal record walk is open. It uses $m+1$ distinct vertices in its minimizing disk. If $R\ge1$ and $G$ is Hamiltonian, the Hamiltonian cycle has at least $m+1$ edges. Taking its first $m+1$ edges (the whole cycle when equality holds) gives a permissible walk in that disk, against the record condition.

If $G=D$, an open walk has at most twelve edges. The embedded exception has a center with all six neighbors and the six outer triangle tips, at distance $\sqrt3$ from that center. Opposite tips force $R\ge\sqrt3$. These coordinates also follow from the graph: the six neighbors of the degree-six center form a wheel, and for each consecutive pair their second common neighbor is the corresponding tip. For an alternative disk, use axial lattice coordinates with squared norm $Q(x,y)=x^2+xy+y^2$. The following cycle closes from the last point back to the first:
$$
(-1,0),(-1,1),(-1,2),(0,1),(0,2),(1,1),(1,0),(2,0),(2,-1),(1,-1),(0,-1),(0,0).
$$
Every edge has squared length one and every vertex lies within squared radius $7/3$ of $(1/3,1/3)$. Its prefixes give a walk of every positive length up to twelve. This contradicts the minimum-radius condition since $7/3<3$.

**Small disks.** If $R<1$, two distinct lattice sites in the same parity class modulo $2$ cannot both fit, because their separation is at least two. There are four parity classes, so an open walk has at most three edges. At $m=2$, its three distinct vertices have mutual distances at least one. Writing $\bar p$ for their centroid and $o$ for the disk center gives
$$
3\le\sum_{i<j}|p_i-p_j|^2=3\sum_i|p_i-\bar p|^2\le3\sum_i|p_i-o|^2\le9R^2 .
$$
A unit equilateral triangle is a three-edge cycle of radius $1/\sqrt3\le R$, violating the record condition. At $m=3$ an open walk has four vertices. They cannot all be pairwise at unit distance in the plane, so some pair is at least $\sqrt3$ apart. But the unit triangular cycle attains length three at the strictly smaller radius $1/\sqrt3<\sqrt3/2$, violating minimality. This exhausts the cases.

This argument applies a published Hamiltonicity theorem. A bounded search for this exact corollary found the OEIS conjecture and the authors’ examples; precedence for the specific application remains unsettled. The derivation does not compute the entire sequence of record radii.
