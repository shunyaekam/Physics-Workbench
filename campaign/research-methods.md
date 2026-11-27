# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 90 | 0 | 77.6 | — | — |
| e27-schmidt | 90 | 0 | 108.7 | — | — |
| gagatsos-2026-c1 | 339 | 0 | 1,141.2 | — | — |
| golay43 | 181 | 66 | 534.3 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 3 | 3 | 496.3 | — | 0/2 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 94 | 1 | 215.8 | 284,541 / 4,116 | 3/4 |
| support-enumeration | 11 | 0 | 405.1 | — | — |
| thomson-10 | 23 | 0 | 12.5 | — | — |
| thomson-11 | 22 | 0 | 6.8 | — | — |
| thomson-13 | 23 | 0 | 11.4 | — | — |
| thomson-14 | 22 | 0 | 10.8 | — | — |
| werner-endpoint | 181 | 0 | 202.3 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T19:52:22.923+00:00](method-runs/e00183ee3260410ebb14420dc34a0bc6.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-27T19:52:16.939+00:00](method-runs/e377223b8acb4e0398c2c34e5213af95.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T19:52:16.365+00:00](method-runs/83a7a10c649a478aae8ae80937a20e97.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T19:52:16.188+00:00](method-runs/11228a6e6c244e549530b131de5713c6.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T19:52:11.980+00:00](method-runs/c42f5bfced744ace84c73233422c7729.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T19:52:10.764+00:00](method-runs/37b44f9b0b114c6f88adca570c4d7d5d.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-27T19:52:09.969+00:00](method-runs/f52075e51c9745a8a790df39f5dcb040.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.8 | — |
| [2026-11-27T19:51:52.209+00:00](method-runs/4948bdedc7be43f9b4cdf806e6ddb944.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T19:51:52.111+00:00](method-runs/d87fe44b9d9c4e249dbcec6afb73943e.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T19:51:51.956+00:00](method-runs/dd60cf4263a143139ffe0572c7af04ea.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T19:51:51.829+00:00](method-runs/85e3cabe954d4b1a933362233ceaf5a4.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T19:51:51.518+00:00](method-runs/0dfd9facd0cc47738cde22c71511e311.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T19:41:32.576+00:00](method-runs/4e658c6195c34a2cb9f11d2f3d3ccd71.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T19:41:31.227+00:00](method-runs/ab4f2c9034344480962e4b65a3b3c81e.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T19:41:30.647+00:00](method-runs/c2c2bb77253c4944bdcc19b3f4b1dc1f.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T19:41:30.447+00:00](method-runs/ca07ea686a3a413c865901dd18cd00cd.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T19:41:27.418+00:00](method-runs/8fe2b991e8c845f8b56a4ab6e2afa50f.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T19:41:26.360+00:00](method-runs/a03cca2b8c1d4b47a07f4fe5d5657bde.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T19:41:25.608+00:00](method-runs/4efdc609439b4ed1bfaeb3fdb1695076.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-27T19:41:14.664+00:00](method-runs/d565896f0a914c229402f7b3f37fcc35.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T19:41:14.564+00:00](method-runs/cd61ee39348d4a018b78676356baa3b4.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T19:41:14.450+00:00](method-runs/597f562dff4549ac9907026b3d78e107.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T19:41:14.335+00:00](method-runs/83e38d64ffda46798c7372fce82a70fd.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T19:41:14.023+00:00](method-runs/b6a5b5e9f9c54d738ff0139acad6789e.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T19:30:47.288+00:00](method-runs/631b413f5a404da29736783834829e03.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T19:30:46.396+00:00](method-runs/3b46b58a37a0428f89c83db98e907e0e.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T19:30:45.954+00:00](method-runs/486c2c6c4c4643ce87b35ac28e6b417d.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T19:30:45.802+00:00](method-runs/d7f8c4b1d13449a091c3b5736d015bea.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T19:30:41.748+00:00](method-runs/726cb2ac1cd544418f471a5f36460651.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.9 | — |
| [2026-11-27T19:30:40.331+00:00](method-runs/fe3e92e425464bf9a8bb9f94e2a1fd72.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.4 | — |
| [2026-11-27T19:30:38.364+00:00](method-runs/894773108b9a4d109def2fab7ea4ae75.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 2.0 | — |
| [2026-11-27T19:30:28.226+00:00](method-runs/9f3a4f3cd6cb46e78ee356831fe6698d.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T19:30:28.073+00:00](method-runs/afebd3ff95e9472db7f57a61472e2322.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T19:30:27.875+00:00](method-runs/c16f6d2c1ea24b16b276e055097965d6.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T19:30:27.499+00:00](method-runs/125b21d609cb4b2d81006375b683e008.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T19:30:26.014+00:00](method-runs/7e1d03eebebb4833a645d236846aea21.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T19:16:03.359+00:00](method-runs/837f704a99304903b1feadfb642075d6.json) | lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | scout | source-screen-and-notebook | gpt-6.2-sol / low | timeout / TimeoutError | 240.3 | — |
| [2026-11-27T19:15:02.517+00:00](method-runs/16c25e4c62084dcda83d89acc3efa9d2.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T19:14:58.524+00:00](method-runs/12f2813e238e4691aeea0cc4d23113d5.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 2.0 | — |
| [2026-11-27T19:14:56.917+00:00](method-runs/69df2b549c634550b55254afd4f604a4.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.6 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
