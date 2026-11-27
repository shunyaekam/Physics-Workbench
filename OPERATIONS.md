# Running the research programme

A ten-minute macOS user LaunchAgent advances the research while the computer is awake and the user session is available. The numerical jobs run on the Mac. GitHub hosts the public evidence and papers. The service retries synchronization on subsequent runs. Werner batches use fixed numerical budgets. Model reasoning uses signed-in hosted Codex when enabled.

Each cycle runs the regression tests and independent scrutiny suite, advances the finite-support benchmark every eighth round, dispatches up to 12,000 Werner proposals or a reduced Werner batch alongside 128 Wigner–Husimi trials according to the [discovery docket](discovery/README.md), and searches for an improved electrostatic lower bound. The exact clique certificates persist between cycles. Current extremal targets include several local dimensions and up to five copies. A layer reaching 60,000 closed leaves is retained for a stronger search method while the scheduler visits other targets. A partial layer contributes no exact maximum to the paper. The complex search keeps the best witness from the previous round and mixes local edits with fresh draws. Effective row and column supports must each contain an odd triple. Saved finalists must agree under two Gaussian-integer calculations, the pair kernel and the partial-trace expansion.

The Coulomb search adds near-contact distances to the constraints of a Legendre-polynomial linear program. Rationalizing its coefficients gives a candidate minorant. Exact Bernstein subdivision and an independent symbolic Sturm root count both have to accept it. A failed sphere search is recorded in its round without a bound. Baseline improvements are comparisons against our own certificates. Establishing priority would need a separate literature review.

Once per ISO week the literature worker queries the arXiv API for recent papers in quantum physics, mathematical physics, and statistical mechanics whose abstracts mention conjectures or open questions. It records versioned source links and extracts a candidate subproblem for editorial screening. These leads enter campaign/intake with unreviewed status. Historical priority and applicability require reading the paper; exact result promotion requires a compatible checker.

When a Werner manuscript changes, the worker replays the dense matrix controls, threshold checks and finite support certificates. A numerical replay has its own receipt and requires separate mathematical review.

Every independently certified dimension/copy maximum updates the data table in the second manuscript and rebuilds its PDF. A strictly negative rank-two result creates a separate draft for review and saves the witness. Unchanged maxima produce no new paper. The finite campaign and manuscripts address restricted questions. Changing the problem statement, starting another discipline, and external submission require editorial judgment.

## Hosted reasoning

From the editable checkout, `python3 ops/install.py --hosted-hourly` enables signed-in Codex for the research worker. Each eligible tick can start one hosted research request after 60 minutes have elapsed since the previous start. Errors and timeouts consume the slot. The next stage runs on a later eligible tick while the Mac is awake. Use `--checks-only` to turn off scheduled inference. Source intake, numerical searches and proof replay run independently.

## Locations

- The editable checkout is in Documents/Physics-Workbench. A separate runtime checkout in Library/Application Support/Physics Workbench/checkout isolates unattended commits from user changes.
- The launch agent stores one short rolling log and its predecessor in Library/Application Support/Physics Workbench. The newest committed receipt is in [campaign/rounds on research](https://github.com/shunyaekam/oo-research/tree/research/campaign/rounds). Each receipt records the seed, allocated and evaluated trials, exact scores, search progress, allocation provenance, and source-code fingerprints.
- The worker pushes batches and draft updates to the research branch. The public catalogue on main changes through an editorial commit. The worker fast-forwards the editable main checkout and, when present, its .runtime/research worktree from their respective branches when their tracked files are clean. If you have local edits, GitHub can continue advancing and the next clean sync catches up. A conflicting remote merge is aborted and logged. Commits and evidence are preserved.
- Login, network and GitHub credentials determine when sync can occur. A sleeping or logged-out Mac resumes on a later available tick. The schedule uses local compute without hosted GitHub runners.

## Commands

Run these from the editable checkout. The full audit replays all archived support certificates, retained complex witnesses and new electrostatic bounds. Run the two old pilot replays separately.

```sh
python3 continuous.py audit
python3 lab.py replay
python3 lab.py --out followup replay
launchctl print "gui/$(id -u)/local.physics-workbench.research"
tail -30 "$HOME/Library/Application Support/Physics Workbench/worker.log"
```

To stop recurrence, unload the agent and disable it for subsequent logins. To restart, enable it and rerun the installer. Stop and restart leave existing results intact.

```sh
launchctl bootout "gui/$(id -u)/local.physics-workbench.research"
launchctl disable "gui/$(id -u)/local.physics-workbench.research"

launchctl enable "gui/$(id -u)/local.physics-workbench.research"
python3 ops/install.py
```

The scientific checks use Python with the pinned NumPy, SciPy and SymPy versions. PDF rebuilding uses Tectonic. The service installer is for macOS and expects a configured Git remote, GitHub push access and the dependencies available to the invoking Python interpreter.

## Optical entropy sprint

Each cycle advances certified interval covers for excited photon pairs with levels from 1 through 16, then searches one three-level subspace for a numerical violation. The sparse manuscript rebuilds its table and PDF when both amplitude orderings of an additional pair have closed and passed replay. Updated source or evidence invalidates the corresponding replay ledger. The proof of the sharp qubit threshold is archived. The [active research status](campaign/fock-pairs/status.md) and its dated copies update locally each day the Mac runs. Network access is needed to sync the public repository. Numerical three-level nominations are saved for rigorous validation.

Run `python3 checks/sharp_qubit.py`, `python3 renyi_scan.py`, `python3 fock_pairs.py`, `python3 excited_pairs.py replay` and `python3 formal/replay.py` for the current proof certificates. [Details of verification](checks/optical-sprint.md)

## The discovery pipeline

The [public board](https://shunyaekam.github.io/oo-research/pipeline/) reads campaign/pipeline.json on the research branch. Each local cycle rebuilds the feed after searching and running the agent stage. A bundled snapshot supports the website during a feed outage. Its timestamp appears on the board.

The [research protocol](discovery/proof-system.md) describes admission, sandbox experiments, exact replay, separate source and mathematics reviews, and publication from a clean checkout. Active attempts are in `campaign/proof-flow`. Historical pilot transcripts remain in `campaign/agent-lanes`.

Run `python3 ops/proof_flow.py` to advance an eligible research stage using the shared hourly quota. Run `python3 ops/witness.py PROBLEM witness.json` to replay a supplied object without using a model. The dedicated checkout runs `ops/publish_checked.py` after synchronizing research; it needs the existing repository credentials, GitHub CLI and Pages for publication and issue closure.

## Hosted model assignment

The hourly research worker uses GPT-6.2 Sol at low reasoning by default, including for new catalogue problems, scouting and prior-art checks. The major-problem list in [ops/hosted.py](ops/hosted.py) assigns GPT-6.2 Astra at medium reasoning to solving and mathematical review of the full refined BMV trace conjecture. Finite cases and numerical screens have their own targets and use Sol. Both models share one hourly allowance.
