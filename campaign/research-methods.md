# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 124 | 0 | 102.4 | — | — |
| e27-schmidt | 124 | 0 | 138.0 | — | — |
| gagatsos-2026-c1 | 466 | 0 | 1,380.8 | — | — |
| golay43 | 249 | 93 | 666.7 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| lts-oeis-a284230 | 2 | 1 | 111.1 | 185,342 / 2,527 | 1/2 |
| refined-bmv | 131 | 3 | 326.4 | 446,095 / 6,119 | 4/7 |
| support-enumeration | 16 | 0 | 655.0 | — | — |
| thomson-10 | 31 | 0 | 16.2 | — | — |
| thomson-11 | 31 | 0 | 9.5 | — | — |
| thomson-13 | 31 | 0 | 14.2 | — | — |
| thomson-14 | 31 | 0 | 15.2 | — | — |
| werner-endpoint | 249 | 0 | 284.9 | 67,096 / 624 | 1/1 |

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
| [2026-11-28T01:58:30.745+00:00](method-runs/d6251f3001e447ceacf60cf041be469f.json) | refined-bmv | math_review | independent-challenge | gpt-6.2-astra / medium | failed / RuntimeError | 19.4 | — |
| [2026-11-28T01:58:28.461+00:00](method-runs/22f844a7cd254933a72ed75b34c3d532.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-28T01:58:27.020+00:00](method-runs/cb2f6a3986d2451a939ed95fb83fc00a.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.8 | — |
| [2026-11-28T01:58:26.601+00:00](method-runs/a24e09afd8194a83827c77e5164b0979.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T01:58:26.470+00:00](method-runs/64365748a0b84027a747bdf1f7174776.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-28T01:58:23.651+00:00](method-runs/d659ef71f2cd4f40b2a292a654f39fa1.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-28T01:58:22.542+00:00](method-runs/15a53fc8705e445284fd6b960c6a1c78.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-28T01:58:21.885+00:00](method-runs/cad0eebeb14544b1b5b46330cdacea4b.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.6 | — |
| [2026-11-28T01:58:14.060+00:00](method-runs/51c13c3a4bea4f79ae4ab2aab1fe2359.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T01:58:13.957+00:00](method-runs/7f643a40d99945eb90158e17aa21a325.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T01:58:07.145+00:00](method-runs/9b22d3528f1b4e98874f845bdfc4ebfd.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 6.8 | — |
| [2026-11-28T01:58:07.029+00:00](method-runs/0b9d71cb6ecf46a0b60c84eb58b2b4e6.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T01:58:06.711+00:00](method-runs/a77649eda2a64550b109ddad9d7efb62.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-28T01:47:32.851+00:00](method-runs/d42d50f40d7e40e7b4b4ab3151075f41.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 20.7 | — |
| [2026-11-28T01:47:32.731+00:00](method-runs/1565818928d349e2b1796cdf97ac5b61.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-28T01:47:30.475+00:00](method-runs/4fc8513715b6423b89ca5c662d6b634c.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.5 | — |
| [2026-11-28T01:47:28.771+00:00](method-runs/f1aaa82284ce4156a05a3aac57a1f63c.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.8 | — |
| [2026-11-28T01:47:26.787+00:00](method-runs/3b8c92d8743a46ef84b87daf5ae1bfe8.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-28T01:47:25.759+00:00](method-runs/3052a7e92f33475a8de242c1d14602eb.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.0 | — |
| [2026-11-28T01:47:25.073+00:00](method-runs/33b05b659202498589d7262ee5ca75a0.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-28T01:47:18.104+00:00](method-runs/4ad46f251e0245449297647784f40579.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T01:47:18.001+00:00](method-runs/e2ed5509ee52444aa316fae243415d75.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T01:47:11.197+00:00](method-runs/46774e7ac6bd44f59b25ce35d2003c8d.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 6.8 | — |
| [2026-11-28T01:47:11.083+00:00](method-runs/7a39c6219a8b4c0caf1c8e16db86ef31.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T01:47:10.795+00:00](method-runs/24fd6186bd774ce888d608f2d11e5ead.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-28T01:36:56.118+00:00](method-runs/354bc85488a64a52b4be492cf7290d64.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-28T01:36:55.347+00:00](method-runs/f5860ae51f3947feb423728f26154f94.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T01:36:54.936+00:00](method-runs/11d7355b52dc43c2bc408b67279a0e88.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T01:36:54.810+00:00](method-runs/100f1905cc254141b94e7f19e6bcd794.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-28T01:36:52.213+00:00](method-runs/5872ec86ef7a40c4b0626ccf89e9abaf.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-28T01:36:51.162+00:00](method-runs/199d0bb08092444ebc71be656b47a1de.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.0 | — |
| [2026-11-28T01:36:50.482+00:00](method-runs/54e8d225d2604397aba09cae7eed0613.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-28T01:36:43.304+00:00](method-runs/689827cc93b84e2e8244aefb01c9f9b1.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T01:36:43.204+00:00](method-runs/40de938ddcdc4d3b987296aad004d680.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T01:36:36.566+00:00](method-runs/bc5c628cfc9b44658cd6e4f7c2ada415.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 6.6 | — |
| [2026-11-28T01:36:36.454+00:00](method-runs/a66f45b4e90f43968edce6f4f172dc4c.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T01:36:36.171+00:00](method-runs/34ebfbd228b14c94bd3afd0ed84bc4da.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-28T01:26:14.324+00:00](method-runs/f5b2fe847af8451ab8ebabb0d08a4c74.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-28T01:26:13.507+00:00](method-runs/40143aa6f3c247c1971100d732a41d5b.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T01:26:13.094+00:00](method-runs/2599bff3390c42ad82d077f7579de70c.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
