"""Exact coefficient proof for the (12,3) refined BMV comparison in dimension 3."""
from collections import Counter
from functools import lru_cache
from math import comb


class Polynomial:
    """A sparse integer polynomial in x and t."""
    def __init__(self, terms):
        self.terms = {key: coefficient for key, coefficient in terms.items() if coefficient}

    def __add__(self, other):
        terms = Counter(self.terms)
        terms.update(other.terms)
        return Polynomial(terms)

    def __sub__(self, other):
        terms = Counter(self.terms)
        terms.subtract(other.terms)
        return Polynomial(terms)

    def __mul__(self, other):
        terms = Counter()
        for (i, j), a in self.terms.items():
            for (k, l), b in other.terms.items():
                terms[i + k, j + l] += a*b
        return Polynomial(terms)

    @lru_cache(maxsize=None)
    def __pow__(self, n):
        if n == 0:
            return ONE
        if n == 1:
            return self
        half = self ** (n // 2)
        square = half * half
        return square * self if n % 2 else square


ZERO = Polynomial({})
ONE = Polynomial({(0, 0): 1})
X = Polynomial({(1, 0): 1})
T = Polynomial({(0, 1): 1})


def deficit(a, b, c):
    # Equation (3) of Hägele, multiplied by its composition count.
    terms = (a**i * b**j * c**(12-i-j) for i in range(13) for j in range(13-i))
    return sum(terms, ZERO) - Polynomial({(0, 0): comb(14, 2)}) * (a*b*c)**4


def certificate():
    a, b, c = X, X+ONE, X+ONE+T
    dx, dy, mixed = deficit(a,a,c), deficit(b,b,c), deficit(a,b,c)
    q = deficit(b,b,a)*deficit(c,c,a) + deficit(a,a,b)*deficit(c,c,b)
    d = mixed**2 - dx*dy
    h = mixed*(dx+dy) + dx*dy + dx*dy
    return q*h**2 - d**2*(dx+dy)**2


if __name__ == '__main__':
    coefficients = certificate().terms
    negatives = sum(c < 0 for c in coefficients.values())
    minimum = min(coefficients.values())
    if negatives or len(coefficients) != 2324 or minimum != 2912:
        raise ArithmeticError("The ordered-gap coefficient certificate failed.")
    print(f"{len(coefficients)} nonzero integer coefficients, {negatives} negative, minimum {minimum}")
