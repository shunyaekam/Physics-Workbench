# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 115 | 0 | 92.5 | — | — |
| e27-schmidt | 115 | 0 | 128.3 | — | — |
| gagatsos-2026-c1 | 432 | 0 | 1,311.3 | — | — |
| golay43 | 231 | 91 | 550.7 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| lts-oeis-a284230 | 1 | 1 | 19.7 | — | 0/1 |
| refined-bmv | 121 | 2 | 304.9 | 446,095 / 6,119 | 4/6 |
| support-enumeration | 15 | 0 | 634.2 | — | — |
| thomson-10 | 29 | 0 | 16.0 | — | — |
| thomson-11 | 28 | 0 | 9.1 | — | — |
| thomson-13 | 29 | 0 | 13.6 | — | — |
| thomson-14 | 29 | 0 | 14.5 | — | — |
| werner-endpoint | 231 | 0 | 270.0 | 67,096 / 624 | 1/1 |

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
| [2026-11-28T00:32:46.965+00:00](method-runs/0a411b75bca249a8aca9b62f833dc551.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 23.8 | — |
| [2026-11-28T00:32:46.471+00:00](method-runs/ec3983efa77d4e25a6d94ec41b361a02.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-28T00:32:38.333+00:00](method-runs/21a5eb07b67344d59fcf323dd89ba628.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.7 | — |
| [2026-11-28T00:32:36.564+00:00](method-runs/5c6e8536b367401485db04df2472fae7.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.8 | — |
| [2026-11-28T00:32:34.477+00:00](method-runs/b93ce4c7fd4d43bf8c7def8990bf7fdc.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-28T00:32:32.716+00:00](method-runs/88ebab05aa6e4e9cae7fedabf83eeb8a.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.8 | — |
| [2026-11-28T00:32:19.964+00:00](method-runs/b4e4a6f5adae431292fa1bbfc7447ad8.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 12.7 | — |
| [2026-11-28T00:32:09.055+00:00](method-runs/ed5353b41bf24a57b5b35533b3d93460.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T00:32:08.895+00:00](method-runs/d9b7235c437c4857a2bf7718ab5946b1.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T00:32:08.692+00:00](method-runs/ea5b5ba40f7b4d7d8de32feac54d177d.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-28T00:32:08.425+00:00](method-runs/01beafed50964c5f8f1fdadb639f9198.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T00:32:07.946+00:00](method-runs/34e038dc515b4c4c95a52f78bc0e3d5f.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.5 | — |
| [2026-11-28T00:21:37.617+00:00](method-runs/8e816fe268014c9485849e02af82e2f8.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 1.5 | — |
| [2026-11-28T00:21:29.649+00:00](method-runs/ea5b59697f3246fb8f84547e8d47b652.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T00:21:28.937+00:00](method-runs/30085c9ed7164ad387d3ac6ebf394c3b.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.7 | — |
| [2026-11-28T00:21:28.798+00:00](method-runs/d8d1011b07a64fe787c31eca6448ee1c.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-28T00:21:24.917+00:00](method-runs/5e226f241e344e7087ad46236217716f.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.6 | — |
| [2026-11-28T00:21:23.350+00:00](method-runs/e272484787664648b0990ccdfe7a2e10.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.6 | — |
| [2026-11-28T00:21:16.587+00:00](method-runs/83177bb85bc74030851508716758084c.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 6.8 | — |
| [2026-11-28T00:21:05.427+00:00](method-runs/ead6b3af9c60474bbad37641a377515f.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T00:21:05.309+00:00](method-runs/ed2f4802436f447eb6ba919a8b2816e6.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T00:21:05.036+00:00](method-runs/0e5031dd2ba74a8d913bd0840d9f1e6d.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.3 | — |
| [2026-11-28T00:21:04.918+00:00](method-runs/d2179f65d2ad4ff8b438d212345ed004.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T00:21:04.248+00:00](method-runs/5b7bbfbcd7484971abc25db991f5f7cf.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.7 | — |
| [2026-11-28T00:10:30.371+00:00](method-runs/2e22f2d400d047fc800151ba629ede0f.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-28T00:10:29.470+00:00](method-runs/5437ff31105544bea5cbb5067b481a54.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-28T00:10:29.059+00:00](method-runs/b58494a4f3484c2ea62438f0773ef2ad.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T00:10:28.944+00:00](method-runs/d1583ac7f8004fd69f11a8a88ccd44f5.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.1 | — |
| [2026-11-28T00:10:26.209+00:00](method-runs/c0ddecbf6fb74af9a00b925b5b3ee8ff.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-28T00:10:25.057+00:00](method-runs/a066e84406d84c5987e09342e81ed443.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-28T00:10:24.231+00:00](method-runs/b89567039b1c45e8ac0d92a62319ca49.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.8 | — |
| [2026-11-28T00:10:15.450+00:00](method-runs/cbe4aefbcfa04bd183f1c04d3dedfe07.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T00:10:15.348+00:00](method-runs/a4e35fe032cf4256824554dde8ab9de9.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T00:10:15.200+00:00](method-runs/f19aa80a00674c71994ec66e7bd3d0c5.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-28T00:10:15.036+00:00](method-runs/6dd69820baff4f17a3fce809e601eb9f.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T00:10:14.625+00:00](method-runs/ec74974475eb4c2081302e1d6559ad4b.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T23:59:26.215+00:00](method-runs/3a474c3ca509443cbf41deeadac7324a.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T23:59:25.367+00:00](method-runs/bde903f708c440d9937a38eca3202a48.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T23:59:24.963+00:00](method-runs/4ae6e1d0d1b34e31a080342bfd880c36.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T23:59:24.833+00:00](method-runs/5bc51cbd52ba4e988a446a957b9ed662.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
