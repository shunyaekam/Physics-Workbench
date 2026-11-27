# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 60 | 0 | 51.1 | — | — |
| e27-schmidt | 60 | 0 | 77.6 | — | — |
| gagatsos-2026-c1 | 226 | 0 | 614.8 | — | — |
| golay43 | 121 | 36 | 500.1 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 1 | 0 | 190.8 | 797,530 / 5,583 | 1/1 |
| refined-bmv | 62 | 0 | 131.1 | 226,762 / 2,761 | 2/2 |
| support-enumeration | 8 | 0 | 261.1 | — | — |
| thomson-10 | 15 | 0 | 8.4 | — | — |
| thomson-11 | 15 | 0 | 5.4 | — | — |
| thomson-13 | 15 | 0 | 7.7 | — | — |
| thomson-14 | 15 | 0 | 7.3 | — | — |
| werner-endpoint | 121 | 0 | 142.9 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T13:42:46.744+00:00](method-runs/c323968e81754094830e7bf8f4482751.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T13:42:45.922+00:00](method-runs/231af8e6c78c49a4b76fcdf92f8655d1.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T13:42:45.444+00:00](method-runs/e48e5ce4fc75432383cc5612f8ee45c4.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T13:42:45.320+00:00](method-runs/6969f8d453a845f58007ffd6d4928e8c.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T13:42:42.705+00:00](method-runs/004cb4b22ae74e4590d70d7955656a9c.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-27T13:42:41.280+00:00](method-runs/077d6bd048e140b48ee191a4e55a2fdd.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.4 | — |
| [2026-11-27T13:42:40.599+00:00](method-runs/c1fd5b8a032f4a6d83883fff64e97e66.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-27T13:41:52.494+00:00](method-runs/f9dbbba172a445d4b224b6a6381d8f64.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 2.7 | — |
| [2026-11-27T13:41:50.446+00:00](method-runs/16ae001831914254ae3fc09d9be4ff2c.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 2.0 | — |
| [2026-11-27T13:41:45.537+00:00](method-runs/3f51e0f36587425485d44e152bcdfe64.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 4.9 | — |
| [2026-11-27T13:41:45.292+00:00](method-runs/15c760e451ad4e34bc440c6094666a91.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T13:41:42.419+00:00](method-runs/cd5060a6857648aa8c45e3283315fb93.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 3.0 | — |
| [2026-11-27T13:30:11.030+00:00](method-runs/ec56328331e849d9971a5b43e7267967.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 33.1 | — |
| [2026-11-27T13:30:10.081+00:00](method-runs/84a0807f8d9e48729cf1ecb08e875b37.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.9 | — |
| [2026-11-27T13:29:52.580+00:00](method-runs/cd790e7dbae14b9dab2ba6afdc850037.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.9 | — |
| [2026-11-27T13:29:50.506+00:00](method-runs/b0f6a3c1b47d4278a199048111b9d92f.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 2.3 | — |
| [2026-11-27T13:29:25.429+00:00](method-runs/44ae4f9efdcd4c1c924014985f0bf3ab.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 12.4 | — |
| [2026-11-27T13:29:11.252+00:00](method-runs/5d97db4839334c94a051a94dc99ed530.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 14.2 | — |
| [2026-11-27T13:28:57.599+00:00](method-runs/70adae4644d84df6a4f83b2814b34d1a.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 13.6 | — |
| [2026-11-27T13:28:34.947+00:00](method-runs/d616dd46e2e0403d916224fd5111c53a.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T13:28:34.824+00:00](method-runs/a0c23914f481436598f934f0f5b0334e.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T13:28:34.716+00:00](method-runs/c88a6d6ab1dc4895810bf0f578b3ef4d.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T13:28:34.616+00:00](method-runs/8eef987f1e1a4ea7806ad1c262ca9a52.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T13:28:34.326+00:00](method-runs/ad92bfc0db734297a61e886642e72845.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T13:18:02.463+00:00](method-runs/0bd9f17614a74a288ed3d0fab3547b63.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 1.0 | — |
| [2026-11-27T13:17:58.798+00:00](method-runs/d27ca2fef6a34eff859752958ad592ec.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T13:17:58.343+00:00](method-runs/1c4dbe788a254a57914157e9b4791351.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T13:17:58.227+00:00](method-runs/e2cb52fcd65641f8b7fc1440ed28da62.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T13:17:55.521+00:00](method-runs/4557207a31524c3f9b476d30118ea56b.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-27T13:17:54.503+00:00](method-runs/f13020867bd74e70bb10f267472e4357.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.0 | — |
| [2026-11-27T13:17:49.067+00:00](method-runs/84d9cec8a5b3495181d66d512d99e22e.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 5.4 | — |
| [2026-11-27T13:16:43.194+00:00](method-runs/cacdc048cc574105828c102248a01cba.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 3.0 | — |
| [2026-11-27T13:16:41.110+00:00](method-runs/8077f18a75e84e5e8e62d4ac945499da.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 2.1 | — |
| [2026-11-27T13:16:35.951+00:00](method-runs/9a19da847eee43aba23499e782a34a60.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 5.1 | — |
| [2026-11-27T13:16:35.562+00:00](method-runs/92ae5977e1a540a888d6c09347859eb6.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T13:16:32.071+00:00](method-runs/7ca158c478834acda82297f31440dbf9.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 3.6 | — |
| [2026-11-27T13:02:33.881+00:00](method-runs/6fec8c27069e4a939d361cbe0d369ce1.json) | lts-Erdos1165.erdos_1165.R1.H1 | scout | source-screen-and-notebook | gpt-6.2-sol / low | completed / prior_resolution | 146.0 | 975,341 / 4,634 |
| [2026-11-27T13:02:28.519+00:00](method-runs/e3f9b2e2241c41f98d8aeafc3e069259.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T13:02:20.680+00:00](method-runs/6e1a5087a8bf40c3807792d6d01a5f39.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T13:02:20.231+00:00](method-runs/29b416fed5bd4798b17b8f63a137c094.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
