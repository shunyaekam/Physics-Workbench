# A recurrence for corner-ending prudent walks

R. J. Mathar conjectured a nine-lag recurrence in 2017 for two-sided prudent square-lattice walks ending at the northeast corner of their bounding box. It holds for every integer n ≥ 9. This is a coefficient consequence of Mireille Bousquet-Mélou's published enumeration of those walks. [Mathar’s conjecture](https://oeis.org/A191625) · [Bousquet-Mélou, Proposition 5](https://arxiv.org/html/0804.4843#ThmTheorem5)

Write a(n) for the count and F(t) for its ordinary generating function. Proposition 5 marks length by t and the endpoint's distance from the northeast corner by a second variable. Setting that variable to zero selects exactly the walks in question and gives

    F = 2(1−t²)(1−t)U / ((1−tU)(2t−U)) − 1,
    K(t,U) = tU² − (1−t+t²+t³)U + t = 0,    U = t + O(t²).

Let s=[1,−4,1,8,−3,2,−1,−8,2,2] and b=[1,0,−5,−6,9,−16,13,56,−14,−18], indexed from j=0 through 9. The proposed recurrence is Σⱼ(sⱼn+bⱼ)a(n−j)=0. Define the polynomials

    A(t) = Σⱼ sⱼ tʲ,    B(t) = Σⱼ (jsⱼ+bⱼ)tʲ,
    R(t) = 1 − 7t² + 6t³ + 5t⁴ − 14t⁵ − 5t⁶ + 2t⁸.

Substitute the displayed rational expression for F and differentiate with U′=−Kₜ/Kᵤ. After clearing denominators, the numerator of tAF′+BF−R has zero remainder upon division in U by K. The denominator is nonzero on this formal branch: U=t+O(t²), Kᵤ=−1+O(t), 1−tU is a unit and 2t−U=t+O(t²). The accompanying exact symbolic computation performs this polynomial division and independently obtains R from the first nine coefficients of the original algebraic series.

The coefficient of tⁿ in tAF′+BF is exactly the conjectured sum for n ≥ 9. Since R has degree eight, every one of these coefficients vanishes. The initial terms are 1, 2, 4, 10, 24, 58, 140, 340 and 828. The contribution here is a checkable derivation of Mathar’s particular recurrence. The counting generating function is Bousquet-Mélou's result.
