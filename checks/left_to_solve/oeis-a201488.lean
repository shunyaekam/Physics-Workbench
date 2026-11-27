import OMAStatements.S_oeis_a201488

namespace OMA.S_oeis_a201488


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


lemma index_injective {m : ℕ} (hm : 0 < m) :
    Function.Injective (fun j : ℕ => m * j ^ 2) := by
  intro x y h
  have hh := Nat.eq_of_mul_eq_mul_left hm h
  exact (Nat.pow_left_injective (by decide : 2 ≠ 0)) hh

lemma coeff_zero (m : ℕ) : PowerSeries.coeff 0 (thetaSeries m) = 1 := by
  simp [thetaSeries]

lemma coeff_hit {m : ℕ} (hm : 0 < m) (k : ℕ) :
    PowerSeries.coeff (m*(k+1)^2) (thetaSeries m) = 2 := by
  have hpos : 0 < m*(k+1)^2 := by positivity
  simp only [thetaSeries, PowerSeries.coeff_mk, if_neg (ne_of_gt hpos), zero_add]
  rw [Finset.sum_eq_single k]
  · simp
  · intro j hj hne
    apply if_neg
    intro he
    have := index_injective hm he
    omega
  · intro h
    exfalso
    have hle : (k+1)^2 ≤ m*(k+1)^2 := by nlinarith
    have hk : k < (k+1)^2 := by nlinarith
    exact h (Finset.mem_range.mpr (lt_of_lt_of_le hk hle))

lemma coeff_miss {m n : ℕ} (hn : n ≠ 0) (h : ∀ j : ℕ, m*(j+1)^2 ≠ n) :
    PowerSeries.coeff n (thetaSeries m) = 0 := by
  simp [thetaSeries, hn, h]

lemma theta_bound {m : ℕ} (hm : 0 < m) (n : ℕ) :
    |PowerSeries.coeff n (thetaSeries m)| ≤ 2 := by
  by_cases hn : n = 0
  · rw [hn, coeff_zero]; norm_num
  · by_cases h : ∃ j, m*(j+1)^2=n
    · obtain ⟨j,rfl⟩ := h
      rw [coeff_hit hm]; norm_num
    · push_neg at h
      rw [coeff_miss hn h]; norm_num

noncomputable def invTheta := PowerSeries.invOfUnit (thetaSeries 1) (1 : ℤˣ)

lemma inv_bound (n : ℕ) : |PowerSeries.coeff n invTheta| ≤ (3 : ℤ)^n := by
  induction n using Nat.strong_induction_on with
  | h n ih =>
    by_cases hz : n = 0
    · subst n
      simp [invTheta, PowerSeries.coeff_invOfUnit]
    · let F (p : ℕ × ℕ) : ℤ := if p.2 < n then
          PowerSeries.coeff p.1 (thetaSeries 1) * PowerSeries.coeff p.2 invTheta else 0
      have idx : PowerSeries.coeff n invTheta = -(∑ p ∈ Finset.HasAntidiagonal.antidiagonal n, F p) := by
        rw [invTheta, PowerSeries.coeff_invOfUnit]
        simp only [if_neg hz, inv_one, Units.val_one, neg_one_mul]
        rfl
      rw [idx, abs_neg, ← Finset.Nat.sum_antidiagonal_swap (f := F), Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk]
      rw [Finset.sum_range_succ]
      simp only [F, Prod.swap, lt_irrefl, if_false, add_zero]
      calc
        _ ≤ ∑ i ∈ Finset.range n, |if i < n then PowerSeries.coeff (n-i) (thetaSeries 1) *
              PowerSeries.coeff i invTheta else 0| := Finset.abs_sum_le_sum_abs _ _
        _ ≤ ∑ i ∈ Finset.range n, 2*(3:ℤ)^i := by
          apply Finset.sum_le_sum
          intro i hi
          have hlt := Finset.mem_range.mp hi
          rw [if_pos hlt, abs_mul]
          exact mul_le_mul (theta_bound (by decide) _) (ih i hlt) (abs_nonneg _) (by norm_num)
        _ ≤ (3:ℤ)^n := by
          rw [← Finset.mul_sum]
          have hg := geom_sum_mul (3:ℤ) n
          linarith


noncomputable def nome := Real.exp (-Real.pi)
noncomputable def weight (f : PowerSeries ℤ) (n : ℕ) : ℝ :=
  ((PowerSeries.coeff (R := ℤ) n f : ℤ) : ℝ) * nome ^ n

lemma smallNome : 3 * nome < 1 := by
  have h : 3 < Real.exp Real.pi := by
    have he := Real.add_one_lt_exp (ne_of_gt Real.pi_pos)
    linarith [Real.pi_gt_three]
  rw [nome, Real.exp_neg, ← div_eq_mul_inv, div_lt_one (Real.exp_pos _)]
  exact h

