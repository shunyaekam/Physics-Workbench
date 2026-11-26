# oo research

**Distance-four quantum error correction.** On twelve physical qubits, the least possible largest stabilizer check has weight seven when encoding four logical qubits and six when encoding three. [Read the paper](https://shunyaekam.github.io/Physics-Workbench/papers/distance-four.pdf) or [replay the exact certificates](checks/small_qec/README.md).

[What counts as a solution](discovery/proof-system.md) · [Full machine-checked results](https://shunyaekam.github.io/Physics-Workbench/pipeline/#certified)

oo research is an open mathematical physics lab. We investigate published conjectures and share our proofs, computations, and verification records.

[Read the scientific audit](discovery/scientific-audit.md) for the claim, strongest objection, verification coverage and remaining uncertainty for each of the nine manuscripts.

[Browse the public research catalogue](https://shunyaekam.github.io/Physics-Workbench/) to read the manuscripts and inspect the verification scope for each result.

**One conjecture has a proposed full solution after internal AI review.** The catalogue contains nine working manuscripts, five with partial Lean verification. The transport paper classifies both parts of Pitchford’s Conjecture 7.7 for finite-spectrum quantum transport. When the target cost grows faster than the energy gap, the worst chain of levels determines the exact approximation error, and a single relabeling attains it. For powers below one the error is zero, while three distinct levels already rule out that relabeling. The source is a recent AI-assisted mathematical-physics manuscript. The global upper bound has a written proof. External peer review and confirmation of priority are pending. [Working paper](papers/transport-polygon.pdf) · [Original conjecture](https://github.com/ipitchford/quantum-transport-cost-cones/blob/270f5dba795ffd73d271bfde959237b730227c5e/manuscript.tex#L558-L565) · [Math review](https://github.com/shunyaekam/Physics-Workbench/blob/research/checks/transport-review.md)

Lean verifies the polygon lower bound for chains of arbitrary length and a local crossing lemma in the upper-bound argument. The manuscript supplies the full proof. A separate exact checker challenged the counting step on 125,664 directed cycles, and a cubic-time algorithm computes the optimum and matching labels. [Lean proof](formal/TransportPolygon.lean) · [Cycle checker](https://github.com/shunyaekam/Physics-Workbench/blob/research/checks/transport_review.py) · [Exact solver](https://github.com/shunyaekam/Physics-Workbench/blob/research/checks/transport_optimum.py)

**Two-level partition functions.** The refined BMV trace bounds hold whenever either matrix has at most two distinct eigenvalues, in all finite dimensions and for every pair of word counts. Cha and Lee's three-level example makes this threshold sharp for the upper bound. The finite three-factor certificates in the appendix reproduce earlier work. [Working paper](papers/bmv-trace-12-3.pdf) · [Independent project review](https://github.com/shunyaekam/Physics-Workbench/blob/research/checks/bmv-blocks.md)

**Rank-seven quantum magic.** The sorted computational basis minimizes nonlocal stabilizer Rényi entropy for every rank-seven pure state on two three-qubit registers. The paper also covers three spectral regions in arbitrary supporting dimensions and equal registers of unbounded rank when all but two amplitudes in the full register, including zeros, coincide. Python and Lean check the original 210 inequalities. Two exact rational implementations verify 630 further inequalities for the three regions. The unrestricted parent conjecture remains open. [Working paper](papers/schmidt-rank-seven.pdf) · [Proof certificates](https://github.com/shunyaekam/Physics-Workbench/tree/research/checks/schmidt7)

[Discovery docket and evidence levels](discovery/README.md) · [Screened external targets](discovery/targets.json) · [Lean formalization coverage](formal/receipt.json)

Four research notes address Gagatsos’s Wigner–Husimi proposal. The [single-rail paper](papers/single-rail-wigner.pdf) proves the conjecture for coherent and mixed optical qubits. The [Rényi-order paper](papers/renyi-obstructions.pdf) proves exclusions and gives lower-order positive results. The [sparse-state paper](papers/sparse-fock-coherence.pdf) proves that a violation within levels zero to five requires at least three-level coherence. Read the [audit and sprint results](checks/optical-sprint.md) and [overnight research status](campaign/fock-pairs/status.md).

The [phase-invariant light paper](papers/phase-invariant-wigner.pdf) proves the sharp Wigner–Husimi bound for every photon-number-diagonal state. Read the [verification and prior-art review](checks/phase-invariant-wigner.md) for its scope and replay commands. Earlier work includes the [coordinate-support theorem](papers/coordinate-supports.pdf), [certified finite maxima](papers/finite-maxima.pdf), [referee audit](checks/referee-audit.md), and [scheduler and replay instructions](OPERATIONS.md). Fresh research receipts appear in [campaign/rounds on research](https://github.com/shunyaekam/Physics-Workbench/tree/research/campaign/rounds).

This local research workflow takes a source-backed question through bounded search, exact witness checking, replay, and review. The first campaign covers classical electrostatics and quantum information. Each saved attempt contains the statement, assumptions, search settings, seed, witness, result, and implementation hashes. Archived pilot attempts retain their original model and provenance.

Start with the [pilot results](PILOT.md) and [scientific review](REVIEW.md). The pilot used Python 3.9, NumPy, SciPy and the installed Ollama model `llama3.2:3b`. The original pilot witness checker uses the Python standard library. Later paper checks also use NumPy, Lean, FLINT/Arb or other dependencies specified with each result.

## Run a campaign

From this folder, use the following commands. A fresh Python environment can install the search dependencies from `requirements.txt`.

```sh
python3 lab.py replay
python3 lab.py report
python3 -m unittest -v
python3 lab.py --out campaign run --workers 2 --rounds 2
python3 lab.py --out campaign replay
python3 lab.py --out campaign report
```

A run processes each registered case once per round. Controls run first in full campaigns. A selected subset runs only the cases named with `--only`. Use `--seed` to start a new seed series. Runs resume from files written by atomic rename with per-job locks. Errors persist and `--retry-errors` archives the failed record before retrying. Use separate output directories for different experimental designs. One workstation is the supported execution environment.

## Intake and triage

1. Find an independently published statement and record the source locator, current prior art, date, quantifiers, conventions and target quantity in a problem card. For a preprint, record what its authors claim and the extent of independent checking. Recheck status before calling an improvement new.
2. Choose a falsifier or a certificate that would settle one useful subproblem. Write a known-answer control and a deliberately invalid witness. Give priority to cheap checks that can discriminate competing ideas.
3. Use the SciNet task taxonomy to identify what the work involves. For the sphere track we use geometry specification in theoretical analysis. For the quantum track we use construction of measurable witnesses as the closest task analogue. Here the witness is evaluated mathematically. SciNet describes research activities. Sources for conjectures and baselines are recorded separately. These are our mappings of tasks from Cristian Alamos and Lukas Althoff’s CC BY 4.0 dataset. [Pinned SciNet release data](https://github.com/lukasalthoff/scinet/blob/69973ad2cf21a34298b1f7f600f2c3820989113e/data/tasks.csv)
4. Freeze the reviewed card before search. `problems.json` is the trusted registry for exact checks. Replay compares the full saved statement with the current registry. A change of scope needs a new problem ID; archive the old registry with its results. Scientific provenance is a human intake judgment. The software checks required fields and detects later statement changes.
5. Record failed searches and unresolved gaps. Escalate a candidate when the witness replays, the checked statement matches the scientific question, and a refreshed literature comparison supports novelty. For a theorem, record the formal statement, source-to-formal correspondence, proof dependencies and independent checker output. For a measured effect, record units, uncertainty, calibration and replication. This pilot implements exact witness checks. Formalization, expert review and experimental replication are subsequent research work.

## Research briefs

The Mac runs numerical searches and proof checks. For model reasoning, the installed research worker can use signed-in hosted Codex at most once per hour. Each attempt reserves its hourly slot before contacting the service. See [operations](OPERATIONS.md).

Run `python3 research.py --only sphere-11 werner-4 --packet` to export the source questions and replayed evidence for a hosted or human reviewer.

For another computable problem family, add a bounded proposal/search routine to `search.py`, an independently readable checker to `verify.py`, a control, a report formatter and a registry entry. A family with experimental observations or an external proof assistant needs its own evidence adapter. For a new instance of either implemented family, add a card and use the existing runner. Preserve the controls when enlarging the campaign.

## Submit a witness

A sphere witness contains rational Legendre coefficients scaled by a billion and rational stereographic coordinates scaled by ten million. A Werner witness contains at most two pairs of sparse local vectors, with each entry written as an integer basis index and coefficient. The full JSON for any completed run contains a `witness` object. Extract that object as a standalone JSON file for either command below.

```sh
python3 lab.py check werner-4 my-witness.json
python3 submit.py werner-4 my-witness.json --credit "Research notebook, experiment 7"
python3 lab.py --out submissions report
```

The check command gives immediate feedback. Submission saves the evidence or a rejection and credits its source. An exact negative score on a research card merits a second implementation and expert review. A zero or positive score records only the tested vector. Keep submissions in their own output directory.

## Sources behind the design

Cinna Davis reported 55 additional candidate solutions undergoing Lean verification. The public repository distinguishes full results, conditional results and contributions with remaining ranges. That distinction carries through to the role and scope fields in this workflow. [Announcement](https://x.com/1337isnot1337/status/2125248838751441354) · [Repository](https://github.com/1337isnot1337/solved-conjectures)

Althoff’s announcement points to a task-level map across disciplines. Use it when selecting which parts of a research project can be delegated or checked. [Announcement](https://x.com/AlthoffLukas/status/2125261389262688652) · [SciNet](https://github.com/lukasalthoff/scinet)

The Gaupenov–Guyon–Venier post is an intake control. Its Lean definition makes every orbit stationary by construction. Every starting integer refutes the assertion that all orbits eventually depart or descend. The repository encodes Rick Astley lyrics and links to the music video. Intake disposition is **parody / exclude from research queue**. A formally correct proof can establish a trivial proposition invented by its author. [Announcement](https://x.com/stutxo/status/2125321602753855891) · [Definitions](https://github.com/stutxo/gaupenov-guyon-venier/blob/main/GaupenovGuyonVenier/Definitions.lean) · [Text certificates](https://github.com/stutxo/gaupenov-guyon-venier/blob/main/GaupenovGuyonVenier/TextCertificates.lean)

OpenAI reported a Lean-verified finite-time singularity for smoothly forced Navier–Stokes. Clay described the problem as apparently settled. After Levent Alpöge released his Claude-assisted Riemann Hypothesis proof, the Lean FRO and Mathlib Initiative reported reproducing the build, matching the exact target statement and checking the exported proof. Clay’s prize process separately requires a qualifying publication, elapsed time and community acceptance. Status checked November 25, 2026. [OpenAI](https://openai.com/index/navier-stokes-solution/) · [Clay announcement](https://www.claymath.org/news/navier-stokes-announcement/) · [Alpöge’s account](https://alpo.ge/remark.pdf) · [Lean verification](https://leanprover-community.github.io/blog/posts/riemann-hypothesis/) · [Clay rules](https://www.claymath.org/millennium-problems/rules/)
