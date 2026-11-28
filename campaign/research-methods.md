# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 145 | 0 | 109.4 | — | — |
| e27-schmidt | 145 | 0 | 147.5 | — | — |
| gagatsos-2026-c1 | 545 | 0 | 1,472.4 | — | — |
| golay43 | 291 | 93 | 895.6 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| lts-mo-338936 | 1 | 0 | 98.8 | 263,468 / 3,920 | 1/1 |
| lts-oeis-a284230 | 2 | 1 | 111.1 | 185,342 / 2,527 | 1/2 |
| oqp:A13 | 1 | 0 | 57.6 | 198,280 / 1,837 | 1/1 |
| refined-bmv | 154 | 3 | 419.4 | 658,366 / 9,000 | 6/9 |
| support-enumeration | 18 | 0 | 739.2 | — | — |
| thomson-10 | 36 | 0 | 17.6 | — | — |
| thomson-11 | 36 | 0 | 10.8 | — | — |
| thomson-13 | 37 | 0 | 15.7 | — | — |
| thomson-14 | 36 | 0 | 17.1 | — | — |
| werner-endpoint | 291 | 0 | 328.3 | 67,096 / 624 | 1/1 |

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
| [2026-11-28T06:21:17.554+00:00](method-runs/37c92074ae154244af745b13b6d64354.json) | refined-bmv | solve | notebook-witness | gpt-6.2-astra / medium | completed / candidate_rejected | 63.9 | 168,396 / 2,048 |
| [2026-11-28T06:19:33.926+00:00](method-runs/78de19012da44d7aad0bde1ccff3c8ee.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-28T06:19:33.094+00:00](method-runs/fe429a30ee8442ae881061883ee988de.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T06:19:32.650+00:00](method-runs/693e0e3160154afaa756da10c3f6e916.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T06:19:32.504+00:00](method-runs/bb602982257442f796dedd6db0e1314b.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-28T06:19:29.477+00:00](method-runs/e2b585a2b8f54718905b11eb4484b443.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-28T06:19:28.291+00:00](method-runs/eefdccec337f4b70b2ed29a5284112f0.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-28T06:19:27.528+00:00](method-runs/c8ce83c261a547fdb6acc1dc0c1b32fd.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.8 | — |
| [2026-11-28T06:19:19.829+00:00](method-runs/54cdf2747b53456181845744b71e563a.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T06:19:19.701+00:00](method-runs/fdf3f1021cc84c57b3780c092b113c81.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T06:19:11.721+00:00](method-runs/d7fd128ce10b4956b2a7fe265bac6e83.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 8.0 | — |
| [2026-11-28T06:19:11.577+00:00](method-runs/0d0bbdecbb184fdaadcfe637abe96413.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T06:19:11.285+00:00](method-runs/a2f7084f57134e29a0e3afac98cce9c2.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-28T06:07:08.451+00:00](method-runs/db9e6d3067e1427eb0f1239527a85156.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-28T06:07:07.607+00:00](method-runs/ffd89bfe05f04a6f9fac2c70e5b07aa3.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T06:07:07.163+00:00](method-runs/ff41251fc16147cfa3b2c177975d6969.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T06:07:07.013+00:00](method-runs/05fa8eb755814755b77c3ad6281247d3.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-28T06:07:03.904+00:00](method-runs/5adfaa987f2f4a7f9a81354f4d63bf34.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-28T06:07:02.684+00:00](method-runs/d244f0fc32c64c0e920b6935a68256af.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-28T06:07:01.939+00:00](method-runs/b0c39ec1deea4b599ecfe8894ba1dd30.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-28T06:06:54.101+00:00](method-runs/4d3f6bea55ae45ffb7289d888e9dab16.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T06:06:53.970+00:00](method-runs/8ff982ad6dca483cbef1a22eb6299f1c.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T06:06:46.300+00:00](method-runs/15e667f91b4e4d8ea5fca5c717823716.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 7.7 | — |
| [2026-11-28T06:06:46.163+00:00](method-runs/9611c81faac748bdaa449029e990937c.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T06:06:45.862+00:00](method-runs/30f427641c5a4c14a8bd2d258f6b8aa2.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-28T05:54:37.465+00:00](method-runs/11dc35cb626c438d894a99a22e938ba2.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-28T05:54:34.950+00:00](method-runs/a2c18f73f4c84146bc3a22015fa3edb2.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.7 | — |
| [2026-11-28T05:54:33.171+00:00](method-runs/cc0ca49109a64d0eb060d9d632110bb5.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.8 | — |
| [2026-11-28T05:54:30.943+00:00](method-runs/6587e7646e544dfabb8494301c37b25d.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-28T05:54:29.670+00:00](method-runs/dec6317ed2154812aba4086f8cba914e.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-28T05:54:28.936+00:00](method-runs/3c75f6ed14a247b38370025e20a66380.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-28T05:54:21.067+00:00](method-runs/2579374f4cc0476397596eb29502b0f9.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T05:54:20.935+00:00](method-runs/edce20dff4de4062a72f2c93eb817823.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T05:54:13.327+00:00](method-runs/875c4b538c5d4eb7a1321fcbf7a6e6b7.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 7.6 | — |
| [2026-11-28T05:54:13.185+00:00](method-runs/d5d6f43b886649e9b6e3318f67bc959e.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T05:54:12.874+00:00](method-runs/3c386930ddda4cf4ba3339e8efb14acf.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-28T05:42:10.443+00:00](method-runs/ebe00e53dd994573bd5a0dd096ef9ec6.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-28T05:42:09.605+00:00](method-runs/cecc2dd59dcb496999b5d11532a8c9a7.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T05:42:09.140+00:00](method-runs/99040fc7ace943a6813acd451cca2a09.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-28T05:42:08.989+00:00](method-runs/035cad427361431ea45458396fa22e44.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
