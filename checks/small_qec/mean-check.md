# The total weight of eight weight-optimal checks

Working proof for [issue 24](https://github.com/shunyaekam/oo-research/issues/24). Wei et al. propose investigating average versus maximum generator weight in [their Discussion](https://arxiv.org/html/2601.19848v2#S8). The finite question here is ours.

For a binary [[12,4,4]] stabilizer code with an independent generating basis of maximum weight at most seven, the minimum total basis weight is 54, or 6.75 per check. Count a physical qubit once for each generator touching it.

**Upper bound.** The existing eight generators in twelve-four.json have weights 6,6,7,7,7,7,7,7. The string checker verifies independence, commutation and distance exactly four.

**Lower bound.** An all-even group has at most six nonidentity words of weight at most six by the distance-four enumerator certificate. It cannot supply eight even basis words under a cap of seven. In the mixed case let A_j count all stabilizers of weight j and let T_6 be their nonidentity count through weight six. The same exact certificate gives

    T_6 + 19 A_1 + 6 A_2 + 10 A_3 + 3 A_4 + 2 A_5 ≤ 2.

Compare a basis with eight hypothetical weight-seven checks. A basis word of weight j≤6 saves 7−j touches. For each such weight the left-hand coefficient is at least 7−j. The sum counts all group words and the basis elements are distinct. Hence the total saving is at most two. Both bounds give 54. The proof allows degenerate codes. The cap on the largest check is essential to the question.

Run `python3 checks/small_qec/mean_check.py` to replay the identity, coefficient inequalities and construction. This is a corollary of the previous result and uses the same witness. Independent mathematical review and a dedicated priority audit are outstanding.
