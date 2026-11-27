import OMAReductions.R_MonochromaticQuantumGraph_eqSystem6_no_solution_ge3_R1

/-!
Six-party GHZ obstruction for complex-weighted monochromatic edges.
A monochromatic six-vertex matching has 15 terms. Expanding the mixed
2+4 and 2+2+2 colourings gives, respectively, private edge supports
and a forbidden three-colour perfect matching. The weighted incidence
identity forces supports to cross each signed cut with nonzero imbalance.
Three nonzero monochromatic matchings fall into eight orbits under
vertex and colour permutations. Seven contradict the constraints by
propositional propagation. In the eighth, the three share an edge;
mixed vanishing forces a different matching avoiding it. All finite
permutations, clauses and propagations are checked in Lean.

This restricted obstruction was known from Cervera-Lierta, Krenn and
Aspuru-Guzik, Quantum 6, 836 (2022), doi:10.22331/q-2022-10-13-836.
The unrestricted six-vertex certificate of algal (2026) gives a second
route to the underlying result. This file contributes a kernel proof of
the monochromatic-edge subtarget. Credit: @shunyaekam, oo research.
-/

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
    · simp [chrom, weight, he]
    · have hlt : ∀ k : Fin 15, left k < right k := by decide
      exact (if_neg he).trans (hd _ (hlt e) he).symm
  rwa [hg]

lemma normal (W : WeightsN 6 3 ℂ) (hd : Diag W) (hw : EqSystemN 6 3 W) (c : Fin 3) :
    poly (weight W c) = 1 := by
  have he := equation W hd hw (fun _ => c)
  have hs : chrom W (fun _ => c) = weight W c := by
    funext e
    simp [chrom]
  rw [hs] at he
  simpa [allEqual, allEqualList, vertices] using he

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
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 0, k 1, k 2, k 1, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 0 * weight W (k 1) 10 * weight W (k 2) 13 = 0
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 0, k 1, k 2, k 2, k 1])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 0 * weight W (k 1) 11 * weight W (k 2) 12 = 0
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 1, k 0, k 1, k 2, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 1 * weight W (k 1) 6 * weight W (k 2) 14 = 0
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 1, k 0, k 2, k 1, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 1 * weight W (k 1) 7 * weight W (k 2) 13 = 0
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 1, k 0, k 2, k 2, k 1])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 1 * weight W (k 1) 8 * weight W (k 2) 12 = 0
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 1, k 1, k 0, k 2, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 2 * weight W (k 1) 5 * weight W (k 2) 14 = 0
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 1, k 2, k 0, k 1, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 2 * weight W (k 1) 7 * weight W (k 2) 11 = 0
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 1, k 2, k 0, k 2, k 1])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 2 * weight W (k 1) 8 * weight W (k 2) 10 = 0
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 1, k 1, k 2, k 0, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 3 * weight W (k 1) 5 * weight W (k 2) 13 = 0
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 1, k 2, k 1, k 0, k 2])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 3 * weight W (k 1) 6 * weight W (k 2) 11 = 0
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 1, k 2, k 2, k 0, k 1])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 3 * weight W (k 1) 8 * weight W (k 2) 9 = 0
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 1, k 1, k 2, k 2, k 0])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 4 * weight W (k 1) 5 * weight W (k 2) 12 = 0
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 1, k 2, k 1, k 2, k 0])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 4 * weight W (k 1) 6 * weight W (k 2) 10 = 0
    simpa only [mul_eq_zero] using he
  · have he := equation W hd hw (![k 0, k 1, k 2, k 2, k 1, k 0])
    simp [chrom, poly, allEqual, allEqualList, vertices, left, right, h01, h02, h12, Ne.symm h01, Ne.symm h02, Ne.symm h12] at he
    change weight W (k 0) 4 * weight W (k 1) 7 * weight W (k 2) 9 = 0
    simpa only [mul_eq_zero] using he

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
    apply h
    fin_cases j
    · change g c (edgeFor m 0) = 0 at he
      simp [term, he]
    · change g c (edgeFor m 1) = 0 at he
      simp [term, he]
    · change g c (edgeFor m 2) = 0 at he
      simp [term, he]
  · intro c x hx
    apply Classical.byContradiction
    intro hh
    have z (e : Fin 15) :
        ((x (left e) : ℂ) + (x (right e) : ℂ)) * (g c e * minor (g c) e) = 0 := by
      by_cases ht : g c e * minor (g c) e = 0
      · simp [ht]
      · have he : x (left e) + x (right e) = 0 := Classical.byContradiction (fun he => hh ⟨e, ht, he⟩)
        have he' : (x (left e) : ℂ) + (x (right e) : ℂ) = 0 := by exact_mod_cast he
        simp [he']
    have h := incidence_sum (g c) (fun v => (x v : ℂ))
    simp only [z, Finset.sum_const_zero, hnorm, mul_one] at h
    exact hx (by exact_mod_cast h)
  · intro m k hk hs
    have hz := rainbow_zero W hd hw m k hk
    exact (mul_ne_zero (mul_ne_zero (hs 0) (hs 1)) (hs 2)) hz
  · intro c d e hcd hs
    apply Classical.byContradiction
    intro hh
    have hminor := (mul_eq_zero.mp (mixed W hd hw c d hcd e)).resolve_left hs
    have z (m : Fin 15) :
        (if ∀ j : Fin 3, edgeFor m j ≠ e then term (g c) m else 0) = 0 := by
      split_ifs with h
      · apply Classical.byContradiction
        intro ht
        exact hh ⟨m, ht, h⟩
      · rfl
    change minor (g c) e = 0 at hminor
    have ho := outside_sum (g c) e
    simp only [z, Finset.sum_const_zero, hminor, mul_zero, add_zero] at ho
    have hn := hnorm c
    rw [ho] at hn
    exact zero_ne_one hn

end
end OORaw



namespace Gamma

theorem branch0_0_0 (p : Nat → Prop)
    (b0 : p 91)
    (b1 : p 106)
    (b2 : p 121)
    (h46 : (¬ p 91) ∨ p 1)
    (h225 : (¬ p 106) ∨ p 25)
    (h404 : (¬ p 121) ∨ p 45)
    (h534 : (¬ p 1) ∨ (¬ p 25) ∨ (¬ p 45))
    : False := by
  classical
  have u1 : p 1 := Or.elim h46 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u25 : p 25 := Or.elim h225 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u45 : p 45 := Or.elim h404 (fun t => False.elim (t b2)) (fun r0 => r0)
  exact Or.elim h534 (fun t => (t u1)) (fun r0 => Or.elim r0 (fun t => (t u25)) (fun r1 => (r1 u45)))

theorem branch0_0_1 (p : Nat → Prop)
    (b0 : p 91)
    (b1 : p 106)
    (b2 : p 122)
    (h47 : (¬ p 91) ∨ p 10)
    (h226 : (¬ p 106) ∨ p 30)
    (h405 : (¬ p 122) ∨ p 31)
    (h537 : (¬ p 10) ∨ (¬ p 30) ∨ (¬ p 31))
    : False := by
  classical
  have u10 : p 10 := Or.elim h47 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u30 : p 30 := Or.elim h226 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u31 : p 31 := Or.elim h405 (fun t => False.elim (t b2)) (fun r0 => r0)
  exact Or.elim h537 (fun t => (t u10)) (fun r0 => Or.elim r0 (fun t => (t u30)) (fun r1 => (r1 u31)))

theorem branch0_0_4 (p : Nat → Prop)
    (b0 : p 91)
    (b1 : p 106)
    (b2 : p 125)
    (h1 : (¬ p 46) ∨ (¬ p 16))
    (h5 : (¬ p 47) ∨ (¬ p 32))
    (h6 : (¬ p 48) ∨ p 3)
    (h12 : (¬ p 50) ∨ p 5)
    (h18 : (¬ p 52) ∨ p 7)
    (h23 : (¬ p 53) ∨ (¬ p 38))
    (h28 : (¬ p 55) ∨ (¬ p 25))
    (h30 : (¬ p 56) ∨ p 11)
    (h41 : (¬ p 59) ∨ (¬ p 44))
    (h43 : (¬ p 60) ∨ (¬ p 30))
    (h46 : (¬ p 91) ∨ p 1)
    (h47 : (¬ p 91) ∨ p 10)
    (h48 : (¬ p 91) ∨ p 15)
    (h159 : p 46 ∨ p 47 ∨ p 48 ∨ p 50 ∨ p 52 ∨ p 53 ∨ p 55 ∨ p 56 ∨ p 59 ∨ p 60)
    (h178 : (¬ p 61) ∨ (¬ p 1))
    (h183 : (¬ p 62) ∨ (¬ p 32))
    (h184 : (¬ p 63) ∨ (¬ p 3))
    (h191 : (¬ p 65) ∨ p 20)
    (h197 : (¬ p 67) ∨ p 22)
    (h201 : (¬ p 68) ∨ (¬ p 38))
    (h205 : (¬ p 70) ∨ (¬ p 10))
    (h209 : (¬ p 71) ∨ p 26)
    (h219 : (¬ p 74) ∨ (¬ p 44))
    (h220 : (¬ p 75) ∨ (¬ p 15))
    (h224 : (¬ p 106) ∨ p 16)
    (h225 : (¬ p 106) ∨ p 25)
    (h226 : (¬ p 106) ∨ p 30)
    (h337 : p 61 ∨ p 62 ∨ p 63 ∨ p 65 ∨ p 67 ∨ p 68 ∨ p 70 ∨ p 71 ∨ p 74 ∨ p 75)
    (h414 : (¬ p 125) ∨ p 32)
    (h415 : (¬ p 125) ∨ p 38)
    (h416 : (¬ p 125) ∨ p 44)
    (h540 : (¬ p 1) ∨ (¬ p 26) ∨ (¬ p 44))
    (h542 : (¬ p 11) ∨ (¬ p 16) ∨ (¬ p 44))
    (h555 : (¬ p 7) ∨ (¬ p 30) ∨ (¬ p 32))
    (h557 : (¬ p 15) ∨ (¬ p 22) ∨ (¬ p 32))
    (h619 : (¬ p 5) ∨ (¬ p 25) ∨ (¬ p 38))
    (h622 : (¬ p 10) ∨ (¬ p 20) ∨ (¬ p 38))
    : False := by
  classical
  have u1 : p 1 := Or.elim h46 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u10 : p 10 := Or.elim h47 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u15 : p 15 := Or.elim h48 (fun t => False.elim (t b0)) (fun r0 => r0)
  have un61 : ¬ p 61 := Or.elim h178 (fun t => t) (fun r0 => False.elim (r0 u1))
  have un70 : ¬ p 70 := Or.elim h205 (fun t => t) (fun r0 => False.elim (r0 u10))
  have un75 : ¬ p 75 := Or.elim h220 (fun t => t) (fun r0 => False.elim (r0 u15))
  have u16 : p 16 := Or.elim h224 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u25 : p 25 := Or.elim h225 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u30 : p 30 := Or.elim h226 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u32 : p 32 := Or.elim h414 (fun t => False.elim (t b2)) (fun r0 => r0)
  have u38 : p 38 := Or.elim h415 (fun t => False.elim (t b2)) (fun r0 => r0)
  have u44 : p 44 := Or.elim h416 (fun t => False.elim (t b2)) (fun r0 => r0)
  have un26 : ¬ p 26 := Or.elim h540 (fun t => False.elim (t u1)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u44)))
  have un11 : ¬ p 11 := Or.elim h542 (fun t => t) (fun r0 => Or.elim r0 (fun t => False.elim (t u16)) (fun r1 => False.elim (r1 u44)))
  have un7 : ¬ p 7 := Or.elim h555 (fun t => t) (fun r0 => Or.elim r0 (fun t => False.elim (t u30)) (fun r1 => False.elim (r1 u32)))
  have un22 : ¬ p 22 := Or.elim h557 (fun t => False.elim (t u15)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u32)))
  have un5 : ¬ p 5 := Or.elim h619 (fun t => t) (fun r0 => Or.elim r0 (fun t => False.elim (t u25)) (fun r1 => False.elim (r1 u38)))
  have un20 : ¬ p 20 := Or.elim h622 (fun t => False.elim (t u10)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u38)))
  have un46 : ¬ p 46 := Or.elim h1 (fun t => t) (fun r0 => False.elim (r0 u16))
  have un47 : ¬ p 47 := Or.elim h5 (fun t => t) (fun r0 => False.elim (r0 u32))
  have un50 : ¬ p 50 := Or.elim h12 (fun t => t) (fun r0 => False.elim (un5 r0))
  have un52 : ¬ p 52 := Or.elim h18 (fun t => t) (fun r0 => False.elim (un7 r0))
  have un53 : ¬ p 53 := Or.elim h23 (fun t => t) (fun r0 => False.elim (r0 u38))
  have un55 : ¬ p 55 := Or.elim h28 (fun t => t) (fun r0 => False.elim (r0 u25))
  have un56 : ¬ p 56 := Or.elim h30 (fun t => t) (fun r0 => False.elim (un11 r0))
  have un59 : ¬ p 59 := Or.elim h41 (fun t => t) (fun r0 => False.elim (r0 u44))
  have un60 : ¬ p 60 := Or.elim h43 (fun t => t) (fun r0 => False.elim (r0 u30))
  have u48 : p 48 := Or.elim h159 (fun t => False.elim (un46 t)) (fun r0 => Or.elim r0 (fun t => False.elim (un47 t)) (fun r1 => Or.elim r1 (fun t => t) (fun r2 => Or.elim r2 (fun t => False.elim (un50 t)) (fun r3 => Or.elim r3 (fun t => False.elim (un52 t)) (fun r4 => Or.elim r4 (fun t => False.elim (un53 t)) (fun r5 => Or.elim r5 (fun t => False.elim (un55 t)) (fun r6 => Or.elim r6 (fun t => False.elim (un56 t)) (fun r7 => Or.elim r7 (fun t => False.elim (un59 t)) (fun r8 => False.elim (un60 r8))))))))))
  have un62 : ¬ p 62 := Or.elim h183 (fun t => t) (fun r0 => False.elim (r0 u32))
  have un65 : ¬ p 65 := Or.elim h191 (fun t => t) (fun r0 => False.elim (un20 r0))
  have un67 : ¬ p 67 := Or.elim h197 (fun t => t) (fun r0 => False.elim (un22 r0))
  have un68 : ¬ p 68 := Or.elim h201 (fun t => t) (fun r0 => False.elim (r0 u38))
  have un71 : ¬ p 71 := Or.elim h209 (fun t => t) (fun r0 => False.elim (un26 r0))
  have un74 : ¬ p 74 := Or.elim h219 (fun t => t) (fun r0 => False.elim (r0 u44))
  have u63 : p 63 := Or.elim h337 (fun t => False.elim (un61 t)) (fun r0 => Or.elim r0 (fun t => False.elim (un62 t)) (fun r1 => Or.elim r1 (fun t => t) (fun r2 => Or.elim r2 (fun t => False.elim (un65 t)) (fun r3 => Or.elim r3 (fun t => False.elim (un67 t)) (fun r4 => Or.elim r4 (fun t => False.elim (un68 t)) (fun r5 => Or.elim r5 (fun t => False.elim (un70 t)) (fun r6 => Or.elim r6 (fun t => False.elim (un71 t)) (fun r7 => Or.elim r7 (fun t => False.elim (un74 t)) (fun r8 => False.elim (un75 r8))))))))))
  have u3 : p 3 := Or.elim h6 (fun t => False.elim (t u48)) (fun r0 => r0)
  exact Or.elim h184 (fun t => (t u63)) (fun r0 => (r0 u3))

theorem branch0_1_3 (p : Nat → Prop)
    (b0 : p 91)
    (b1 : p 107)
    (b2 : p 124)
    (h47 : (¬ p 91) ∨ p 10)
    (h227 : (¬ p 107) ∨ p 16)
    (h413 : (¬ p 124) ∨ p 45)
    (h536 : (¬ p 10) ∨ (¬ p 16) ∨ (¬ p 45))
    : False := by
  classical
  have u10 : p 10 := Or.elim h47 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u16 : p 16 := Or.elim h227 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u45 : p 45 := Or.elim h413 (fun t => False.elim (t b2)) (fun r0 => r0)
  exact Or.elim h536 (fun t => (t u10)) (fun r0 => Or.elim r0 (fun t => (t u16)) (fun r1 => (r1 u45)))

