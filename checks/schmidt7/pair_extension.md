# An all-dimension pair bound with a stabilizer direction

Let the one-particle labels be the elements of the binary vector space of size
$d=2^n$. Use the projector $\Pi$ and scaling $q=4/d$ of the
[rank-seven note](../../papers/schmidt-rank-seven.tex). Fix orthonormal vectors
$x,y,s_1,\dots,s_m$. If $\operatorname{span}(x,y)$ contains a stabilizer state, then

$$
\frac1q\sum_{a<b}\|\Pi(x\wedge y\wedge s_a\wedge s_b)\|^2
\le \lfloor m/2\rfloor.
$$

In particular the bound is two for the five spectator orbitals in the rank-seven problem. The spectator subspace is arbitrary and may have complex amplitudes. This is a restricted frame inequality. The distinguished span of a general frame need not contain a stabilizer state.

## Proof

A unitary change within the distinguished plane changes its wedge by a phase.
The Clifford group maps its stabilizer direction to the computational vector
$e_0$. It preserves $\Pi$ because it permutes the fourfold Pauli summands
in the stabilizer projector and preserves the antisymmetric sector.
We may therefore set $x=e_0$, with all other orbitals orthogonal to $e_0$.

In the coordinate formula for $\Pi$, only the plane containing $0$ can
contribute within each family of parallel affine planes. Deleting $0$
leaves a triple $G=\{i,j,i\oplus j\}$ of nonzero labels. Call the resulting
family $\mathcal G$. A pair of distinct nonzero labels belongs to exactly one
such triple. Let $S=\operatorname{span}(s_1,\ldots,s_m)$ and
$T=S\oplus\mathbb C y$. For a subspace $V$ define
$F(V)=\sum_{G\in\mathcal G}\det P_V[G,G]$ with $P_V$ its orthogonal
projection. Cauchy–Binet expands each summand as a sum of squared
three-orbital minors. Subtracting $F(S)$ from $F(T)$ keeps precisely
the minors involving $y$ and two spectators. Expanding the four-orbital
minor in its $e_0$ column shows that this difference equals the left
side of the asserted inequality.

Sample a set $J$ of $\dim V$ coordinates with probability equal to the
squared modulus of its coefficient in the normalized top wedge of $V$.
For any $G$, the probability that $J$ contains $G$ equals
$\det P_V[G,G]$. Indeed, summing squared coefficients over supersets of
$G$ gives the squared norm of successive contractions by the coordinate
vectors of $G$. In an orthonormal orbital basis this norm is the sum of the
squared $|G|$-orbital minors on $G$, which is the determinant by Cauchy–Binet.
Thus $F(V)$ is the expected number of triples contained in $J$.

The samples for $S\subset T$ can be coupled as $I\subset J$. Here is a
finite proof. Write $s$ for the normalized top wedge of $S$,
$t=y\wedge s$ for that of $T$. The exterior contraction $\iota_y$
has operator norm one and $s=\iota_y t$. If $A$ is a family of
$m$-sets, let $N(A)$ consist of the $(m+1)$-sets containing a member
of $A$. Projection onto the coordinates in $A$ satisfies
$P_A\iota_y=P_A\iota_y P_{N(A)}$. Consequently
$\|P_A s\|^2\le \|P_{N(A)}t\|^2$. These are exactly the
weighted Hall inequalities for transporting the first probability law to
the second along containment edges. To see sufficiency, join a source
to each $m$-set with capacity its probability, each inclusion edge with
capacity two, and each $(m+1)$-set to a sink with capacity its probability.
Any cut retaining the left family $A$ on the source side has capacity at
least one, since it either cuts an inclusion edge or retains all its
neighbors. A unit flow supplies the coupling.

Under this coupling, $J$ adds one site $v$ to $I$. Every new triple
must contain $v$. The pairs completing a triple with $v$ are disjoint,
since a second site uniquely determines the third. At most
$\lfloor m/2\rfloor$ disjoint pairs fit in $I$. Taking the expected
increase proves the bound.

## Sharpness and replay

For $m=5$, take coordinates $x=e_0$, $y=e_1$ and the spectators
$e_2,e_3,e_4,e_5,e_6$. The two completed triples through $1$ use
pairs $(2,3)$ and $(4,5)$. Run
`python3 checks/schmidt7/pair_extension.py` to compare the four-orbital
projector formula with the difference of occupation sums on complex frames,
also after a Clifford change and a rotation within the distinguished span.
