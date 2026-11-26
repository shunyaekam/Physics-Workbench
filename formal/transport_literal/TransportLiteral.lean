import Mathlib.Data.Real.Sqrt
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith

namespace TransportLiteral

/-- The three entries are ordered by the level pairs (0,9), (9,25), (0,25). -/
def fits (a b c e : ℝ) : Prop :=
  abs (|a - b| - 3) ≤ e ∧ abs (|b - c| - 4) ≤ e ∧ abs (|a - c| - 5) ≤ e

theorem squareRootCosts :
    Real.sqrt |(0 : ℝ) - 9| = 3 ∧ Real.sqrt |(9 : ℝ) - 25| = 4 ∧
      Real.sqrt |(0 : ℝ) - 25| = 5 := by
  norm_num [Real.sqrt_eq_iff_mul_self_eq]

/-- Singleton cuts with weights 2, 1, 3 separate each unequal pair twice. -/
def cut (site i j : Fin 3) : ℕ :=
  if (i = site ∧ j ≠ site) ∨ (j = site ∧ i ≠ site) then 1 else 0

def cutCost (i j : Fin 3) : ℕ := 2 * cut 0 i j + cut 1 i j + 3 * cut 2 i j

def level (i : Fin 3) : ℕ := if i = 0 then 0 else if i = 1 then 9 else 25

theorem cutRealization : ∀ i j : Fin 3, cutCost i j ^ 2 = (level i - level j) + (level j - level i) := by
  decide

/-- A scaled level projector at exponent one quarter contributes a fourth
root of its scalar spectral gap. -/
def spike (site : Fin 3) (height : ℝ) (i : Fin 3) : ℝ := if i = site then height else 0

noncomputable def quarterCost (f : Fin 3 → ℝ) (i j : Fin 3) : ℝ := Real.sqrt (Real.sqrt |f i - f j|)

theorem lowerExponentRealization (i j : Fin 3) :
    Real.sqrt |(level i : ℝ) - (level j : ℝ)| =
      quarterCost (spike 0 16) i j + quarterCost (spike 1 1) i j +
        quarterCost (spike 2 81) i j := by
  have three (n : Fin 3) : n = 0 ∨ n = 1 ∨ n = 2 := by omega
  have h02 : (0 : Fin 3) ≠ 2 := by decide
  have h12 : (1 : Fin 3) ≠ 2 := by decide
  have h01 : (0 : Fin 3) ≠ 1 := by decide
  have sqrt4 : Real.sqrt 4 = 2 := by norm_num [Real.sqrt_eq_iff_mul_self_eq]
  have sqrt9 : Real.sqrt 9 = 3 := by norm_num [Real.sqrt_eq_iff_mul_self_eq]
  have sqrt16 : Real.sqrt 16 = 4 := by norm_num [Real.sqrt_eq_iff_mul_self_eq]
  have sqrt25 : Real.sqrt 25 = 5 := by norm_num [Real.sqrt_eq_iff_mul_self_eq]
  have sqrt81 : Real.sqrt 81 = 9 := by norm_num [Real.sqrt_eq_iff_mul_self_eq]
  rcases three i with rfl | rfl | rfl <;> rcases three j with rfl | rfl | rfl <;>
    norm_num [level, quarterCost, spike, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12,
      sqrt4, sqrt9, sqrt16, sqrt25, sqrt81]

/-- On a line the distance between the extreme points is the sum of the two
other distances. Splitting on which of the three pairwise differences are
nonnegative avoids assuming that the new labels preserve the energy order. -/
private theorem between (a b c : ℝ) :
    |a - b| + |b - c| = |a - c| ∨ |a - b| + |a - c| = |b - c| ∨
      |b - c| + |a - c| = |a - b| := by
  have ha := abs_nonneg (a - b)
  have hb := abs_nonneg (b - c)
  have hc := abs_nonneg (a - c)
  rcases abs_choice (a - b) with ha' | ha' <;>
    rcases abs_choice (b - c) with hb' | hb' <;>
    rcases abs_choice (a - c) with hc' | hc' <;>
    first | left; linarith | right; left; linarith | right; right; linarith

/-- Every real-valued relabeling, including nonmonotone relabelings, incurs
at least two thirds of uniform error on the three off-diagonal pairs. -/
theorem lower (a b c e : ℝ) (h : fits a b c e) : (2 : ℝ) / 3 ≤ e := by
  obtain ⟨hab, hbc, hac⟩ := h
  obtain ⟨habl, habu⟩ := abs_le.mp hab
  obtain ⟨hbcl, hbcu⟩ := abs_le.mp hbc
  obtain ⟨hacl, hacu⟩ := abs_le.mp hac
  rcases between a b c with h | h | h <;> linarith

theorem attained : fits 0 (7 / 3) (17 / 3) (2 / 3) := by norm_num [fits, abs, max_def]

theorem noExactLine : ¬ ∃ a b c : ℝ, fits a b c 0 := by
  rintro ⟨a, b, c, h⟩
  have := lower a b c 0 h
  linarith

end TransportLiteral
