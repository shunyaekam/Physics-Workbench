# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 3 | 0 | 0.8 | — | — |
| e27-schmidt | 3 | 0 | 1.0 | — | — |
| gagatsos-2026-c1 | 12 | 0 | 34.9 | — | — |
| golay43 | 7 | 0 | 33.1 | — | — |
| refined-bmv | 3 | 0 | 0.4 | — | — |
| support-enumeration | 1 | 0 | 31.0 | — | — |
| thomson-10 | 1 | 0 | 0.4 | — | — |
| thomson-13 | 1 | 0 | 0.4 | — | — |
| thomson-14 | 1 | 0 | 0.4 | — | — |
| werner-endpoint | 6 | 0 | 6.4 | — | — |

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
| [2026-11-27T02:16:24.991+00:00](method-runs/0d8697cbff034263a8ef4baa8316cc8b.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 31.0 | — |
| [2026-11-27T02:16:24.611+00:00](method-runs/fe21f512e5994453bfd5288d5ba5a784.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-27T02:16:21.330+00:00](method-runs/80038a34ffbf4de6a35ad2b31a21895e.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.8 | — |
| [2026-11-27T02:16:19.733+00:00](method-runs/2245acc184bf4512bb57c5aa6c1acedd.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.6 | — |
| [2026-11-27T02:16:17.915+00:00](method-runs/23827cc388d2400893c8f3a179706194.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T02:16:16.444+00:00](method-runs/72e2fc6eae5d43ca9682a111f1650a7d.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T02:16:15.134+00:00](method-runs/b86c77dd53c245528250657e3ce52d50.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.3 | — |
| [2026-11-27T02:16:04.784+00:00](method-runs/156af024ebf44063a5623f57a03653cf.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T02:16:04.652+00:00](method-runs/f01dce9c5a08468686170671c92c1c66.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T02:15:53.393+00:00](method-runs/844ab6b7a65544a89d30ab520617706c.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 11.3 | — |
| [2026-11-27T02:15:53.282+00:00](method-runs/a4bb7485dfde4e61a4c02d3c6f2ed437.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T02:15:52.996+00:00](method-runs/2ebabc3c6a3e46d68f4d07b1dca7df28.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T02:05:24.638+00:00](method-runs/bbb2c41c93324ab0842fee437b559f5d.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-27T02:05:23.512+00:00](method-runs/b08dcdae13604ffaac9b0412b9613b71.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T02:05:22.881+00:00](method-runs/777b80b969f44bffa1c80b71c566c0bc.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T02:05:22.521+00:00](method-runs/ff04d5d05f654d568213b7ddcae7c1a0.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T02:05:16.946+00:00](method-runs/cd7308584f8245099fe3ecc0a50c95b1.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.3 | — |
| [2026-11-27T02:05:15.158+00:00](method-runs/9fc6620e14a64748b7781e3caa448470.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.8 | — |
| [2026-11-27T02:05:14.276+00:00](method-runs/21a68226653040488cfca54b44c247ee.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.9 | — |
| [2026-11-27T02:05:02.825+00:00](method-runs/b5ed0bb780954b059db855910acdc37a.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T02:05:02.686+00:00](method-runs/a2be40515f904b0ab69c298865c58cbb.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T02:04:55.561+00:00](method-runs/0d0eca665b2e4d6789fe3006b56fbd2a.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 7.1 | — |
| [2026-11-27T02:04:55.452+00:00](method-runs/ce7a664961cc4db8b6ec439f20fb8782.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T02:04:55.183+00:00](method-runs/5e6b83083cf64df99b589932d2272172.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T01:54:31.023+00:00](method-runs/a3109592c48a4aa99bc87aa7b088c2b5.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-27T01:54:29.309+00:00](method-runs/da3fa4c05cad4674abec636e67dfa481.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.1 | — |
| [2026-11-27T01:54:28.646+00:00](method-runs/e4fc1327ef2342769b20908734004781.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.7 | — |
| [2026-11-27T01:54:28.514+00:00](method-runs/b92448329f5a4b56b466971c3a14d2fc.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T01:54:25.013+00:00](method-runs/9357f715f94b41c5ae9e945f5d08bbfb.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T01:54:23.927+00:00](method-runs/004ddfeca61e41ad859be388e5ac814d.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T01:54:23.190+00:00](method-runs/e10ff4cc7e65499d9ff0a41e34125d68.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-27T01:54:10.778+00:00](method-runs/5ce3327471674fcfac5fe639411b14a6.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T01:54:10.664+00:00](method-runs/66ad585780a345688973ba804ce2f434.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T01:53:56.239+00:00](method-runs/e5cca0172dfd4f47af22d165a90c1e43.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 14.4 | — |
| [2026-11-27T01:53:56.135+00:00](method-runs/837459c4235a4ac184567babb910798d.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T01:53:55.812+00:00](method-runs/6b6ce57a43be44e18a48839907b521f3.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T01:51:52.054+00:00](method-runs/1f59456aa0194d238b113631d5782612.json) | gagatsos-2026-c1 | replay | checks/sharp_qubit.py | — | completed / single_rail_order_cover_replayed | 22.6 | — |
| [2026-11-27T01:51:52.052+00:00](method-runs/e0579a7492f74eda8d7bd1368d55c945.json) | golay43 | replay | checks/golay_certificate.py | — | completed / signed_47_cnot_witness | 0.0 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
