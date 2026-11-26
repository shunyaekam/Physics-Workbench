# A two-eigenvalue case of both refined BMV bounds

**Scope.** Let $A,B$ be complex positive semidefinite matrices of any finite size. If $A$ has at most two distinct eigenvalues, then for all positive integers $n,m$ the normalized mean $M$ over the traces of the $\binom{n+m}{m}$ words with $n$ copies of $A$ and $m$ copies of $B$ obeys
$$
\operatorname{Tr}\big[(A^{n/m}B)^m\big]\ \leq\ M\ \leq\ \operatorname{Tr}(A^nB^m).
$$
The two eigenvalues may have arbitrary multiplicities and may include zero. For $A=e^H,B=e^K$, Hägele’s Lemma 2 gives the partition-function lower bound $\operatorname{Tr}e^{nH+mK}\le M$. The argument below is a corollary of Hägele’s composition formula and Stahl’s original BMV theorem, in the coefficient formulation of Lieb and Seiringer. Historical priority for this specific combination requires a separate assessment. [Hägele, §§2–3](https://arxiv.org/html/2611.00129v1#S2) · [Lieb–Seiringer](https://arxiv.org/abs/math-ph/0210027) · [Stahl](https://arxiv.org/abs/1107.4875)

### Grouping the spectral paths

When $A$ is scalar every comparison is equality. Otherwise write $A=aP+bQ$ with complementary orthogonal spectral projections. Put $C=B^{1/2}PB^{1/2}$ and $D=B^{1/2}QB^{1/2}$. They are positive semidefinite and $C+D=B$. Set
$$ w_j=[z^j]\operatorname{Tr}(C+zD)^m,\qquad 0\le j\le m.$$
Stahl's theorem implies $w_j\ge0$ for each $j$. Expanding the matrix polynomial before taking the trace shows that $w_j$ sums all ordered products with exactly $j$ letters $D$. Cyclicity pairs the adjacent square roots of $B$ in each such product, including the first and last factors. This identifies the same weight with the sum of the traces of the corresponding $P,Q$ block paths interspersed with $B$. There is no normalization by $\binom mj$ in $w_j$.

The word mean is the mean of $\operatorname{Tr}(A^{c_1}B\cdots A^{c_m}B)$ over all weak compositions $c_1+\cdots+c_m=n$. There are $N=\binom{n+m-1}{m-1}$ such compositions. For the normalization, mark one of the $m$ occurrences of $B$ in a length-$(n+m)$ word and cyclically move the mark to a chosen initial slot. The marked word is determined by its $m$ gaps and the original position of the mark. Thus there are $(n+m)N=m\binom{n+m}{m}$ marked words, with identical trace under the move. This argument also counts periodic words correctly.

For a profile $v=(v_1,\ldots,v_m)$ with $m-j$ copies of $a$ and $j$ copies of $b$, set
$$ K_j=\frac{1}{N}\sum_{c_1+\dots+c_m=n}\prod_{i=1}^m v_i^{c_i}.$$
Symmetry of the composition set makes this independent of the order of $v$. Expanding each $A^{c_i}$ spectrally and then grouping by the number of $Q$ slots gives the identity $M=\sum_j w_j K_j$.

### Two scalar bounds give both matrix bounds

The mean exponent in each slot under a uniform weak composition is $n/m$. AM–GM over compositions therefore gives $K_j\ge L_j=\prod_i v_i^{n/m}$. Another application of weighted AM–GM to a single composition gives $\prod_i v_i^{c_i}\le\sum_i(c_i/n)v_i^n$. Averaging gives $K_j\le U_j=((m-j)a^n+jb^n)/m$. These inequalities extend from positive $a,b$ by continuity with $0^0=1$ in the polynomial; factors with zero exponent are omitted.

The coefficient comparison can now be summed since all $w_j$ are nonnegative. The lower sum is the trace of $(a^{n/m}C+b^{n/m}D)^m$, which by cyclicity is $\operatorname{Tr}[(A^{n/m}B)^m]$. For the upper sum, evaluate the polynomial defining $w_j$ and its first derivative at $z=1$. This gives $\sum_j w_j=\operatorname{Tr}B^m$ and $\sum_j j w_j=m\operatorname{Tr}(DB^{m-1})$. Substitution yields
$$
\sum_j w_j U_j
 =\operatorname{Tr}[(a^n C+b^n D)B^{m-1}]
 =\operatorname{Tr}(A^nB^m).
$$
Every step works when $B$ is singular. Swapping the letters gives the upper and partition-function lower bounds when the *second* matrix alone has at most two spectral values. In that orientation the explicit balanced product lower bound reads $\operatorname{Tr}[(B^{m/n}A)^n]$.

### Exact challenge and prior scope

For $A=\operatorname{diag}(1,1,2,2)$, consider the positive definite matrix
$$
 B=\begin{pmatrix}100&190&2&0\\190&400&0&1\\2&0&100&-190\\0&1&-190&400\end{pmatrix}.
$$
At $n=12,m=6$ the ordered block trace for labels $(0,0,1,1,0,1)$ is $-41{,}000$. The sum of traces over all words with three visits to each block is $65{,}135{,}808{,}130$. The exact checker verifies positive definiteness, reconstructs all grouped coefficients, and independently computes the original word sum by noncommutative multiplication. It obtains strictly positive gaps on both sides. Replay with `python3 checks/bmv_blocks.py`. [Exact check](bmv_blocks.py)

For $m=3$ each binary block trace is individually nonnegative. After cyclic rotation it is the trace of either a positive diagonal block cubed, or a product of that block with $B_{ij}B_{ij}^{*}$. This simpler case is already included in a public theorem for up to three spectral values of $A$, arbitrary multiplicities, all positive $n$ and exactly three copies of $B$. In particular, that prior result also includes the workbench’s separate $(12,3)$ certificate in dimension three. [Versioned theorem statements](https://github.com/the-omega-institute/trureturing/blob/51dca4f1542baa532983864568d6a8ca3470e745/D5/S3/Quantum/Analysis/RefinedBMVThreeSpectrumCertificate.lean#L42-L57)
