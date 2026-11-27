# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 35 | 0 | 24.0 | — | — |
| e27-schmidt | 35 | 0 | 39.5 | — | — |
| gagatsos-2026-c1 | 132 | 0 | 241.8 | — | — |
| golay43 | 71 | 11 | 437.8 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| refined-bmv | 36 | 0 | 51.3 | 69,669 / 997 | 1/1 |
| support-enumeration | 5 | 0 | 167.6 | — | — |
| thomson-10 | 9 | 0 | 4.3 | — | — |
| thomson-11 | 8 | 0 | 2.2 | — | — |
| thomson-13 | 9 | 0 | 4.0 | — | — |
| thomson-14 | 9 | 0 | 4.5 | — | — |
| werner-endpoint | 71 | 0 | 96.1 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T08:34:17.278+00:00](method-runs/77dc5f83ebd64dba96740566e77e0fbe.json) | werner-endpoint | math_review | independent-challenge | gpt-6.2-sol / low | completed / park | 26.4 | 67,096 / 624 |
| [2026-11-27T08:33:05.310+00:00](method-runs/717a61820ca6458984568602522b8792.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 43.6 | — |
| [2026-11-27T08:33:05.019+00:00](method-runs/26f79797946c409489d6d803bacd47f5.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T08:33:02.468+00:00](method-runs/4d44f7fe95e641c0aa789f8afb31fbf5.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.8 | — |
| [2026-11-27T08:33:00.697+00:00](method-runs/94d322dbdc744651879be79ad30467ff.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.8 | — |
| [2026-11-27T08:32:57.907+00:00](method-runs/eaaf506e848b45c696c06b1c8edba954.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.7 | — |
| [2026-11-27T08:32:56.218+00:00](method-runs/6845334b0b284b5495e7ccd10db47c20.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.7 | — |
| [2026-11-27T08:32:54.583+00:00](method-runs/2ff961dd13494ea2a041b9ff55e35fd8.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.6 | — |
| [2026-11-27T08:32:43.573+00:00](method-runs/a01eba3630ca49bebbcb224dca963373.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.5 | — |
| [2026-11-27T08:32:43.424+00:00](method-runs/0728cb720c474c0e91ae76af8890ca68.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T08:32:43.292+00:00](method-runs/fb292f0a0dbd480f86446dfd964ffeb7.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T08:32:43.132+00:00](method-runs/1bc78aecacf147b8bde90fd3172500ba.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T08:32:42.766+00:00](method-runs/a77f5246a1b34a26b0bb204c1d9a066b.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T08:20:57.249+00:00](method-runs/decb467f1aa14769a342e822e40128a3.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 2.0 | — |
| [2026-11-27T08:20:43.278+00:00](method-runs/b80c6e8560634aa4a6cdc9569dba2d18.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.8 | — |
| [2026-11-27T08:20:42.461+00:00](method-runs/1d125f8a7ca74a7285d90cc64337424c.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.8 | — |
| [2026-11-27T08:20:42.225+00:00](method-runs/4c7b2f5f533d451c9af84b24f0c7c59d.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T08:20:37.088+00:00](method-runs/2378986ea2834c14b66858496a8a52b3.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.6 | — |
| [2026-11-27T08:20:35.582+00:00](method-runs/ef1ef28461b44a2eb871bbf76b8e1711.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T08:20:34.493+00:00](method-runs/f374a642f8ca4ec18ac4e0da6dcbb52e.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.1 | — |
| [2026-11-27T08:20:20.958+00:00](method-runs/d5585b06a08546ef8e4ca4f61b6f7e28.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T08:20:20.793+00:00](method-runs/9d674b1bdb084a4e8c4ccb46b4f0ec17.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T08:20:20.665+00:00](method-runs/8474644670d242eba6774428291cfbb7.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T08:20:20.544+00:00](method-runs/f6f9028c1c2d4384a398212435648af1.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T08:20:20.243+00:00](method-runs/30cb67d2c81647d78b123f9714ed8630.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T08:09:52.955+00:00](method-runs/d967f12d7195498a9ebd1c3b629841e8.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T08:09:52.158+00:00](method-runs/6e9c9509538842c29d0e09976e6fda76.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T08:09:51.745+00:00](method-runs/409acf6b22bb4f71848fe484065e5713.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T08:09:51.615+00:00](method-runs/52b1a62769b24756a9197c6c4d00fb14.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T08:09:49.076+00:00](method-runs/3f9e4d4b4eb04a87a40e399237f4c91c.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T08:09:47.461+00:00](method-runs/d9e92e353e784004be5e45100bb60c44.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.6 | — |
| [2026-11-27T08:09:45.966+00:00](method-runs/402aa0c6c5fa49dcbc29f5826aa9096f.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.5 | — |
| [2026-11-27T08:09:36.468+00:00](method-runs/7a6707aa89974928a10a0174c9ad58ef.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T08:09:36.374+00:00](method-runs/d16e8097883c46d8876e2941f2f646fb.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T08:09:36.270+00:00](method-runs/0e679221466547a29efd7ca0ebae1177.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T08:09:36.161+00:00](method-runs/7c4049d98a454507ad6ca96e6d4dd969.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T08:09:35.873+00:00](method-runs/9d16ce6378ce4194b0408e32ce93edc1.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T07:59:16.188+00:00](method-runs/531e4629b60a493689b6d955cb00dd9d.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T07:59:15.408+00:00](method-runs/3b424a1f1ebc4a4fa8a3443cdc7e58dc.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T07:59:14.986+00:00](method-runs/21f35dc6d60d4d29b227f9bc9940af3c.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