theorem branch0_1_5 (p : Nat → Prop)
    (b0 : p 91)
    (b1 : p 107)
    (b2 : p 126)
    (h1 : (¬ p 46) ∨ (¬ p 16))
    (h5 : (¬ p 47) ∨ (¬ p 32))
    (h6 : (¬ p 48) ∨ p 3)
    (h12 : (¬ p 50) ∨ p 5)
    (h21 : (¬ p 53) ∨ p 8)
    (h26 : (¬ p 54) ∨ (¬ p 39))
    (h31 : (¬ p 56) ∨ (¬ p 26))
    (h33 : (¬ p 57) ∨ p 12)
    (h38 : (¬ p 58) ∨ (¬ p 43))
    (h40 : (¬ p 59) ∨ (¬ p 29))
    (h46 : (¬ p 91) ∨ p 1)
    (h47 : (¬ p 91) ∨ p 10)
    (h48 : (¬ p 91) ∨ p 15)
    (h156 : p 46 ∨ p 47 ∨ p 48 ∨ p 50 ∨ p 53 ∨ p 54 ∨ p 56 ∨ p 57 ∨ p 58 ∨ p 59)
    (h178 : (¬ p 61) ∨ (¬ p 1))
    (h183 : (¬ p 62) ∨ (¬ p 32))
    (h188 : (¬ p 64) ∨ p 19)
    (h190 : (¬ p 65) ∨ (¬ p 5))
    (h197 : (¬ p 67) ∨ p 22)
    (h204 : (¬ p 69) ∨ (¬ p 39))
    (h205 : (¬ p 70) ∨ (¬ p 10))
    (h212 : (¬ p 72) ∨ p 27)
    (h216 : (¬ p 73) ∨ (¬ p 43))
    (h220 : (¬ p 75) ∨ (¬ p 15))
    (h227 : (¬ p 107) ∨ p 16)
    (h228 : (¬ p 107) ∨ p 26)
    (h229 : (¬ p 107) ∨ p 29)
    (h332 : p 61 ∨ p 62 ∨ p 64 ∨ p 65 ∨ p 67 ∨ p 69 ∨ p 70 ∨ p 72 ∨ p 73 ∨ p 75)
    (h417 : (¬ p 126) ∨ p 32)
    (h418 : (¬ p 126) ∨ p 39)
    (h419 : (¬ p 126) ∨ p 43)
    (h546 : (¬ p 1) ∨ (¬ p 27) ∨ (¬ p 43))
    (h548 : (¬ p 12) ∨ (¬ p 16) ∨ (¬ p 43))
    (h557 : (¬ p 15) ∨ (¬ p 22) ∨ (¬ p 32))
    (h561 : (¬ p 8) ∨ (¬ p 29) ∨ (¬ p 32))
    (h583 : (¬ p 3) ∨ (¬ p 26) ∨ (¬ p 39))
    (h604 : (¬ p 10) ∨ (¬ p 19) ∨ (¬ p 39))
    : False := by
  classical
  have u1 : p 1 := Or.elim h46 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u10 : p 10 := Or.elim h47 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u15 : p 15 := Or.elim h48 (fun t => False.elim (t b0)) (fun r0 => r0)
  have un61 : ¬ p 61 := Or.elim h178 (fun t => t) (fun r0 => False.elim (r0 u1))
  have un70 : ¬ p 70 := Or.elim h205 (fun t => t) (fun r0 => False.elim (r0 u10))
  have un75 : ¬ p 75 := Or.elim h220 (fun t => t) (fun r0 => False.elim (r0 u15))
  have u16 : p 16 := Or.elim h227 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u26 : p 26 := Or.elim h228 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u29 : p 29 := Or.elim h229 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u32 : p 32 := Or.elim h417 (fun t => False.elim (t b2)) (fun r0 => r0)
  have u39 : p 39 := Or.elim h418 (fun t => False.elim (t b2)) (fun r0 => r0)
  have u43 : p 43 := Or.elim h419 (fun t => False.elim (t b2)) (fun r0 => r0)
  have un27 : ¬ p 27 := Or.elim h546 (fun t => False.elim (t u1)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u43)))
  have un12 : ¬ p 12 := Or.elim h548 (fun t => t) (fun r0 => Or.elim r0 (fun t => False.elim (t u16)) (fun r1 => False.elim (r1 u43)))
  have un22 : ¬ p 22 := Or.elim h557 (fun t => False.elim (t u15)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u32)))
  have un8 : ¬ p 8 := Or.elim h561 (fun t => t) (fun r0 => Or.elim r0 (fun t => False.elim (t u29)) (fun r1 => False.elim (r1 u32)))
  have un3 : ¬ p 3 := Or.elim h583 (fun t => t) (fun r0 => Or.elim r0 (fun t => False.elim (t u26)) (fun r1 => False.elim (r1 u39)))
  have un19 : ¬ p 19 := Or.elim h604 (fun t => False.elim (t u10)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u39)))
  have un46 : ¬ p 46 := Or.elim h1 (fun t => t) (fun r0 => False.elim (r0 u16))
  have un47 : ¬ p 47 := Or.elim h5 (fun t => t) (fun r0 => False.elim (r0 u32))
  have un48 : ¬ p 48 := Or.elim h6 (fun t => t) (fun r0 => False.elim (un3 r0))
  have un53 : ¬ p 53 := Or.elim h21 (fun t => t) (fun r0 => False.elim (un8 r0))
  have un54 : ¬ p 54 := Or.elim h26 (fun t => t) (fun r0 => False.elim (r0 u39))
  have un56 : ¬ p 56 := Or.elim h31 (fun t => t) (fun r0 => False.elim (r0 u26))
  have un57 : ¬ p 57 := Or.elim h33 (fun t => t) (fun r0 => False.elim (un12 r0))
  have un58 : ¬ p 58 := Or.elim h38 (fun t => t) (fun r0 => False.elim (r0 u43))
  have un59 : ¬ p 59 := Or.elim h40 (fun t => t) (fun r0 => False.elim (r0 u29))
  have u50 : p 50 := Or.elim h156 (fun t => False.elim (un46 t)) (fun r0 => Or.elim r0 (fun t => False.elim (un47 t)) (fun r1 => Or.elim r1 (fun t => False.elim (un48 t)) (fun r2 => Or.elim r2 (fun t => t) (fun r3 => Or.elim r3 (fun t => False.elim (un53 t)) (fun r4 => Or.elim r4 (fun t => False.elim (un54 t)) (fun r5 => Or.elim r5 (fun t => False.elim (un56 t)) (fun r6 => Or.elim r6 (fun t => False.elim (un57 t)) (fun r7 => Or.elim r7 (fun t => False.elim (un58 t)) (fun r8 => False.elim (un59 r8))))))))))
  have un62 : ¬ p 62 := Or.elim h183 (fun t => t) (fun r0 => False.elim (r0 u32))
  have un64 : ¬ p 64 := Or.elim h188 (fun t => t) (fun r0 => False.elim (un19 r0))
  have un67 : ¬ p 67 := Or.elim h197 (fun t => t) (fun r0 => False.elim (un22 r0))
  have un69 : ¬ p 69 := Or.elim h204 (fun t => t) (fun r0 => False.elim (r0 u39))
  have un72 : ¬ p 72 := Or.elim h212 (fun t => t) (fun r0 => False.elim (un27 r0))
  have un73 : ¬ p 73 := Or.elim h216 (fun t => t) (fun r0 => False.elim (r0 u43))
  have u65 : p 65 := Or.elim h332 (fun t => False.elim (un61 t)) (fun r0 => Or.elim r0 (fun t => False.elim (un62 t)) (fun r1 => Or.elim r1 (fun t => False.elim (un64 t)) (fun r2 => Or.elim r2 (fun t => t) (fun r3 => Or.elim r3 (fun t => False.elim (un67 t)) (fun r4 => Or.elim r4 (fun t => False.elim (un69 t)) (fun r5 => Or.elim r5 (fun t => False.elim (un70 t)) (fun r6 => Or.elim r6 (fun t => False.elim (un72 t)) (fun r7 => Or.elim r7 (fun t => False.elim (un73 t)) (fun r8 => False.elim (un75 r8))))))))))
  have u5 : p 5 := Or.elim h12 (fun t => False.elim (t u50)) (fun r0 => r0)
  exact Or.elim h190 (fun t => (t u65)) (fun r0 => (r0 u5))

theorem branch0_4_8 (p : Nat → Prop)
    (b0 : p 91)
    (b1 : p 110)
    (b2 : p 129)
    (h46 : (¬ p 91) ∨ p 1)
    (h238 : (¬ p 110) ∨ p 29)
    (h428 : (¬ p 129) ∨ p 41)
    (h541 : (¬ p 1) ∨ (¬ p 29) ∨ (¬ p 41))
    : False := by
  classical
  have u1 : p 1 := Or.elim h46 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u29 : p 29 := Or.elim h238 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u41 : p 41 := Or.elim h428 (fun t => False.elim (t b2)) (fun r0 => r0)
  exact Or.elim h541 (fun t => (t u1)) (fun r0 => Or.elim r0 (fun t => (t u29)) (fun r1 => (r1 u41)))

theorem branch0_4_13 (p : Nat → Prop)
    (b0 : p 91)
    (b1 : p 110)
    (b2 : p 134)
    (h46 : (¬ p 91) ∨ p 1)
    (h238 : (¬ p 110) ∨ p 29)
    (h443 : (¬ p 134) ∨ p 41)
    (h541 : (¬ p 1) ∨ (¬ p 29) ∨ (¬ p 41))
    : False := by
  classical
  have u1 : p 1 := Or.elim h46 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u29 : p 29 := Or.elim h238 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u41 : p 41 := Or.elim h443 (fun t => False.elim (t b2)) (fun r0 => r0)
  exact Or.elim h541 (fun t => (t u1)) (fun r0 => Or.elim r0 (fun t => (t u29)) (fun r1 => (r1 u41)))

theorem branch3_1_2 (p : Nat → Prop)
    (b0 : p 94)
    (b1 : p 107)
    (b2 : p 123)
    (h55 : (¬ p 94) ∨ p 2)
    (h56 : (¬ p 94) ∨ p 7)
    (h57 : (¬ p 94) ∨ p 15)
    (h180 : (¬ p 61) ∨ (¬ p 31))
    (h181 : (¬ p 62) ∨ (¬ p 2))
    (h185 : (¬ p 63) ∨ p 18)
    (h188 : (¬ p 64) ∨ p 19)
    (h196 : (¬ p 67) ∨ (¬ p 7))
    (h203 : (¬ p 69) ∨ p 24)
    (h206 : (¬ p 70) ∨ p 25)
    (h213 : (¬ p 72) ∨ (¬ p 42))
    (h216 : (¬ p 73) ∨ (¬ p 43))
    (h220 : (¬ p 75) ∨ (¬ p 15))
    (h227 : (¬ p 107) ∨ p 16)
    (h228 : (¬ p 107) ∨ p 26)
    (h229 : (¬ p 107) ∨ p 29)
    (h338 : p 61 ∨ p 62 ∨ p 63 ∨ p 64 ∨ p 67 ∨ p 69 ∨ p 70 ∨ p 72 ∨ p 73 ∨ p 75)
    (h357 : (¬ p 76) ∨ (¬ p 16))
    (h359 : (¬ p 77) ∨ (¬ p 2))
    (h363 : (¬ p 78) ∨ (¬ p 18))
    (h370 : (¬ p 80) ∨ p 35)
    (h374 : (¬ p 82) ∨ (¬ p 7))
    (h379 : (¬ p 83) ∨ p 38)
    (h385 : (¬ p 85) ∨ p 40)
    (h387 : (¬ p 86) ∨ (¬ p 26))
    (h396 : (¬ p 89) ∨ (¬ p 29))
    (h398 : (¬ p 90) ∨ (¬ p 15))
    (h408 : (¬ p 123) ∨ p 31)
    (h409 : (¬ p 123) ∨ p 42)
    (h410 : (¬ p 123) ∨ p 43)
    (h515 : p 76 ∨ p 77 ∨ p 78 ∨ p 80 ∨ p 82 ∨ p 83 ∨ p 85 ∨ p 86 ∨ p 89 ∨ p 90)
    (h538 : (¬ p 15) ∨ (¬ p 16) ∨ (¬ p 40))
    (h539 : (¬ p 15) ∨ (¬ p 25) ∨ (¬ p 31))
    (h559 : (¬ p 2) ∨ (¬ p 29) ∨ (¬ p 38))
    (h564 : (¬ p 2) ∨ (¬ p 24) ∨ (¬ p 43))
    (h596 : (¬ p 7) ∨ (¬ p 19) ∨ (¬ p 42))
    (h615 : (¬ p 7) ∨ (¬ p 26) ∨ (¬ p 35))
    : False := by
  classical
  have u2 : p 2 := Or.elim h55 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u7 : p 7 := Or.elim h56 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u15 : p 15 := Or.elim h57 (fun t => False.elim (t b0)) (fun r0 => r0)
  have un62 : ¬ p 62 := Or.elim h181 (fun t => t) (fun r0 => False.elim (r0 u2))
  have un67 : ¬ p 67 := Or.elim h196 (fun t => t) (fun r0 => False.elim (r0 u7))
  have un75 : ¬ p 75 := Or.elim h220 (fun t => t) (fun r0 => False.elim (r0 u15))
  have u16 : p 16 := Or.elim h227 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u26 : p 26 := Or.elim h228 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u29 : p 29 := Or.elim h229 (fun t => False.elim (t b1)) (fun r0 => r0)
  have un76 : ¬ p 76 := Or.elim h357 (fun t => t) (fun r0 => False.elim (r0 u16))
  have un77 : ¬ p 77 := Or.elim h359 (fun t => t) (fun r0 => False.elim (r0 u2))
  have un82 : ¬ p 82 := Or.elim h374 (fun t => t) (fun r0 => False.elim (r0 u7))
  have un86 : ¬ p 86 := Or.elim h387 (fun t => t) (fun r0 => False.elim (r0 u26))
  have un89 : ¬ p 89 := Or.elim h396 (fun t => t) (fun r0 => False.elim (r0 u29))
  have un90 : ¬ p 90 := Or.elim h398 (fun t => t) (fun r0 => False.elim (r0 u15))
  have u31 : p 31 := Or.elim h408 (fun t => False.elim (t b2)) (fun r0 => r0)
  have u42 : p 42 := Or.elim h409 (fun t => False.elim (t b2)) (fun r0 => r0)
  have u43 : p 43 := Or.elim h410 (fun t => False.elim (t b2)) (fun r0 => r0)
  have un40 : ¬ p 40 := Or.elim h538 (fun t => False.elim (t u15)) (fun r0 => Or.elim r0 (fun t => False.elim (t u16)) (fun r1 => r1))
  have un25 : ¬ p 25 := Or.elim h539 (fun t => False.elim (t u15)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u31)))
  have un38 : ¬ p 38 := Or.elim h559 (fun t => False.elim (t u2)) (fun r0 => Or.elim r0 (fun t => False.elim (t u29)) (fun r1 => r1))
  have un24 : ¬ p 24 := Or.elim h564 (fun t => False.elim (t u2)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u43)))
  have un19 : ¬ p 19 := Or.elim h596 (fun t => False.elim (t u7)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u42)))
  have un35 : ¬ p 35 := Or.elim h615 (fun t => False.elim (t u7)) (fun r0 => Or.elim r0 (fun t => False.elim (t u26)) (fun r1 => r1))
  have un61 : ¬ p 61 := Or.elim h180 (fun t => t) (fun r0 => False.elim (r0 u31))
  have un64 : ¬ p 64 := Or.elim h188 (fun t => t) (fun r0 => False.elim (un19 r0))
  have un69 : ¬ p 69 := Or.elim h203 (fun t => t) (fun r0 => False.elim (un24 r0))
  have un70 : ¬ p 70 := Or.elim h206 (fun t => t) (fun r0 => False.elim (un25 r0))
  have un72 : ¬ p 72 := Or.elim h213 (fun t => t) (fun r0 => False.elim (r0 u42))
  have un73 : ¬ p 73 := Or.elim h216 (fun t => t) (fun r0 => False.elim (r0 u43))
  have u63 : p 63 := Or.elim h338 (fun t => False.elim (un61 t)) (fun r0 => Or.elim r0 (fun t => False.elim (un62 t)) (fun r1 => Or.elim r1 (fun t => t) (fun r2 => Or.elim r2 (fun t => False.elim (un64 t)) (fun r3 => Or.elim r3 (fun t => False.elim (un67 t)) (fun r4 => Or.elim r4 (fun t => False.elim (un69 t)) (fun r5 => Or.elim r5 (fun t => False.elim (un70 t)) (fun r6 => Or.elim r6 (fun t => False.elim (un72 t)) (fun r7 => Or.elim r7 (fun t => False.elim (un73 t)) (fun r8 => False.elim (un75 r8))))))))))
  have un80 : ¬ p 80 := Or.elim h370 (fun t => t) (fun r0 => False.elim (un35 r0))
  have un83 : ¬ p 83 := Or.elim h379 (fun t => t) (fun r0 => False.elim (un38 r0))
  have un85 : ¬ p 85 := Or.elim h385 (fun t => t) (fun r0 => False.elim (un40 r0))
  have u78 : p 78 := Or.elim h515 (fun t => False.elim (un76 t)) (fun r0 => Or.elim r0 (fun t => False.elim (un77 t)) (fun r1 => Or.elim r1 (fun t => t) (fun r2 => Or.elim r2 (fun t => False.elim (un80 t)) (fun r3 => Or.elim r3 (fun t => False.elim (un82 t)) (fun r4 => Or.elim r4 (fun t => False.elim (un83 t)) (fun r5 => Or.elim r5 (fun t => False.elim (un85 t)) (fun r6 => Or.elim r6 (fun t => False.elim (un86 t)) (fun r7 => Or.elim r7 (fun t => False.elim (un89 t)) (fun r8 => False.elim (un90 r8))))))))))
  have u18 : p 18 := Or.elim h185 (fun t => False.elim (t u63)) (fun r0 => r0)
  exact Or.elim h363 (fun t => (t u78)) (fun r0 => (r0 u18))

theorem branch4_1_2 (p : Nat → Prop)
    (b0 : p 95)
    (b1 : p 107)
    (b2 : p 123)
    (h60 : (¬ p 95) ∨ p 14)
    (h228 : (¬ p 107) ∨ p 26)
    (h408 : (¬ p 123) ∨ p 31)
    (h545 : (¬ p 14) ∨ (¬ p 26) ∨ (¬ p 31))
    : False := by
  classical
  have u14 : p 14 := Or.elim h60 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u26 : p 26 := Or.elim h228 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u31 : p 31 := Or.elim h408 (fun t => False.elim (t b2)) (fun r0 => r0)
  exact Or.elim h545 (fun t => (t u14)) (fun r0 => Or.elim r0 (fun t => (t u26)) (fun r1 => (r1 u31)))

theorem branch5_1_2 (p : Nat → Prop)
    (b0 : p 96)
    (b1 : p 107)
    (b2 : p 123)
    (h63 : (¬ p 96) ∨ p 13)
    (h227 : (¬ p 107) ∨ p 16)
    (h409 : (¬ p 123) ∨ p 42)
    (h550 : (¬ p 13) ∨ (¬ p 16) ∨ (¬ p 42))
    : False := by
  classical
  have u13 : p 13 := Or.elim h63 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u16 : p 16 := Or.elim h227 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u42 : p 42 := Or.elim h409 (fun t => False.elim (t b2)) (fun r0 => r0)
  exact Or.elim h550 (fun t => (t u13)) (fun r0 => Or.elim r0 (fun t => (t u16)) (fun r1 => (r1 u42)))

