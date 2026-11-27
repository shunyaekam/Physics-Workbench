# Research methods

Elapsed seconds sum the measured duration of recorded jobs. Input tokens include cached input. Token coverage counts hosted jobs with complete usage divided by hosted jobs observed. The ledger covers the scheduled worker. Interactive sessions and work before instrumentation have unknown cost.

| Problem | Runs | Failed or timed out | Job seconds | Input / output tokens | Token coverage |
|---|---:|---:|---:|---:|---:|
| bernasconi-table2 | 56 | 0 | 44.8 | — | — |
| e27-schmidt | 56 | 0 | 66.7 | — | — |
| gagatsos-2026-c1 | 211 | 0 | 509.3 | — | — |
| golay43 | 113 | 32 | 488.8 | — | — |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_charges.R1.H1 | 1 | 0 | 88.7 | 337,260 / 3,220 | 1/1 |
| lts-Arxiv.2607.27197.maxwell_conjecture.variants.three_equal_magnitudes | 1 | 1 | 15.6 | — | — |
| lts-Erdos1164.erdos_1164.R1.H2.R1.H1 | 3 | 1 | 489.7 | 878,620 / 8,904 | 2/3 |
| lts-Erdos1166.erdos_1166.variants.dembo_peres_rosen_zeitouni.R1.H2 | 1 | 0 | 91.9 | 494,151 / 3,149 | 1/1 |
| lts-OpenQuantumProblem23.hasSICPOVM_68.R1.H1 | 1 | 0 | 190.8 | 797,530 / 5,583 | 1/1 |
| refined-bmv | 58 | 0 | 126.7 | 226,762 / 2,761 | 2/2 |
| support-enumeration | 7 | 0 | 228.0 | — | — |
| thomson-10 | 14 | 0 | 7.4 | — | — |
| thomson-11 | 14 | 0 | 5.1 | — | — |
| thomson-13 | 14 | 0 | 7.6 | — | — |
| thomson-14 | 14 | 0 | 6.3 | — | — |
| werner-endpoint | 113 | 0 | 136.1 | 67,096 / 624 | 1/1 |

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
| [2026-11-27T12:33:07.846+00:00](method-runs/c0844819e0774e37a566084c7d0a3504.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 10.7 | — |
| [2026-11-27T12:32:52.517+00:00](method-runs/fa8c0017a68c428fb92bf9ec14b16750.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 15.3 | — |
| [2026-11-27T12:32:35.461+00:00](method-runs/ec67b39e130c4b5d9cf640812c8cbe26.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 17.0 | — |
| [2026-11-27T12:31:37.964+00:00](method-runs/8d1293c39b8b4b629887e487828f70ac.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 2.2 | — |
| [2026-11-27T12:31:37.555+00:00](method-runs/a63aae78c72a4114a77a342b9e3f3be4.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.4 | — |
| [2026-11-27T12:31:34.289+00:00](method-runs/c593d713ebde479084555caf87050dda.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 3.2 | — |
| [2026-11-27T12:31:32.589+00:00](method-runs/c1069bbe0ad240a3a793f5739363e8d7.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 1.7 | — |
| [2026-11-27T12:31:30.612+00:00](method-runs/f83dac2472b348d9a01aa3c832a831e6.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 2.1 | — |
| [2026-11-27T12:19:47.803+00:00](method-runs/0cd6fb3e927645b39c0ce22d3d66a023.json) | thomson-10 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.1 | — |
| [2026-11-27T12:19:46.934+00:00](method-runs/029ccb3260f8455a837e04c844ad7862.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T12:19:46.523+00:00](method-runs/ced8578bab664053a5be8868b5470104.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.4 | — |
| [2026-11-27T12:19:46.389+00:00](method-runs/47c347a81adc41dc86293c97ec3e9bd2.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.2 | — |
| [2026-11-27T12:19:43.461+00:00](method-runs/90eed9a38614424688686e9a437bec8a.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 1.4 | — |
| [2026-11-27T12:19:42.003+00:00](method-runs/b0b4ebcb242d4c8f8ce202cd25d2a256.json) | gagatsos-2026-c1 | search | three_level_search.py | — | completed / search_receipt | 1.5 | — |
| [2026-11-27T12:19:33.131+00:00](method-runs/fdec3a543be64d0e98df96ccf2c9a296.json) | gagatsos-2026-c1 | search | excited_pairs.py | — | completed / no_new_receipt | 8.9 | — |
| [2026-11-27T12:19:22.594+00:00](method-runs/5302512bb0cc4019a6de65e4d4f185c7.json) | bernasconi-table2 | search | checks/finite_spins.py | — | completed / no_new_receipt | 0.3 | — |
| [2026-11-27T12:19:22.470+00:00](method-runs/7bb2859ea94a4790953fce09ab6bd3a3.json) | refined-bmv | search | checks/bmv_search.py | — | completed / no_new_receipt | 0.1 | — |
| [2026-11-27T12:19:22.336+00:00](method-runs/26a749507066418b82b3d972aad235ea.json) | golay43 | search | checks/golay/advance.py | — | failed / CalledProcessError | 0.1 | — |
| [2026-11-27T12:19:22.156+00:00](method-runs/ad73aa8166664d99b014a3e82018ef55.json) | golay43 | search | checks/golay43.py | — | completed / no_new_receipt | 0.2 | — |
| [2026-11-27T12:19:21.756+00:00](method-runs/c1439b285c5748a4a3f60eac81723c25.json) | e27-schmidt | search | checks/schmidt7/pair_search.py | — | completed / search_receipt | 0.4 | — |
| [2026-11-27T12:08:55.918+00:00](method-runs/135c08a86dc24c7a857023c7e54bfbce.json) | thomson-13 | search | sphere_bounds.experiment | — | completed / bound_checked | 0.7 | — |
| [2026-11-27T12:08:47.691+00:00](method-runs/21b1e955289441758bb9e5ca82e41665.json) | werner-endpoint | search | complex_search.search-5-copies | — | completed / bounded_result | 0.5 | — |
| [2026-11-27T12:08:47.057+00:00](method-runs/8f5bdcb15dd04a5380f57cd3d1a512e2.json) | werner-endpoint | search | complex_search.search-4-copies | — | completed / bounded_result | 0.6 | — |
| [2026-11-27T12:08:46.780+00:00](method-runs/0ef34caef55f445786de1429188055df.json) | gagatsos-2026-c1 | search | wigner_search.search | — | completed / bounded_result | 0.9 | — |
| [2026-11-27T12:08:09.152+00:00](method-runs/8d71c6e9718c4ce6b0231368a59cfd14.json) | gagatsos-2026-c1 | search | coherent_band_search.py | — | completed / search_receipt | 12.1 | — |

## Search policy experiments

Each Golay policy constructs 24 circuits, split between 12 development seeds and 12 fresh evaluation seeds. Both policies receive the same seeds and the same number of pivot choices. Two signed stabilizer checks validate every circuit. The challenger advances inside this experiment only if it saves at least one gate on average, wins more pairs than it loses, and matches or improves the best gate count on each split. The physical target is at most 43 CNOTs.

| Week | Tree depths compared | Best CNOTs | Next tree depth | Seconds | Model tokens |
|---|---|---:|---:|---:|---:|
| [2026-W48](method-trials/v1-2026-W48.json) | 23 vs 12 | 47 | 23 | 3.22 | 0 |
