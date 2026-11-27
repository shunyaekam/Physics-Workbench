"""Exact recurrence certificate for OEIS A191625 (SymPy)."""
from sympy import Poly, cancel, diff, expand, factor, rem, symbols

t, u = symbols("t u")
base = 1 - t + t**2 + t**3
disc = (1-t**4)*(1-2*t-t**2)
kernel = factor(((2*t*u-base)**2-disc)/(4*t))
F = 2*(1-t**2)*(1-t)*u/((1-t*u)*(2*t-u))-1
# c_j(n)=slope[j]*n+offset[j], multiplying a(n-j).
slope = [1,-4,1,8,-3,2,-1,-8,2,2]
offset = [1,0,-5,-6,9,-16,13,56,-14,-18]
A = sum(s*t**j for j,s in enumerate(slope))
B = sum((j*s+b)*t**j for j,(s,b) in enumerate(zip(slope,offset)))
# Extract the first nine exact coefficients of P(t;0) directly from the
# source radical. The denominator starts with t, so expand U one term farther.
from sympy import sqrt
U = ((base-sqrt(disc)).series(t,0,13).removeO()/(2*t)).expand()
numerator, denominator = F.as_numer_denom()
num = Poly(expand(numerator.subs(u,U)), t)
den = Poly(expand(denominator.subs(u,U)), t)
power = min(e[0] for e in den.monoms())
initial = []
for n in range(9):
    residual = num.nth(n+power)-sum(den.nth(n+power-i)*c for i,c in enumerate(initial))
    initial.append(residual / den.nth(power))
R = sum(t**n * sum((slope[j]*n+offset[j])*initial[n-j] for j in range(n+1)) for n in range(9))
deriv = diff(F,t)-diff(F,u)*diff(kernel,t)/diff(kernel,u)
num,den = cancel(t*A*deriv+B*F-R).as_numer_denom()
assert rem(num,kernel,u)==0
assert rem(den,kernel,u)!=0
print("Initial terms",initial)
print("Low-degree residual",R)
print("Kernel",kernel)
print("Exact numerator remainder",rem(num,kernel,u))
