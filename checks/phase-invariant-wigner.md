# Verification of the phase-invariant Wigner bound

The [research note](../papers/phase-invariant-wigner.pdf) proves Eq. (7) of Gagatsos v1 for a single optical mode whose density matrix is diagonal in photon number. It covers arbitrary countable mixtures. The vacuum attains the sharp constant and is the unique finite equality case in this class. The physical input is the ideal heterodyne probability density. Estimating its square-root integral from a finite experiment would require its own uncertainty analysis. [Source statement, Conjecture 1](https://arxiv.org/html/2611.30969v1)

## Checks on the argument

| Question | Check |
|---|---|
| Can a factor of two in the phase-space convention change the conclusion? | With α = (x+ip)/√2, the radial substitutions for W and Q differ by a factor of four. Carrying each Jacobian separately gives A₀ = B₀ = 1. The known one-photon negative volume gives A₁ = 4/√e − 1, and direct Husimi integration gives B₁ = π/2. |
| Does the bound survive excursions past the largest Laguerre zero? | Weighted Cauchy–Schwarz integrates over the entire positive half-line. The inverse weight has integral πa/(2√2). Taking a⁴ = 3M gives exactly A⁸ ≤ π⁴M/1728. |
| Could the recurrence fail at the vacuum boundary? | The lowering coefficient vanishes at index zero. A separate four-step recurrence calculation reproduces the moment polynomial for symbolic n. Term-by-term factorial integration of explicit Laguerre polynomials checks n = 0 through 15 by another route. |
| Could the comparison change sign at an untested photon count? | Lean 4.19.0 proves the strict two-step polynomial inequality for all natural n. The two exact base moments are 504 and 3144. The paper supplies the gamma recurrence and the two strict comparisons using rational bounds for π. |
| Is Jensen's inequality being used in the wrong direction? | The finite-dimensional integral triangle inequality for the vector of square-root densities gives Σ pₙBₙ ≤ H(ρ). The opposite side uses the triangle inequality for W. Finite projections and nonnegative sums handle unbounded support. |
| Is finite equality meaningful for every state? | The inequality holds in the extended nonnegative reals. The uniqueness claim assumes a finite Husimi integral. Any positive weight on an excited number state then gives strict inequality. |
| Could phase averaging hide a violating pure state? | Yes. The proof applies to the averaged state. It yields no reverse inference for the input superposition. |

## Replay

From the repository root, run the commands below. The symbolic check uses SymPy from the project requirements. The Lean runner checks its pinned toolchain and the reported axioms.

```sh
python3 checks/fock_moment.py
python3 formal/replay.py
tectonic papers/phase-invariant-wigner.tex
```

The Lean declarations are Workbench.Fock.fourthMoment_step and Workbench.Fock.baseMoments. The first uses propositional extensionality and quotient soundness. The second has no axioms. The phase-space formulas, Cauchy–Schwarz, gamma recurrence and countable-mixture argument are verified in the written mathematics. [Lean source](../formal/FockMoment.lean) · [Replay receipt](../formal/receipt.json)

## Prior-art search on November 25, 2026

Gagatsos v1 gives the all-state factor-two estimate and the reduction to pure states. Its numerical experiments concern finite superpositions. Kenfack and Życzkowski studied number-state Wigner negativity years earlier. Abadias, Miana and Romero developed quadrature identities for weighted absolute integrals of orthogonal polynomials. We searched by title and preprint identifier, by Wigner negativity and Husimi Rényi entropy for number states, and by weighted Laguerre absolute-norm bounds. We found no earlier proof of this precise sharp inequality for the full photon-number-diagonal class. An equivalent bound in the special-function literature remains possible. Priority and independent expert review remain open. [Gagatsos](https://arxiv.org/abs/2611.30969) · [Kenfack and Życzkowski](https://arxiv.org/abs/quant-ph/0406015) · [Abadias, Miana and Romero](https://arxiv.org/abs/1407.2644)
