# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 58 | 0 | 48.1 | — | — |
| e27-schmidt | 58 | 0 | 74.3 | — | — |
| gagatsos-2026-c1 | 219 | 0 | 571.3 | — | — |
| golay43 | 117 | 34 | 494.8 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 1 | 0 | 190.8 | 797,530 / 5,583 | 1/1 |
| refined-bmv | 60 | 0 | 128.9 | 226,762 / 2,761 | 2/2 |
| support-enumeration | 7 | 0 | 228.0 | — | — |
| thomson-10 | 15 | 0 | 8.4 | — | — |
| thomson-11 | 14 | 0 | 5.1 | — | — |
| thomson-13 | 15 | 0 | 7.7 | — | — |
| thomson-14 | 14 | 0 | 6.3 | — | — |
| werner-endpoint | 117 | 0 | 137.8 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T13:02:19.871+00:00](method-runs/dee9a43eab034c73b05f90f68996b2af.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T13:01:31.379+00:00](method-runs/c67bf25b30ef4491a82b4a47500429f8.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 17.8 | — |
| [2026-11-27T13:01:16.026+00:00](method-runs/1d9ddc5e86694297bafe303ccd5caaf8.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 15.3 | — |
| [2026-11-27T13:00:55.895+00:00](method-runs/b66019ee1cbc425cbcd99ae904078067.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 20.1 | — |
| [2026-11-27T13:00:23.757+00:00](method-runs/8f6d1a6a1de94816a1b7886c3cf84b0d.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T13:00:23.643+00:00](method-runs/c9b9686be89f44b18456b9383f745ae7.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T13:00:23.432+00:00](method-runs/a9c489c0b5774d708ff25775ff7f1011.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T13:00:23.188+00:00](method-runs/f55b384665f0444bb16ff242aa323a21.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T13:00:19.281+00:00](method-runs/7abae771048240f39b1d109d12d212c6.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 4.0 | — |
| [2026-11-27T12:48:48.219+00:00](method-runs/d9ebcd3313dd437a92977b09a700546e.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.7 | — |
| [2026-11-27T12:48:38.825+00:00](method-runs/035f5fab5e7d4e2cbba08a26af8d2be6.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T12:48:38.243+00:00](method-runs/ac8b87a8b45d4432852d891b98dd1aab.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T12:48:37.637+00:00](method-runs/ac22342690874513ba6560e192de5a9c.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T12:48:00.196+00:00](method-runs/5fc62c62700a4066828670a67f4d0ae6.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 12.5 | — |
| [2026-11-27T12:47:43.365+00:00](method-runs/f229e7fa2f6347588d94a3193c80da21.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 16.8 | — |
| [2026-11-27T12:47:23.740+00:00](method-runs/284d7f22260e47f789a62db0e33cb8da.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 19.6 | — |
| [2026-11-27T12:46:20.111+00:00](method-runs/bb705b0ee87640a990bcdfdf71754d91.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 3.0 | — |
| [2026-11-27T12:46:19.070+00:00](method-runs/6cdca74d27d64e9294d00fbb7fa17a90.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 1.0 | — |
| [2026-11-27T12:46:13.457+00:00](method-runs/329f84c587cf44b8a3d8f965a5c9b3d0.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 5.6 | — |
| [2026-11-27T12:46:13.116+00:00](method-runs/c18f822162e84db7b59afbe3c5482a34.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T12:46:10.188+00:00](method-runs/4781bf93abfe43ec8ea8fd98f750a585.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 3.0 | — |
| [2026-11-27T12:33:42.572+00:00](method-runs/27bd56c735544af09caff97d4db336f9.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 1.0 | — |
| [2026-11-27T12:33:30.855+00:00](method-runs/cde2877904c74b08b29a4d08aa174e9b.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.8 | — |
| [2026-11-27T12:33:29.179+00:00](method-runs/f66749288d344ffa8062685a6f6845b8.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 2.0 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
