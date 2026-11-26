# How oo research counts a solution

Our unit of work is one externally posed question, identified by its source, version and quantifiers. A paper can describe several experiments on one question. The published certificate index counts each registered question once.

## A model of a research attempt

Let a source claim be $T$. For each supported way of settling it, the lab fixes a set of admissible objects $W$, a checker $V$, and the mathematical implication $V(w)=1\Rightarrow T$ or $V(w)=1\Rightarrow\neg T$. For instance, a universal inequality needs a single admissible strict violation to fail. An existence question can be answered positively with one explicit construction. In both cases a failed search is compatible with either answer.

The contract records assumptions and the implication before an agent searches. The search may be heuristic, stochastic or assisted by a model. The decisive comparison must have a reproducible meaning independent of the search. Our primary measure is the number of distinct registered statements with a full certificate replayed using the publication branch. Working papers, candidate witnesses and subsidiary Lean theorems have their own labels.

| Question | Object tested | What could follow |
|---|---|---|
| Sorted Schmidt basis | Exact paired states on the same local-unitary orbit | A larger exact Pauli fourth moment refutes the entropy minimum |
| Quantum Golay preparation | Signed Clifford circuit on the 23 specified wires | The exact target state and at most 43 CNOTs prove existence |
| Refined BMV lower bound | A rational symmetric pair and two word counts | A strictly negative upper endpoint of a rigorous trace-gap enclosure refutes the bound |
| NPT bound entanglement | A Schmidt-rank-at-most-two vector at four or five copies of one state | A negative score establishes this state's finite-copy distillability; the existential parent remains open |
| Wigner–Husimi inequality | Finite optical state tested at two quadrature resolutions | A possible violation calls for rigorous integral and tail bounds |
| Quantum transport | Lean proof steps against a frozen all-cycles counting proposition | A kernel-checked counting lemma would advance the existing written proof; the reduction to the full physical statement still needs formalization |

A useful allocation objective is $\mathbb E[\sum_i w_i \Delta C_i]/h$, where $C_i$ becomes one only at the first verified full solution, $w_i$ is the scientific value of the original question and $h$ is research time. Running an equivalent trial twice contributes zero to $\Delta C_i$. We do not have calibrated probabilities or weights. The scheduler therefore gives actual decisive candidates first access to review, rotates open approaches, and parks repeated failures while the scout evaluates new leads.

## One pass through the lab

1. **Find and reserve.** Screen source-based leads for the exact statement, aliases, later solutions, significance and a feasible decisive test. Registered questions have one [tracking issue each](https://github.com/shunyaekam/Physics-Workbench/issues). New leads remain on research until there is a source-to-checker contract.
2. **Construct and execute.** The hosted solver gets the problem, prior failed attempts and a disposable mathematical workspace. It can run experiments and returns a concrete object or proof steps. The worker checks that object again with the registered implementation. It keeps the witness, outcome or rejection. Numerical optics leads retain their numerical status.
3. **Challenge and revise.** A fresh hosted context checks the quantifiers, derivation and executed outcome. The next solver sees the criticism. Repeating the identical object produces a rejection. Four unsuccessful attempts park a strategy; a new contract version reopens it. An open queue rotates across targets.
4. **Check priority.** When a witness is decisive and survives the math review, a different hosted session searches primary sources for a previous resolution. Its verdict and sources travel with the witness. A prior resolution or unresolved priority blocks discovery release. A bounded literature search cannot establish absolute priority.
5. **Replay, publish and reconcile.** The publisher checks out the publication branch in isolation. It reads the immutable research packet as data and independently recomputes the answer. Only an exact decisive result matching the frozen statement and both reviews enters the [certificate index](../certificates/index.json). It pushes the evidence, verifies the public file byte content as parsed JSON, then closes the tracking issue. A stale branch or deployment retries without a forced push.

Mathematical correctness is relative to the formal statement, the correctness of the checker or Lean kernel and its allowed foundations. The original source, the bridge from physics to mathematics, and the search for prior work remain inspectable. No model vote establishes these assumptions. Search is incomplete: a genuine open question may stay open indefinitely.

The operational pattern is adapted from [Cinna Davis and GPT-6.2 Astra's public instructions](https://github.com/1337isnot1337/solved-conjectures/blob/8e6ba08e377bae2014fd53c49ca03d9b39c99ab7/AGENTS.md) and the [Brown–Mol case history](https://github.com/1337isnot1337/solved-conjectures/issues/210). The physics contracts and acceptance tests are specific to oo research.