theorem branch6_1_2 (p : Nat → Prop)
    (b0 : p 97)
    (b1 : p 107)
    (b2 : p 123)
    (h64 : (¬ p 97) ∨ p 3)
    (h65 : (¬ p 97) ∨ p 6)
    (h66 : (¬ p 97) ∨ p 15)
    (h180 : (¬ p 61) ∨ (¬ p 31))
    (h182 : (¬ p 62) ∨ p 17)
    (h184 : (¬ p 63) ∨ (¬ p 3))
    (h191 : (¬ p 65) ∨ p 20)
    (h193 : (¬ p 66) ∨ (¬ p 6))
    (h200 : (¬ p 68) ∨ p 23)
    (h206 : (¬ p 70) ∨ p 25)
    (h213 : (¬ p 72) ∨ (¬ p 42))
    (h216 : (¬ p 73) ∨ (¬ p 43))
    (h220 : (¬ p 75) ∨ (¬ p 15))
    (h227 : (¬ p 107) ∨ p 16)
    (h228 : (¬ p 107) ∨ p 26)
    (h229 : (¬ p 107) ∨ p 29)
    (h340 : p 61 ∨ p 62 ∨ p 63 ∨ p 65 ∨ p 66 ∨ p 68 ∨ p 70 ∨ p 72 ∨ p 73 ∨ p 75)
    (h357 : (¬ p 76) ∨ (¬ p 16))
    (h360 : (¬ p 77) ∨ (¬ p 17))
    (h362 : (¬ p 78) ∨ (¬ p 3))
    (h367 : (¬ p 79) ∨ p 34)
    (h371 : (¬ p 81) ∨ (¬ p 6))
    (h382 : (¬ p 84) ∨ p 39)
    (h385 : (¬ p 85) ∨ p 40)
    (h387 : (¬ p 86) ∨ (¬ p 26))
    (h396 : (¬ p 89) ∨ (¬ p 29))
    (h398 : (¬ p 90) ∨ (¬ p 15))
    (h408 : (¬ p 123) ∨ p 31)
    (h409 : (¬ p 123) ∨ p 42)
    (h410 : (¬ p 123) ∨ p 43)
    (h519 : p 76 ∨ p 77 ∨ p 78 ∨ p 79 ∨ p 81 ∨ p 84 ∨ p 85 ∨ p 86 ∨ p 89 ∨ p 90)
    (h538 : (¬ p 15) ∨ (¬ p 16) ∨ (¬ p 40))
    (h539 : (¬ p 15) ∨ (¬ p 25) ∨ (¬ p 31))
    (h576 : (¬ p 3) ∨ (¬ p 23) ∨ (¬ p 42))
    (h583 : (¬ p 3) ∨ (¬ p 26) ∨ (¬ p 39))
    (h591 : (¬ p 6) ∨ (¬ p 29) ∨ (¬ p 34))
    (h608 : (¬ p 6) ∨ (¬ p 20) ∨ (¬ p 43))
    : False := by
  classical
  have u3 : p 3 := Or.elim h64 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u6 : p 6 := Or.elim h65 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u15 : p 15 := Or.elim h66 (fun t => False.elim (t b0)) (fun r0 => r0)
  have un63 : ¬ p 63 := Or.elim h184 (fun t => t) (fun r0 => False.elim (r0 u3))
  have un66 : ¬ p 66 := Or.elim h193 (fun t => t) (fun r0 => False.elim (r0 u6))
  have un75 : ¬ p 75 := Or.elim h220 (fun t => t) (fun r0 => False.elim (r0 u15))
  have u16 : p 16 := Or.elim h227 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u26 : p 26 := Or.elim h228 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u29 : p 29 := Or.elim h229 (fun t => False.elim (t b1)) (fun r0 => r0)
  have un76 : ¬ p 76 := Or.elim h357 (fun t => t) (fun r0 => False.elim (r0 u16))
  have un78 : ¬ p 78 := Or.elim h362 (fun t => t) (fun r0 => False.elim (r0 u3))
  have un81 : ¬ p 81 := Or.elim h371 (fun t => t) (fun r0 => False.elim (r0 u6))
  have un86 : ¬ p 86 := Or.elim h387 (fun t => t) (fun r0 => False.elim (r0 u26))
  have un89 : ¬ p 89 := Or.elim h396 (fun t => t) (fun r0 => False.elim (r0 u29))
  have un90 : ¬ p 90 := Or.elim h398 (fun t => t) (fun r0 => False.elim (r0 u15))
  have u31 : p 31 := Or.elim h408 (fun t => False.elim (t b2)) (fun r0 => r0)
  have u42 : p 42 := Or.elim h409 (fun t => False.elim (t b2)) (fun r0 => r0)
  have u43 : p 43 := Or.elim h410 (fun t => False.elim (t b2)) (fun r0 => r0)
  have un40 : ¬ p 40 := Or.elim h538 (fun t => False.elim (t u15)) (fun r0 => Or.elim r0 (fun t => False.elim (t u16)) (fun r1 => r1))
  have un25 : ¬ p 25 := Or.elim h539 (fun t => False.elim (t u15)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u31)))
  have un23 : ¬ p 23 := Or.elim h576 (fun t => False.elim (t u3)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u42)))
  have un39 : ¬ p 39 := Or.elim h583 (fun t => False.elim (t u3)) (fun r0 => Or.elim r0 (fun t => False.elim (t u26)) (fun r1 => r1))
  have un34 : ¬ p 34 := Or.elim h591 (fun t => False.elim (t u6)) (fun r0 => Or.elim r0 (fun t => False.elim (t u29)) (fun r1 => r1))
  have un20 : ¬ p 20 := Or.elim h608 (fun t => False.elim (t u6)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u43)))
  have un61 : ¬ p 61 := Or.elim h180 (fun t => t) (fun r0 => False.elim (r0 u31))
  have un65 : ¬ p 65 := Or.elim h191 (fun t => t) (fun r0 => False.elim (un20 r0))
  have un68 : ¬ p 68 := Or.elim h200 (fun t => t) (fun r0 => False.elim (un23 r0))
  have un70 : ¬ p 70 := Or.elim h206 (fun t => t) (fun r0 => False.elim (un25 r0))
  have un72 : ¬ p 72 := Or.elim h213 (fun t => t) (fun r0 => False.elim (r0 u42))
  have un73 : ¬ p 73 := Or.elim h216 (fun t => t) (fun r0 => False.elim (r0 u43))
  have u62 : p 62 := Or.elim h340 (fun t => False.elim (un61 t)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => Or.elim r1 (fun t => False.elim (un63 t)) (fun r2 => Or.elim r2 (fun t => False.elim (un65 t)) (fun r3 => Or.elim r3 (fun t => False.elim (un66 t)) (fun r4 => Or.elim r4 (fun t => False.elim (un68 t)) (fun r5 => Or.elim r5 (fun t => False.elim (un70 t)) (fun r6 => Or.elim r6 (fun t => False.elim (un72 t)) (fun r7 => Or.elim r7 (fun t => False.elim (un73 t)) (fun r8 => False.elim (un75 r8))))))))))
  have un79 : ¬ p 79 := Or.elim h367 (fun t => t) (fun r0 => False.elim (un34 r0))
  have un84 : ¬ p 84 := Or.elim h382 (fun t => t) (fun r0 => False.elim (un39 r0))
  have un85 : ¬ p 85 := Or.elim h385 (fun t => t) (fun r0 => False.elim (un40 r0))
  have u77 : p 77 := Or.elim h519 (fun t => False.elim (un76 t)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => Or.elim r1 (fun t => False.elim (un78 t)) (fun r2 => Or.elim r2 (fun t => False.elim (un79 t)) (fun r3 => Or.elim r3 (fun t => False.elim (un81 t)) (fun r4 => Or.elim r4 (fun t => False.elim (un84 t)) (fun r5 => Or.elim r5 (fun t => False.elim (un85 t)) (fun r6 => Or.elim r6 (fun t => False.elim (un86 t)) (fun r7 => Or.elim r7 (fun t => False.elim (un89 t)) (fun r8 => False.elim (un90 r8))))))))))
  have u17 : p 17 := Or.elim h182 (fun t => False.elim (t u62)) (fun r0 => r0)
  exact Or.elim h360 (fun t => (t u77)) (fun r0 => (r0 u17))

theorem branch7_1_2 (p : Nat → Prop)
    (b0 : p 98)
    (b1 : p 107)
    (b2 : p 123)
    (h69 : (¬ p 98) ∨ p 12)
    (h227 : (¬ p 107) ∨ p 16)
    (h410 : (¬ p 123) ∨ p 43)
    (h548 : (¬ p 12) ∨ (¬ p 16) ∨ (¬ p 43))
    : False := by
  classical
  have u12 : p 12 := Or.elim h69 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u16 : p 16 := Or.elim h227 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u43 : p 43 := Or.elim h410 (fun t => False.elim (t b2)) (fun r0 => r0)
  exact Or.elim h548 (fun t => (t u12)) (fun r0 => Or.elim r0 (fun t => (t u16)) (fun r1 => (r1 u43)))

theorem branch8_1_2 (p : Nat → Prop)
    (b0 : p 99)
    (b1 : p 107)
    (b2 : p 123)
    (h72 : (¬ p 99) ∨ p 11)
    (h229 : (¬ p 107) ∨ p 29)
    (h408 : (¬ p 123) ∨ p 31)
    (h543 : (¬ p 11) ∨ (¬ p 29) ∨ (¬ p 31))
    : False := by
  classical
  have u11 : p 11 := Or.elim h72 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u29 : p 29 := Or.elim h229 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u31 : p 31 := Or.elim h408 (fun t => False.elim (t b2)) (fun r0 => r0)
  exact Or.elim h543 (fun t => (t u11)) (fun r0 => Or.elim r0 (fun t => (t u29)) (fun r1 => (r1 u31)))

theorem branch9_1_2 (p : Nat → Prop)
    (b0 : p 100)
    (b1 : p 107)
    (b2 : p 123)
    (h75 : (¬ p 100) ∨ p 14)
    (h228 : (¬ p 107) ∨ p 26)
    (h408 : (¬ p 123) ∨ p 31)
    (h545 : (¬ p 14) ∨ (¬ p 26) ∨ (¬ p 31))
    : False := by
  classical
  have u14 : p 14 := Or.elim h75 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u26 : p 26 := Or.elim h228 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u31 : p 31 := Or.elim h408 (fun t => False.elim (t b2)) (fun r0 => r0)
  exact Or.elim h545 (fun t => (t u14)) (fun r0 => Or.elim r0 (fun t => (t u26)) (fun r1 => (r1 u31)))

theorem branch10_1_2 (p : Nat → Prop)
    (b0 : p 101)
    (b1 : p 107)
    (b2 : p 123)
    (h78 : (¬ p 101) ∨ p 12)
    (h227 : (¬ p 107) ∨ p 16)
    (h410 : (¬ p 123) ∨ p 43)
    (h548 : (¬ p 12) ∨ (¬ p 16) ∨ (¬ p 43))
    : False := by
  classical
  have u12 : p 12 := Or.elim h78 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u16 : p 16 := Or.elim h227 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u43 : p 43 := Or.elim h410 (fun t => False.elim (t b2)) (fun r0 => r0)
  exact Or.elim h548 (fun t => (t u12)) (fun r0 => Or.elim r0 (fun t => (t u16)) (fun r1 => (r1 u43)))

theorem branch11_1_2 (p : Nat → Prop)
    (b0 : p 102)
    (b1 : p 107)
    (b2 : p 123)
    (h79 : (¬ p 102) ∨ p 4)
    (h80 : (¬ p 102) ∨ p 9)
    (h81 : (¬ p 102) ∨ p 10)
    (h180 : (¬ p 61) ∨ (¬ p 31))
    (h182 : (¬ p 62) ∨ p 17)
    (h187 : (¬ p 64) ∨ (¬ p 4))
    (h191 : (¬ p 65) ∨ p 20)
    (h197 : (¬ p 67) ∨ p 22)
    (h202 : (¬ p 69) ∨ (¬ p 9))
    (h205 : (¬ p 70) ∨ (¬ p 10))
    (h213 : (¬ p 72) ∨ (¬ p 42))
    (h216 : (¬ p 73) ∨ (¬ p 43))
    (h221 : (¬ p 75) ∨ p 30)
    (h227 : (¬ p 107) ∨ p 16)
    (h228 : (¬ p 107) ∨ p 26)
    (h229 : (¬ p 107) ∨ p 29)
    (h332 : p 61 ∨ p 62 ∨ p 64 ∨ p 65 ∨ p 67 ∨ p 69 ∨ p 70 ∨ p 72 ∨ p 73 ∨ p 75)
    (h357 : (¬ p 76) ∨ (¬ p 16))
    (h364 : (¬ p 78) ∨ p 33)
    (h365 : (¬ p 79) ∨ (¬ p 4))
    (h369 : (¬ p 80) ∨ (¬ p 20))
    (h373 : (¬ p 81) ∨ p 36)
    (h380 : (¬ p 84) ∨ (¬ p 9))
    (h383 : (¬ p 85) ∨ (¬ p 10))
    (h387 : (¬ p 86) ∨ (¬ p 26))
    (h396 : (¬ p 89) ∨ (¬ p 29))
    (h400 : (¬ p 90) ∨ p 45)
    (h408 : (¬ p 123) ∨ p 31)
    (h409 : (¬ p 123) ∨ p 42)
    (h410 : (¬ p 123) ∨ p 43)
    (h507 : p 76 ∨ p 78 ∨ p 79 ∨ p 80 ∨ p 81 ∨ p 84 ∨ p 85 ∨ p 86 ∨ p 89 ∨ p 90)
    (h536 : (¬ p 10) ∨ (¬ p 16) ∨ (¬ p 45))
    (h537 : (¬ p 10) ∨ (¬ p 30) ∨ (¬ p 31))
    (h566 : (¬ p 9) ∨ (¬ p 17) ∨ (¬ p 43))
    (h585 : (¬ p 9) ∨ (¬ p 26) ∨ (¬ p 33))
    (h589 : (¬ p 4) ∨ (¬ p 29) ∨ (¬ p 36))
    (h594 : (¬ p 4) ∨ (¬ p 22) ∨ (¬ p 42))
    : False := by
  classical
  have u4 : p 4 := Or.elim h79 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u9 : p 9 := Or.elim h80 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u10 : p 10 := Or.elim h81 (fun t => False.elim (t b0)) (fun r0 => r0)
  have un64 : ¬ p 64 := Or.elim h187 (fun t => t) (fun r0 => False.elim (r0 u4))
  have un69 : ¬ p 69 := Or.elim h202 (fun t => t) (fun r0 => False.elim (r0 u9))
  have un70 : ¬ p 70 := Or.elim h205 (fun t => t) (fun r0 => False.elim (r0 u10))
  have u16 : p 16 := Or.elim h227 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u26 : p 26 := Or.elim h228 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u29 : p 29 := Or.elim h229 (fun t => False.elim (t b1)) (fun r0 => r0)
  have un76 : ¬ p 76 := Or.elim h357 (fun t => t) (fun r0 => False.elim (r0 u16))
  have un79 : ¬ p 79 := Or.elim h365 (fun t => t) (fun r0 => False.elim (r0 u4))
  have un84 : ¬ p 84 := Or.elim h380 (fun t => t) (fun r0 => False.elim (r0 u9))
  have un85 : ¬ p 85 := Or.elim h383 (fun t => t) (fun r0 => False.elim (r0 u10))
  have un86 : ¬ p 86 := Or.elim h387 (fun t => t) (fun r0 => False.elim (r0 u26))
  have un89 : ¬ p 89 := Or.elim h396 (fun t => t) (fun r0 => False.elim (r0 u29))
  have u31 : p 31 := Or.elim h408 (fun t => False.elim (t b2)) (fun r0 => r0)
  have u42 : p 42 := Or.elim h409 (fun t => False.elim (t b2)) (fun r0 => r0)
  have u43 : p 43 := Or.elim h410 (fun t => False.elim (t b2)) (fun r0 => r0)
  have un45 : ¬ p 45 := Or.elim h536 (fun t => False.elim (t u10)) (fun r0 => Or.elim r0 (fun t => False.elim (t u16)) (fun r1 => r1))
  have un30 : ¬ p 30 := Or.elim h537 (fun t => False.elim (t u10)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u31)))
  have un17 : ¬ p 17 := Or.elim h566 (fun t => False.elim (t u9)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u43)))
  have un33 : ¬ p 33 := Or.elim h585 (fun t => False.elim (t u9)) (fun r0 => Or.elim r0 (fun t => False.elim (t u26)) (fun r1 => r1))
  have un36 : ¬ p 36 := Or.elim h589 (fun t => False.elim (t u4)) (fun r0 => Or.elim r0 (fun t => False.elim (t u29)) (fun r1 => r1))
  have un22 : ¬ p 22 := Or.elim h594 (fun t => False.elim (t u4)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u42)))
  have un61 : ¬ p 61 := Or.elim h180 (fun t => t) (fun r0 => False.elim (r0 u31))
  have un62 : ¬ p 62 := Or.elim h182 (fun t => t) (fun r0 => False.elim (un17 r0))
  have un67 : ¬ p 67 := Or.elim h197 (fun t => t) (fun r0 => False.elim (un22 r0))
  have un72 : ¬ p 72 := Or.elim h213 (fun t => t) (fun r0 => False.elim (r0 u42))
  have un73 : ¬ p 73 := Or.elim h216 (fun t => t) (fun r0 => False.elim (r0 u43))
  have un75 : ¬ p 75 := Or.elim h221 (fun t => t) (fun r0 => False.elim (un30 r0))
  have u65 : p 65 := Or.elim h332 (fun t => False.elim (un61 t)) (fun r0 => Or.elim r0 (fun t => False.elim (un62 t)) (fun r1 => Or.elim r1 (fun t => False.elim (un64 t)) (fun r2 => Or.elim r2 (fun t => t) (fun r3 => Or.elim r3 (fun t => False.elim (un67 t)) (fun r4 => Or.elim r4 (fun t => False.elim (un69 t)) (fun r5 => Or.elim r5 (fun t => False.elim (un70 t)) (fun r6 => Or.elim r6 (fun t => False.elim (un72 t)) (fun r7 => Or.elim r7 (fun t => False.elim (un73 t)) (fun r8 => False.elim (un75 r8))))))))))
  have un78 : ¬ p 78 := Or.elim h364 (fun t => t) (fun r0 => False.elim (un33 r0))
  have un81 : ¬ p 81 := Or.elim h373 (fun t => t) (fun r0 => False.elim (un36 r0))
  have un90 : ¬ p 90 := Or.elim h400 (fun t => t) (fun r0 => False.elim (un45 r0))
  have u80 : p 80 := Or.elim h507 (fun t => False.elim (un76 t)) (fun r0 => Or.elim r0 (fun t => False.elim (un78 t)) (fun r1 => Or.elim r1 (fun t => False.elim (un79 t)) (fun r2 => Or.elim r2 (fun t => t) (fun r3 => Or.elim r3 (fun t => False.elim (un81 t)) (fun r4 => Or.elim r4 (fun t => False.elim (un84 t)) (fun r5 => Or.elim r5 (fun t => False.elim (un85 t)) (fun r6 => Or.elim r6 (fun t => False.elim (un86 t)) (fun r7 => Or.elim r7 (fun t => False.elim (un89 t)) (fun r8 => False.elim (un90 r8))))))))))
  have u20 : p 20 := Or.elim h191 (fun t => False.elim (t u65)) (fun r0 => r0)
  exact Or.elim h369 (fun t => (t u80)) (fun r0 => (r0 u20))

theorem branch12_1_2 (p : Nat → Prop)
    (b0 : p 103)
    (b1 : p 107)
    (b2 : p 123)
    (h84 : (¬ p 103) ∨ p 13)
    (h227 : (¬ p 107) ∨ p 16)
    (h409 : (¬ p 123) ∨ p 42)
    (h550 : (¬ p 13) ∨ (¬ p 16) ∨ (¬ p 42))
    : False := by
  classical
  have u13 : p 13 := Or.elim h84 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u16 : p 16 := Or.elim h227 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u42 : p 42 := Or.elim h409 (fun t => False.elim (t b2)) (fun r0 => r0)
  exact Or.elim h550 (fun t => (t u13)) (fun r0 => Or.elim r0 (fun t => (t u16)) (fun r1 => (r1 u42)))

theorem branch13_1_2 (p : Nat → Prop)
    (b0 : p 104)
    (b1 : p 107)
    (b2 : p 123)
    (h87 : (¬ p 104) ∨ p 11)
    (h229 : (¬ p 107) ∨ p 29)
    (h408 : (¬ p 123) ∨ p 31)
    (h543 : (¬ p 11) ∨ (¬ p 29) ∨ (¬ p 31))
    : False := by
  classical
  have u11 : p 11 := Or.elim h87 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u29 : p 29 := Or.elim h229 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u31 : p 31 := Or.elim h408 (fun t => False.elim (t b2)) (fun r0 => r0)
  exact Or.elim h543 (fun t => (t u11)) (fun r0 => Or.elim r0 (fun t => (t u29)) (fun r1 => (r1 u31)))

