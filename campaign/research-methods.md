# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 75 | 0 | 66.5 | — | — |
| e27-schmidt | 75 | 0 | 97.1 | — | — |
| gagatsos-2026-c1 | 282 | 0 | 997.8 | — | — |
| golay43 | 151 | 51 | 521.3 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 78 | 0 | 191.7 | 284,541 / 4,116 | 3/3 |
| support-enumeration | 10 | 0 | 332.1 | — | — |
| thomson-10 | 19 | 0 | 10.8 | — | — |
| thomson-11 | 18 | 0 | 6.0 | — | — |
| thomson-13 | 19 | 0 | 10.5 | — | — |
| thomson-14 | 19 | 0 | 10.0 | — | — |
| werner-endpoint | 151 | 0 | 171.0 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T16:47:31.580+00:00](method-runs/9896dcf756fa43eaa39de6256312a6de.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 36.7 | — |
| [2026-11-27T16:47:30.840+00:00](method-runs/79366a6255204c9da666b57094643db1.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.7 | — |
| [2026-11-27T16:47:21.716+00:00](method-runs/cdab28b740f3438290650060be7acecd.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.5 | — |
| [2026-11-27T16:47:20.039+00:00](method-runs/139f29ec7f3f45a3a3645bcee7bb2644.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.7 | — |
| [2026-11-27T16:47:18.259+00:00](method-runs/7f6dc9e0564740d396999cedd433e40f.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.0 | — |
| [2026-11-27T16:47:17.208+00:00](method-runs/ae0ee4dc057546759eb4a65c0b2c6330.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.0 | — |
| [2026-11-27T16:47:08.974+00:00](method-runs/645ef55c3eb14003b1496a0542d7fa98.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 8.2 | — |
| [2026-11-27T16:46:33.430+00:00](method-runs/02df0da6ede74862ba3aefc0b96f45bd.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-27T16:46:33.030+00:00](method-runs/29ab8239ee7e40f5ac8d2475d031a698.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T16:46:28.476+00:00](method-runs/27b0124663d646ae952741afb05a91bc.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 4.6 | — |
| [2026-11-27T16:46:28.116+00:00](method-runs/38a43bd5da70492f8b4337f9242febf4.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T16:46:25.406+00:00](method-runs/77a284a597f149ef8846f854838fa385.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 2.7 | — |
| [2026-11-27T16:35:50.627+00:00](method-runs/2a4256ccf0554bb487cbe26668fe5c9a.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T16:35:42.099+00:00](method-runs/2f4cd49530414aefb68c059390ecc27a.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T16:35:41.660+00:00](method-runs/cd977ee214044bbd8d6e5da02362ddb8.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T16:35:41.273+00:00](method-runs/6096f12445564de2a9d7719723e41043.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.8 | — |
| [2026-11-27T16:35:10.044+00:00](method-runs/4bec3b8be73f473f99806eaa5f5a06f5.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 9.6 | — |
| [2026-11-27T16:34:56.798+00:00](method-runs/584ad9c29bf840a6aaf7af5db3930c5d.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 13.2 | — |
| [2026-11-27T16:34:42.148+00:00](method-runs/abec79bf31cc4cd6905ffd3f1a4cd5c9.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 14.6 | — |
| [2026-11-27T16:34:25.615+00:00](method-runs/0d383826517a4056affd37dab5491141.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T16:34:25.521+00:00](method-runs/9841c0efdb38456cb44ae22e03eeebb5.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T16:34:25.416+00:00](method-runs/cbd5062daf8d459ea2eda016b6c65a13.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T16:34:25.305+00:00](method-runs/bbea2e7cfb70452f958f058cd2f62d2c.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T16:34:25.008+00:00](method-runs/42167529418840e0b2673cf3cb1dca18.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T16:24:08.646+00:00](method-runs/e78df7893a89471d88aa9067eca76720.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T16:24:07.920+00:00](method-runs/e3c2b01766594802ab4f601e195f135c.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T16:24:07.508+00:00](method-runs/ef904d3062874db2b930038a6db937e0.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T16:24:07.392+00:00](method-runs/8004cec8c72444be9645271adfaa47dd.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.1 | — |
| [2026-11-27T16:24:05.085+00:00](method-runs/f93e11c5d5a3466f907e07de3eba6e55.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.0 | — |
| [2026-11-27T16:24:04.201+00:00](method-runs/7899b18f62244fe880439e15c7ca969a.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 0.9 | — |
| [2026-11-27T16:24:02.625+00:00](method-runs/41ba85891fa6462c8d93a955057708bb.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.6 | — |
| [2026-11-27T16:23:54.943+00:00](method-runs/021135817e674edc99244004e5d38047.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T16:23:54.854+00:00](method-runs/38494d696585492eb67bec8f8b86cca0.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T16:23:54.754+00:00](method-runs/82e5adae9911444f89dfd1cf4e14628a.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T16:23:54.623+00:00](method-runs/348d1ea56c28415fad636f7fd3bbe572.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T16:23:54.222+00:00](method-runs/7dfb5304e1db47069c2e0195d1704524.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T16:11:16.130+00:00](method-runs/e0af4f6dc64744fdb58a958531560daf.json) | lts-Erdos1165.erdos_1165.R1.H2 | scout | source-screen-and-notebook | gpt-6.2-sol / low | completed / prior_resolution | 143.0 | 842,263 / 4,374 |
| [2026-11-27T16:11:14.064+00:00](method-runs/2fff4cee059e41ccb2c7d6d87ac4f4b7.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T16:11:12.986+00:00](method-runs/a97d8162b7744cb0b6e31c801cd6ccbf.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T16:11:12.571+00:00](method-runs/c35484f4e2844c22bc6471f5a81e8a48.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
