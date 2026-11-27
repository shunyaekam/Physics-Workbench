import OMAReductions.R_MonochromaticQuantumGraph_eqSystem6_no_solution_ge3_R1

open MonochromaticQuantumGraph

namespace OORaw

def left : Fin 15 → Fin 6 := ![0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4]
def right : Fin 15 → Fin 6 := ![1, 2, 3, 4, 5, 2, 3, 4, 5, 3, 4, 5, 4, 5, 5]
def edgeFor : Fin 15 → Fin 3 → Fin 15 := ![![0, 9, 14], ![0, 10, 13], ![0, 11, 12], ![1, 6, 14], ![1, 7, 13], ![1, 8, 12], ![2, 5, 14], ![2, 7, 11], ![2, 8, 10], ![3, 5, 13], ![3, 6, 11], ![3, 8, 9], ![4, 5, 12], ![4, 6, 10], ![4, 7, 9]]

structure Support where
  S : Fin 3 → Fin 15 → Prop
  T : Fin 3 → Fin 15 → Prop
  P : Fin 3 → Fin 15 → Prop
  has_matching : ∀ c, ∃ m, P c m
  active_support : ∀ c e, T c e → S c e
  active_private : ∀ c d e, c ≠ d → T c e → ¬ S d e
  matching_support : ∀ c m j, P c m → S c (edgeFor m j)
  cut : ∀ c (x : Fin 6 → ℤ), (∑ v, x v) ≠ 0 →
    ∃ e, T c e ∧ x (left e) + x (right e) ≠ 0
  rainbow : ∀ m (k : Fin 3 → Fin 3), Function.Injective k →
    ¬ (∀ j : Fin 3, S (k j) (edgeFor m j))
  avoid : ∀ c d e, c ≠ d → S d e →
    ∃ m, P c m ∧ ∀ j : Fin 3, edgeFor m j ≠ e

end OORaw

namespace OORaw

noncomputable section

open MonochromaticQuantumGraph

def weight (W : WeightsN 6 3 ℂ) (c : Fin 3) (e : Fin 15) : ℂ :=
  W (mkEdge (left e) (right e) c c)

def term (g : Fin 15 → ℂ) (m : Fin 15) : ℂ :=
  g (edgeFor m 0) * g (edgeFor m 1) * g (edgeFor m 2)

def poly (g : Fin 15 → ℂ) : ℂ :=
  g 0 * g 9 * g 14 + g 0 * g 10 * g 13 + g 0 * g 11 * g 12 + g 1 * g 6 * g 14 + g 1 * g 7 * g 13 + g 1 * g 8 * g 12 + g 2 * g 5 * g 14 + g 2 * g 7 * g 11 + g 2 * g 8 * g 10 + g 3 * g 5 * g 13 + g 3 * g 6 * g 11 + g 3 * g 8 * g 9 + g 4 * g 5 * g 12 + g 4 * g 6 * g 10 + g 4 * g 7 * g 9

def minor (g : Fin 15 → ℂ) : Fin 15 → ℂ :=
  ![g 9 * g 14 + g 10 * g 13 + g 11 * g 12, g 6 * g 14 + g 7 * g 13 + g 8 * g 12, g 5 * g 14 + g 7 * g 11 + g 8 * g 10, g 5 * g 13 + g 6 * g 11 + g 8 * g 9, g 5 * g 12 + g 6 * g 10 + g 7 * g 9, g 2 * g 14 + g 3 * g 13 + g 4 * g 12, g 1 * g 14 + g 3 * g 11 + g 4 * g 10, g 1 * g 13 + g 2 * g 11 + g 4 * g 9, g 1 * g 12 + g 2 * g 10 + g 3 * g 9, g 0 * g 14 + g 3 * g 8 + g 4 * g 7, g 0 * g 13 + g 2 * g 8 + g 4 * g 6, g 0 * g 12 + g 2 * g 7 + g 3 * g 6, g 0 * g 11 + g 1 * g 8 + g 4 * g 5, g 0 * g 10 + g 1 * g 7 + g 3 * g 5, g 0 * g 9 + g 1 * g 6 + g 2 * g 5]


def chrom (W : WeightsN 6 3 ℂ) (σ : Fin 6 → Fin 3) (e : Fin 15) : ℂ :=
  if σ (left e) = σ (right e) then weight W (σ (left e)) e else 0

