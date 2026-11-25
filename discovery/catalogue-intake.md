# Where the open questions come from

We screen externally maintained problem catalogues, trace a question to its first-party statement, and look for later results using its name and exact parameters. A listing is a lead. Admission requires a check that would answer the sourced question and a concrete route to running it.

| Catalogue screened | What we used |
|---|---|
| [Open Quantum Problems](https://github.com/jpbruneton/open_quantum_problems/tree/31d6133) | Entries with a precise settlement criterion, primary evidence and related questions. A50 is active. E27 is the next lead after the two new active searches. |
| [Physics Open Problems](https://github.com/jgmcm/problems/tree/6eea351) | Found finite-certificate entries, then read the hypotheses. Entry 035 also needs a rigorous infinite-volume and zero-temperature error bound. It ranks below finite witness searches despite its 2/5 catalogue rating. |
| [AIM](https://github.com/MColbrook/AIM/tree/b2ec0fa) | Cross-disciplinary catalogue with a many-body and quantum-information section and linked resolution records. It overlaps our existing NPT problem. |

The first active pick is A50’s 43-gate Golay challenge. It has a clear use in quantum error correction, an explicit 44-gate starting circuit, and a fast exact state check. Second is the quantum transport polygon problem. The q>1 branch has an exact finite witness test, a source that publishes baseline calculations, and an explicit question spanning every number of levels. Third is the sorted Schmidt-basis conjecture. This ordering estimates how cheaply the first decisive evidence could be obtained. It assigns no probability of success. [Primary transport source](https://evidencepress.org/releases/quantum-transport-cost-cones/) · [Next lead](ranked-sources.json)

Two stale-status examples explain why the date and the exact version matter. Catalogue C14 still calls finite-order cost-cone monotonicity open. A later public manuscript gives a proof and explicitly poses a new polygon conjecture. We pursue the latter. The 21-cycle uniform-mixing case also has a public claim and a linked Lean source. We parked that candidate pending inspection of the full hypotheses. Neither earns discovery credit here. [C14](https://openquantumproblems.com/p/C14) · [Cost-cone manuscript](https://evidencepress.org/releases/quantum-transport-cost-cones/) · [21-cycle claim](https://www.trureturing.org/knowledge/node/a623064605b1c3a10597081a1100e71ec5d0697680aca282f56561f7f405da0b/)

The worker records the current revisions of all three catalogues once a week. After the first week the records link directly to changes since the previous scan. A changed catalogue triggers source review before admission. [Version history](../campaign/catalogue-scans) · [Watcher](../ops/catalogue_watch.py)
