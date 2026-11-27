## The one-row toroidal sandpile

The Omega Institute’s trureturing project previously published a Lean proof of this corrected identity. This note reproduces its mathematical conclusion for the Left to Solve catalogue. [Prior proof and attribution](https://www.trureturing.org/research/arndt-2017-a293452-torus-column-sandpile/)

For a ring of length $n\ge1$ with the sink at zero, the number of legal topplings until stabilization is
$$
T(n,1)=\sum_{j=1}^{\lfloor n/2\rfloor}j(n-j).
$$
For $n\ge2$ this is A023855 at $n-1$. For $n=1$ the sum is empty. In particular, the equality printed in A293452 fails even if we omit the singleton ring: a two-site ring topples once, while A023855(2) is two.

**Proof.** Cut the ring at the sink, giving endpoints $0,n$ with firing count zero. Each interior site starts with four grains. The vertical self-loops return two grains to the firing site. If $v_i$ is its firing count, its current height is $4-(Lv)_i$, where $(Lv)_i=2v_i-v_{i-1}-v_{i+1}$. This counts both horizontal edges also for $n=2$.

Set
$$
u_i=\tfrac12\bigl(i(n-i)+\mathbf1_{2\mid n}\min(i,n-i)\bigr).
$$
These are nonnegative integers with zero boundary values. For odd $n$, $i(n-i)$ is even. For even $n$, $i(n-i)$ and $\min(i,n-i)$ have the same parity. A second difference gives $(Lu)_i=1$ at every interior site, except for the midpoint of an even ring where it is two. Thus $h_i^*=4-(Lu)_i$ is stable.

Every legal firing sequence has $v\le u$. At the first firing that would exceed $u_i$, its two neighbors have counts at most their prescribed values and the site itself has count $u_i$, so its height is at most $h_i^*<4$. In particular every maximal legal play terminates. At its end put $w=u-v\ge0$, with $w_0=w_n=0$. If its maximum is positive, select a maximal consecutive plateau attaining that maximum. Either an endpoint is a site with $h_i^*=3$, where $(Lw)_i\ge1$, or the plateau consists only of the exceptional midpoint, where $(Lw)_i\ge2$. In either case the actual height $h_i^*+(Lw)_i$ is at least four, contradicting termination. Therefore $v=u$ in every play.

Finally pair $i$ with $n-i$ when summing $u_i$. For odd $n$ this directly gives the displayed sum. For even $n=2m$, the quadratic part gives $\sum_{i=1}^{m-1}i(n-i)+m^2/2$; the extra half-sum of $\min(i,n-i)$ contributes another $m^2/2$. This proves the identity.

[Sandpile table and conjecture](https://oeis.org/A293452) · [Toppling rules](https://oeis.org/A249872) · [Rectangle sums and offset](https://oeis.org/A023855)

The Omega Institute previously formalized the same corrected identity for every size. This note records our independent replay of the catalogue entry. [Earlier Lean result](https://www.trureturing.org/research/arndt-2017-a293452-torus-column-sandpile/)