theorem branch14_1_2 (p : Nat → Prop)
    (b0 : p 105)
    (b1 : p 107)
    (b2 : p 123)
    (h88 : (¬ p 105) ∨ p 5)
    (h89 : (¬ p 105) ∨ p 8)
    (h90 : (¬ p 105) ∨ p 10)
    (h180 : (¬ p 61) ∨ (¬ p 31))
    (h185 : (¬ p 63) ∨ p 18)
    (h188 : (¬ p 64) ∨ p 19)
    (h190 : (¬ p 65) ∨ (¬ p 5))
    (h194 : (¬ p 66) ∨ p 21)
    (h199 : (¬ p 68) ∨ (¬ p 8))
    (h205 : (¬ p 70) ∨ (¬ p 10))
    (h213 : (¬ p 72) ∨ (¬ p 42))
    (h216 : (¬ p 73) ∨ (¬ p 43))
    (h221 : (¬ p 75) ∨ p 30)
    (h227 : (¬ p 107) ∨ p 16)
    (h228 : (¬ p 107) ∨ p 26)
    (h229 : (¬ p 107) ∨ p 29)
    (h330 : p 61 ∨ p 63 ∨ p 64 ∨ p 65 ∨ p 66 ∨ p 68 ∨ p 70 ∨ p 72 ∨ p 73 ∨ p 75)
    (h357 : (¬ p 76) ∨ (¬ p 16))
    (h361 : (¬ p 77) ∨ p 32)
    (h366 : (¬ p 79) ∨ (¬ p 19))
    (h368 : (¬ p 80) ∨ (¬ p 5))
    (h376 : (¬ p 82) ∨ p 37)
    (h377 : (¬ p 83) ∨ (¬ p 8))
    (h383 : (¬ p 85) ∨ (¬ p 10))
    (h387 : (¬ p 86) ∨ (¬ p 26))
    (h396 : (¬ p 89) ∨ (¬ p 29))
    (h400 : (¬ p 90) ∨ p 45)
    (h408 : (¬ p 123) ∨ p 31)
    (h409 : (¬ p 123) ∨ p 42)
    (h410 : (¬ p 123) ∨ p 43)
    (h511 : p 76 ∨ p 77 ∨ p 79 ∨ p 80 ∨ p 82 ∨ p 83 ∨ p 85 ∨ p 86 ∨ p 89 ∨ p 90)
    (h536 : (¬ p 10) ∨ (¬ p 16) ∨ (¬ p 45))
    (h537 : (¬ p 10) ∨ (¬ p 30) ∨ (¬ p 31))
    (h561 : (¬ p 8) ∨ (¬ p 29) ∨ (¬ p 32))
    (h578 : (¬ p 8) ∨ (¬ p 18) ∨ (¬ p 42))
    (h606 : (¬ p 5) ∨ (¬ p 21) ∨ (¬ p 43))
    (h613 : (¬ p 5) ∨ (¬ p 26) ∨ (¬ p 37))
    : False := by
  classical
  have u5 : p 5 := Or.elim h88 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u8 : p 8 := Or.elim h89 (fun t => False.elim (t b0)) (fun r0 => r0)
  have u10 : p 10 := Or.elim h90 (fun t => False.elim (t b0)) (fun r0 => r0)
  have un65 : ¬ p 65 := Or.elim h190 (fun t => t) (fun r0 => False.elim (r0 u5))
  have un68 : ¬ p 68 := Or.elim h199 (fun t => t) (fun r0 => False.elim (r0 u8))
  have un70 : ¬ p 70 := Or.elim h205 (fun t => t) (fun r0 => False.elim (r0 u10))
  have u16 : p 16 := Or.elim h227 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u26 : p 26 := Or.elim h228 (fun t => False.elim (t b1)) (fun r0 => r0)
  have u29 : p 29 := Or.elim h229 (fun t => False.elim (t b1)) (fun r0 => r0)
  have un76 : ¬ p 76 := Or.elim h357 (fun t => t) (fun r0 => False.elim (r0 u16))
  have un80 : ¬ p 80 := Or.elim h368 (fun t => t) (fun r0 => False.elim (r0 u5))
  have un83 : ¬ p 83 := Or.elim h377 (fun t => t) (fun r0 => False.elim (r0 u8))
  have un85 : ¬ p 85 := Or.elim h383 (fun t => t) (fun r0 => False.elim (r0 u10))
  have un86 : ¬ p 86 := Or.elim h387 (fun t => t) (fun r0 => False.elim (r0 u26))
  have un89 : ¬ p 89 := Or.elim h396 (fun t => t) (fun r0 => False.elim (r0 u29))
  have u31 : p 31 := Or.elim h408 (fun t => False.elim (t b2)) (fun r0 => r0)
  have u42 : p 42 := Or.elim h409 (fun t => False.elim (t b2)) (fun r0 => r0)
  have u43 : p 43 := Or.elim h410 (fun t => False.elim (t b2)) (fun r0 => r0)
  have un45 : ¬ p 45 := Or.elim h536 (fun t => False.elim (t u10)) (fun r0 => Or.elim r0 (fun t => False.elim (t u16)) (fun r1 => r1))
  have un30 : ¬ p 30 := Or.elim h537 (fun t => False.elim (t u10)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u31)))
  have un32 : ¬ p 32 := Or.elim h561 (fun t => False.elim (t u8)) (fun r0 => Or.elim r0 (fun t => False.elim (t u29)) (fun r1 => r1))
  have un18 : ¬ p 18 := Or.elim h578 (fun t => False.elim (t u8)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u42)))
  have un21 : ¬ p 21 := Or.elim h606 (fun t => False.elim (t u5)) (fun r0 => Or.elim r0 (fun t => t) (fun r1 => False.elim (r1 u43)))
  have un37 : ¬ p 37 := Or.elim h613 (fun t => False.elim (t u5)) (fun r0 => Or.elim r0 (fun t => False.elim (t u26)) (fun r1 => r1))
  have un61 : ¬ p 61 := Or.elim h180 (fun t => t) (fun r0 => False.elim (r0 u31))
  have un63 : ¬ p 63 := Or.elim h185 (fun t => t) (fun r0 => False.elim (un18 r0))
  have un66 : ¬ p 66 := Or.elim h194 (fun t => t) (fun r0 => False.elim (un21 r0))
  have un72 : ¬ p 72 := Or.elim h213 (fun t => t) (fun r0 => False.elim (r0 u42))
  have un73 : ¬ p 73 := Or.elim h216 (fun t => t) (fun r0 => False.elim (r0 u43))
  have un75 : ¬ p 75 := Or.elim h221 (fun t => t) (fun r0 => False.elim (un30 r0))
  have u64 : p 64 := Or.elim h330 (fun t => False.elim (un61 t)) (fun r0 => Or.elim r0 (fun t => False.elim (un63 t)) (fun r1 => Or.elim r1 (fun t => t) (fun r2 => Or.elim r2 (fun t => False.elim (un65 t)) (fun r3 => Or.elim r3 (fun t => False.elim (un66 t)) (fun r4 => Or.elim r4 (fun t => False.elim (un68 t)) (fun r5 => Or.elim r5 (fun t => False.elim (un70 t)) (fun r6 => Or.elim r6 (fun t => False.elim (un72 t)) (fun r7 => Or.elim r7 (fun t => False.elim (un73 t)) (fun r8 => False.elim (un75 r8))))))))))
  have un77 : ¬ p 77 := Or.elim h361 (fun t => t) (fun r0 => False.elim (un32 r0))
  have un82 : ¬ p 82 := Or.elim h376 (fun t => t) (fun r0 => False.elim (un37 r0))
  have un90 : ¬ p 90 := Or.elim h400 (fun t => t) (fun r0 => False.elim (un45 r0))
  have u79 : p 79 := Or.elim h511 (fun t => False.elim (un76 t)) (fun r0 => Or.elim r0 (fun t => False.elim (un77 t)) (fun r1 => Or.elim r1 (fun t => t) (fun r2 => Or.elim r2 (fun t => False.elim (un80 t)) (fun r3 => Or.elim r3 (fun t => False.elim (un82 t)) (fun r4 => Or.elim r4 (fun t => False.elim (un83 t)) (fun r5 => Or.elim r5 (fun t => False.elim (un85 t)) (fun r6 => Or.elim r6 (fun t => False.elim (un86 t)) (fun r7 => Or.elim r7 (fun t => False.elim (un89 t)) (fun r8 => False.elim (un90 r8))))))))))
  have u19 : p 19 := Or.elim h188 (fun t => False.elim (t u64)) (fun r0 => r0)
  exact Or.elim h366 (fun t => (t u79)) (fun r0 => (r0 u19))

theorem branch0_1_2 (p : Nat → Prop)
    (g : p 107) (b : p 123)
    (ex : p 94 ∨ p 95 ∨ p 96 ∨ p 97 ∨ p 98 ∨ p 99 ∨ p 100 ∨ p 101 ∨ p 102 ∨ p 103 ∨ p 104 ∨ p 105)
    (h55 : (¬ p 94) ∨ p 2)
    (h56 : (¬ p 94) ∨ p 7)
    (h57 : (¬ p 94) ∨ p 15)
    (h60 : (¬ p 95) ∨ p 14)
    (h63 : (¬ p 96) ∨ p 13)
    (h64 : (¬ p 97) ∨ p 3)
    (h65 : (¬ p 97) ∨ p 6)
    (h66 : (¬ p 97) ∨ p 15)
    (h69 : (¬ p 98) ∨ p 12)
    (h72 : (¬ p 99) ∨ p 11)
    (h75 : (¬ p 100) ∨ p 14)
    (h78 : (¬ p 101) ∨ p 12)
    (h79 : (¬ p 102) ∨ p 4)
    (h80 : (¬ p 102) ∨ p 9)
    (h81 : (¬ p 102) ∨ p 10)
    (h84 : (¬ p 103) ∨ p 13)
    (h87 : (¬ p 104) ∨ p 11)
    (h88 : (¬ p 105) ∨ p 5)
    (h89 : (¬ p 105) ∨ p 8)
    (h90 : (¬ p 105) ∨ p 10)
    (h180 : (¬ p 61) ∨ (¬ p 31))
    (h181 : (¬ p 62) ∨ (¬ p 2))
    (h182 : (¬ p 62) ∨ p 17)
    (h184 : (¬ p 63) ∨ (¬ p 3))
    (h185 : (¬ p 63) ∨ p 18)
    (h187 : (¬ p 64) ∨ (¬ p 4))
    (h188 : (¬ p 64) ∨ p 19)
    (h190 : (¬ p 65) ∨ (¬ p 5))
    (h191 : (¬ p 65) ∨ p 20)
    (h193 : (¬ p 66) ∨ (¬ p 6))
    (h194 : (¬ p 66) ∨ p 21)
    (h196 : (¬ p 67) ∨ (¬ p 7))
    (h197 : (¬ p 67) ∨ p 22)
    (h199 : (¬ p 68) ∨ (¬ p 8))
    (h200 : (¬ p 68) ∨ p 23)
    (h202 : (¬ p 69) ∨ (¬ p 9))
    (h203 : (¬ p 69) ∨ p 24)
    (h205 : (¬ p 70) ∨ (¬ p 10))
    (h206 : (¬ p 70) ∨ p 25)
    (h213 : (¬ p 72) ∨ (¬ p 42))
    (h216 : (¬ p 73) ∨ (¬ p 43))
    (h220 : (¬ p 75) ∨ (¬ p 15))
    (h221 : (¬ p 75) ∨ p 30)
    (h227 : (¬ p 107) ∨ p 16)
    (h228 : (¬ p 107) ∨ p 26)
    (h229 : (¬ p 107) ∨ p 29)
    (h330 : p 61 ∨ p 63 ∨ p 64 ∨ p 65 ∨ p 66 ∨ p 68 ∨ p 70 ∨ p 72 ∨ p 73 ∨ p 75)
    (h332 : p 61 ∨ p 62 ∨ p 64 ∨ p 65 ∨ p 67 ∨ p 69 ∨ p 70 ∨ p 72 ∨ p 73 ∨ p 75)
    (h338 : p 61 ∨ p 62 ∨ p 63 ∨ p 64 ∨ p 67 ∨ p 69 ∨ p 70 ∨ p 72 ∨ p 73 ∨ p 75)
    (h340 : p 61 ∨ p 62 ∨ p 63 ∨ p 65 ∨ p 66 ∨ p 68 ∨ p 70 ∨ p 72 ∨ p 73 ∨ p 75)
    (h357 : (¬ p 76) ∨ (¬ p 16))
    (h359 : (¬ p 77) ∨ (¬ p 2))
    (h360 : (¬ p 77) ∨ (¬ p 17))
    (h361 : (¬ p 77) ∨ p 32)
    (h362 : (¬ p 78) ∨ (¬ p 3))
    (h363 : (¬ p 78) ∨ (¬ p 18))
    (h364 : (¬ p 78) ∨ p 33)
    (h365 : (¬ p 79) ∨ (¬ p 4))
    (h366 : (¬ p 79) ∨ (¬ p 19))
    (h367 : (¬ p 79) ∨ p 34)
    (h368 : (¬ p 80) ∨ (¬ p 5))
    (h369 : (¬ p 80) ∨ (¬ p 20))
    (h370 : (¬ p 80) ∨ p 35)
    (h371 : (¬ p 81) ∨ (¬ p 6))
    (h373 : (¬ p 81) ∨ p 36)
    (h374 : (¬ p 82) ∨ (¬ p 7))
    (h376 : (¬ p 82) ∨ p 37)
    (h377 : (¬ p 83) ∨ (¬ p 8))
    (h379 : (¬ p 83) ∨ p 38)
    (h380 : (¬ p 84) ∨ (¬ p 9))
    (h382 : (¬ p 84) ∨ p 39)
    (h383 : (¬ p 85) ∨ (¬ p 10))
    (h385 : (¬ p 85) ∨ p 40)
    (h387 : (¬ p 86) ∨ (¬ p 26))
    (h396 : (¬ p 89) ∨ (¬ p 29))
    (h398 : (¬ p 90) ∨ (¬ p 15))
    (h400 : (¬ p 90) ∨ p 45)
    (h408 : (¬ p 123) ∨ p 31)
    (h409 : (¬ p 123) ∨ p 42)
    (h410 : (¬ p 123) ∨ p 43)
    (h507 : p 76 ∨ p 78 ∨ p 79 ∨ p 80 ∨ p 81 ∨ p 84 ∨ p 85 ∨ p 86 ∨ p 89 ∨ p 90)
    (h511 : p 76 ∨ p 77 ∨ p 79 ∨ p 80 ∨ p 82 ∨ p 83 ∨ p 85 ∨ p 86 ∨ p 89 ∨ p 90)
    (h515 : p 76 ∨ p 77 ∨ p 78 ∨ p 80 ∨ p 82 ∨ p 83 ∨ p 85 ∨ p 86 ∨ p 89 ∨ p 90)
    (h519 : p 76 ∨ p 77 ∨ p 78 ∨ p 79 ∨ p 81 ∨ p 84 ∨ p 85 ∨ p 86 ∨ p 89 ∨ p 90)
    (h536 : (¬ p 10) ∨ (¬ p 16) ∨ (¬ p 45))
    (h537 : (¬ p 10) ∨ (¬ p 30) ∨ (¬ p 31))
    (h538 : (¬ p 15) ∨ (¬ p 16) ∨ (¬ p 40))
    (h539 : (¬ p 15) ∨ (¬ p 25) ∨ (¬ p 31))
    (h543 : (¬ p 11) ∨ (¬ p 29) ∨ (¬ p 31))
    (h545 : (¬ p 14) ∨ (¬ p 26) ∨ (¬ p 31))
    (h548 : (¬ p 12) ∨ (¬ p 16) ∨ (¬ p 43))
    (h550 : (¬ p 13) ∨ (¬ p 16) ∨ (¬ p 42))
    (h559 : (¬ p 2) ∨ (¬ p 29) ∨ (¬ p 38))
    (h561 : (¬ p 8) ∨ (¬ p 29) ∨ (¬ p 32))
    (h564 : (¬ p 2) ∨ (¬ p 24) ∨ (¬ p 43))
    (h566 : (¬ p 9) ∨ (¬ p 17) ∨ (¬ p 43))
    (h576 : (¬ p 3) ∨ (¬ p 23) ∨ (¬ p 42))
    (h578 : (¬ p 8) ∨ (¬ p 18) ∨ (¬ p 42))
    (h583 : (¬ p 3) ∨ (¬ p 26) ∨ (¬ p 39))
    (h585 : (¬ p 9) ∨ (¬ p 26) ∨ (¬ p 33))
    (h589 : (¬ p 4) ∨ (¬ p 29) ∨ (¬ p 36))
    (h591 : (¬ p 6) ∨ (¬ p 29) ∨ (¬ p 34))
    (h594 : (¬ p 4) ∨ (¬ p 22) ∨ (¬ p 42))
    (h596 : (¬ p 7) ∨ (¬ p 19) ∨ (¬ p 42))
    (h606 : (¬ p 5) ∨ (¬ p 21) ∨ (¬ p 43))
    (h608 : (¬ p 6) ∨ (¬ p 20) ∨ (¬ p 43))
    (h613 : (¬ p 5) ∨ (¬ p 26) ∨ (¬ p 37))
    (h615 : (¬ p 7) ∨ (¬ p 26) ∨ (¬ p 35))
    : False := by
  rcases ex with red | ex
  · exact branch3_1_2 p red g b h55 h56 h57 h180 h181 h185 h188 h196 h203 h206 h213 h216 h220 h227 h228 h229 h338 h357 h359 h363 h370 h374 h379 h385 h387 h396 h398 h408 h409 h410 h515 h538 h539 h559 h564 h596 h615
  rcases ex with red | ex
  · exact branch4_1_2 p red g b h60 h228 h408 h545
  rcases ex with red | ex
  · exact branch5_1_2 p red g b h63 h227 h409 h550
  rcases ex with red | ex
  · exact branch6_1_2 p red g b h64 h65 h66 h180 h182 h184 h191 h193 h200 h206 h213 h216 h220 h227 h228 h229 h340 h357 h360 h362 h367 h371 h382 h385 h387 h396 h398 h408 h409 h410 h519 h538 h539 h576 h583 h591 h608
  rcases ex with red | ex
  · exact branch7_1_2 p red g b h69 h227 h410 h548
  rcases ex with red | ex
  · exact branch8_1_2 p red g b h72 h229 h408 h543
  rcases ex with red | ex
  · exact branch9_1_2 p red g b h75 h228 h408 h545
  rcases ex with red | ex
  · exact branch10_1_2 p red g b h78 h227 h410 h548
  rcases ex with red | ex
  · exact branch11_1_2 p red g b h79 h80 h81 h180 h182 h187 h191 h197 h202 h205 h213 h216 h221 h227 h228 h229 h332 h357 h364 h365 h369 h373 h380 h383 h387 h396 h400 h408 h409 h410 h507 h536 h537 h566 h585 h589 h594
  rcases ex with red | ex
  · exact branch12_1_2 p red g b h84 h227 h409 h550
  rcases ex with red | ex
  · exact branch13_1_2 p red g b h87 h229 h408 h543
  have red := ex
  exact branch14_1_2 p red g b h88 h89 h90 h180 h185 h188 h190 h194 h199 h205 h213 h216 h221 h227 h228 h229 h330 h357 h361 h366 h368 h376 h377 h383 h387 h396 h400 h408 h409 h410 h511 h536 h537 h561 h578 h606 h613

end Gamma


namespace OORaw



def atom (g : Support) (n : Nat) : Prop :=
  let i := n-1
  let c : Fin 3 := (i / 15 : Nat)
  let e : Fin 15 := (i : Nat)
  if i < 45 then g.S c e else if i < 90 then g.T c e else g.P c e

theorem clauseImp {a b : Prop} (h : a → b) : ¬ a ∨ b := by
  classical
  by_cases ha : a
  · exact Or.inr (h ha)
  · exact Or.inl ha

theorem forbidThree {a b c : Prop} (h : a → b → c → False) : ¬ a ∨ ¬ b ∨ ¬ c := by
  classical
  by_cases ha : a
  · exact Or.inr (clauseImp (h ha))
  · exact Or.inl ha

theorem rawClause1 (g : Support) :

    (¬ g.T 0 0) ∨ (¬ g.S 1 0) := by

  exact clauseImp (g.active_private 0 1 0 (by decide))

theorem rawClause5 (g : Support) :

    (¬ g.T 0 1) ∨ (¬ g.S 2 1) := by

  exact clauseImp (g.active_private 0 2 1 (by decide))

theorem rawClause6 (g : Support) :

    (¬ g.T 0 2) ∨ (g.S 0 2) := by

  exact clauseImp (g.active_support 0 2)

theorem rawClause12 (g : Support) :

    (¬ g.T 0 4) ∨ (g.S 0 4) := by

  exact clauseImp (g.active_support 0 4)

theorem rawClause18 (g : Support) :

    (¬ g.T 0 6) ∨ (g.S 0 6) := by

  exact clauseImp (g.active_support 0 6)

theorem rawClause21 (g : Support) :

    (¬ g.T 0 7) ∨ (g.S 0 7) := by

  exact clauseImp (g.active_support 0 7)

theorem rawClause23 (g : Support) :

    (¬ g.T 0 7) ∨ (¬ g.S 2 7) := by

  exact clauseImp (g.active_private 0 2 7 (by decide))

theorem rawClause26 (g : Support) :

    (¬ g.T 0 8) ∨ (¬ g.S 2 8) := by

  exact clauseImp (g.active_private 0 2 8 (by decide))

theorem rawClause28 (g : Support) :

    (¬ g.T 0 9) ∨ (¬ g.S 1 9) := by

  exact clauseImp (g.active_private 0 1 9 (by decide))

theorem rawClause30 (g : Support) :

    (¬ g.T 0 10) ∨ (g.S 0 10) := by

  exact clauseImp (g.active_support 0 10)

theorem rawClause31 (g : Support) :

    (¬ g.T 0 10) ∨ (¬ g.S 1 10) := by

  exact clauseImp (g.active_private 0 1 10 (by decide))

theorem rawClause33 (g : Support) :

    (¬ g.T 0 11) ∨ (g.S 0 11) := by

  exact clauseImp (g.active_support 0 11)

theorem rawClause38 (g : Support) :

    (¬ g.T 0 12) ∨ (¬ g.S 2 12) := by

  exact clauseImp (g.active_private 0 2 12 (by decide))

theorem rawClause40 (g : Support) :

    (¬ g.T 0 13) ∨ (¬ g.S 1 13) := by

  exact clauseImp (g.active_private 0 1 13 (by decide))

