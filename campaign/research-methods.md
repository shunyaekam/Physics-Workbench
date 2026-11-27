# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 19 | 0 | 7.5 | — | — |
| e27-schmidt | 19 | 0 | 15.5 | — | — |
| gagatsos-2026-c1 | 72 | 0 | 121.6 | — | — |
| golay43 | 39 | 0 | 255.7 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 1 | 0 | 106.6 | 392,812 / 3,390 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| refined-bmv | 20 | 0 | 47.0 | 69,669 / 997 | 1/1 |
| support-enumeration | 3 | 0 | 83.0 | — | — |
| thomson-10 | 5 | 0 | 1.7 | — | — |
| thomson-11 | 4 | 0 | 1.2 | — | — |
| thomson-13 | 5 | 0 | 3.0 | — | — |
| thomson-14 | 5 | 0 | 1.3 | — | — |
| werner-endpoint | 38 | 0 | 38.9 | — | — |

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
| [2026-11-27T05:21:12.653+00:00](method-runs/76e2d8056e4a466c8f2bf189f8d56309.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 23.9 | — |
| [2026-11-27T05:21:12.500+00:00](method-runs/94530172a95b4a679cbb5a7bdeeb5491.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T05:21:09.937+00:00](method-runs/9262f16b258844e0864aef0187653fe7.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.6 | — |
| [2026-11-27T05:21:07.747+00:00](method-runs/b03e3bb16e434c57873802377084ed56.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 2.2 | — |
| [2026-11-27T05:21:05.245+00:00](method-runs/5d92b439e8884162ba0c8fc9e65682cc.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.6 | — |
| [2026-11-27T05:21:04.048+00:00](method-runs/1c0c19c6adf64042b7e6a975980e8cc6.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-27T05:21:03.206+00:00](method-runs/3ddcc34521b34b14a443182cbbcf4f45.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.8 | — |
| [2026-11-27T05:20:53.599+00:00](method-runs/dee1b35858f0493e9cfa2fd6c57fe46c.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T05:20:53.398+00:00](method-runs/d1203e04a0e042c1bb64af080cac4c49.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T05:20:34.587+00:00](method-runs/4ca36d8a593b4e63965a29d36e76439d.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 18.8 | — |
| [2026-11-27T05:20:34.272+00:00](method-runs/c207eec7ab4e4a86b7abf8b0de613704.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T05:20:32.759+00:00](method-runs/8e3c7885eb7346149f24760c998b858c.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 1.6 | — |
| [2026-11-27T05:08:19.625+00:00](method-runs/37dbd5ccc8d64019b2b6d5dd18bf9d4d.json) | lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | scout | source-screen-and-notebook | gpt-6.2-sol / low | completed / prior_resolution | 91.9 | 494,151 / 3,149 |
| [2026-11-27T05:07:34.219+00:00](method-runs/888217eaaaa34e9fa02876d1dee443c8.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.6 | — |
| [2026-11-27T05:07:30.267+00:00](method-runs/b5c0e24d3c4948c3a6424ead4778ef0a.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.7 | — |
| [2026-11-27T05:07:29.414+00:00](method-runs/69f690a57e994ebb98162c11fc6fb643.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T05:07:29.153+00:00](method-runs/05034cb325b94e148e31dc612f98ce05.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T05:07:24.892+00:00](method-runs/fe81d0c447324828956d26c701fb37b0.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.7 | — |
| [2026-11-27T05:07:23.379+00:00](method-runs/8a700ba84e464a7795fc05aa25b96047.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T05:07:21.880+00:00](method-runs/d13066b3fee04f11b79c8f90ab511cb9.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.5 | — |
| [2026-11-27T05:07:07.672+00:00](method-runs/45beb4218cf54ed09935e295cd5132ac.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T05:07:07.517+00:00](method-runs/24054ff424454bb082cc856d81e3016b.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T05:06:56.272+00:00](method-runs/8bbbee9dbff44dd8a0050d62832d62ea.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 11.2 | — |
| [2026-11-27T05:06:56.066+00:00](method-runs/4ded89b448de414f9fb681926f74d535.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T05:06:55.695+00:00](method-runs/2d84fb25cd2441aa87eb1513dc8dcb38.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T04:56:31.208+00:00](method-runs/fd63729612154ddd9522802195bd9d40.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T04:56:30.286+00:00](method-runs/643fac00954c4181a8b57c5609d6921f.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T04:56:29.848+00:00](method-runs/e89d85cf50994c66ab7c34d63a70db21.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T04:56:29.696+00:00](method-runs/80b715ac3eff4dd58f0c427ae3566803.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T04:56:24.875+00:00](method-runs/fd72bcbacfbd481ca70d921f5143cd87.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T04:56:22.717+00:00](method-runs/179b171be23948e2969392f1abcb8e50.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T04:56:21.333+00:00](method-runs/645145fc5c454b12acefd195dc2698b1.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T04:56:10.872+00:00](method-runs/7107449b3246486a8c8d9e6af9b3529a.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.5 | — |
| [2026-11-27T04:56:10.621+00:00](method-runs/176281daa8e946de8760988b97d45402.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T04:55:58.488+00:00](method-runs/244913cdcf094ebc9071546681e4820f.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 12.1 | — |
| [2026-11-27T04:55:58.342+00:00](method-runs/4f8eb67d45f54fd6b60f8e14898e7003.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T04:55:58.018+00:00](method-runs/d400da23e85141449e430f222b00469b.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T04:45:12.033+00:00](method-runs/e405a5503f5d48d4a757bb273f980dd7.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T04:45:10.310+00:00](method-runs/8d858abb91604f3a848605f2cbb17cc3.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.8 | — |
| [2026-11-27T04:45:09.460+00:00](method-runs/c9a81f68c08e4c05990162f826456b0c.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.8 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