def Diag (W : WeightsN 6 3 ℂ) : Prop :=
  ∀ e : EdgeN 6 3, e.u < e.v → e.i ≠ e.j → W e = 0

lemma expand (W : WeightsN 6 3 ℂ) (σ : Fin 6 → Fin 3) :
    pmSumN 6 3 W σ =
      poly (fun e => W (mkEdge (left e) (right e) (σ (left e)) (σ (right e)))) := by
  let g : Fin 15 → ℂ := fun e => W (mkEdge (left e) (right e) (σ (left e)) (σ (right e)))

  change g 0 * (g 9 * (g 14 * (1) + (0)) + (g 10 * (g 13 * (1) + (0)) + (g 11 * (g 12 * (1) + (0)) + (0)))) + (g 1 * (g 6 * (g 14 * (1) + (0)) + (g 7 * (g 13 * (1) + (0)) + (g 8 * (g 12 * (1) + (0)) + (0)))) + (g 2 * (g 5 * (g 14 * (1) + (0)) + (g 7 * (g 11 * (1) + (0)) + (g 8 * (g 10 * (1) + (0)) + (0)))) + (g 3 * (g 5 * (g 13 * (1) + (0)) + (g 6 * (g 11 * (1) + (0)) + (g 8 * (g 9 * (1) + (0)) + (0)))) + (g 4 * (g 5 * (g 12 * (1) + (0)) + (g 6 * (g 10 * (1) + (0)) + (g 7 * (g 9 * (1) + (0)) + (0)))) + (0))))) = poly g
  unfold poly
  ring


lemma equation (W : WeightsN 6 3 ℂ) (hd : Diag W) (hw : EqSystemN 6 3 W)
    (σ : Fin 6 → Fin 3) : poly (chrom W σ) = if allEqual σ then 1 else 0 := by
  have h := hw σ
  rw [expand] at h
  have hg : chrom W σ =
      (fun e => W (mkEdge (left e) (right e) (σ (left e)) (σ (right e)))) := by
    funext e
    by_cases he : σ (left e) = σ (right e)
    · simp only [chrom, if_pos he, weight, he]
    · have hlt : ∀ k : Fin 15, left k < right k := by decide
      exact (if_neg he).trans (hd _ (hlt e) he).symm
  rwa [hg]

lemma normal (W : WeightsN 6 3 ℂ) (hd : Diag W) (hw : EqSystemN 6 3 W) (c : Fin 3) :
    poly (weight W c) = 1 := by
  have he := equation W hd hw (fun _ => c)
  simpa [chrom, allEqual, allEqualList, vertices] using he

lemma mono_sum (g : Fin 15 → ℂ) : poly g = ∑ m, term g m := by
  simp [poly, term, edgeFor, Fin.sum_univ_succ] <;> ring

set_option maxHeartbeats 2000000 in
lemma incidence_sum (g : Fin 15 → ℂ) (x : Fin 6 → ℂ) :
    (∑ v, x v) * poly g =
      ∑ e, (x (left e) + x (right e)) * (g e * minor g e) := by
  simp [Fin.sum_univ_succ, left, right, minor, poly] <;> ring

set_option maxHeartbeats 3000000 in
lemma outside_sum (g : Fin 15 → ℂ) (e : Fin 15) :
    poly g = g e * minor g e +
      ∑ m : Fin 15, if ∀ j : Fin 3, edgeFor m j ≠ e then term g m else 0 := by
  fin_cases e <;>
    simp [Fin.sum_univ_succ, Fin.forall_fin_succ, term, edgeFor, minor, poly] <;> ring


