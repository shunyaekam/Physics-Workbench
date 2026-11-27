# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 27 | 0 | 21.8 | — | — |
| e27-schmidt | 27 | 0 | 36.9 | — | — |
| gagatsos-2026-c1 | 102 | 0 | 171.8 | — | — |
| golay43 | 55 | 3 | 435.4 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 2 | 0 | 249.3 | 878,620 / 8,904 | 2/2 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| refined-bmv | 28 | 0 | 50.3 | 69,669 / 997 | 1/1 |
| support-enumeration | 4 | 0 | 124.0 | — | — |
| thomson-10 | 7 | 0 | 1.9 | — | — |
| thomson-11 | 6 | 0 | 1.6 | — | — |
| thomson-13 | 7 | 0 | 3.5 | — | — |
| thomson-14 | 7 | 0 | 3.2 | — | — |
| werner-endpoint | 54 | 0 | 56.0 | — | — |

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
| [2026-11-27T06:58:41.724+00:00](method-runs/76e0e1fe11a749afaf56371a01588efb.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 41.1 | — |
| [2026-11-27T06:58:39.930+00:00](method-runs/ad1384b681a64c0eb76e90543430510e.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 1.8 | — |
| [2026-11-27T06:58:21.531+00:00](method-runs/588fe23dc80540c683f633c02ce4d55e.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.6 | — |
| [2026-11-27T06:58:19.914+00:00](method-runs/6c16821f08564b4b9601bfdfe9ae945a.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.7 | — |
| [2026-11-27T06:58:17.497+00:00](method-runs/eeda0f438c654a61af5348f1e988db82.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T06:58:15.137+00:00](method-runs/ead5aba015844144b511edf1457b329e.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.3 | — |
| [2026-11-27T06:58:09.841+00:00](method-runs/d87582d749a34f07bd406cbd4e1ade4f.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 5.2 | — |
| [2026-11-27T06:57:45.948+00:00](method-runs/f83c2654b97745ad9a680b20c9251b4f.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 1.8 | — |
| [2026-11-27T06:57:45.837+00:00](method-runs/6e22eebe501e473cb4fb13d9c8862841.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T06:57:44.276+00:00](method-runs/ad471070a58c475e8f9a2aa48befa892.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 1.6 | — |
| [2026-11-27T06:57:43.873+00:00](method-runs/5a783b6f56e1492e8fd90e70c6e9ce4c.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T06:57:42.623+00:00](method-runs/60ad3cf466ee4d9e8b99cabe24805178.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-27T06:45:27.376+00:00](method-runs/d76da7b246264a7fa38a48e8e4352b47.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T06:45:26.450+00:00](method-runs/400341ac9b8d47d5ba01860c1ac4db93.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T06:45:25.995+00:00](method-runs/453954b182024a84ab754a0acd4f2425.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T06:45:25.844+00:00](method-runs/9ef30d6f839b438a8076fac6eaf2f557.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T06:45:22.783+00:00](method-runs/903de7069018459788d14172c3350f5e.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-27T06:45:21.654+00:00](method-runs/2107ac1b855143828431e09013185ace.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T06:45:20.851+00:00](method-runs/0bc04a1df7234bf4affefda165b0fc64.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.8 | — |
| [2026-11-27T06:45:08.993+00:00](method-runs/a7e7936c2cb34124b96ce42a185238ad.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T06:45:08.871+00:00](method-runs/bd48f11434b34f72b5fc715b66f8ce53.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T06:45:08.755+00:00](method-runs/93395d3e91e7486b978e06f599ea1567.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T06:45:08.617+00:00](method-runs/d71768b54e6449829cb8592c7375d6b3.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T06:45:08.289+00:00](method-runs/4199d3876a5e415b8f1f2066fa2cb60f.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T06:34:30.829+00:00](method-runs/97d6d07caf9646719aff9c56501f65f5.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T06:34:27.635+00:00](method-runs/3a3912e846b446b49b8c7dfd8d1ce93e.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T06:34:27.182+00:00](method-runs/1fb4b079705641f09cf06bef0c0eafab.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T06:34:27.045+00:00](method-runs/f8760d5322714de295fe76a5ebb8c98b.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T06:34:20.798+00:00](method-runs/1f4a645a5fd0416ab3b76e03a7e9ecb1.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 3.6 | — |
| [2026-11-27T06:34:19.055+00:00](method-runs/d403c6f244a343d8b7b8872233fa5f96.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.7 | — |
| [2026-11-27T06:34:17.821+00:00](method-runs/cac14772c8c944deabf112557710115b.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.2 | — |
| [2026-11-27T06:33:56.154+00:00](method-runs/ae474f450763429aa1befc505cece39d.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.6 | — |
| [2026-11-27T06:33:55.869+00:00](method-runs/724273482f634dfa9348c2e10c296129.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T06:33:47.898+00:00](method-runs/e7a2a1e1296a41ceb2c3c34c7a5c5dd8.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 8.0 | — |
| [2026-11-27T06:33:43.833+00:00](method-runs/c860a741d96749d4be698798e45b1285.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 3.7 | — |
| [2026-11-27T06:33:33.682+00:00](method-runs/3690a5b813b94a74b78efab50d4b15ce.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 10.2 | — |
| [2026-11-27T06:20:01.012+00:00](method-runs/af85240f51794be7a9ec188d917baa37.json) | lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | scout | continue-scored-lemma | gpt-6.2-sol / low | completed / insufficient_evidence | 142.8 | 485,808 / 5,514 |
| [2026-11-27T06:19:58.601+00:00](method-runs/0d8fd0ca372c488f8415a6ffaa618b66.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T06:19:57.010+00:00](method-runs/c5e6ba16e436456a8fbe948c42fe2d04.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.7 | — |
| [2026-11-27T06:19:56.290+00:00](method-runs/00a2ca5bbf614584b593eb4500a19752.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.7 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
