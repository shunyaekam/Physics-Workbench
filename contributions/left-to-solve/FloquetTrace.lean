import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

namespace FloquetBand

/-- Algebraic step for a real 2×2 period matrix with determinant 1.
The entries x,y,z form the Gram matrix. The expression in the conclusion
is twice the derivative of the half-trace under A' = A J G. -/
theorem trace_slope_ne_zero (a b c d x y z : ℝ)
    (hunimod : a*d - b*c = 1) (hband : |(a+d)/2| < 1)
    (hz : 0 < z) (hgram : 0 < x*z - y^2) :
    -b*x + (a-d)*y + c*z ≠ 0 := by
  set k := (a-d)/2 with hk
  have hab := abs_lt.mp hband
  have hdet : 0 < (-b)*c - k^2 := by
    rw [hk]
    nlinarith [mul_pos (by linarith [hab.1] : 0 < 1 + (a+d)/2)
                       (by linarith [hab.2] : 0 < 1 - (a+d)/2)]
  have identity : (-b)*z*((-b)*x + 2*k*y + c*z) =
      ((-b)*y + k*z)^2 + (-b)^2*(x*z-y^2) + z^2*((-b)*c-k^2) := by ring
  intro hzero
  have zero : (-b)*x + 2*k*y + c*z = 0 := by rw [hk]; nlinarith
  rw [zero, mul_zero] at identity
  nlinarith [sq_nonneg ((-b)*y + k*z), mul_nonneg (sq_nonneg (-b)) hgram.le,
             mul_pos (sq_pos_of_pos hz) hdet]
end FloquetBand

#print axioms FloquetBand.trace_slope_ne_zero
