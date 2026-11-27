# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 44 | 0 | 32.3 | — | — |
| e27-schmidt | 44 | 0 | 50.0 | — | — |
| gagatsos-2026-c1 | 166 | 0 | 282.7 | — | — |
| golay43 | 89 | 20 | 460.9 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| refined-bmv | 45 | 0 | 56.3 | 69,669 / 997 | 1/1 |
| support-enumeration | 6 | 0 | 199.6 | — | — |
| thomson-10 | 11 | 0 | 6.8 | — | — |
| thomson-11 | 11 | 0 | 3.5 | — | — |
| thomson-13 | 11 | 0 | 4.7 | — | — |
| thomson-14 | 11 | 0 | 5.0 | — | — |
| werner-endpoint | 89 | 0 | 116.6 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T10:19:03.281+00:00](method-runs/a60c4442cea3465093ab28d956bd4bfb.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.8 | — |
| [2026-11-27T10:18:46.554+00:00](method-runs/a68a7ca2f29043ed9108d4f182ad1525.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T10:18:45.630+00:00](method-runs/862224840b1c49e2af3496fd6e110f8c.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T10:18:44.841+00:00](method-runs/19d5a9392dde49c8aa6dae8a6a9e8faa.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 1.3 | — |
| [2026-11-27T10:18:35.415+00:00](method-runs/c36798c62bd94c5f98ba41974faeea2d.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-27T10:18:34.313+00:00](method-runs/7550000212e946b982a1cd936f6645b1.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T10:18:33.522+00:00](method-runs/10f125c9b2d14eea9d6d5d65b58280d7.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.8 | — |
| [2026-11-27T10:18:23.580+00:00](method-runs/6ee3e984de9e4274a0b7923eefad63fe.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T10:18:23.477+00:00](method-runs/47596987d7a54e9cb2d9550ff52ef097.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T10:18:23.369+00:00](method-runs/5d0b490818ef4ebca142e1586c1da868.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T10:18:23.248+00:00](method-runs/b69c22315a7e40f8adeafa73046510f3.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T10:18:22.935+00:00](method-runs/2bea9c9ec7534f4faa21befd333dc70c.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T10:06:56.792+00:00](method-runs/ce66d6dbf7f141749cbc94d70f2fa8d9.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 32.0 | — |
| [2026-11-27T10:06:56.602+00:00](method-runs/0bdfbc1a4e784605992bd19dbf6a6af0.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T10:06:54.365+00:00](method-runs/e1ceb286aa58490aa57a9bec77900e73.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.5 | — |
| [2026-11-27T10:06:52.764+00:00](method-runs/3a4b8caabcde4bd4afdac1175569b97c.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.6 | — |
| [2026-11-27T10:06:49.663+00:00](method-runs/e019e5afa21547edb81f17b650928876.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T10:06:48.069+00:00](method-runs/fbecb3ac616e498e934b9d7adf6fc85e.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.6 | — |
| [2026-11-27T10:06:46.871+00:00](method-runs/79fa28ca1d284577b6d83ae08b8752a7.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.2 | — |
| [2026-11-27T10:06:37.890+00:00](method-runs/0878dbd3e12149be97baaeb8fe6174f1.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T10:06:37.747+00:00](method-runs/0a47c75731d748458ed757f13cb51b71.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T10:06:37.573+00:00](method-runs/4d8721b2dec94acda963b8a364c3cf34.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T10:06:37.356+00:00](method-runs/753903474a1e42efbb5f918ad95e6bc4.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T10:06:36.776+00:00](method-runs/695dd75d9380486a9285c4e4752bf6b2.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-27T09:55:59.125+00:00](method-runs/bae5808c74d84e8d86fbe6fb4a863d9f.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 2.1 | — |
| [2026-11-27T09:55:42.481+00:00](method-runs/6eb58bffe8504598b8f88b74caa80857.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T09:55:41.493+00:00](method-runs/0cc023fe79704c0a9ca0c121a1db1d0a.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T09:55:41.042+00:00](method-runs/3b04bbeb94ee42ea9060b8e0cb89b3d8.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T09:55:35.586+00:00](method-runs/8ce4e0fe9d58455fb223de2f0569448c.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T09:55:34.060+00:00](method-runs/26c07d9fd72243b095849b34e4138b47.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T09:55:33.356+00:00](method-runs/e691ec70792c401b94d844b94ba2a457.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-27T09:55:23.889+00:00](method-runs/6cb238bf5ae64caeaaa226b6b9ee254e.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T09:55:23.797+00:00](method-runs/a6c98889c7e44edfa66a433ad0f4e45e.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T09:55:23.686+00:00](method-runs/ee21192c1f6942899e35ac8aa01994fd.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T09:55:23.576+00:00](method-runs/c0cf4f4227a04023a75a6082d11ebd5f.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T09:55:23.277+00:00](method-runs/f9dc99d939c242519da59302254ff7a0.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T09:43:38.348+00:00](method-runs/af81a28261224a4699f6714471a9b573.json) | lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | scout | source-screen-and-notebook | gpt-6.2-sol / low | completed / prior_resolution | 88.7 | 337,260 / 3,220 |
| [2026-11-27T09:43:35.971+00:00](method-runs/519b144a3cd54886a8754313350daf41.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-27T09:43:34.404+00:00](method-runs/80f6658cf12342318f5f2641c6466772.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.8 | — |
| [2026-11-27T09:43:33.695+00:00](method-runs/3a93abf5ddda46faa8cb9189d55a313a.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.7 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
