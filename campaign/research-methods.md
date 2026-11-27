# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 105 | 0 | 84.0 | — | — |
| e27-schmidt | 105 | 0 | 118.3 | — | — |
| gagatsos-2026-c1 | 395 | 0 | 1,226.2 | — | — |
| golay43 | 211 | 81 | 539.5 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| lts-oeis-a284230 | 1 | 1 | 19.7 | — | 0/1 |
| refined-bmv | 110 | 2 | 238.5 | 284,541 / 4,116 | 3/5 |
| support-enumeration | 13 | 0 | 559.3 | — | — |
| thomson-10 | 26 | 0 | 13.9 | — | — |
| thomson-11 | 26 | 0 | 8.8 | — | — |
| thomson-13 | 27 | 0 | 13.0 | — | — |
| thomson-14 | 26 | 0 | 12.7 | — | — |
| werner-endpoint | 211 | 0 | 252.2 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T22:38:19.790+00:00](method-runs/72298eae8ac24be19711faaf9bb944cb.json) | refined-bmv | solve | notebook-witness | gpt-6.2-astra / medium | failed / RuntimeError | 19.8 | — |
| [2026-11-27T22:38:16.683+00:00](method-runs/a1e53a3ce97848949db0159e10c20be0.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T22:38:15.846+00:00](method-runs/aeb49d4824ba4c53bd873e7fbb797f7a.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T22:38:15.401+00:00](method-runs/b7a2a3f36efb4f44ab814fc5528b0220.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T22:38:15.224+00:00](method-runs/8ae8a2a0955a45f39665ca0e8a457a95.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T22:38:12.154+00:00](method-runs/f8916c1674ef414db1ca9a4c23993f10.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T22:38:11.101+00:00](method-runs/b1db4e8117b44f928c6cf2259a145a06.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.0 | — |
| [2026-11-27T22:38:10.385+00:00](method-runs/7131b09039de4f98b9eb688a4742879f.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-27T22:38:00.842+00:00](method-runs/2cddac34ad3448c59f70e369e13a5285.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T22:38:00.735+00:00](method-runs/7c31df990dbf4044ab8cefc45175e1f2.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T22:38:00.606+00:00](method-runs/a036cf85e3d04f618441476ebb599855.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T22:38:00.482+00:00](method-runs/4ac71c42969b4615aea8b50b16bc7927.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T22:38:00.153+00:00](method-runs/0d12470ceaf64cf182980537deaaab85.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
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

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
