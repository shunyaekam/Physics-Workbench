# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 52 | 0 | 37.2 | — | — |
| e27-schmidt | 52 | 0 | 57.4 | — | — |
| gagatsos-2026-c1 | 196 | 0 | 361.1 | — | — |
| golay43 | 105 | 28 | 473.6 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 1 | 0 | 190.8 | 797,530 / 5,583 | 1/1 |
| refined-bmv | 54 | 0 | 122.8 | 226,762 / 2,761 | 2/2 |
| support-enumeration | 7 | 0 | 228.0 | — | — |
| thomson-10 | 13 | 0 | 7.3 | — | — |
| thomson-11 | 13 | 0 | 4.4 | — | — |
| thomson-13 | 13 | 0 | 7.0 | — | — |
| thomson-14 | 13 | 0 | 5.3 | — | — |
| werner-endpoint | 105 | 0 | 129.2 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T11:54:07.522+00:00](method-runs/a0440661f3cc4a7faa84abaf2e78fdf7.json) | refined-bmv | solve | notebook-witness | gpt-6.2-astra / medium | completed / bounded_result | 65.3 | 157,093 / 1,764 |
| [2026-11-27T11:53:59.835+00:00](method-runs/d7233215b6904fbca510d18de656433e.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T11:53:59.073+00:00](method-runs/6d80e2452b374bcaaa3966b35c853cae.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T11:53:58.600+00:00](method-runs/8476e9b6e02641d58cbadd2056a48e33.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T11:53:58.477+00:00](method-runs/e5b03b1f915b492792e4b9a4d0ae4aae.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T11:53:55.033+00:00](method-runs/f06b61b4d3a94d249847be85a9138405.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T11:53:50.524+00:00](method-runs/908e04d16c244912bcd69c26a18afb75.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 4.5 | — |
| [2026-11-27T11:53:42.725+00:00](method-runs/63ed6dd6c7ef4968b767775fcca9eb48.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 7.8 | — |
| [2026-11-27T11:53:36.072+00:00](method-runs/fc8768ec095a416db4c1066987e9333c.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T11:53:35.994+00:00](method-runs/979ccd80c142475b918ce66e4e5db5d6.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T11:53:35.958+00:00](method-runs/4f912241d0f54ee4acc81e5556554480.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.0 | — |
| [2026-11-27T11:53:35.840+00:00](method-runs/6e23cf8b9197445f9eb40f75dff4e669.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T11:53:35.299+00:00](method-runs/e4049cf2c9674bfc8017077665e49d49.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.7 | — |
| [2026-11-27T11:42:05.832+00:00](method-runs/603935efe1cb4a59ab81b8fac72d0825.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 28.4 | — |
| [2026-11-27T11:42:05.708+00:00](method-runs/6e675abc7bdf47d2a31e65a57d99261b.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T11:42:01.477+00:00](method-runs/9af1e31fc4da471fa598b312446684e4.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.5 | — |
| [2026-11-27T11:41:59.878+00:00](method-runs/43548af2b95c4023a1dbbaa4e4dfc03f.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.6 | — |
| [2026-11-27T11:41:58.126+00:00](method-runs/793a171f76c44fe2ad24c637deeb3e7d.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.0 | — |
| [2026-11-27T11:41:57.030+00:00](method-runs/954d962a1df14a3cb3dea4e6223f9dc6.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T11:41:53.685+00:00](method-runs/1e877d166bca4405b8328820bedbf688.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 3.3 | — |
| [2026-11-27T11:41:45.575+00:00](method-runs/32d1364dfe5d46cea6860fe07b263add.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T11:41:45.473+00:00](method-runs/f18e8f857ba3488080610e7ac7e3be6e.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T11:41:45.362+00:00](method-runs/6c07e4f976674b829e57db52339e0f54.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T11:41:45.242+00:00](method-runs/32be50c265e34219afe4110a945e2e6b.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T11:41:44.952+00:00](method-runs/8768fabbbe32489e85134fc6344f26fc.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T11:31:16.908+00:00](method-runs/77d2a5f7ecab45f59dbb756b97f9d2e7.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T11:31:08.893+00:00](method-runs/91fe20f082ad44d990c26a17f0fb10d8.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T11:31:08.488+00:00](method-runs/3b3f3228dcf84e2296f00a1041460ca2.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T11:31:08.363+00:00](method-runs/2cee54c6d0cb4e938890a41477ea66be.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T11:31:03.841+00:00](method-runs/3d8e3df7caac469890bf1a1557dcf060.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.5 | — |
| [2026-11-27T11:30:59.147+00:00](method-runs/62ea16d5a969451281454e257dca2529.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 4.7 | — |
| [2026-11-27T11:30:52.418+00:00](method-runs/a75ba8a4dea345abaf4a1e42d54735e3.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 6.7 | — |
| [2026-11-27T11:30:08.971+00:00](method-runs/cd28bf4aa7eb4cc487d75ada8dc9f73d.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 1.7 | — |
| [2026-11-27T11:30:08.621+00:00](method-runs/ee3bd14721844cfcb6fe178cfe1cf9c2.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T11:30:03.984+00:00](method-runs/bed2b5594d4b4f55b4537f8d00cacef9.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 4.6 | — |
| [2026-11-27T11:30:01.914+00:00](method-runs/6fc8840176d547408234a2c193f7c5bd.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 2.1 | — |
| [2026-11-27T11:29:59.968+00:00](method-runs/5a0d4b25b08d40cea9ed3e394d48daf3.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T11:19:09.021+00:00](method-runs/3330c0b0b8b84d6ab7896ab51c21acb3.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-27T11:19:04.331+00:00](method-runs/d8b3fd11e754444396457b5c2b6d9300.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T11:19:03.911+00:00](method-runs/a79797f8b2a141fc94beb5f390eae7e0.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
