# OpenProblems.net source screening

Reviewed 2026-11-25. The directory mixes broad research areas, lectures, historical lists, and conjectures. Use its links for discovery. Establish the precise statement and its current status from the author, problem sponsor, or a recent paper. [Directory](https://www.openproblems.net/)

| Directory route | Source of record | Decision |
|---|---|---|
| Complex and chaotic systems → cellular automata → Rule 30 | Wolfram Foundation prize statement and Wolfram Institute reference kit | Shortlist Problem 1 for proof development. Rule 30 is a downstream lead from the topic heading. |
| Mathematics / confinement → Yang–Mills existence and mass gap | Clay’s problem statement and the KITP working group’s existence review | Watch. A finite lattice calculation needs a proved connection to the continuum and infinite-volume gap. The workbench currently has no such verifier. [Clay](https://www.claymath.org/millennium/yang-mills-the-maths-gap/) · [KITP](https://www.kitp.ucsb.edu/statement-by-the-yangmills-working-group) |
| Mathematics / turbulence → Navier–Stokes | Clay’s September 2026 announcement | Exclude the previously announced forced blow-up result from new-discovery intake. A proposal about unforced data would need its own precise statement and literature check. [Clay announcement](https://www.claymath.org/news/navier-stokes-announcement/) |

## Rule 30 Problem 1

Start with one black cell at the origin of an otherwise white infinite line. Update each cell by taking the exclusive OR of its left neighbor with the inclusive OR of itself and its right neighbor. Let c(t) be the origin cell at time t. The target is to prove that for every starting time T and every positive period P, some t ≥ T satisfies c(t+P) ≠ c(t). A long simulation can disqualify a specified candidate onset/period pair. It cannot establish the quantifiers of this conjecture. [Sponsor statement](https://rule30prize.org/)

**Prior work.** The sponsor supplies Lean statements, existing equivalences, sufficient conditions, and a public submission history. The period-one case is already handled. The workbench’s Lean 4.19 environment checks separate Werner lemmas. A Rule 30 candidate belongs in the sponsor’s pinned Lean 4.35 / Mathlib project. This intake reviewed source and version metadata; it did not build the kit. [Pinned reference project](https://github.com/WolframInstitute/Rule30PrizeKit/tree/5bda6abfa602abee0500700f4c2d60da44cf8ec5) · [Known reductions](https://github.com/WolframInstitute/Rule30PrizeKit/blob/5bda6abfa602abee0500700f4c2d60da44cf8ec5/equivalents/README.md) · [Submission history](https://www.wolframcloud.com/obj/rule-30-prize/Agents/submissions)

**Admission test for an attack.** Identify a seed-specific recurrence or invariant, state how it forces a mismatch beyond *arbitrary* T, and map it to the sponsor's target or a named sufficient condition. Check the current catalog and submissions for the proposed lemma. Reject a route if it merely restates an existing equivalence, rules out period one, or depends on extrapolating observed digits. A verified new intermediate lemma would receive its own scope label.

The weekly source check records the sponsor kit revision and flags upstream changes for review. An update is a prompt to examine the source. It makes no claim about the prize’s status.
