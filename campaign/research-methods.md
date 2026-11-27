# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 87 | 0 | 76.8 | — | — |
| e27-schmidt | 87 | 0 | 106.5 | — | — |
| gagatsos-2026-c1 | 327 | 0 | 1,128.1 | — | — |
| golay43 | 175 | 63 | 533.3 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 3 | 3 | 496.3 | — | 0/2 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 91 | 1 | 215.5 | 284,541 / 4,116 | 3/4 |
| support-enumeration | 11 | 0 | 405.1 | — | — |
| thomson-10 | 22 | 0 | 12.1 | — | — |
| thomson-11 | 21 | 0 | 6.7 | — | — |
| thomson-13 | 22 | 0 | 11.1 | — | — |
| thomson-14 | 22 | 0 | 10.8 | — | — |
| werner-endpoint | 175 | 0 | 199.6 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T19:16:03.359+00:00](method-runs/837f704a99304903b1feadfb642075d6.json) | lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | scout | source-screen-and-notebook | gpt-6.2-sol / low | timeout / TimeoutError | 240.3 | — |
| [2026-11-27T19:15:02.517+00:00](method-runs/16c25e4c62084dcda83d89acc3efa9d2.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T19:14:58.524+00:00](method-runs/12f2813e238e4691aeea0cc4d23113d5.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 2.0 | — |
| [2026-11-27T19:14:56.917+00:00](method-runs/69df2b549c634550b55254afd4f604a4.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.6 | — |
| [2026-11-27T19:14:54.990+00:00](method-runs/9405d5a0ef7842f0bb14153189467bc1.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-27T19:14:53.608+00:00](method-runs/2c73309da9174dfea36cba97ca0252be.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.4 | — |
| [2026-11-27T19:14:52.217+00:00](method-runs/16b08251c3124bcc978ac84ab15355e7.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T19:14:42.490+00:00](method-runs/99ca924dd4e94826a113f969fe402535.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T19:14:42.385+00:00](method-runs/6a300ae61ed34d5280f905391dc48450.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T19:14:42.274+00:00](method-runs/1154c57d856748bfa9a1744e00868885.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T19:14:42.156+00:00](method-runs/e8560755da394e82b97f97d565a99d18.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T19:14:41.845+00:00](method-runs/9405af1b40e84de7904f4895c7ae65db.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
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

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
