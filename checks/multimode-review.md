# Mathematical review of the weak multimode Wigner–Husimi bound

**Verdict, 25 November 2026.** A separate Workbench AI reviewer reproduced the weak bound and the pure-state reduction for every finite number of modes, including entangled and mixed inputs. These answer two clauses of Gagatsos’s Section VII(iii). The sharp multimode inequality and the parent single-mode conjecture remain open. The review covers mathematical correctness and source scope. Priority, external peer review and Lean verification remain outstanding. [Paper, Section VII](https://arxiv.org/html/2611.30969v1#S7) · [Reviewed notebook version](https://github.com/shunyaekam/oo-research/blob/24ce371a5fa057e8143771fba2bbf9af67a53c50/discovery/coherent-optimality.md#a-second-check-against-the-source-question)

## Check of the dimension-dependent factor

Use complex amplitudes for an independent check of the quadrature normalization. Let $d\mu(z)=d^{2n}z/\pi^n$, $u(z)=\langle z|\rho|z\rangle$, and $R_z=D(z)\Pi D(z)^\dagger$ be parity about $z$. In this measure the normalized Wigner density is $w(z)=2^n\operatorname{Tr}(\rho R_z)$. The change from $z_j$ to the two real quadratures multiplies volume by $2^n$ and preserves the integrated absolute Wigner mass.

Insert the coherent resolution of identity in the trace. The reflection $R_z$ maps $|t\rangle$ to $|2z-t\rangle$ times a phase. Cauchy–Schwarz on $\rho^{1/2}|t\rangle$ and $\rho^{1/2}|2z-t\rangle$ bounds the absolute trace integrand by $\sqrt{u(t)u(2z-t)}$. For fixed $z$, the latter is integrable with integral at most one by Cauchy–Schwarz and $\int u\,d\mu=1$. Tonelli and the substitution $s=2z-t$ for fixed $t$ give
$$\int |w|\,d\mu \le 2^n 2^{-2n}\left(\int\sqrt{u}\,d\mu\right)^2.$$
For the source’s quadrature density $Q(r)=u(z)/(2\pi)^n$, one has $\int\sqrt Q\,dr=(2\pi)^{n/2}\int\sqrt u\,d\mu$. The resulting prefactor is $(4\pi)^{-n}$. The reflection acts on coherent vectors only. The density operator may contain arbitrary multimode correlations. Infinite right sides give the extended-real inequality without a finite estimate. [Source normalization and one-mode argument](https://arxiv.org/html/2611.30969v1#S5)

## Check of the reduction and equality

For a spectral mixture $\rho=\sum_jp_j\rho_j$, set $M_j=\int\sqrt{Q_j}$ and $a_j(r)=\sqrt{p_jQ_j(r)}$. Integrating Cauchy–Schwarz on the pair of vectors $a(r),a(s)$ yields $\sum_jp_jM_j^2\le M(\rho)^2$. The summands are nonnegative, so Tonelli covers infinitely many components. The Wigner density is linear and the absolute integral convex. Consequently any pure-state inequality with constant $C>0$ gives the same inequality for mixtures. With finite equality the Cauchy–Schwarz deficit vanishes for almost every pair $(r,s)$, forcing all nonzero $a(r)$ to have the same direction almost everywhere. Normalization makes each positive-weight $Q_j$ the same density. The derivatives at zero of $e^{|z|^2}\langle z|\rho_j|z\rangle$ in $z,\bar z$ recover each Fock matrix element. Thus identical densities give identical states, ruling out finite equality for a spectral mixture of two distinct eigenprojectors. Classifying the pure equality cases of the sharp inequality still requires a sharp pure-state theorem. [Source one-mode reduction](https://arxiv.org/html/2611.30969v1#S3)

## Attempts to falsify the conclusion

- **Factor of two per mode.** For $n$ vacuum modes $u(z)=e^{-|z|^2}$, so $\int\sqrt u\,d\mu=2^n$. The weak right side is $2^n$, while the exact Wigner norm is one. The proposed sharp right side is one. Vacuum explicitly exposes the missing factor $2^n$.
- **Entangled input.** A balanced beam splitter maps $|1,0\rangle$ to $(|1,0\rangle+|0,1\rangle)/\sqrt 2$ up to phase conventions. The phase-space change is passive, so both integrals are invariant. Direct one-photon and vacuum integrals give $\int\sqrt u\,d\mu=2\sqrt{2\pi}$ and Wigner norm $4e^{-1/2}-1$ for this two-mode input. The weak right side is $2\pi$. This cross-check exercises an entangled example; unrestricted coverage comes from the trace proof.
- **Mixtures with disjoint or coincident densities.** Disjoint positive components cannot give equality, since Cauchy–Schwarz is strict on cross-component pairs. Coincident Husimi densities imply coincident operators by the derivative check. Infinite–infinite comparisons supply no equality characterization.

Dashboard classification: **partial result, reviewed by a separate AI agent**. The weak bound is a direct extension of the author’s technique. This review adds zero full parent resolutions.
