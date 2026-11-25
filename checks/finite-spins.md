# Finite spin-chain experiments

Imagine a row of arrows, each pointing up or down. Slide a copy of the row one place. In the overlap, count one point for each matching pair and subtract one for each mismatch. Square the sum. Repeat for every possible slide and add those squares. This integer is the energy of an open Bernasconi chain in the convention used here. Low energy means that the pattern has little overall resemblance to its shifted copies.

## Questions we can finish

* At lengths 13 and 16 we check every pattern, including patterns related by symmetry. The receipt gives the minimum, the number of patterns that reach it, and one example. The literature already gives the minima. These are calibration cases. [Published values](https://oeis.org/A102780/b102780.txt) · [Physical model and exact search](https://doi.org/10.1088/1751-8113/49/16/165001)
* For each of 13 arrangements in Zhang et al.’s Table 2 we ask whether changing up to three arrows can lower its energy. This is our bounded research question. Its answer measures the stability of that specific arrangement. Even a strict local minimum leaves the energy of more distant arrangements unresolved. We credit Zhang et al. for the starting sequences. [Original paper and sequences](https://arxiv.org/html/2504.00987v1#S4.T2)

## How to replay

In the research branch, run `python3 checks/finite_spins.py replay` to recompute all saved receipts. NumPy is required. The first checker sums signed spin products at every displacement. The second counts disagreeing bits with integer shifts and XOR. They must agree for every arrangement. The number of arrangements at exactly k flips must equal the binomial coefficient C(n,k). The published starting energy must match before a search proceeds.

`advance` finishes the next missing instance. `all` finishes every remaining instance. The ten-minute research worker runs one pending instance per cycle. Full-chain controls and finite neighborhoods have their own dashboard tab. The general ground-state problem stays outside the full-solutions count.

## Smallest energy climb

For a published arrangement we also ask how high the energy must climb before three spins differ from their starting directions, allowing any sequence of individual flips. Until that first visit, the chain stays inside our enumerated set. The search keeps the least possible peak energy to each arrangement and saves a path attaining the smallest escape peak. A second graph traversal allows only energies strictly below that peak and checks that it cannot reach three changed spins. Receipts give the witness flips, numbered from the left starting at 1. This establishes a finite barrier for the specified start and endpoint condition.
