# Counting walks of every strip length with a finite proof

A self-avoiding walk on a rectangular grid is a nearest-neighbor path that visits each vertex at most once. There are two different counting problems here. We prove the proposed recurrence and generating function in each case. The strip widths are fixed.

| Problem | Paths counted | Initial counts | Recurrence order |
|---|---|---|---:|
| [A333686](https://oeis.org/A333686), Seiichi Manyama | Opposite corners of a three-row, $2n+1$-column grid, through its center | $1,10,101,1105,12046,131399$ starting at $n=0$ | 6 |
| [A216211](https://oeis.org/A216211), Toby Gottfried; formulas proposed by Colin Barker | NW to SW corner of an $n$-row, four-column grid | $1,4,28,178,1008,5493$ starting at $n=1$ | 12 |

## Encoding a path

Rotate the four-column problem so that layers are traversed from left to right. Append a temporary edge entering the start and another leaving the destination. All used grid vertices now have degree two. When the endpoints coincide, these two edges can meet at the same vertex, giving the unique empty walk.

Cut between two consecutive layers. The part of a completed path to the left of this cut consists of disjoint paths. One starts at the external source and has one tip at the cut. Every other path joins a pair of tips. Store the occupied rows, the tip belonging to the source and the pairing of the others. At the initial cut there is just the source tip. At the final cut we require just that tip in the destination row.

To add a layer, enumerate its vertical-edge subsets. At each vertex, add the number of chosen vertical edges to the number of incoming edges. Degree one forces an outgoing edge, degree two forbids it, degree zero leaves the vertex unused, and degree greater than two is rejected. At a required center vertex degree zero is rejected as well. Joining the old pairs to the chosen edges produces the pairing at the new cut. Discard a component unless it has one outgoing tip when attached to the source, or two otherwise. A detached completed cycle can never rejoin a simple path.

These rules are reversible on an accepted configuration. Its vertical-edge subsets and the initial state determine every horizontal edge uniquely. Conversely, an accepting history is connected through the unique source component at the final cut. Its used vertices all have degree two after adding the artificial end edges, and detached cycles have been excluded throughout. Removing the artificial ends gives the desired simple path. This establishes the counting interpretation independently of the proposed formulas.

## Why finitely many exact calculations prove statements for all lengths

Let $T$ be the ordinary layer transition and $M$ the central layer transition that requires the middle vertex. Write $u$ for the incoming source state and $f$ for selection of the single outgoing destination tip. All matrices have integer entries.

For A216211 the count is $a(n)=fT^nu$. Closing ordinary transitions from the initial state yields exactly 12 states. Its proposed recurrence for $n\ge13$ has lag coefficients

$$
(12,-54,124,-133,-16,175,-94,-69,40,12,-4,-1).
$$

The residual (left side minus right side) is itself an output of powers of the same 12-dimensional matrix, with an adjusted initial vector. Cayley–Hamilton therefore gives a monic recurrence of order 12 for the residual. Its first 12 terms, from $n=13$ through $24$, are exactly zero, as the replay computes. Every later residual is zero.

For A333686 the count is $b(n)=fT^nMT^nu$. There are five reachable states and the marked-layer choices form a subset of ordinary choices. On the 25-dimensional space of five-by-five matrices, increasing $n$ acts linearly by $B\mapsto TBT$. Start with $B=M$. The residual of the proposed order-six recurrence has the same fixed 25-dimensional description. Its lag coefficients are

$$
(10,10,0,-10,-10,1).
$$

All 25 residuals from $n=6$ through $30$ are zero by exact arithmetic, so Cayley–Hamilton gives zero at every later index. For each problem, multiplying the generating series by the reciprocal recurrence polynomial now leaves a numerator determined by the initial values. The replay checks both that numerator and the complete factored denominator against the respective source, coefficient by coefficient. A separate check directly walks small grids, with no transfer states.

## Scope and attribution

This is an application of transfer matrices to two finite-width lattice models. Beckmann already used related calculations for the distinct four-row problem A214931. Its endpoint placement differs and its recurrence has order five. Historical priority for the two applications above has not been established. [Related calculation](https://oeis.org/A214931) · [Executable proof](replay_strip_paths.py)
