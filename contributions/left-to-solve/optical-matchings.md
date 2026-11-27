# Six vertices with monochromatic edges

Let the weight of an edge joining vertices i and j in colour c be w(c,ij).
For monochromatic-edge graphs these 45 complex coefficients describe every
matching amplitude on six vertices in three colours. Write F(c) for the
sum of the 15 monochromatic perfect-matching weights. Normalization gives
F(c)=1. Write M(c,e) for the sum of the three two-edge matchings of the four
vertices complementary to the edge e.

For a fixed colour c define t(c,e)=w(c,e)M(c,e). At every vertex v,
the sum of t(c,e) over the five incident edges equals 1, by expanding F(c)
at v. If t(c,e) is nonzero, the edge is private to c among the nonzero
weights. Indeed, for d different from c the colouring that has colour d
on the endpoints of e and c elsewhere has amplitude w(d,e)M(c,e)=0.
Thus w(d,e)=0. Further, F(c)=1 requires at least one perfect matching of
nonzero colour-c weights. There can be no perfect matching containing
one nonzero edge of each colour: the 2+2+2 vertex colouring induced by
those edges has just this one contributing matching, whose product is
nonzero.

The six-by-fifteen unsigned incidence matrix has the all-ones vector in
the span of columns for which t(c,e) is nonzero. Choose an inclusion-minimal
such set B(c): it has at most six edges by linear independence. Every
bipartite component of its graph has equally large sides, since summing
vertex equations over the two sides gives the same edge sum. This holds
over the complex numbers, including for negative or non-real coefficients.
Conversely the only left-null vectors of the unsigned incidence matrix on
a connected graph are constant with opposite signs on opposite sides if
the graph is bipartite, and zero otherwise; hence the component test is
exact (over characteristic zero).

Relabel colours freely and enumerate triples of disjoint minimal supports
B(c). Discard those already containing a rainbow matching. For each
remaining triple extend each B(c) by one chosen monochromatic perfect
matching avoiding the two other private supports, as every actual solution
would allow. Every such extension contains a rainbow matching. The standard
library enumerator computes 15, 90 and 70 minimal supports with 3, 5 and 6
edges respectively, 60 remaining unordered triples, and 960 extensions;
none survives. Thus H1 holds. The standalone verifier uses exact integers,
bit masks and exhaustive enumeration. It is a conventional finite proof,
separate from the Lean verdict on the reduction. This restricted theorem
was already known: A. Cervera-Lierta, M. Krenn, A. Aspuru-Guzik, Quantum 6,
836 (2022), https://doi.org/10.22331/q-2022-10-13-836.

A second enumeration chooses one nonzero perfect matching per colour. There are 3,375 ordered triples of choices and eight orbits under vertex and colour permutations. For each colour, every vector x of vertex labels in {−1,0,1} with positive sum gives a constraint: at least one edge ij with xᵢ+xⱼ ≠ 0 must have nonzero t. This follows by multiplying the six normalized incidence equations by the labels and summing. Keeping the minimal such sets of edges suffices. Applying these constraints, private-edge implications and forbidden rainbow matchings eliminates seven orbits by unit propagation. In the eighth orbit all three chosen matchings share an edge. Its complementary two-edge amplitude in red must vanish, since both endpoints can be coloured blue. Red normalization therefore requires a nonzero red matching avoiding that edge. Each such replacement lies in one of the seven eliminated orbits. [Symmetry replay](replay_optical_symmetry.py)


## Complete six-photon theorem

The exact catalogue declaration now has an end-to-end Lean replay. The runner builds the two public proof files, applies the merged reduction and checks the axiom set of the resulting parent theorem. The only reported axioms are `propext`, `Classical.choice` and `Quot.sound`. In the pair-source perfect-matching model on six vertices, no assignment of complex amplitudes realizes a GHZ state in local dimension three or higher.

The finite monochromatic contradiction is our formalization of a restriction previously established in physics. The rigidity step is an attributed port of Rishi Rajasekaran’s existing proof, including his upstream graph adapter. The contribution is a checked proof of the catalogue target. [Parent theorem replay](https://github.com/shunyaekam/oo-research/actions/runs/45922396593) · [First submitted step](https://github.com/GuillaumeBAUD-coder/open-math-agents/pull/1167) · [Second submitted step](https://github.com/GuillaumeBAUD-coder/open-math-agents/pull/1289) · [Rajasekaran’s original proof](https://github.com/rrajasek95/krenn-conjecture/tree/1db2e5a23d97e3b2d03c30c6d9af773111ec682b)
