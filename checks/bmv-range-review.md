# Independent coefficient review of the refined BMV range

**Verdict — independent replication.** Omega Institute’s earlier public three-spectrum theorem covers every positive first degree, three second factors and any finite dimension with at most three distinct eigenvalues of the first matrix, with arbitrary multiplicities. Every case checked here falls under that theorem. The panel earns zero new-resolution credit. [Prior theorem and Lean declarations](https://github.com/the-omega-institute/trureturing/blob/a419d0b6a650c965338c3db874b17e8143b6dea3/Blueprint/D5/S3/Quantum/Analysis/RefinedBMVThreeSpectrumCertificate.md)

I reconstructed the sufficient polynomial in Hägele’s Lemma 6 for every integer $11\le n\le36$, three second factors, and dimension three. Its 1,670,650 nonzero coefficients across the 26 degrees are positive integers. Every other coefficient is zero. In conjunction with Hägele’s analytical reduction this proves the stated lower bound for arbitrary complex positive semidefinite $3\times3$ matrices, including singular ones, at each listed degree. The 3 × 3 panel gives a separate finite coefficient certificate for a consequence of that earlier theorem. [Original problem](https://oqp.iqoqi.oeaw.ac.at/refinement-of-the-bessis-moussa-villani-conjecture/) · [Hägele, Lemmas 5 and 6](https://arxiv.org/html/2611.00129v1#S4)

## Reconstruction

1. Scale Hägele’s composition deficit by $N=\binom{n+2}{2}$. It becomes $F(a,b,c)=h_n(a,b,c)-N(abc)^{n/3}$, where $h_n$ sums all monomials of total degree $n$ with coefficient one. I obtained $h_n$ independently as the second divided difference of $z^{n+2}$. Indeed the first divided difference at $a,b$ is the sum of all monomials in $a,b$ of degree $n+1$. Subtracting the corresponding expression at $b,c$ and dividing by $a-c$ yields $h_n$. At a repeated argument the first divided difference is $(n+2)a^{n+1}$. Every division of polynomials in the checker verifies a zero remainder.
2. Put $e=1$ when three divides $n$, and $e=3$ otherwise. Write the three eigenvalues as $u^e,(u+v)^e,(u+v+w)^e$ with $u,v,w\ge0$. This covers the ordered spectrum, including repeated levels, and makes the balanced term an ordinary monomial in the three roots. The primary checker sets the *first gap* $v$ to one. I set the *base* $u$ to one and kept both gaps as independent polynomial variables. The homogeneous degree before dehomogenization is $6en$. Thus the exponents of $v,w$ determine the missing exponent of $u$ term by term, also covering $u=0$.
3. With $X=F(a,a,c)$, $Y=F(b,b,c)$, $Z=F(a,b,c)$, set $R=XY$, $S=X+Y$, and $Q=F(b,b,a)F(c,c,a)+F(a,a,b)F(c,c,b)$. I constructed the certificate as $(QZ^2-(Z^2-R)^2)S^2+4QR(ZS+R)$. Expanding $(ZS+2R)^2$ identifies this expression with the source’s polynomial scaled by $N^6$. The checker independently evaluates the original difference of squares with literal integer composition sums on four pairs of gaps per degree. These tests include both repeated-level boundaries, an ordinary interior point, and a signed point outside the physical cone.
4. Restoring the omitted exponent yields the canonical triples (base exponent, second-gap exponent, integer coefficient). I compared SHA-256 digests of the full sorted lists against the primary implementation, exposing its final polynomial before its coefficient-summary call. Both reconstructions used FLINT integer polynomial arithmetic. They used different polynomial coordinates, different methods for computing the complete homogeneous functions, and different groupings of the final expression.

The finite coefficient certificates imply nonnegativity throughout the continuous ordered eigenvalue cone. Hägele’s trace expansion and pairing bound then give
$$
 \frac{1}{\binom{n+3}{3}}\sum_{W}\operatorname{tr}W(A,B)
 \ \ge\ \operatorname{tr}\big[(A^{n/3}B)^3\big].
$$
The sum has one term per distinct word with $n$ letters $A$ and three letters $B$. Positive semidefinite fractional powers include eigenvalue zero. The matrix reduction and the exponential corollary are analytical. This internal computational replication confirms the finite panel. The general three-spectrum theorem cited above has priority over the panel. [Source, Sections 2–4](https://arxiv.org/html/2611.00129v1#S2)

## Replay

The review used python-flint 0.9.0 and FLINT 3.6.0. The default command prints one line per degree containing the degree, support size, minimum positive coefficient and SHA-256 digest of the complete canonical coefficient list. The SHA-256 digest of the 26-line UTF-8 output, including its final newline, is `9df61c1103223bfe73bb089c1469c2b4bd74ebc42e46d32a9b30c511a9ac1e6f`. [Independent checker](bmv_range_review.py) · [Primary checker](bmv_degrees.py)

```sh
uv run --with python-flint==0.9.0 python checks/bmv_range_review.py
```

| First degree | Nonzero terms | Smallest coefficient | First degree | Nonzero terms | Smallest coefficient |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 11 | 18,578 | 2,496 | 24 | 9,722 | 10,400 |
| 12 | 2,324 | 2,912 | 25 | 97,391 | 11,232 |
| 13 | 26,057 | 3,360 | 26 | 105,383 | 12,096 |
| 14 | 30,269 | 3,840 | 27 | 12,359 | 12,992 |
| 15 | 3,701 | 4,352 | 28 | 122,312 | 13,920 |
| 16 | 39,638 | 4,896 | 29 | 131,249 | 14,880 |
| 17 | 44,795 | 5,472 | 30 | 15,311 | 15,872 |
| 18 | 5,393 | 6,080 | 31 | 150,068 | 16,896 |
| 19 | 56,054 | 6,720 | 32 | 159,950 | 17,952 |
| 20 | 62,156 | 7,392 | 33 | 18,578 | 19,040 |
| 21 | 7,400 | 8,096 | 34 | 180,659 | 20,160 |
| 22 | 75,305 | 8,832 | 35 | 191,486 | 21,312 |
| 23 | 82,352 | 9,600 | 36 | 22,160 | 22,496 |
