# An explicit interval for the cubic-phase Wigner–Husimi bound

Research notebook, 25 November 2026. Written proof with a reproducible interval-arithmetic calculation. Independent mathematical review and priority remain open.

**Result.** In the convention $[x,p]=i$ and $x=(a+a^\dagger)/\sqrt2$, put $v_\kappa=e^{i\kappa x^3}|0\rangle$. For every single-mode Gaussian unitary $U$ and every $0<|\kappa|\le 3/20$,
$$ H(Uv_\kappa)-\|W_{Uv_\kappa}\|_1\ \ge\ \kappa^2/500. $$
Here $W$ integrates to one in $dq\,dp$ and $H=(\int\sqrt Q\,dq\,dp)^2/(8\pi)$ for the normalized heterodyne density $Q$. At zero strength $\|W\|_1=1\le H$. The upper endpoint is a sufficient condition. The best possible range is unknown. This strengthens the [earlier existence argument](coherent-optimality.md#weak-cubic-phase-light-with-no-photon-cutoff) for a class of states in [Gagatsos's Conjecture 1](https://arxiv.org/html/2611.30969v1).

## Reducing arbitrary Gaussian processing to two parameters

An output displacement or rotation translates or rotates both integrals, preserving their values. For every real symplectic two-by-two matrix choose a left rotation taking its second column to the positive vertical axis. The rotated matrix has diagonal $s,1/s$ for $s>0$ and an arbitrary lower-left entry. This is a real dilation and a quadratic phase multiplication. Up to the discarded transformations and an overall phase the output wavefunction is therefore
$$\psi(x)=\pi^{-1/4}s^{-1/2}\exp[-(x/s)^2/2+i\kappa(x/s)^3+i\eta(x/s)^2],\qquad \eta\in\mathbb R.$$
The Wigner norm is invariant under all these Gaussian operations by the unit Jacobian. The calculation below retains the effects of both $s$ and $\eta$ on $H$. [Gaussian operations in phase space](https://www.nature.com/articles/s41534-025-01006-z)

Write $\widehat f(t)=(2\pi)^{-1}\int f(v)e^{-itv}dv$ and $A(f)=\int|\widehat f|$. Put $h=(1+s^2)^{-1/2}$ and $G=(s+s^{-1})/2$. With $B$ standard normal, define
$$ c=\kappa h^3,\quad d=\eta h^2+3\kappa s h^3 B,\qquad f_B(v)=\exp[-v^2/2+icv^3+idv^2]. $$
Then $H=G(\mathbb E A(f_B))^2$. To verify the normalization use the coherent window $\pi^{-1/4}e^{-(x-q)^2/2+ipx}$ up to a phase. In its overlap with $\psi$, set $q=B/h$ and $x/s=shB+hv$. Completing the square produces $e^{-B^2/2-v^2/2}$ and the phase above up to affine terms in $v$. Upon integrating the modulus over $p$, its frequency Jacobian is $1/(sh)$, canceling $dx=sh\,dv$. Hence $\int|\langle q,p|\psi\rangle|\,dq\,dp/(2\pi)=2\sqrt G\,\mathbb EA(f_B)$. Squaring and dividing by four gives $H$. At $\kappa=\eta=0$ this reproduces the squeezed-vacuum value $G$.

## Cancelling the cubic phase gives a lower bound

Pointwise multiplication becomes convolution under this Fourier convention. Reflection preserves $A$, so $A(f_B)^2\ge A(f_B(v) f_B(-v))$. The cubic phases cancel. The transform norm of the resulting complex Gaussian $e^{-(1-2id)v^2}$ is $(1+4d^2)^{1/4}$ by direct integration. Thus
$$H\ge G\left[\mathbb E(1+4d^2)^{1/8}\right]^2.$$
For a symmetric normal variable, translation away from zero decreases the probability of lying in a fixed centered interval. This follows by differentiating the integral of its even, radially decreasing density over the translated interval. Since $(1+t^2)^{1/8}$ increases with $|t|$, the right side is smallest when $\eta=0$. Define $A_s=36s^2/(1+s^2)^3$. Taylor's theorem, with nonnegative third derivative, gives $(1+t)^{1/8}\ge1+t/8-7t^2/128$ for $t\ge0$. Applying it at $t=A_s\kappa^2 B^2$, using $\mathbb EB^2=1$, $\mathbb EB^4=3$, and $y^2\ge 1+2(y-1)$, yields
$$H\ge G\left[1+A_s\kappa^2/4-21A_s^2\kappa^4/64\right].$$
The initial reflection bound also gives $H\ge G$ directly. Write $K=3/20$. For $s$ outside $[4/5,5/4]$, $G-1\ge1/40>(966/1000)K^2$. Inside, $(H-1)/\kappa^2$ is at least
$$(G-1)/K^2+G(A_s/4-21A_s^2K^2/64).$$
The checker partitions this closed interval into 4,096 rational intervals. On each it uses the minimum of $G$ at the endpoint nearest 1 (or at 1), and the two endpoint bounds for $A_s$, decreasing on this range. The bracket is positive on every interval. The smallest certified lower bound exceeds $0.967527$. In particular **$H-1\ge0.966\kappa^2$** for all widths and shears in the theorem.

## Bounding the full negative Wigner volume

For $\kappa>0$, put $b^3=1/(36\kappa^2)$. The [Airy representation derived in the preceding notebook](coherent-optimality.md#weak-cubic-phase-light-with-no-photon-cutoff) gives exactly
$$\|W\|_1-1=2e^{-b^3/3}\int_2^\infty e^{-bx}[-\operatorname{Ai}(-x)]_+\,dx.$$
The first Airy zero is below $-2$ and Airy is positive to its right. Complex conjugation reflects momentum for negative $\kappa$. After division by $\kappa^2$, the variable factor in the integrand is $b^3 e^{-b^3/3-bx}$. Its logarithmic derivative $3/b-b^2-x$ is negative at $b=b(K)$ for $x\ge2$, and decreases with $b$. It suffices to certify an upper bound at the single endpoint $K$. [Airy zeros](https://dlmf.nist.gov/9.9)

For $f(x)=\operatorname{Ai}(-x)$, the differential equation $f''=-xf$ gives $(f^2+f'^2/x)'=-f'^2/x^2$. At $x=2$ the checker encloses this energy strictly below one. Therefore $|f|\le1$ on the whole tail. On $[2,16]$ we have $|f''|\le16$. Interpolate $f$ linearly on intervals of width $h_0=1/512$. The interpolation error is at most $2h_0^2$. The negative-part map is convex and 1-Lipschitz. Its integral on each interval is at most the interval length times the average of the endpoint negative parts plus $2h_0^3$. Multiply by the largest exponential weight on the interval. The omitted tail contributes at most $e^{-16b}/b$ before the common prefactor. Arb encloses the resulting upper estimate for $(\|W\|_1-1)/K^2$ strictly below $0.962065$. In particular **$\|W\|_1-1\le0.964\kappa^2$**. Subtraction proves the stated gap.

## Changing the input or mixing preparations

For a pure Gaussian input with mean position $m$ and variance $V_x$, write $x=m+\sigma y$ with $\sigma=\sqrt{2V_x}$. Its amplitude in $y$ is vacuum times a phase of degree at most two. Applying $e^{igx^3}$ adds cubic coefficient $\kappa=g\sigma^3$; the remaining terms have degree at most two and are absorbed in the Gaussian output. Hence the sufficient condition on the preparation is $|g|(2V_x)^{3/2}\le0.15$. The normalization of the quadratures and of the gate exponent matters when comparing numbers across experiments.

For mixtures of these preparations with weights $p_j$, the gap is at least $\sum_j p_j\kappa_j^2/500$. The Wigner norm is convex. On the Husimi side the triangle inequality for the integral of the vector $(\sqrt{p_j Q_j})_j$ gives $H(\sum_jp_j\rho_j)\ge\sum_jp_j H(\rho_j)$. Countable sums follow by finite partial sums and monotone convergence. This argument covers classical preparation uncertainty when each component satisfies the strength condition.

## Where the method fails

At $\kappa=1/5$, $s=1$, $\eta=0$, concavity gives an **upper** bound on the reflection estimate itself of $(1+9\kappa^2/2)^{1/4}<1.042247$. The same Airy mesh gives a lower bound of $1.046391$ on the actual Wigner norm. For this lower sum the checker samples the midpoint and subtracts $2h_0$, since $|f'|\le4$ on the integration interval. It discards the nonnegative tail. Thus the reflection estimate alone cannot establish the desired comparison for this state. The actual Husimi integral can exceed that estimate. This is a limitation of the proof and supplies no counterexample to the conjecture.

## Reproduction

The first command checks the continuum certificate with exact rational arithmetic and 96-bit Arb balls, including the quadrature remainder, tail, and failure test. The second independently evaluates the coherent overlap on an ordinary floating-point grid for several nonzero chirps and widths. Its numerical values are diagnostics. The trusted numerical dependency of the certificate is python-flint 0.8.0 and its bundled FLINT/Arb routines. The mathematical reductions above are written arguments. [Certificate](../checks/cubic_range.py) · [Direct window calculation](../checks/cubic_phase.py) · [Arb reference](https://python-flint.readthedocs.io/en/latest/arb.html)

```sh
uv run --no-project --python 3.12 --with python-flint==0.8.0 checks/cubic_range.py
python3 checks/cubic_phase.py
```
