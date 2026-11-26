# Independent analytic review of the two-exception family

25 November 2026 (Toronto). Second AI agent, same project. The proposed theorem is supported for equal qubit registers whose ambient Schmidt list contains at most two exceptions to a common amplitude. Amplitudes may vanish and the exceptions may lie on either side of the common value. This is a partial result for the index-two nonlocal stabilizer Rényi problem.

## Derivation

Work on the four-particle exterior power for $d=2^n\ge8$. In a basis containing orthogonal outlier modes $u,v$, their commuting occupation projections have eigenvalues zero and one. For background $a$ and anomalies $b,c$, the four-wedge eigenvalue according to these occupations is respectively $a^4,a^3b,a^3c,a^2bc$. The unique multilinear interpolant therefore has constant term $a^4$, linear coefficients $a^3(b-a),a^3(c-a)$, and mixed coefficient $B=a^2(b-a)(c-a)$. This derivation uses no division by an amplitude.

Write $P$ for Sierant's projector, $q=4/d$, $R=(d-1)(d-2)/6$ for its rank, and $K=P n_u n_v P$. Uniform single-mode occupation gives $P n_uP=P n_vP=qP$. Since $0\le n_un_v\le n_u$, $0\le K\le qP$. The unnormalized two-particle reduction of $P$ is scalar by the disjoint-parallel-plane argument, so $T=\mathrm{Tr}\,K=q(d-2)/2$ for arbitrary complex orthonormal $u,v$. At a coordinate pair, each direction contributes either zero or a single containing plane with weight $q$. Exactly $(d-2)/2$ directions occur, thus $K^2=qK$.

Set $A=a^4+qa^3(b+c-2a)$. The antisymmetric squared norm in Eq. 40 is $RA^2+2ABT+B^2\mathrm{Tr}(K^2)$. Its only variable coefficient is the nonnegative square $B^2$, so $\mathrm{Tr}(K^2)\le qT$ proves the maximum is attained at any coordinate pair. Applying the same expansion to squared amplitudes shows that the trace overlap in Eq. 41 is the constant $R A(a^2,b^2,c^2)+T B(a^2,b^2,c^2)$. The nonnegative defect vanishes on the sorted computational diagonal. The all-rank Proposition 2 and the two-to-one-unitary Lemma 1 now prove the claimed optimum. For $d=4,2$ Sierant already covers all spectra. Enlarging unequal registers by padding with many zeros need not preserve this family's hypothesis. [Sierant, Sections III–V and Appendix C](https://arxiv.org/html/2609.13106v2)

## Exact normalization checks

An independent integer Walsh–Hadamard evaluator summed all $d^4$ Hermitian Pauli fourth moments at the computational state. Raw amplitudes were normalized by their Euclidean norm. Each finite sum matched the expression obtained by inserting $Q=RA^2+2ABT+B^2qT$ and the constant trace overlap into Eq. 42.

| Local dimension | Raw amplitudes, repetitions shown | Exact optimal stabilizer purity |
| --- | --- | --- |
| 8 | six 2s, 1, 0 | 228673/390625 |
| 16 | fourteen 2s, 1, 0 | 2576747/3518667 |
| 16 | 3, fourteen 2s, 1 | 350123/395307 |

## Priority and overlap

When both exceptional amplitudes lie above the background, the sorted list has nonincreasing steps at the first and second positions. Sierant's dyadic-staircase theorem already covers that region. An exception below the common amplitude may split the last shell. Fourteen 2s followed by 1 and 0 in dimension 16 give rank 15 and split the last shell, escaping both the dyadic and low-rank theorems. Relabeling both exceptional entries to the first two positions would remove sortedness and can make Sierant's nonnegative-increment argument inapplicable. The closed-form solution of Viscardi, Leone and Hamma concerns log-stabilizer fidelity, a different objective. Searches against the parent paper, nonlocal stabilizer entropy, two-outlier spectra and rank-seven results returned no prior proof of the full stated family. Publication priority and independent external peer review remain open. [Sierant, Section IV.1](https://arxiv.org/html/2609.13106v2#S4.SS1) · [Liu and Cui](https://arxiv.org/abs/2607.10714) · [Viscardi, Leone and Hamma](https://arxiv.org/abs/2609.04119)
