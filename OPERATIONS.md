# Running the research programme

A ten-minute macOS user LaunchAgent advances the research while the computer is awake and the user session is available. Runs are local. GitHub hosts the public evidence and papers. The service retries synchronization on subsequent runs. Local Ollama can allocate the four- and five-copy search budgets every fourth round. A model outage uses the recorded fallback.

Each cycle runs the regression tests and independent scrutiny suite, advances the finite-support benchmark every eighth round, dispatches up to 12,000 Werner proposals or a reduced Werner batch alongside 128 Wigner–Husimi trials according to the [discovery docket](discovery/README.md), and searches for an improved electrostatic lower bound. The exact clique certificates persist between cycles. Current extremal targets include several local dimensions and up to five copies. A layer reaching 60,000 closed leaves is retained for a stronger search method while the scheduler visits other targets. A partial layer contributes no exact maximum to the paper. The complex search keeps the best witness from the previous round and mixes local edits with fresh draws. Effective row and column supports must each contain an odd triple. Saved finalists must agree under two Gaussian-integer calculations, the pair kernel and the partial-trace expansion.

The Coulomb search adds near-contact distances to the constraints of a Legendre-polynomial linear program. Rationalizing its coefficients gives a candidate minorant. Exact Bernstein subdivision and an independent symbolic Sturm root count both have to accept it. A failed sphere search is recorded in its round without a bound. Baseline improvements are comparisons against our own certificates. Establishing priority would need a separate literature review.

Once per ISO week the literature worker queries the arXiv API for recent papers in quantum physics, mathematical physics, and statistical mechanics whose abstracts mention conjectures or open questions. It records versioned source links and extracts a candidate subproblem for a local proposer and critic. These leads enter campaign/intake with unreviewed status. Historical priority and applicability require reading the paper; exact result promotion requires a compatible checker.

When either manuscript changes, the worker asks the local model for a concrete counterexample. It tests the proposed triple directly, compares the referee prediction with the exact matrix, reruns the exhaustive controls, and replays the finite support certificates. Reports in campaign/reviews identify the exact draft hashes and retain invalid referee inputs. A model outage leaves review pending.

Every independently certified dimension/copy maximum updates the data table in the second manuscript and rebuilds its PDF. A strictly negative rank-two result creates a separate draft for review and saves the witness. Unchanged maxima produce no new paper. The finite campaign and manuscripts address restricted questions. Changing the problem statement, starting another discipline, and external submission require editorial judgment.

## Locations

- The editable checkout is in Documents/Physics-Workbench. A separate runtime checkout in Library/Application Support/Physics Workbench/checkout isolates unattended commits from user changes.
- The launch agent stores one short rolling log and its predecessor in Library/Application Support/Physics Workbench. The newest committed receipt is in [campaign/rounds on research](https://github.com/shunyaekam/Physics-Workbench/tree/research/campaign/rounds). Each receipt records the seed, allocated and evaluated trials, exact scores, search progress, model fallback where applicable, and source-code fingerprints.
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
