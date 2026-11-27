# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 95 | 0 | 79.8 | — | — |
| e27-schmidt | 95 | 0 | 112.0 | — | — |
| gagatsos-2026-c1 | 357 | 0 | 1,170.4 | — | — |
| golay43 | 191 | 71 | 536.1 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 99 | 1 | 216.8 | 284,541 / 4,116 | 3/4 |
| support-enumeration | 12 | 0 | 480.8 | — | — |
| thomson-10 | 24 | 0 | 12.9 | — | — |
| thomson-11 | 23 | 0 | 7.3 | — | — |
| thomson-13 | 24 | 0 | 11.9 | — | — |
| thomson-14 | 24 | 0 | 11.7 | — | — |
| werner-endpoint | 191 | 0 | 223.2 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T20:48:23.401+00:00](method-runs/18c198388c20456fabe4328b3ca1a9a9.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.7 | — |
| [2026-11-27T20:48:18.436+00:00](method-runs/f8ede015f2fb43f3a798d0a9a84b50ff.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 3.6 | — |
| [2026-11-27T20:48:14.406+00:00](method-runs/a87bbc41a2f042e58b1a80fd7d6d25c6.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 4.1 | — |
| [2026-11-27T20:48:10.772+00:00](method-runs/7d61f6e70f5e4f87a5501ad3c732b16d.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T20:48:08.702+00:00](method-runs/f2decc9d7e2b42eeba44daf5290ef850.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T20:48:07.299+00:00](method-runs/ad3e32831ee04114b160bdc5fa730338.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T20:47:52.620+00:00](method-runs/2fc8b1bb957b42918b73ce2d7f74bc1c.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T20:47:52.422+00:00](method-runs/fa3c51e70bcd4454b9066ebdb6d65d51.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T20:47:52.263+00:00](method-runs/ef0cfbc410a140d7a94bb747f14a9e46.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T20:47:52.040+00:00](method-runs/6ac758b647be4f7297e4822ce7b15103.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T20:47:51.463+00:00](method-runs/d1b64caf220b42a58fcfdeb93d383fbf.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-27T20:37:29.282+00:00](method-runs/b02bec4b1a354cb5a08c4c12dd032a35.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-27T20:37:27.640+00:00](method-runs/155b3e7fe1e44baea314650b61ef6b34.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T20:37:26.624+00:00](method-runs/64c656ed48d94de483c1b8a391f77248.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T20:37:26.359+00:00](method-runs/f1893f390be847ceb74d20978e085c54.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T20:37:21.171+00:00](method-runs/35a0a475836e43e589e3cabbfe12ae41.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T20:37:19.071+00:00](method-runs/19e4862a449e41339d729e0a4659f73a.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T20:37:17.622+00:00](method-runs/d444efa2a3fe45bc81fe82767bf686a7.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T20:37:02.191+00:00](method-runs/7276735a72eb432188eb859821bf9bb5.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.5 | — |
| [2026-11-27T20:37:01.991+00:00](method-runs/5a5eb3f7cb6545dd9e9a9fc5bdc68d4f.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T20:37:01.829+00:00](method-runs/d278be5c60a243ee9656d4071de0de35.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T20:37:01.599+00:00](method-runs/5f368b0063aa4f3898f60178be8e8ca0.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T20:37:00.958+00:00](method-runs/faa0429c06ab4855b1841443afe0d98d.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.7 | — |
| [2026-11-27T20:26:21.952+00:00](method-runs/285d1f32e77c4c8e89eaea270695bf5f.json) | lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | scout | source-screen-and-notebook | gpt-6.2-sol / low | failed / RuntimeError | 20.9 | — |
| [2026-11-27T20:26:18.184+00:00](method-runs/e478636d5ac343dfa410d7e54741cd78.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T20:26:16.575+00:00](method-runs/3e0072a166a645f2bdfb26ebff524a7e.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T20:26:15.566+00:00](method-runs/605977e808b848d0bf8e3fc6599f38a8.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T20:26:15.274+00:00](method-runs/380c3314afdd4479bdca9c51d51ab686.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T20:26:10.230+00:00](method-runs/57dc4ad7ad93476ba4dfa02044b8c03c.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T20:26:08.136+00:00](method-runs/98b73eb178214c71b7c42ab933fd90dd.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T20:26:06.732+00:00](method-runs/9e78180638af4b3ab6879399e595e880.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T20:25:51.428+00:00](method-runs/76c59e18244f4b29a15ed4e1d5599fb7.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.5 | — |
| [2026-11-27T20:25:51.227+00:00](method-runs/e72867ac138046328770eb904f2e65ce.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T20:25:51.070+00:00](method-runs/3ed4641f36af4151946324672df21e48.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T20:25:50.845+00:00](method-runs/eaa24ffa8c104e449904fb092cbf9d30.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T20:25:50.211+00:00](method-runs/3628f314ca28489ca8cdeb23d00b82f4.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.7 | — |
| [2026-11-27T20:15:27.711+00:00](method-runs/c69ae0f696f643c296c5f792d3b88e13.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T20:15:26.099+00:00](method-runs/5043819645d94f0f81a3d9f3d117e2cc.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T20:15:25.107+00:00](method-runs/a3ecb37eb3d5479da62d931673c25c94.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T20:15:24.847+00:00](method-runs/8a13293546d342d69a427240c57524f6.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
