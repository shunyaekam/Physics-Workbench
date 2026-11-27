import FormalConjectures.ErdosProblems.«1165»

open MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators ProbabilityTheory

namespace DiffusionCylinder

open Erdos1165

private theorem four_steps : Measure.count Erdos1165.steps = 4 := by
  let choices : Finset (ℤ × ℤ) := {(1,0), (-1,0), (0,1), (0,-1)}
  have h : (choices : Set (ℤ × ℤ)) = Erdos1165.steps := by
    ext x
    simp [choices, Erdos1165.steps]
  rw [← h, Measure.count_apply_finset]
  have hc : choices.card = 4 := by decide
  simp [hc]

variable {Ω : Type*} [MeasureSpace Ω]
variable {X : ℕ → Ω → ℤ × ℤ} (hX : IsSimpleRandomWalkSteps X)

include hX

/-- A specified legal increment has probability one quarter. -/
theorem one_step (k : ℕ) (z : ℤ × ℤ) (hz : z ∈ Erdos1165.steps) :
    ℙ (X k ⁻¹' {z}) = 1 / 4 := by
  have hsub : ({z} : Set (ℤ × ℤ)) ⊆ Erdos1165.steps := Set.singleton_subset_iff.mpr hz
  rw [(hX.isUniform k).measure_preimage (by rw [four_steps]; norm_num)
      (by rw [four_steps]; norm_num) (measurableSet_singleton z),
      Set.inter_eq_right.mpr hsub, Measure.count_singleton, four_steps]

/-- Every legal word of length t has probability 4^(-t), including the empty word. -/
theorem word_mass {t : ℕ} (w : Fin t → ℤ × ℤ) (hw : ∀ i, w i ∈ Erdos1165.steps) :
    ℙ {ω | ∀ i : Fin t, X (i : ℕ) ω = w i} = (1 / 4 : ℝ≥0∞)^t := by
  classical
  have hi : iIndepFun (fun i : Fin t => X (i : ℕ)) ℙ :=
    iIndepFun.precomp Fin.val_injective hX.indep
  have h := hi.measure_inter_preimage_eq_mul (Finset.univ : Finset (Fin t))
    (sets := fun i => {w i}) (fun i _ => measurableSet_singleton _)
  have he : {ω | ∀ i : Fin t, X (i : ℕ) ω = w i} =
      ⋂ i ∈ (Finset.univ : Finset (Fin t)), X (i : ℕ) ⁻¹' {w i} := by
    ext ω
    simp
  rw [he, h]
  simp only [one_step hX _ _ (hw _), Finset.prod_const, Finset.card_univ, Fintype.card_fin]

/-- The real-valued mass used in the discounted first-hit target. -/
theorem word_mass_real {t : ℕ} (w : Fin t → ℤ × ℤ) (hw : ∀ i, w i ∈ Erdos1165.steps) :
    (ℙ {ω | ∀ i : Fin t, X (i : ℕ) ω = w i}).toReal = (1 / 4 : ℝ)^t := by
  rw [word_mass hX w hw]
  simp

/-- The walk almost surely produces a legal word at every finite length at once. -/
theorem legal_path_ae [IsProbabilityMeasure (ℙ : Measure Ω)] : ∀ᵐ ω ∂ℙ, ∀ k, X k ω ∈ Erdos1165.steps := by
  rw [ae_all_iff]
  intro k
  have hmeas : MeasurableSet Erdos1165.steps := Set.to_countable _ |>.measurableSet
  have hp : ℙ (X k ⁻¹' Erdos1165.steps) = 1 := by
    rw [(hX.isUniform k).measure_preimage (by rw [four_steps]; norm_num)
        (by rw [four_steps]; norm_num) hmeas, Set.inter_self, four_steps]
    exact ENNReal.div_self (by norm_num) (by norm_num)
  exact (mem_ae_iff_prob_eq_one ((hX.measurable k) hmeas)).2 hp

/-- The probability of any specified finite list of distinct legal paths is its
cardinality times the mass of one word. No independence of path events is assumed. -/
theorem count_words {t : ℕ} (A : Finset (Fin t → ℤ × ℤ))
    (ha : ∀ w ∈ A, ∀ i, w i ∈ Erdos1165.steps) :
    ℙ {ω | (fun i : Fin t => X i ω) ∈ A} =
      (A.card : ℝ≥0∞) * (1 / 4 : ℝ≥0∞)^t := by
  classical
  let C := fun w : Fin t → ℤ × ℤ => {ω | ∀ i : Fin t, X i ω = w i}
  have hm (w) : MeasurableSet (C w) := by
    have he : C w = ⋂ i : Fin t, X i ⁻¹' {w i} := by
      ext ω
      simp [C]
    rw [he]
    exact MeasurableSet.iInter (fun i : Fin t => (hX.measurable i) (measurableSet_singleton (w i)))
  have hd : Set.PairwiseDisjoint (A : Set (Fin t → ℤ × ℤ)) C := by
    intro u _ v _ huv
    refine Set.disjoint_left.mpr ?_
    intro ω hu hv
    exact huv (funext (fun i => (hu i).symm.trans (hv i)))
  have he : {ω | (fun i : Fin t => X i ω) ∈ A} = ⋃ w ∈ A, C w := by
    ext ω
    simp only [Set.mem_setOf_eq, Set.mem_iUnion, exists_prop, C]
    constructor
    · intro h
      exact ⟨_, h, fun _ => rfl⟩
    · rintro ⟨w, hw, heq⟩
      rwa [show (fun i : Fin t => X i ω) = w from funext heq]
  rw [he, measure_biUnion_finset hd (fun w _ => hm w)]
  calc
    _ = ∑ _w ∈ A, (1 / 4 : ℝ≥0∞)^t :=
      Finset.sum_congr rfl (fun w hw => word_mass hX w (ha w hw))
    _ = _ := by simp [nsmul_eq_mul]

/-- Endpoint after the first j increments of a length-t word, for j ≤ t. -/
def pathPos {t : ℕ} (w : Fin t → ℤ × ℤ) (j : ℕ) : ℤ × ℤ :=
  ∑ k ∈ Finset.range j, if hk : k < t then w ⟨k, hk⟩ else 0

omit hX [MeasureSpace Ω] in
private theorem prefix_eq {t j : ℕ} (hj : j ≤ t) (ω : Ω) :
    pathPos (fun i : Fin t => X i ω) j = Erdos1165.position X j ω := by
  unfold pathPos Erdos1165.position
  exact Finset.sum_congr rfl fun k hk => dif_pos ((Finset.mem_range.mp hk).trans_le hj)

/-- Enumerate the legal words that first visit x at exactly time t. -/
def firstHitWords (t : ℕ) (x : ℤ × ℤ) : Finset (Fin t → ℤ × ℤ) :=
  (Fintype.piFinset (fun _ : Fin t => ({(1,0), (-1,0), (0,1), (0,-1)} : Finset (ℤ × ℤ)))).filter
    (fun w => pathPos w t = x ∧ ∀ j < t, pathPos w j ≠ x)

/-- Exact first-visit probability on the catalogue's arbitrary probability space. -/
theorem first_hit_count [IsProbabilityMeasure (ℙ : Measure Ω)] (t : ℕ) (x : ℤ × ℤ) :
    (ℙ {ω | Erdos1165.position X t ω = x ∧ ∀ j < t, Erdos1165.position X j ω ≠ x}).toReal =
      ((firstHitWords t x).card : ℝ) * (1 / 4 : ℝ)^t := by
  classical
  have hlegal : ∀ w ∈ firstHitWords t x, ∀ i, w i ∈ Erdos1165.steps := by
    intro w hw i
    have hi := Fintype.mem_piFinset.mp (Finset.mem_filter.mp hw).1 i
    simpa [Erdos1165.steps] using hi
  have he : {ω | Erdos1165.position X t ω = x ∧ ∀ j < t, Erdos1165.position X j ω ≠ x} =ᵐ[ℙ]
      {ω | (fun i : Fin t => X i ω) ∈ firstHitWords t x} := by
    filter_upwards [legal_path_ae hX] with ω hω
    apply propext
    change (_ ∧ _) ↔ _ ∈ (Finset.filter _ _)
    rw [Finset.mem_filter, Fintype.mem_piFinset]
    have hl : ∀ i : Fin t, X i ω ∈ ({(1,0), (-1,0), (0,1), (0,-1)} : Finset (ℤ × ℤ)) :=
      fun i => by simpa [Erdos1165.steps] using hω i
    constructor
    · rintro ⟨hend, hprev⟩
      refine ⟨hl, ?_, ?_⟩
      · rwa [prefix_eq (le_refl t)]
      · intro j hj
        rw [prefix_eq hj.le]
        exact hprev j hj
    · rintro ⟨_, hend, hprev⟩
      refine ⟨?_, ?_⟩
      · rwa [prefix_eq (le_refl t)] at hend
      · intro j hj
        have hn := hprev j hj
        rwa [prefix_eq hj.le] at hn
  rw [measure_congr he, count_words hX _ hlegal]
  simp

end DiffusionCylinder
