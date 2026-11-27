# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 78 | 0 | 72.1 | — | — |
| e27-schmidt | 78 | 0 | 101.4 | — | — |
| gagatsos-2026-c1 | 294 | 0 | 1,075.0 | — | — |
| golay43 | 157 | 54 | 530.8 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 2 | 2 | 256.0 | — | 0/1 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 81 | 0 | 194.2 | 284,541 / 4,116 | 3/3 |
| support-enumeration | 10 | 0 | 332.1 | — | — |
| thomson-10 | 20 | 0 | 11.6 | — | — |
| thomson-11 | 19 | 0 | 6.2 | — | — |
| thomson-13 | 20 | 0 | 10.6 | — | — |
| thomson-14 | 19 | 0 | 10.0 | — | — |
| werner-endpoint | 157 | 0 | 173.9 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T16:59:08.435+00:00](method-runs/45c2f2b737244b8c88f5fd45644e2723.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.4 | — |
| [2026-11-27T16:59:06.906+00:00](method-runs/0dc0946a7c3746b3a077465e878aaa4a.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T16:59:03.632+00:00](method-runs/ad0502129eb94c528de470ba62477319.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 3.3 | — |
| [2026-11-27T16:58:55.373+00:00](method-runs/19b2e77fd5554abda9f7ff4e4e645331.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T16:58:55.279+00:00](method-runs/07c65a71179f44a69e878b317cf28ec5.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T16:58:55.177+00:00](method-runs/76892682a7ea4824870d6cc86b603dc6.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T16:58:55.069+00:00](method-runs/68275b8a04d64de7bfb831e73ec1dc18.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T16:58:54.795+00:00](method-runs/57f13e0a4eee4573971f622b5eaeb096.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T16:47:31.580+00:00](method-runs/9896dcf756fa43eaa39de6256312a6de.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 36.7 | — |
| [2026-11-27T16:47:30.840+00:00](method-runs/79366a6255204c9da666b57094643db1.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.7 | — |
| [2026-11-27T16:47:21.716+00:00](method-runs/cdab28b740f3438290650060be7acecd.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.5 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
