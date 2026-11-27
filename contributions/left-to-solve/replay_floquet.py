"""Independent numerical illustration of the complex-potential counterexample."""
import numpy as np
from scipy.integrate import solve_ivp
from scipy.optimize import brentq

def trace_and_derivative(energy, t):
    def rhs(s, v):
        a, c, b, d, ae, ce, be, de = v
        h = 2j * t * np.cos(2 * s) - energy
        return (c, h*a, d, h*b, ce, h*ae-a, de, h*be-b)
    sol = solve_ivp(rhs, (0, np.pi), np.array([1,0,0,1,0,0,0,0], dtype=complex),
                    method="DOP853", rtol=2e-13, atol=2e-14)
    assert sol.success
    a, _, _, d, ae, _, _, de = sol.y[:,-1]
    tr, derivative = (a+d)/2, (ae+de)/2
    assert max(abs(tr.imag), abs(derivative.imag)) < 4e-12
    return tr.real, derivative.real

if __name__ == '__main__':
    for t in [0.1, 0.05, 0.025]:
        E = brentq(lambda e: trace_and_derivative(e, t)[1], .9, 1.1)
        f, slope = trace_and_derivative(E, t)
        assert -1 < f < 1 and abs(slope) < 1e-10
        print(f"t={t:g}, E={E:.12f}, f={f:.12f}, (f+1)/t²={(f+1)/t**2:.9f}")
    print("predicted limit", np.pi**2/8)
