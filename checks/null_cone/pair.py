"""Check the connected single-polarization mode sum in arXiv:2611.34924v1, Eq. 4.33."""
import mpmath as mp
mp.mp.dps = 45
N = 20_000
for s in (2, 5, 13):
    # Wick contractions leave 2*(variance)^2 per mode; number-two state acquires two phases.
    z = mp.exp(-2j/mp.mpf(s))
    phase = mp.mpc(1)
    partial = mp.mpc(0)
    for k in range(1, N+1):
        phase *= z
        partial += phase / (2*(s*k)**2)
    closed = mp.polylog(2,z) / (2*s*s)
    difference = abs(closed-partial)
    # Triangle inequality followed by sum_{k>N} k^{-2} <= integral_N^infty x^{-2} dx.
    tail = mp.mpf(1)/(2*s*s*N)
    if difference >= tail:
        raise ArithmeticError("Disagreement larger than the analytic truncation bound")
    print(f"s={s}  absolute difference={mp.nstr(difference,8)}  tail bound={mp.nstr(tail,8)}")
