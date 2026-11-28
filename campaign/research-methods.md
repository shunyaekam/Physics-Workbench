# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 117 | 0 | 98.6 | — | — |
| e27-schmidt | 117 | 0 | 132.1 | — | — |
| gagatsos-2026-c1 | 440 | 0 | 1,344.6 | — | — |
| golay43 | 235 | 93 | 556.9 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| lts-oeis-a284230 | 2 | 1 | 111.1 | 185,342 / 2,527 | 1/2 |
| refined-bmv | 123 | 2 | 305.9 | 446,095 / 6,119 | 4/6 |
| support-enumeration | 15 | 0 | 634.2 | — | — |
| thomson-10 | 29 | 0 | 16.0 | — | — |
| thomson-11 | 29 | 0 | 9.2 | — | — |
| thomson-13 | 30 | 0 | 14.0 | — | — |
| thomson-14 | 29 | 0 | 14.5 | — | — |
| werner-endpoint | 235 | 0 | 271.9 | 67,096 / 624 | 1/1 |

## Time to certificate

The endpoint is the first public commit containing a full target certificate. Calendar time starts at the first logged job for that target. Earlier work and costs outside the worker remain unmeasured.

| Certified target | Observed hours to release | Job seconds before release | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|
| [wei-10-2-4](https://github.com/shunyaekam/oo-research/blob/main/certificates/wei-10-2-4.json) | Unmeasured | — | — | — |
| [wei-12-3-4](https://github.com/shunyaekam/oo-research/blob/main/certificates/wei-12-3-4.json) | Unmeasured | — | — | — |
| [wei-12-4-4](https://github.com/shunyaekam/oo-research/blob/main/certificates/wei-12-4-4.json) | Unmeasured | — | — | — |

## Latest attempts

| Started (UTC) | Problem | Stage | Method | Model / effort | Status / outcome | Job seconds | Input / output tokens |
|---|---|---|---|---|---|---:|---:|
| [2026-11-28T00:57:44.734+00:00](method-runs/60b116e8d4924c20b1a53a72c0aa3c05.json) | lts-oeis-a284230 | scout | source-screen-and-notebook | gpt-6.2-sol / low | completed / shortlist | 91.3 | 185,342 / 2,527 |
| [2026-11-28T00:57:39.594+00:00](method-runs/38fef1b24fdd47f69d954a5ec31a4ba8.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-28T00:57:38.048+00:00](method-runs/ba7eb4448c7a46d5829e2cdfdd7de61d.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-28T00:57:37.494+00:00](method-runs/d64361bf9af24146a2f6ab0b6b4f38e5.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-28T00:57:37.299+00:00](method-runs/3f856a33218d42aebff72c468c893b51.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-28T00:57:33.234+00:00](method-runs/bc08c3997ec24a7197b09866b6c13e74.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-28T00:57:31.526+00:00](method-runs/da4b9d09dbc040fb976df6ab7bd05127.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.7 | — |
| [2026-11-28T00:57:29.652+00:00](method-runs/8991c869ccad4532b3e1a040e8a0d45b.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.8 | — |
| [2026-11-28T00:56:34.325+00:00](method-runs/d9ccca25a9494de3924c357f47e8942d.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 3.9 | — |
| [2026-11-28T00:56:33.389+00:00](method-runs/4529ba2a2bc84aaf91334af6d8c7ef9a.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.9 | — |
| [2026-11-28T00:56:28.736+00:00](method-runs/19b0c4d11311432c84b6f310c8ba1092.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 4.6 | — |
| [2026-11-28T00:56:28.283+00:00](method-runs/9d59b330c6b2432ab60d1c74e2455001.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-28T00:56:26.501+00:00](method-runs/497d104559cc4a2a9b873b2e7ecea671.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-28T00:45:13.669+00:00](method-runs/b8bea32a3ad84293a8616137b25f0a46.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-28T00:45:12.757+00:00](method-runs/3fbdf02f594a454bbbb3780d65189635.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T00:45:12.330+00:00](method-runs/3a835c9d2a2943289dc23e4a4b8f699d.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T00:45:12.192+00:00](method-runs/ffc5ec6f368440eab1c59032c9ce0030.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-28T00:45:00.855+00:00](method-runs/d673b108029548ec9e02a18f9e98ef80.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 5.3 | — |
| [2026-11-28T00:44:49.737+00:00](method-runs/8311ab5345674b07a555e7aaf4dbf19d.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 11.1 | — |
| [2026-11-28T00:44:38.350+00:00](method-runs/184a42b04f704660a466d3577cee3f46.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 11.4 | — |
| [2026-11-28T00:43:59.978+00:00](method-runs/cc3f02ab6d4a49cd9363a79f1d6f96cd.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 2.2 | — |
| [2026-11-28T00:43:59.854+00:00](method-runs/4d2398b5bc6a4f84817f00f7282bc522.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T00:43:58.950+00:00](method-runs/72cac33d4fc64ef39dea18808cd6ef14.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.9 | — |
| [2026-11-28T00:43:58.669+00:00](method-runs/e7ac2ae5d29a4db9af06fa19d32adfa0.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T00:43:56.824+00:00](method-runs/37409f3e541c4392a1946b3c45cd7bee.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 1.9 | — |
| [2026-11-28T00:32:46.965+00:00](method-runs/0a411b75bca249a8aca9b62f833dc551.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 23.8 | — |
| [2026-11-28T00:32:46.471+00:00](method-runs/ec3983efa77d4e25a6d94ec41b361a02.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-28T00:32:38.333+00:00](method-runs/21a5eb07b67344d59fcf323dd89ba628.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.7 | — |
| [2026-11-28T00:32:36.564+00:00](method-runs/5c6e8536b367401485db04df2472fae7.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.8 | — |
| [2026-11-28T00:32:34.477+00:00](method-runs/b93ce4c7fd4d43bf8c7def8990bf7fdc.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-28T00:32:32.716+00:00](method-runs/88ebab05aa6e4e9cae7fedabf83eeb8a.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.8 | — |
| [2026-11-28T00:32:19.964+00:00](method-runs/b4e4a6f5adae431292fa1bbfc7447ad8.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 12.7 | — |
| [2026-11-28T00:32:09.055+00:00](method-runs/ed5353b41bf24a57b5b35533b3d93460.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T00:32:08.895+00:00](method-runs/d9b7235c437c4857a2bf7718ab5946b1.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T00:32:08.692+00:00](method-runs/ea5b5ba40f7b4d7d8de32feac54d177d.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-28T00:32:08.425+00:00](method-runs/01beafed50964c5f8f1fdadb639f9198.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T00:32:07.946+00:00](method-runs/34e038dc515b4c4c95a52f78bc0e3d5f.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.5 | — |
| [2026-11-28T00:21:37.617+00:00](method-runs/8e816fe268014c9485849e02af82e2f8.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 1.5 | — |
| [2026-11-28T00:21:29.649+00:00](method-runs/ea5b59697f3246fb8f84547e8d47b652.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T00:21:28.937+00:00](method-runs/30085c9ed7164ad387d3ac6ebf394c3b.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.7 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