lemma mixed (W : WeightsN 6 3 ℂ) (hd : Diag W) (hw : EqSystemN 6 3 W)
    (c d : Fin 3) (hcd : c ≠ d) (e : Fin 15) :
    weight W d e * minor (weight W c) e = 0 := by
  have hdc : d ≠ c := Ne.symm hcd
  fin_cases e
  · have he := equation W hd hw (![d, d, c, c, c, c])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 0 * (weight W c 9 * weight W c 14 + weight W c 10 * weight W c 13 + weight W c 11 * weight W c 12) = 0
    linear_combination he
  · have he := equation W hd hw (![d, c, d, c, c, c])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 1 * (weight W c 6 * weight W c 14 + weight W c 7 * weight W c 13 + weight W c 8 * weight W c 12) = 0
    linear_combination he
  · have he := equation W hd hw (![d, c, c, d, c, c])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 2 * (weight W c 5 * weight W c 14 + weight W c 7 * weight W c 11 + weight W c 8 * weight W c 10) = 0
    linear_combination he
  · have he := equation W hd hw (![d, c, c, c, d, c])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 3 * (weight W c 5 * weight W c 13 + weight W c 6 * weight W c 11 + weight W c 8 * weight W c 9) = 0
    linear_combination he
  · have he := equation W hd hw (![d, c, c, c, c, d])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 4 * (weight W c 5 * weight W c 12 + weight W c 6 * weight W c 10 + weight W c 7 * weight W c 9) = 0
    linear_combination he
  · have he := equation W hd hw (![c, d, d, c, c, c])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 5 * (weight W c 2 * weight W c 14 + weight W c 3 * weight W c 13 + weight W c 4 * weight W c 12) = 0
    linear_combination he
  · have he := equation W hd hw (![c, d, c, d, c, c])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 6 * (weight W c 1 * weight W c 14 + weight W c 3 * weight W c 11 + weight W c 4 * weight W c 10) = 0
    linear_combination he
  · have he := equation W hd hw (![c, d, c, c, d, c])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 7 * (weight W c 1 * weight W c 13 + weight W c 2 * weight W c 11 + weight W c 4 * weight W c 9) = 0
    linear_combination he
  · have he := equation W hd hw (![c, d, c, c, c, d])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 8 * (weight W c 1 * weight W c 12 + weight W c 2 * weight W c 10 + weight W c 3 * weight W c 9) = 0
    linear_combination he
  · have he := equation W hd hw (![c, c, d, d, c, c])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 9 * (weight W c 0 * weight W c 14 + weight W c 3 * weight W c 8 + weight W c 4 * weight W c 7) = 0
    linear_combination he
  · have he := equation W hd hw (![c, c, d, c, d, c])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 10 * (weight W c 0 * weight W c 13 + weight W c 2 * weight W c 8 + weight W c 4 * weight W c 6) = 0
    linear_combination he
  · have he := equation W hd hw (![c, c, d, c, c, d])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 11 * (weight W c 0 * weight W c 12 + weight W c 2 * weight W c 7 + weight W c 3 * weight W c 6) = 0
    linear_combination he
  · have he := equation W hd hw (![c, c, c, d, d, c])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 12 * (weight W c 0 * weight W c 11 + weight W c 1 * weight W c 8 + weight W c 4 * weight W c 5) = 0
    linear_combination he
  · have he := equation W hd hw (![c, c, c, d, c, d])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 13 * (weight W c 0 * weight W c 10 + weight W c 1 * weight W c 7 + weight W c 3 * weight W c 5) = 0
    linear_combination he
  · have he := equation W hd hw (![c, c, c, c, d, d])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, hcd, hdc] at he
    change weight W d 14 * (weight W c 0 * weight W c 9 + weight W c 1 * weight W c 6 + weight W c 2 * weight W c 5) = 0
    linear_combination he

