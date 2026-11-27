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
