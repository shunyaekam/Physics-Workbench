"""Independent analytic constants and direct radial integrations for the optical notes."""
from fractions import Fraction as F
from math import comb, exp, factorial, log, log1p, sqrt
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from scipy.integrate import quad
from scipy.special import i0e
from single_rail_regions import enclose
from checks.sparse_table import audit, ROOT


def angular_radial(v, power, upper):
    # Radial density of |Z+sqrt(v)|² for a circular unit Gaussian. Evaluate
    # the angular integral by the scaled Bessel function, without a Poisson series.
    def density(u):
        return exp(-(sqrt(u)-sqrt(v))**2)*i0e(2*sqrt(u*v))
    return quad(lambda u: power(u)*density(u), 0, upper, epsabs=1e-12, epsrel=3e-12)[0]


def main():
    print("Published excited-level pairs with matching receipts:", audit(ROOT))
    for k in range(17):
        v = lambda j: (2*j+1)*comb(2*j, j)
        c = sum(comb(k, j)*v(j)*v(k-j) for j in range(k+1))
        assert 157*6**k*c > (100*(k+1)+1)*48**k + 50*28**k
    assert F(4,3)*F(37,2)*F(4**17,factorial(17)) < F(1,100)
    for x, needed in [(F('6.96'),1000), (F(10),10000)]:
        assert sum(x**j/factorial(j) for j in range(15)) > needed
    assert F(29,400)*F(24,25)**2 > F('6.96')*F('7.96')/1000 + F(24,10000)
    for a in (F(29,100), F(1,3), F(2,5), F(1,2)):
        for s in (F(0), F(1,100), F(1,2), F(5), F(24), F(64)):
            af, sf = float(a), float(s)
            d = angular_radial(sf/2, lambda u: 1-2*u, .5)
            raw = angular_radial(af*sf, lambda u: u**af, float("inf"))
            delta = (log(raw)-af*log(af*(1+sf)))/(1-af)
            measured = delta-log1p(2*d/(1+sf))
            lo, hi = enclose(s, s, a)
            assert float(lo)-2e-10 <= measured <= float(hi)+2e-10, (a,s,lo,measured,hi)
    print("17 coefficients, exponential tail comparisons, and 24 independent radial checks passed.")


if __name__ == "__main__":
    main()
