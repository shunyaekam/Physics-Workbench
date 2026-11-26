# One next problem: Hägele's refined partition-function inequality

25 November 2026. **Replication of a prior result.** The pinned public archive proves the three-second-factor bound in every positive first degree when the first matrix has at most three distinct spectral values, in any finite dimension. This subsumes the entire finite-degree calculation below. The initial search stopped after locating a degree-limited module. A review of the broader repository found the stronger theorem. [Exact prior theorem](https://github.com/the-omega-institute/trureturing/blob/51dca4f1542baa532983864568d6a8ca3470e745/D5/S3/Quantum/Analysis/RefinedBMVThreeSpectrumCertificate.lean#L42-L57)

**Original selection:** dimension three, twelve copies of the first matrix and three copies of the second. We obtained an exact positive-coefficient certificate for every input in that case. This is a restricted result for the lower-bound half of IQOQI problem 40. This case now serves as a reproducibility check.

## The source and the scope

Daniel Hägele asks whether the mean trace of all words containing $n$ letters $e^H$ and $m$ letters $e^K$ dominates $\operatorname{Tr}e^{nH+mK}$ for arbitrary Hermitian $H,K$. The Vienna catalogue attributes the conjecture to Hägele, communicated by R. F. Werner. This inequality compares a symmetrized noncommutative product with a quantum partition function. Hägele's October 2026 manuscript gives a sufficient polynomial criterion in dimension three for every $n$ when $m=3$ and verifies it for $n=3,4$. We selected $n=12$ because the fractional exponent $n/3$ becomes an integer and the case extends beyond the degree range of a later public proof. [IQOQI problem 40](https://oqp.iqoqi.oeaw.ac.at/refinement-of-the-bessis-moussa-villani-conjecture/) · [Open Quantum Problems M14](https://open-quantum-problems.vercel.app/p/M14) · [Hägele, Lemmas 2, 5 and 6](https://arxiv.org/html/2611.00129v1)

A later public Lean project reports the three-second-factor bound for first degrees five through ten in all finite dimensions. Its result supersedes several small cases that the catalogue still describes as open. This module stops short of twelve, but another module in the same repository covers arbitrary first degree and up to three spectral values. Cha and Lee refute the *upper* bound, and Dinh, Le and Vuong study a different lower bound against a spectral pinching. Searching by word counts alone missed the stronger three-spectrum result. The reduction, pairing argument and polynomial criterion here all belong to Hägele. The numerical choice of word counts was ours. [Later three-factor proofs](https://github.com/the-omega-institute/trureturing/blob/a419d0b6a650c965338c3db874b17e8143b6dea3/Blueprint/D5/S3/Quantum/Analysis/RefinedBMVExtremeAnalytic.md) · [Cha and Lee](https://arxiv.org/abs/2603.19927v6) · [Dinh, Le and Vuong](https://arxiv.org/abs/2610.31851)

## Exact certificate

For positive semidefinite complex $3\times3$ matrices $A,B$, write $M$ for the mean of the traces of all $\binom{15}{3}=455$ words with twelve $A$ and three $B$. The result is $M\ge\operatorname{Tr}[(A^4B)^3]$. With $A=e^H$ and $B=e^K$, Hägele's Lemma 2 then implies the requested $M\ge\operatorname{Tr}e^{12H+3K}$.

Use the scaled deficit
$$
F(a,b,c)=\sum_{i+j+k=12}a^ib^jc^k-91(abc)^4
$$
with nonnegative integer exponents. It is $91\Delta_{12}$ in Hägele's notation. For ordered eigenvalues $0\le a\le b\le c$, put $X=F(a,a,c)$, $Y=F(b,b,c)$, $Z=F(a,b,c)$ and define
$$
Q=F(b,b,a)F(c,c,a)+F(a,a,b)F(c,c,b),\quad D=Z^2-XY,\quad T=Z(X+Y)+2XY.
$$
Hägele's Lemmas 5 and 6 reduce the claimed trace comparison to the nonnegativity of $P=QT^2-D^2(X+Y)^2$. Their criterion uses the largest eigenvalue scaled to one. Here $P$ is homogeneous of degree 72, so its sign is invariant under any positive common rescaling. Replacing each $\Delta$ by $91\Delta$ also preserves its sign, since it multiplies $P$ by $91^6$.

For $b>a$, divide the three eigenvalues by $b-a$. They become $(x,x+1,x+1+t)$ where $x,t\ge0$. Direct integer polynomial multiplication gives **2,324 nonzero coefficients** in $P(x,x+1,x+1+t)$, **zero negative coefficients**, and smallest nonzero coefficient **2,912**. Thus $P\ge0$ on the entire ordered cone with $b>a$. Continuity covers $a=b$, including the origin, and permutation of eigenvalues covers the unsorted case. This is an exhaustive algebraic check of a sufficient inequality, not sampling of matrix pairs. [Source criterion in Section 4](https://arxiv.org/html/2611.00129v1#S4)

The standard-library Python checker reconstructs the polynomial directly from the composition sum. A second computation using FLINT's multivariate integer polynomials independently produced the same count, sign and minimum. Run `python3 checks/next_intake_bmv.py` from the research branch. A separate reviewer checked the transcription and the implication in the [mathematical review](../../checks/bmv-review.md). [Replay the certificate](../../checks/next_intake_bmv.py)

The unrestricted word-count result for a binary spectrum uses a different argument based on the original BMV coefficient theorem. The [working paper](../../papers/bmv-trace-12-3.pdf) includes the finite computations as independent reproduction. [Binary-spectrum review](../../checks/bmv-blocks.md) · [Priority search](bmv-block-priority.md)
