# Verification of the optical physics sprint

## Research claims

| Manuscript | Physics question | Result and attribution |
|---|---|---|
| [Single-rail optical qubit](../papers/single-rail-wigner.pdf) | Does the sharp heterodyne bound survive phase coherence between zero and one photon? | Yes for every pure and mixed state in that subspace. Gagatsos numerically sampled pure states in the subspace. The paper proves the entire continuum and characterizes equality. |
| [Rényi orders](../papers/renyi-obstructions.pdf) | Which alternative entropy orders could give a universal Wigner-negativity bound? | One photon rules out all orders below the root near 0.288703. Dilute superpositions rule out every fixed order above 1/2, including states with vanishing mean energy. Gagatsos proposed that mechanism and gave examples. |
| [Rényi orders, positive cases](../papers/renyi-obstructions.pdf) | How close to the lower obstruction can the bound be proved? | Across all positive orders up to one half, the exact threshold is the one-photon root for the full zero–one-photon qubit and for photon-number mixtures through 144 photons. |
| [Sparse-state paper](../papers/sparse-fock-coherence.pdf) | Can states built from two number levels violate the sharp bound? | Every vacuum-plus-n subspace for n = 2, 3, 4, 5 passes, including its infinite amplitude tail. Together with the excited-pair certificates and the single-rail result, any counterexample in levels 0–5 needs coherence number at least three. |

The general order-one-half conjecture is open in the sources checked. November 25, 2026 searches covered the identifier and title, optical qubits and single-rail states, Wigner negativity, Husimi entropy orders, and low-energy dilute superpositions. Prior studies include Romero’s work on the Wigner side for low-lying Fock states and Kenfack–Życzkowski’s number-state and cat calculations. The mathematical contributions above are relative to the cited papers. Priority and peer review remain open. [Gagatsos, Conjecture 1 and Sec. VII](https://arxiv.org/html/2611.30969v1) · [Fonseca Romero](https://doi.org/10.1007/s10773-025-06241-w) · [Kenfack and Życzkowski](https://arxiv.org/abs/quant-ph/0406015)

## What was checked

- Lean 4.19.0 checks the 17 integer coefficient comparisons and the tail inequality in the single-rail proof. Both new declarations have empty axiom reports. The Gaussian reduction, strengthened Poincaré inequality, strictness and mixed-state extension have written proofs. [Lean source](../formal/SingleRail.lean)
- A separate exact-arithmetic implementation checks the constants. Direct Bessel-function integration checks the normalization and sign of the general-order expressions against the Poisson-series interval implementation at 24 parameter choices. These integrations are numerical diagnostics. The positive continuum claim uses outward enclosures and the analytic tail.
- In the threshold table, SciPy proposes zeros and order brackets. Exact sign changes at disjoint rational endpoints plus the polynomial degree certify completeness. The primitive is computed at rational midpoints with exact polynomial arithmetic. The displaced-parity bound controls movement to each true zero. The gamma recurrence and a signed Stirling remainder bound control each entropy comparison. Basic transcendental evaluations use Python Decimal correctly rounded log and exp with an extra outward neighbor at input and output. [144 certified brackets](../campaign/renyi/fock-1-to-144.json)
- At order 0.29 the original compact cover has 2,242 positive leaves and zero unresolved leaves. Every leaf is a statement about an interval of amplitudes. A separate analytic tail handles arbitrarily small excited-state populations. Partial two-parameter bands use monotonicity of the raw Rényi entropy, with the vacuum entropy evaluated at the opposite endpoint. The phase of the superposition is free by rotation. For a fixed photon population, its pure states form a latitude of the Bloch sphere; their mixtures fill that latitude’s disk. [Fixed-order cover](../campaign/single-rail/order-029.json) · [Sharp order-domain certificate](../campaign/single-rail/sharp-domain.json)
- The high-order argument treats Shannon entropy and min-entropy separately, keeps the coherent overlap in normalization, and checks trace distance and mean photon number. The claim holds eventually for each fixed order; the required separation can grow as the order approaches one half. The argument uses the absolute cosine fringe integral and an entropy upper bound. It does not infer negativity from the signed Wigner integral.

The final order-domain proof covers 18 parameter strips and 10,467 terminal rectangles. A strict derivative bound closes the one-photon endpoint. An angular inequality closes the entire near-vacuum tail, including vanishingly small excited-state populations. All 15 pairs among levels zero through five are accounted for by the single-rail proof, four vacuum-pair proofs and both amplitude orderings for ten excited pairs. The finite certificates use correctly rounded elementary functions or exact fixed-point arithmetic. These computational proofs have replay scripts; the Lean certificate in this sprint concerns the single-rail polynomial comparison.

## Replay from the project root

```sh
python3 formal/replay.py
python3 checks/optical_sprint.py
python3 renyi_scan.py
python3 single_rail_regions.py
python3 checks/sharp_qubit.py
python3 fock_pairs.py
python3 excited_pairs.py replay
tectonic papers/single-rail-wigner.tex
tectonic papers/renyi-obstructions.tex
tectonic papers/sparse-fock-coherence.tex
```