theorem rawClause41 (g : Support) :

    (¬ g.T 0 13) ∨ (¬ g.S 2 13) := by

  exact clauseImp (g.active_private 0 2 13 (by decide))

theorem rawClause43 (g : Support) :

    (¬ g.T 0 14) ∨ (¬ g.S 1 14) := by

  exact clauseImp (g.active_private 0 1 14 (by decide))

theorem rawClause46 (g : Support) :

    (¬ g.P 0 0) ∨ (g.S 0 0) := by

  exact clauseImp (g.matching_support 0 0 0)

theorem rawClause47 (g : Support) :

    (¬ g.P 0 0) ∨ (g.S 0 9) := by

  exact clauseImp (g.matching_support 0 0 1)

theorem rawClause48 (g : Support) :

    (¬ g.P 0 0) ∨ (g.S 0 14) := by

  exact clauseImp (g.matching_support 0 0 2)

theorem rawClause55 (g : Support) :

    (¬ g.P 0 3) ∨ (g.S 0 1) := by

  exact clauseImp (g.matching_support 0 3 0)

theorem rawClause56 (g : Support) :

    (¬ g.P 0 3) ∨ (g.S 0 6) := by

  exact clauseImp (g.matching_support 0 3 1)

theorem rawClause57 (g : Support) :

    (¬ g.P 0 3) ∨ (g.S 0 14) := by

  exact clauseImp (g.matching_support 0 3 2)

theorem rawClause60 (g : Support) :

    (¬ g.P 0 4) ∨ (g.S 0 13) := by

  exact clauseImp (g.matching_support 0 4 2)

theorem rawClause63 (g : Support) :

    (¬ g.P 0 5) ∨ (g.S 0 12) := by

  exact clauseImp (g.matching_support 0 5 2)

theorem rawClause64 (g : Support) :

    (¬ g.P 0 6) ∨ (g.S 0 2) := by

  exact clauseImp (g.matching_support 0 6 0)

theorem rawClause65 (g : Support) :

    (¬ g.P 0 6) ∨ (g.S 0 5) := by

  exact clauseImp (g.matching_support 0 6 1)

theorem rawClause66 (g : Support) :

    (¬ g.P 0 6) ∨ (g.S 0 14) := by

  exact clauseImp (g.matching_support 0 6 2)

theorem rawClause69 (g : Support) :

    (¬ g.P 0 7) ∨ (g.S 0 11) := by

  exact clauseImp (g.matching_support 0 7 2)

theorem rawClause72 (g : Support) :

    (¬ g.P 0 8) ∨ (g.S 0 10) := by

  exact clauseImp (g.matching_support 0 8 2)

theorem rawClause75 (g : Support) :

    (¬ g.P 0 9) ∨ (g.S 0 13) := by

  exact clauseImp (g.matching_support 0 9 2)

theorem rawClause78 (g : Support) :

    (¬ g.P 0 10) ∨ (g.S 0 11) := by

  exact clauseImp (g.matching_support 0 10 2)

theorem rawClause79 (g : Support) :

    (¬ g.P 0 11) ∨ (g.S 0 3) := by

  exact clauseImp (g.matching_support 0 11 0)

theorem rawClause80 (g : Support) :

    (¬ g.P 0 11) ∨ (g.S 0 8) := by

  exact clauseImp (g.matching_support 0 11 1)

theorem rawClause81 (g : Support) :

    (¬ g.P 0 11) ∨ (g.S 0 9) := by

  exact clauseImp (g.matching_support 0 11 2)

theorem rawClause84 (g : Support) :

    (¬ g.P 0 12) ∨ (g.S 0 12) := by

  exact clauseImp (g.matching_support 0 12 2)

theorem rawClause87 (g : Support) :

    (¬ g.P 0 13) ∨ (g.S 0 10) := by

  exact clauseImp (g.matching_support 0 13 2)

theorem rawClause88 (g : Support) :

    (¬ g.P 0 14) ∨ (g.S 0 4) := by

  exact clauseImp (g.matching_support 0 14 0)

theorem rawClause89 (g : Support) :

    (¬ g.P 0 14) ∨ (g.S 0 7) := by

  exact clauseImp (g.matching_support 0 14 1)

theorem rawClause90 (g : Support) :

    (¬ g.P 0 14) ∨ (g.S 0 9) := by

  exact clauseImp (g.matching_support 0 14 2)

theorem rawClause156 (g : Support) :

    (g.T 0 0) ∨ (g.T 0 1) ∨ (g.T 0 2) ∨ (g.T 0 4) ∨ (g.T 0 7) ∨ (g.T 0 8) ∨ (g.T 0 10) ∨ (g.T 0 11) ∨ (g.T 0 12) ∨ (g.T 0 13) := by

  obtain ⟨e, ht, hx⟩ := g.cut 0 ![1, 0, 0, 0, -1, 1] (by decide)

  fin_cases e

  · exact Or.inl (ht)

  · exact Or.inr (Or.inl (ht))

  · exact Or.inr (Or.inr (Or.inl (ht)))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inl (ht))))

  · exact False.elim (hx (by decide))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (ht)))))))))

  · exact False.elim (hx (by decide))

theorem rawClause159 (g : Support) :

    (g.T 0 0) ∨ (g.T 0 1) ∨ (g.T 0 2) ∨ (g.T 0 4) ∨ (g.T 0 6) ∨ (g.T 0 7) ∨ (g.T 0 9) ∨ (g.T 0 10) ∨ (g.T 0 13) ∨ (g.T 0 14) := by

  obtain ⟨e, ht, hx⟩ := g.cut 0 ![1, 0, 0, 1, -1, 0] (by decide)

  fin_cases e

  · exact Or.inl (ht)

  · exact Or.inr (Or.inl (ht))

  · exact Or.inr (Or.inr (Or.inl (ht)))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inl (ht))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))))

  · exact False.elim (hx (by decide))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (ht)))))))))

theorem rawClause178 (g : Support) :

    (¬ g.T 1 0) ∨ (¬ g.S 0 0) := by

  exact clauseImp (g.active_private 1 0 0 (by decide))

theorem rawClause180 (g : Support) :

    (¬ g.T 1 0) ∨ (¬ g.S 2 0) := by

  exact clauseImp (g.active_private 1 2 0 (by decide))

theorem rawClause181 (g : Support) :

    (¬ g.T 1 1) ∨ (¬ g.S 0 1) := by

  exact clauseImp (g.active_private 1 0 1 (by decide))

theorem rawClause182 (g : Support) :

    (¬ g.T 1 1) ∨ (g.S 1 1) := by

  exact clauseImp (g.active_support 1 1)

theorem rawClause183 (g : Support) :

    (¬ g.T 1 1) ∨ (¬ g.S 2 1) := by

  exact clauseImp (g.active_private 1 2 1 (by decide))

theorem rawClause184 (g : Support) :

    (¬ g.T 1 2) ∨ (¬ g.S 0 2) := by

  exact clauseImp (g.active_private 1 0 2 (by decide))

theorem rawClause185 (g : Support) :

    (¬ g.T 1 2) ∨ (g.S 1 2) := by

  exact clauseImp (g.active_support 1 2)

theorem rawClause187 (g : Support) :

    (¬ g.T 1 3) ∨ (¬ g.S 0 3) := by

  exact clauseImp (g.active_private 1 0 3 (by decide))

theorem rawClause188 (g : Support) :

    (¬ g.T 1 3) ∨ (g.S 1 3) := by

  exact clauseImp (g.active_support 1 3)

theorem rawClause190 (g : Support) :

    (¬ g.T 1 4) ∨ (¬ g.S 0 4) := by

  exact clauseImp (g.active_private 1 0 4 (by decide))

theorem rawClause191 (g : Support) :

    (¬ g.T 1 4) ∨ (g.S 1 4) := by

  exact clauseImp (g.active_support 1 4)

theorem rawClause193 (g : Support) :

    (¬ g.T 1 5) ∨ (¬ g.S 0 5) := by

  exact clauseImp (g.active_private 1 0 5 (by decide))

theorem rawClause194 (g : Support) :

    (¬ g.T 1 5) ∨ (g.S 1 5) := by

  exact clauseImp (g.active_support 1 5)

theorem rawClause196 (g : Support) :

    (¬ g.T 1 6) ∨ (¬ g.S 0 6) := by

  exact clauseImp (g.active_private 1 0 6 (by decide))

theorem rawClause197 (g : Support) :

    (¬ g.T 1 6) ∨ (g.S 1 6) := by

  exact clauseImp (g.active_support 1 6)

theorem rawClause199 (g : Support) :

    (¬ g.T 1 7) ∨ (¬ g.S 0 7) := by

  exact clauseImp (g.active_private 1 0 7 (by decide))

theorem rawClause200 (g : Support) :

    (¬ g.T 1 7) ∨ (g.S 1 7) := by

  exact clauseImp (g.active_support 1 7)

theorem rawClause201 (g : Support) :

    (¬ g.T 1 7) ∨ (¬ g.S 2 7) := by

  exact clauseImp (g.active_private 1 2 7 (by decide))

theorem rawClause202 (g : Support) :

    (¬ g.T 1 8) ∨ (¬ g.S 0 8) := by

  exact clauseImp (g.active_private 1 0 8 (by decide))

theorem rawClause203 (g : Support) :

    (¬ g.T 1 8) ∨ (g.S 1 8) := by

  exact clauseImp (g.active_support 1 8)

theorem rawClause204 (g : Support) :

    (¬ g.T 1 8) ∨ (¬ g.S 2 8) := by

  exact clauseImp (g.active_private 1 2 8 (by decide))

theorem rawClause205 (g : Support) :

    (¬ g.T 1 9) ∨ (¬ g.S 0 9) := by

  exact clauseImp (g.active_private 1 0 9 (by decide))

theorem rawClause206 (g : Support) :

    (¬ g.T 1 9) ∨ (g.S 1 9) := by

  exact clauseImp (g.active_support 1 9)

theorem rawClause209 (g : Support) :

    (¬ g.T 1 10) ∨ (g.S 1 10) := by

  exact clauseImp (g.active_support 1 10)

theorem rawClause212 (g : Support) :

    (¬ g.T 1 11) ∨ (g.S 1 11) := by

  exact clauseImp (g.active_support 1 11)

theorem rawClause213 (g : Support) :

    (¬ g.T 1 11) ∨ (¬ g.S 2 11) := by

  exact clauseImp (g.active_private 1 2 11 (by decide))

theorem rawClause216 (g : Support) :

    (¬ g.T 1 12) ∨ (¬ g.S 2 12) := by

  exact clauseImp (g.active_private 1 2 12 (by decide))

theorem rawClause219 (g : Support) :

    (¬ g.T 1 13) ∨ (¬ g.S 2 13) := by

  exact clauseImp (g.active_private 1 2 13 (by decide))

theorem rawClause220 (g : Support) :

    (¬ g.T 1 14) ∨ (¬ g.S 0 14) := by

  exact clauseImp (g.active_private 1 0 14 (by decide))

theorem rawClause221 (g : Support) :

    (¬ g.T 1 14) ∨ (g.S 1 14) := by

  exact clauseImp (g.active_support 1 14)

theorem rawClause224 (g : Support) :

    (¬ g.P 1 0) ∨ (g.S 1 0) := by

  exact clauseImp (g.matching_support 1 0 0)

theorem rawClause225 (g : Support) :

    (¬ g.P 1 0) ∨ (g.S 1 9) := by

  exact clauseImp (g.matching_support 1 0 1)

theorem rawClause226 (g : Support) :

    (¬ g.P 1 0) ∨ (g.S 1 14) := by

  exact clauseImp (g.matching_support 1 0 2)

theorem rawClause227 (g : Support) :

    (¬ g.P 1 1) ∨ (g.S 1 0) := by

  exact clauseImp (g.matching_support 1 1 0)

theorem rawClause228 (g : Support) :

    (¬ g.P 1 1) ∨ (g.S 1 10) := by

  exact clauseImp (g.matching_support 1 1 1)

theorem rawClause229 (g : Support) :

    (¬ g.P 1 1) ∨ (g.S 1 13) := by

  exact clauseImp (g.matching_support 1 1 2)

theorem rawClause238 (g : Support) :

    (¬ g.P 1 4) ∨ (g.S 1 13) := by

  exact clauseImp (g.matching_support 1 4 2)

theorem rawClause330 (g : Support) :

    (g.T 1 0) ∨ (g.T 1 2) ∨ (g.T 1 3) ∨ (g.T 1 4) ∨ (g.T 1 5) ∨ (g.T 1 7) ∨ (g.T 1 9) ∨ (g.T 1 11) ∨ (g.T 1 12) ∨ (g.T 1 14) := by

  obtain ⟨e, ht, hx⟩ := g.cut 1 ![1, 0, -1, 0, 1, 0] (by decide)

  fin_cases e

  · exact Or.inl (ht)

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inl (ht))

  · exact Or.inr (Or.inr (Or.inl (ht)))

  · exact Or.inr (Or.inr (Or.inr (Or.inl (ht))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (ht)))))))))

theorem rawClause332 (g : Support) :

    (g.T 1 0) ∨ (g.T 1 1) ∨ (g.T 1 3) ∨ (g.T 1 4) ∨ (g.T 1 6) ∨ (g.T 1 8) ∨ (g.T 1 9) ∨ (g.T 1 11) ∨ (g.T 1 12) ∨ (g.T 1 14) := by

  obtain ⟨e, ht, hx⟩ := g.cut 1 ![1, 0, 0, -1, 0, 1] (by decide)

  fin_cases e

  · exact Or.inl (ht)

  · exact Or.inr (Or.inl (ht))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inl (ht)))

  · exact Or.inr (Or.inr (Or.inr (Or.inl (ht))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (ht)))))))))

theorem rawClause337 (g : Support) :

    (g.T 1 0) ∨ (g.T 1 1) ∨ (g.T 1 2) ∨ (g.T 1 4) ∨ (g.T 1 6) ∨ (g.T 1 7) ∨ (g.T 1 9) ∨ (g.T 1 10) ∨ (g.T 1 13) ∨ (g.T 1 14) := by

  obtain ⟨e, ht, hx⟩ := g.cut 1 ![1, 0, 0, 1, -1, 0] (by decide)

  fin_cases e

  · exact Or.inl (ht)

  · exact Or.inr (Or.inl (ht))

  · exact Or.inr (Or.inr (Or.inl (ht)))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inl (ht))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))))

  · exact False.elim (hx (by decide))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (ht)))))))))

theorem rawClause338 (g : Support) :

    (g.T 1 0) ∨ (g.T 1 1) ∨ (g.T 1 2) ∨ (g.T 1 3) ∨ (g.T 1 6) ∨ (g.T 1 8) ∨ (g.T 1 9) ∨ (g.T 1 11) ∨ (g.T 1 12) ∨ (g.T 1 14) := by

  obtain ⟨e, ht, hx⟩ := g.cut 1 ![1, 0, 0, 1, 0, -1] (by decide)

  fin_cases e

  · exact Or.inl (ht)

  · exact Or.inr (Or.inl (ht))

  · exact Or.inr (Or.inr (Or.inl (ht)))

  · exact Or.inr (Or.inr (Or.inr (Or.inl (ht))))

  · exact False.elim (hx (by decide))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (ht)))))))))

theorem rawClause340 (g : Support) :

    (g.T 1 0) ∨ (g.T 1 1) ∨ (g.T 1 2) ∨ (g.T 1 4) ∨ (g.T 1 5) ∨ (g.T 1 7) ∨ (g.T 1 9) ∨ (g.T 1 11) ∨ (g.T 1 12) ∨ (g.T 1 14) := by

  obtain ⟨e, ht, hx⟩ := g.cut 1 ![1, 0, 1, 0, -1, 0] (by decide)

  fin_cases e

  · exact Or.inl (ht)

  · exact Or.inr (Or.inl (ht))

  · exact Or.inr (Or.inr (Or.inl (ht)))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inl (ht))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (ht)))))))))

theorem rawClause357 (g : Support) :

    (¬ g.T 2 0) ∨ (¬ g.S 1 0) := by

  exact clauseImp (g.active_private 2 1 0 (by decide))

theorem rawClause359 (g : Support) :

    (¬ g.T 2 1) ∨ (¬ g.S 0 1) := by

  exact clauseImp (g.active_private 2 0 1 (by decide))

theorem rawClause360 (g : Support) :

    (¬ g.T 2 1) ∨ (¬ g.S 1 1) := by

  exact clauseImp (g.active_private 2 1 1 (by decide))

theorem rawClause361 (g : Support) :

    (¬ g.T 2 1) ∨ (g.S 2 1) := by

  exact clauseImp (g.active_support 2 1)

theorem rawClause362 (g : Support) :

    (¬ g.T 2 2) ∨ (¬ g.S 0 2) := by

  exact clauseImp (g.active_private 2 0 2 (by decide))

theorem rawClause363 (g : Support) :

    (¬ g.T 2 2) ∨ (¬ g.S 1 2) := by

  exact clauseImp (g.active_private 2 1 2 (by decide))

theorem rawClause364 (g : Support) :

    (¬ g.T 2 2) ∨ (g.S 2 2) := by

  exact clauseImp (g.active_support 2 2)

theorem rawClause365 (g : Support) :

    (¬ g.T 2 3) ∨ (¬ g.S 0 3) := by

  exact clauseImp (g.active_private 2 0 3 (by decide))

theorem rawClause366 (g : Support) :

    (¬ g.T 2 3) ∨ (¬ g.S 1 3) := by

  exact clauseImp (g.active_private 2 1 3 (by decide))

theorem rawClause367 (g : Support) :

    (¬ g.T 2 3) ∨ (g.S 2 3) := by

  exact clauseImp (g.active_support 2 3)

theorem rawClause368 (g : Support) :

    (¬ g.T 2 4) ∨ (¬ g.S 0 4) := by

  exact clauseImp (g.active_private 2 0 4 (by decide))

theorem rawClause369 (g : Support) :

    (¬ g.T 2 4) ∨ (¬ g.S 1 4) := by

  exact clauseImp (g.active_private 2 1 4 (by decide))

theorem rawClause370 (g : Support) :

    (¬ g.T 2 4) ∨ (g.S 2 4) := by

  exact clauseImp (g.active_support 2 4)

theorem rawClause371 (g : Support) :

    (¬ g.T 2 5) ∨ (¬ g.S 0 5) := by

  exact clauseImp (g.active_private 2 0 5 (by decide))

theorem rawClause373 (g : Support) :

    (¬ g.T 2 5) ∨ (g.S 2 5) := by

  exact clauseImp (g.active_support 2 5)

theorem rawClause374 (g : Support) :

    (¬ g.T 2 6) ∨ (¬ g.S 0 6) := by

  exact clauseImp (g.active_private 2 0 6 (by decide))

theorem rawClause376 (g : Support) :

    (¬ g.T 2 6) ∨ (g.S 2 6) := by

  exact clauseImp (g.active_support 2 6)

theorem rawClause377 (g : Support) :

    (¬ g.T 2 7) ∨ (¬ g.S 0 7) := by

  exact clauseImp (g.active_private 2 0 7 (by decide))

theorem rawClause379 (g : Support) :

    (¬ g.T 2 7) ∨ (g.S 2 7) := by

  exact clauseImp (g.active_support 2 7)

theorem rawClause380 (g : Support) :

    (¬ g.T 2 8) ∨ (¬ g.S 0 8) := by

  exact clauseImp (g.active_private 2 0 8 (by decide))

theorem rawClause382 (g : Support) :

    (¬ g.T 2 8) ∨ (g.S 2 8) := by

  exact clauseImp (g.active_support 2 8)

theorem rawClause383 (g : Support) :

    (¬ g.T 2 9) ∨ (¬ g.S 0 9) := by

  exact clauseImp (g.active_private 2 0 9 (by decide))

theorem rawClause385 (g : Support) :

    (¬ g.T 2 9) ∨ (g.S 2 9) := by

  exact clauseImp (g.active_support 2 9)

theorem rawClause387 (g : Support) :

    (¬ g.T 2 10) ∨ (¬ g.S 1 10) := by

  exact clauseImp (g.active_private 2 1 10 (by decide))

