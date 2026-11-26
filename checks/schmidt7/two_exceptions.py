"""Compare the closed optimum with direct computational-basis Pauli fourth moments."""
from fractions import Fraction as Q


def optimal(d,a,b,c):
    """Purity for raw Schmidt amplitudes a repeated d-2 times, b and c."""
    if d<8 or d&(d-1) or min(a,b,c)<0:raise ValueError("Expected qubit dimension and nonnegative amplitudes")
    norm=(d-2)*a*a+b*b+c*c
    if not norm:raise ValueError("Empty state")
    q=Q(4,d)
    rank=(d-1)*(d-2)//6
    trace=q*(d-2)/2
    def terms(a,b,c):
        return a**4+q*a**3*(b+c-2*a),a*a*(b-a)*(c-a)
    A,B=terms(a,b,c)
    A2,B2=terms(a*a,b*b,c*c)
    sector=rank*A*A+2*A*B*trace+B*B*q*trace
    overlap=rank*A2+trace*B2
    inv=7*((d-2)*a**4+b**4+c**4)**2-6*((d-2)*a**8+b**8+c**8)
    return (inv+6*d*d*sector+18*d*overlap)/norm**4


def direct(amplitudes):
    # X-displacements must match on the two parties. For each local phase
    # difference z there are d choices of the two Z strings.
    d=len(amplitudes)
    parity=[(-1)**bin(i).count("1") for i in range(d)]
    result=sum(sum(parity[z&i]*a*amplitudes[i^x] for i,a in enumerate(amplitudes))**4
               for x in range(d) for z in range(d))
    return Q(result,d*sum(a*a for a in amplitudes)**4)


if __name__=="__main__":
    for d in (8,16,32,64):
        for a,b,c in ((2,1,0),(2,3,1),(2,0,0),(2,3,4),(2,2,2),(0,3,4)):
            amplitudes=sorted([a]*(d-2)+[b,c],reverse=True)
            if direct(amplitudes)!=optimal(d,a,b,c):raise ArithmeticError("Pauli normalization mismatch")
    print("24 exact purity checks passed; rank-15 example:",optimal(16,2,1,0))
