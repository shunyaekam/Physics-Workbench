# Rational interval check for the lower refined BMV bound

For Hermitian $H,K$ and positive integers $n,m$, define $g$ as the mean trace over words with $n$ factors $A=e^H$ and $m$ factors $B=e^K$, minus $\operatorname{Tr}e^{nH+mK}$. A witness with a rigorously negative **upper** endpoint for $g$ contradicts the registered lower bound. Real symmetric matrices with small rational entries are admissible instances. A nonnegative sample says nothing about other inputs. [Hägele, Eq. (1)](https://arxiv.org/html/2611.00129v1#S1)

## Error bound

Use the row-sum matrix norm $\|T\|_\infty=\max_i\sum_j|T_{ij}|$. Submultiplicativity bounds the omitted terms of the degree-$s$ Taylor polynomial $P_s(T)$ by the scalar exponential tail at $t=\|T\|_\infty$. The first omitted term has size at most $t^{s+1}/(s+1)!$. Each later term has ratio at most $t/(s+2)<1$ with the checker's chosen degree. Thus the error is at most

$$e_T=\frac{t^{s+1}}{(s+1)!}\frac{1}{1-t/(s+2)}.$$

Write $u=\|P_s(H)\|_\infty+e_H$, $v=\|P_s(K)\|_\infty+e_K$. These upper-bound both the approximate and exact factors of the two types. In any ordered word, replace factors one by one. The difference telescopes. The $n$ replacements of the first type each have error at most $e_Hu^{n-1}v^m$, and the $m$ of the second type have error at most $e_Ku^nv^{m-1}$. Averaging over words preserves this uniform bound. Because $|\operatorname{Tr}E|\le d\|E\|_\infty$, the total additive trace error is bounded by

$$d\left(n e_Hu^{n-1}v^m+m e_Ku^nv^{m-1}+e_{nH+mK}\right).$$

The [checker](bmv_certificate.py) computes the polynomial matrices, word sums, rational center and radius exactly. The primary recurrence appends either letter to all shorter words, counting each distinct word once. If the upper endpoint is negative, a higher-degree Taylor approximation enumerates words by their positions. Release requires both upper endpoints negative and intersecting enclosures. Both approaches share matrix arithmetic and the tail estimate.

## Independent controls

Run `python3 -m unittest -v test_bmv_certificate`. Zero inputs give the exact singleton $[0,0]$. Proportional nonzero matrices commute, so the interval must contain zero. Another test takes $H=(3/8)Z$, $K=(4/8)X$ and $n=m=2$. Cyclicity splits the six words into four traces of $A^2B^2$ and two of $(AB)^2$. The first trace is $2\cosh(3/4)\cosh(1)$, and the second is $(2\cosh(3/8)\cosh(1/2))^2-2$ by the determinant-one identity. The joint exponential trace is $2\cosh(5/4)$. An independent 120-digit decimal evaluation lies inside both rational enclosures. This numerical control exercises the implementation. The rational error estimate supplies the certificate. An intentionally corrupted recurrence and inadmissible matrix inputs must also be rejected.