theorem rawClause396 (g : Support) :

    (¬ g.T 2 13) ∨ (¬ g.S 1 13) := by

  exact clauseImp (g.active_private 2 1 13 (by decide))

theorem rawClause398 (g : Support) :

    (¬ g.T 2 14) ∨ (¬ g.S 0 14) := by

  exact clauseImp (g.active_private 2 0 14 (by decide))

theorem rawClause400 (g : Support) :

    (¬ g.T 2 14) ∨ (g.S 2 14) := by

  exact clauseImp (g.active_support 2 14)

theorem rawClause404 (g : Support) :

    (¬ g.P 2 0) ∨ (g.S 2 14) := by

  exact clauseImp (g.matching_support 2 0 2)

theorem rawClause405 (g : Support) :

    (¬ g.P 2 1) ∨ (g.S 2 0) := by

  exact clauseImp (g.matching_support 2 1 0)

theorem rawClause408 (g : Support) :

    (¬ g.P 2 2) ∨ (g.S 2 0) := by

  exact clauseImp (g.matching_support 2 2 0)

theorem rawClause409 (g : Support) :

    (¬ g.P 2 2) ∨ (g.S 2 11) := by

  exact clauseImp (g.matching_support 2 2 1)

theorem rawClause410 (g : Support) :

    (¬ g.P 2 2) ∨ (g.S 2 12) := by

  exact clauseImp (g.matching_support 2 2 2)

theorem rawClause413 (g : Support) :

    (¬ g.P 2 3) ∨ (g.S 2 14) := by

  exact clauseImp (g.matching_support 2 3 2)

theorem rawClause414 (g : Support) :

    (¬ g.P 2 4) ∨ (g.S 2 1) := by

  exact clauseImp (g.matching_support 2 4 0)

theorem rawClause415 (g : Support) :

    (¬ g.P 2 4) ∨ (g.S 2 7) := by

  exact clauseImp (g.matching_support 2 4 1)

theorem rawClause416 (g : Support) :

    (¬ g.P 2 4) ∨ (g.S 2 13) := by

  exact clauseImp (g.matching_support 2 4 2)

theorem rawClause417 (g : Support) :

    (¬ g.P 2 5) ∨ (g.S 2 1) := by

  exact clauseImp (g.matching_support 2 5 0)

theorem rawClause418 (g : Support) :

    (¬ g.P 2 5) ∨ (g.S 2 8) := by

  exact clauseImp (g.matching_support 2 5 1)

theorem rawClause419 (g : Support) :

    (¬ g.P 2 5) ∨ (g.S 2 12) := by

  exact clauseImp (g.matching_support 2 5 2)

theorem rawClause428 (g : Support) :

    (¬ g.P 2 8) ∨ (g.S 2 10) := by

  exact clauseImp (g.matching_support 2 8 2)

theorem rawClause443 (g : Support) :

    (¬ g.P 2 13) ∨ (g.S 2 10) := by

  exact clauseImp (g.matching_support 2 13 2)

theorem rawClause507 (g : Support) :

    (g.T 2 0) ∨ (g.T 2 2) ∨ (g.T 2 3) ∨ (g.T 2 4) ∨ (g.T 2 5) ∨ (g.T 2 8) ∨ (g.T 2 9) ∨ (g.T 2 10) ∨ (g.T 2 13) ∨ (g.T 2 14) := by

  obtain ⟨e, ht, hx⟩ := g.cut 2 ![1, 0, -1, 0, 0, 1] (by decide)

  fin_cases e

  · exact Or.inl (ht)

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inl (ht))

  · exact Or.inr (Or.inr (Or.inl (ht)))

  · exact Or.inr (Or.inr (Or.inr (Or.inl (ht))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))

  · exact False.elim (hx (by decide))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))))

  · exact False.elim (hx (by decide))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (ht)))))))))

theorem rawClause511 (g : Support) :

    (g.T 2 0) ∨ (g.T 2 1) ∨ (g.T 2 3) ∨ (g.T 2 4) ∨ (g.T 2 6) ∨ (g.T 2 7) ∨ (g.T 2 9) ∨ (g.T 2 10) ∨ (g.T 2 13) ∨ (g.T 2 14) := by

  obtain ⟨e, ht, hx⟩ := g.cut 2 ![1, 0, 0, -1, 1, 0] (by decide)

  fin_cases e

  · exact Or.inl (ht)

  · exact Or.inr (Or.inl (ht))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inl (ht)))

  · exact Or.inr (Or.inr (Or.inr (Or.inl (ht))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))))

  · exact False.elim (hx (by decide))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (ht)))))))))

theorem rawClause515 (g : Support) :

    (g.T 2 0) ∨ (g.T 2 1) ∨ (g.T 2 2) ∨ (g.T 2 4) ∨ (g.T 2 6) ∨ (g.T 2 7) ∨ (g.T 2 9) ∨ (g.T 2 10) ∨ (g.T 2 13) ∨ (g.T 2 14) := by

  obtain ⟨e, ht, hx⟩ := g.cut 2 ![1, 0, 0, 1, -1, 0] (by decide)

  fin_cases e

  · exact Or.inl (ht)

  · exact Or.inr (Or.inl (ht))

  · exact Or.inr (Or.inr (Or.inl (ht)))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inl (ht))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))))

  · exact False.elim (hx (by decide))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (ht)))))))))

theorem rawClause519 (g : Support) :

    (g.T 2 0) ∨ (g.T 2 1) ∨ (g.T 2 2) ∨ (g.T 2 3) ∨ (g.T 2 5) ∨ (g.T 2 8) ∨ (g.T 2 9) ∨ (g.T 2 10) ∨ (g.T 2 13) ∨ (g.T 2 14) := by

  obtain ⟨e, ht, hx⟩ := g.cut 2 ![1, 0, 1, 0, 0, -1] (by decide)

  fin_cases e

  · exact Or.inl (ht)

  · exact Or.inr (Or.inl (ht))

  · exact Or.inr (Or.inr (Or.inl (ht)))

  · exact Or.inr (Or.inr (Or.inr (Or.inl (ht))))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))

  · exact False.elim (hx (by decide))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht))))))))

  · exact False.elim (hx (by decide))

  · exact False.elim (hx (by decide))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (ht)))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (ht)))))))))

theorem rawClause534 (g : Support) :

    (¬ g.S 0 0) ∨ (¬ g.S 1 9) ∨ (¬ g.S 2 14) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 0 ![0, 1, 2] (by decide)

  intro j

  fin_cases j

  · exact h0

  · exact h1

  · exact h2

theorem rawClause536 (g : Support) :

    (¬ g.S 0 9) ∨ (¬ g.S 1 0) ∨ (¬ g.S 2 14) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 0 ![1, 0, 2] (by decide)

  intro j

  fin_cases j

  · exact h1

  · exact h0

  · exact h2

theorem rawClause537 (g : Support) :

    (¬ g.S 0 9) ∨ (¬ g.S 1 14) ∨ (¬ g.S 2 0) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 0 ![2, 0, 1] (by decide)

  intro j

  fin_cases j

  · exact h2

  · exact h0

  · exact h1

theorem rawClause538 (g : Support) :

    (¬ g.S 0 14) ∨ (¬ g.S 1 0) ∨ (¬ g.S 2 9) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 0 ![1, 2, 0] (by decide)

  intro j

  fin_cases j

  · exact h1

  · exact h2

  · exact h0

theorem rawClause539 (g : Support) :

    (¬ g.S 0 14) ∨ (¬ g.S 1 9) ∨ (¬ g.S 2 0) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 0 ![2, 1, 0] (by decide)

  intro j

  fin_cases j

  · exact h2

  · exact h1

  · exact h0

theorem rawClause540 (g : Support) :

    (¬ g.S 0 0) ∨ (¬ g.S 1 10) ∨ (¬ g.S 2 13) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 1 ![0, 1, 2] (by decide)

  intro j

  fin_cases j

  · exact h0

  · exact h1

  · exact h2

theorem rawClause541 (g : Support) :

    (¬ g.S 0 0) ∨ (¬ g.S 1 13) ∨ (¬ g.S 2 10) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 1 ![0, 2, 1] (by decide)

  intro j

  fin_cases j

  · exact h0

  · exact h2

  · exact h1

theorem rawClause542 (g : Support) :

    (¬ g.S 0 10) ∨ (¬ g.S 1 0) ∨ (¬ g.S 2 13) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 1 ![1, 0, 2] (by decide)

  intro j

  fin_cases j

  · exact h1

  · exact h0

  · exact h2

theorem rawClause543 (g : Support) :

    (¬ g.S 0 10) ∨ (¬ g.S 1 13) ∨ (¬ g.S 2 0) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 1 ![2, 0, 1] (by decide)

  intro j

  fin_cases j

  · exact h2

  · exact h0

  · exact h1

theorem rawClause545 (g : Support) :

    (¬ g.S 0 13) ∨ (¬ g.S 1 10) ∨ (¬ g.S 2 0) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 1 ![2, 1, 0] (by decide)

  intro j

  fin_cases j

  · exact h2

  · exact h1

  · exact h0

theorem rawClause546 (g : Support) :

    (¬ g.S 0 0) ∨ (¬ g.S 1 11) ∨ (¬ g.S 2 12) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 2 ![0, 1, 2] (by decide)

  intro j

  fin_cases j

  · exact h0

  · exact h1

  · exact h2

theorem rawClause548 (g : Support) :

    (¬ g.S 0 11) ∨ (¬ g.S 1 0) ∨ (¬ g.S 2 12) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 2 ![1, 0, 2] (by decide)

  intro j

  fin_cases j

  · exact h1

  · exact h0

  · exact h2

theorem rawClause550 (g : Support) :

    (¬ g.S 0 12) ∨ (¬ g.S 1 0) ∨ (¬ g.S 2 11) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 2 ![1, 2, 0] (by decide)

  intro j

  fin_cases j

  · exact h1

  · exact h2

  · exact h0

theorem rawClause555 (g : Support) :

    (¬ g.S 0 6) ∨ (¬ g.S 1 14) ∨ (¬ g.S 2 1) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 3 ![2, 0, 1] (by decide)

  intro j

  fin_cases j

  · exact h2

  · exact h0

  · exact h1

theorem rawClause557 (g : Support) :

    (¬ g.S 0 14) ∨ (¬ g.S 1 6) ∨ (¬ g.S 2 1) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 3 ![2, 1, 0] (by decide)

  intro j

  fin_cases j

  · exact h2

  · exact h1

  · exact h0

theorem rawClause559 (g : Support) :

    (¬ g.S 0 1) ∨ (¬ g.S 1 13) ∨ (¬ g.S 2 7) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 4 ![0, 2, 1] (by decide)

  intro j

  fin_cases j

  · exact h0

  · exact h2

  · exact h1

theorem rawClause561 (g : Support) :

    (¬ g.S 0 7) ∨ (¬ g.S 1 13) ∨ (¬ g.S 2 1) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 4 ![2, 0, 1] (by decide)

  intro j

  fin_cases j

  · exact h2

  · exact h0

  · exact h1

theorem rawClause564 (g : Support) :

    (¬ g.S 0 1) ∨ (¬ g.S 1 8) ∨ (¬ g.S 2 12) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 5 ![0, 1, 2] (by decide)

  intro j

  fin_cases j

  · exact h0

  · exact h1

  · exact h2

theorem rawClause566 (g : Support) :

    (¬ g.S 0 8) ∨ (¬ g.S 1 1) ∨ (¬ g.S 2 12) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 5 ![1, 0, 2] (by decide)

  intro j

  fin_cases j

  · exact h1

  · exact h0

  · exact h2

theorem rawClause576 (g : Support) :

    (¬ g.S 0 2) ∨ (¬ g.S 1 7) ∨ (¬ g.S 2 11) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 7 ![0, 1, 2] (by decide)

  intro j

  fin_cases j

  · exact h0

  · exact h1

  · exact h2

theorem rawClause578 (g : Support) :

    (¬ g.S 0 7) ∨ (¬ g.S 1 2) ∨ (¬ g.S 2 11) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 7 ![1, 0, 2] (by decide)

  intro j

  fin_cases j

  · exact h1

  · exact h0

  · exact h2

theorem rawClause583 (g : Support) :

    (¬ g.S 0 2) ∨ (¬ g.S 1 10) ∨ (¬ g.S 2 8) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 8 ![0, 2, 1] (by decide)

  intro j

  fin_cases j

  · exact h0

  · exact h2

  · exact h1

theorem rawClause585 (g : Support) :

    (¬ g.S 0 8) ∨ (¬ g.S 1 10) ∨ (¬ g.S 2 2) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 8 ![2, 0, 1] (by decide)

  intro j

  fin_cases j

  · exact h2

  · exact h0

  · exact h1

theorem rawClause589 (g : Support) :

    (¬ g.S 0 3) ∨ (¬ g.S 1 13) ∨ (¬ g.S 2 5) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 9 ![0, 2, 1] (by decide)

  intro j

  fin_cases j

  · exact h0

  · exact h2

  · exact h1

theorem rawClause591 (g : Support) :

    (¬ g.S 0 5) ∨ (¬ g.S 1 13) ∨ (¬ g.S 2 3) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 9 ![2, 0, 1] (by decide)

  intro j

  fin_cases j

  · exact h2

  · exact h0

  · exact h1

theorem rawClause594 (g : Support) :

    (¬ g.S 0 3) ∨ (¬ g.S 1 6) ∨ (¬ g.S 2 11) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 10 ![0, 1, 2] (by decide)

  intro j

  fin_cases j

  · exact h0

  · exact h1

  · exact h2

theorem rawClause596 (g : Support) :

    (¬ g.S 0 6) ∨ (¬ g.S 1 3) ∨ (¬ g.S 2 11) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 10 ![1, 0, 2] (by decide)

  intro j

  fin_cases j

  · exact h1

  · exact h0

  · exact h2

theorem rawClause604 (g : Support) :

    (¬ g.S 0 9) ∨ (¬ g.S 1 3) ∨ (¬ g.S 2 8) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 11 ![1, 2, 0] (by decide)

  intro j

  fin_cases j

  · exact h1

  · exact h2

  · exact h0

theorem rawClause606 (g : Support) :

    (¬ g.S 0 4) ∨ (¬ g.S 1 5) ∨ (¬ g.S 2 12) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 12 ![0, 1, 2] (by decide)

  intro j

  fin_cases j

  · exact h0

  · exact h1

  · exact h2

theorem rawClause608 (g : Support) :

    (¬ g.S 0 5) ∨ (¬ g.S 1 4) ∨ (¬ g.S 2 12) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 12 ![1, 0, 2] (by decide)

  intro j

  fin_cases j

  · exact h1

  · exact h0

  · exact h2

theorem rawClause613 (g : Support) :

    (¬ g.S 0 4) ∨ (¬ g.S 1 10) ∨ (¬ g.S 2 6) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 13 ![0, 2, 1] (by decide)

  intro j

  fin_cases j

  · exact h0

  · exact h2

  · exact h1

theorem rawClause615 (g : Support) :

    (¬ g.S 0 6) ∨ (¬ g.S 1 10) ∨ (¬ g.S 2 4) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 13 ![2, 0, 1] (by decide)

  intro j

  fin_cases j

  · exact h2

  · exact h0

  · exact h1

theorem rawClause619 (g : Support) :

    (¬ g.S 0 4) ∨ (¬ g.S 1 9) ∨ (¬ g.S 2 7) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 14 ![0, 2, 1] (by decide)

  intro j

  fin_cases j

  · exact h0

  · exact h2

  · exact h1

theorem rawClause622 (g : Support) :

    (¬ g.S 0 9) ∨ (¬ g.S 1 4) ∨ (¬ g.S 2 7) := by

  apply forbidThree

  intro h0 h1 h2

  apply g.rainbow 14 ![1, 2, 0] (by decide)

  intro j

  fin_cases j

  · exact h1

  · exact h2

  · exact h0

theorem redAlternative (g : Support) (h : g.P 1 1) :
    g.P 0 3 ∨ g.P 0 4 ∨ g.P 0 5 ∨ g.P 0 6 ∨ g.P 0 7 ∨ g.P 0 8 ∨ g.P 0 9 ∨ g.P 0 10 ∨ g.P 0 11 ∨ g.P 0 12 ∨ g.P 0 13 ∨ g.P 0 14 := by
  have green : g.S 1 0 := g.matching_support 1 1 0 h
  obtain ⟨m, red, avoid⟩ := g.avoid 0 1 0 (by decide) green
  fin_cases m

  · exact False.elim (avoid 0 (by decide))

  · exact False.elim (avoid 0 (by decide))

  · exact False.elim (avoid 0 (by decide))

  · exact Or.inl (red)

  · exact Or.inr (Or.inl (red))

  · exact Or.inr (Or.inr (Or.inl (red)))

  · exact Or.inr (Or.inr (Or.inr (Or.inl (red))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (red)))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (red))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (red)))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (red))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (red)))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (red))))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (red)))))))))))

  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (red)))))))))))

theorem noRep0 (g : Support) (ha : g.P 0 0) (hb : g.P 1 0) (hc : g.P 2 0) : False := by

  exact Gamma.branch0_0_0 (atom g) ha hb hc (rawClause46 g) (rawClause225 g) (rawClause404 g) (rawClause534 g)

theorem noRep1 (g : Support) (ha : g.P 0 0) (hb : g.P 1 0) (hc : g.P 2 1) : False := by

  exact Gamma.branch0_0_1 (atom g) ha hb hc (rawClause47 g) (rawClause226 g) (rawClause405 g) (rawClause537 g)

theorem noRep2 (g : Support) (ha : g.P 0 0) (hb : g.P 1 0) (hc : g.P 2 4) : False := by

  exact Gamma.branch0_0_4 (atom g) ha hb hc (rawClause1 g) (rawClause5 g) (rawClause6 g) (rawClause12 g) (rawClause18 g) (rawClause23 g) (rawClause28 g) (rawClause30 g) (rawClause41 g) (rawClause43 g) (rawClause46 g) (rawClause47 g) (rawClause48 g) (rawClause159 g) (rawClause178 g) (rawClause183 g) (rawClause184 g) (rawClause191 g) (rawClause197 g) (rawClause201 g) (rawClause205 g) (rawClause209 g) (rawClause219 g) (rawClause220 g) (rawClause224 g) (rawClause225 g) (rawClause226 g) (rawClause337 g) (rawClause414 g) (rawClause415 g) (rawClause416 g) (rawClause540 g) (rawClause542 g) (rawClause555 g) (rawClause557 g) (rawClause619 g) (rawClause622 g)

theorem noRep3 (g : Support) (ha : g.P 0 0) (hb : g.P 1 1) (hc : g.P 2 2) : False := by

  exact Gamma.branch0_1_2 (atom g) hb hc (redAlternative g hb) (rawClause55 g) (rawClause56 g) (rawClause57 g) (rawClause60 g) (rawClause63 g) (rawClause64 g) (rawClause65 g) (rawClause66 g) (rawClause69 g) (rawClause72 g) (rawClause75 g) (rawClause78 g) (rawClause79 g) (rawClause80 g) (rawClause81 g) (rawClause84 g) (rawClause87 g) (rawClause88 g) (rawClause89 g) (rawClause90 g) (rawClause180 g) (rawClause181 g) (rawClause182 g) (rawClause184 g) (rawClause185 g) (rawClause187 g) (rawClause188 g) (rawClause190 g) (rawClause191 g) (rawClause193 g) (rawClause194 g) (rawClause196 g) (rawClause197 g) (rawClause199 g) (rawClause200 g) (rawClause202 g) (rawClause203 g) (rawClause205 g) (rawClause206 g) (rawClause213 g) (rawClause216 g) (rawClause220 g) (rawClause221 g) (rawClause227 g) (rawClause228 g) (rawClause229 g) (rawClause330 g) (rawClause332 g) (rawClause338 g) (rawClause340 g) (rawClause357 g) (rawClause359 g) (rawClause360 g) (rawClause361 g) (rawClause362 g) (rawClause363 g) (rawClause364 g) (rawClause365 g) (rawClause366 g) (rawClause367 g) (rawClause368 g) (rawClause369 g) (rawClause370 g) (rawClause371 g) (rawClause373 g) (rawClause374 g) (rawClause376 g) (rawClause377 g) (rawClause379 g) (rawClause380 g) (rawClause382 g) (rawClause383 g) (rawClause385 g) (rawClause387 g) (rawClause396 g) (rawClause398 g) (rawClause400 g) (rawClause408 g) (rawClause409 g) (rawClause410 g) (rawClause507 g) (rawClause511 g) (rawClause515 g) (rawClause519 g) (rawClause536 g) (rawClause537 g) (rawClause538 g) (rawClause539 g) (rawClause543 g) (rawClause545 g) (rawClause548 g) (rawClause550 g) (rawClause559 g) (rawClause561 g) (rawClause564 g) (rawClause566 g) (rawClause576 g) (rawClause578 g) (rawClause583 g) (rawClause585 g) (rawClause589 g) (rawClause591 g) (rawClause594 g) (rawClause596 g) (rawClause606 g) (rawClause608 g) (rawClause613 g) (rawClause615 g)

