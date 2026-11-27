# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 49 | 0 | 35.1 | — | — |
| e27-schmidt | 49 | 0 | 54.3 | — | — |
| gagatsos-2026-c1 | 185 | 0 | 327.1 | — | — |
| golay43 | 99 | 25 | 466.6 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 1 | 0 | 190.8 | 797,530 / 5,583 | 1/1 |
| refined-bmv | 50 | 0 | 56.9 | 69,669 / 997 | 1/1 |
| support-enumeration | 6 | 0 | 199.6 | — | — |
| thomson-10 | 12 | 0 | 7.0 | — | — |
| thomson-11 | 12 | 0 | 4.3 | — | — |
| thomson-13 | 13 | 0 | 7.0 | — | — |
| thomson-14 | 12 | 0 | 5.2 | — | — |
| werner-endpoint | 99 | 0 | 124.5 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T11:19:09.021+00:00](method-runs/3330c0b0b8b84d6ab7896ab51c21acb3.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-27T11:19:04.331+00:00](method-runs/d8b3fd11e754444396457b5c2b6d9300.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T11:19:03.911+00:00](method-runs/a79797f8b2a141fc94beb5f390eae7e0.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T11:19:03.484+00:00](method-runs/12dad4b0a81548759fc8b09ac2a329ea.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T11:18:42.515+00:00](method-runs/1b53afe9ccb14bcfb179dd7ee3054f5a.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 7.7 | — |
| [2026-11-27T11:18:36.769+00:00](method-runs/60d404ef202c46bcb471641d803c143d.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 5.7 | — |
| [2026-11-27T11:18:23.596+00:00](method-runs/fb40e12fa4354bb7bf81adfd44497818.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 13.2 | — |
| [2026-11-27T11:17:49.373+00:00](method-runs/b211cd8dac9c47e5bdc34e0bb270ed7c.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 1.6 | — |
| [2026-11-27T11:17:49.255+00:00](method-runs/f76f9afaf17a4f2dbd7039fe86b98088.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T11:17:44.892+00:00](method-runs/9c2503525ecc44acb64e26c86c2fa5b9.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 4.4 | — |
| [2026-11-27T11:17:44.732+00:00](method-runs/dd68a59eae6f4ed3b20924cd2192e563.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T11:17:42.107+00:00](method-runs/1c07e34790fe433c9021209c455e55f4.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 2.7 | — |
| [2026-11-27T11:06:55.400+00:00](method-runs/c9797d0be2c7466db99b84c46a94abbd.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.8 | — |
| [2026-11-27T11:06:39.167+00:00](method-runs/bcaa87fbf9e44f2fb75dc0290b7f37d2.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T11:06:38.658+00:00](method-runs/6a83e14bb929441388067beb7365518e.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T11:06:38.517+00:00](method-runs/4737c00b3f6d45f6ba319d8309c54a23.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T11:06:30.666+00:00](method-runs/7b4c5082f72946aabb277b9d66085898.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.6 | — |
| [2026-11-27T11:06:28.818+00:00](method-runs/be335cb530f941ff8e10b953ef53f3d9.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.8 | — |
| [2026-11-27T11:06:28.032+00:00](method-runs/9291e833a8bd46039f6ce16557188090.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.8 | — |
| [2026-11-27T11:06:20.848+00:00](method-runs/b4b8f21ed6b74643ae802dcbe146d56e.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T11:06:20.740+00:00](method-runs/3e6ac7b4bc354c83b62def41850887a5.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T11:06:20.695+00:00](method-runs/3452543fcf69405190ea4a04392bd949.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.0 | — |
| [2026-11-27T11:06:20.571+00:00](method-runs/28a762f47b1c46d2bfb6fa5c3580300f.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T11:06:20.265+00:00](method-runs/29e4add8eb514e9ab3017c158d2eb781.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
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

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
