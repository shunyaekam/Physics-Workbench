# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 120 | 0 | 101.5 | — | — |
| e27-schmidt | 120 | 0 | 136.7 | — | — |
| gagatsos-2026-c1 | 451 | 0 | 1,363.6 | — | — |
| golay43 | 241 | 93 | 634.1 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 4 | 4 | 517.2 | — | 0/3 |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1165.erdos_1165.R1.H1 | 1 | 0 | 146.0 | 975,341 / 4,634 | 1/1 |
| lts-Erdos1165.erdos_1165.R1.H2 | 1 | 0 | 143.0 | 842,263 / 4,374 | 1/1 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 2 | 0 | 338.0 | 996,404 / 10,876 | 2/2 |
| lts-oeis-a284230 | 2 | 1 | 111.1 | 185,342 / 2,527 | 1/2 |
| refined-bmv | 126 | 2 | 306.6 | 446,095 / 6,119 | 4/6 |
| support-enumeration | 15 | 0 | 634.2 | — | — |
| thomson-10 | 30 | 0 | 16.1 | — | — |
| thomson-11 | 30 | 0 | 9.3 | — | — |
| thomson-13 | 30 | 0 | 14.0 | — | — |
| thomson-14 | 30 | 0 | 15.0 | — | — |
| werner-endpoint | 241 | 0 | 278.9 | 67,096 / 624 | 1/1 |

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
| [2026-11-28T01:15:13.926+00:00](method-runs/be1b49f2ec9a4945908087bc32b14da1.json) | thomson-11 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-28T01:15:05.946+00:00](method-runs/c9bc43833dcf42fa9a6af94c7ae3f0a9.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-28T01:15:05.392+00:00](method-runs/6b2a199b07fe4083823ba911caae6f5b.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-28T01:15:05.165+00:00](method-runs/bb785318ac93468f845e14b4ebede9a8.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.4 | — |
| [2026-11-28T01:15:01.166+00:00](method-runs/22eaf67ed3734c63b8415ece86ad790b.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-28T01:14:59.769+00:00](method-runs/77b6cbad59f84427ab1f236fe2766bea.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.4 | — |
| [2026-11-28T01:14:58.771+00:00](method-runs/57a658318c9f49c590be92ca598c96cd.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.0 | — |
| [2026-11-28T01:14:45.772+00:00](method-runs/41883ecb365144d995ccabea1a6ee128.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.6 | — |
| [2026-11-28T01:14:45.474+00:00](method-runs/029e9a1bfe9c452683c04bae475821fc.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T01:14:26.404+00:00](method-runs/793c6e2392864a9ca52dac3fd1502d33.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 19.1 | — |
| [2026-11-28T01:14:26.197+00:00](method-runs/b606ddb9d6424276888d3ac066657730.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T01:14:25.639+00:00](method-runs/42cc1d4ff332465a8fe81511c3436a08.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.6 | — |
| [2026-11-28T01:13:27.600+00:00](method-runs/10a633d603714c66a5ac7d96efb28bd5.json) | thomson-14 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.6 | — |
| [2026-11-28T01:13:21.359+00:00](method-runs/e57d19176f6743219f12cbb67e6fd701.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 2.1 | — |
| [2026-11-28T01:13:19.027+00:00](method-runs/21bd74e77f3f426586565e54ad5ffe14.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 2.4 | — |
| [2026-11-28T01:13:15.844+00:00](method-runs/6493c7951a934680ad1932fa43a0d5b0.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 2.0 | — |
| [2026-11-28T01:13:14.087+00:00](method-runs/d0191f9167c14c028d9ac0439eacb1ea.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.7 | — |
| [2026-11-28T01:13:12.870+00:00](method-runs/b79bab0e734d4bcb97f37f6378f2768e.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 1.2 | — |
| [2026-11-28T01:12:59.316+00:00](method-runs/6d90bc8ada7949c7a4779b24f6b889a9.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 2.0 | — |
| [2026-11-28T01:12:59.092+00:00](method-runs/b7523fe5ef6d4e13be0ee9ade04dd657.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-28T01:12:22.499+00:00](method-runs/8762e5a1bda9433a8807b3b1a05962bb.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 36.6 | — |
| [2026-11-28T01:12:22.127+00:00](method-runs/3596f5ac009c406fb627410b99f683b5.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T01:12:20.442+00:00](method-runs/1a3203cbefb343b7b054176105becdb0.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 1.8 | — |
| [2026-11-28T01:01:51.063+00:00](method-runs/6415c0f187714ffeb4d5300e828c0bda.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-28T01:01:49.703+00:00](method-runs/5ac42f9d10aa42aaa9c8dd5b6e487de9.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-28T01:01:48.876+00:00](method-runs/44c2416d6e1a4eea8f52e91276192ad4.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.8 | — |
| [2026-11-28T01:01:48.437+00:00](method-runs/31c8bf3b3e7b4c75b2c3887828f9acdc.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.6 | — |
| [2026-11-28T01:01:44.106+00:00](method-runs/b90edcb484d84a23ac085e47cf88e81b.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.3 | — |
| [2026-11-28T01:01:42.866+00:00](method-runs/db4db0b27e2146b0aa5ca2102b9169ac.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.2 | — |
| [2026-11-28T01:01:36.082+00:00](method-runs/977ac9dad0fb454aa6327d6cdea1bcf2.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 6.8 | — |
| [2026-11-28T01:01:22.489+00:00](method-runs/c4341dfc1263484da67fd3daa9299fa2.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T01:01:22.360+00:00](method-runs/b3e408ef8ae44a45ac847f83a40db11b.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-28T01:01:01.607+00:00](method-runs/710becd487f8485f958d59ed4974da5f.json) | golay43 | search | checks/golay/advance.py | — | completed / search_receipt | 20.8 | — |
| [2026-11-28T01:01:01.340+00:00](method-runs/387c43a1dfa14bfa91b14972294d123b.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-28T01:00:59.181+00:00](method-runs/f914e5a1cc4141aca6773a8cd579d991.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 2.2 | — |
| [2026-11-28T00:57:44.734+00:00](method-runs/60b116e8d4924c20b1a53a72c0aa3c05.json) | lts-oeis-a284230 | scout | source-screen-and-notebook | gpt-6.2-sol / low | completed / shortlist | 91.3 | 185,342 / 2,527 |
| [2026-11-28T00:57:39.594+00:00](method-runs/38fef1b24fdd47f69d954a5ec31a4ba8.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.3 | — |
| [2026-11-28T00:57:38.048+00:00](method-runs/ba7eb4448c7a46d5829e2cdfdd7de61d.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-28T00:57:37.494+00:00](method-runs/d64361bf9af24146a2f6ab0b6b4f38e5.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-28T00:57:37.299+00:00](method-runs/3f856a33218d42aebff72c468c893b51.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.3 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
