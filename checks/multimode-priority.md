# Prior-art review of the weak multimode Wigner–Husimi inequality

**Disposition, 25 November 2026.** The coefficient asked about in Gagatsos’s Section VII(iii) follows in every dimension from the classical change-of-window inequality for the short-time Fourier transform (STFT). The mixed-state reduction follows by convexity. This supplies a mathematical answer to two components of the published question. Its discovery credit is zero under a policy that excludes direct consequences of established results. The sharp multimode coefficient remains a separate open target. [Gagatsos, Propositions 1–2 and Section VII](https://arxiv.org/html/2611.30969v1) · [Cordero, Tabacco and Wahlberg, Lemma 2.2](https://iris.polito.it/retrieve/4c359c18-f43f-4661-87ab-0701104360a9/corderotabaccowahlberg2.dvi.pdf)

## Matching the exact constants

Use $V_g f(q,\xi)=\int f(y)\overline{g(y-q)}e^{-2\pi i\xi\cdot y}\,dy$ on $\mathbb R^n$. The cited lemma estimates $|V_h f|$ by the convolution of $|V_g f|$ and $|V_h g|$ when $\|g\|_2=1$. It credits Gröchenig’s Lemma 11.3.3. For the general $L^2$ windows needed here the same estimate follows from the normalized continuous-frame identity inserted into $\langle f,M_\xi T_q h\rangle$; absolute integrability of that identity follows from Cauchy–Schwarz and STFT orthogonality. Tonelli gives the norm inequality, allowing an infinite right-hand side. [2012 preprint](https://arxiv.org/abs/1207.2099)

Set $Pf(t)=f(-t)$ and choose the real even normalized vacuum window $g(t)=\pi^{-n/4} e^{-|t|^2/2}$. Swapping window and signal reflects $(q,\xi)$ and introduces only a phase. Simultaneously reflecting both signal and window also reflects $(q,\xi)$. Hence $\|V_{Pf}g\|_1=\|V_g f\|_1$. Young’s inequality yields
$$\|V_{Pf}f\|_1\le\|V_g f\|_1^2.$$
No separability assumption appears in this step. In the physical coordinates of Gagatsos, $Q(q,p)=(2\pi)^{-n}|V_g f(q,p/(2\pi))|^2$. Substitution $y=q+t/2$ in the Wigner integral gives $|W(q,p)|=\pi^{-n}|V_{Pf}f(2q,p/\pi)|$. Including both Jacobians,
$$\int\sqrt Q\,dq\,dp=(2\pi)^{n/2}\|V_g f\|_1,\qquad
\int |W|\,dq\,dp=2^{-n}\|V_{Pf}f\|_1.$$
Together they give the exact weak factor $(4\pi)^{-n}$ for all normalized pure $n$-mode states, including entangled ones.

For a spectral mixture, convexity of the Wigner norm and Minkowski’s integral inequality for $(\sqrt{p_j Q_j})_j$ extend the same constant to the mixture. Finite partial sums and monotone convergence handle countably many eigenstates. For any proposed pure-state constant, these operations give the same implication. This is the dimension-independent argument of Gagatsos’s Proposition 1. The conjectured sharp factor $(8\pi)^{-n}$ would improve on window change by $2^n$. [Source statement](https://arxiv.org/html/2611.30969v1) · [Workbench’s displaced-parity derivation](../discovery/coherent-optimality.md#a-second-check-against-the-source-question)

## Search scope and limitations

A separate agent searched the preprint identifier, author, and multimode Wigner–Husimi/negativity wording, then checked STFT window change, ambiguity functions, cross-Wigner estimates and the Feichtinger algebra. The decisive primary source was the explicit unit-window convolution inequality above. Cordero and Nicola’s work on cross-Wigner modulation-space bounds provides related context. A generic norm estimate with an unspecified constant would be insufficient to identify this coefficient. Within the sources inspected we found the earlier transform inequality and Gagatsos’s explicit single-mode statement. We did not locate a separate earlier publication printing the precise mixed-state multimode claim in these optical coordinates. The demonstrated implication already decides the discovery classification irrespective of that bibliographic uncertainty. This was an internal agent review. [Related cross-Wigner estimates](https://arxiv.org/abs/1605.00481)
