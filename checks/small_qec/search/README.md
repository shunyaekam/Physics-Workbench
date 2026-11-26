# Small stabilizer codes with bounded check weight

For a binary stabilizer code, the weight of a Pauli check counts the qubits it touches. Let W(n,k,d) be the smallest possible maximum generator weight over all codes with these parameters and all generating bases. A concrete list of checks proves an upper bound. Equality also needs a lower bound covering every eligible code. Jing and Tu had already reported all six distance-three values below in their [September 2026 manuscript](https://github.com/Ivann1242/optimal-check-weight-11-3-3/blob/b4df2d2a2a855f89f9aa9d7200a6f5582519e1fb/paper/main.tex). Our distance-three witnesses corroborate those values. The reference intervals below come from [Wei et al., *Theory of low-weight quantum codes*, Table 2, version 2](https://arxiv.org/html/2601.19848v2#S7.T2).

| n | k | d | Reference interval | Attained W | Evidence and attribution |
|---:|---:|---:|:---:|---:|---|
| 10 | 4 | 3 | 6–7 | 6 | Known implicitly in Grassl's archived group and the Chao–Reichardt construction. Matches the published lower bound. |
| 11 | 4 | 3 | 5–7 | 5 | Search certificate matches the published lower bound. Grassl's archived group reaches 6. |
| 11 | 5 | 3 | 6–8 | 7 | Steane's 1996 code already provides 7. A second certificate has a different weight enumerator. The lower bound 7 requires the separate proof in the accompanying article. |
| 12 | 4 | 3 | 5–7 | 5 | Matches the published lower bound. Padding the length-11, k=4 certificate with a fixed qubit suffices. The file also contains an independently found length-12 certificate. |
| 12 | 5 | 3 | 6–8 | 6 | Search certificate matches the published lower bound. Grassl's archived group reaches 8. |
| 12 | 6 | 3 | 8–10 | 8 | Already implicit in Grassl's archived group. Matches the published lower bound. |
| 10 | 1 | 4 | 4–6 | 4 | Matches the published lower bound. Also obtained by imposing one logical Pauli on Grassl's length-10, k=2 code. |
| 11 or 12 | 1 | 4 | 4–6 | 4 | Follows by padding the length-10, k=1 certificate. Each appended fixed qubit adds one weight-one check and preserves distance. |
| 12 | 3 | 4 | 6–8 | 6 | Matches the published lower bound. Also obtained by imposing one logical Pauli on Grassl's length-12, k=4 code. |
| 12 | 4 | 4 | 7–8 | 7 | A subsequent rank-seven neighbor search reaches seven. The [verified rows](../twelve-four.json) and [dual](../dual.py) certify the optimum. |

For the length-11, k=5 claim, the letters in Steane's displayed phase vectors specify the signs on the 16 computational words in each coset. The first row of the support matrix varies fastest. For each support translation x and phase word z, the script checks that X(x)Z(z) fixes every signed superposition. It extracts six independent commuting checks of weight at most seven. The old code has 75 weight-three phase-free Pauli operators in the normalizer outside the stabilizer. The search witness has 79. Qubit permutations and local Clifford gates preserve this count, so these codes are inequivalent under those operations. [Steane, *Simple Quantum Error Correcting Codes*, 1996](https://arxiv.org/abs/quant-ph/9605021)

The Grassl length-11, k=5 group, Chao and Reichardt's Figure 3(c), and both entries in the QEC Challenge archive have minimum maximum check weight eight, even after trying every group element. The old sources illustrate why a result relative to a table should be distinguished from a first construction. The comparison covers the cited matrices. [Grassl](https://codetables.de/QECC.php?q=4&n=11&k=5) · [Chao and Reichardt](https://arxiv.org/abs/1705.02329) · [QEC Challenge](https://qecchallenge.com/codes/11-5-3.html) · [QEC Challenge variant](https://qecchallenge.com/codes/11-5-3-f.html)

Two nearby targets were already settled independently. Zhang's published certificate excludes maximum weight four for length 11, k=3, d=3. The QEC Challenge catalog already exhibits maximum weight four for length 12, k=3, d=3. [Zhang's proof and certificate](https://yuxuanzhang1995.github.io/agentic-research/lowweight-11-3-3/) · [Length-12 construction](https://qecchallenge.com/codes/12-3-3-s.html)

## Replay the evidence

Run from this directory with standard Python 3.9 or newer.

```sh
python3 verify.py
python3 prior.py
```

The first command reads the eight explicit Pauli matrices in `witnesses.json`. It checks commutation, expands the full stabilizer span, verifies independence, and enumerates every phase-free Pauli of weights one through the asserted distance. For each weight, it counts errors that commute with the stabilizer and lie outside its span. The output includes a positive count at distance d. The second command reproduces the earlier-source checks offline from `prior_groups.json`, reconstructs Steane's states, and builds the two distance-four subcodes. For each archived group it computes the exact minimum basis weight by generating successive spans in nondecreasing order of Pauli weight. The first weight at which the span reaches the full group is that group's optimum.

## Replay the search

Build with Clang or GCC and C++17. The search uses bounded-weight rows and simulated annealing. It penalizes anticommuting rows and zero or repeated single-error syndromes. At distance four it also penalizes pairs on different qubits whose combined syndrome matches a single error. This objective targets pure codes. A failed search leaves the lower bound open. The independent verifier checks every reported hit under the general stabilizer distance definition, including degeneracy.

```sh
c++ -std=c++17 -O3 search.cpp -o search
./search 10 4 3 6 20261125 180
./search 11 4 3 5 20261125 180
./search 11 5 3 7 37 120
./search 12 4 3 5 20261125 180
./search 12 5 3 6 20261125 180
./search 12 6 3 8 20261125 180
./search 10 1 4 4 260119848 100
./search 12 3 4 6 260119848 100
```

The arguments are n, k, distance, weight ceiling, RNG seed, and restart count. Each restart has 30,000 proposals. The recorded discoveries used Apple Clang 21.0.0, arm64, and libc++. Library implementations can vary in floating-point RNG details. The saved certificates verify independently of those choices.
