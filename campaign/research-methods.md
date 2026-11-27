# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 104 | 0 | 83.7 | — | — |
| e27-schmidt | 104 | 0 | 117.9 | — | — |
| gagatsos-2026-c1 | 391 | 0 | 1,223.0 | — | — |
| golay43 | 209 | 80 | 539.2 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| lts-oeis-a284230 | 1 | 1 | 19.7 | — | 0/1 |
| refined-bmv | 108 | 1 | 218.5 | 284,541 / 4,116 | 3/4 |
| support-enumeration | 13 | 0 | 559.3 | — | — |
| thomson-10 | 26 | 0 | 13.9 | — | — |
| thomson-11 | 26 | 0 | 8.8 | — | — |
| thomson-13 | 26 | 0 | 12.8 | — | — |
| thomson-14 | 26 | 0 | 12.7 | — | — |
| werner-endpoint | 209 | 0 | 251.3 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T22:27:41.370+00:00](method-runs/24cbb8c35bce4edbac419f8f85a3db1b.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-27T22:27:39.776+00:00](method-runs/c78a441fe1b94d9bbd927a4b8495f67c.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T22:27:38.767+00:00](method-runs/657d3d2f60014461abb64c0f5bb3a3dd.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T22:27:38.492+00:00](method-runs/225de2a7dc2841afb27aee425bcffcbf.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T22:27:33.489+00:00](method-runs/88a04b7124e84723b5060e6ba289405d.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T22:27:31.445+00:00](method-runs/b658da64aea54d13a4922bfe5ce8deff.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T22:27:30.075+00:00](method-runs/1e19cb32c5014afda755eccabd86934f.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T22:27:15.064+00:00](method-runs/27f0924cb9fa42419503b7b802ad0149.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T22:27:14.871+00:00](method-runs/904e18a4c2ff4cc598f3450a336db87a.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T22:27:14.717+00:00](method-runs/d1c1210651f0438481daf6a6e32ce708.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T22:27:14.493+00:00](method-runs/d3f4cb8dd8fb4f73bdb336c71ca35248.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T22:27:13.882+00:00](method-runs/d989abf345bb4ad98228abf4a76f527e.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.7 | — |
| [2026-11-27T22:16:51.201+00:00](method-runs/89fbd10ca205468cb05d32d158baa61f.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T22:16:46.183+00:00](method-runs/7d7a3ceec5454109932b01c923c45f0e.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 3.6 | — |
| [2026-11-27T22:16:42.549+00:00](method-runs/ba93aa4b43194890afe5ccdfc42012cc.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 3.7 | — |
| [2026-11-27T22:16:39.175+00:00](method-runs/50afc87fe46b4f058cdf64a8e0f515f1.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T22:16:37.053+00:00](method-runs/3fa9ce80511e445982be53cfc6e94096.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T22:16:35.692+00:00](method-runs/4ab58752c82d41f28e0267ddaa58db16.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.3 | — |
| [2026-11-27T22:16:20.842+00:00](method-runs/e51741cd16c840d0906a171f5c708ae1.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T22:16:20.650+00:00](method-runs/1f7fdb5319d4498c82f782a48e683c56.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T22:16:20.492+00:00](method-runs/c89c627b4f5947068e15062f0947ad2e.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T22:16:20.272+00:00](method-runs/7e9be1e2afbc48099f2059eef2210908.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T22:16:19.638+00:00](method-runs/c14e44cea21a4a9ca2f89f0d6309c503.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.7 | — |
| [2026-11-27T22:05:57.176+00:00](method-runs/ae78c37fafe347f985384640750ac222.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T22:05:55.596+00:00](method-runs/9761ac9650c04f5493f12ca9d1300c4f.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T22:05:54.617+00:00](method-runs/693a7b67ec55484387a38002ff4ce111.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T22:05:54.341+00:00](method-runs/7b3295cae0204aa091cc485019355480.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T22:05:49.325+00:00](method-runs/9bfda8de72a34a0abb33a94a6f39b703.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T22:05:47.348+00:00](method-runs/c6e5680f2a364d769c1592b31bdd61fe.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T22:05:46.076+00:00](method-runs/5a9be738685d4c68a177ba0a41144eb0.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.3 | — |
| [2026-11-27T22:05:31.079+00:00](method-runs/a36f7c1ff4f348059bcc421f6765a030.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.5 | — |
| [2026-11-27T22:05:30.883+00:00](method-runs/c4d9743e0ab34fd1a1d2774c5ca60f2c.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T22:05:30.726+00:00](method-runs/f1bb7fe120c54e4290ba597139751eb8.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T22:05:30.514+00:00](method-runs/e48ca95dca5c4d1c8748686917d49472.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T22:05:29.885+00:00](method-runs/1a65c21913ab49b0895a67b5c3e77b4a.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.7 | — |
| [2026-11-27T21:55:06.650+00:00](method-runs/e5ad01b2db3540948d7b0002303b5e52.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T21:55:04.961+00:00](method-runs/f1f7fc844cac45f79759e0c2cc068be2.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T21:55:03.972+00:00](method-runs/b71741ad2d1f4015b9b970c6adcb83d3.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T21:55:03.682+00:00](method-runs/e4f9fef2f1644feca36354cc6ba02f87.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T21:54:58.010+00:00](method-runs/bd4b205cfe41420c9e1a7a0e4f68e38a.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
