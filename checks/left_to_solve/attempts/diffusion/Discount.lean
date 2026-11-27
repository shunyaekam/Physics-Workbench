import Mathlib.Analysis.Normed.Ring.InfiniteSum
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Tactic.Ring

open scoped BigOperators

namespace DiffusionDiscount

/-- The discounted masses of any sequence of subprobabilities are absolutely summable. -/
theorem discounted_summable {s : ℝ} (hs : 0 ≤ s) (hs' : s < 1)
    (p : ℕ → ℝ) (hp : ∀ n, p n ∈ Set.Icc 0 1) :
    Summable (fun n : ℕ => ‖s^n * p n‖) := by
  apply Summable.of_nonneg_of_le (fun n => norm_nonneg _) _ (summable_geometric_of_lt_one hs hs')
  intro n
  rw [Real.norm_eq_abs, abs_of_nonneg (mul_nonneg (pow_nonneg hs n) (hp n).1)]
  simpa using mul_le_mul_of_nonneg_left (hp n).2 (pow_nonneg hs n)

/-- Given the finite first-hit convolution, its discounted generating functions factor
at every 0 ≤ s < 1. This includes the zero-time coefficient. -/
theorem discounted_renewal {s : ℝ} (hs : 0 ≤ s) (hs' : s < 1)
    (hit ret walk : ℕ → ℝ) (hh : ∀ n, hit n ∈ Set.Icc 0 1) (hr : ∀ n, ret n ∈ Set.Icc 0 1)
    (hconv : ∀ n, walk n = ∑ k ∈ Finset.range (n+1), hit k * ret (n-k)) :
    (∑' n, s^n * walk n) = (∑' n, s^n * hit n) * (∑' n, s^n * ret n) := by
  rw [tsum_mul_tsum_eq_tsum_sum_range_of_summable_norm
    (discounted_summable hs hs' hit hh) (discounted_summable hs hs' ret hr)]
  apply tsum_congr
  intro n
  rw [hconv, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro k hk
  have hkn : k ≤ n := Nat.le_of_lt_succ (Finset.mem_range.mp hk)
  calc
    _ = (s^(k+(n-k))) * (hit k * ret (n-k)) := by rw [Nat.add_sub_of_le hkn]
    _ = _ := by rw [pow_add]; ring

end DiffusionDiscount
