# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 42 | 0 | 31.7 | — | — |
| e27-schmidt | 42 | 0 | 49.0 | — | — |
| gagatsos-2026-c1 | 159 | 0 | 273.5 | — | — |
| golay43 | 85 | 18 | 460.3 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| refined-bmv | 43 | 0 | 56.1 | 69,669 / 997 | 1/1 |
| support-enumeration | 5 | 0 | 167.6 | — | — |
| thomson-10 | 11 | 0 | 6.8 | — | — |
| thomson-11 | 10 | 0 | 2.7 | — | — |
| thomson-13 | 11 | 0 | 4.7 | — | — |
| thomson-14 | 10 | 0 | 4.8 | — | — |
| werner-endpoint | 85 | 0 | 111.6 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T09:43:33.533+00:00](method-runs/19f5e7f463aa42579e205cd7afe4b572.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T09:43:29.430+00:00](method-runs/ef9b7c9a0a8f4ddb90a48b4ee46e3410.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T09:43:28.382+00:00](method-runs/0018e3eb69ec47d88458a3ed6e29eb6d.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.0 | — |
| [2026-11-27T09:43:27.682+00:00](method-runs/49ea69997f3441629d6258bce0286f0d.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-27T09:43:19.077+00:00](method-runs/62016a9ae81344e19c0b9acda0435f06.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T09:43:18.977+00:00](method-runs/248d8bbe61854994b06439fd40424877.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T09:43:18.873+00:00](method-runs/43f20362fb834ba8989d731b66760fd0.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T09:43:18.762+00:00](method-runs/fd37cd8ca77642eb995c252888203515.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T09:43:18.481+00:00](method-runs/4871c37b28f44dd8a3c863f8330118f4.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T09:31:56.376+00:00](method-runs/6205430d0da4464e85794d933a47fd8b.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T09:31:55.501+00:00](method-runs/306d70c6394d4c51bb04ee26ffc1f079.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T09:31:55.083+00:00](method-runs/380c70fa012b4493bffe6e8d7ca02032.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T09:31:54.937+00:00](method-runs/ee2145e501b247048d5c671177603342.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T09:31:52.107+00:00](method-runs/91672b459eec4c2a836ffb9e415dfc34.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-27T09:31:50.814+00:00](method-runs/d8c146ebf2f8416899ab9a7c1d47efc8.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-27T09:31:49.402+00:00](method-runs/3f7249e6b7314c77a73d85042e962bbc.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T09:31:38.689+00:00](method-runs/7724a4e8c2db492b8e0f07b950dbb4b3.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T09:31:38.580+00:00](method-runs/813cddbf5231422aa4ab008cc06e67a5.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T09:31:38.450+00:00](method-runs/ceb93549c7c444b28800a39df708ea20.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T09:31:38.322+00:00](method-runs/8f887e40a09f4b5fbcc1b8decdeda653.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T09:31:37.994+00:00](method-runs/8e5a01ecf3564cc9805468e0da577f42.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T09:20:23.869+00:00](method-runs/a2abb2075e5848c9a7299c855d33a043.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T09:20:20.769+00:00](method-runs/bb3d1ca191fb425cb7361999d9724866.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 2.3 | — |
| [2026-11-27T09:20:17.396+00:00](method-runs/eada5b7613c0400eb6a4444326f2b3f6.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 3.4 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
