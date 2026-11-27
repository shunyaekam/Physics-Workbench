# The CHSH probability as a theta series

Let φ(z) = Σ_{k∈ℤ} z^(k²), and define cₙ by the Taylor expansion of (φ(z²)/φ(z))² at zero. These are the integers in A210066. Simon Plouffe's conjecture in A201488 asks whether Σ cₙ exp(−πn) equals the quantum CHSH winning probability (2+√2)/4. An equivalent theta quotient was recorded by Michael Somos in the same entry in 2022. [A201488](https://oeis.org/A201488) · [A210066](https://oeis.org/A210066)

Write F(t) = Σₖ exp(−πt k²), with t > 0. The Gaussian transformation formula gives F(1/2) = √2 F(2). This is the theta transformation at z = 0 and τ = i/2. [DLMF 20.7.32](https://dlmf.nist.gov/20.7.E32)

Set A = F(2) and B = F(1/2) − A. The even indices in F(1/2) contribute A, so the odd indices contribute B. In the absolutely convergent double sum F(1)² change variables to u = m+n and v = m−n. This maps integer pairs bijectively onto pairs of the same parity, with m²+n² = (u²+v²)/2. The even-even and odd-odd contributions are A² and B². Hence F(1)² = A²+B², with B = (√2−1)A. Since A > 0,

(F(2)/F(1))² = 1/(1+(√2−1)²) = (2+√2)/4.

To justify the Taylor evaluation, on |z| ≤ 1/8 we have |φ(z)−1| ≤ 2Σ_{k≥1} (1/8)^{k²} ≤ 2/7. The quotient is therefore analytic on |z| < 1/8, and formal series division gives its Taylor coefficients. As e^(−π) < 1/8, its Taylor series converges absolutely there to (F(2)/F(1))².

The [complete Lean proof](CHSH.lean) includes absolute convergence, evaluation of the formal coefficients, the lattice parity split and the Gaussian transformation. The upstream-pinned Lean 4.33.1 compiler accepted the full series identity, with only the standard axioms propext, Classical.choice and Quot.sound. [Verification run](https://github.com/shunyaekam/oo-research/actions/runs/45920326180) · [Statement under review at Left to Solve](https://github.com/GuillaumeBAUD-coder/open-math-agents/pull/1073)