theorem noRep4 (g : Support) (ha : g.P 0 0) (hb : g.P 1 1) (hc : g.P 2 3) : False := by

  exact Gamma.branch0_1_3 (atom g) ha hb hc (rawClause47 g) (rawClause227 g) (rawClause413 g) (rawClause536 g)

theorem noRep5 (g : Support) (ha : g.P 0 0) (hb : g.P 1 1) (hc : g.P 2 5) : False := by

  exact Gamma.branch0_1_5 (atom g) ha hb hc (rawClause1 g) (rawClause5 g) (rawClause6 g) (rawClause12 g) (rawClause21 g) (rawClause26 g) (rawClause31 g) (rawClause33 g) (rawClause38 g) (rawClause40 g) (rawClause46 g) (rawClause47 g) (rawClause48 g) (rawClause156 g) (rawClause178 g) (rawClause183 g) (rawClause188 g) (rawClause190 g) (rawClause197 g) (rawClause204 g) (rawClause205 g) (rawClause212 g) (rawClause216 g) (rawClause220 g) (rawClause227 g) (rawClause228 g) (rawClause229 g) (rawClause332 g) (rawClause417 g) (rawClause418 g) (rawClause419 g) (rawClause546 g) (rawClause548 g) (rawClause557 g) (rawClause561 g) (rawClause583 g) (rawClause604 g)

theorem noRep6 (g : Support) (ha : g.P 0 0) (hb : g.P 1 4) (hc : g.P 2 8) : False := by

  exact Gamma.branch0_4_8 (atom g) ha hb hc (rawClause46 g) (rawClause238 g) (rawClause428 g) (rawClause541 g)

theorem noRep7 (g : Support) (ha : g.P 0 0) (hb : g.P 1 4) (hc : g.P 2 13) : False := by

  exact Gamma.branch0_4_13 (atom g) ha hb hc (rawClause46 g) (rawClause238 g) (rawClause443 g) (rawClause541 g)

end OORaw


namespace OOIso

open OORaw

structure Relabel where
  vertex : Fin 6 → Fin 6
  undoVertex : Fin 6 → Fin 6
  edge : Fin 15 → Fin 15
  undoEdge : Fin 15 → Fin 15
  matching : Fin 15 → Fin 15
  undoMatching : Fin 15 → Fin 15
  slot : Fin 15 → Fin 3 → Fin 3
  undoSlot : Fin 15 → Fin 3 → Fin 3

def faithful (g : Relabel) : Prop :=
  (∀ v, g.undoVertex (g.vertex v) = v) ∧ (∀ v, g.vertex (g.undoVertex v) = v) ∧
  (∀ e, g.undoEdge (g.edge e) = e) ∧ (∀ e, g.edge (g.undoEdge e) = e) ∧
  (∀ m, g.undoMatching (g.matching m) = m) ∧ (∀ m, g.matching (g.undoMatching m) = m) ∧
  (∀ m j, g.undoSlot m (g.slot m j) = j) ∧ (∀ m j, g.slot m (g.undoSlot m j) = j) ∧
  (∀ e, (g.vertex (left e) = left (g.edge e) ∧ g.vertex (right e) = right (g.edge e)) ∨
         (g.vertex (left e) = right (g.edge e) ∧ g.vertex (right e) = left (g.edge e))) ∧
  (∀ m j, g.edge (edgeFor m j) = edgeFor (g.matching m) (g.slot m j))

def map0 (tag : Fin 74) (i : Fin 6) : Fin 6 :=
  let w := (#[
    181896, 153224, 178312, 146056, 181448, 152776, 174280, 142024, 120072, 87816, 109320, 80648,
    116040, 83784, 108872, 80200, 181840, 153168, 178256, 120912, 146000, 181336, 152664, 174168,
    88152, 141912, 177248, 119904, 173664, 87648, 109152, 80480, 144488, 115816, 140904, 83560,
    108648, 79976, 181777, 153105, 120849, 181273, 152601, 88089, 177185, 109089, 80417, 144425,
    108585, 79913, 180762, 152090, 170010, 137754, 180314, 151642, 53530, 21274, 49498, 17242,
    168162, 135402, 168099, 135339, 107052, 78380, 103468, 71212, 106604, 77932, 45228, 12972,
    41196, 8940
  ] : Array Nat).getD tag.val 0
  ⟨((w >>> (3 * i.val)) % 8) % 6, Nat.mod_lt _ (by decide)⟩

def map1 (tag : Fin 74) (i : Fin 6) : Fin 6 :=
  let w := (#[
    181896, 153224, 178312, 120968, 181448, 152776, 177416, 120072, 142024, 141128, 109320, 108872,
    84680, 83784, 80648, 80200, 181840, 153168, 178256, 146000, 120912, 180944, 152272, 176912,
    144208, 119568, 170192, 137936, 169744, 137040, 105232, 104784, 55504, 51920, 55056, 51024,
    47888, 47440, 181826, 153154, 145986, 180930, 152258, 144194, 170178, 105218, 104770, 55490,
    47874, 47426, 180762, 152090, 176674, 119330, 180755, 152083, 139819, 139805, 82475, 82461,
    168995, 54307, 168099, 53411, 35610, 35162, 35554, 34658, 35603, 35155, 34987, 34973,
    34091, 34077
  ] : Array Nat).getD tag.val 0
  ⟨((w >>> (3 * i.val)) % 8) % 6, Nat.mod_lt _ (by decide)⟩

def map2 (tag : Fin 74) (i : Fin 15) : Fin 15 :=
  let w := (#[
    1070935975390360080, 1066697354038690320, 1003380949935989520, 931587303129949200, 1061403209561813280, 1057164588210143520, 858738133450363680, 786944486644323360, 980604558481965360, 837017269148140080, 710384456916145200, 701907218239398960,
    908283150105456960, 764695860771631680, 705618073994007360, 697140835317261120, 1070879707879453185, 1066641086527783425, 1003324682425082625, 994847439721743105, 931531035619042305, 1061309499079667970, 1057070877727998210, 858645453508711170,
    841707460776510210, 786851806702670850, 988969334866190595, 980492092162851075, 853860314749604355, 836922322017403395, 710273021137523715, 701812271108662275, 912390549301043460, 908151927949373700, 777281529184457220, 764582157803926020,
    705487882378416900, 697027132349555460, 1070804666206942725, 1066566044855272965, 994772398049232645, 1061234457407157510, 1056995836055487750, 841632419103999750, 988894293193680135, 710197979465013255, 701737229436151815, 912315507628533000,
    705412840705906440, 696952090677045000, 1046879164825314585, 1042640543473644825, 641552104475548185, 569758457669507865, 1027813633136763225, 1023575011785093465, 577725426139771305, 290550838915610025, 505404017763262905, 218229430539101625,
    594710645812449690, 518131860247302555, 594674293207294620, 518095507642147485, 676983661799450430, 672745036421187390, 474320647020640830, 402526995936345150, 657918130110899070, 653679504732636030, 433006477363889070, 145831890139727790,
    360685068719989710, 73510481495828430
  ] : Array Nat).getD tag.val 0
  ⟨((w >>> (4 * i.val)) % 16) % 15, Nat.mod_lt _ (by decide)⟩

def map3 (tag : Fin 74) (i : Fin 15) : Fin 15 :=
  let w := (#[
    1070935975390360080, 1066697354038690320, 1003380949935989520, 994903707232650000, 1061403209561813280, 1057164588210143520, 989081801185304880, 980604558481965360, 786944486644323360, 777411720800047680, 710384456916145200, 705618073994007360,
    774228626615907360, 764695860771631680, 701907218239398960, 697140835317261120, 1070879707879453185, 1066641086527783425, 1003324682425082625, 931531035619042305, 994847439721743105, 1047047793284493345, 1042809171932823585, 974726384907984945,
    898166355179806785, 966249142204645425, 641717640809939745, 569923994003899425, 636951257887801905, 560391228159623745, 493363964275721265, 488597581353583425, 612047295374967585, 544492269920597025, 607280912452829745, 534959504076321345,
    472170861544088625, 467404478621950785, 1070879675813439825, 1066641054461770065, 931531003553028945, 1047047761249936785, 1042809139898267025, 898166323145250225, 641717609278691985, 493363932744473505, 488597549822335665, 612047271896660625,
    472170838065781665, 467404455143643825, 1046879164825314585, 1042640543473644825, 974539000611837210, 966061757908497690, 1046879155680822825, 1042640534329153065, 753562451945756205, 753562442783438925, 745085205215823405, 745085196053506125,
    627478222732093740, 602079475944315180, 594674293207294620, 577686810372002460, 37282129373371305, 32515746451233465, 37263373536402330, 27730607692126650, 37282124774387145, 32515741852249305, 32459405638642845, 32459396476325565,
    22926639778638285, 22926630616321005
  ] : Array Nat).getD tag.val 0
  ⟨((w >>> (4 * i.val)) % 16) % 15, Nat.mod_lt _ (by decide)⟩

def map4 (tag : Fin 74) (i : Fin 15) : Fin 15 :=
  let w := (#[
    1070935975390360080, 840464246688264480, 1003325713468834305, 772781228607885570, 1066712806210363680, 836241077508268560, 931493312907866370, 700948828046918145, 605695543840838145, 375151058979889410, 470403294379487760, 239931565677392160,
    533863143279870210, 303318658418921985, 466180125199491360, 235708396497396240, 1003365484275500355, 772893763626468435, 1070863211175089460, 542382264114352980, 840351711662974005, 931571828006193270, 701100107359127430, 1066584800993749095,
    311853227144455815, 836073301483722600, 927293417824852905, 470571070389230265, 994791144724442010, 240059570877114810, 605544264513948315, 375072543864916395, 696764380854955740, 466292660207889900, 764262107754667725, 235781160697863405,
    533750608244641230, 303278887597575390, 627546582922890390, 568732687239612870, 780169876277958345, 412165650825481635, 353351755144170195, 704450014411301850, 399480778498645620, 953292616728905550, 894478721045628030, 323760916631989125,
    737911684631496795, 679097788950185355, 191153986760687280, 132902903593843680, 731725408525049355, 943725547485350670, 178482435449449440, 111789156514492080, 679101413763157515, 303282856170478350, 894483578545666830, 375079797987126795,
    550118391890751960, 635408402462007975, 329108940586398405, 414961901111075220, 170038186869438000, 111787103702594400, 372751903233910275, 584752042194211590, 199598235609195360, 132904956674238000, 353352438117422595, 701089494573613830,
    568734602899931910, 772886436390262275
  ] : Array Nat).getD tag.val 0
  ⟨((w >>> (4 * i.val)) % 16) % 15, Nat.mod_lt _ (by decide)⟩

def map5 (tag : Fin 74) (i : Fin 15) : Fin 15 :=
  let w := (#[
    1070935975390360080, 840464246688264480, 1003325713468834305, 609919761827315745, 1066712806210363680, 836241077508268560, 994880405649395745, 605695543840838145, 700948828046918145, 696724610060439585, 470403294379487760, 466180125199491360,
    311763966238359585, 303318658418921985, 239931565677392160, 235708396497396240, 1003365484275500355, 772893763626468435, 1070863211175089460, 840351711662974005, 542382264114352980, 994919149941056595, 764447421240927555, 1066638987502523220,
    836128500768228165, 533936934506632500, 927214902726526005, 696670417867666740, 931435982847849285, 700890457736799060, 466124892756616515, 470345972877939795, 148845191189988165, 81234929268585300, 144624083594294325, 72791683536643380,
    9402529210934355, 5181421615240515, 752901714050901315, 973242801382515795, 635497974517384245, 731783866228606035, 943682765843203395, 584818043224793925, 191342979592533045, 66266016036017475, 53596553783452755, 906959043406246725,
    488938194261824595, 476268723958162755, 191153986760687280, 132902903593843680, 178471313457106305, 66190240981928145, 113764659197669040, 199593579734592480, 170023958427961665, 15246333842479425, 53521796119823505, 191125268774835345,
    295335011922971685, 277606474089661125, 329108940586398405, 264948317977361445, 476313223672897200, 488980641550380000, 678991687500631425, 704326527281146065, 264981792296349360, 277649210207378400, 953222111478810945, 602317844321347905,
    982778041092285585, 627652684168955025
  ] : Array Nat).getD tag.val 0
  ⟨((w >>> (4 * i.val)) % 16) % 15, Nat.mod_lt _ (by decide)⟩

def map6 (tag : Fin 74) (i : Fin 45) : Fin 3 :=
  let w := (#[
    707394308163074442799499556, 707394308163074442799499556, 707394308163074442799499556, 707394308163074442799499556, 707394308163074442799449636, 707394308163074442799449636, 707394308163074442799450392, 707394308163074442799450392, 707394308163074442799449636, 707394308163074442799498776, 707394308163074442799450392, 707394308163074442799498776,
    707394308163074442799449636, 707394308163074442799498776, 707394308163074442799450392, 707394308163074442799498776, 471652874056017684112492836, 471652874056017684112492836, 471652874056017684112492836, 471652874056017684112492836, 471652874056017684112492836, 471652874056017671026264356, 471652874056017671026264356, 471652874056017671224445220,
    471652874056017683908020516, 471652874056017671224445220, 471652874056017671026264356, 471652874056017671026264356, 471652874056017671224445220, 471652874056017683908020516, 471652874056017671224445220, 471652874056017683908020516, 471652874056017671026264356, 471652874056017671026264356, 471652874056017671224445220, 471652874056017683908020516,
    471652874056017671224445220, 471652874056017683908020516, 176961914268704725131204705, 176961914268704725131204705, 176961914268704725131204705, 176961914268704712044976225, 176961914268704712044976225, 176961914268704724926732385, 176961914268704712044976225, 176961914268704712243157089, 176961914268704724926732385, 176961914268704712044976225,
    176961914268704712243157089, 176961914268704724926732385, 175984380677770204022908065, 175984380677770204022908065, 118862639429945242247309394, 118862639429945242247309394, 179554503361993214120976801, 179554503361993214120976801, 184101920981487865337242194, 475222519158698953064129094, 184101920981487865337242194, 475222519158698953064129094,
    121540248467857339172032914, 121540248467857339172032914, 121526081368408730236379538, 121526081368408730236379538, 117955941336268003637011602, 175984159316841319508288658, 117955945065234270366278802, 118862639429100817317176466, 121526064020491013735080338, 179554282001064329606357394, 184101920927444669808796050, 475222519104655757535682950,
    184101920981487865286910354, 475222519158698953013797254
  ] : Array Nat).getD tag.val 0
  ⟨((w >>> (2 * i.val)) % 4) % 3, Nat.mod_lt _ (by decide)⟩

def map7 (tag : Fin 74) (i : Fin 45) : Fin 3 :=
  let w := (#[
    707394308163074442799499556, 707394308163074442799499556, 707394308163074442799499556, 707394308163074442799499556, 707394308163074442799449636, 707394308163074442799449636, 707394308163074442799450392, 707394308163074442799450392, 707394308163074442799449636, 707394308163074442799498776, 707394308163074442799450392, 707394308163074442799498776,
    707394308163074442799449636, 707394308163074442799498776, 707394308163074442799450392, 707394308163074442799498776, 471652874056017684112492836, 471652874056017684112492836, 471652874056017684112492836, 471652874056017684112492836, 471652874056017684112492836, 471652874056017671026264356, 471652874056017671026264356, 471652874056017671224445220,
    471652874056017683908020516, 471652874056017671224445220, 471652874056017671026264356, 471652874056017671026264356, 471652874056017671224445220, 471652874056017683908020516, 471652874056017671224445220, 471652874056017683908020516, 471652874056017671026264356, 471652874056017671026264356, 471652874056017671224445220, 471652874056017683908020516,
    471652874056017671224445220, 471652874056017683908020516, 353767989848997294146459745, 353767989848997294146459745, 353767989848997294146459745, 353767989848997281060231265, 353767989848997281060231265, 353767989848997293941987425, 353767989848997281060231265, 353767989848997281258412129, 353767989848997293941987425, 353767989848997281060231265,
    353767989848997281258412129, 353767989848997293941987425, 350027861327160902541152865, 350027861327160902541152865, 121540895687345182404024393, 121540895687345182404024393, 350920391998860021532484001, 350920391998860021532484001, 358229730090176338574206089, 475221855238082077486781574, 358229730090176338574206089, 475221855238082077486781574,
    118863330916986500126417289, 118863330916986500126417289, 118806662519192064383803785, 118806662519192064383803785, 117914103961152100997567049, 350026975883445364482675273, 117914118228501294879904329, 121540895683967482683494985, 118806634632851219988898185, 350919506555144483474006409, 358229729874003556460421513, 475221855021909295372996998,
    358229730090176338372878729, 475221855238082077285454214
  ] : Array Nat).getD tag.val 0
  ⟨((w >>> (2 * i.val)) % 4) % 3, Nat.mod_lt _ (by decide)⟩

def slotIndex (m : Fin 15) (j : Fin 3) : Fin 45 :=
  ⟨3*m.val+j.val, by have hm := m.isLt; have hj := j.isLt; omega⟩

def graph (tag : Fin 74) : Relabel :=
  ⟨map0 tag, map1 tag, map2 tag, map3 tag, map4 tag, map5 tag,
    fun m j => map6 tag (slotIndex m j), fun m j => map7 tag (slotIndex m j)⟩

set_option maxRecDepth 8192 in
theorem faithful0 : faithful (graph 0) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful1 : faithful (graph 1) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful2 : faithful (graph 2) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful3 : faithful (graph 3) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful4 : faithful (graph 4) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful5 : faithful (graph 5) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful6 : faithful (graph 6) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful7 : faithful (graph 7) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful8 : faithful (graph 8) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful9 : faithful (graph 9) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful10 : faithful (graph 10) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful11 : faithful (graph 11) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful12 : faithful (graph 12) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful13 : faithful (graph 13) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful14 : faithful (graph 14) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful15 : faithful (graph 15) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful16 : faithful (graph 16) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful17 : faithful (graph 17) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful18 : faithful (graph 18) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful19 : faithful (graph 19) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful20 : faithful (graph 20) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful21 : faithful (graph 21) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful22 : faithful (graph 22) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful23 : faithful (graph 23) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful24 : faithful (graph 24) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful25 : faithful (graph 25) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful26 : faithful (graph 26) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful27 : faithful (graph 27) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful28 : faithful (graph 28) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful29 : faithful (graph 29) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful30 : faithful (graph 30) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful31 : faithful (graph 31) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful32 : faithful (graph 32) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful33 : faithful (graph 33) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful34 : faithful (graph 34) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful35 : faithful (graph 35) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful36 : faithful (graph 36) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful37 : faithful (graph 37) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful38 : faithful (graph 38) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful39 : faithful (graph 39) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful40 : faithful (graph 40) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful41 : faithful (graph 41) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful42 : faithful (graph 42) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful43 : faithful (graph 43) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful44 : faithful (graph 44) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful45 : faithful (graph 45) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful46 : faithful (graph 46) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful47 : faithful (graph 47) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful48 : faithful (graph 48) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful49 : faithful (graph 49) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful50 : faithful (graph 50) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful51 : faithful (graph 51) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful52 : faithful (graph 52) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful53 : faithful (graph 53) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful54 : faithful (graph 54) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful55 : faithful (graph 55) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful56 : faithful (graph 56) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful57 : faithful (graph 57) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful58 : faithful (graph 58) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful59 : faithful (graph 59) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful60 : faithful (graph 60) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful61 : faithful (graph 61) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful62 : faithful (graph 62) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful63 : faithful (graph 63) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful64 : faithful (graph 64) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful65 : faithful (graph 65) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful66 : faithful (graph 66) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful67 : faithful (graph 67) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful68 : faithful (graph 68) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful69 : faithful (graph 69) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful70 : faithful (graph 70) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful71 : faithful (graph 71) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful72 : faithful (graph 72) := by unfold faithful; decide
set_option maxRecDepth 8192 in
theorem faithful73 : faithful (graph 73) := by unfold faithful; decide

