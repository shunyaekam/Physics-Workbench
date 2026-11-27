# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 86 | 0 | 76.5 | — | — |
| e27-schmidt | 86 | 0 | 106.2 | — | — |
| gagatsos-2026-c1 | 324 | 0 | 1,124.1 | — | — |
| golay43 | 173 | 62 | 533.0 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 2 | 2 | 256.0 | — | 0/1 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 90 | 1 | 215.4 | 284,541 / 4,116 | 3/4 |
| support-enumeration | 11 | 0 | 405.1 | — | — |
| thomson-10 | 22 | 0 | 12.1 | — | — |
| thomson-11 | 21 | 0 | 6.7 | — | — |
| thomson-13 | 22 | 0 | 11.1 | — | — |
| thomson-14 | 21 | 0 | 10.6 | — | — |
| werner-endpoint | 173 | 0 | 196.0 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T19:00:18.652+00:00](method-runs/b7c10347327d490f9c844724df75580f.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T19:00:17.396+00:00](method-runs/dc7b1dae724f4dd1b30d692a8de995e4.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T19:00:16.737+00:00](method-runs/384fa21c35fd41d4bb137b38b49a2725.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.7 | — |
| [2026-11-27T19:00:16.560+00:00](method-runs/9564aab5665546c0b3c934eaea088084.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T19:00:12.480+00:00](method-runs/5dc83ca17d41498ca917f151db2556b7.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-27T19:00:11.362+00:00](method-runs/2567da1cf2154ca6982363e15820b680.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T19:00:10.587+00:00](method-runs/4e97f2f1b34e4a298b6c207beaf13460.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.8 | — |
| [2026-11-27T18:59:59.135+00:00](method-runs/9341650fac294a5787500627eb927681.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T18:59:59.025+00:00](method-runs/7f88b01d2f6b44d888ecc203104b54aa.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T18:59:58.901+00:00](method-runs/85c493ca6bc3495ba9543b42977076ca.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T18:59:58.732+00:00](method-runs/5824e112cc1b4ad495d1a1a14c6be44d.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T18:59:58.412+00:00](method-runs/6dcc3a7af390435db2ec11bd5c8f6b8b.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T18:49:28.709+00:00](method-runs/4de6c174238348ffb2dabb51cd0ce224.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T18:49:27.154+00:00](method-runs/108c176c908d4523bd430a30bb57093e.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T18:49:26.162+00:00](method-runs/ca313fd7f02f42e3bcb8e5f73eb86001.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T18:49:25.900+00:00](method-runs/8aa03bb5026f43f899f53e871aa14dab.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T18:49:20.860+00:00](method-runs/569a10d825024aa8bdb697992e856610.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T18:49:18.863+00:00](method-runs/e0e78e27d0464226a58b09acdb7d5609.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T18:49:17.718+00:00](method-runs/91087cc6ab394d95ab9b9203556caa93.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.1 | — |
| [2026-11-27T18:49:03.806+00:00](method-runs/354cc69f2c2d4aa8a7fc8038614d81e5.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T18:49:03.606+00:00](method-runs/c63cd0581e78489c800d9ca74000fece.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T18:49:03.543+00:00](method-runs/389eb04a81bd471a82feb08241fa7d81.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T18:49:03.325+00:00](method-runs/00e7ba7a56c64004b0c2dc8a69123ace.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T18:49:02.765+00:00](method-runs/d35b420b631049d4bb4f7a1e29d74bee.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-27T18:38:42.001+00:00](method-runs/8cdffbe8b2d24f57b17b6c216032b552.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T18:38:40.474+00:00](method-runs/5bfb7e07e497475abdfafa06894a295a.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T18:38:39.485+00:00](method-runs/c4b89179bf484d2494a02d48b0953a5a.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T18:38:39.206+00:00](method-runs/ffc821384a904b1c8dce63f4f4b0a6fc.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T18:38:34.105+00:00](method-runs/55abe099069245e68a13c01702fb0ffc.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T18:38:32.105+00:00](method-runs/f844d306e4c84a56abe4e0790863cbb5.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T18:38:30.970+00:00](method-runs/f23cc7cdad98435b8c1224ab36676da6.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.1 | — |
| [2026-11-27T18:38:17.032+00:00](method-runs/dc3c6cfa23624f30b1c69b473a2df157.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T18:38:16.837+00:00](method-runs/716622f4d234474190c428add92e4584.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T18:38:16.769+00:00](method-runs/0b6f66576abf48099352da64c5d2215a.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T18:38:16.560+00:00](method-runs/1d6b0d15d0894599b11361717690ecd9.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T18:38:16.004+00:00](method-runs/3d1c8ef215764295be0aa8d82cde339d.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-27T18:26:42.341+00:00](method-runs/e2e7709af0064a8dbb52f93f7d82e50e.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 73.0 | — |
| [2026-11-27T18:26:42.063+00:00](method-runs/0d3742600c014ac0b47a0a588fd5c69d.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T18:26:37.164+00:00](method-runs/48c87eaaf31a4a9c9cd3d79c1cc31100.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 3.6 | — |
| [2026-11-27T18:26:33.325+00:00](method-runs/2479c86d88764bc19a2b9f4f195a8c09.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 3.9 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
