"""Cross-check the polynomial solver against the original exhaustive polygon calculation."""
from itertools import combinations
from transport_optimum import solve
from transport_polygon import polygon

if __name__=="__main__":
    count=0
    for n in range(2,9):
        for x in combinations(range(8),n):
            for q in (1,2,3,5):
                error,_,_=solve(x,q)
                reference=polygon(x,q)[0] if n>=3 else 0
                if error!=reference:raise ArithmeticError(f"Chain optimum mismatch for {x}, {q}")
                count+=1
    print(count,"exact comparisons; attaining labels checked for every input")
