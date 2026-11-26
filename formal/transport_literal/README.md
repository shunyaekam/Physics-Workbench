# Two finite-spectrum transport checks

## Three energy levels at target exponent one half

Take energy levels 0, 9 and 25. The square roots of the three pairwise gaps are 3, 4 and 5. Three singleton projectors, scaled to heights 16, 1 and 81, reproduce these costs exactly when the exponent is one quarter. A single exponent-one relabeling gives distances on a real line. The smallest possible maximum error on the three pairs is **2/3**. The labels 0, 7/3 and 17/3 attain it. The lower bound quantifies over every triple of real labels, including nonmonotone choices. [Pinned statement of Conjecture 7.7](https://github.com/ipitchford/quantum-transport-cost-cones/blob/270f5dba795ffd73d271bfde959237b730227c5e/manuscript.tex#L521-L565)

[The independent contract](Verify.lean) states the projector costs, the three target costs and the optimum. [The proof](TransportLiteral.lean) shows that the largest of three line distances equals the sum of the other two. In the best ordering the discrepancy in that identity is 2. An error of at most e on each pair can absorb at most 3e. Lean checks all orderings and the attaining labels over the real numbers in mathlib.

For a diagonal observable the diagonal pair costs are the absolute spectral gaps raised to the chosen power. This identification connects the checked arithmetic to the single-function attainment clause in the printed question. The kernel statement is about these scalar costs. It has no operator algebra, novelty claim or experimental interpretation. The registered transport problem uses target powers greater than one. This example concerns the literal lower-exponent clause, and strengthens the existing worked example with its exact line approximation error. [Original project example](../../discovery/transport-polygon.md)

The replay compiles the proof, then compiles the independently written contract against its declarations. It checks the transitive axiom report for each contract theorem. The only admitted logical foundations are propositional extensionality, classical choice and quotient soundness. The first command below fetches the project-pinned mathlib dependency closure. The second runs offline against that checkout, checks imports at Lean trust level zero, and tries a false bound, an altered projector and an added axiom. Install the Lean version in [lean-toolchain](lean-toolchain) first. The verifier accepts the lab's installed toolchain or `WORKBENCH_LEAN`.

```sh
python3 formal/transport_literal/replay.py --prepare
python3 formal/transport_literal/replay.py --recheck-imports --self-test
```

[Recorded strict replay](receipt.json)

## General cycle counting for powers greater than one

The proposal adapter checks a proof of the manuscript's counting lemma for **every simple directed cycle** and every family of intervals with disjoint strict interiors. Indices are natural numbers. The signed demand counts downward edges spanning an interval minus upward edges spanning it, including the return edge of the cycle. The statement in [Counting.lean](Counting.lean) compares the total positive demand of the family with the cycle length minus twice the largest demand. Positive demand requires a spanning edge, so extending the index domain beyond the cycle's extreme vertices introduces only intervals of zero demand there. The [global counting proof](counting-proof.md) now compiles against this contract. Run `python3 formal/transport_literal/counting_replay.py` with Lean 4.19.0 to reproduce the axiom audit and negative control. The source file already proves adjacent-cut balance for arbitrary closed walks by telescoping. [Counting argument](../../papers/transport-polygon.md#directed-cycles)

A proposal contains at most 32 whitelisted tactic instructions. The verifier constructs the surrounding theorem declaration, compiles it in a fresh directory and inspects its axiom dependencies. Acceptance concerns the fixed counting lemma. The covering step, feasible-potential construction, quantum reduction and their correspondence to the source would still need formal proofs for the complete registered theorem.

```sh
python3 formal/transport_literal/attempt.py                 # statement and tactic grammar
python3 formal/transport_literal/attempt.py witness.json    # check a proposed proof
python3 formal/transport_literal/attempt.py --smoke          # positive and negative controls
```

These commands use Lean's core library. The smoke test checks the proven adjacent-cut case, rejects an incomplete proof for the full cycle lemma and tests four prohibited instructions. A bounded tactic language can reject a correct argument expressed outside its grammar. Proof search completeness is not an assumption of the verification.
