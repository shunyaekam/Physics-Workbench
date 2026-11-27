# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 62 | 0 | 51.6 | — | — |
| e27-schmidt | 62 | 0 | 80.5 | — | — |
| gagatsos-2026-c1 | 234 | 0 | 654.9 | — | — |
| golay43 | 125 | 38 | 501.0 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| refined-bmv | 64 | 0 | 131.3 | 226,762 / 2,761 | 2/2 |
| support-enumeration | 8 | 0 | 261.1 | — | — |
| thomson-10 | 16 | 0 | 9.9 | — | — |
| thomson-11 | 15 | 0 | 5.4 | — | — |
| thomson-13 | 16 | 0 | 8.4 | — | — |
| thomson-14 | 15 | 0 | 7.3 | — | — |
| werner-endpoint | 125 | 0 | 145.2 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T14:06:31.844+00:00](method-runs/72193671721d41a18a5359fd7bc6ba1b.json) | lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | scout | continue-scored-lemma | gpt-6.2-sol / low | completed / insufficient_evidence | 147.2 | 198,874 / 5,293 |
| [2026-11-27T14:06:20.726+00:00](method-runs/2cd7727ab54949f780b87486b6f481c7.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 1.5 | — |
| [2026-11-27T14:06:14.803+00:00](method-runs/07af1dad4979401f8112f39f29fd1328.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T14:06:14.310+00:00](method-runs/76020d6066d84a6d967e51fd27a92e7c.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T14:06:14.140+00:00](method-runs/314094ce814b414fa7d15c04a4383c83.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T14:06:10.541+00:00](method-runs/cf17bbfb460645e2abf4d7cb4656eb9f.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T14:06:08.994+00:00](method-runs/0176a09d388b4448b16935f8c3e81a55.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T14:05:58.207+00:00](method-runs/f9a446d96e89462d9aa0cdd0c5d66149.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 10.8 | — |
| [2026-11-27T14:05:36.395+00:00](method-runs/14c1407218944178a3053642b95afbe6.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T14:05:36.255+00:00](method-runs/7dfa2dd139464a8db443476c2dc6ba4c.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T14:05:35.926+00:00](method-runs/1d9875ea7ea644d0a5b8e8712b6a1393.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.3 | — |
| [2026-11-27T14:05:35.510+00:00](method-runs/364bf7a99c53443ea6e4cea055514660.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T14:05:32.977+00:00](method-runs/3f6fa7c9f3f4463a9b41e12f5a982c95.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 2.6 | — |
| [2026-11-27T13:54:19.010+00:00](method-runs/c8464345187d451d8727615f92717be5.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.7 | — |
| [2026-11-27T13:54:17.351+00:00](method-runs/ba9b3cbef09a42438388a84efb1ae167.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.8 | — |
| [2026-11-27T13:54:16.837+00:00](method-runs/1d9c35c3c36c4b0ca6636d68cdd054bd.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T13:54:16.703+00:00](method-runs/e36ed134276d4041bd74b72c70973702.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T13:53:54.047+00:00](method-runs/5b8a6a57594a443a92ce8d93dc156d3f.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 11.3 | — |
| [2026-11-27T13:53:49.014+00:00](method-runs/52939271cc1b443f9c832ed54677d985.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 5.0 | — |
| [2026-11-27T13:53:39.491+00:00](method-runs/1ad4522f77d349aaa91f106dd2cc5122.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 9.5 | — |
| [2026-11-27T13:53:28.851+00:00](method-runs/8d8554377e5a4564ade5af0208ccf865.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T13:53:28.731+00:00](method-runs/21172dcceedc4c68b89e94172b45eecd.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T13:53:28.637+00:00](method-runs/890de9140eab452f8b8d3103b4872f80.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T13:53:28.535+00:00](method-runs/d927e215844b41a883fbf6825cb33ecd.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T13:53:28.254+00:00](method-runs/91b6918fd3774675adf455ddd8620dca.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
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

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
