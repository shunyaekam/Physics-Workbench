# Light checks for small quantum codes

With **four logical qubits** stored in twelve physical qubits at distance four, the exact minimum check weight is **seven**. A neighbor of Grassl’s code attains seven. Among weight-one through weight-six stabilizers any eligible group has at most six in the all-even case and at most two in the mixed case. Eight independent generators are required. Replay with `python3 ops/witness.py wei-12-4-4 checks/small_qec/twelve-four.json`. The search that produced the matrix replays with `python3 checks/small_qec/neighbor_replay.py`. The explicit code has 225 weight-four logical Pauli strings and zero of weights one through three.

For twelve physical qubits encoding three logical qubits at distance four, six is the smallest possible maximum number of qubits touched by a stabilizer generator. Our independent code and a subcode of an archived Grassl construction attain six. The reference tables give an interval of six through eight. Wei et al. already describe the parent-code restriction in Appendix J. Optimizing the choice of logical Pauli and the resulting generating basis supplies the missing endpoint in their table. The lower bound is also reproducible here. [Wei et al., Table 2](https://arxiv.org/html/2601.19848v2#S7.T2) · [Jing and Tu](https://github.com/Ivann1242/optimal-check-weight-11-3-3/blob/b4df2d2a2a855f89f9aa9d7200a6f5582519e1fb/paper/main.tex) · [Research note](https://shunyaekam.github.io/Physics-Workbench/papers/distance-four.pdf)

From the repository root, run

```sh
python3 ops/witness.py wei-12-3-4 checks/small_qec/twelve-three.json
python3 checks/small_qec/search/verify.py
python3 checks/small_qec/search/prior.py
```

The first command checks commutation, rank and all physical Pauli words through weight four. The counts of logical Pauli strings at weights one to four are 0, 0, 0 and 105. A basis of nine independent checks spans a group of size 512. Nine light generators would require nine distinct nonidentity group elements of weight at most five.

[The dual checker](dual.py) bounds this count by 8 if all stabilizers have even weight and by 54/7 otherwise. On commuting Paulis, the parity of weight is additive under multiplication, because the number of sites bearing two different nonidentity Paulis is even. Thus the even subgroup contains 512 or 256 elements. For each case the checker combines exact rational multiples of quantum MacWilliams, shadow and positivity constraints, checking all 13 coefficients and the sign of every inequality multiplier. These identities apply to arbitrary binary stabilizers, including degenerate codes. The short script uses only the Python standard library. The necessity of its input inequalities is the published weight-enumerator theorem in Wei et al. Appendix G.

[Independent mathematical and priority review](d4-review.md)

## Eleven-qubit replication

[The elementary counting proof](https://shunyaekam.github.io/Physics-Workbench/papers/eleven-five.pdf) independently recovers seven for the [[11,5,3]] code. Jing and Tu had already established that optimum. See the [priority audit](priority-review.md), [mathematical challenge](math-review.md) and [search records](search/README.md). Run the signed-Pauli checker and the finite arithmetic check with

```sh
python3 checks/small_qec/signed.py checks/small_qec/eleven-five-rows.txt
python3 checks/small_qec/lower.py
```
