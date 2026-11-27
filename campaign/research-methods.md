# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 70 | 0 | 64.9 | — | — |
| e27-schmidt | 70 | 0 | 92.9 | — | — |
| gagatsos-2026-c1 | 264 | 0 | 889.6 | — | — |
| golay43 | 141 | 46 | 515.6 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 73 | 0 | 190.9 | 284,541 / 4,116 | 3/3 |
| support-enumeration | 9 | 0 | 295.4 | — | — |
| thomson-10 | 18 | 0 | 10.3 | — | — |
| thomson-11 | 17 | 0 | 5.8 | — | — |
| thomson-13 | 18 | 0 | 10.3 | — | — |
| thomson-14 | 17 | 0 | 9.1 | — | — |
| werner-endpoint | 141 | 0 | 161.6 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T15:47:43.682+00:00](method-runs/cd718170e4d74c2d80099506e79a6acf.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T15:47:42.759+00:00](method-runs/11d4375e3013432b9fe87668cbf57a24.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T15:47:42.345+00:00](method-runs/58703f344c4e4969a8b3326e19fc8395.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T15:47:42.230+00:00](method-runs/d048751e96a64b64a437b980cf99a129.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T15:47:04.070+00:00](method-runs/851a1d5973cd419f8afb604f2e21756d.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 12.6 | — |
| [2026-11-27T15:46:48.650+00:00](method-runs/0d5754653df449ed889f204f132a9b19.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 15.4 | — |
| [2026-11-27T15:46:30.972+00:00](method-runs/65cfc2c606974ed683b44db29779b471.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 17.7 | — |
| [2026-11-27T15:45:31.165+00:00](method-runs/bce8fe284b9b43b3bcb1f3fd140431f1.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 5.6 | — |
| [2026-11-27T15:45:28.553+00:00](method-runs/0dd132b7c4f94a9280718d828f0491cb.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 2.6 | — |
| [2026-11-27T15:45:23.486+00:00](method-runs/1673b41d42dd4862a79ce392cf0b9e56.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 5.0 | — |
| [2026-11-27T15:45:22.832+00:00](method-runs/07f5717ce0dc4442a3f4f742fcbca836.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.6 | — |
| [2026-11-27T15:45:18.986+00:00](method-runs/e6d6f9103ebe4e8f85aa5b6512704dc9.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 4.0 | — |
| [2026-11-27T15:34:20.553+00:00](method-runs/8fdb8ec403174110ba6f9eaad32cda97.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.9 | — |
| [2026-11-27T15:34:18.735+00:00](method-runs/0cd00761d8694d0094b54f643d3ec9c4.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T15:34:18.254+00:00](method-runs/f8d7de2071a140e6a61da810df26686c.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T15:34:17.948+00:00](method-runs/72c653c20834464ba1367f18364db458.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T15:33:46.895+00:00](method-runs/00683c5d92df4ca5b1adb9b084df48ec.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 12.9 | — |
| [2026-11-27T15:33:31.396+00:00](method-runs/7556c39642fa490992baf4579304e4b5.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 15.5 | — |
| [2026-11-27T15:33:17.398+00:00](method-runs/0241be1d0de54da59ba7bb43f43d51aa.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 14.0 | — |
| [2026-11-27T15:33:08.625+00:00](method-runs/214eaa6b0c0744d7ad8e5aee655c0f6f.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T15:33:08.527+00:00](method-runs/e50fcfe2c2ee4b7ca85c57a600f2eadc.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T15:33:08.422+00:00](method-runs/27ecac453c8d40069dd193692c8e9fdf.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T15:33:08.308+00:00](method-runs/2d4f3837ef5e403cb11594a8c7a5e80d.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T15:33:08.017+00:00](method-runs/13dd1ccaaf9943fba105ab53330eda12.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T15:22:16.969+00:00](method-runs/1decfb319507403988d6ffbd15b76415.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T15:22:16.035+00:00](method-runs/e8574d9f08f3479bb6338f7b42fe64f1.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T15:22:15.623+00:00](method-runs/e12a69cd6c164d4eb5d39dd680e73d3f.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T15:22:15.506+00:00](method-runs/fb50db7d21894e1a852698732b1a985b.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T15:22:08.751+00:00](method-runs/b121dbbf38ef439eb73b94cea566f26d.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 5.0 | — |
| [2026-11-27T15:22:04.652+00:00](method-runs/85b3b34ddbef4cc68c4c9eef1dedfc00.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 4.1 | — |
| [2026-11-27T15:21:55.830+00:00](method-runs/39275371263d49e1b527d8be6c654e7a.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 8.8 | — |
| [2026-11-27T15:21:47.510+00:00](method-runs/6eae7aa604014f1a910d00ea84722add.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T15:21:47.416+00:00](method-runs/8285cfd714ca468eb1cdbe4a916c9080.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T15:21:47.282+00:00](method-runs/38ca8253ec734c449f50032e5d77a02b.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T15:21:47.168+00:00](method-runs/719998d811e64ab88d2f3603419ca77e.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T15:21:46.765+00:00](method-runs/bf9dc0bc3dc049d28fef7df566a3d790.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T15:10:01.873+00:00](method-runs/f4239eae214c4944b6437f72ac30ac09.json) | refined-bmv | math_review | independent-challenge | gpt-6.2-astra / medium | completed / revise | 54.9 | 57,779 / 1,355 |
| [2026-11-27T15:09:25.120+00:00](method-runs/d3eb9e0cb8804255af92fdd0b0e63c30.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 34.3 | — |
| [2026-11-27T15:09:24.053+00:00](method-runs/0e73789378994f759e09fe8a0bdb75a0.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 1.1 | — |
| [2026-11-27T15:09:18.821+00:00](method-runs/c6b498abc4374ab38543e71f05dde275.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 2.0 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
