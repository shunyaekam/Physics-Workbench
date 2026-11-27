# Boundary-covering loops on a strip of width five

Seiichi Manyama's 2022 conjecture states that the numbers of simple cycles containing every boundary vertex of the rectangular five-by-n square grid satisfy an order-nine recurrence for n ≥ 11. The cycles are unoriented edge sets. Rechoosing the starting vertex leaves the same cycle. [A358696](https://oeis.org/A358696) · [Parent array](https://oeis.org/A333758)

Sweep columns from left to right, cutting the horizontal edges between successive columns. Each selected edge crossing this cut leaves one open tip. Every connected piece to the left of an interior cut is a path between two tips: every selected vertex has degree two when its tips are counted, and any already-completed cycle would be disconnected from the required final-column vertices. Record which rows carry tips and which tips are connected. This pairing contains all information the remainder of the rectangle uses. There are five row positions. The transition can be constructed without assuming any formula for the number of cycles.

For a new column choose a subset of its four vertical edges. At row i let d be the number of these edges incident to i, plus one if i receives a tip from the previous cut. If d exceeds two discard this choice. If d=1 the outgoing horizontal edge is mandatory. If d=2 there is no outgoing edge. If d=0 the vertex must be unused; reject this when the vertex is on the rectangle boundary. The last column has no outgoing edges, so d=1 is forbidden there. To find the new components, join the pairs of incoming tips using the prior state and join the endpoints of the chosen vertical edges. At an intermediate cut, discard any used component without two outgoing tips. With the degree rules, this excludes exactly premature cycles. At the last column accept exactly one connected used component. All vertices of the first and last columns are mandatory, as are the top and bottom rows throughout.

Each choice of vertical edges uniquely determines its outgoing edges. Reading any allowed cycle recovers exactly one history. Conversely every accepting history gives an undirected connected graph with all used vertices of degree two, hence a simple cycle. This proves the transfer counts every admissible cycle once.

Write v0 for the vector of partial counts after the first column, T for the interior-column transition, and f for the final-column count. Then a(n)=f(T^(n−2)v0). In the 20 reachable pairing coordinates, direct exact integer evaluation yields

    (T^9 − 6T^8 − T^7 + 20T^6 − 37T^5 − 16T^4 + 12T^3 + 7T^2 − 5T + I)v0 = 0.

Multiplication by T^(n−11) and application of f prove the proposed recurrence for every n ≥ 11. The first values at n=2 through n=10 are 1, 5, 36, 191, 1123, 6410, 37165, 214515, 1240200. This is an exact finite-width result. The argument uses a standard transfer-matrix method and makes no priority claim for the method or its application.

The independent review re-counted small rectangles by direct path enumeration and checked the source conventions against the authors' tables. [Independent review](boundary-cycle-audit.md) · [Executable proof](replay_boundary_cycles.py)
