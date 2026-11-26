"""Exact dual certificates for the number of light stabilizers of binary [[12,k,d>=4]] codes with k=3 or 4.

A_j counts stabilizers of weight j. Wei et al. Appendix G (115b-e) gives
A >= 0, H_i = (M_i - 2^(12-k) e_i) A equal to zero below distance and
nonnegative otherwise, and nonnegative shadow rows S_i. M is the
quaternary Krawtchouk transform. All displayed rows have integer entries.
"""
from fractions import Fraction
from math import comb

# Each row name denotes its coefficient vector acting on A_0,...,A_12.
# The right side is zero except for A0=1 and the count E of even words.
THREE_LOGICAL = (
    (512, "8", {"A0":"9120/47", "H0":"9355/24064", "H1":"19/2048",
        "H2":"3/1024", "H3":"343/481280", "E":"-1093/3008",
        "A3":"-945/752", "A6":"-1/4", "A7":"-305/752",
        "A9":"-337/940", "A11":"-285/752", "S3":"-27/120320"}),
    (256, "54/7", {"A0":"44/7", "H0":"3/128", "H1":"87/7168",
        "H2":"13/3584", "H3":"9/7168", "E":"5/896",
        "A1":"-39/14", "A3":"-33/14", "A4":"-1/7", "A6":"-2/7",
        "S1":"-11/7168", "S2":"-1/3584", "S3":"-5/7168"}),
)


def transform(i, j):
    return sum((-1)**h * 3**(i-h) * comb(j,h) * comb(12-j,i-h)
               for h in range(min(i,j)+1))


FOUR_LOGICAL = (
    (256, "6", {"A0":"22", "H0":"21/128", "H1":"19/512", "H2":"3/256", "H3":"1/512", "E":"-1/16",
        "A1":"-4", "A2":"-6", "A3":"-41/8", "A4":"-3", "A5":"-5/4", "A7":"-3/8", "A11":"-1/8"}),
    (128, "2", {"A0":"-2", "H0":"9/128", "H1":"5/128", "H2":"3/256", "H3":"1/256", "E":"1/32",
        "A1":"-19", "A2":"-6", "A3":"-10", "A4":"-3", "A5":"-2", "S1":"-1/512", "S3":"-1/512"}),
)


def upper_bounds(k):
    limit, certificates = {3:(5, THREE_LOGICAL), 4:(6, FOUR_LOGICAL)}[k]
    rank = 12-k
    cols = range(13)
    rows = {"E": [int(j%2 == 0) for j in cols]}
    for i in cols:
        rows["A"+str(i)] = [int(i == j) for j in cols]
        rows["H"+str(i)] = [transform(i,j) - (2**rank)*int(i==j) for j in cols]
        rows["S"+str(i)] = [(-1)**j * transform(i,j) for j in cols]
    equalities = {"A0","E","H0","H1","H2","H3"}
    results = {}
    for even_count, stated, coefficients in certificates:
        total = [Fraction(0)]*13
        for name, ratio in coefficients.items():
            multiplier = Fraction(ratio)
            if name not in equalities and multiplier > 0:
                raise ValueError("An inequality is used in the wrong direction")
            total = [a + multiplier*b for a,b in zip(total,rows[name])]
        if total != [int(1 <= j <= limit) for j in cols]:
            raise ValueError("Dual does not reproduce the light-stabilizer count")
        value = Fraction(coefficients["A0"]) + even_count*Fraction(coefficients["E"])
        if value != Fraction(stated) or value >= rank:
            raise ValueError("Bound does not exclude a basis of light generators")
        results[str(even_count)] = str(value)
    return results


if __name__ == "__main__":
    for k in (3,4):
        print(k, upper_bounds(k))
