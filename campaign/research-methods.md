# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 108 | 0 | 85.1 | — | — |
| e27-schmidt | 108 | 0 | 119.6 | — | — |
| gagatsos-2026-c1 | 406 | 0 | 1,239.4 | — | — |
| golay43 | 217 | 84 | 540.5 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| lts-oeis-a284230 | 1 | 1 | 19.7 | — | 0/1 |
| refined-bmv | 113 | 2 | 238.9 | 284,541 / 4,116 | 3/5 |
| support-enumeration | 14 | 0 | 610.5 | — | — |
| thomson-10 | 27 | 0 | 14.1 | — | — |
| thomson-11 | 27 | 0 | 8.9 | — | — |
| thomson-13 | 27 | 0 | 13.0 | — | — |
| thomson-14 | 27 | 0 | 13.8 | — | — |
| werner-endpoint | 217 | 0 | 258.1 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T23:11:47.201+00:00](method-runs/1b4fc5071dbd4c0eaf474bea4c88dc5b.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T23:11:46.338+00:00](method-runs/f9c3c00201a84a2f9924a666b9aa3133.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T23:11:45.927+00:00](method-runs/a5e5a4c5855e413aa51246a5e8fbd14e.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T23:11:45.774+00:00](method-runs/e9a38b38d7ad4969a60c6e912e4c19d8.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T23:11:43.223+00:00](method-runs/0568c8f7421045bbb0cd446a7b4dcd9f.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.0 | — |
| [2026-11-27T23:11:42.134+00:00](method-runs/70e347c887e043ccbe00e8366e2e6051.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T23:11:41.245+00:00](method-runs/8cf9cb7a923a460eaf9a6d74c0904695.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.8 | — |
| [2026-11-27T23:11:32.312+00:00](method-runs/2712fd5c61414da39203f8da739e6e8f.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T23:11:32.188+00:00](method-runs/f822930bfb8c4e708956e65e18dc2906.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T23:11:32.042+00:00](method-runs/627a4d94cad94448b555f073cb570dff.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T23:11:31.915+00:00](method-runs/a1957c3489ab45578440a517a31004ed.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T23:11:31.565+00:00](method-runs/cf1b57cb47a74f3c87318950953706e0.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T23:00:12.335+00:00](method-runs/2d5afe75b3854916866e5c9b2ed35d9e.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 51.1 | — |
| [2026-11-27T23:00:11.247+00:00](method-runs/47dbf330f2eb482a9b3f43432a972296.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 1.1 | — |
| [2026-11-27T23:00:07.545+00:00](method-runs/ccc5a3bfab324dc985ab9998f2e1e76b.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 2.3 | — |
| [2026-11-27T23:00:05.772+00:00](method-runs/c91ba40d04104dc2b4633fbf159e0e02.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.8 | — |
| [2026-11-27T23:00:02.974+00:00](method-runs/49378af8405e464e8c6e281562cbe8c9.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.8 | — |
| [2026-11-27T23:00:00.826+00:00](method-runs/599c703a573c4f9baeb7560fd594fb0d.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T22:59:59.865+00:00](method-runs/05db49d540e3421fb7a360b56f20f78b.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.0 | — |
| [2026-11-27T22:59:49.692+00:00](method-runs/98cf43f80cb64991953dd4b180951917.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T22:59:49.547+00:00](method-runs/91ab3236158f48d08d231ed5d007a4d9.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T22:59:49.423+00:00](method-runs/c3157b681b854faa804ddc7ac6a5b4e9.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T22:59:49.276+00:00](method-runs/9711a7a6de294922bddd034a27c0196c.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T22:59:48.884+00:00](method-runs/3c8221bc1fa04c998388afaa3b42fc85.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T22:49:23.079+00:00](method-runs/b0a52e0533f5448eb32030cfba8433cc.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T22:49:22.056+00:00](method-runs/5a6982aa419943908fd760d999501658.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T22:49:21.566+00:00](method-runs/5b0dfb04e59b43eaa4a120daeed92565.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T22:49:21.413+00:00](method-runs/dfeeac3e13aa4c0eb6be6937b173921e.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T22:49:18.069+00:00](method-runs/aecf64eff17d486db6636bb50de2ab93.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T22:49:15.900+00:00](method-runs/8ea9b9bd6d55442a84cccf9fe5430ebd.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T22:49:14.520+00:00](method-runs/790e1f34b9dc4d6cb8eede7acd491b9f.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T22:49:02.684+00:00](method-runs/552a1f51c0114b88b7e228a78307dacc.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.5 | — |
| [2026-11-27T22:49:02.502+00:00](method-runs/7b6288ba217e4d52bdf436b282896eb1.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T22:49:02.320+00:00](method-runs/21d2d407b1d54a69b79601f731d412e0.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T22:49:01.930+00:00](method-runs/04122c17a0fb4e1388fd26623b7365ee.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T22:49:01.492+00:00](method-runs/a9511fe8fcca4faaaa187765ca80ed70.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.5 | — |
| [2026-11-27T22:38:19.790+00:00](method-runs/72298eae8ac24be19711faaf9bb944cb.json) | refined-bmv | solve | notebook-witness | gpt-6.2-astra / medium | failed / RuntimeError | 19.8 | — |
| [2026-11-27T22:38:16.683+00:00](method-runs/a1e53a3ce97848949db0159e10c20be0.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T22:38:15.846+00:00](method-runs/aeb49d4824ba4c53bd873e7fbb797f7a.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T22:38:15.401+00:00](method-runs/b7a2a3f36efb4f44ab814fc5528b0220.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
