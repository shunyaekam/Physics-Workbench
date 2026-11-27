# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 92 | 0 | 78.5 | — | — |
| e27-schmidt | 92 | 0 | 110.0 | — | — |
| gagatsos-2026-c1 | 346 | 0 | 1,152.8 | — | — |
| golay43 | 185 | 68 | 535.0 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 3 | 3 | 496.3 | — | 0/2 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 96 | 1 | 216.2 | 284,541 / 4,116 | 3/4 |
| support-enumeration | 12 | 0 | 480.8 | — | — |
| thomson-10 | 23 | 0 | 12.5 | — | — |
| thomson-11 | 23 | 0 | 7.3 | — | — |
| thomson-13 | 23 | 0 | 11.4 | — | — |
| thomson-14 | 23 | 0 | 11.0 | — | — |
| werner-endpoint | 185 | 0 | 211.8 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T20:15:27.711+00:00](method-runs/c69ae0f696f643c296c5f792d3b88e13.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T20:15:26.099+00:00](method-runs/5043819645d94f0f81a3d9f3d117e2cc.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T20:15:25.107+00:00](method-runs/a3ecb37eb3d5479da62d931673c25c94.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T20:15:24.847+00:00](method-runs/8a13293546d342d69a427240c57524f6.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T20:15:19.711+00:00](method-runs/5aaff4c1586941f28fad83909dc28e44.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T20:15:17.659+00:00](method-runs/b590ca73cc084d758390d185fe75c9d4.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T20:15:16.273+00:00](method-runs/addf809ba8c7483c9990f1c00e1776b0.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T20:15:00.889+00:00](method-runs/376dbda99cef469c8fe956b8ae75c0b2.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.5 | — |
| [2026-11-27T20:15:00.683+00:00](method-runs/91471999ba9242918c22075ca303556d.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T20:15:00.521+00:00](method-runs/e71dd8627e6f45b8aae5b4fb09589289.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T20:15:00.265+00:00](method-runs/89d595e79b6a41daaff17f8f79ba1e02.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T20:14:59.687+00:00](method-runs/52a5b38e32f74d3a9287761cdd5b9746.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-27T20:03:21.724+00:00](method-runs/3059c5a60bd1464297c6bcd9b8e666d6.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 75.6 | — |
| [2026-11-27T20:03:21.469+00:00](method-runs/ca24a40b76394ac99533a3389f75944a.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T20:03:16.443+00:00](method-runs/7f84e14b1e864fcc81324bf4d71e462f.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 3.6 | — |
| [2026-11-27T20:03:12.552+00:00](method-runs/429e7071c10b4aa1a6b6d522db07a948.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 3.9 | — |
| [2026-11-27T20:03:08.929+00:00](method-runs/2fb3853017ef45b4a9d9c35e87330d9d.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T20:03:06.823+00:00](method-runs/494e57d7161c4edab4219425b11a994e.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T20:03:05.442+00:00](method-runs/09b4ddcf98864be6a36d10cd4fcb61cc.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T20:02:50.167+00:00](method-runs/4da1d6e35680486397ac355b7d2e6c55.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T20:02:49.970+00:00](method-runs/ee267fa979b446d89f72d9ee37763a2e.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T20:02:49.806+00:00](method-runs/aaddf4ef2d194578bdc31c623243838c.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T20:02:49.579+00:00](method-runs/d3c9bceb75f04a52b7f12c66f690f7f7.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T20:02:48.931+00:00](method-runs/900267a93385428eb5d286bb1dbe698e.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.7 | — |
| [2026-11-27T19:52:22.923+00:00](method-runs/e00183ee3260410ebb14420dc34a0bc6.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-27T19:52:16.939+00:00](method-runs/e377223b8acb4e0398c2c34e5213af95.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T19:52:16.365+00:00](method-runs/83a7a10c649a478aae8ae80937a20e97.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T19:52:16.188+00:00](method-runs/11228a6e6c244e549530b131de5713c6.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T19:52:11.980+00:00](method-runs/c42f5bfced744ace84c73233422c7729.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T19:52:10.764+00:00](method-runs/37b44f9b0b114c6f88adca570c4d7d5d.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-27T19:52:09.969+00:00](method-runs/f52075e51c9745a8a790df39f5dcb040.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.8 | — |
| [2026-11-27T19:51:52.209+00:00](method-runs/4948bdedc7be43f9b4cdf806e6ddb944.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T19:51:52.111+00:00](method-runs/d87fe44b9d9c4e249dbcec6afb73943e.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T19:51:51.956+00:00](method-runs/dd60cf4263a143139ffe0572c7af04ea.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T19:51:51.829+00:00](method-runs/85e3cabe954d4b1a933362233ceaf5a4.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T19:51:51.518+00:00](method-runs/0dfd9facd0cc47738cde22c71511e311.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T19:41:32.576+00:00](method-runs/4e658c6195c34a2cb9f11d2f3d3ccd71.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T19:41:31.227+00:00](method-runs/ab4f2c9034344480962e4b65a3b3c81e.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T19:41:30.647+00:00](method-runs/c2c2bb77253c4944bdcc19b3f4b1dc1f.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T19:41:30.447+00:00](method-runs/ca07ea686a3a413c865901dd18cd00cd.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
