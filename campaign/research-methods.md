# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 81 | 0 | 74.6 | — | — |
| e27-schmidt | 81 | 0 | 103.4 | — | — |
| gagatsos-2026-c1 | 305 | 0 | 1,098.6 | — | — |
| golay43 | 163 | 57 | 531.8 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 2 | 2 | 256.0 | — | 0/1 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 84 | 0 | 194.7 | 284,541 / 4,116 | 3/3 |
| support-enumeration | 10 | 0 | 332.1 | — | — |
| thomson-10 | 20 | 0 | 11.6 | — | — |
| thomson-11 | 20 | 0 | 6.5 | — | — |
| thomson-13 | 21 | 0 | 10.9 | — | — |
| thomson-14 | 20 | 0 | 10.3 | — | — |
| werner-endpoint | 163 | 0 | 181.5 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T17:53:53.349+00:00](method-runs/704c883c2c144d89ba6850e44034ec73.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T17:53:48.284+00:00](method-runs/b393d3ca6c994afe91736f5141361874.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T17:53:46.286+00:00](method-runs/61c7f00916dd478e8996280fd52f7f60.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T17:53:45.071+00:00](method-runs/be76a631d4df4b929eab20541ccb43b9.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.2 | — |
| [2026-11-27T17:53:30.352+00:00](method-runs/682409ee9959418d8fba2c80e49ab810.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T17:53:30.153+00:00](method-runs/58958b8145c1411f9c9a05356d3b3b33.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T17:53:29.992+00:00](method-runs/55ea634d50064c938d725bf50f8f944d.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T17:53:29.768+00:00](method-runs/871fe8538403478d8725bc20caf9001d.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T17:53:29.113+00:00](method-runs/e2f78d9f60c74a75937b1406ffccfabd.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.7 | — |
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

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