lemma inv_summable : Summable (weight invTheta) := by
  apply Summable.of_norm
  apply Summable.of_nonneg_of_le (fun _ => norm_nonneg _) _
    (summable_geometric_of_lt_one (by positivity : 0 ≤ 3 * Real.exp (-Real.pi)) smallNome)
  intro n
  rw [Real.norm_eq_abs, weight, nome, abs_mul, abs_of_nonneg (pow_nonneg (Real.exp_pos _).le _), mul_pow]
  apply mul_le_mul_of_nonneg_right _ (pow_nonneg (Real.exp_pos _).le _)
  exact_mod_cast inv_bound n

lemma weight_mul (f g : PowerSeries ℤ) (n : ℕ) :
    weight (f*g) n = ∑ p ∈ Finset.HasAntidiagonal.antidiagonal n, weight f p.1 * weight g p.2 := by
  simp only [weight, PowerSeries.coeff_mul, Int.cast_sum, Int.cast_mul, Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro p hp
  rw [← Finset.HasAntidiagonal.mem_antidiagonal.mp hp, pow_add]
  ring

lemma hasSum_product {f g : PowerSeries ℤ} {F G : ℝ}
    (hf : HasSum (weight f) F) (hg : HasSum (weight g) G) :
    HasSum (weight (f * g)) (F*G) := by
  have ha := hf.summable.norm
  have hb := hg.summable.norm
  have hs := (summable_sum_mul_antidiagonal_of_summable_norm' ha hf.summable hb hg.summable).hasSum
  rw [← tsum_mul_tsum_eq_tsum_sum_antidiagonal_of_summable_norm ha hb, hf.tsum_eq, hg.tsum_eq] at hs
  exact hs.congr_fun (weight_mul f g)

lemma one_eval : HasSum (weight 1) 1 := by
  convert hasSum_ite_eq (0:ℕ) (1:ℝ) using 1
  ext n
  rcases n with _ | n <;> simp [weight, PowerSeries.coeff_one]



lemma nome_mass (m n : ℕ) : nome ^ (m * n^2) = mass m (n : ℤ) := by
  rw [nome, ← Real.exp_nat_mul, mass]
  congr 1
  push_cast
  ring

lemma theta_eval {m : ℕ} (hm : 0 < m) : HasSum (weight (thetaSeries m)) (G m) := by
  have hpos : 0 < (m : ℝ) := by exact_mod_cast hm
  have hg : HasSum (mass (m:ℝ)) (G m) := (summableMass hpos).hasSum
  have hzero : HasSum (fun n : ℕ => if n = 0 then (1:ℝ) else 0) 1 := by
    simpa [eq_comm] using (hasSum_ite_eq 0 (1:ℝ))
  have h := hg.nat_add_neg.sub hzero
  have hz : mass (m:ℝ) 0 = 1 := by simp [mass]
  have hc : PowerSeries.constantCoeff (thetaSeries m) = 1 :=
    (PowerSeries.coeff_zero_eq_constantCoeff_apply _).symm.trans (coeff_zero m)
  rw [hz, add_sub_cancel_right] at h
  apply (index_injective hm).hasSum_iff _ |>.mp
  · apply h.congr_fun
    intro n
    cases n with
    | zero => simp [Function.comp, weight, coeff_zero, hc, hz]
    | succ n =>
      change weight (thetaSeries m) (m*(n+1)^2) = _
      rw [weight, coeff_hit hm, nome_mass]
      simp [mass]
      ring
  · intro x hx
    have hn : x ≠ 0 := by
      rintro rfl
      exact hx ⟨0, by simp⟩
    have hmiss (j : ℕ) : m*(j+1)^2 ≠ x := fun h => hx ⟨j+1,h⟩
    simp [weight, coeff_miss hn hmiss]

lemma inv_eval : HasSum (weight invTheta) (1/G 1) := by
  let a := ∑' n, weight invTheta n
  have ha : HasSum (weight invTheta) a := inv_summable.hasSum
  have mult := hasSum_product (theta_eval (m:=1) (by decide)) ha
  have eqone : thetaSeries 1 * invTheta = 1 := by
    apply PowerSeries.mul_invOfUnit
    rw [← PowerSeries.coeff_zero_eq_constantCoeff_apply, coeff_zero]
    rfl
  rw [eqone] at mult
  have hx := mult.unique one_eval
  norm_num only [Nat.cast_one] at hx
  have hn := (G_pos (t:=1) (by norm_num)).ne'
  have hval : a = 1 / G 1 := (eq_div_iff hn).2 ((mul_comm a (G 1)).trans hx)
  exact hval ▸ ha

theorem chsh_series : HasSum (fun n : ℕ => (a210066 n : ℝ) * Real.exp (-Real.pi)^n)
    ((2 + Real.sqrt 2)/4) := by
  have h := hasSum_product (theta_eval (m:=2) (by decide)) inv_eval
  norm_num only [Nat.cast_ofNat] at h
  have hh := hasSum_product h h
  rw [← pow_two, ← pow_two, one_div, ← div_eq_mul_inv, thetaQuotient] at hh
  exact hh


end OMA.S_oeis_a201488

theorem OMA.solution : type_of% @OMA.S_oeis_a201488.main := OMA.S_oeis_a201488.chsh_series
