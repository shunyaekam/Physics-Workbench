import Mathlib.Data.Nat.Choose.Central
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity



/-!
These lemmas prove the scalar kernel comparison in Step 2 of `proof.md`
for `Erdos1164.erdos_1164.R1.H2.R1.H1`. The identification of the
central and displaced binomial expressions with random-walk probabilities
is a separate obligation.

Checked with Lean 4.19.0 (arm64-apple-darwin23.6.0, commit 6caaee842e94)
and Mathlib c44e0c8ee63ca166450922a373c7409c5d26b00b.
-/

namespace DiffusionBounds

/-- The one-dimensional probability of returning after (2n) steps. -/
noncomputable def centralMass (n : ℕ) : ℝ :=
  (n.centralBinom : ℝ) / (4 : ℝ)^n

theorem centralMass_succ (n : ℕ) :
    centralMass (n + 1) = ((2 * (n : ℝ) + 1) / (2 * n + 2)) * centralMass n := by
  have h : ((n : ℝ) + 1) * (Nat.centralBinom (n + 1) : ℝ) =
      2 * (2 * (n : ℝ) + 1) * (Nat.centralBinom n : ℝ) := by
    exact_mod_cast Nat.succ_mul_centralBinom_succ n
  simp only [centralMass, pow_succ]
  have h₁ : (2 * (n : ℝ) + 2) ≠ 0 := by positivity
  have h₂ : (4 : ℝ) ^ n ≠ 0 := by positivity
  field_simp [h₁, h₂]
  linear_combination (2 * (4 : ℝ) ^ n) * h

/-- Upper bound on the squared central probability appearing in the planar return kernel. -/
theorem centralMass_sq_le (n : ℕ) : centralMass n ^ 2 ≤ 1 / ((n : ℝ) + 1) := by
  induction n with
  | zero => norm_num [centralMass]
  | succ n ih =>
    rw [centralMass_succ, mul_pow]
    simp only [Nat.cast_succ]
    calc
      _ ≤ ((2 * (n : ℝ) + 1) / (2 * n + 2)) ^ 2 * (1 / ((n : ℝ) + 1)) :=
        mul_le_mul_of_nonneg_left ih (sq_nonneg _)
      _ ≤ _ := by
        have h₁ : 0 < (n : ℝ) + 1 := by positivity
        have h₂ : 0 < (n : ℝ) + 1 + 1 := by positivity
        have h₃ : 0 < (2 * (n : ℝ) + 2) ^ 2 := by positivity
        rw [div_pow, div_mul_div_comm]
        apply (div_le_div_iff₀ (mul_pos h₃ h₁) h₂).2
        have hn : 0 ≤ (n : ℝ) := Nat.cast_nonneg n
        nlinarith

/-- Lower bound on the squared central probability appearing in the planar return kernel. -/
theorem le_centralMass_sq (n : ℕ) (hn : 0 < n) :
    1 / (4 * (n : ℝ)) ≤ centralMass n ^ 2 := by
  induction n with
  | zero => omega
  | succ n ih =>
    by_cases h : n = 0
    · subst n
      norm_num [centralMass, Nat.centralBinom, Nat.choose]
    · have hpos : 0 < n := Nat.pos_of_ne_zero h
      have hnR : 0 < (n : ℝ) := by exact_mod_cast hpos
      rw [centralMass_succ, mul_pow]
      simp only [Nat.cast_succ]
      calc
        _ ≤ ((2 * (n : ℝ) + 1) / (2 * n + 2)) ^ 2 * (1 / (4 * (n : ℝ))) := by
          have h₁ : 0 < 4 * (n : ℝ) := by positivity
          have h₂ : 0 < 4 * ((n : ℝ) + 1) := by positivity
          have h₃ : 0 < (2 * (n : ℝ) + 2) ^ 2 := by positivity
          rw [div_pow, div_mul_div_comm]
          apply (div_le_div_iff₀ h₂ (mul_pos h₃ h₁)).2
          nlinarith
        _ ≤ _ := mul_le_mul_of_nonneg_left (ih hpos) (sq_nonneg _)

/-- At each even time, any displaced product kernel has mass at most the return kernel. -/
theorem displacedMass_sq_le (n k : ℕ) :
    (((2 * n).choose k : ℝ) / (4 : ℝ)^n) ^ 2 ≤ centralMass n ^ 2 := by
  have hChoose : ((2 * n).choose k : ℝ) ≤ (n.centralBinom : ℝ) := by
    exact_mod_cast Nat.choose_le_centralBinom k n
  have h₄ : 0 < (4 : ℝ)^n := by positivity
  have h : ((2 * n).choose k : ℝ) / (4 : ℝ)^n ≤ centralMass n :=
    (div_le_div_iff_of_pos_right h₄).2 hChoose
  have h₁ : 0 ≤ ((2 * n).choose k : ℝ) / (4 : ℝ)^n := by positivity
  have h₂ : 0 ≤ centralMass n := h₁.trans h
  nlinarith [mul_nonneg (sub_nonneg.mpr h) (add_nonneg h₂ h₁)]

end DiffusionBounds

#print axioms DiffusionBounds.centralMass_succ
#print axioms DiffusionBounds.centralMass_sq_le
#print axioms DiffusionBounds.le_centralMass_sq
#print axioms DiffusionBounds.displacedMass_sq_le
