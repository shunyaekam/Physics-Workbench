# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 128 | 0 | 103.9 | — | — |
| e27-schmidt | 128 | 0 | 140.2 | — | — |
| gagatsos-2026-c1 | 481 | 0 | 1,400.3 | — | — |
| golay43 | 257 | 93 | 716.4 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| lts-oeis-a284230 | 2 | 1 | 111.1 | 185,342 / 2,527 | 1/2 |
| refined-bmv | 135 | 3 | 327.1 | 446,095 / 6,119 | 4/7 |
| support-enumeration | 16 | 0 | 655.0 | — | — |
| thomson-10 | 32 | 0 | 16.6 | — | — |
| thomson-11 | 32 | 0 | 9.9 | — | — |
| thomson-13 | 32 | 0 | 14.5 | — | — |
| thomson-14 | 32 | 0 | 15.7 | — | — |
| werner-endpoint | 257 | 0 | 296.7 | 67,096 / 624 | 1/1 |

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
| [2026-11-28T02:42:27.981+00:00](method-runs/dcb6d89c5c224057bde2f357ab9d1f28.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-28T02:42:26.401+00:00](method-runs/525ae67efe4940a5b46a9ebb73ecf49c.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-28T02:42:25.446+00:00](method-runs/5d648589b0844b778b8959afd21820c4.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-28T02:42:25.169+00:00](method-runs/ecc0360d36e54600ba523cbc722806b9.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-28T02:42:20.136+00:00](method-runs/63074262ce3b4d5696fb9a3a844e63c2.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-28T02:42:18.181+00:00](method-runs/e3e6d092886942da89f3b86bdb9b025b.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.9 | — |
| [2026-11-28T02:42:17.048+00:00](method-runs/1bad5d57ad9c48c3adf606eeed1081f1.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.1 | — |
| [2026-11-28T02:42:03.529+00:00](method-runs/b66e5ffe101c493096a43bcf41999d87.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-28T02:42:03.333+00:00](method-runs/d0c20c2de6c346399d8eed2c4e457dfa.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T02:41:49.591+00:00](method-runs/ee710926ba14430eb8d0fd25dec6ab4d.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 13.7 | — |
| [2026-11-28T02:41:49.376+00:00](method-runs/781b6a71ecc84d60b02e54164139598b.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T02:41:48.823+00:00](method-runs/0c766a4ae01942d5add064c88132ec70.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-28T02:31:26.898+00:00](method-runs/f15eb969b636455e872f4308151a140c.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-28T02:31:22.058+00:00](method-runs/8bcf7e3016334a3e8d41266d40cbea29.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 3.5 | — |
| [2026-11-28T02:31:18.248+00:00](method-runs/3f45c9dcc9c648cc81394531c6e3ef77.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 3.9 | — |
| [2026-11-28T02:31:14.615+00:00](method-runs/6544644577694273b93b9903113ea49f.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-28T02:31:12.620+00:00](method-runs/96cfe7c0fc964d249475374ffc1b5980.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-28T02:31:11.453+00:00](method-runs/9437ae14455649939cc6836ad5607e6b.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.2 | — |
| [2026-11-28T02:30:57.851+00:00](method-runs/807f0e6fb268484ab59cd39ac51c8b22.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-28T02:30:57.651+00:00](method-runs/ec2209971ad44d9ab1c6d9a50ae62673.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T02:30:43.278+00:00](method-runs/e74fad7d43894329a92a15548191f29c.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 14.4 | — |
| [2026-11-28T02:30:43.063+00:00](method-runs/da2ce0e1ab874ef2af023e3d177e6540.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T02:30:42.511+00:00](method-runs/e231b3cc41854e2485388282b19260cf.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-28T02:20:20.330+00:00](method-runs/7aff7f186b7c478f818bbc537c752911.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-28T02:20:18.764+00:00](method-runs/93cd57cd7f2f454caac3114f60297bdb.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-28T02:20:17.826+00:00](method-runs/14b003bea06e42569ec432285a3a3b2f.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-28T02:20:17.577+00:00](method-runs/a4b4a539b5024c91bb38e40ccfe92c62.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T02:20:12.420+00:00](method-runs/cd27f62094ca4755b7ce3ace82dd28fb.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-28T02:20:10.427+00:00](method-runs/f8b717381ba748cdb12e571b4c1a058e.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-28T02:20:09.114+00:00](method-runs/184cb11701f74fd694cf50798a194fc4.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.3 | — |
| [2026-11-28T02:19:55.649+00:00](method-runs/55bc5ec0888744de837cb38289351069.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-28T02:19:55.445+00:00](method-runs/966cb5c422fe4489947ac3f741131a7f.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T02:19:41.377+00:00](method-runs/3a17224d2af6460693d1a93fd264cabe.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 14.1 | — |
| [2026-11-28T02:19:41.144+00:00](method-runs/c0225ecdfd4844b98de7e8ea92af7d7e.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T02:19:40.507+00:00](method-runs/92504bf95e2b41dfb6af118d322bfb5f.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.7 | — |
| [2026-11-28T02:09:21.453+00:00](method-runs/bc03664ee5f546f28a4d429220f68499.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-28T02:09:20.700+00:00](method-runs/10eb6c3ce3fd48e98069ce584c2a718f.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T02:09:20.292+00:00](method-runs/b443b87f3b15400c9dd0c13a7e943139.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T02:09:20.163+00:00](method-runs/7ca2fba234ab43789e010c47e13ad4eb.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-28T02:09:17.621+00:00](method-runs/9ceb8fa542a84dbdac368df2d3cc7d0c.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.1 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
