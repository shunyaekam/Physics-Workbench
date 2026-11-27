# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 47 | 0 | 33.3 | — | — |
| e27-schmidt | 47 | 0 | 51.3 | — | — |
| gagatsos-2026-c1 | 177 | 0 | 294.8 | — | — |
| golay43 | 95 | 23 | 461.9 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 1 | 0 | 190.8 | 797,530 / 5,583 | 1/1 |
| refined-bmv | 48 | 0 | 56.7 | 69,669 / 997 | 1/1 |
| support-enumeration | 6 | 0 | 199.6 | — | — |
| thomson-10 | 12 | 0 | 7.0 | — | — |
| thomson-11 | 11 | 0 | 3.5 | — | — |
| thomson-13 | 12 | 0 | 6.6 | — | — |
| thomson-14 | 12 | 0 | 5.2 | — | — |
| werner-endpoint | 95 | 0 | 122.3 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T10:52:32.506+00:00](method-runs/90bf367a9864446ca81e4156b9cd9a02.json) | lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | scout | source-screen-and-notebook | gpt-6.2-sol / low | completed / shortlist | 190.8 | 797,530 / 5,583 |
| [2026-11-27T10:52:30.354+00:00](method-runs/8c7c339207914309a5022211d0717d86.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T10:52:28.073+00:00](method-runs/016e25c7590f41068f997d678bfab558.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.5 | — |
| [2026-11-27T10:52:26.457+00:00](method-runs/02299a3023474cf6ac77b9e33ef10544.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.6 | — |
| [2026-11-27T10:52:23.150+00:00](method-runs/555f45e17c1c47caa13d5b061c461fdc.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.8 | — |
| [2026-11-27T10:52:22.053+00:00](method-runs/cccfc58645584abdbcc6b2bd5dbad6ee.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T10:52:21.384+00:00](method-runs/24afbb3b1fdc4ef3a39c4054c07b9ad3.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-27T10:52:14.233+00:00](method-runs/79082a4298d7423da010521f9338f39a.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T10:52:14.124+00:00](method-runs/a0d1ccf77a3e4e8c84ef11c85846d534.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T10:52:14.077+00:00](method-runs/9981b669520f4b80b6fe3abff5f6b264.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.0 | — |
| [2026-11-27T10:52:13.946+00:00](method-runs/be73b4d56f1d453599517af5e621bf6f.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T10:52:13.650+00:00](method-runs/e58cf8338b774e0ca35ada4219f3ba81.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T10:41:19.279+00:00](method-runs/ddce597cb7544b22ad18aa82335e6aec.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T10:41:18.437+00:00](method-runs/031b2f151670436da3a1655853d46061.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T10:41:18.022+00:00](method-runs/766e88f9c69a4f2594212fc80c1db6ef.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T10:41:17.882+00:00](method-runs/d284d8d1fa404565a0fd6179b870627a.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T10:41:14.807+00:00](method-runs/4befc5a037a94d1ea354d1c9e55df54d.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-27T10:41:13.640+00:00](method-runs/3cbd0938e23d4b47a23595cb0544ae86.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-27T10:41:12.960+00:00](method-runs/d2d28f0cfa444cc68b5ed7fcb13e8c60.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-27T10:41:04.898+00:00](method-runs/ebd9ebd283814ec88427c21196a4ac04.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T10:41:04.789+00:00](method-runs/430f3e60e7744293b71ff137b95f1e6f.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T10:41:04.680+00:00](method-runs/b3833caaa26e46f48d79b33c314cc0d8.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T10:41:04.549+00:00](method-runs/6403c7dd2f4c42138a443f5ae9013fc4.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T10:41:04.249+00:00](method-runs/72f1f41b6996458a8b896f9004a94b86.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T10:30:17.824+00:00](method-runs/35b373254bcc470683ecebfacd500f24.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 1.9 | — |
| [2026-11-27T10:30:01.032+00:00](method-runs/c4e96a468159485da0651a27cf325b6f.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.7 | — |
| [2026-11-27T10:29:59.940+00:00](method-runs/38690b18093d4eceb886665f42f031b4.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.1 | — |
| [2026-11-27T10:29:59.761+00:00](method-runs/b0a9e70b215445edac0de634ee405a6a.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T10:29:55.116+00:00](method-runs/1449e0119b4a47f79cb2ee2178662aa0.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.7 | — |
| [2026-11-27T10:29:53.021+00:00](method-runs/356d4557882c469490ffc3ebdb8aecd0.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T10:29:51.787+00:00](method-runs/41ffe575460b43259090633713bd1ec0.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.2 | — |
| [2026-11-27T10:29:41.519+00:00](method-runs/23312baf29af49bbab1c1a6756afb939.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T10:29:41.370+00:00](method-runs/442bc94708914b39bf6d5624d3243eeb.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T10:29:41.119+00:00](method-runs/6d09b3140a9d4dcdbbd5c2a8b7f4d8b6.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T10:29:40.747+00:00](method-runs/c710d678d73a465fb17dcaccf93e45c3.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T10:29:40.207+00:00](method-runs/6fd5c6d057024f22819e145f527edf3e.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-27T10:19:03.281+00:00](method-runs/a60c4442cea3465093ab28d956bd4bfb.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.8 | — |
| [2026-11-27T10:18:46.554+00:00](method-runs/a68a7ca2f29043ed9108d4f182ad1525.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T10:18:45.630+00:00](method-runs/862224840b1c49e2af3496fd6e110f8c.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T10:18:44.841+00:00](method-runs/19d5a9392dde49c8aa6dae8a6a9e8faa.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 1.3 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
