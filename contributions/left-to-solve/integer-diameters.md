# Integer diameters on the triangular lattice

For every integer $n\ge2$, the maximum segment count of a self-avoiding walk (cycles allowed) in a disk of diameter $n$ is the maximum number of triangular-lattice sites in such a disk. These are A122226 and A125852 in their published integer index. [Walks](https://oeis.org/A122226) · [Point counts](https://oeis.org/A125852)

A disk of fixed diameter contains at most finitely many sites uniformly in its center. This follows by packing open radius-$1/2$ circles at these sites and comparing areas within the concentric disk enlarged by $1/2$. Some placement therefore achieves the largest integer site count. Its induced graph is 2-connected and linearly convex by the disk-graph argument for A346126. It consequently has a Hamiltonian cycle unless it is the 13-vertex Star of David. [Reay and Zamfirescu’s theorem](https://doi.org/10.1007/s004540010051)

For diameters $2$ and $3$, opposite tips of that exceptional graph are $2\sqrt3$ apart, too far to fit. For integer diameters $n\ge4$ the disk centered at a lattice site already contains its center, six neighbors at distance one, six at $\sqrt3$, and six at two. A maximizing disk therefore has at least 19 sites, excluding the exception. Its Hamiltonian cycle realizes one segment per site. Every open walk of $m$ segments uses $m+1$ distinct sites, and every simple cycle of $m$ segments uses $m$ distinct sites, giving the converse upper bound.

The conjecture about equality of the two **integer-indexed sequences** follows. Extending this statement to every real diameter would introduce a different question. The proof makes no assertion of priority for the integer-diameter corollary.
