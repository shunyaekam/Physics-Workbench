# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 150 | 0 | 110.8 | — | — |
| e27-schmidt | 150 | 0 | 149.1 | — | — |
| gagatsos-2026-c1 | 564 | 0 | 1,488.8 | — | — |
| golay43 | 301 | 93 | 932.6 | — | — |
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
| refined-bmv | 160 | 3 | 471.6 | 727,597 / 9,879 | 7/10 |
| support-enumeration | 19 | 0 | 771.4 | — | — |
| thomson-10 | 38 | 0 | 17.9 | — | — |
| thomson-11 | 37 | 0 | 10.9 | — | — |
| thomson-13 | 38 | 0 | 15.9 | — | — |
| thomson-14 | 37 | 0 | 17.2 | — | — |
| werner-endpoint | 301 | 0 | 334.9 | 67,096 / 624 | 1/1 |

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
| [2026-11-28T07:25:07.715+00:00](method-runs/e498366a62784c37aa483e8e31f0ef84.json) | refined-bmv | math_review | independent-challenge | gpt-6.2-astra / medium | completed / revise | 51.6 | 69,231 / 879 |
| [2026-11-28T07:23:23.240+00:00](method-runs/92cd30de57d9462293989e648b7bada7.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-28T07:23:22.465+00:00](method-runs/4782ef9a2ac84580a5f085106e3ecde6.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T07:23:22.028+00:00](method-runs/543fb3b0f4914d12a0c8329f316dc3aa.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T07:23:21.888+00:00](method-runs/69392c71f16b4e62a7948429f9345663.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-28T07:23:19.063+00:00](method-runs/2931bec01b4c4d6995261330592278d3.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-28T07:23:17.962+00:00](method-runs/7040b2e35b834031978e4a8339e3e5e8.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-28T07:23:17.316+00:00](method-runs/02da111adf6e4d06b88d23983bfb7972.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.6 | — |
| [2026-11-28T07:23:10.195+00:00](method-runs/f0c8275948ea4c07bb9bae2cb0f9aa1f.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T07:23:10.075+00:00](method-runs/0c637b2a5c3841928a818f738ded95bf.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T07:23:03.069+00:00](method-runs/51286645ae6b4daf9293bb3d283563b5.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 7.0 | — |
| [2026-11-28T07:23:02.940+00:00](method-runs/55cf62cf538f4cd1a7df258f859316fa.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T07:23:02.664+00:00](method-runs/d5f356aeabea4395a7b6559d371ab7ca.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-28T07:10:58.432+00:00](method-runs/e7cddd7a5d5a45fab893252a59e7d244.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-28T07:10:57.664+00:00](method-runs/fa36408e927249a0b41e99c1d551ab27.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T07:10:57.227+00:00](method-runs/79d062e7e4fb474a8bc2054478d2d2a7.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T07:10:57.076+00:00](method-runs/78c6305302b44514b9716a32fb2932cd.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-28T07:10:54.158+00:00](method-runs/e21547efb0de44be945db7d6e6ac1910.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-28T07:10:52.754+00:00](method-runs/3acb3e5246ef480ab8ef2b1d9479dbe4.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.4 | — |
| [2026-11-28T07:10:52.082+00:00](method-runs/5d2cead872034744afc0940af8cf1568.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-28T07:10:44.769+00:00](method-runs/9f12dce9542c42d3ac154c7df09a655d.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T07:10:44.644+00:00](method-runs/d3b4e6fb9311422bad14b2aea89bf4ce.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T07:10:37.436+00:00](method-runs/44f59ceeadab467a8024014b778849ec.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 7.2 | — |
| [2026-11-28T07:10:37.313+00:00](method-runs/45f7209c5b9442f78814e9b504903410.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T07:10:37.037+00:00](method-runs/f4602568cd5c492b9d9a32eb5ddf3805.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-28T06:58:26.830+00:00](method-runs/13f6bb84a78d457093cb6ed9c985eae7.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-28T06:58:26.072+00:00](method-runs/a9ef77d96bc7413989a3cef0898b87ca.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T06:58:25.641+00:00](method-runs/cdb011b5044d44fda15cb000fe748ae5.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T06:58:25.497+00:00](method-runs/3f7dc04f288b4052bd74a82884d72de6.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-28T06:58:22.565+00:00](method-runs/b4db9958561349008d7828e9e13ee595.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-28T06:58:21.386+00:00](method-runs/95927d8557a24ffd87d221da88a893d1.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-28T06:58:20.676+00:00](method-runs/6d0406958fd14e9287924561b4c5ef11.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-28T06:58:13.281+00:00](method-runs/86bfa61b49fb417e908aa0f22ebaa30a.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T06:58:13.155+00:00](method-runs/15b5e210187c4d51bda376c78c21c4fd.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T06:58:05.885+00:00](method-runs/5a881f128e4544a1b15b5ed3c8800e09.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 7.3 | — |
| [2026-11-28T06:58:05.754+00:00](method-runs/3290a06f68c845dc88054d266de3e858.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T06:58:05.472+00:00](method-runs/feae241cddef462db7242ce8c52e18fe.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-28T06:45:29.730+00:00](method-runs/3bb1ce2510514353a7868c12db55d7fe.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 32.3 | — |
| [2026-11-28T06:45:29.589+00:00](method-runs/2c38ed59b37a45b88a9ef7f2f8e1b0b8.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-28T06:45:27.203+00:00](method-runs/b224bc3e467c4ad592946b740a33686b.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.6 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
