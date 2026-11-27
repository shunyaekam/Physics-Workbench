# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 83 | 0 | 75.4 | — | — |
| e27-schmidt | 83 | 0 | 104.6 | — | — |
| gagatsos-2026-c1 | 312 | 0 | 1,109.4 | — | — |
| golay43 | 167 | 59 | 532.3 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 2 | 2 | 256.0 | — | 0/1 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 87 | 1 | 214.9 | 284,541 / 4,116 | 3/4 |
| support-enumeration | 11 | 0 | 405.1 | — | — |
| thomson-10 | 21 | 0 | 11.9 | — | — |
| thomson-11 | 20 | 0 | 6.5 | — | — |
| thomson-13 | 21 | 0 | 10.9 | — | — |
| thomson-14 | 21 | 0 | 10.6 | — | — |
| werner-endpoint | 167 | 0 | 190.9 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T18:26:42.341+00:00](method-runs/e2e7709af0064a8dbb52f93f7d82e50e.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 73.0 | — |
| [2026-11-27T18:26:42.063+00:00](method-runs/0d3742600c014ac0b47a0a588fd5c69d.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T18:26:37.164+00:00](method-runs/48c87eaaf31a4a9c9cd3d79c1cc31100.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 3.6 | — |
| [2026-11-27T18:26:33.325+00:00](method-runs/2479c86d88764bc19a2b9f4f195a8c09.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 3.9 | — |
| [2026-11-27T18:26:29.761+00:00](method-runs/2f6ef3e3f1dc4e05bc443622359cf852.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T18:26:27.736+00:00](method-runs/cfe9d27ecfb44bdf80c0d50d4d2e953b.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T18:26:26.592+00:00](method-runs/1215253d2f4c4b8f8a213ab89ebff45f.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.1 | — |
| [2026-11-27T18:26:12.671+00:00](method-runs/7457635eedb748a795b176a343706cec.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T18:26:12.478+00:00](method-runs/3356f9147db44875959a4b1021ce861c.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T18:26:12.409+00:00](method-runs/dd3807c932da4b81b43a0529f1128f58.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T18:26:12.190+00:00](method-runs/e69c645af36e48178d59687d9872015b.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T18:26:11.634+00:00](method-runs/54b97c692857442a9855ba7561809696.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-27T18:15:34.578+00:00](method-runs/7a6f7859d85a4284bd31a8e0f22dc510.json) | refined-bmv | solve | notebook-witness | gpt-6.2-astra / medium | failed / RuntimeError | 19.8 | — |
| [2026-11-27T18:15:31.246+00:00](method-runs/2a388699baa34732afd660f3244f84c0.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T18:15:29.726+00:00](method-runs/ca96101e3b5f4b5cb96127da131caf9b.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T18:15:28.711+00:00](method-runs/3b5ee604be974d718bbf24923bcb1ff8.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T18:15:28.433+00:00](method-runs/9f01fc1480024ff4af520814c66f3c63.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T18:15:23.342+00:00](method-runs/48e52e88368849f19902856f6afca62b.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T18:15:21.463+00:00](method-runs/ac2afcf1b4d0424c876ef88683640e96.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.9 | — |
| [2026-11-27T18:15:20.332+00:00](method-runs/6ed63826b155465ca8fdb6aa13c6285d.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.1 | — |
| [2026-11-27T18:15:06.453+00:00](method-runs/6b9bafed86d84960993132a59e0c8c67.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T18:15:06.265+00:00](method-runs/14c38e1237904389a71158ffec4aeffc.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T18:15:06.213+00:00](method-runs/8d0a7c827bdb4fa0b5ee3a6ee099ac98.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T18:15:06.016+00:00](method-runs/6b1a034ea66245c28fb35d33b84d5d85.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T18:15:05.457+00:00](method-runs/e43eb46b697744be9ae7bc66000e5ec1.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-27T18:04:44.452+00:00](method-runs/3d29b3ee89ec46b69a17d16e03175e11.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T18:04:42.945+00:00](method-runs/786d9c71089846f2bf4a6e106168109d.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T18:04:41.954+00:00](method-runs/a57cda260d964330a93bdb0a4261e8bf.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T18:04:41.679+00:00](method-runs/ecee9da79bcd4e4cbd8cf7ca06e8ee33.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T18:04:36.644+00:00](method-runs/a53d3dc1e94548828b3d23367d7fc360.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T18:04:34.656+00:00](method-runs/50f366fb0d464f5999503b057a681187.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T18:04:33.523+00:00](method-runs/d684d81ac95f40129f49d6496d7bfda9.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.1 | — |
| [2026-11-27T18:04:19.558+00:00](method-runs/ee1ff5ae076a44b19c2898929619d611.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T18:04:19.364+00:00](method-runs/7813367023654ab8abb75dc88f5f7276.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T18:04:19.293+00:00](method-runs/2a9c7da354034a889820d866eb86db7d.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T18:04:19.106+00:00](method-runs/ccea653e20ec4a508af28464e94588ae.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T18:04:18.567+00:00](method-runs/755d384aa8b5436288659302fc302926.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-27T17:53:56.279+00:00](method-runs/43aa0d1bfc9d4234ac371f294aa0763e.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T17:53:54.603+00:00](method-runs/738c98c81cd045c7ae330328e3af20e8.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T17:53:53.628+00:00](method-runs/05425b198d9f44f48ed2a049bdcad908.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
