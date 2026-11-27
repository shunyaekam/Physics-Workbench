# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 110 | 0 | 87.1 | — | — |
| e27-schmidt | 110 | 0 | 122.3 | — | — |
| gagatsos-2026-c1 | 414 | 0 | 1,269.1 | — | — |
| golay43 | 221 | 86 | 543.7 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| lts-oeis-a284230 | 1 | 1 | 19.7 | — | 0/1 |
| refined-bmv | 115 | 2 | 239.2 | 284,541 / 4,116 | 3/5 |
| support-enumeration | 14 | 0 | 610.5 | — | — |
| thomson-10 | 28 | 0 | 14.5 | — | — |
| thomson-11 | 27 | 0 | 8.9 | — | — |
| thomson-13 | 28 | 0 | 13.5 | — | — |
| thomson-14 | 27 | 0 | 13.8 | — | — |
| werner-endpoint | 221 | 0 | 260.0 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T23:34:12.498+00:00](method-runs/0f49ee7410dc455c91fe3a70bca1a25a.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-27T23:34:08.348+00:00](method-runs/f013b1ebf7934fb7943081a7347128f1.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T23:34:07.893+00:00](method-runs/095e51c4af5e441b87ca016c760cb971.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T23:34:07.746+00:00](method-runs/38a1f0ecd25c41ee936c486006101d3d.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.7 | — |
| [2026-11-27T23:33:59.360+00:00](method-runs/38749b5f92ea48259774abab268dcc08.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 5.9 | — |
| [2026-11-27T23:33:46.725+00:00](method-runs/f80a5125c4a144a993dda4b3eb153e7c.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 12.6 | — |
| [2026-11-27T23:33:43.950+00:00](method-runs/d0a70999940344e7b35ff7dc01648602.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 2.8 | — |
| [2026-11-27T23:33:11.068+00:00](method-runs/911d17a9b0144bb78d167bf485fe62f2.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 1.8 | — |
| [2026-11-27T23:33:10.907+00:00](method-runs/578d6096ac7d4009a01fa869bde70c61.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T23:33:08.613+00:00](method-runs/76ebe62ec8cf491392795a1cac8aa51c.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 2.3 | — |
| [2026-11-27T23:33:07.877+00:00](method-runs/e5eb080fddfe4cfa8c5609d2a12c345b.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-27T23:33:05.729+00:00](method-runs/4d3af91dfdb64dbf8e65b17aef93dc67.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 2.4 | — |
| [2026-11-27T23:22:33.754+00:00](method-runs/ccc0aa2668cc47ec96f297ff566cd6ef.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T23:22:32.235+00:00](method-runs/5c47a450485a407db9132de9ea18ee67.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T23:22:31.805+00:00](method-runs/bf72155fecbf408596b6e196a068ba9f.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T23:22:31.665+00:00](method-runs/af2b5f5f9b7744f380f5d03794b4c375.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T23:22:29.035+00:00](method-runs/8060a96a1272461ab40610c45f7553aa.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T23:22:27.973+00:00](method-runs/bfe30cb2cf624c3da200231806acb159.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T23:22:22.719+00:00](method-runs/3011c0c4b4db44dea496fb12973949db.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 5.2 | — |
| [2026-11-27T23:22:10.253+00:00](method-runs/40934b59a49d423c95c98da1d5b150cd.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T23:22:10.165+00:00](method-runs/a9da0568a5934145860f624bbbfd5dbe.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T23:22:10.072+00:00](method-runs/8fd81e000ee848ea950f4631c221c381.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T23:22:09.973+00:00](method-runs/130ac40bfaef4a189f4c43869cea0f45.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T23:22:09.672+00:00](method-runs/046e10afcf004d8199c906d0da3f28b4.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
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

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
