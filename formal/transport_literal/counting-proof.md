# A local proof of the all-cycles counting bound

Let a closed walk have length k. For a level interval I, write h(I) for the number of downward edges spanning I minus the number of upward edges spanning I. Fix any interval J = [c,d] of positive width and a finite family of intervals with pairwise disjoint sets of strictly interior level indices. Then

$$2h(J)+\sum_I\max(0,h(I))\ \leq\ k.$$

The walk may repeat vertices. J need not maximize demand. A three-site walk 0 → 1 → 2 → 0, with J = [0,2] and family {J}, attains equality. Thus the factor two cannot increase. The proof below establishes the counting step required in oo research’s proposed formula for the distance between finite-spectrum quantum transport costs.

Discard all family members with nonpositive demand. For an increasing edge u < v, write s(I) = 1 when [u,v] contains I, and zero otherwise. We will fit its cost

$$D(u,v)=2s(J)+\sum_I s(I)$$

by a scalar difference to within one. All constructions below use the endpoints of the intervals alone.

Assign a label to each site t. Begin with one unit if t ≥ d. For each ordinary interval I = [a,b] add one more contribution as follows.

* If a < c and d < b, use the indicator of t > c.
* Otherwise, use the indicator of a < t when t < d and of b ≤ t when t ≥ d.

Let Y(t) be the sum. An ordinary interval's error is its label increment from u to v minus s(I). In each row of the following table every ordinary error has the indicated sign. A nonzero error can arise only if the indicated site lies strictly inside the ordinary interval. Disjointness therefore bounds their combined magnitude by one.

| Edge position | Distinguished term’s error | Ordinary errors | Charged site |
|---|---:|---|---|
| v < d | 0 | 0 or +1 | v |
| d ≤ u | 0 | 0 or +1 | u |
| u ≤ c and d ≤ v | −1 | 0 or +1 | c |
| c < u < d ≤ v | +1 | −1 or 0 | u |

For example, on an edge crossing the pivot d, the increment for a nonenclosing interval is the indicator of b ≤ v minus the indicator of a < u. After subtracting s(I), this equals −1 precisely when both u and v are strictly inside I. If the edge spans J, such an interval would strictly enclose J, so that case is impossible. The enclosing-interval rule then provides the only possible positive error. The Lean proof checks every endpoint ordering, including equalities.

In all four cases |Y(v)−Y(u)−D(u,v)| ≤ 1. Orienting the costs with positive sign downwards and negative sign upwards, each directed edge has cost at most 1 + Y(start) − Y(end). Self-loops have zero cost. Summing around the walk cancels the labels and proves the bound.

**Verification and scope.** The reference is the pre-existing [counting statement](Counting.lean). [CountingProof.lean](CountingProof.lean) proves it through the stronger arbitrary-walk theorem; [VerifyCounting.lean](VerifyCounting.lean) separately checks the interface and sharpness example. [Replay](counting_replay.py) compiles all three files from scratch under Lean 4.19.0, requests trust-zero import checking, audits axioms, and confirms that a false strengthened coefficient is rejected. The paper also needs the interval-covering argument, feasibility of line potentials, and the operator reduction. The kernel result here covers the counting step.

**Source check, 25 November 2026.** The [author’s manuscript](https://github.com/ipitchford/quantum-transport-cost-cones/blob/270f5dba795ffd73d271bfde959237b730227c5e/manuscript.tex#L521-L565) still poses Conjecture 7.7. The upstream default branch remained at that commit and its public issue list was empty when checked. The [release](https://www.evidencepress.org/releases/quantum-transport-cost-cones/) still describes the general case as open. A search for the author, title and polygon condition found the source release and related results. This limited search leaves independent priority unresolved.
