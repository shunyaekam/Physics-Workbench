# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 30 | 0 | 22.5 | — | — |
| e27-schmidt | 30 | 0 | 37.8 | — | — |
| gagatsos-2026-c1 | 114 | 0 | 220.9 | — | — |
| golay43 | 61 | 6 | 436.7 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| refined-bmv | 31 | 0 | 50.7 | 69,669 / 997 | 1/1 |
| support-enumeration | 4 | 0 | 124.0 | — | — |
| thomson-10 | 8 | 0 | 2.3 | — | — |
| thomson-11 | 7 | 0 | 2.0 | — | — |
| thomson-13 | 8 | 0 | 3.8 | — | — |
| thomson-14 | 7 | 0 | 3.2 | — | — |
| werner-endpoint | 60 | 0 | 59.8 | — | — |

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
| [2026-11-27T07:36:56.407+00:00](method-runs/a56a6d4675074fb3982b60233d4e192b.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.4 | — |
| [2026-11-27T07:36:55.162+00:00](method-runs/4147949cd526406c81ef5e5b4366fc37.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.7 | — |
| [2026-11-27T07:36:54.329+00:00](method-runs/9473f3ddca204f8096bdaf994ef654fa.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.8 | — |
| [2026-11-27T07:36:54.116+00:00](method-runs/c08ff478ae8d46a093dc54dab1cf8e13.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T07:36:50.510+00:00](method-runs/b0971037a8914d7d94e84becb53682bb.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-27T07:36:49.466+00:00](method-runs/3972d704bba445f98e9d1e54467358c3.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.0 | — |
| [2026-11-27T07:36:48.761+00:00](method-runs/47502dca039a418c955e6b1ec249ee68.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 0.7 | — |
| [2026-11-27T07:36:38.260+00:00](method-runs/97fafba3e06444279247508ce4a6fb6c.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T07:36:38.163+00:00](method-runs/4d592a9d0b264327a9896794955584b0.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T07:36:38.052+00:00](method-runs/b01825fc9e83491991d5610e54b797f5.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T07:36:37.936+00:00](method-runs/1bc8d154f93e4046b5de9db564d70e1e.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T07:36:37.646+00:00](method-runs/aa2c1477913047ba8d7c0c6d67ba5353.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T07:22:19.417+00:00](method-runs/79cafe0d8fe547afa5906ce966aef085.json) | lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | scout | pinned-lean-repair | gpt-6.2-sol / low | timeout / TimeoutError | 240.3 | — |
| [2026-11-27T07:22:17.374+00:00](method-runs/19ed4721ddf14fb0bb7bcfefd0b50a2d.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.2 | — |
| [2026-11-27T07:22:16.349+00:00](method-runs/b5e4050c7b664a50b8ed748f9395d0d8.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T07:22:15.606+00:00](method-runs/48f0103385914d2dae9fb6c4ffa21dba.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.7 | — |
| [2026-11-27T07:22:15.329+00:00](method-runs/0e598b2a14e54c019f5367072bc6b62b.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |
| [2026-11-27T07:22:10.738+00:00](method-runs/6d932eec3a784b4e96810a3bcf0a6c7b.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.8 | — |
| [2026-11-27T07:22:09.142+00:00](method-runs/08afec4bc7e3462bb62d552fbabe9621.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.6 | — |
| [2026-11-27T07:22:07.983+00:00](method-runs/c2fd15276e50401b945243701e4baa23.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.1 | — |
| [2026-11-27T07:21:59.128+00:00](method-runs/ab3116311491409580100a17c23c4442.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T07:21:58.957+00:00](method-runs/cdef991c8c2542df9bf3c706b7d8e607.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T07:21:58.179+00:00](method-runs/def8fa3100c84be19b9e03dcf0965b6b.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.8 | — |
| [2026-11-27T07:21:58.058+00:00](method-runs/aa65314241f1471383da9ab485d45863.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T07:21:57.772+00:00](method-runs/f6bfe3edc5a8483faff154244d571f4a.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T07:11:14.147+00:00](method-runs/a48f094f43ed475d8070645d86430499.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.5 | — |
| [2026-11-27T07:11:12.726+00:00](method-runs/390413f5d7f447ddab6feb9abd49946f.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T07:11:12.304+00:00](method-runs/1b79b9dfee4b4f9f94ab7b2e616f00e0.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T07:11:12.167+00:00](method-runs/ed19d962683847cf81952f542b8183fa.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T07:11:09.328+00:00](method-runs/fc235be74fd84229b24a1fa28cc55f6b.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-27T07:10:58.751+00:00](method-runs/361c0dcc25b64faabfc69376fb9a31ba.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 10.6 | — |
| [2026-11-27T07:10:29.682+00:00](method-runs/5ccdef5fa1d343ae810adaf6367d64e5.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 29.1 | — |
| [2026-11-27T07:10:16.547+00:00](method-runs/9382809845a948c98e44bf60e5e109f3.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T07:10:16.440+00:00](method-runs/11a39fb95ff74d729f07f4e0127bba82.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T07:10:16.329+00:00](method-runs/be05b6aae92d4baaa87b6c519a196c8f.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T07:10:16.206+00:00](method-runs/3afaf7a87440486a8ad17a9a02d472db.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T07:10:15.915+00:00](method-runs/43f19117e9684316bf73d20c0495861d.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.3 | — |
| [2026-11-27T06:58:41.724+00:00](method-runs/76e0e1fe11a749afaf56371a01588efb.json) | support-enumeration | search | continuous.advance_frontier | — | completed / search_receipt | 41.1 | — |
| [2026-11-27T06:58:39.930+00:00](method-runs/ad1384b681a64c0eb76e90543430510e.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 1.8 | — |
| [2026-11-27T06:58:21.531+00:00](method-runs/588fe23dc80540c683f633c02ce4d55e.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 1.6 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
