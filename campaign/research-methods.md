# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 66 | 0 | 58.5 | — | — |
| e27-schmidt | 66 | 0 | 87.8 | — | — |
| gagatsos-2026-c1 | 249 | 0 | 757.7 | — | — |
| golay43 | 133 | 42 | 509.3 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 68 | 0 | 133.1 | 226,762 / 2,761 | 2/2 |
| support-enumeration | 8 | 0 | 261.1 | — | — |
| thomson-10 | 17 | 0 | 10.1 | — | — |
| thomson-11 | 16 | 0 | 5.6 | — | — |
| thomson-13 | 17 | 0 | 9.4 | — | — |
| thomson-14 | 16 | 0 | 8.0 | — | — |
| werner-endpoint | 133 | 0 | 154.9 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T14:57:26.478+00:00](method-runs/a4affed2ef0b4ade93c52024ef31849c.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T14:57:23.729+00:00](method-runs/8a0cac7fe65b40bab4dfa33e84d79556.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T14:57:22.609+00:00](method-runs/3aa17180f6f84c4eb0b29e80eb9c28ec.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.1 | — |
| [2026-11-27T14:57:22.450+00:00](method-runs/3ee3e9503afa43318a4eac063a6746d1.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T14:57:17.467+00:00](method-runs/0118eb9aa5ab45b2ac4d9936c8007d43.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.8 | — |
| [2026-11-27T14:57:14.278+00:00](method-runs/4e9b851289f9418ca490c3582c648465.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 3.2 | — |
| [2026-11-27T14:57:06.348+00:00](method-runs/516a79ca5bb945e0863d6e09ecd43d14.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 7.9 | — |
| [2026-11-27T14:56:33.217+00:00](method-runs/ef4f3f3393c54957a05196d8b5db0827.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 3.7 | — |
| [2026-11-27T14:56:33.104+00:00](method-runs/2a4b92f25ab046c49b761533be3f9189.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T14:56:30.412+00:00](method-runs/0ae7fcf6c9f04e4d9809b776582f8b67.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 2.7 | — |
| [2026-11-27T14:56:30.198+00:00](method-runs/5136186478d94a429ade1fa76218d556.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T14:56:27.528+00:00](method-runs/36811b39b1034ec492d5c83054abd3c8.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 2.7 | — |
| [2026-11-27T14:45:29.847+00:00](method-runs/a835cea017744eea86830e49bad53724.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 1.0 | — |
| [2026-11-27T14:45:28.560+00:00](method-runs/5bf0c19673294329b182bdb425d2ac20.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T14:45:27.946+00:00](method-runs/4b021346e11947d9b7a7c017667d6224.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T14:45:27.782+00:00](method-runs/02eb6724c4d544e6ab9dd19dd64d47f5.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T14:45:23.350+00:00](method-runs/342ec830380e4fc591c669257ba3f073.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T14:45:20.364+00:00](method-runs/99275a99534f4696ba24783609d2a280.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 3.0 | — |
| [2026-11-27T14:45:16.023+00:00](method-runs/6b241a1597c34f58b72e98448dd1f770.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 4.3 | — |
| [2026-11-27T14:45:04.088+00:00](method-runs/ddb66136e5934b4bb6af6715b388664c.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T14:45:03.954+00:00](method-runs/aeecccb7259e4f91a7ec8e2fb165df32.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T14:45:03.803+00:00](method-runs/0f2b3b65b1574fc8bf0118351840a7c4.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T14:45:03.491+00:00](method-runs/5199264372454ab5b899d985fe5848b7.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T14:45:03.099+00:00](method-runs/bb4959f087874f0f8a98f23bb6acc35d.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
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

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
