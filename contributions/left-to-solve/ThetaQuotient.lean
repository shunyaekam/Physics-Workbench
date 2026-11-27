import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

namespace OMA.CHSHArithmetic

noncomputable def G (t : ℝ) : ℝ :=
  ∑' n : ℤ, Real.exp (-Real.pi * t * (n : ℝ) ^ 2)

theorem gaussianScale : G (1 / 2) = Real.sqrt 2 * G 2 := by
  have h := Real.tsum_exp_neg_mul_int_sq (a := (2 : ℝ)) (by norm_num)
  rw [← Real.sqrt_eq_rpow] at h
  have shift : -Real.pi / 2 = -Real.pi * (1 / 2) := by ring
  rw [shift] at h
  change G 2 = 1 / Real.sqrt 2 * G (1 / 2) at h
  rw [h]
  have hp : Real.sqrt 2 ≠ 0 := by positivity
  field_simp

theorem quotient_of_parity (hpos : 0 < G 2)
    (hparity : G 1 ^ 2 = G 2 ^ 2 + (G (1 / 2) - G 2) ^ 2) :
    (G 2 / G 1) ^ 2 = (2 + Real.sqrt 2) / 4 := by
  have hr : Real.sqrt 2 ^ 2 = 2 := Real.sq_sqrt (by norm_num)
  rw [gaussianScale] at hparity
  have hpos₁ : 0 < G 1 ^ 2 := by
    rw [hparity]
    positivity
  rw [div_pow]
  apply (div_eq_iff (ne_of_gt hpos₁)).2
  rw [hparity]
  linear_combination (-(Real.sqrt 2) * (G 2) ^ 2 / 4) * hr



noncomputable def mass (t : ℝ) (n : ℤ) : ℝ :=
  Real.exp (-Real.pi * t * (n : ℝ) ^ 2)

theorem summableMass {t : ℝ} (ht : 0 < t) : Summable (mass t) := by
  have hc : 0 < Real.pi * t := mul_pos Real.pi_pos ht
  have hs : Summable fun n : ℕ => mass t (n : ℤ) := by
    apply Summable.of_nonneg_of_le (fun _ => (Real.exp_pos _).le) _
      (summable_geometric_of_lt_one (Real.exp_pos (-(Real.pi * t))).le
        (Real.exp_lt_one_iff.mpr (neg_lt_zero.mpr hc)))
    intro n
    rw [← Real.exp_nat_mul]
    apply Real.exp_le_exp.mpr
    simp only [Int.cast_natCast]
    have hn : (n : ℝ) ≤ (n : ℝ) ^ 2 := by exact_mod_cast Nat.le_self_pow (by decide : 2 ≠ 0) n
    nlinarith [mul_nonneg hc.le (sub_nonneg.mpr hn)]
  apply summable_int_iff_summable_nat_and_neg.mpr
  exact ⟨hs, by simpa [mass] using hs⟩

theorem G_pos {t : ℝ} (ht : 0 < t) : 0 < G t :=
  (summableMass ht).tsum_pos (fun _ => (Real.exp_pos _).le) 0 (Real.exp_pos _)

def parityZ : ℤ ⊕ ℤ ≃ ℤ where
  toFun := Sum.elim (fun j => 2*j) (fun j => 2*j+1)
  invFun := fun n => if n % 2 = 0 then Sum.inl (n/2) else Sum.inr (n/2)
  left_inv := by
    intro x
    cases x <;> simp [Sum.elim] <;> omega
  right_inv := by
    intro n
    dsimp only
    split <;> simp only [Sum.elim_inl, Sum.elim_inr] <;> omega

def parityPlane : (ℤ × ℤ) ⊕ (ℤ × ℤ) ≃ ℤ × ℤ where
  toFun := Sum.elim (fun p => (p.1+p.2, p.1-p.2))
    (fun p => (p.1+p.2+1, p.1-p.2))
  invFun := fun p => if (p.1+p.2) % 2 = 0 then
    Sum.inl ((p.1+p.2)/2,(p.1-p.2)/2)
    else Sum.inr ((p.1+p.2)/2,(p.1-p.2)/2)
  left_inv := by
    rintro (⟨i,j⟩ | ⟨i,j⟩) <;> dsimp
    all_goals split <;> try simp only [Sum.inl.injEq, Sum.inr.injEq, Prod.mk.injEq] <;>
      first | omega | constructor <;> omega
    all_goals exfalso <;> omega
  right_inv := by
    rintro ⟨i,j⟩
    dsimp
    split <;> simp only [Sum.elim_inl, Sum.elim_inr, Prod.mk.injEq] <;> constructor <;> omega

