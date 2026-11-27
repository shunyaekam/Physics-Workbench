# A sheared Floquet discriminant for an even periodic potential

For a real, continuous, one-periodic potential $V$ symmetric about $x=1/2$, the answer to [MathOverflow 283077](https://mathoverflow.net/questions/283077) is yes. For real $\alpha$ set $f(z)=y_1(1,z)+\alpha y_2(1,z)$, with the initial data in the question. Then $f'(z)\ne0$ whenever $|f(z)|<1$. The prime here means differentiation in the spectral parameter. This conclusion holds for complex as well as real spectral parameters when $V$ is real. The original question has the real-analysis and quantum-mechanics tags and explicitly specifies real $\alpha$, but does not specify the codomain of $V$. The real-potential assumption is essential. A smooth complex even potential gives a counterexample below.

**The transfer matrix.** Write $U(x,z)$ for the matrix whose columns are $(y_j(x,z),\partial_x y_j(x,z))^T$, and set $M=U(1,z)$. The Wronskian gives $\det U=1$. Reflection about $1/2$ reverses the derivative, so $RMR=M^{-1}$ for $R=\operatorname{diag}(1,-1)$. Comparing diagonals shows $M_{11}=M_{22}$. With the real shear
$$
S=\begin{pmatrix}1&0\\2\alpha&1\end{pmatrix},\qquad A=SM,
$$
we therefore have $\det A=1$ and $f=\tfrac12\operatorname{tr} A$. Physically the shear represents a delta interaction of strength $2\alpha$ at each period boundary. The mathematics only uses the matrix.

**Real energies.** For real $z$, define the Gram matrix
$$
G=\int_0^1 (y_1,y_2)^T(y_1,y_2)\,dx,\qquad J=\begin{pmatrix}0&1\\-1&0\end{pmatrix}.
$$
$G$ is positive definite because the two solutions are independent. Differentiating the initial-value equation $U_x=\left(\begin{smallmatrix}0&1\\V-z&0\end{smallmatrix}\right)U$ and using variation of constants gives $A_z=AJG$. For $A=\left(\begin{smallmatrix}a&b\\c&d\end{smallmatrix}\right)$, the symmetric part $B$ of $AJ$ satisfies
$$
B=\begin{pmatrix}-b&(a-d)/2\\(a-d)/2&c\end{pmatrix},
\qquad \det B=1-f^2 .
$$
If $|f|<1$, the symmetric $2\times2$ matrix $B$ is definite. Thus $2f'=\operatorname{tr}(BG)$ is nonzero: conjugation of $B$ by $G^{1/2}$ preserves definiteness and its trace equals $\operatorname{tr}(BG)$.

**Nonreal energies.** The Volterra equations for the two fundamental solutions have inhomogeneous terms $\cos(kx)$ and $\sin(kx)/k$ and kernel $\sin(k(x-t))V(t)/k$, where $k^2=z$. For $|k|\ge1$, Grönwall's inequality after removing $e^{|\operatorname{Im}k|x}$ gives a uniform $O(e^{|\operatorname{Im}k|})$ bound for $f$. Along real $k\to\infty$ it also gives $f(k^2)=\cos k+O(1/k)$, so $f$ is nonconstant. The same integral equations yield entire dependence on $z$, hence $f$ is entire of order at most $1/2$. If $f(z)=0$, then $A$ has eigenvalue $i$. The corresponding nonzero solution has boundary data satisfying $S(y(1),y'(1))^T=i(y(0),y'(0))^T$. The real unimodular $S$ preserves the boundary Wronskian and $|i|=1$, so Green's identity gives $(z-\bar z)\int_0^1 |y|^2=0$. Every zero is real. Hadamard factorization thus writes $f$ as a constant times a genus-zero product (with a power of $z$ for zeros at zero). For nonreal $z$,
$$
\operatorname{Im}\frac{f'(z)}{f(z)}=-\operatorname{Im}(z)\sum_{x:\,f(x)=0}\frac{m_x}{|z-x|^2}\ne0.
$$
Nonconstancy and the genus-zero factorization ensure at least one zero; $m_x$ denotes multiplicity. Hence $f'$ never vanishes outside the real axis either.

**A complex-potential counterexample.** Take $\alpha=0$ and $V(x)=2\pi^2 i t\cos(2\pi x)$ for sufficiently small nonzero real $t$. Rescale $s=\pi x,\ E=z/\pi^2$ and write $D(E,q)$ for the half-trace over $s\in[0,\pi]$ of the Mathieu equation $-y''+2q\cos(2s)y=Ey$. Periodicity makes the half-trace invariant under a half-period translation, hence it is even in $q$. Its Taylor coefficients in real $E,q$ are real, so $D(E,it)$ is real on the real $E$ axis. At $q=0$ it equals $\cos(\pi\sqrt E)$, which has a strict minimum $-1$ at $E=1$ with quadratic coefficient $C=\pi^2/8$. The analytic antiperiodic characteristic value $a_1(q)=1+q+O(q^2)$ satisfies $D(a_1(q),q)=-1$. In the Taylor expansion
$$
D(E,q)+1=C(E-1)^2+Bq^2+O((|E-1|+|q|)^3)
$$
this forces $B=-C$. The real implicit function theorem applied to $D_E(E,it)=0$ gives a real stationary energy $E(t)=1+O(t^2)$ by evenness. Its half-trace is $-1+Ct^2+O(|t|^3)$, strictly inside $(-1,1)$ for small nonzero $t$. Reflection symmetry makes this half-trace exactly $y_1(1,z)$ in the original question. [Mathieu characteristic value, NIST DLMF 28.6.2](https://dlmf.nist.gov/28.6.E2)

**Context.** The real-band argument is an application of classical one-dimensional Floquet theory. Rabinovich's work treats real periodic potentials with real determinant-one point-interaction matrices, including this shear. It supplies prior context for this reduction. The self-contained calculation above answers a catalogue question and makes no priority claim for the underlying spectral result. [Rabinovich, Frontiers in Physics](https://doi.org/10.3389/fphy.2019.00057) · [Left to Solve](https://lefttosolve.com/p/mo-283077)

[Lean verification of the real matrix inequality](FloquetTrace.lean) · [Numerical replay of the complex-potential example](replay_floquet.py)
