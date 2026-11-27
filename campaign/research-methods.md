# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 59 | 0 | 48.4 | — | — |
| e27-schmidt | 59 | 0 | 74.6 | — | — |
| gagatsos-2026-c1 | 222 | 0 | 611.5 | — | — |
| golay43 | 119 | 35 | 495.0 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 1 | 0 | 190.8 | 797,530 / 5,583 | 1/1 |
| refined-bmv | 61 | 0 | 129.0 | 226,762 / 2,761 | 2/2 |
| support-enumeration | 8 | 0 | 261.1 | — | — |
| thomson-10 | 15 | 0 | 8.4 | — | — |
| thomson-11 | 14 | 0 | 5.1 | — | — |
| thomson-13 | 15 | 0 | 7.7 | — | — |
| thomson-14 | 15 | 0 | 7.3 | — | — |
| werner-endpoint | 119 | 0 | 142.0 | 67,096 / 624 | 1/1 |

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

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