noncomputable def oddMass (n : ℤ) := mass (1/2) (2*n+1)

theorem evenMass_eq (n : ℤ) : mass (1/2) (2*n) = mass 2 n := by
  unfold mass
  congr 1
  push_cast
  ring

theorem summableOdd : Summable oddMass := by
  exact (summableMass (by norm_num : 0 < (1/2:ℝ))).comp_injective
    (i := fun n : ℤ => 2*n+1) (fun x y h => by change 2*x+1=2*y+1 at h; omega)

theorem G_split : G (1/2) = G 2 + ∑' n, oddMass n := by
  change (∑' n : ℤ, mass (1/2) n) = _
  rw [← parityZ.tsum_eq]
  let f := fun n : ℤ ⊕ ℤ => mass (1/2) (parityZ n)
  change (∑' n, f n) = _
  have hl : Summable (f ∘ Sum.inl) := by
    change Summable (fun n : ℤ => mass (1/2) (2*n))
    simp only [evenMass_eq]
    exact summableMass (by norm_num)
  rw [Summable.tsum_sum hl (show Summable (f ∘ Sum.inr) from summableOdd)]
  change (∑' n : ℤ, mass (1/2) (2*n)) + _ = _
  simp only [evenMass_eq]
  rfl

theorem tsum_square (f : ℤ → ℝ) (hf : Summable f) (hn : 0 ≤ f) :
    (∑' i, f i)^2 = ∑' p : ℤ × ℤ, f p.1 * f p.2 := by
  rw [pow_two]
  exact hf.tsum_mul_tsum hf (hf.mul_of_nonneg hf hn hn)

theorem parity_mass_left (p : ℤ × ℤ) :
    mass 1 (parityPlane (Sum.inl p)).1 * mass 1 (parityPlane (Sum.inl p)).2 =
      mass 2 p.1 * mass 2 p.2 := by
  simp only [mass, parityPlane, Equiv.coe_fn_mk, Sum.elim_inl, ← Real.exp_add]
  congr 1
  push_cast
  ring

theorem parity_mass_right (p : ℤ × ℤ) :
    mass 1 (parityPlane (Sum.inr p)).1 * mass 1 (parityPlane (Sum.inr p)).2 =
      oddMass p.1 * oddMass p.2 := by
  simp only [oddMass, mass, parityPlane, Equiv.coe_fn_mk, Sum.elim_inr, ← Real.exp_add]
  congr 1
  push_cast
  ring

theorem G_parity : G 1 ^ 2 = G 2 ^ 2 + (G (1 / 2) - G 2) ^ 2 := by
  rw [G_split, add_sub_cancel_left]
  change (∑' i, mass 1 i)^2 = (∑' i, mass 2 i)^2 + (∑' i, oddMass i)^2
  have hpos (t : ℝ) : 0 ≤ mass t := fun n => (Real.exp_pos _).le
  have ho : 0 ≤ oddMass := fun n => (Real.exp_pos _).le
  have h₂ := summableMass (by norm_num : 0 < (2:ℝ))
  rw [tsum_square _ (summableMass (by norm_num : 0 < (1:ℝ))) (hpos 1),
    tsum_square _ h₂ (hpos 2), tsum_square _ summableOdd ho, ← parityPlane.tsum_eq]
  let f := fun p : (ℤ × ℤ) ⊕ (ℤ × ℤ) =>
    mass 1 (parityPlane p).1 * mass 1 (parityPlane p).2
  change (∑' p, f p) = _
  have hl : Summable (f ∘ Sum.inl) := by
    simpa [f, Function.comp_def, parity_mass_left] using h₂.mul_of_nonneg h₂ (hpos 2) (hpos 2)
  have hr : Summable (f ∘ Sum.inr) := by
    simpa [f, Function.comp_def, parity_mass_right] using summableOdd.mul_of_nonneg summableOdd ho ho
  rw [Summable.tsum_sum hl hr]
  simp only [f, parity_mass_left, parity_mass_right]

theorem thetaQuotient : (G 2 / G 1)^2 = (2 + Real.sqrt 2) / 4 :=
  quotient_of_parity (G_pos (by norm_num)) G_parity

end OMA.CHSHArithmetic

#print axioms OMA.CHSHArithmetic.thetaQuotient
