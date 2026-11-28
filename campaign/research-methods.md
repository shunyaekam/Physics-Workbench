# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 130 | 0 | 104.5 | — | — |
| e27-schmidt | 130 | 0 | 141.3 | — | — |
| gagatsos-2026-c1 | 489 | 0 | 1,409.5 | — | — |
| golay43 | 261 | 93 | 742.8 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| lts-oeis-a284230 | 2 | 1 | 111.1 | 185,342 / 2,527 | 1/2 |
| oqp:A13 | 1 | 0 | 57.6 | 198,280 / 1,837 | 1/1 |
| refined-bmv | 137 | 3 | 327.4 | 446,095 / 6,119 | 4/7 |
| support-enumeration | 16 | 0 | 655.0 | — | — |
| thomson-10 | 33 | 0 | 16.8 | — | — |
| thomson-11 | 32 | 0 | 9.9 | — | — |
| thomson-13 | 33 | 0 | 14.9 | — | — |
| thomson-14 | 32 | 0 | 15.7 | — | — |
| werner-endpoint | 261 | 0 | 300.3 | 67,096 / 624 | 1/1 |

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
| [2026-11-28T03:06:09.367+00:00](method-runs/3492a933b5ae4f6c977284414d6f3182.json) | oqp:A13 | scout | source-screen | gpt-6.2-sol / low | completed / shortlist | 57.6 | 198,280 / 1,837 |
| [2026-11-28T03:04:23.650+00:00](method-runs/d89efe3f5e2348f69c484c4554747743.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-28T03:04:21.415+00:00](method-runs/227b43575ccc4b7f848f6025a553d1a2.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-28T03:04:20.566+00:00](method-runs/d523e47e95a94a22ba9fe707a9452e68.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.8 | — |
| [2026-11-28T03:04:20.410+00:00](method-runs/d785c8c83f094f0f83ba551538874e35.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-28T03:04:17.436+00:00](method-runs/ff755db80c8c44dc85d0e2f088ac237a.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-28T03:04:16.328+00:00](method-runs/3e3f25a5cf53466ea4cf3f2fe3a03ddc.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.1 | — |
| [2026-11-28T03:04:15.355+00:00](method-runs/9ccb91fe19544aa6b2899e2fcda7fe52.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.0 | — |
| [2026-11-28T03:04:04.328+00:00](method-runs/0d285d7bcb24402399d503e26155efa3.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T03:04:04.193+00:00](method-runs/055b55722f244e089b9261b2e09987f4.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T03:03:52.418+00:00](method-runs/7ec414742c6c4dce805b7a210a06231b.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 11.8 | — |
| [2026-11-28T03:03:52.291+00:00](method-runs/44ecf9b6010a4f3b90936bc9d8ddd143.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T03:03:51.911+00:00](method-runs/4c71fe92f6524a0d9f7a5c07098cf87e.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-28T02:53:30.139+00:00](method-runs/23319a50ec384e168291b03d88223e62.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-28T02:53:28.633+00:00](method-runs/0a95c13235964e17b47b4dd21bcaa00b.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-28T02:53:27.706+00:00](method-runs/73043d6c36804c3c870507866205773c.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-28T02:53:27.436+00:00](method-runs/3bcc0c473a2f41319333b942df28b560.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-28T02:53:22.401+00:00](method-runs/d3162994e8fc493d888eeb2f1392035a.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-28T02:53:20.393+00:00](method-runs/26993ab6d77940a484ba8b698adb7b9c.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-28T02:53:19.222+00:00](method-runs/c52c78e5bd2b47c1a874b351bcd29af0.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.2 | — |
| [2026-11-28T02:53:05.478+00:00](method-runs/0157c55d1fc040ee9bee0f92ae375267.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-28T02:53:05.280+00:00](method-runs/74424bdd3050485f995c703d41ba6e4d.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T02:52:50.990+00:00](method-runs/4abcd21baef14e4b98cd045b5d91f301.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 14.3 | — |
| [2026-11-28T02:52:50.774+00:00](method-runs/c480e5849820484a8d47b99ca22c173d.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T02:52:50.206+00:00](method-runs/9556ef86ab234d81ac483c91d96e4d51.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
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

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