theorem graphFaithful (tag : Fin 74) : faithful (graph tag) := by
  match tag with
  | ⟨0, _⟩ => exact faithful0
  | ⟨1, _⟩ => exact faithful1
  | ⟨2, _⟩ => exact faithful2
  | ⟨3, _⟩ => exact faithful3
  | ⟨4, _⟩ => exact faithful4
  | ⟨5, _⟩ => exact faithful5
  | ⟨6, _⟩ => exact faithful6
  | ⟨7, _⟩ => exact faithful7
  | ⟨8, _⟩ => exact faithful8
  | ⟨9, _⟩ => exact faithful9
  | ⟨10, _⟩ => exact faithful10
  | ⟨11, _⟩ => exact faithful11
  | ⟨12, _⟩ => exact faithful12
  | ⟨13, _⟩ => exact faithful13
  | ⟨14, _⟩ => exact faithful14
  | ⟨15, _⟩ => exact faithful15
  | ⟨16, _⟩ => exact faithful16
  | ⟨17, _⟩ => exact faithful17
  | ⟨18, _⟩ => exact faithful18
  | ⟨19, _⟩ => exact faithful19
  | ⟨20, _⟩ => exact faithful20
  | ⟨21, _⟩ => exact faithful21
  | ⟨22, _⟩ => exact faithful22
  | ⟨23, _⟩ => exact faithful23
  | ⟨24, _⟩ => exact faithful24
  | ⟨25, _⟩ => exact faithful25
  | ⟨26, _⟩ => exact faithful26
  | ⟨27, _⟩ => exact faithful27
  | ⟨28, _⟩ => exact faithful28
  | ⟨29, _⟩ => exact faithful29
  | ⟨30, _⟩ => exact faithful30
  | ⟨31, _⟩ => exact faithful31
  | ⟨32, _⟩ => exact faithful32
  | ⟨33, _⟩ => exact faithful33
  | ⟨34, _⟩ => exact faithful34
  | ⟨35, _⟩ => exact faithful35
  | ⟨36, _⟩ => exact faithful36
  | ⟨37, _⟩ => exact faithful37
  | ⟨38, _⟩ => exact faithful38
  | ⟨39, _⟩ => exact faithful39
  | ⟨40, _⟩ => exact faithful40
  | ⟨41, _⟩ => exact faithful41
  | ⟨42, _⟩ => exact faithful42
  | ⟨43, _⟩ => exact faithful43
  | ⟨44, _⟩ => exact faithful44
  | ⟨45, _⟩ => exact faithful45
  | ⟨46, _⟩ => exact faithful46
  | ⟨47, _⟩ => exact faithful47
  | ⟨48, _⟩ => exact faithful48
  | ⟨49, _⟩ => exact faithful49
  | ⟨50, _⟩ => exact faithful50
  | ⟨51, _⟩ => exact faithful51
  | ⟨52, _⟩ => exact faithful52
  | ⟨53, _⟩ => exact faithful53
  | ⟨54, _⟩ => exact faithful54
  | ⟨55, _⟩ => exact faithful55
  | ⟨56, _⟩ => exact faithful56
  | ⟨57, _⟩ => exact faithful57
  | ⟨58, _⟩ => exact faithful58
  | ⟨59, _⟩ => exact faithful59
  | ⟨60, _⟩ => exact faithful60
  | ⟨61, _⟩ => exact faithful61
  | ⟨62, _⟩ => exact faithful62
  | ⟨63, _⟩ => exact faithful63
  | ⟨64, _⟩ => exact faithful64
  | ⟨65, _⟩ => exact faithful65
  | ⟨66, _⟩ => exact faithful66
  | ⟨67, _⟩ => exact faithful67
  | ⟨68, _⟩ => exact faithful68
  | ⟨69, _⟩ => exact faithful69
  | ⟨70, _⟩ => exact faithful70
  | ⟨71, _⟩ => exact faithful71
  | ⟨72, _⟩ => exact faithful72
  | ⟨73, _⟩ => exact faithful73
  | ⟨k + 74, h⟩ => omega

def normalTag (i : Fin 15) : Fin 74 :=
  ⟨((#[0, 2, 3, 16, 18, 20, 21, 23, 25, 26, 28, 30, 32, 34, 36] : Array Nat).getD i.val 0) % 74, Nat.mod_lt _ (by decide)⟩
def triple (a b c : Fin 15) (i : Fin 3) : Fin 15 :=
  if i = 0 then a else if i = 1 then b else c
def representative (r : Fin 8) (i : Fin 3) : Fin 15 :=
  let w := (#[0, 256, 1024, 528, 784, 1296, 2112, 3392] : Array Nat).getD r.val 0
  ⟨((w >>> (4*i.val)) % 16) % 15, Nat.mod_lt _ (by decide)⟩

def pickedCode (i : Fin 225) : Fin 74 :=
  ⟨((#[0, 0, 1, 64, 0, 1, 65, 4, 5, 10, 11, 50, 14, 15, 51, 0, 2, 0, 0, 2, 0, 5, 5, 7, 8, 8, 10, 13, 13, 15, 1, 0, 3, 1, 1, 3, 4, 6, 4, 9, 9, 11, 12, 12, 14, 64, 0, 1, 66, 16, 17, 64, 69, 70, 64, 41, 50, 73, 42, 51, 0, 2, 1, 16, 18, 19, 68, 44, 0, 63, 18, 50, 33, 0, 45, 1, 0, 3, 17, 19, 20, 72, 1, 47, 27, 1, 48, 62, 20, 51, 65, 5, 4, 64, 68, 72, 67, 21, 22, 38, 65, 55, 39, 71, 54, 4, 5, 6, 69, 44, 1, 21, 23, 24, 23, 61, 59, 4, 35, 46, 5, 7, 4, 70, 0, 47, 22, 24, 25, 5, 29, 49, 25, 60, 57, 10, 8, 9, 64, 63, 27, 38, 23, 5, 27, 26, 30, 40, 10, 54, 11, 8, 9, 41, 18, 1, 65, 61, 29, 26, 29, 31, 11, 43, 58, 50, 10, 11, 50, 50, 48, 55, 59, 49, 30, 31, 52, 55, 56, 50, 14, 13, 12, 73, 33, 62, 39, 4, 25, 40, 11, 55, 33, 32, 36, 15, 13, 12, 42, 0, 20, 71, 35, 60, 10, 43, 56, 32, 35, 37, 51, 15, 14, 51, 45, 51, 54, 46, 57, 54, 58, 50, 36, 37, 53] : Array Nat).getD i.val 0) % 74, Nat.mod_lt _ (by decide)⟩
def pickedRep (i : Fin 225) : Fin 8 :=
  ⟨((#[0, 1, 1, 1, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 1, 1, 1, 3, 4, 4, 5, 4, 5, 4, 4, 5, 4, 5, 4, 4, 1, 3, 1, 4, 5, 4, 4, 4, 5, 5, 4, 4, 4, 5, 4, 1, 4, 4, 1, 4, 4, 3, 5, 5, 5, 4, 4, 5, 4, 4, 2, 4, 5, 4, 2, 5, 5, 5, 6, 5, 6, 5, 6, 7, 4, 2, 5, 4, 4, 5, 2, 5, 6, 5, 6, 7, 4, 5, 6, 5, 1, 4, 4, 3, 5, 5, 1, 4, 4, 4, 5, 4, 4, 5, 4, 2, 5, 4, 5, 5, 6, 4, 2, 5, 6, 5, 5, 7, 6, 4, 2, 4, 5, 5, 6, 5, 4, 5, 2, 7, 6, 4, 6, 5, 5, 2, 4, 5, 5, 5, 6, 4, 6, 7, 2, 5, 4, 5, 6, 5, 2, 5, 4, 4, 6, 7, 5, 5, 6, 5, 2, 4, 6, 5, 5, 1, 4, 4, 4, 5, 4, 4, 5, 4, 4, 4, 1, 5, 5, 3, 2, 5, 4, 5, 6, 5, 4, 7, 6, 5, 6, 5, 2, 5, 4, 2, 4, 5, 4, 7, 6, 5, 6, 5, 6, 5, 5, 5, 2, 4, 1, 4, 4, 4, 4, 5, 4, 4, 5, 5, 5, 3, 4, 4, 1] : Array Nat).getD i.val 0) % 8, Nat.mod_lt _ (by decide)⟩
def pickedColour (i : Fin 225) : Fin 6 :=
  ⟨((#[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 2, 0, 0, 0, 2, 2, 2, 0, 2, 2, 0, 1, 1, 3, 0, 0, 2, 0, 2, 0, 2, 2, 0, 2, 2, 0, 1, 1, 1, 3, 3, 3, 0, 0, 2, 0, 3, 1, 2, 3, 1, 1, 4, 1, 5, 3, 3, 1, 3, 0, 3, 2, 1, 4, 0, 5, 1, 1, 4, 5, 5, 3, 4, 0, 3, 4, 0, 5, 3, 2, 1, 1, 1, 1, 1, 0, 2, 3, 3, 3, 3, 0, 1, 3, 2, 1, 1, 1, 4, 1, 5, 1, 5, 3, 3, 2, 3, 4, 0, 4, 5, 1, 4, 1, 4, 1, 5, 5, 5, 3, 0, 4, 5, 2, 3, 4, 1, 4, 4, 1, 5, 2, 5, 4, 1, 3, 3, 5, 3, 0, 1, 1, 4, 4, 5, 4, 1, 1, 5, 2, 5, 3, 5, 0, 3, 4, 1, 1, 1, 0, 0, 3, 0, 2, 3, 3, 3, 3, 0, 2, 0, 1, 4, 4, 4, 2, 5, 5, 1, 4, 5, 1, 1, 3, 3, 5, 1, 4, 4, 5, 1, 4, 4, 2, 5, 1, 5, 4, 5, 3, 5, 1, 1, 1, 0, 3, 0, 0, 3, 2, 0, 2, 1, 3, 3, 3] : Array Nat).getD i.val 0) % 6, Nat.mod_lt _ (by decide)⟩
def pairIndex (b c : Fin 15) : Fin 225 :=
  ⟨15*b.val+c.val, by have hb := b.isLt; have hc := c.isLt; omega⟩

def colour (tag : Fin 6) (i : Fin 3) : Fin 3 :=
  ⟨((#[0, 1, 2, 0, 2, 1, 1, 0, 2, 1, 2, 0, 2, 0, 1, 2, 1, 0] : Array Nat).getD (3*tag.val+i.val) 0) % 3, Nat.mod_lt _ (by decide)⟩
def colourBack (tag : Fin 6) (i : Fin 3) : Fin 3 :=
  ⟨((#[0, 1, 2, 0, 2, 1, 1, 0, 2, 2, 0, 1, 1, 2, 0, 2, 1, 0] : Array Nat).getD (3*tag.val+i.val) 0) % 3, Nat.mod_lt _ (by decide)⟩

theorem colourInverse : ∀ p i, colourBack p (colour p i) = i := by decide
theorem inverseColour : ∀ p i, colour p (colourBack p i) = i := by decide

theorem firstToZero : ∀ a, (graph (normalTag a)).undoMatching a = 0 := by decide

def normalized (b c : Fin 15) : Prop :=
  ∀ i, (graph (pickedCode (pairIndex b c))).matching (representative (pickedRep (pairIndex b c)) i) =
    triple 0 b c (colour (pickedColour (pairIndex b c)) i)
set_option maxRecDepth 16384 in
theorem normalized0 : ∀ c, normalized 0 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized1 : ∀ c, normalized 1 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized2 : ∀ c, normalized 2 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized3 : ∀ c, normalized 3 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized4 : ∀ c, normalized 4 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized5 : ∀ c, normalized 5 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized6 : ∀ c, normalized 6 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized7 : ∀ c, normalized 7 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized8 : ∀ c, normalized 8 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized9 : ∀ c, normalized 9 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized10 : ∀ c, normalized 10 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized11 : ∀ c, normalized 11 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized12 : ∀ c, normalized 12 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized13 : ∀ c, normalized 13 c := by unfold normalized; decide
set_option maxRecDepth 16384 in
theorem normalized14 : ∀ c, normalized 14 c := by unfold normalized; decide

theorem normalizedAll (b : Fin 15) : ∀ c, normalized b c := by
  match b with
  | ⟨0, _⟩ => exact normalized0
  | ⟨1, _⟩ => exact normalized1
  | ⟨2, _⟩ => exact normalized2
  | ⟨3, _⟩ => exact normalized3
  | ⟨4, _⟩ => exact normalized4
  | ⟨5, _⟩ => exact normalized5
  | ⟨6, _⟩ => exact normalized6
  | ⟨7, _⟩ => exact normalized7
  | ⟨8, _⟩ => exact normalized8
  | ⟨9, _⟩ => exact normalized9
  | ⟨10, _⟩ => exact normalized10
  | ⟨11, _⟩ => exact normalized11
  | ⟨12, _⟩ => exact normalized12
  | ⟨13, _⟩ => exact normalized13
  | ⟨14, _⟩ => exact normalized14

end OOIso


namespace OORaw

open OOIso

def relabel (g : Support) (tag : Fin 74) (p : Fin 6) : Support := by
  let u := graph tag
  have law : faithful u := graphFaithful tag
  have vi := law.1
  have iv := law.2.1
  have ei := law.2.2.1
  have ie := law.2.2.2.1
  have mi := law.2.2.2.2.1
  have im := law.2.2.2.2.2.1
  have si := law.2.2.2.2.2.2.1
  have islot := law.2.2.2.2.2.2.2.1
  have endpoints := law.2.2.2.2.2.2.2.2.1
  have incidence := law.2.2.2.2.2.2.2.2.2
  have colourInj : Function.Injective (colour p) := fun {_ _} h => by
    simpa only [colourInverse] using congrArg (colourBack p) h
  refine {
    S := fun c e => g.S (colour p c) (u.edge e)
    T := fun c e => g.T (colour p c) (u.edge e)
    P := fun c m => g.P (colour p c) (u.matching m)
    has_matching := ?_, active_support := ?_, active_private := ?_,
    matching_support := ?_, cut := ?_, rainbow := ?_, avoid := ?_ }
  · intro c
    obtain ⟨m, hm⟩ := g.has_matching (colour p c)
    exact ⟨u.undoMatching m, by simpa only [im] using hm⟩
  · intro c e h
    exact g.active_support _ _ h
  · intro c d e h hactive
    exact g.active_private _ _ _ (fun hcd => h (colourInj hcd)) hactive
  · intro c m j h
    exact (incidence m j).symm ▸ g.matching_support (colour p c) (u.matching m) (u.slot m j) h
  · intro c x h
    let eV : Fin 6 ≃ Fin 6 := ⟨u.undoVertex, u.vertex, iv, vi⟩
    have hs : (∑ w, x (u.undoVertex w)) ≠ 0 := by
      change (∑ w, x (eV w)) ≠ 0
      rw [eV.sum_comp x]
      exact h
    obtain ⟨e, he, hn⟩ := g.cut (colour p c) _ hs
    refine ⟨u.undoEdge e, ?_, ?_⟩
    · simpa only [ie] using he
    · have hu := endpoints (u.undoEdge e)
      rw [ie] at hu
      rcases hu with ⟨hl, hr⟩ | ⟨hl, hr⟩
      · have l := congrArg u.undoVertex hl
        have r := congrArg u.undoVertex hr
        simpa only [← l, ← r, vi] using hn
      · have l := congrArg u.undoVertex hl
        have r := congrArg u.undoVertex hr
        simpa only [← l, ← r, vi, add_comm] using hn
  · intro m k hk hall
    let qc := fun j => colour p (k (u.undoSlot m j))
    apply g.rainbow (u.matching m) qc ?_ ?_
    · intro i j hij
      have h := hk (colourInj hij)
      simpa only [islot] using congrArg (u.slot m) h
    · intro j
      have h := hall (u.undoSlot m j)
      rw [incidence, islot] at h
      exact h
  · intro c d e hcd hactive
    obtain ⟨m, hm, havoid⟩ := g.avoid _ _ _ (fun h => hcd (colourInj h)) hactive
    refine ⟨u.undoMatching m, ?_, ?_⟩
    · simpa only [im] using hm
    · intro j h
      have he := congrArg u.edge h
      rw [incidence, im] at he
      exact havoid _ he

theorem noRep (g : Support) (r : Fin 8)
    (h : ∀ i : Fin 3, g.P i (OOIso.representative r i)) : False := by
  fin_cases r
  · exact noRep0 g (h 0) (h 1) (h 2)
  · exact noRep1 g (h 0) (h 1) (h 2)
  · exact noRep2 g (h 0) (h 1) (h 2)
  · exact noRep3 g (h 0) (h 1) (h 2)
  · exact noRep4 g (h 0) (h 1) (h 2)
  · exact noRep5 g (h 0) (h 1) (h 2)
  · exact noRep6 g (h 0) (h 1) (h 2)
  · exact noRep7 g (h 0) (h 1) (h 2)

set_option maxRecDepth 8192 in
theorem noSupport (g : Support) : False := by
  obtain ⟨a, ha⟩ := g.has_matching 0
  obtain ⟨b, hb⟩ := g.has_matching 1
  obtain ⟨c, hc⟩ := g.has_matching 2
  let n := normalTag a
  let u := graph n
  let h := relabel g n 0
  let b' := u.undoMatching b
  let c' := u.undoMatching c
  have law : faithful u := graphFaithful n
  have im := law.2.2.2.2.2.1
  have first : h.P 0 0 := by
    change g.P 0 (u.matching 0)
    have h0 : u.undoMatching a = 0 := firstToZero a
    rw [← h0, im]
    exact ha
  have second : h.P 1 b' := by
    change g.P 1 (u.matching (u.undoMatching b))
    simpa only [im] using hb
  have third : h.P 2 c' := by
    change g.P 2 (u.matching (u.undoMatching c))
    simpa only [im] using hc
  have choices : ∀ i, h.P i (triple 0 b' c' i) := by
    intro i
    fin_cases i
    · exact first
    · exact second
    · exact third
  let tag := pairIndex b' c'
  let r := pickedRep tag
  let p := pickedColour tag
  apply noRep (relabel h (pickedCode tag) p) r
  intro i
  change h.P (colour p i) ((graph (pickedCode tag)).matching (representative r i))
  rw [normalizedAll b' c' i]
  exact choices (colour p i)

end OORaw

theorem OMA.solution : OMA.R_MonochromaticQuantumGraph_eqSystem6_no_solution_ge3_R1.H1 := by
  intro W hd hw
  obtain ⟨s⟩ := OORaw.from_physical W hd hw
  exact OORaw.noSupport s

#print axioms OMA.solution
