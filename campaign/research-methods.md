# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 79 | 0 | 73.7 | — | — |
| e27-schmidt | 79 | 0 | 102.1 | — | — |
| gagatsos-2026-c1 | 297 | 0 | 1,087.3 | — | — |
| golay43 | 159 | 55 | 531.2 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 2 | 2 | 256.0 | — | 0/1 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 82 | 0 | 194.3 | 284,541 / 4,116 | 3/3 |
| support-enumeration | 10 | 0 | 332.1 | — | — |
| thomson-10 | 20 | 0 | 11.6 | — | — |
| thomson-11 | 19 | 0 | 6.2 | — | — |
| thomson-13 | 20 | 0 | 10.6 | — | — |
| thomson-14 | 20 | 0 | 10.3 | — | — |
| werner-endpoint | 159 | 0 | 177.7 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T17:42:58.048+00:00](method-runs/47fb7e40aa8a4a729c847da14fd0e0a1.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T17:42:50.298+00:00](method-runs/00f3592e14944c2086ae996ef0f103a7.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.8 | — |
| [2026-11-27T17:42:48.462+00:00](method-runs/b66ff5d31e664975b7b589e069fe253c.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.9 | — |
| [2026-11-27T17:42:40.477+00:00](method-runs/d1117ee051a04f3f9517e2fa755eda6e.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 5.2 | — |
| [2026-11-27T17:42:37.340+00:00](method-runs/b9ec14cfced1483e957effebcc4ef948.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 3.1 | — |
| [2026-11-27T17:42:33.280+00:00](method-runs/e974bbe7faf648dfb42a997c6ed70add.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 4.0 | — |
| [2026-11-27T17:42:12.679+00:00](method-runs/d915918689884e1fba829b33a89de9df.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 1.6 | — |
| [2026-11-27T17:42:12.528+00:00](method-runs/83473021204b4b35bfc95d289d29d155.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T17:42:12.333+00:00](method-runs/c7cda50758e044b6a38828d3bdbf2dde.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T17:42:12.142+00:00](method-runs/6a117a6276db4def80fe0177f4ec88fe.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T17:42:11.486+00:00](method-runs/28b0de22257b43b9b797765d8163ecc3.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.7 | — |
| [2026-11-27T17:30:21.943+00:00](method-runs/8eacedb600ff415cab8130c8559ec5e9.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.7 | — |
| [2026-11-27T17:30:11.190+00:00](method-runs/f8ae33d705d04d0ca68e3a075cb58088.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.8 | — |
| [2026-11-27T17:30:10.722+00:00](method-runs/877a9ffb334f465da10641ccab7414e3.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T17:30:10.395+00:00](method-runs/eadeb80bbcc34b279b0c5498bf7be524.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T17:29:22.040+00:00](method-runs/68132821f997428885e67418762e5ff7.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 16.3 | — |
| [2026-11-27T17:29:05.384+00:00](method-runs/c53e1b04efba4c9d8e1739b442ff2835.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 16.6 | — |
| [2026-11-27T17:28:46.935+00:00](method-runs/6d34cb796ce647d19562988987d69850.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 18.5 | — |
| [2026-11-27T17:27:37.505+00:00](method-runs/0444a5707e32421788c6bfa4b26ad694.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 5.1 | — |
| [2026-11-27T17:27:35.196+00:00](method-runs/f31575fa8e784b27870377207238eb52.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 2.3 | — |
| [2026-11-27T17:27:28.381+00:00](method-runs/5c7e18ccb33d4fa1b74ecf8822bf0fd1.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 6.8 | — |
| [2026-11-27T17:27:26.887+00:00](method-runs/41f32c083faa45c7ab2b3837545b48c3.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 1.5 | — |
| [2026-11-27T17:27:25.646+00:00](method-runs/a24122ece9df4e9785f299ec7f7ef1d4.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 1.4 | — |
| [2026-11-27T17:11:25.418+00:00](method-runs/5e1d39c00a2747498c5a417175ee5cdb.json) | lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | scout | source-screen-and-notebook | gpt-6.2-sol / low | timeout / TimeoutError | 240.4 | — |
| [2026-11-27T17:11:21.090+00:00](method-runs/299c928e11404b03a6736d6b3dffc2c2.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T17:11:20.162+00:00](method-runs/a4ad4e40a0dd4cd6834d4e024a162ff8.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T17:11:19.732+00:00](method-runs/78bab8414aa240d39023879bc7f0d755.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T17:11:19.612+00:00](method-runs/94645c1089e54772ab856c594cc68f2f.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T17:11:01.144+00:00](method-runs/268bbd2ce5244b49b8f2e8ca514fb763.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 11.7 | — |
| [2026-11-27T17:10:59.657+00:00](method-runs/4cd8c915b6884b828f90743f8ba52010.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T17:10:54.378+00:00](method-runs/df83357e2a9343afb7f170c2caf01902.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 5.3 | — |
| [2026-11-27T17:10:24.441+00:00](method-runs/669ef4be5eeb42d4a2969e07dc14ed5c.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T17:10:24.355+00:00](method-runs/e50b5cac20e54a5183fd294dd5549813.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T17:10:24.111+00:00](method-runs/be7cdd177ca64c34b7c6af7462c9fe7b.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T17:10:23.285+00:00](method-runs/f4723853585048e58928a9cfac4810a2.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.8 | — |
| [2026-11-27T17:10:20.701+00:00](method-runs/207f634c4beb402ba2af549f90b942b0.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 2.6 | — |
| [2026-11-27T16:59:13.413+00:00](method-runs/c658e580995c4a67a70dfe9a5d2d7395.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T16:59:12.619+00:00](method-runs/bb6c3e9259714ac8afdb4311f88773a7.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T16:59:12.218+00:00](method-runs/96c8817998134a49887f1e0edbfeb6ad.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T16:59:12.096+00:00](method-runs/e48f467cccb9466eb00496789ed62e7b.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
