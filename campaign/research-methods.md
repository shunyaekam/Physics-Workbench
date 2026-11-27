# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 100 | 0 | 81.9 | — | — |
| e27-schmidt | 100 | 0 | 115.2 | — | — |
| gagatsos-2026-c1 | 376 | 0 | 1,199.7 | — | — |
| golay43 | 201 | 76 | 537.8 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| lts-oeis-a284230 | 1 | 1 | 19.7 | — | 0/1 |
| refined-bmv | 104 | 1 | 217.8 | 284,541 / 4,116 | 3/4 |
| support-enumeration | 13 | 0 | 559.3 | — | — |
| thomson-10 | 25 | 0 | 13.4 | — | — |
| thomson-11 | 25 | 0 | 8.3 | — | — |
| thomson-13 | 25 | 0 | 12.3 | — | — |
| thomson-14 | 25 | 0 | 12.2 | — | — |
| werner-endpoint | 201 | 0 | 238.4 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T21:44:16.027+00:00](method-runs/e5ac5367f68c45c995d8d629c34c9db4.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T21:44:14.380+00:00](method-runs/e30f8be22bc247fe9e9a8c633a7b0115.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T21:44:13.358+00:00](method-runs/64ea70f11f754b6297e6813f9a378b0f.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T21:44:13.080+00:00](method-runs/6f83e68779674b08bf4901bbddb191a9.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T21:44:08.025+00:00](method-runs/4e9448efcfe9473483214602d1976fe7.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T21:44:05.967+00:00](method-runs/b75030c07a174d46bd28b662551e3838.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T21:44:04.564+00:00](method-runs/1a647efbab024b69b0f0756bb8b93758.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T21:43:49.236+00:00](method-runs/a28415534f814b69bfb2f5675ba18ef1.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.5 | — |
| [2026-11-27T21:43:49.042+00:00](method-runs/c4c0d467da8c4cf4ac8b0a3bbcaf63c1.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T21:43:48.882+00:00](method-runs/8ca90ac2dae24db4b5ca5bb5acbea0ca.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T21:43:48.659+00:00](method-runs/046815a57f684f2eadb220c79af46167.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T21:43:48.106+00:00](method-runs/29d5dea7f6334dadb1baba363b03b496.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-27T21:33:10.164+00:00](method-runs/04f77aeb3a4d42bba0d457cb0a2fab52.json) | lts-oeis-a284230 | scout | source-screen-and-notebook | gpt-6.2-sol / low | failed / RuntimeError | 19.7 | — |
| [2026-11-27T21:31:48.250+00:00](method-runs/afbb702369274319ae7e40b9f8f5f689.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 78.6 | — |
| [2026-11-27T21:31:47.785+00:00](method-runs/d9930a6ab58e497e8966daff7dc6cfa0.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T21:31:42.738+00:00](method-runs/b31ed4ac254d404f8e894e8768458894.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 3.6 | — |
| [2026-11-27T21:31:38.843+00:00](method-runs/4c8bd93c817a42fea3e0c862b2830910.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 4.0 | — |
| [2026-11-27T21:31:35.255+00:00](method-runs/7a560564d6ce416f94d0d18ca9570d25.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T21:31:33.213+00:00](method-runs/14b713dbce354af9a3a23bae852494ef.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T21:31:31.817+00:00](method-runs/3e3ff4b69f26456fb9409c48c99d809e.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T21:31:17.219+00:00](method-runs/396cc1a232b14e4aa3fecfb2a038202f.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T21:31:17.030+00:00](method-runs/4e394de1d5834b9d9dea4cd3453a2c73.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T21:31:16.876+00:00](method-runs/c6579cdb008c458999cbeffeb1c7f760.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T21:31:16.661+00:00](method-runs/002cbdcce09a4ff98363ed8803628a7c.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T21:31:16.110+00:00](method-runs/7406bba1c68b414097ed5185da0affce.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-27T21:20:53.965+00:00](method-runs/997d40342e364f25873cf766cbc6b291.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T21:20:52.354+00:00](method-runs/7f9b5810e0c4497ca06dc62f061b4ae6.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T21:20:51.355+00:00](method-runs/3c606f24bf59404ca334121c7dd5d71a.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T21:20:51.082+00:00](method-runs/3ad722b6062a4815a8e5a8a978f53d18.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T21:20:45.988+00:00](method-runs/2fb280ba274f48fb935b75783813b7db.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T21:20:43.767+00:00](method-runs/3bd42338e301488db76925d7895bc715.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T21:20:42.358+00:00](method-runs/54a667c8ed95431c92f2e92a0f9bb466.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T21:20:26.251+00:00](method-runs/507eaeb7fd8644c3adfac60ed616c9bc.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T21:20:26.053+00:00](method-runs/46c3d962cdce4c0fa0b365ffb457ba30.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T21:20:25.896+00:00](method-runs/df207247121241ca88fa30e21f2463be.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T21:20:25.672+00:00](method-runs/587ddc89b178403d8e6553215973ae8d.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T21:20:25.051+00:00](method-runs/f57641c2b8cf4977a96dd342eff23acf.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.7 | — |
| [2026-11-27T21:10:02.275+00:00](method-runs/ed4d878496ef40a9b8f4fef90c4af527.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T21:10:00.618+00:00](method-runs/b8b93d0a5a32455abef55dfecabd1c6e.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T21:09:59.644+00:00](method-runs/230c7d2872834189a395a43d2fa1dcc2.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
