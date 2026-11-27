# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 54 | 0 | 39.6 | — | — |
| e27-schmidt | 54 | 0 | 61.5 | — | — |
| gagatsos-2026-c1 | 204 | 0 | 416.5 | — | — |
| golay43 | 109 | 30 | 478.0 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 1 | 0 | 190.8 | 797,530 / 5,583 | 1/1 |
| refined-bmv | 56 | 0 | 125.3 | 226,762 / 2,761 | 2/2 |
| support-enumeration | 7 | 0 | 228.0 | — | — |
| thomson-10 | 14 | 0 | 7.4 | — | — |
| thomson-11 | 13 | 0 | 4.4 | — | — |
| thomson-13 | 14 | 0 | 7.6 | — | — |
| thomson-14 | 13 | 0 | 5.3 | — | — |
| werner-endpoint | 109 | 0 | 131.1 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T12:19:47.803+00:00](method-runs/0cd6fb3e927645b39c0ce22d3d66a023.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T12:19:46.934+00:00](method-runs/029ccb3260f8455a837e04c844ad7862.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T12:19:46.523+00:00](method-runs/ced8578bab664053a5be8868b5470104.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T12:19:46.389+00:00](method-runs/47c347a81adc41dc86293c97ec3e9bd2.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T12:19:43.461+00:00](method-runs/90eed9a38614424688686e9a437bec8a.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.4 | — |
| [2026-11-27T12:19:42.003+00:00](method-runs/b0b4ebcb242d4c8f8ce202cd25d2a256.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T12:19:33.131+00:00](method-runs/fdec3a543be64d0e98df96ccf2c9a296.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 8.9 | — |
| [2026-11-27T12:19:22.594+00:00](method-runs/5302512bb0cc4019a6de65e4d4f185c7.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T12:19:22.470+00:00](method-runs/7bb2859ea94a4790953fce09ab6bd3a3.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T12:19:22.336+00:00](method-runs/26a749507066418b82b3d972aad235ea.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T12:19:22.156+00:00](method-runs/ad73aa8166664d99b014a3e82018ef55.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T12:19:21.756+00:00](method-runs/c1439b285c5748a4a3f60eac81723c25.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T12:08:55.918+00:00](method-runs/135c08a86dc24c7a857023c7e54bfbce.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.7 | — |
| [2026-11-27T12:08:47.691+00:00](method-runs/21b1e955289441758bb9e5ca82e41665.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T12:08:47.057+00:00](method-runs/8f5bdcb15dd04a5380f57cd3d1a512e2.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T12:08:46.780+00:00](method-runs/0ef34caef55f445786de1429188055df.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T12:08:09.152+00:00](method-runs/8d71c6e9718c4ce6b0231368a59cfd14.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 12.1 | — |
| [2026-11-27T12:07:54.468+00:00](method-runs/e0864792ef494d84998fa7b9c8e7e769.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 14.7 | — |
| [2026-11-27T12:07:38.658+00:00](method-runs/1e4c23aab82c4541bcae7f06155425d7.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 15.8 | — |
| [2026-11-27T12:06:44.330+00:00](method-runs/0356fb57e4e641d48aa051786853d0a8.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 2.0 | — |
| [2026-11-27T12:06:41.934+00:00](method-runs/7778707b392d4f0181f0d50c12829c8f.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 2.4 | — |
| [2026-11-27T12:06:38.143+00:00](method-runs/43e4321916c54f0d966f93e2896a44fa.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 3.8 | — |
| [2026-11-27T12:06:37.836+00:00](method-runs/e3b2d3a267b545899fd320bf0eac8f5f.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T12:06:34.355+00:00](method-runs/5f939d764eb54b1d96b12ae5797ad7ff.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 3.6 | — |
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

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
