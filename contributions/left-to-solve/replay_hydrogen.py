"""Show the n=15 discrepancy for every quadratic scale fitting rows 9 and 12."""
from fractions import Fraction

# If round(c*n²) = a, the scale c lies in this closed interval, including
# both ties to cover any choice of nearest-integer tie-breaking convention.
def scale_interval(n, a):
    return Fraction(2*a - 1, 2*n*n), Fraction(2*a + 1, 2*n*n)

lower = scale_interval(9, 73813)[0]
upper = scale_interval(12, 131222)[1]
assert lower < upper
rows = [91127, 110263, 131222, 154004, 178608, 205035]
for n, a in enumerate(rows, 10):
    if n == 12:
        # The observed row itself fixes which side of a potential tie applies.
        continue
    assert a - Fraction(1, 2) < lower*n*n <= upper*n*n < a + Fraction(1, 2)
prediction = sum(c*a for c, a in zip([1, -3, 4, -4, 3], rows))
assert prediction == 205034 and rows[-1] == 205035
print(f'Scales consistent with rows 9 and 12 lie between {lower} and {upper}.')
print(f'n=15: rounded {rows[-1]}, recurrence {prediction}.')
