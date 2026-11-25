# Can 43 entangling gates prepare the Golay logical zero?

The goal is the cyclic 23-qubit Golay logical zero, starting with 23 zero qubits and using at most 43 controlled-NOTs. Single-qubit Clifford gates are free. There are no extra qubits, measurements or postselection. The published construction uses 44 CNOT-equivalent gates in six layers. The same paper reports searching for a 43-gate circuit, including a failed 92-million-neighbor experiment. Its 44-gate circuit is our starting point. [Named catalogue question A50](https://openquantumproblems.com/p/A50) · [Ganesan, Appendix A.4](https://arxiv.org/html/2610.35579v1#A1.SS4) · [Deposited circuit, cyclic CNOT version](https://doi.org/10.5281/zenodo.23509367)

We can test a proposed circuit on a laptop. Work backwards from the target. Success means all 23 qubits end in a product of single-qubit stabilizer states; their individual orientations and signs can be prepared with the allowed free gates. We pack the Pauli generators into binary columns and check whether the two columns at each site are linearly dependent over the two-element field. The positive control reverses the deposited 44-gate circuit and leaves zero mixed qubits. The empty circuit leaves 23 mixed qubits. Any positive 43-gate hit must be exported as an explicit forward circuit and independently checked with signed generators before publication.

Batch 0 scans every way to omit one entangler and change the Pauli axes of at most one other entangler on the same pair of wires. Batch 1 changes several axes. Later batches permit changing the wire endpoints and gate order at fixed count 43. A search miss says nothing about whether some other 43-gate circuit works. The wider problem of the best circuit at each depth also remains open.

Run `python3 checks/golay43.py replay` on the research branch. Each batch records its best outcome and the changes to the reference circuit. [Exact search code](../checks/golay43.py) · [Trial records](../campaign/golay43)

An independent simulator (Stim 1.16.0) verified the complete signed output of the deposited forward circuit. Its count of mixed qubits also agreed with the search checker on 80 schedules including deletions and rewired gates. Replay with `uv run --with stim==1.16.0 python checks/golay_oracle.py`. [Independent check](../checks/golay_oracle.py)

## What the larger search establishes

Each graph batch starts with a prefix of a previously verified circuit, converts its residual state to a graph state, and synthesizes a new ending using local complementations, controlled-NOTs and controlled-Zs. The first 37 batches completed 1,048,000 construction trials. They produced 37 different signed circuit files at cost 44. Stim verifies the entire stabilizer including signs, and a separate binary calculation reverses each circuit. Different files can describe equivalent preparations. [Graph receipts](../campaign/golay-graphs)

On the published circuit and those first 37 alternatives, the search tested all 3,519,704,628 delete-two/insert-one choices. A second search deleted three gates, inserted one anywhere, and allowed one final inverse-circuit gate. It tested 48,129,914,448 choices. Neither family reached 43. Counts describe choices of positions, wires and axes, with possible duplicate resulting circuits. The two-gate replacement on the original circuit also serves as a reproduction of the author's search. The second family checks whether at most two sites are still mixed after insertion. With a pure stabilizer state the only non-product possibility on two mixed sites is a Bell pair up to free single-qubit Cliffords. [Splices](../campaign/golay-splices) · [Splices with final gate](../campaign/golay-splice-tails)

There is also a finite exclusion on the published preparation. Delete any one through eight gates of its inverse in the fixed local frame. Keep every surviving operation fixed and in order. No replacement at the end of the inverse circuit with fewer gates than were deleted completes the disentangling. This covers all 223,848,240 deletion subsets. For eight deletions, just one subset survived the initial lower bound, and all 252 possible next gates failed the next bound. The first 37 alternative circuits also received the three-, four- and five-deletion test. [Repair receipts](../campaign/golay-repairs)

The lower bound follows from the graph of interactions. A product input needs at least $m-c$ two-qubit gates to produce a pure state with $m$ mixed sites in $c$ irreducible tensor factors. Each factor's sites must be connected, and touching spectators or joining two factors costs extra edges. At equality, a search need only try gates within a factor. With slack the implementation tries all wires. To get the factors, group the binary stabilizer columns for each wire into a single site and split their spans into direct summands. Across a cut the two restriction ranks are $|A|+S(A)$ and $|B|+S(A)$, with entropy in bits, so their intersection has dimension $2S(A)$. A direct sum therefore certifies a product cut. The implementation finds these cuts by sparse binary elimination. An independent Stim graph-state partition agrees on 245 inputs. Five constructed examples check both success and failure paths. [Algorithms and checks](../checks/golay)

Reproduce from the research branch with C++17 and Python. The graph replay repeats the actual search, and the splice check compares sampled optimized transformations with literal suffix replay.

```sh
uv run --with stim==1.16.0 python checks/golay/audit.py
uv run --with stim==1.16.0 python checks/golay/graph_campaign.py replay
uv run --with stim==1.16.0 python checks/golay/repair_campaign.py published 1 2 3 4 5 6 7 8
uv run --with stim==1.16.0 python checks/golay/splice_campaign.py published --check
uv run --with stim==1.16.0 python checks/golay/splice_campaign.py published --tail --check
```
