# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 24 | 0 | 19.1 | — | — |
| e27-schmidt | 24 | 0 | 25.1 | — | — |
| gagatsos-2026-c1 | 91 | 0 | 152.7 | — | — |
| golay43 | 49 | 0 | 421.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 2 | 0 | 249.3 | 878,620 / 8,904 | 2/2 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| refined-bmv | 25 | 0 | 49.8 | 69,669 / 997 | 1/1 |
| support-enumeration | 3 | 0 | 83.0 | — | — |
| thomson-10 | 6 | 0 | 1.8 | — | — |
| thomson-11 | 6 | 0 | 1.6 | — | — |
| thomson-13 | 6 | 0 | 3.3 | — | — |
| thomson-14 | 6 | 0 | 1.4 | — | — |
| werner-endpoint | 48 | 0 | 50.9 | — | — |

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
| [2026-11-27T06:20:01.012+00:00](method-runs/af85240f51794be7a9ec188d917baa37.json) | lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | scout | continue-scored-lemma | gpt-6.2-sol / low | completed / insufficient_evidence | 142.8 | 485,808 / 5,514 |
| [2026-11-27T06:19:58.601+00:00](method-runs/0d8fd0ca372c488f8415a6ffaa618b66.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T06:19:57.010+00:00](method-runs/c5e6ba16e436456a8fbe948c42fe2d04.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.7 | — |
| [2026-11-27T06:19:56.290+00:00](method-runs/00a2ca5bbf614584b593eb4500a19752.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.7 | — |
| [2026-11-27T06:19:56.074+00:00](method-runs/441537040b2940cab88bf4fb7f5247ee.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T06:19:51.090+00:00](method-runs/cb397cc895754168b6c8ff6680dc1c0f.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.3 | — |
| [2026-11-27T06:19:49.813+00:00](method-runs/e99f85c90e684b44833db074857541c6.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-27T06:19:48.785+00:00](method-runs/7b93354fb0484e8a91cd922158d7ea9b.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.0 | — |
| [2026-11-27T06:19:36.737+00:00](method-runs/f882647d4bf6427ca5f4d2ce9a60816f.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.6 | — |
| [2026-11-27T06:19:36.581+00:00](method-runs/172c4291aa3246c6890b8c3aba335db7.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T06:18:34.403+00:00](method-runs/b8a7e600d24345c9ae72e5012433e1a7.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 62.2 | — |
| [2026-11-27T06:18:30.586+00:00](method-runs/66b3ade3837d4926a69f95cd14668634.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 3.8 | — |
| [2026-11-27T06:18:24.400+00:00](method-runs/e05e00f2e5634e88936b8c86435c68a3.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 6.7 | — |
| [2026-11-27T06:08:00.004+00:00](method-runs/ce5efbc4fb5d40f49620e5ddf948f649.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T06:07:54.935+00:00](method-runs/0f74e7594aa1499d88900e6ffeaa15ab.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 3.5 | — |
| [2026-11-27T06:07:51.825+00:00](method-runs/0d24a981ee8b4b8bbacdc9cf282d2346.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 3.2 | — |
| [2026-11-27T06:07:47.717+00:00](method-runs/4751cef3c1384086b03798614b90f58d.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.8 | — |
| [2026-11-27T06:07:46.185+00:00](method-runs/223a4f4555d94838bb8a791309fcd738.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T06:07:44.734+00:00](method-runs/47fed1327b994b168f9cd9fcc37f0df9.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.4 | — |
| [2026-11-27T06:07:11.805+00:00](method-runs/c5f95c830dcf4506a26cadcebd10e996.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T06:07:11.615+00:00](method-runs/da0aa5ee35b4462c911017975ef6550c.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T06:06:31.887+00:00](method-runs/59bf5bc871794c6da1759fe7629a9260.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 39.7 | — |
| [2026-11-27T06:06:31.671+00:00](method-runs/70ae173025e64a4cb8ec4ba150191029.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T06:06:29.994+00:00](method-runs/9ee9683dc50d41a8aa6c96bc2f83dfcf.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 1.8 | — |
| [2026-11-27T05:55:44.284+00:00](method-runs/fe51ebf364ef4b6f80361cf8f99b3e11.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T05:55:42.777+00:00](method-runs/412b42e3672042d5bfdef6975220a4e1.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.8 | — |
| [2026-11-27T05:55:41.926+00:00](method-runs/d729ded429b04cb4802b171b51a06f5d.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T05:55:41.668+00:00](method-runs/4d9640b30fc947458ea53dac6214030b.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T05:55:38.581+00:00](method-runs/5e64bc5359f54e0bb9aee98e5c3d659a.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-27T05:55:37.326+00:00](method-runs/79dda15aed1c4cbf8b0fd2b013754008.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-27T05:55:26.675+00:00](method-runs/d924c09d90c34b4dba9b8d4a5f88243b.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 10.6 | — |
| [2026-11-27T05:55:02.271+00:00](method-runs/f05c6a9b5a464f61a18bd49bbe93bd98.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 9.9 | — |
| [2026-11-27T05:55:00.100+00:00](method-runs/d996490e45924db2a2d9458885b407cc.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 2.2 | — |
| [2026-11-27T05:54:24.586+00:00](method-runs/44fe67f80bcd4aeb851bf6ad9c4f770d.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 35.5 | — |
| [2026-11-27T05:54:24.457+00:00](method-runs/b1be229029b34e1485a470e95083d20f.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T05:54:24.161+00:00](method-runs/8f904abcb8554f87984cd7dc31db98a8.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T05:44:03.947+00:00](method-runs/ba851a46e7d54c87be168de423711f3d.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T05:44:02.747+00:00](method-runs/4cede27e396c4d46ab2a40c94c7e7090.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T05:44:02.300+00:00](method-runs/77bea1379fea4ace979b4de1db0e2db2.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T05:44:02.166+00:00](method-runs/da8f36e4674640519e1ae45aa433ed88.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
