import Init

/- Finite coefficient certificate for t ∈ [0,2] in the single-rail proof.
   After multiplication by 100 * 4^k * 6^k * k!, every comparison is integral. -/
namespace Workbench.SingleRail

private def choose : Nat → Nat → Nat
  | _, 0 => 1
  | 0, _+1 => 0
  | n+1, k+1 => choose n k + choose n (k+1)

-- Compute (2j choose j) by the multiplicative recurrence; the univariate
-- convolution uses the small Pascal triangle for its remaining binomials.
private def central : Nat → Nat
  | 0 => 1
  | j+1 => central j * (4*j+2) / (j+1)

private def v (j : Nat) := (2*j+1)*central j

private def convolution (k : Nat) :=
  ((List.range (k+1)).map (fun j => choose k j * v j * v (k-j))).sum

def passes (k : Nat) : Bool :=
  decide ((100*(k+1)+1)*48^k + 50*28^k < 157*6^k*convolution k)

theorem lowCoefficients : (List.range 17).all passes = true := by decide

private def factorial : Nat → Nat
  | 0 => 1
  | j+1 => (j+1)*factorial j

theorem tailBound : 4 * 37 * 4^17 * 100 < 3 * 2 * factorial 17 := by decide

#print axioms lowCoefficients
#print axioms tailBound
end Workbench.SingleRail
