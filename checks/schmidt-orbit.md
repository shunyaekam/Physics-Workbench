# Exact local-basis tests for nonlocal magic

[Sierant’s Conjecture 1](https://arxiv.org/html/2609.13106v2#S2.SS1) states that the computational-basis state with decreasing Schmidt amplitudes minimizes the stabilizer 2-Rényi entropy on its local-unitary orbit. For $N$ total qubits the quantity inside the negative logarithm is $F=2^{-N}\sum_P\langle P\rangle^4$. A single state on that orbit with **strictly larger** $F$ disproves the universal conjecture. An equality, a smaller value, or an unsuccessful search supplies no universal proof.

The [first hosted proposal](https://github.com/shunyaekam/Physics-Workbench/blob/research/campaign/agent-lanes/e27-schmidt-52687ee3011a4c80.json) chose two four-qubit registers and the state $\sum_x a_x|x,x\rangle/\|a\|_2$. The search rearranges the same integer amplitudes by a common basis permutation on both parties. Its full grid for $0\leq a_x\leq4$ contains $5^{16}-1=152{,}587{,}890{,}624$ nonzero ordered assignments. The checker accepts either a specific pair of amplitude lists or two independent rational plane rotations. A rotation supplied as $[i,j,c,s,h]$ acts by the matrix $\left(\begin{smallmatrix}c&-s\\s&c\end{smallmatrix}\right)/h$ on the ordered basis vectors $i,j$ and by the identity elsewhere. It requires $c^2+s^2=h^2$ with $h>0$. All comparisons use unbounded integers and the complete normalized fourth moments. Every finalist is replayed through direct Hermitian tensor-Pauli enumeration, with a second matrix construction verifying the rotation on the supplied Schmidt state.

## Why permutations have a structural obstruction

The following is a written argument for simultaneous basis permutations at any equal register size. The finite local character coefficients have an executable check. The general argument and its priority remain under review.

Let $V=\mathbb F_2^n$, $d=2^n$ and $a:V\to\mathbb R_{\ge0}$. Write $C(a)$ for the sum of the products of the eight amplitudes on every ordered affine cube, including degenerate cubes:

$$C(a)=\sum_{x,h,k,l\in V}\prod_{v\in\{0,1\}^3} a(x+v_1h+v_2k+v_3l).$$

For a diagonal Schmidt state, a bipartite Pauli has zero expectation unless the two bit-flip masks agree. At common mask $h$ the expectation before normalization is, up to unit phase, the Walsh transform of $g_h(x)=a(x)a(x+h)$ at the XOR of the two phase masks. Each resulting phase mask has $d$ preimages. Expanding the fourth moment of this transform, character orthogonality forces the four input indices to sum to zero. They are uniquely $x,x+k,x+l,x+k+l$ in that order. The unnormalized Pauli sum is $d^2 C(a)$, and $F=C(a)/(\sum_x a(x)^2)^4$. The cube expression is a Gowers uniformity functional. [Related quantum Gowers norm work](https://arxiv.org/abs/2408.06289)

Choose any nonzero bit string $u$ and write $V=H\oplus\langle u\rangle$, where $H$ consists of labels with the highest set bit of $u$ cleared. Sort every pair $y,y+u$ so that the larger entry is at $y\in H$, the smaller integer label. At each pair write $a(y+tu)=m_y+(-1)^t b_y$ with $m_y\geq0$. The operation replaces each $b_y$ by $|b_y|$.

Fix the projections of $x,h,k,l$ onto $H$. The sixteen lifts correspond to the sixteen affine bit functions $L(v)=t_0+t_1v_1+t_2v_2+t_3v_3$. Expand $\sum_L\prod_v(m_{y_v}+(-1)^{L(v)} b_{y_v})$. The coefficient on any chosen subset of the eight $b$ factors is $\sum_L(-1)^{\sum_{v\in S}L(v)}$, equal to zero or sixteen by character orthogonality. Every surviving term can only increase when its $b$ factors are replaced by their absolute values. This holds even for repeated $y_v$. Hence the pair sort weakly increases $C$.

Whenever $i<j$ and $a(i)<a(j)$, choose $u=i\oplus j$. Pair sorting then strictly decreases $\sum_x x a(x)$, since at least that pair changes and all larger values move to smaller integer labels. Only finitely many permutations exist. Repeating thus terminates at the decreasing arrangement, whose $F$ is maximal in this family. This motivates rotating the local bases in the next search. General local rotations change the individual computational-basis amplitudes and fall outside the sorting argument.

## Reproduce the two pilots

```sh
python3 checks/schmidt_orbit.py --seed 20261125 --trials 1024
python3 checks/schmidt_orbit.py --rotations --seed 20261125 --trials 128
python3 -m unittest -v test_schmidt_orbit
```

The permutation pilot sampled 1,024 arrangements. The rotation pilot sampled 128 rank-15 spectra with one real plane rotation per party. Both searches returned a lower stabilizer purity for every sampled alternative. The tests include a known analytic purity, strict comparison direction, a physical one-qubit rotation, corrupted arithmetic, malformed rotations and same-orbit controls. The 256 local coefficients in the compression argument are also checked exactly. The unrestricted conjecture remains open.
