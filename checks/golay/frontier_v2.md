# Golay search replay and shadow benchmark

Version 2 starts 32 frontiers by deleting gates from the parent prefix, 48 by rewiring a gate to a different site, and 48 by replacing a contiguous block of 2–5 gates with a new shorter block. For each mutated prefix, eight seeded variants compete on the number of qubits still entangled after the inverse prefix. Each family gets its own graph-walk incumbent and trial budget. Tied circuit costs favor a mutated frontier. The receipt records each family's starting count, actual trial count and best cost, plus a digest of the chosen starting schedules. The selected preparation undergoes the binary inverse check and the signed Stim forward replay.

In a shadow run of batch 45 from graph batch 41, rewiring reached 44 CNOTs in 7,500 trials, block regrowth reached 45 in 7,500, and deletion reached 44 in 5,000. The rewired 44-CNOT circuit has forward SHA-256 `ab5ced6e70c7419084c59f417285f2ad8a1cd1a16fda7de218d720953f48d094`. Its normalized inverse differs from the first 45 graph receipts and the published seed. Repeating the run produced the same full JSON. Both splice searches around this circuit finished without a 43-CNOT witness.

## Why the reduced splice enumeration is exact

Fix the removed gates and the proposed insertion. A controlled Pauli on two sites is a polynomial in the two single-site Pauli axes. It commutes with a retained gate if their sites are disjoint or their axes agree on every shared site. Sliding the insertion one place to the right across such a gate preserves the complete unitary. Each skipped insertion can be slid until the next retained gate fails this sufficient commutation test or the insertion reaches the end. The implementation tests that representative. The same argument preserves any final closing gate in the three-deletion search. The check mode additionally verifies each skipped gate-pair type on a full binary Pauli basis. Further possible equivalences across deletion masks are outside this pruning rule.

| Neighborhood of a 44-gate seed | Previously enumerated positions and gates | Tested in v2 | Omitted by commutation |
|---|---:|---:|---:|
| Delete two, insert one | 92,623,806 | 12,484,362 | 80,139,444 |
| Delete three, insert one, allow one closing gate | 1,266,576,696 | 171,337,628 | 1,095,239,068 |

On the same machine, consecutive check-enabled runs on the published seed took 10.068 seconds for the legacy tail traversal and 1.454 seconds for its canonical replacement (about 6.9 times faster). These single-run timings exclude compilation. These figures are for exhausted neighborhoods with no witness. The published 44-gate seed and the rewired shadow result both gave these counts. Across source receipts the search also compares complete inverse schedules and the target stabilizer columns, normalizing the order of the endpoints within each gate. A verified identical schedule can refer to a completed no-hit result with zero new trials. The first 45 graph schedules and the published schedule were distinct under this normalization.

## Reproduction

Run in the research repository with a C++17 compiler and Stim 1.16.0.

```sh
uv run --offline --with stim==1.16.0 python checks/golay/graph_campaign.py preview --batch 45
uv run --offline --with stim==1.16.0 python checks/golay/graph_campaign.py replay --batch 44
uv run --offline --with stim==1.16.0 python checks/golay/splice_campaign.py published --check --tail
uv run --offline --with stim==1.16.0 python checks/golay/splice_campaign.py published --check --tail --replay
uv run --offline --with stim==1.16.0 python checks/golay/audit.py
```

Preview prints the candidate JSON and leaves the production ledger untouched. Replay loads the receipt's version, including the original exhaustive splice traversal and original deletion-only graph construction for archived batches.
