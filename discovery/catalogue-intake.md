# Where the open questions come from

We screen externally maintained problem catalogues, trace a question to its first-party statement, and look for later results using its name and exact parameters. A listing is a lead. Admission requires a check that would answer the sourced question and a concrete route to running it.

| Catalogue screened | What we used |
|---|---|
| [Open Quantum Problems](https://github.com/jpbruneton/open_quantum_problems/tree/31d6133) | Entries with a precise settlement criterion, primary evidence and related questions. A50 is active. E27 is the next lead after the two new active searches. |
| [Physics Open Problems](https://github.com/jgmcm/problems/tree/6eea351) | Found finite-certificate entries, then read the hypotheses. Entry 035 also needs a rigorous infinite-volume and zero-temperature error bound. It ranks below finite witness searches despite its 2/5 catalogue rating. |
| [AIM](https://github.com/MColbrook/AIM/tree/b2ec0fa) | Cross-disciplinary catalogue with a many-body and quantum-information section and linked resolution records. It overlaps our existing NPT problem. |

At admission the first pick was A50’s 43-gate Golay challenge. It has a clear use in quantum error correction, an explicit 44-gate starting circuit, and a fast exact state check. Second is the quantum transport polygon problem. The q>1 branch has an exact finite witness test, a source that publishes baseline calculations, and an explicit question spanning every number of levels. Third is the sorted Schmidt-basis conjecture. This ordering estimates how cheaply the first decisive evidence could be obtained. It assigns no probability of success. [Primary transport source](https://evidencepress.org/releases/quantum-transport-cost-cones/) · [Next lead](ranked-sources.json)

Two stale-status examples explain why the date and the exact version matter. Catalogue C14 still calls finite-order cost-cone monotonicity open. A later public manuscript gives a proof and explicitly poses a new polygon conjecture. The project has since published its proof for this polygon question. The 21-cycle uniform-mixing case also has a public claim and a linked Lean source. We parked that candidate pending inspection of the full hypotheses. Neither earns discovery credit here. [C14](https://openquantumproblems.com/p/C14) · [Cost-cone manuscript](https://evidencepress.org/releases/quantum-transport-cost-cones/) · [21-cycle claim](https://www.trureturing.org/knowledge/node/a623064605b1c3a10597081a1100e71ec5d0697680aca282f56561f7f405da0b/)

The worker records the current revisions of all three catalogues once a week. After the first week the records link directly to changes since the previous scan. A changed catalogue triggers source review before admission. [Version history](../campaign/catalogue-scans) · [Watcher](../ops/catalogue_watch.py)

The next intake revisits the lower bound of Vienna problem 40. One proof archive already covers all first-factor degrees with three second factors and three spectral values. A restricted search for small word counts missed this theorem. We now inspect the complete repository path listing for each identified proof archive, follow its exact versioned declarations, and record the largest hypotheses that subsume a candidate before crediting it. [Case history](sources/next-intake.md) · [Prior three-spectrum theorem](https://github.com/the-omega-institute/trureturing/blob/51dca4f1542baa532983864568d6a8ca3470e745/D5/S3/Quantum/Analysis/RefinedBMVThreeSpectrumCertificate.lean#L42-L57)

## Full source index

[Search the entries and inspect source coverage](https://shunyaekam.github.io/oo-research/pipeline/indexed.html). Indexing happens before scientific screening. The worker imports catalogue rows and source statuses weekly, preserving separate records when two catalogues discuss the same question. Broader sources also carry archived records, proposals, resource links, benchmarks, and sampled arXiv leads. The physics view selects current catalogue entries with a source-reported open or partly resolved status and a physics catalogue or subject tag. Select all records to search outside this filter. Each collection documents its coverage in the index.

The scout takes individual entries from this pool as well as the recorded arXiv intake, visits the primary literature and compares exact formulations before shortlisting. A shortlist still needs an authored, source-matched verifier before it can become an investigation. The six current investigations are a subset of the index's subject matter.

A capable exact checker already exists for the Golay circuit question. As long as its investigation is active, the dispatcher alternates its solver or reviewer with other work and gives fresh decisive results immediate review priority. A successful focus search goes to the same signed circuit verifier and independent review as every other proposal. The one-job-per-hour setting applies across these assignments.
