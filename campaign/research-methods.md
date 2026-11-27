# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 64 | 0 | 54.5 | — | — |
| e27-schmidt | 64 | 0 | 84.7 | — | — |
| gagatsos-2026-c1 | 241 | 0 | 734.1 | — | — |
| golay43 | 129 | 40 | 506.0 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 66 | 0 | 132.9 | 226,762 / 2,761 | 2/2 |
| support-enumeration | 8 | 0 | 261.1 | — | — |
| thomson-10 | 16 | 0 | 9.9 | — | — |
| thomson-11 | 16 | 0 | 5.6 | — | — |
| thomson-13 | 16 | 0 | 8.4 | — | — |
| thomson-14 | 16 | 0 | 8.0 | — | — |
| werner-endpoint | 129 | 0 | 152.0 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T14:34:29.993+00:00](method-runs/5b683fcc87ee4040a053368083b6f260.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T14:34:22.142+00:00](method-runs/f58044aff4b04212a5e38add5a558432.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T14:34:21.483+00:00](method-runs/e2074b8fd46442a3bc514f7febd741e2.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.7 | — |
| [2026-11-27T14:34:20.952+00:00](method-runs/69f5e5399eaf4e0ba209f08dbf4f7e6b.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 1.7 | — |
| [2026-11-27T14:33:41.140+00:00](method-runs/38c90c58755e4a51a56db4dbecf8f1cf.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 12.4 | — |
| [2026-11-27T14:33:27.111+00:00](method-runs/f9c13f726f0f47b4913237c082c56b0e.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 14.0 | — |
| [2026-11-27T14:33:14.603+00:00](method-runs/f742f0c49d314996897edeee4254bfcd.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 12.5 | — |
| [2026-11-27T14:33:04.121+00:00](method-runs/384a5688b6c74c6eb27fc005337592e3.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T14:33:04.025+00:00](method-runs/25ccf1b0aa9640749e198465fcb00be4.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T14:33:03.893+00:00](method-runs/95ea2f85992f4265b65cb67e848b62c0.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T14:33:03.655+00:00](method-runs/747d4699f18e4fc9bfae68c3e3ae3328.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T14:33:03.344+00:00](method-runs/5d3d990f05404009a7c3911d6d85d30d.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T14:22:05.109+00:00](method-runs/ae76e57d72e9487381e935d5812cbeb5.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.7 | — |
| [2026-11-27T14:21:48.093+00:00](method-runs/499f99f997bd414a9d53e8408f6fffbb.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 3.0 | — |
| [2026-11-27T14:21:46.106+00:00](method-runs/4262d440718e45b3876b1608d6ffa677.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 2.4 | — |
| [2026-11-27T14:21:20.927+00:00](method-runs/f29eafb9544e47809f3bce766979201a.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 12.2 | — |
| [2026-11-27T14:21:07.612+00:00](method-runs/9a26eea3188b496f9de845301c9f64d3.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 13.3 | — |
| [2026-11-27T14:20:54.572+00:00](method-runs/e300599abce74f07bdb128ccb647c9c7.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 13.0 | — |
| [2026-11-27T14:20:00.867+00:00](method-runs/cf8df68264d24eb1a18284640cf16237.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 2.5 | — |
| [2026-11-27T14:19:59.423+00:00](method-runs/ef41fb74d7f04a25a71afbdfb986d2e6.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T14:19:55.121+00:00](method-runs/00357746c621463ba58cdbae476e56b4.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 4.3 | — |
| [2026-11-27T14:19:54.730+00:00](method-runs/40894d024e154597870338e1c597fd1e.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T14:19:50.912+00:00](method-runs/1a62110621754554a188c9e4ef8b3e28.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 3.9 | — |
| [2026-11-27T14:06:31.844+00:00](method-runs/72193671721d41a18a5359fd7bc6ba1b.json) | lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | scout | continue-scored-lemma | gpt-6.2-sol / low | completed / insufficient_evidence | 147.2 | 198,874 / 5,293 |
| [2026-11-27T14:06:20.726+00:00](method-runs/2cd7727ab54949f780b87486b6f481c7.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 1.5 | — |
| [2026-11-27T14:06:14.803+00:00](method-runs/07af1dad4979401f8112f39f29fd1328.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T14:06:14.310+00:00](method-runs/76020d6066d84a6d967e51fd27a92e7c.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T14:06:14.140+00:00](method-runs/314094ce814b414fa7d15c04a4383c83.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T14:06:10.541+00:00](method-runs/cf17bbfb460645e2abf4d7cb4656eb9f.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T14:06:08.994+00:00](method-runs/0176a09d388b4448b16935f8c3e81a55.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T14:05:58.207+00:00](method-runs/f9a446d96e89462d9aa0cdd0c5d66149.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 10.8 | — |
| [2026-11-27T14:05:36.395+00:00](method-runs/14c1407218944178a3053642b95afbe6.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T14:05:36.255+00:00](method-runs/7dfa2dd139464a8db443476c2dc6ba4c.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T14:05:35.926+00:00](method-runs/1d9875ea7ea644d0a5b8e8712b6a1393.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.3 | — |
| [2026-11-27T14:05:35.510+00:00](method-runs/364bf7a99c53443ea6e4cea055514660.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T14:05:32.977+00:00](method-runs/3f6fa7c9f3f4463a9b41e12f5a982c95.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 2.6 | — |
| [2026-11-27T13:54:19.010+00:00](method-runs/c8464345187d451d8727615f92717be5.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.7 | — |
| [2026-11-27T13:54:17.351+00:00](method-runs/ba9b3cbef09a42438388a84efb1ae167.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.8 | — |
| [2026-11-27T13:54:16.837+00:00](method-runs/1d9c35c3c36c4b0ca6636d68cdd054bd.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T13:54:16.703+00:00](method-runs/e36ed134276d4041bd74b72c70973702.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