lemma rainbow_zero (W : WeightsN 6 3 ℂ) (hd : Diag W) (hw : EqSystemN 6 3 W)
    (m : Fin 15) (k : Fin 3 → Fin 3) (hk : Function.Injective k) :
    weight W (k 0) (edgeFor m 0) * weight W (k 1) (edgeFor m 1) *
      weight W (k 2) (edgeFor m 2) = 0 := by
  have h01 : k 0 ≠ k 1 := fun h => (by decide : (0 : Fin 3) ≠ 1) (hk h)
  have h02 : k 0 ≠ k 2 := fun h => (by decide : (0 : Fin 3) ≠ 2) (hk h)
  have h12 : k 1 ≠ k 2 := fun h => (by decide : (1 : Fin 3) ≠ 2) (hk h)
  fin_cases m
  · have he := equation W hd hw (![k 0, k 0, k 1, k 1, k 2, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 0 * weight W (k 1) 9 * weight W (k 2) 14 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 0, k 1, k 2, k 1, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 0 * weight W (k 1) 10 * weight W (k 2) 13 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 0, k 1, k 2, k 2, k 1])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 0 * weight W (k 1) 11 * weight W (k 2) 12 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 1, k 0, k 1, k 2, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 1 * weight W (k 1) 6 * weight W (k 2) 14 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 1, k 0, k 2, k 1, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 1 * weight W (k 1) 7 * weight W (k 2) 13 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 1, k 0, k 2, k 2, k 1])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 1 * weight W (k 1) 8 * weight W (k 2) 12 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 1, k 1, k 0, k 2, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 2 * weight W (k 1) 5 * weight W (k 2) 14 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 1, k 2, k 0, k 1, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 2 * weight W (k 1) 7 * weight W (k 2) 11 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 1, k 2, k 0, k 2, k 1])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 2 * weight W (k 1) 8 * weight W (k 2) 10 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 1, k 1, k 2, k 0, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 3 * weight W (k 1) 5 * weight W (k 2) 13 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 1, k 2, k 1, k 0, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 3 * weight W (k 1) 6 * weight W (k 2) 11 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 1, k 2, k 2, k 0, k 1])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 3 * weight W (k 1) 8 * weight W (k 2) 9 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 1, k 1, k 2, k 2, k 0])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 4 * weight W (k 1) 5 * weight W (k 2) 12 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 1, k 2, k 1, k 2, k 0])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 4 * weight W (k 1) 6 * weight W (k 2) 10 = 0
    linear_combination he
  · have he := equation W hd hw (![k 0, k 1, k 2, k 2, k 1, k 0])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 4 * weight W (k 1) 7 * weight W (k 2) 9 = 0
    linear_combination he

lemma from_physical (W : WeightsN 6 3 ℂ) (hd : Diag W)
    (hw : EqSystemN 6 3 W) : Nonempty Support := by
  classical
  let g := weight W
  have hnorm (c) : poly (g c) = 1 := normal W hd hw c
  refine ⟨{
    S := fun c e => g c e ≠ 0
    T := fun c e => g c e * minor (g c) e ≠ 0
    P := fun c m => term (g c) m ≠ 0
    has_matching := ?_
    active_support := ?_
    active_private := ?_
    matching_support := ?_
    cut := ?_
    rainbow := ?_
    avoid := ?_
  }⟩
  · intro c
    by_contra! h
    have hn := hnorm c
    rw [mono_sum] at hn
    simp [h] at hn
  · intro c e h he
    exact h (by rw [he, zero_mul])
  · intro c d e hcd ht hs
    have hminor := (mul_eq_zero.mp (mixed W hd hw c d hcd e)).resolve_left hs
    exact ht (by rw [hminor, mul_zero])
  · intro c m j h he
    fin_cases j <;> apply h <;> simp [term, he]
  · intro c x hx
    by_contra! hh
    have z (e : Fin 15) :
        ((x (left e) : ℂ) + (x (right e) : ℂ)) * (g c e * minor (g c) e) = 0 := by
      by_cases ht : g c e * minor (g c) e = 0
      · simp [ht]
      · have he : x (left e) + x (right e) = 0 := hh e ht
        have he' : (x (left e) : ℂ) + (x (right e) : ℂ) = 0 := by exact_mod_cast he
        simp [he']
    have h := incidence_sum (g c) (fun v => (x v : ℂ))
    simp only [z, Finset.sum_const_zero, hnorm, mul_one] at h
    exact hx (by exact_mod_cast h)
  · intro m k hk hs
    have hz := rainbow_zero W hd hw m k hk
    exact (mul_ne_zero (mul_ne_zero (hs 0) (hs 1)) (hs 2)) hz
  · intro c d e hcd hs
    by_contra! hh
    have hminor := (mul_eq_zero.mp (mixed W hd hw c d hcd e)).resolve_left hs
    have z (m : Fin 15) :
        (if ∀ j : Fin 3, edgeFor m j ≠ e then term (g c) m else 0) = 0 := by
      split_ifs with h
      · by_contra ht
        obtain ⟨j, hj⟩ := hh m ht
        exact h j hj
      · rfl
    have ho := outside_sum (g c) e
    simp only [z, Finset.sum_const_zero, hminor, mul_zero, add_zero] at ho
    have hn := hnorm c
    rw [ho] at hn
    exact zero_ne_one hn

end
end OORaw
