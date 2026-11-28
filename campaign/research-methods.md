# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 114 | 0 | 92.2 | — | — |
| e27-schmidt | 114 | 0 | 127.8 | — | — |
| gagatsos-2026-c1 | 429 | 0 | 1,295.6 | — | — |
| golay43 | 229 | 90 | 550.2 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| lts-oeis-a284230 | 1 | 1 | 19.7 | — | 0/1 |
| refined-bmv | 120 | 2 | 304.7 | 446,095 / 6,119 | 4/6 |
| support-enumeration | 14 | 0 | 610.5 | — | — |
| thomson-10 | 29 | 0 | 16.0 | — | — |
| thomson-11 | 28 | 0 | 9.1 | — | — |
| thomson-13 | 29 | 0 | 13.6 | — | — |
| thomson-14 | 28 | 0 | 14.0 | — | — |
| werner-endpoint | 229 | 0 | 266.5 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T23:59:22.359+00:00](method-runs/d0b3dd5991be41bcb83cd3c67447425a.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T23:59:21.331+00:00](method-runs/de00103d6cd04c43930f88aa64bb5454.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.0 | — |
| [2026-11-27T23:59:15.964+00:00](method-runs/cdae4088153344c98f02bd635612f80d.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 5.4 | — |
| [2026-11-27T23:58:24.428+00:00](method-runs/2848ba4c866b439084de4916e4071e99.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 2.2 | — |
| [2026-11-27T23:58:22.305+00:00](method-runs/6e66f048df9140a4b601125946286b90.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 2.1 | — |
| [2026-11-27T23:58:19.491+00:00](method-runs/bccd060f03524504bae896590492d43e.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 2.8 | — |
| [2026-11-27T23:58:19.143+00:00](method-runs/648124d47618497db0ca27c89cbeb295.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T23:58:17.357+00:00](method-runs/56865ad4f0564adfa40d5f60cbd5fe91.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T23:46:13.042+00:00](method-runs/46fa0dd8b5214f749d151ba127be9dd8.json) | refined-bmv | solve | notebook-witness | gpt-6.2-astra / medium | completed / bounded_result | 63.1 | 161,554 / 2,003 |
| [2026-11-27T23:46:10.063+00:00](method-runs/b68746fcb09242ab98c41e6f7c949d15.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T23:46:07.387+00:00](method-runs/246b6d5ab2ef4640bcb1ec0bb7546f12.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.6 | — |
| [2026-11-27T23:46:05.473+00:00](method-runs/c6e0338b282747958ba94c4b503dd232.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 2.0 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
