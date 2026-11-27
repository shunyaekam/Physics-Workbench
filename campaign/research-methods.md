# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 38 | 0 | 25.2 | — | — |
| e27-schmidt | 38 | 0 | 40.9 | — | — |
| gagatsos-2026-c1 | 144 | 0 | 257.0 | — | — |
| golay43 | 77 | 14 | 438.7 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| refined-bmv | 39 | 0 | 51.7 | 69,669 / 997 | 1/1 |
| support-enumeration | 5 | 0 | 167.6 | — | — |
| thomson-10 | 10 | 0 | 4.7 | — | — |
| thomson-11 | 9 | 0 | 2.5 | — | — |
| thomson-13 | 10 | 0 | 4.3 | — | — |
| thomson-14 | 9 | 0 | 4.5 | — | — |
| werner-endpoint | 77 | 0 | 101.6 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T09:08:48.364+00:00](method-runs/7d25f9737afd4d65991736c767b70ead.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T09:08:46.346+00:00](method-runs/f6187d7015e24e979b1c2130f38532f3.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.1 | — |
| [2026-11-27T09:08:44.882+00:00](method-runs/1f5680f1a7d4469bb96dcf9647b2337f.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.5 | — |
| [2026-11-27T09:08:44.626+00:00](method-runs/d862b83e9a0e444785c32195c8339ff4.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T09:08:39.699+00:00](method-runs/e54825b145184a619463fe38a48dd851.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.6 | — |
| [2026-11-27T09:08:38.369+00:00](method-runs/180fcea055f04bcc8995f4618d8b743a.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-27T09:08:37.556+00:00](method-runs/84b2af000c04401dac08e22378b17daa.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.8 | — |
| [2026-11-27T09:08:22.697+00:00](method-runs/a3af5444b2bb4be3bb89f0ba3b28845b.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T09:08:22.550+00:00](method-runs/318ef96f641f4b119a880c4c7571e6c3.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T09:08:22.394+00:00](method-runs/d53b8acbe99b4e15bfa3b7f9cc9eb6d0.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.2 | — |
| [2026-11-27T09:08:22.221+00:00](method-runs/87b30ff65ad846e79465976cec0e2278.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T09:08:21.814+00:00](method-runs/f4a4a1a2c7b1412a985eebe4db4ee04f.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T08:57:49.842+00:00](method-runs/2536907ef0cc41ea940e05b16b3c6d7a.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T08:57:48.708+00:00](method-runs/291356ba64834f55a8798477a41d6d9d.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T08:57:48.179+00:00](method-runs/6c114ae8c4744d7c94f6ca5af23e939b.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T08:57:48.008+00:00](method-runs/a97eb3edf0754887a38dbd2ec02a62d9.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T08:57:42.410+00:00](method-runs/7027210069cb4aeeabd9aa4bf4d596a4.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-27T08:57:40.552+00:00](method-runs/863c8f6e6c8b4fb3aa460ecf0db2bd17.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.8 | — |
| [2026-11-27T08:57:38.717+00:00](method-runs/da1bd9d6c1624906a385aaf3a11283cd.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.8 | — |
| [2026-11-27T08:57:26.855+00:00](method-runs/b08ff94cf9d64a79ac3a8aff8f532a03.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T08:57:26.721+00:00](method-runs/270afc2783014b74b43d4106a498bedf.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T08:57:26.576+00:00](method-runs/b414b208b8584a8bb9e43b6cbb1b0a54.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T08:57:26.405+00:00](method-runs/877498e2c5ec4dd5bcfc663929a8cc0c.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T08:57:25.987+00:00](method-runs/2c31edd54bf94eafa7ceefb03e199f8b.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.5 | — |
| [2026-11-27T08:46:08.559+00:00](method-runs/3b7629247ec4489dac6f9353e757e7f1.json) | lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | scout | source-screen-and-notebook | gpt-6.2-sol / low | timeout / TimeoutExpired | 15.6 | — |
| [2026-11-27T08:45:33.450+00:00](method-runs/d609edfcff5e4a209ea9ff271f3a8ecf.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-27T08:45:31.902+00:00](method-runs/b5e5b75533b24589b8e638c1fb84da52.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T08:45:30.916+00:00](method-runs/62d93fd15f9d46358c69397b5f868d66.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 1.0 | — |
| [2026-11-27T08:45:30.597+00:00](method-runs/8f9914e4a41045caa7f3c90ecea13559.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T08:45:25.494+00:00](method-runs/5d3c83dfbe714b3f8014194f9e91a823.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.8 | — |
| [2026-11-27T08:45:23.476+00:00](method-runs/3509eb014f7b49e7a568d93ad25d29c8.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-27T08:45:22.660+00:00](method-runs/707c848a76b0420784a435bbd050f1d6.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.8 | — |
| [2026-11-27T08:45:08.305+00:00](method-runs/4c56bfca2cb04ae2a314e6f8ec19a0f5.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T08:45:08.169+00:00](method-runs/e137c187f9004fd994ad26f9f8a70d43.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T08:45:08.034+00:00](method-runs/6604888544ee49bca2381dd490bafdd0.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T08:45:07.865+00:00](method-runs/5d1af26a535c42d3b7cb239e7e07ccc7.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T08:45:07.461+00:00](method-runs/416eb4ddf4974696b7ce2f24da3d0160.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T08:34:17.278+00:00](method-runs/77dc5f83ebd64dba96740566e77e0fbe.json) | werner-endpoint | math_review | independent-challenge | gpt-6.2-sol / low | completed / park | 26.4 | 67,096 / 624 |
| [2026-11-27T08:33:05.310+00:00](method-runs/717a61820ca6458984568602522b8792.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 43.6 | — |
| [2026-11-27T08:33:05.019+00:00](method-runs/26f79797946c409489d6d803bacd47f5.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
