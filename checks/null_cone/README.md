# A check on the null-cone graviton pair amplitude

Venkatesa Chandrasekaran proposes a background-independent quantization of four-dimensional vacuum general relativity. This reproduction addresses the particular choice of one polarization, one angular harmonic, a Gaussian incoming state, and a phased annihilation source in Eqs. (4.32–34). [Preprint, Sec. 4.4](https://arxiv.org/html/2611.34924v1#S4.SS4)

The variance of radial mode k is 1/(2sk). Two Wick contractions and the two-graviton phase give the summand exp(−2ik/s)/(2s²k²). Its absolute value sums to π²/(12s²), so the series converges for each positive s. Summing at fixed s gives the stated dilogarithm. If one expands first at finite cutoff N, the coefficient of 1/s³ is −i times the harmonic sum through N. This diverges as N grows. These two statements can both hold because the expansion in k/s is nonuniform.

With mpmath installed, run `python3 checks/null_cone/pair.py`. The script compares 20,000 terms with the independently evaluated dilogarithm at s = 2, 5 and 13. The analytic bound controls truncation. Decimal evaluation is a numerical consistency check. This calculation tests the reported mode sum under its specified assumptions. The full quantization, its physical state space and its experimental implications are separate questions.
