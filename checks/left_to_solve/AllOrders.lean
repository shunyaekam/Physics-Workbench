import FormalConjectures.Paper.MonochromaticQuantumGraph

import Mathlib.Algebra.Algebra.Basic

import Mathlib.Algebra.BigOperators.Field

import Mathlib.Algebra.BigOperators.Fin

import Mathlib.Algebra.BigOperators.Ring.Finset

import Mathlib.Algebra.CharZero.Infinite

import Mathlib.Algebra.Field.Basic

import Mathlib.Algebra.Module.Pi

import Mathlib.Algebra.MvPolynomial.Basic

import Mathlib.Algebra.MvPolynomial.Coeff

import Mathlib.Algebra.MvPolynomial.CommRing

import Mathlib.Algebra.MvPolynomial.Division

import Mathlib.Algebra.MvPolynomial.Equiv

import Mathlib.Algebra.MvPolynomial.Eval

import Mathlib.Algebra.MvPolynomial.Funext

import Mathlib.Algebra.MvPolynomial.NoZeroDivisors

import Mathlib.Algebra.MvPolynomial.PDeriv

import Mathlib.Algebra.MvPolynomial.Rename

import Mathlib.Algebra.Polynomial.Degree.Lemmas

import Mathlib.Algebra.Polynomial.Derivative

import Mathlib.Algebra.Polynomial.Roots

import Mathlib.Algebra.Ring.Parity

import Mathlib.Analysis.Complex.Polynomial.Basic

import Mathlib.Analysis.SpecialFunctions.Pow.Real

import Mathlib.Combinatorics.SimpleGraph.CycleGraph

import Mathlib.Combinatorics.SimpleGraph.Hamiltonian

import Mathlib.Combinatorics.SimpleGraph.Matching

import Mathlib.Data.Complex.Basic

import Mathlib.Data.Fin.Basic

import Mathlib.Data.Finset.Sum

import Mathlib.Data.Fintype.EquivFin

import Mathlib.Data.Fintype.Perm

import Mathlib.Data.Fintype.Pi

import Mathlib.Data.List.Chain

import Mathlib.Data.List.Pairwise

import Mathlib.FieldTheory.IsAlgClosed.Basic

import Mathlib.LinearAlgebra.BilinearMap

import Mathlib.LinearAlgebra.Matrix.BilinearForm

import Mathlib.LinearAlgebra.Matrix.Notation

import Mathlib.LinearAlgebra.Matrix.SemiringInverse

import Mathlib.LinearAlgebra.Multilinear.Basic

import Mathlib.LinearAlgebra.Multilinear.Curry

import Mathlib.Logic.Equiv.Fin.Basic

import Mathlib.Logic.Equiv.Sum

import Mathlib.RingTheory.Ideal.Quotient.Defs

import Mathlib.RingTheory.MvPolynomial.Homogeneous

import Mathlib.RingTheory.MvPolynomial.WeightedHomogeneous

import Mathlib.Tactic.FieldSimp

import Mathlib.Tactic.FinCases

import Mathlib.Tactic.LinearCombination

import Mathlib.Tactic.Ring

/-
Original proofs and graph-model identifications by Rishi Rajasekaran.
Copyright 2026 Rishi. Released under the Apache License, Version 2.0.
Source: https://github.com/rrajasek95/krenn-conjecture/tree/1db2e5a23d97e3b2d03c30c6d9af773111ec682b/formal
The all-orders source directory and the explicitly licensed upstream-adapter file are
redistributed under Apache 2.0; original notices and the license text are included here.
The single-file platform port and palette restriction at the pinned revision are by @shunyaekam.
Changes: group imports, concatenate modules, condense comments, remove unused exports,
replace generated extensionality with a proof, and adapt to pinned Mathlib.
The original source paths appear at their respective boundaries.
-/

-- formal/all-orders/MatchingModel.lean

namespace Krenn.MatchingModel

open scoped BigOperators

abbrev V (N : ℕ) := Fin N

structure EdgeN (N D : ℕ) where
  u : V N
  v : V N
  i : Fin D
  j : Fin D
deriving DecidableEq

abbrev WeightsN (N D : ℕ) (α : Type*) := EdgeN N D → α

def mkEdge {N D : ℕ} (u v : V N) (i j : Fin D) : EdgeN N D :=
  ⟨u, v, i, j⟩

def vertices : (N : ℕ) → List (V N)
  | 0 => []
  | N + 1 => (0 : Fin (N + 1)) :: (vertices N).map Fin.succ

def pmSumListAux {α : Type*} [Semiring α] {N D : ℕ}
    (W : WeightsN N D α) (ι : V N → Fin D) : ℕ → List (V N) → α
  | 0, _ => 1
  | 1, _ => 0
  | _ + 2, [] => 1
  | _ + 2, [_] => 0
  | n + 2, v :: vs =>
      (vs.map fun u => W (mkEdge v u (ι v) (ι u)) *
        pmSumListAux W ι n (vs.erase u)).sum

def pmSumList {α : Type*} [Semiring α] {N D : ℕ}
    (W : WeightsN N D α) (ι : V N → Fin D) (L : List (V N)) : α :=
  pmSumListAux W ι L.length L

def pmSumN {α : Type*} [Semiring α] (N D : ℕ)
    (W : WeightsN N D α) (ι : V N → Fin D) : α :=
  pmSumList W ι (vertices N)

def allEqualList {N D : ℕ} (ι : V N → Fin D) (L : List (V N)) : Prop :=
  List.IsChain (fun v w => ι v = ι w) L

def allEqual {N D : ℕ} (ι : V N → Fin D) : Prop :=
  allEqualList ι (vertices N)

instance {N D : ℕ} (ι : V N → Fin D) (L : List (V N)) :
    Decidable (allEqualList ι L) := by
  letI : DecidableRel (fun v w : V N => ι v = ι w) := fun v w => inferInstance
  unfold allEqualList
  infer_instance

instance {N D : ℕ} (ι : V N → Fin D) : Decidable (allEqual ι) := by
  unfold allEqual
  infer_instance

def EqSystemN {α : Type*} [Semiring α] (N D : ℕ) (W : WeightsN N D α) : Prop :=
  ∀ ι : V N → Fin D, pmSumN N D W ι = if allEqual ι then 1 else 0

abbrev SiteVariable (N D : ℕ) := V N × Fin D
abbrev MatchingPolynomial (N D : ℕ) (α : Type*) [CommSemiring α] :=
  MvPolynomial (SiteVariable N D) α

variable {α : Type*} [CommSemiring α] {N D : ℕ}

noncomputable def edgePolynomial (W : WeightsN N D α) (v u : V N) :
    MatchingPolynomial N D α :=
  ∑ i : Fin D, ∑ j : Fin D,
    MvPolynomial.C (W (mkEdge v u i j)) *
      MvPolynomial.X (v, i) * MvPolynomial.X (u, j)

noncomputable def matchingPolynomialAux (W : WeightsN N D α) :
    ℕ → List (V N) → MatchingPolynomial N D α
  | 0, _ => 1
  | 1, _ => 0
  | _ + 2, [] => 1
  | _ + 2, [_] => 0
  | n + 2, v :: vs =>
      (vs.map fun u => edgePolynomial W v u *
        matchingPolynomialAux W n (vs.erase u)).sum

noncomputable def matchingPolynomialList (W : WeightsN N D α) (L : List (V N)) :
    MatchingPolynomial N D α := matchingPolynomialAux W L.length L

noncomputable def matchingPolynomialN (W : WeightsN N D α) :
    MatchingPolynomial N D α := matchingPolynomialList W (vertices N)

noncomputable def selector (ι : V N → Fin D) : SiteVariable N D → α :=
  fun z => if z.2 = ι z.1 then 1 else 0

@[simp]
theorem eval_edgePolynomial (W : WeightsN N D α) (ι : V N → Fin D) (v u : V N) :
    MvPolynomial.eval (selector ι) (edgePolynomial W v u) =
      W (mkEdge v u (ι v) (ι u)) := by
  classical
  simp [edgePolynomial, selector, MvPolynomial.eval_mul]

theorem eval_matchingPolynomialAux (W : WeightsN N D α) (ι : V N → Fin D) :
    ∀ (n : ℕ) (L : List (V N)),
      MvPolynomial.eval (selector ι) (matchingPolynomialAux W n L) =
        pmSumListAux W ι n L
  | 0, _ => by simp [matchingPolynomialAux, pmSumListAux]
  | 1, _ => by simp [matchingPolynomialAux, pmSumListAux]
  | _ + 2, [] => by simp [matchingPolynomialAux, pmSumListAux]
  | _ + 2, [_] => by simp [matchingPolynomialAux, pmSumListAux]
  | n + 2, v :: u :: L => by
    simp only [matchingPolynomialAux, pmSumListAux]
    rw [map_list_sum]
    congr 1
    simp only [List.map_map]
    apply List.map_congr_left
    intro r _
    simp only [Function.comp_apply]
    rw [map_mul, eval_edgePolynomial, eval_matchingPolynomialAux W ι n]

theorem eval_matchingPolynomialN (W : WeightsN N D α) (ι : V N → Fin D) :
    MvPolynomial.eval (selector ι) (matchingPolynomialN W) = pmSumN N D W ι :=
  eval_matchingPolynomialAux W ι _ _

@[simp]
theorem matchingPolynomialList_nil (W : WeightsN N D α) :
    matchingPolynomialList W [] = 1 := rfl

@[simp]
theorem matchingPolynomialList_singleton (W : WeightsN N D α) (v : V N) :
    matchingPolynomialList W [v] = 0 := rfl

noncomputable def wordExponent (ι : V N → Fin D) : List (V N) → SiteVariable N D →₀ ℕ
  | [] => 0
  | v :: L => Finsupp.single (v, ι v) 1 + wordExponent ι L

theorem wordExponent_wrong_color (ι : V N → Fin D) (L : List (V N))
    (v : V N) (i : Fin D) (hi : i ≠ ι v) : wordExponent ι L (v, i) = 0 := by
  induction L with
  | nil => simp [wordExponent]
  | cons u L ih =>
    have h : (u, ι u) ≠ (v, i) := by
      intro h
      have huv : u = v := congrArg Prod.fst h
      have hui : ι u = i := congrArg Prod.snd h
      exact hi (by simpa [huv] using hui.symm)
    simp [wordExponent, h, ih]

theorem wordExponent_erase (ι : V N → Fin D) (L : List (V N)) (u : V N)
    (hu : u ∈ L) :
    wordExponent ι L = Finsupp.single (u, ι u) 1 + wordExponent ι (L.erase u) := by
  induction L with
  | nil => simp at hu
  | cons v L ih =>
    by_cases hv : v = u
    · subst v
      simp [wordExponent]
    · have huL : u ∈ L := by simpa [Ne.symm hv] using hu
      rw [List.erase_cons_tail (by simpa using hv)]
      simp only [wordExponent]
      rw [ih huL]
      ac_rfl

private theorem coeff_X_mul_zero (P : MatchingPolynomial N D α)
    (m : SiteVariable N D →₀ ℕ) (z : SiteVariable N D) (hz : m z = 0) :
    MvPolynomial.coeff m (MvPolynomial.X z * P) = 0 := by
  classical
  simp [MvPolynomial.coeff_X_mul', Finsupp.mem_support_iff, hz]

theorem coeff_edgePolynomial_mul (W : WeightsN N D α) (ι : V N → Fin D)
    (L : List (V N)) (v u : V N) (P : MatchingPolynomial N D α) :
    MvPolynomial.coeff (wordExponent ι L) (edgePolynomial W v u * P) =
      W (mkEdge v u (ι v) (ι u)) *
        MvPolynomial.coeff (wordExponent ι L)
          (MvPolynomial.X (v, ι v) * MvPolynomial.X (u, ι u) * P) := by
  classical
  simp only [edgePolynomial, Finset.sum_mul, MvPolynomial.coeff_sum]
  rw [Finset.sum_eq_single (ι v)]
  · rw [Finset.sum_eq_single (ι u)]
    · rw [mul_assoc, mul_assoc, MvPolynomial.coeff_C_mul, mul_assoc]
    · intro j _ hj
      rw [show MvPolynomial.C (W (mkEdge v u (ι v) j)) *
          MvPolynomial.X (v, ι v) * MvPolynomial.X (u, j) * P =
          MvPolynomial.X (u, j) *
            (MvPolynomial.C (W (mkEdge v u (ι v) j)) * MvPolynomial.X (v, ι v) * P)
          by ring]
      exact coeff_X_mul_zero _ _ _ (wordExponent_wrong_color ι L u j hj)
    · simp
  · intro i _ hi
    apply Finset.sum_eq_zero
    intro j _
    rw [show MvPolynomial.C (W (mkEdge v u i j)) *
        MvPolynomial.X (v, i) * MvPolynomial.X (u, j) * P =
        MvPolynomial.X (v, i) *
          (MvPolynomial.C (W (mkEdge v u i j)) * MvPolynomial.X (u, j) * P)
        by ring]
    exact coeff_X_mul_zero _ _ _ (wordExponent_wrong_color ι L v i hi)
  · simp

theorem coeff_matchingPolynomialAux (W : WeightsN N D α) (ι : V N → Fin D) :
    ∀ (n : ℕ) (L : List (V N)), L.length = n →
      MvPolynomial.coeff (wordExponent ι L) (matchingPolynomialAux W n L) =
        pmSumListAux W ι n L
  | 0, L, h => by
    cases L with
    | nil => simp [wordExponent, matchingPolynomialAux, pmSumListAux]
    | cons v L => simp at h
  | 1, L, _ => by simp [matchingPolynomialAux, pmSumListAux]
  | _ + 2, [], h => by simp at h
  | _ + 2, [_], h => by simp at h
  | n + 2, v :: u :: L, h => by
    simp only [matchingPolynomialAux, pmSumListAux]
    rw [← MvPolynomial.coeffAddMonoidHom_apply]
    rw [map_list_sum]
    congr 1
    simp only [List.map_map]
    apply List.map_congr_left
    intro r hr
    simp only [Function.comp_apply, MvPolynomial.coeffAddMonoidHom_apply]
    rw [coeff_edgePolynomial_mul]
    have hw : wordExponent ι (v :: u :: L) =
        Finsupp.single (v, ι v) 1 + Finsupp.single (r, ι r) 1 +
          wordExponent ι ((u :: L).erase r) := by
      rw [wordExponent, wordExponent_erase ι (u :: L) r hr]
      ac_rfl
    rw [hw, mul_assoc, add_assoc, MvPolynomial.coeff_X_mul,
      MvPolynomial.coeff_X_mul]
    rw [coeff_matchingPolynomialAux W ι n ((u :: L).erase r)]
    rw [List.length_erase_of_mem hr]
    simp only [List.length_cons] at h ⊢
    omega

theorem coeff_matchingPolynomialList (W : WeightsN N D α) (ι : V N → Fin D)
    (L : List (V N)) :
    MvPolynomial.coeff (wordExponent ι L) (matchingPolynomialList W L) =
      pmSumList W ι L :=
  coeff_matchingPolynomialAux W ι L.length L rfl

theorem coeff_matchingPolynomialN (W : WeightsN N D α) (ι : V N → Fin D) :
    MvPolynomial.coeff (wordExponent ι (vertices N)) (matchingPolynomialN W) =
      pmSumN N D W ι :=
  coeff_matchingPolynomialList W ι _

theorem coeff_matchingPolynomialList_eq_selector (W : WeightsN N D α)
    (ι : V N → Fin D) (L : List (V N)) :
    MvPolynomial.coeff (wordExponent ι L) (matchingPolynomialList W L) =
      MvPolynomial.eval (selector ι) (matchingPolynomialList W L) :=
  (coeff_matchingPolynomialList W ι L).trans
    (eval_matchingPolynomialAux W ι L.length L).symm

noncomputable def siteWeight (z : SiteVariable N D) : V N →₀ ℕ :=
  Finsupp.single z.1 1

noncomputable def siteProfile : List (V N) → V N →₀ ℕ
  | [] => 0
  | v :: L => Finsupp.single v 1 + siteProfile L

theorem siteWeight_apply (m : SiteVariable N D →₀ ℕ) (v : V N) :
    Finsupp.weight siteWeight m v = ∑ i : Fin D, m (v, i) := by
  classical
  simp [Finsupp.weight_eq_sum, siteWeight, Fintype.sum_prod_type, Finsupp.single_apply]

theorem siteProfile_erase (L : List (V N)) (u : V N) (hu : u ∈ L) :
    siteProfile L = Finsupp.single u 1 + siteProfile (L.erase u) := by
  induction L with
  | nil => simp at hu
  | cons v L ih =>
    by_cases hv : v = u
    · subst v
      simp [siteProfile]
    · have huL : u ∈ L := by simpa [Ne.symm hv] using hu
      rw [List.erase_cons_tail (by simpa using hv)]
      simp only [siteProfile]
      rw [ih huL]
      ac_rfl

theorem siteProfile_apply (L : List (V N)) (v : V N) :
    siteProfile L v = L.count v := by
  induction L with
  | nil => simp [siteProfile]
  | cons u L ih =>
    simp [siteProfile, List.count_cons, ih, Finsupp.single_apply, add_comm]

theorem siteProfile_nodup (L : List (V N)) (hL : L.Nodup) (v : V N) :
    siteProfile L v = if v ∈ L then 1 else 0 := by
  rw [siteProfile_apply, hL.count]

private theorem weighted_list_sum (L : List (MatchingPolynomial N D α))
    (s : V N →₀ ℕ)
    (h : ∀ P ∈ L, MvPolynomial.IsWeightedHomogeneous siteWeight P s) :
    MvPolynomial.IsWeightedHomogeneous siteWeight L.sum s := by
  induction L with
  | nil => exact MvPolynomial.isWeightedHomogeneous_zero α siteWeight s
  | cons P L ih =>
    exact (h P (by simp)).add (ih fun Q hQ => h Q (by simp [hQ]))

theorem edgePolynomial_siteHomogeneous (W : WeightsN N D α) (v u : V N) :
    MvPolynomial.IsWeightedHomogeneous siteWeight (edgePolynomial W v u)
      (Finsupp.single v 1 + Finsupp.single u 1) := by
  classical
  unfold edgePolynomial
  apply MvPolynomial.IsWeightedHomogeneous.sum
  intro i _
  apply MvPolynomial.IsWeightedHomogeneous.sum
  intro j _
  simpa only [siteWeight, zero_add] using
    ((MvPolynomial.isWeightedHomogeneous_C siteWeight (W (mkEdge v u i j))).mul
      (MvPolynomial.isWeightedHomogeneous_X α siteWeight (v, i))).mul
        (MvPolynomial.isWeightedHomogeneous_X α siteWeight (u, j))

theorem matchingPolynomialAux_siteHomogeneous (W : WeightsN N D α) :
    ∀ (n : ℕ) (L : List (V N)), L.length = n →
      MvPolynomial.IsWeightedHomogeneous siteWeight (matchingPolynomialAux W n L)
        (siteProfile L)
  | 0, L, h => by
    cases L with
    | nil => exact MvPolynomial.isWeightedHomogeneous_one α siteWeight
    | cons v L => simp at h
  | 1, L, _ => MvPolynomial.isWeightedHomogeneous_zero α siteWeight (siteProfile L)
  | _ + 2, [], h => by simp at h
  | _ + 2, [_], h => by simp at h
  | n + 2, v :: u :: L, h => by
    simp only [matchingPolynomialAux]
    apply weighted_list_sum
    intro P hP
    obtain ⟨r, hr, rfl⟩ := List.mem_map.mp hP
    have hlen : ((u :: L).erase r).length = n := by
      rw [List.length_erase_of_mem hr]
      simp only [List.length_cons] at h ⊢
      omega
    have hs := (edgePolynomial_siteHomogeneous W v r).mul
      (matchingPolynomialAux_siteHomogeneous W n ((u :: L).erase r) hlen)
    have hp : siteProfile (v :: u :: L) =
        (Finsupp.single v 1 + Finsupp.single r 1) +
          siteProfile ((u :: L).erase r) := by
      rw [siteProfile, siteProfile_erase (u :: L) r hr]
      ac_rfl
    rw [hp]
    exact hs

theorem matchingPolynomialList_siteHomogeneous (W : WeightsN N D α) (L : List (V N)) :
    MvPolynomial.IsWeightedHomogeneous siteWeight (matchingPolynomialList W L)
      (siteProfile L) :=
  matchingPolynomialAux_siteHomogeneous W L.length L rfl

@[simp]
theorem vertices_eq_finRange (n : ℕ) : vertices n = List.finRange n := by
  induction n with
  | zero => rfl
  | succ n ih => rw [vertices, ih, List.finRange_succ]

theorem vertices_nodup (n : ℕ) : (vertices n).Nodup := by
  rw [vertices_eq_finRange]
  exact (List.pairwise_lt_finRange n).imp fun h => ne_of_lt h

theorem vertices_pairwise_lt (n : ℕ) :
    (vertices n).Pairwise (fun v u => v < u) := by
  rw [vertices_eq_finRange]
  exact List.pairwise_lt_finRange n

@[simp]
theorem mem_vertices (v : V N) : v ∈ vertices N := by simp

theorem matchingPolynomialN_siteHomogeneous (W : WeightsN N D α) :
    MvPolynomial.IsWeightedHomogeneous siteWeight (matchingPolynomialN W)
      (siteProfile (vertices N)) :=
  matchingPolynomialList_siteHomogeneous W _

theorem matchingPolynomialN_siteDegree (W : WeightsN N D α)
    (m : SiteVariable N D →₀ ℕ)
    (hm : MvPolynomial.coeff m (matchingPolynomialN W) ≠ 0) (v : V N) :
    Finsupp.weight siteWeight m v = 1 := by
  rw [matchingPolynomialN_siteHomogeneous W hm]
  rw [siteProfile_nodup _ (vertices_nodup N)]
  simp

theorem matchingPolynomialN_localDegree (W : WeightsN N D α)
    (m : SiteVariable N D →₀ ℕ)
    (hm : MvPolynomial.coeff m (matchingPolynomialN W) ≠ 0) (v : V N) :
    (∑ i : Fin D, m (v, i)) = 1 := by
  rw [← siteWeight_apply]
  exact matchingPolynomialN_siteDegree W m hm v

theorem eqSystemN_iff_coefficients (W : WeightsN N D α) :
    EqSystemN N D W ↔ ∀ ι : V N → Fin D,
      MvPolynomial.coeff (wordExponent ι (vertices N)) (matchingPolynomialN W) =
        if allEqual ι then 1 else 0 := by
  simp only [EqSystemN, coeff_matchingPolynomialN]

theorem edgePolynomial_add (W W' : WeightsN N D α) (v u : V N) :
    edgePolynomial (fun e => W e + W' e) v u =
      edgePolynomial W v u + edgePolynomial W' v u := by
  classical
  simp [edgePolynomial, map_add, add_mul, Finset.sum_add_distrib]

def reverseEdge (e : EdgeN N D) : EdgeN N D := ⟨e.v, e.u, e.j, e.i⟩

theorem edgePolynomial_reverse (W : WeightsN N D α) (v u : V N) :
    edgePolynomial (fun e => W (reverseEdge e)) v u = edgePolynomial W u v := by
  classical
  unfold edgePolynomial
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  simp only [mkEdge, reverseEdge]
  ring

theorem pmSumListAux_congr_ordered (W W' : WeightsN N D α) (ι : V N → Fin D)
    (hW : ∀ v u : V N, v < u → ∀ i j, W (mkEdge v u i j) = W' (mkEdge v u i j)) :
    ∀ (n : ℕ) (L : List (V N)), L.Pairwise (fun v u => v < u) →
      pmSumListAux W ι n L = pmSumListAux W' ι n L
  | 0, _, _ => rfl
  | 1, _, _ => rfl
  | _ + 2, [], _ => rfl
  | _ + 2, [_], _ => rfl
  | n + 2, v :: u :: L, hL => by
    simp only [pmSumListAux]
    congr 1
    apply List.map_congr_left
    intro r hr
    rw [hW v r (List.rel_of_pairwise_cons hL hr)]
    rw [pmSumListAux_congr_ordered W W' ι hW n ((u :: L).erase r)
      (List.Pairwise.erase r (List.pairwise_cons.mp hL).2)]

theorem pmSumN_congr_ordered (W W' : WeightsN N D α) (ι : V N → Fin D)
    (hW : ∀ v u : V N, v < u → ∀ i j, W (mkEdge v u i j) = W' (mkEdge v u i j)) :
    pmSumN N D W ι = pmSumN N D W' ι :=
  pmSumListAux_congr_ordered W W' ι hW _ _ (vertices_pairwise_lt N)

end Krenn.MatchingModel

-- formal/all-orders/SiteAlgebra.lean

namespace Krenn.SiteAlgebra

open scoped BigOperators
open MatchingModel

variable {R : Type*} {N D : ℕ}

section Ring

variable [CommRing R]

def siteRelations (N D : ℕ) (R : Type*) [CommRing R] :
    Set (MatchingPolynomial N D R) :=
  {P | ∃ (v : V N) (i j : Fin D),
    P = MvPolynomial.X (v, i) * MvPolynomial.X (v, j)}

noncomputable def siteIdeal (N D : ℕ) (R : Type*) [CommRing R] :
    Ideal (MatchingPolynomial N D R) := Ideal.span (siteRelations N D R)

abbrev SiteRing (N D : ℕ) (R : Type*) [CommRing R] :=
  MatchingPolynomial N D R ⧸ siteIdeal N D R

noncomputable def project : MatchingPolynomial N D R →+* SiteRing N D R :=
  Ideal.Quotient.mk (siteIdeal N D R)

noncomputable def siteX (v : V N) (i : Fin D) : SiteRing N D R :=
  project (MvPolynomial.X (v, i))

@[simp]
theorem siteX_mul_same (v : V N) (i j : Fin D) :
    siteX (R := R) v i * siteX v j = 0 := by
  rw [siteX, siteX, ← map_mul]
  apply Ideal.Quotient.eq_zero_iff_mem.mpr
  exact Ideal.subset_span ⟨v, i, j, rfl⟩

@[simp]
theorem siteX_sq (v : V N) (i : Fin D) : (siteX (R := R) v i) ^ 2 = 0 := by
  rw [pow_two, siteX_mul_same]

noncomputable def edgeMatrix (W : WeightsN N D R)
    (z t : SiteVariable N D) : R :=
  if z.1 < t.1 then W (mkEdge z.1 t.1 z.2 t.2)
  else if t.1 < z.1 then W (mkEdge t.1 z.1 t.2 z.2) else 0

theorem edgeMatrix_symm (W : WeightsN N D R) (z t : SiteVariable N D) :
    edgeMatrix W z t = edgeMatrix W t z := by
  unfold edgeMatrix
  rcases lt_trichotomy z.1 t.1 with h | h | h
  · simp [h, not_lt_of_gt h]
  · simp [h]
  · simp [h, not_lt_of_gt h]

@[simp]
theorem edgeMatrix_same_site (W : WeightsN N D R) (v : V N) (i j : Fin D) :
    edgeMatrix W (v, i) (v, j) = 0 := by simp [edgeMatrix]

theorem edgeMatrix_ordered (W : WeightsN N D R) (v u : V N) (hvu : v < u)
    (i j : Fin D) : edgeMatrix W (v, i) (u, j) = W (mkEdge v u i j) := by
  simp [edgeMatrix, hvu]

end Ring

section Field

variable [Field R] [CharZero R]

noncomputable def symmetricQuadratic (S : SiteVariable N D → SiteVariable N D → R) :
    MatchingPolynomial N D R :=
  MvPolynomial.C ((2 : R)⁻¹) *
    ∑ z : SiteVariable N D, ∑ t : SiteVariable N D,
      MvPolynomial.C (S z t) * MvPolynomial.X z * MvPolynomial.X t

noncomputable def rowPolynomial (S : SiteVariable N D → SiteVariable N D → R)
    (z : SiteVariable N D) : MatchingPolynomial N D R :=
  ∑ t : SiteVariable N D, MvPolynomial.C (S z t) * MvPolynomial.X t

theorem pderiv_symmetricQuadratic
    (S : SiteVariable N D → SiteVariable N D → R)
    (hS : ∀ z t, S z t = S t z) (z : SiteVariable N D) :
    MvPolynomial.pderiv z (symmetricQuadratic S) = rowPolynomial S z := by
  classical
  have hterm (a b : SiteVariable N D) :
      MvPolynomial.pderiv z
        (MvPolynomial.C (S a b) * MvPolynomial.X a * MvPolynomial.X b) =
      (if a = z then MvPolynomial.C (S a b) * MvPolynomial.X b else 0) +
        (if b = z then MvPolynomial.C (S a b) * MvPolynomial.X a else 0) := by
    by_cases ha : a = z <;> by_cases hb : b = z <;> simp [ha, hb] <;> ring
  have hfirst :
      (∑ a : SiteVariable N D, ∑ b : SiteVariable N D,
        if a = z then MvPolynomial.C (S a b) * MvPolynomial.X b else 0) =
      rowPolynomial S z := by
    rw [Finset.sum_comm]
    simp [rowPolynomial]
  have hsecond :
      (∑ a : SiteVariable N D, ∑ b : SiteVariable N D,
        if b = z then MvPolynomial.C (S a b) * MvPolynomial.X a else 0) =
      rowPolynomial S z := by simp [rowPolynomial, hS]
  have hgrad : MvPolynomial.pderiv z
      (∑ a : SiteVariable N D, ∑ b : SiteVariable N D,
        MvPolynomial.C (S a b) * MvPolynomial.X a * MvPolynomial.X b) =
      rowPolynomial S z + rowPolynomial S z := by
    simp_rw [map_sum, hterm, Finset.sum_add_distrib]
    rw [hfirst, hsecond]
  rw [symmetricQuadratic, MvPolynomial.pderiv_C_mul, hgrad]
  have htwo : (2 : R) ≠ 0 := by norm_num
  have hC : MvPolynomial.C ((2 : R)⁻¹) * MvPolynomial.C (2 : R) =
      (1 : MatchingPolynomial N D R) := by
    rw [← map_mul, inv_mul_cancel₀ htwo, map_one]
  calc
    MvPolynomial.C ((2 : R)⁻¹) *
        (rowPolynomial S z + rowPolynomial S z) =
      (MvPolynomial.C ((2 : R)⁻¹) * MvPolynomial.C (2 : R)) * rowPolynomial S z := by
        simp only [map_ofNat]
        ring
    _ = rowPolynomial S z := by rw [hC, one_mul]

noncomputable def sourceQuadratic (W : WeightsN N D R) : MatchingPolynomial N D R :=
  symmetricQuadratic (edgeMatrix W)

theorem pderiv_sourceQuadratic (W : WeightsN N D R) (z : SiteVariable N D) :
    MvPolynomial.pderiv z (sourceQuadratic W) = rowPolynomial (edgeMatrix W) z :=
  pderiv_symmetricQuadratic _ (edgeMatrix_symm W) z

theorem wordExponent_not_mem (ι : V N → Fin D) (L : List (V N))
    (v : V N) (hv : v ∉ L) (i : Fin D) : wordExponent ι L (v, i) = 0 := by
  induction L with
  | nil => simp [wordExponent]
  | cons u L ih =>
    have hvu : v ≠ u := by
      intro h
      exact hv (List.mem_cons.mpr (Or.inl h))
    have hvL : v ∉ L := by
      intro h
      exact hv (List.mem_cons.mpr (Or.inr h))
    have hpair : (u, ι u) ≠ (v, i) := by
      intro h
      exact hvu (congrArg Prod.fst h).symm
    simp [wordExponent, hpair, ih hvL]

omit [CharZero R] in

theorem coeff_rowPolynomial_mul
    (S : SiteVariable N D → SiteVariable N D → R) (z : SiteVariable N D)
    (ι : V N → Fin D) (L : List (V N)) (hL : L.Nodup)
    (P : MatchingPolynomial N D R) :
    MvPolynomial.coeff (wordExponent ι L) (rowPolynomial S z * P) =
      (L.map fun u => S z (u, ι u) *
        MvPolynomial.coeff (wordExponent ι (L.erase u)) P).sum := by
  classical
  simp only [rowPolynomial, Finset.sum_mul, MvPolynomial.coeff_sum,
    Fintype.sum_prod_type, mul_assoc, MvPolynomial.coeff_C_mul]
  have hcolor (u : V N) :
      (∑ i : Fin D, S z (u, i) * MvPolynomial.coeff (wordExponent ι L)
        (MvPolynomial.X (u, i) * P)) =
      S z (u, ι u) * MvPolynomial.coeff (wordExponent ι L)
        (MvPolynomial.X (u, ι u) * P) := by
    apply Finset.sum_eq_single (ι u)
    · intro i _ hi
      simp [MvPolynomial.coeff_X_mul', Finsupp.mem_support_iff,
        wordExponent_wrong_color ι L u i hi]
    · simp
  simp_rw [hcolor]
  let f := fun u : V N => S z (u, ι u) * MvPolynomial.coeff (wordExponent ι L)
    (MvPolynomial.X (u, ι u) * P)
  change (∑ u, f u) = _
  calc
    (∑ u, f u) = ∑ u ∈ L.toFinset, f u := by
      symm
      apply Finset.sum_subset (Finset.subset_univ _)
      intro u _ hu
      have huL : u ∉ L := by simpa using hu
      simp [f, MvPolynomial.coeff_X_mul', Finsupp.mem_support_iff,
        wordExponent_not_mem ι L u huL (ι u)]
    _ = ∑ u ∈ L.toFinset, S z (u, ι u) *
        MvPolynomial.coeff (wordExponent ι (L.erase u)) P := by
      apply Finset.sum_congr rfl
      intro u hu
      have huL : u ∈ L := List.mem_toFinset.mp hu
      simp only [f]
      rw [wordExponent_erase ι L u huL, MvPolynomial.coeff_X_mul]
    _ = _ := List.sum_toFinset _ hL

theorem coeff_root_pderiv (P : MatchingPolynomial N D R) (ι : V N → Fin D)
    (v : V N) (L : List (V N)) (hv : v ∉ L) :
    MvPolynomial.coeff (wordExponent ι (v :: L)) P =
      MvPolynomial.coeff (wordExponent ι L) (MvPolynomial.pderiv (v, ι v) P) := by
  rw [MvPolynomial.coeff_pderiv, wordExponent_not_mem ι L v hv (ι v)]
  simp [wordExponent, add_comm]

theorem coeff_sourceQuadratic_pow_succ (W : WeightsN N D R) (ι : V N → Fin D)
    (k : ℕ) (v : V N) (L : List (V N)) (hv : v ∉ L) (hL : L.Nodup) :
    MvPolynomial.coeff (wordExponent ι (v :: L)) (sourceQuadratic W ^ (k + 1)) =
      (k + 1 : R) * (L.map fun u => edgeMatrix W (v, ι v) (u, ι u) *
        MvPolynomial.coeff (wordExponent ι (L.erase u)) (sourceQuadratic W ^ k)).sum := by
  rw [coeff_root_pderiv _ ι v L hv, MvPolynomial.pderiv_pow,
    pderiv_sourceQuadratic]
  simp only [Nat.add_sub_cancel]
  rw [show (↑(k + 1) : MatchingPolynomial N D R) * sourceQuadratic W ^ k *
      rowPolynomial (edgeMatrix W) (v, ι v) =
      MvPolynomial.C (k + 1 : R) *
        (rowPolynomial (edgeMatrix W) (v, ι v) * sourceQuadratic W ^ k) by
      simp only [Nat.cast_add, Nat.cast_one, map_add, map_natCast, map_one]
      ring]
  rw [MvPolynomial.coeff_C_mul, coeff_rowPolynomial_mul _ _ ι L hL]

theorem coeff_sourceQuadratic_pow (W : WeightsN N D R) (ι : V N → Fin D) :
    ∀ (k : ℕ) (L : List (V N)), L.length = 2 * k →
      L.Pairwise (fun v u => v < u) →
      MvPolynomial.coeff (wordExponent ι L) (sourceQuadratic W ^ k) =
        (k.factorial : R) * pmSumListAux W ι (2 * k) L := by
  intro k
  induction k with
  | zero =>
    intro L hlen _
    have hL : L = [] := by simpa using hlen
    subst L
    simp [wordExponent, pmSumListAux]
  | succ k ih =>
    intro L hlen hord
    cases L with
    | nil => simp at hlen
    | cons v vs =>
      have hn : (v :: vs).Nodup := hord.imp (fun h => ne_of_lt h)
      have hv : v ∉ vs := (List.nodup_cons.mp hn).1
      have hvs : vs.Nodup := (List.nodup_cons.mp hn).2
      rw [coeff_sourceQuadratic_pow_succ W ι k v vs hv hvs]
      have hterm :
          (vs.map fun u => edgeMatrix W (v, ι v) (u, ι u) *
            MvPolynomial.coeff (wordExponent ι (vs.erase u))
              (sourceQuadratic W ^ k)).sum =
          (k.factorial : R) *
            (vs.map fun u => W (mkEdge v u (ι v) (ι u)) *
              pmSumListAux W ι (2 * k) (vs.erase u)).sum := by
        rw [← List.sum_map_mul_left]
        congr 1
        apply List.map_congr_left
        intro u hu
        have helen : (vs.erase u).length = 2 * k := by
          rw [List.length_erase_of_mem hu]
          simp only [List.length_cons] at hlen
          omega
        rw [edgeMatrix_ordered W v u (List.rel_of_pairwise_cons hord hu),
          ih (vs.erase u) helen (List.Pairwise.erase u (List.pairwise_cons.mp hord).2)]
        ring
      rw [hterm]
      have htwo : 2 * (k + 1) = 2 * k + 2 := by omega
      cases vs with
      | nil => simp only [List.length_cons, List.length_nil] at hlen; omega
      | cons u us =>
        rw [htwo, Nat.factorial_succ, Nat.cast_mul]
        simp only [pmSumListAux, Nat.cast_add, Nat.cast_one]
        ring

theorem coeff_sourceQuadratic_pow_full (k : ℕ)
    (W : WeightsN (2 * k) D R) (ι : V (2 * k) → Fin D) :
    MvPolynomial.coeff (wordExponent ι (vertices (2 * k)))
      (sourceQuadratic W ^ k) = (k.factorial : R) * pmSumN (2 * k) D W ι := by
  simpa [pmSumN, pmSumList] using
    coeff_sourceQuadratic_pow W ι k (vertices (2 * k))
      (by simp) (vertices_pairwise_lt _)

noncomputable def dividedSourcePower (W : WeightsN N D R) (k : ℕ) :
    MatchingPolynomial N D R :=
  MvPolynomial.C ((k.factorial : R)⁻¹) * sourceQuadratic W ^ k

theorem coeff_dividedSourcePower_full (k : ℕ)
    (W : WeightsN (2 * k) D R) (ι : V (2 * k) → Fin D) :
    MvPolynomial.coeff (wordExponent ι (vertices (2 * k)))
      (dividedSourcePower W k) = pmSumN (2 * k) D W ι := by
  rw [dividedSourcePower, MvPolynomial.coeff_C_mul, coeff_sourceQuadratic_pow_full]
  have hf : (k.factorial : R) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero k)
  rw [← mul_assoc, inv_mul_cancel₀ hf, one_mul]

end Field

section QuotientCoefficients

variable [CommRing R]

theorem wordExponent_selected (ι : V N → Fin D) (L : List (V N)) (v : V N) :
    wordExponent ι L (v, ι v) = L.count v := by
  induction L with
  | nil => simp [wordExponent]
  | cons u L ih =>
    by_cases h : u = v
    · subst u
      simp [wordExponent, ih, add_comm]
    · have hp : (u, ι u) ≠ (v, ι v) := by
        intro hp
        exact h (congrArg Prod.fst hp)
      simp [wordExponent, hp, h, ih]

noncomputable def siteDegree (m : SiteVariable N D →₀ ℕ) (v : V N) : ℕ :=
  ∑ i : Fin D, m (v, i)

noncomputable def exponentDegree (m : SiteVariable N D →₀ ℕ) : ℕ :=
  ∑ v : V N, siteDegree m v

theorem weight_one_eq_exponentDegree (m : SiteVariable N D →₀ ℕ) :
    Finsupp.weight (fun _ : SiteVariable N D => (1 : ℕ)) m = exponentDegree m := by
  simp [Finsupp.weight_eq_sum, exponentDegree, siteDegree, Fintype.sum_prod_type]

theorem exists_same_site_pair_le (m : SiteVariable N D →₀ ℕ) (v : V N)
    (h : 2 ≤ siteDegree m v) :
    ∃ i j : Fin D, Finsupp.single (v, i) 1 + Finsupp.single (v, j) 1 ≤ m := by
  classical
  obtain ⟨i, _, hi⟩ := Finset.sum_pos_iff.mp (show 0 < ∑ i : Fin D, m (v, i) by
    change 0 < siteDegree m v
    omega)
  have hile : Finsupp.single (v, i) 1 ≤ m := Finsupp.single_le_iff.mpr hi
  let t := m - Finsupp.single (v, i) 1
  have ht : t + Finsupp.single (v, i) 1 = m := tsub_add_cancel_of_le hile
  have hd : siteDegree t v + 1 = siteDegree m v := by
    rw [← ht]
    simp [siteDegree, Finset.sum_add_distrib, Finsupp.single_apply]
  obtain ⟨j, _, hj⟩ := Finset.sum_pos_iff.mp (show 0 < ∑ j : Fin D, t (v, j) by
    change 0 < siteDegree t v
    omega)
  refine ⟨i, j, ?_⟩
  have hjle : Finsupp.single (v, j) 1 ≤ t := Finsupp.single_le_iff.mpr hj
  calc
    Finsupp.single (v, i) 1 + Finsupp.single (v, j) 1 ≤
        Finsupp.single (v, i) 1 + t := add_le_add le_rfl hjle
    _ = m := by rw [add_comm, ht]

theorem monomial_mem_siteIdeal_of_doubled (m : SiteVariable N D →₀ ℕ) (a : R)
    (v : V N) (h : 2 ≤ siteDegree m v) :
    MvPolynomial.monomial m a ∈ siteIdeal N D R := by
  classical
  obtain ⟨i, j, hij⟩ := exists_same_site_pair_le m v h
  have hgen : (MvPolynomial.monomial
      (Finsupp.single (v, i) 1 + Finsupp.single (v, j) 1) (1 : R)) ∈ siteIdeal N D R := by
    have heq : (MvPolynomial.X (v, i) * MvPolynomial.X (v, j) :
        MatchingPolynomial N D R) = MvPolynomial.monomial
          (Finsupp.single (v, i) 1 + Finsupp.single (v, j) 1) 1 := by
      simp [MvPolynomial.X, MvPolynomial.monomial_mul]
    rw [← heq]
    exact Ideal.subset_span ⟨v, i, j, rfl⟩
  have heq := add_tsub_cancel_of_le hij
  rw [← heq]
  simpa only [MvPolynomial.monomial_mul, one_mul] using
    (siteIdeal N D R).mul_mem_right
      (MvPolynomial.monomial (m - (Finsupp.single (v, i) 1 + Finsupp.single (v, j) 1)) a)
      hgen

theorem exists_word_of_full_squarefree (m : SiteVariable N D →₀ ℕ)
    (hs : ∀ v, siteDegree m v ≤ 1) (hd : exponentDegree m = N) :
    ∃ ι : V N → Fin D, m = wordExponent ι (vertices N) := by
  classical
  have hone : ∀ v, siteDegree m v = 1 := by
    have hh : ∀ v ∈ Finset.univ, siteDegree m v = 1 :=
      (Finset.sum_eq_sum_iff_of_le (fun v (_ : v ∈ Finset.univ) => hs v)).mp
        (by simpa [exponentDegree] using hd)
    exact fun v => hh v (Finset.mem_univ v)
  have hex (v : V N) : ∃ i : Fin D, 0 < m (v, i) := by
    obtain ⟨i, _, hi⟩ := Finset.sum_pos_iff.mp (show 0 < ∑ i : Fin D, m (v, i) by
      change 0 < siteDegree m v
      rw [hone v]
      norm_num)
    exact ⟨i, hi⟩
  choose ι hι using hex
  refine ⟨ι, ?_⟩
  ext z
  rcases z with ⟨v, i⟩
  have hchosen : m (v, ι v) = 1 := by
    have hle := Finset.single_le_sum (fun j (_ : j ∈ Finset.univ) => Nat.zero_le (m (v, j)))
      (Finset.mem_univ (ι v))
    change m (v, ι v) ≤ siteDegree m v at hle
    rw [hone v] at hle
    exact Nat.le_antisymm hle (hι v)
  by_cases hi : i = ι v
  · subst i
    rw [wordExponent_selected, (vertices_nodup N).count]
    simp only [mem_vertices, if_true]
    exact hchosen
  · have herase : ∑ j ∈ Finset.univ.erase (ι v), m (v, j) = 0 := by
      have hh := Finset.sum_erase_add Finset.univ (fun j => m (v, j)) (Finset.mem_univ (ι v))
      rw [hchosen] at hh
      change (∑ j ∈ Finset.univ.erase (ι v), m (v, j)) + 1 = siteDegree m v at hh
      rw [hone v] at hh
      omega
    have hle := Finset.single_le_sum (fun j (_ : j ∈ Finset.univ.erase (ι v)) =>
      Nat.zero_le (m (v, j))) (Finset.mem_erase.mpr ⟨hi, Finset.mem_univ i⟩)
    rw [herase] at hle
    rw [wordExponent_wrong_color ι (vertices N) v i hi]
    exact Nat.eq_zero_of_le_zero hle

theorem project_eq_of_full_coefficients (P Q : MatchingPolynomial N D R)
    (hP : MvPolynomial.IsWeightedHomogeneous (fun _ : SiteVariable N D => (1 : ℕ)) P N)
    (hQ : MvPolynomial.IsWeightedHomogeneous (fun _ : SiteVariable N D => (1 : ℕ)) Q N)
    (hc : ∀ ι : V N → Fin D,
      MvPolynomial.coeff (wordExponent ι (vertices N)) P =
        MvPolynomial.coeff (wordExponent ι (vertices N)) Q) : project P = project Q := by
  apply sub_eq_zero.mp
  rw [← map_sub project]
  apply Ideal.Quotient.eq_zero_iff_mem.mpr
  rw [MvPolynomial.as_sum (P - Q)]
  apply Ideal.sum_mem
  intro m hm
  by_cases hdouble : ∃ v, 2 ≤ siteDegree m v
  · obtain ⟨v, hv⟩ := hdouble
    exact monomial_mem_siteIdeal_of_doubled m _ v hv
  · have hs : ∀ v, siteDegree m v ≤ 1 := by
      intro v
      by_contra hv
      apply hdouble
      exact ⟨v, by omega⟩
    have hd : exponentDegree m = N := by
      rw [← weight_one_eq_exponentDegree]
      exact (hP.sub hQ) (MvPolynomial.mem_support_iff.mp hm)
    obtain ⟨ι, rfl⟩ := exists_word_of_full_squarefree m hs hd
    rw [MvPolynomial.coeff_sub, hc ι, sub_self, MvPolynomial.monomial_zero]
    exact (siteIdeal N D R).zero_mem

theorem wordExponent_selected_le_one (ι : V N → Fin D) (L : List (V N))
    (hL : L.Nodup) (v : V N) : wordExponent ι L (v, ι v) ≤ 1 := by
  rw [wordExponent_selected, hL.count]
  split_ifs <;> omega

theorem coeff_siteRelation_mul (ι : V N → Fin D) (L : List (V N)) (hL : L.Nodup)
    (v : V N) (i j : Fin D) (P : MatchingPolynomial N D R) :
    MvPolynomial.coeff (wordExponent ι L)
      ((MvPolynomial.X (v, i) * MvPolynomial.X (v, j)) * P) = 0 := by
  classical
  have hnot : ¬ (Finsupp.single (v, i) 1 + Finsupp.single (v, j) 1 ≤
      wordExponent ι L) := by
    intro h
    by_cases hi : i = ι v
    · by_cases hj : j = ι v
      · have hc := h (v, ι v)
        have hb := wordExponent_selected_le_one ι L hL v
        simp [hi, hj] at hc
        omega
      · have hc := h (v, j)
        simp [wordExponent_wrong_color ι L v j hj] at hc
    · have hc := h (v, i)
      simp [wordExponent_wrong_color ι L v i hi] at hc
  have hmono : (MvPolynomial.X (v, i) * MvPolynomial.X (v, j) :
      MatchingPolynomial N D R) =
      MvPolynomial.monomial (Finsupp.single (v, i) 1 + Finsupp.single (v, j) 1) 1 := by
    simp [MvPolynomial.X, MvPolynomial.monomial_mul]
  rw [hmono, MvPolynomial.coeff_monomial_mul', if_neg hnot]

theorem coeff_siteIdeal_zero (ι : V N → Fin D) (L : List (V N)) (hL : L.Nodup)
    (P : MatchingPolynomial N D R) (hP : P ∈ siteIdeal N D R) :
    MvPolynomial.coeff (wordExponent ι L) P = 0 := by
  classical
  have hall : ∀ Q ∈ siteIdeal N D R, ∀ A : MatchingPolynomial N D R,
      MvPolynomial.coeff (wordExponent ι L) (Q * A) = 0 := by
    intro Q hQ
    induction hQ using Submodule.span_induction with
    | mem Q hQ =>
      rcases hQ with ⟨v, i, j, rfl⟩
      exact fun A => coeff_siteRelation_mul ι L hL v i j A
    | zero => intro A; simp
    | add Q Q' _ _ ih ih' =>
      intro A
      simp [add_mul, ih A, ih' A]
    | smul A Q _ ih =>
      intro A'
      simpa only [smul_eq_mul, mul_assoc, mul_left_comm A Q] using ih (A * A')
  simpa using hall P hP 1

theorem coeff_eq_of_project_eq (ι : V N → Fin D) (L : List (V N)) (hL : L.Nodup)
    (P Q : MatchingPolynomial N D R) (h : project P = project Q) :
    MvPolynomial.coeff (wordExponent ι L) P =
      MvPolynomial.coeff (wordExponent ι L) Q := by
  have hmem : P - Q ∈ siteIdeal N D R :=
    (Ideal.Quotient.mk_eq_mk_iff_sub_mem P Q).mp h
  have hc := coeff_siteIdeal_zero ι L hL (P - Q) hmem
  rw [MvPolynomial.coeff_sub] at hc
  exact sub_eq_zero.mp hc

noncomputable def siteCoefficient (ι : V N → Fin D) : SiteRing N D R → R :=
  fun q => MvPolynomial.coeff (wordExponent ι (vertices N)) (Quotient.out q)

@[simp]
theorem siteCoefficient_project (ι : V N → Fin D) (P : MatchingPolynomial N D R) :
    siteCoefficient ι (project P) =
      MvPolynomial.coeff (wordExponent ι (vertices N)) P := by
  apply coeff_eq_of_project_eq ι (vertices N) (vertices_nodup N)
  exact Ideal.Quotient.mk_out (project P)

noncomputable def siteCoefficientHom (ι : V N → Fin D) : SiteRing N D R →+ R where
  toFun := siteCoefficient ι
  map_zero' := by
    rw [← map_zero project, siteCoefficient_project]
    exact MvPolynomial.coeff_zero _
  map_add' := by
    intro q r
    obtain ⟨P, rfl⟩ := Ideal.Quotient.mk_surjective q
    obtain ⟨Q, rfl⟩ := Ideal.Quotient.mk_surjective r
    change siteCoefficient ι (project P + project Q) =
      siteCoefficient ι (project P) + siteCoefficient ι (project Q)
    calc
      siteCoefficient ι (project P + project Q) = siteCoefficient ι (project (P + Q)) :=
        congrArg (siteCoefficient ι) (map_add project P Q).symm
      _ = _ := by rw [siteCoefficient_project, MvPolynomial.coeff_add,
        siteCoefficient_project, siteCoefficient_project]

@[simp]
theorem siteCoefficient_project_mul_C (ι : V N → Fin D)
    (a : R) (q : SiteRing N D R) :
    siteCoefficient ι (project (MvPolynomial.C a) * q) = a * siteCoefficient ι q := by
  obtain ⟨P, rfl⟩ := Ideal.Quotient.mk_surjective q
  change siteCoefficient ι (project (MvPolynomial.C a) * project P) =
    a * siteCoefficient ι (project P)
  calc
    siteCoefficient ι (project (MvPolynomial.C a) * project P) =
        siteCoefficient ι (project (MvPolynomial.C a * P)) :=
      congrArg (siteCoefficient ι) (map_mul project (MvPolynomial.C a) P).symm
    _ = _ := by rw [siteCoefficient_project, MvPolynomial.coeff_C_mul,
      siteCoefficient_project]

end QuotientCoefficients

section DividedPhysicalCoefficients

variable [Field R] [CharZero R]

omit [CharZero R] in

theorem sourceQuadratic_totalHomogeneous (W : WeightsN N D R) :
    MvPolynomial.IsWeightedHomogeneous (fun _ : SiteVariable N D => (1 : ℕ))
      (sourceQuadratic W) 2 := by
  classical
  unfold sourceQuadratic symmetricQuadratic
  apply MvPolynomial.IsWeightedHomogeneous.C_mul
  apply MvPolynomial.IsWeightedHomogeneous.sum
  intro z _
  apply MvPolynomial.IsWeightedHomogeneous.sum
  intro t _
  simpa using
    ((MvPolynomial.isWeightedHomogeneous_C (fun _ : SiteVariable N D => (1 : ℕ))
      (edgeMatrix W z t)).mul
      (MvPolynomial.isWeightedHomogeneous_X R (fun _ : SiteVariable N D => (1 : ℕ)) z)).mul
      (MvPolynomial.isWeightedHomogeneous_X R (fun _ : SiteVariable N D => (1 : ℕ)) t)

omit [CharZero R] in

theorem matchingPolynomialN_totalHomogeneous (W : WeightsN N D R) :
    MvPolynomial.IsWeightedHomogeneous (fun _ : SiteVariable N D => (1 : ℕ))
      (matchingPolynomialN W) N := by
  intro m hm
  rw [weight_one_eq_exponentDegree]
  unfold exponentDegree siteDegree
  have hs := matchingPolynomialN_siteHomogeneous W hm
  have hv (v : V N) : (∑ i : Fin D, m (v, i)) = 1 := by
    rw [← siteWeight_apply, hs, siteProfile_nodup _ (vertices_nodup N)]
    simp
  simp_rw [hv]
  simp

theorem project_sourceQuadratic_pow_full (k : ℕ) (W : WeightsN (2 * k) D R) :
    project (sourceQuadratic W ^ k) =
      project (MvPolynomial.C (k.factorial : R) * matchingPolynomialN W) := by
  apply project_eq_of_full_coefficients
  · simpa [nsmul_eq_mul, Nat.mul_comm] using (sourceQuadratic_totalHomogeneous W).pow k
  · exact (matchingPolynomialN_totalHomogeneous W).C_mul _
  · intro ι
    rw [coeff_sourceQuadratic_pow_full, MvPolynomial.coeff_C_mul,
      coeff_matchingPolynomialN]

theorem project_dividedSourcePower_full (k : ℕ) (W : WeightsN (2 * k) D R) :
    project (dividedSourcePower W k) = project (matchingPolynomialN W) := by
  apply project_eq_of_full_coefficients
  · unfold dividedSourcePower
    simpa [nsmul_eq_mul, Nat.mul_comm] using
      ((sourceQuadratic_totalHomogeneous W).pow k).C_mul ((k.factorial : R)⁻¹)
  · exact matchingPolynomialN_totalHomogeneous W
  · intro ι
    rw [coeff_dividedSourcePower_full, coeff_matchingPolynomialN]

theorem siteCoefficient_dividedSourcePower (k : ℕ)
    (W : WeightsN (2 * k) D R) (ι : V (2 * k) → Fin D) :
    siteCoefficient ι (project (dividedSourcePower W k)) = pmSumN (2 * k) D W ι := by
  rw [siteCoefficient_project, coeff_dividedSourcePower_full]

end DividedPhysicalCoefficients

end Krenn.SiteAlgebra

-- formal/all-orders/RootResponse.lean

namespace Krenn.RootResponse

open scoped BigOperators
open MatchingModel SiteAlgebra

variable {R : Type*} {N D : ℕ}

section Ring

variable [CommRing R]

noncomputable def eraseSite (p : V N) :
    MatchingPolynomial N D R →+* MatchingPolynomial N D R :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    (fun z => if z.1 = p then 0 else MvPolynomial.X z)

@[simp]
theorem eraseSite_C (p : V N) (a : R) :
    eraseSite (D := D) p (MvPolynomial.C a) = MvPolynomial.C a := by
  simp [eraseSite]

@[simp]
theorem eraseSite_X (p : V N) (z : SiteVariable N D) :
    eraseSite (R := R) p (MvPolynomial.X z) =
      if z.1 = p then 0 else MvPolynomial.X z := by
  simp [eraseSite]

noncomputable def rootExtract (p : V N) (i : Fin D)
    (P : MatchingPolynomial N D R) : MatchingPolynomial N D R :=
  eraseSite p (MvPolynomial.pderiv (p, i) P)

@[simp]
theorem rootExtract_add (p : V N) (i : Fin D) (P Q : MatchingPolynomial N D R) :
    rootExtract p i (P + Q) = rootExtract p i P + rootExtract p i Q := by
  simp [rootExtract]

@[simp]
theorem rootExtract_C (p : V N) (i : Fin D) (a : R) :
    rootExtract p i (MvPolynomial.C a) = 0 := by simp [rootExtract]

theorem rootExtract_mul (p : V N) (i : Fin D) (P Q : MatchingPolynomial N D R) :
    rootExtract p i (P * Q) =
      rootExtract p i P * eraseSite p Q + eraseSite p P * rootExtract p i Q := by
  simp only [rootExtract, MvPolynomial.pderiv_mul, map_add, map_mul]

theorem eraseSite_mem_siteIdeal (p : V N) (P : MatchingPolynomial N D R)
    (hP : P ∈ siteIdeal N D R) : eraseSite p P ∈ siteIdeal N D R := by
  classical
  induction hP using Submodule.span_induction with
  | mem P hP =>
    rcases hP with ⟨v, i, j, rfl⟩
    by_cases hv : v = p
    · simp [hv]
    · simp only [map_mul, eraseSite_X, if_neg hv]
      exact Ideal.subset_span ⟨v, i, j, rfl⟩
  | zero => simp
  | add P Q _ _ ih ih' =>
    rw [map_add]
    exact (siteIdeal N D R).add_mem ih ih'
  | smul A P _ ih =>
    rw [smul_eq_mul, map_mul]
    exact (siteIdeal N D R).mul_mem_left _ ih

theorem rootExtract_mem_siteIdeal (p : V N) (i : Fin D)
    (P : MatchingPolynomial N D R) (hP : P ∈ siteIdeal N D R) :
    rootExtract p i P ∈ siteIdeal N D R := by
  classical
  induction hP using Submodule.span_induction with
  | mem P hP =>
    rcases hP with ⟨v, a, b, rfl⟩
    by_cases hv : v = p
    · simp [rootExtract, hv]
    · have hpa : (p, i) ≠ (v, a) := by
        intro h
        exact hv (congrArg Prod.fst h).symm
      have hpb : (p, i) ≠ (v, b) := by
        intro h
        exact hv (congrArg Prod.fst h).symm
      simp [rootExtract, hpa, hpb]
  | zero => simp [rootExtract]
  | add P Q _ _ ih ih' =>
    rw [rootExtract_add]
    exact (siteIdeal N D R).add_mem ih ih'
  | smul A P hP ih =>
    rw [smul_eq_mul, rootExtract_mul]
    exact (siteIdeal N D R).add_mem
      ((siteIdeal N D R).mul_mem_left _ (eraseSite_mem_siteIdeal p P hP))
      ((siteIdeal N D R).mul_mem_left _ ih)

theorem project_rootExtract_eq (p : V N) (i : Fin D)
    (P Q : MatchingPolynomial N D R) (h : project P = project Q) :
    project (rootExtract p i P) = project (rootExtract p i Q) := by
  have hmem : P - Q ∈ siteIdeal N D R :=
    (Ideal.Quotient.mk_eq_mk_iff_sub_mem P Q).mp h
  have hroot := rootExtract_mem_siteIdeal p i (P - Q) hmem
  apply (Ideal.Quotient.mk_eq_mk_iff_sub_mem _ _).mpr
  simpa [rootExtract] using hroot

end Ring

section Field

variable [Field R] [CharZero R]

omit [CharZero R] in

theorem eraseSite_rowPolynomial (W : WeightsN N D R) (p : V N) (i : Fin D) :
    eraseSite p (rowPolynomial (edgeMatrix W) (p, i)) =
      rowPolynomial (edgeMatrix W) (p, i) := by
  classical
  unfold rowPolynomial
  rw [map_sum]
  apply Finset.sum_congr rfl
  intro z _
  rw [map_mul, eraseSite_C, eraseSite_X]
  rcases z with ⟨v, j⟩
  by_cases hv : v = p
  · subst v
    simp
  · simp [hv]

noncomputable def deletedQuadratic (W : WeightsN N D R) (p : V N) :
    MatchingPolynomial N D R := eraseSite p (sourceQuadratic W)

noncomputable def quadraticRootResponse (W : WeightsN N D R)
    (p : V N) (i : Fin D) (k : ℕ) : MatchingPolynomial N D R :=
  MvPolynomial.C ((k.factorial : R)⁻¹) *
    rowPolynomial (edgeMatrix W) (p, i) * deletedQuadratic W p ^ k

theorem rootExtract_dividedSourcePower (W : WeightsN N D R)
    (p : V N) (i : Fin D) (k : ℕ) :
    rootExtract p i (dividedSourcePower W (k + 1)) =
      quadraticRootResponse W p i k := by
  unfold rootExtract dividedSourcePower
  rw [MvPolynomial.pderiv_C_mul, MvPolynomial.pderiv_pow, pderiv_sourceQuadratic]
  simp only [Nat.add_sub_cancel, map_mul, map_pow, eraseSite_C, eraseSite_rowPolynomial]
  have hcast : eraseSite (D := D) p (↑(k + 1) : MatchingPolynomial N D R) =
      MvPolynomial.C (k + 1 : R) := by simp
  rw [hcast]
  have hk : (k + 1 : R) ≠ 0 := by exact_mod_cast Nat.succ_ne_zero k
  have hfactor : ((k + 1).factorial : R)⁻¹ * (k + 1 : R) = (k.factorial : R)⁻¹ := by
    rw [Nat.factorial_succ, Nat.cast_mul, mul_inv_rev]
    simp only [Nat.cast_add, Nat.cast_one]
    rw [mul_assoc, inv_mul_cancel₀ hk, mul_one]
  unfold quadraticRootResponse deletedQuadratic
  have hC : (MvPolynomial.C (((k + 1).factorial : R)⁻¹) *
      MvPolynomial.C (k + 1 : R) : MatchingPolynomial N D R) =
      MvPolynomial.C ((k.factorial : R)⁻¹) := by rw [← map_mul, hfactor]
  calc
    _ = (MvPolynomial.C (((k + 1).factorial : R)⁻¹) * MvPolynomial.C (k + 1 : R)) *
        (rowPolynomial (edgeMatrix W) (p, i) * eraseSite p (sourceQuadratic W) ^ k) := by ring
    _ = _ := by rw [hC]; ring

theorem project_rootExtract_matchingPolynomial (k : ℕ)
    (W : WeightsN (2 * (k + 1)) D R) (p : V (2 * (k + 1))) (i : Fin D) :
    project (rootExtract p i (matchingPolynomialN W)) =
      project (quadraticRootResponse W p i k) := by
  have h := project_rootExtract_eq p i _ _ (project_dividedSourcePower_full (k + 1) W)
  rw [rootExtract_dividedSourcePower] at h
  exact h.symm

theorem pmSumN_rootExpansion (k : ℕ) (W : WeightsN (2 * (k + 1)) D R)
    (ι : V (2 * (k + 1)) → Fin D) (p : V (2 * (k + 1))) :
    pmSumN (2 * (k + 1)) D W ι =
      (((vertices (2 * (k + 1))).erase p).map fun q =>
        edgeMatrix W (p, ι p) (q, ι q) *
          pmSumList W ι (((vertices (2 * (k + 1))).erase p).erase q)).sum := by
  let L := (vertices (2 * (k + 1))).erase p
  have hnodup : L.Nodup := (vertices_nodup _).erase p
  have hp : p ∉ L := (vertices_nodup _).not_mem_erase
  have hlen : L.length = 2 * k + 1 := by
    dsimp [L]
    rw [List.length_erase_of_mem (mem_vertices p)]
    simp
    omega
  have hex : wordExponent ι (p :: L) = wordExponent ι (vertices (2 * (k + 1))) := by
    exact (wordExponent_erase ι _ p (mem_vertices p)).symm
  have hrec := coeff_sourceQuadratic_pow_succ W ι k p L hp hnodup
  rw [hex, coeff_sourceQuadratic_pow_full] at hrec
  have hterm : (L.map fun q => edgeMatrix W (p, ι p) (q, ι q) *
      MvPolynomial.coeff (wordExponent ι (L.erase q)) (sourceQuadratic W ^ k)).sum =
      (k.factorial : R) * (L.map fun q => edgeMatrix W (p, ι p) (q, ι q) *
        pmSumList W ι (L.erase q)).sum := by
    rw [← List.sum_map_mul_left]
    congr 1
    apply List.map_congr_left
    intro q hq
    have hlq : (L.erase q).length = 2 * k := by
      rw [List.length_erase_of_mem hq, hlen]
      omega
    rw [coeff_sourceQuadratic_pow W ι k (L.erase q) hlq
      (List.Pairwise.erase q (List.Pairwise.erase p (vertices_pairwise_lt _)))]
    rw [pmSumList, hlq]
    ring
  rw [hterm] at hrec
  have hfac : ((k + 1).factorial : R) = (k + 1 : R) * (k.factorial : R) := by
    rw [Nat.factorial_succ, Nat.cast_mul, Nat.cast_add, Nat.cast_one]
  have hf : ((k + 1).factorial : R) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero _)
  apply mul_left_cancel₀ hf
  calc
    _ = (k + 1 : R) * ((k.factorial : R) *
      (L.map fun q => edgeMatrix W (p, ι p) (q, ι q) * pmSumList W ι (L.erase q)).sum) := hrec
    _ = _ := by rw [hfac]; ring

noncomputable def pureCofactor (W : WeightsN N D R) (h : Fin D) (p q : V N) : R :=
  if p = q then 0 else pmSumList W (fun _ => h) (((vertices N).erase p).erase q)

omit [CharZero R] in
@[simp]
theorem pureCofactor_self (W : WeightsN N D R) (h : Fin D) (p : V N) :
    pureCofactor W h p p = 0 := by simp [pureCofactor]

omit [CharZero R] in
theorem pureCofactor_symm (W : WeightsN N D R) (h : Fin D) (p q : V N) :
    pureCofactor W h p q = pureCofactor W h q p := by
  simp only [pureCofactor]
  by_cases hpq : p = q
  · simp [hpq]
  · rw [if_neg hpq, if_neg (Ne.symm hpq), List.erase_comm]

theorem pureCofactor_rowSum_eq_one (k : ℕ) (W : WeightsN (2 * (k + 1)) D R)
    (hW : EqSystemN (2 * (k + 1)) D W) (p : V (2 * (k + 1))) (h : Fin D) :
    ∑ q : V (2 * (k + 1)), edgeMatrix W (p, h) (q, h) * pureCofactor W h p q = 1 := by
  classical
  have htarget : pmSumN (2 * (k + 1)) D W (fun _ => h) = 1 := by
    rw [hW]
    have hc : ∀ L : List (V (2 * (k + 1))), List.IsChain (fun _ _ => True) L := by
      intro L
      induction L with
      | nil => simp
      | cons v L ih => exact List.isChain_cons.mpr ⟨fun _ _ => True.intro, ih⟩
    simp only [allEqual, allEqualList, hc, if_true]
  rw [pmSumN_rootExpansion k W (fun _ => h) p] at htarget
  let L := (vertices (2 * (k + 1))).erase p
  have hL : L.Nodup := (vertices_nodup _).erase p
  have heq : (L.map fun q => edgeMatrix W (p, h) (q, h) *
      pmSumList W (fun _ => h) (L.erase q)).sum =
      ∑ q : V (2 * (k + 1)), edgeMatrix W (p, h) (q, h) * pureCofactor W h p q := by
    rw [← List.sum_toFinset _ hL]
    calc
      _ = ∑ q ∈ L.toFinset, edgeMatrix W (p, h) (q, h) * pureCofactor W h p q := by
        apply Finset.sum_congr rfl
        intro q hq
        have hqp : q ≠ p := by
          intro hqp
          subst q
          exact (vertices_nodup _).not_mem_erase (List.mem_toFinset.mp hq)
        rw [pureCofactor, if_neg (Ne.symm hqp)]
      _ = _ := by
        apply Finset.sum_subset (Finset.subset_univ _)
        intro q _ hq
        have hqp : q = p := by
          by_contra hh
          exact hq (List.mem_toFinset.mpr ((List.mem_erase_of_ne hh).mpr (mem_vertices q)))
        subst q
        simp
  rw [← heq]
  exact htarget

end Field

section SourceTensor

variable [Field R] [CharZero R]

theorem allEqual_constant (h : Fin D) : allEqual (fun _ : V N => h) := by
  have hc : ∀ L : List (V N), List.IsChain (fun _ _ => True) L := by
    intro L
    induction L with
    | nil => simp
    | cons v L ih => exact List.isChain_cons.mpr ⟨fun _ _ => True.intro, ih⟩
  simpa only [allEqual, allEqualList] using hc (vertices N)

private theorem colour_pairwise_rel (ι : V N → Fin D) (L : List (V N))
    (hL : L.Pairwise (fun v u => ι v = ι u)) :
    ∀ v ∈ L, ∀ u ∈ L, ι v = ι u := by
  induction L with
  | nil => simp
  | cons a L ih =>
    rcases List.pairwise_cons.mp hL with ⟨hhead, htail⟩
    intro v hv u hu
    rcases List.mem_cons.mp hv with hva | hvL
    · rcases List.mem_cons.mp hu with hua | huL
      · rw [hva, hua]
      · rw [hva]
        exact hhead u huL
    · rcases List.mem_cons.mp hu with hua | huL
      · rw [hua]
        exact (hhead v hvL).symm
      · exact ih htail v hvL u huL

theorem allEqual_iff_constant_at (ι : V N → Fin D) (p : V N) :
    allEqual ι ↔ ι = fun _ => ι p := by
  constructor
  · intro h
    have : Trans (fun v u : V N => ι v = ι u)
        (fun v u : V N => ι v = ι u) (fun v u : V N => ι v = ι u) :=
      ⟨fun h₁ h₂ => h₁.trans h₂⟩
    have hp := (show List.IsChain (fun v u => ι v = ι u) (vertices N) from h).pairwise
    funext v
    exact colour_pairwise_rel ι _ hp v (mem_vertices v) p (mem_vertices p)
  · intro h
    rw [h]
    exact allEqual_constant _

theorem wordExponent_full_injective :
    Function.Injective (fun ι : V N → Fin D => wordExponent ι (vertices N)) := by
  intro ι ν heq
  change wordExponent ι (vertices N) = wordExponent ν (vertices N) at heq
  funext v
  by_contra hv
  have hown : wordExponent ι (vertices N) (v, ι v) = 1 := by
    rw [wordExponent_selected, (vertices_nodup N).count]
    simp
  have hzero := wordExponent_wrong_color ν (vertices N) v (ι v) hv
  rw [heq, hzero] at hown
  norm_num at hown

noncomputable def diagonalPolynomial (N D : ℕ) : MatchingPolynomial N D R :=
  ∑ h : Fin D, MvPolynomial.monomial (wordExponent (fun _ => h) (vertices N)) 1

omit [CharZero R] in
theorem coeff_diagonalPolynomial (ι : V N → Fin D) (p : V N) :
    MvPolynomial.coeff (wordExponent ι (vertices N)) (diagonalPolynomial (R := R) N D) =
      if allEqual ι then 1 else 0 := by
  classical
  unfold diagonalPolynomial
  rw [MvPolynomial.coeff_sum]
  by_cases hι : allEqual ι
  · rw [if_pos hι]
    have hc := (allEqual_iff_constant_at ι p).mp hι
    rw [Finset.sum_eq_single (ι p)]
    · rw [← hc]
      simp
    · intro h _ hh
      have hex : wordExponent (fun _ : V N => h) (vertices N) ≠ wordExponent ι (vertices N) := by
        intro heq
        have heq' := wordExponent_full_injective heq
        exact hh (congrFun heq' p)
      simp only [MvPolynomial.coeff_monomial, if_neg hex]
    · simp
  · rw [if_neg hι]
    apply Finset.sum_eq_zero
    intro h _
    have hex : wordExponent (fun _ : V N => h) (vertices N) ≠ wordExponent ι (vertices N) := by
      intro heq
      have heq' := wordExponent_full_injective heq
      apply hι
      rw [← heq']
      exact allEqual_constant h
    simp only [MvPolynomial.coeff_monomial, if_neg hex]

theorem wordExponent_full_degree (ι : V N → Fin D) :
    exponentDegree (wordExponent ι (vertices N)) = N := by
  classical
  unfold exponentDegree siteDegree
  have hsite (v : V N) : (∑ i : Fin D, wordExponent ι (vertices N) (v, i)) = 1 := by
    rw [Finset.sum_eq_single (ι v)]
    · rw [wordExponent_selected, (vertices_nodup N).count]
      simp
    · intro i _ hi
      exact wordExponent_wrong_color ι _ v i hi
    · simp
  simp_rw [hsite]
  simp

omit [CharZero R] in
theorem diagonalPolynomial_totalHomogeneous :
    MvPolynomial.IsWeightedHomogeneous (fun _ : SiteVariable N D => (1 : ℕ))
      (diagonalPolynomial (R := R) N D) N := by
  classical
  unfold diagonalPolynomial
  apply MvPolynomial.IsWeightedHomogeneous.sum
  intro h _
  apply MvPolynomial.isWeightedHomogeneous_monomial
  rw [weight_one_eq_exponentDegree, wordExponent_full_degree]

omit [CharZero R] in

theorem project_matchingPolynomial_eq_diagonal (W : WeightsN N D R)
    (hW : EqSystemN N D W) (p : V N) :
    project (matchingPolynomialN W) = project (diagonalPolynomial (R := R) N D) := by
  apply project_eq_of_full_coefficients _ _ (matchingPolynomialN_totalHomogeneous W)
    diagonalPolynomial_totalHomogeneous
  intro ι
  rw [coeff_matchingPolynomialN, coeff_diagonalPolynomial ι p]
  exact hW ι

omit [CharZero R] in

theorem eraseSite_wordMonomial (p : V N) (ι : V N → Fin D) (L : List (V N))
    (hp : p ∉ L) :
    eraseSite p (MvPolynomial.monomial (wordExponent ι L) (1 : R)) =
      MvPolynomial.monomial (wordExponent ι L) 1 := by
  induction L with
  | nil => simp [wordExponent, MvPolynomial.monomial_eq]
  | cons v L ih =>
    have hvp : v ≠ p := by
      intro h
      subst v
      exact hp (by simp)
    have hpL : p ∉ L := by
      intro h
      exact hp (List.mem_cons_of_mem v h)
    have heq : (MvPolynomial.monomial (wordExponent ι (v :: L)) (1 : R)) =
        MvPolynomial.monomial (wordExponent ι L) 1 * MvPolynomial.X (v, ι v) := by
      rw [wordExponent, add_comm, MvPolynomial.monomial_add_single, pow_one]
    rw [heq, map_mul, eraseSite_X, if_neg hvp, ih hpL]

noncomputable def pureRootWord (p : V N) (h : Fin D) : MatchingPolynomial N D R :=
  MvPolynomial.monomial (wordExponent (fun _ => h) ((vertices N).erase p)) 1

omit [CharZero R] in
theorem rootExtract_pureWord (p : V N) (i h : Fin D) :
    rootExtract p i (MvPolynomial.monomial (wordExponent (fun _ : V N => h) (vertices N)) (1 : R)) =
      if i = h then pureRootWord p h else 0 := by
  classical
  unfold rootExtract
  rw [MvPolynomial.pderiv_monomial]
  by_cases hi : i = h
  · subst i
    rw [if_pos rfl, wordExponent_selected, (vertices_nodup N).count]
    simp only [mem_vertices, if_true, Nat.cast_one, mul_one]
    rw [wordExponent_erase (fun _ => h) (vertices N) p (mem_vertices p),
      add_tsub_cancel_left]
    exact eraseSite_wordMonomial p _ _ (vertices_nodup N).not_mem_erase
  · rw [if_neg hi, wordExponent_wrong_color (fun _ => h) (vertices N) p i hi]
    simp

omit [CharZero R] in
theorem rootExtract_diagonalPolynomial (p : V N) (i : Fin D) :
    rootExtract p i (diagonalPolynomial (R := R) N D) = pureRootWord p i := by
  classical
  unfold diagonalPolynomial rootExtract
  simp only [map_sum]
  change (∑ h : Fin D, rootExtract p i
    (MvPolynomial.monomial (wordExponent (fun _ => h) (vertices N)) (1 : R))) = _
  simp_rw [rootExtract_pureWord]
  simp

theorem quadraticRootResponse_eq_pure (k : ℕ) (W : WeightsN (2 * (k + 1)) D R)
    (hW : EqSystemN (2 * (k + 1)) D W) (p : V (2 * (k + 1))) (i : Fin D) :
    project (quadraticRootResponse W p i k) = project (pureRootWord p i) := by
  rw [← project_rootExtract_matchingPolynomial]
  have h := project_rootExtract_eq p i _ _ (project_matchingPolynomial_eq_diagonal W hW p)
  rw [rootExtract_diagonalPolynomial] at h
  exact h

noncomputable def rootFamilyRow (W : WeightsN N D R) (p : V N)
    (a : Fin D → MatchingPolynomial N D R) : MatchingPolynomial N D R :=
  ∑ i : Fin D, a i * rowPolynomial (edgeMatrix W) (p, i)

theorem rootFamily_response_eq_pure (k : ℕ) (W : WeightsN (2 * (k + 1)) D R)
    (hW : EqSystemN (2 * (k + 1)) D W) (p : V (2 * (k + 1)))
    (a : Fin D → MatchingPolynomial (2 * (k + 1)) D R) :
    project (MvPolynomial.C ((k.factorial : R)⁻¹) *
        rootFamilyRow W p a * deletedQuadratic W p ^ k) =
      ∑ i : Fin D, project (a i) * project (pureRootWord p i) := by
  classical
  have hpoly : MvPolynomial.C ((k.factorial : R)⁻¹) * rootFamilyRow W p a *
      deletedQuadratic W p ^ k = ∑ i : Fin D, a i * quadraticRootResponse W p i k := by
    unfold rootFamilyRow quadraticRootResponse
    simp only [Finset.mul_sum, Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro i _
    ring
  rw [hpoly, map_sum]
  apply Finset.sum_congr rfl
  intro i _
  rw [map_mul, quadraticRootResponse_eq_pure k W hW p i]

end SourceTensor

end Krenn.RootResponse

-- formal/all-orders/ThreeMatching.lean

/-
Copyright (c) 2026 Rishi. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

namespace Krenn.ThreeMatching

open scoped Classical

variable {V C : Type*}

structure Matching (V : Type*) where
  partner : V → V
  partner_partner : ∀ v, partner (partner v) = v
  partner_ne_self : ∀ v, partner v ≠ v

namespace Matching

theorem ext {M L : Matching V} (h : M.partner = L.partner) : M = L := by
  cases M
  cases L
  cases h
  rfl

theorem partner_injective (M : Matching V) : Function.Injective M.partner :=
  Function.Involutive.injective M.partner_partner

def toGraph (M : Matching V) : SimpleGraph V where
  Adj v w := M.partner v = w
  symm := ⟨fun v w h => by rw [← h, M.partner_partner]⟩
  loopless := ⟨M.partner_ne_self⟩

@[simp]
theorem toGraph_adj (M : Matching V) (v w : V) :
    M.toGraph.Adj v w ↔ M.partner v = w := Iff.rfl

def toSubgraph (M : Matching V) (G : SimpleGraph V)
    (hG : ∀ v, G.Adj v (M.partner v)) : G.Subgraph where
  verts := Set.univ
  Adj v w := M.partner v = w
  adj_sub := by
    intro v w h
    simpa only [h] using hG v
  edge_vert := fun _ => Set.mem_univ _
  symm := ⟨fun v w h => by rw [← h, M.partner_partner]⟩

theorem toSubgraph_isPerfectMatching (M : Matching V) (G : SimpleGraph V)
    (hG : ∀ v, G.Adj v (M.partner v)) :
    (M.toSubgraph G hG).IsPerfectMatching := by
  rw [SimpleGraph.Subgraph.isPerfectMatching_iff]
  intro v
  exact ⟨M.partner v, rfl, fun w h => (show M.partner v = w from h).symm⟩

theorem even_card [Fintype V] (M : Matching V) : Even (Fintype.card V) :=
  (M.toSubgraph_isPerfectMatching M.toGraph (fun _ => rfl)).even_card

noncomputable def ofSubgraph {G : SimpleGraph V} (M : G.Subgraph)
    (hM : M.IsPerfectMatching) : Matching V where
  partner v := (SimpleGraph.Subgraph.isPerfectMatching_iff.mp hM v).choose
  partner_partner v := by
    let h := SimpleGraph.Subgraph.isPerfectMatching_iff.mp hM
    exact ((h ((h v).choose)).choose_spec.2 v (h v).choose_spec.1.symm).symm
  partner_ne_self v := by
    intro heq
    have hadj := (SimpleGraph.Subgraph.isPerfectMatching_iff.mp hM v).choose_spec.1
    rw [heq] at hadj
    exact G.irrefl (M.adj_sub hadj)

theorem ofSubgraph_partner_adj {G : SimpleGraph V} (M : G.Subgraph)
    (hM : M.IsPerfectMatching) (v : V) :
    M.Adj v ((ofSubgraph M hM).partner v) :=
  (SimpleGraph.Subgraph.isPerfectMatching_iff.mp hM v).choose_spec.1

theorem ofSubgraph_partner_eq_iff {G : SimpleGraph V} (M : G.Subgraph)
    (hM : M.IsPerfectMatching) (v w : V) :
    (ofSubgraph M hM).partner v = w ↔ M.Adj v w := by
  constructor
  · intro h
    simpa only [h] using ofSubgraph_partner_adj M hM v
  · intro h
    exact ((SimpleGraph.Subgraph.isPerfectMatching_iff.mp hM v).choose_spec.2 w h).symm

def Closed (M : Matching V) (S : Set V) : Prop :=
  ∀ ⦃v⦄, v ∈ S → M.partner v ∈ S

theorem Closed.partner_mem_iff {M : Matching V} {S : Set V} (hS : M.Closed S)
    (v : V) : M.partner v ∈ S ↔ v ∈ S := by
  constructor
  · intro hv
    simpa only [M.partner_partner] using hS hv
  · exact fun hv => hS hv

noncomputable def switch (F G : Matching V) (S : Set V)
    (hF : F.Closed S) (hG : G.Closed S) : Matching V := by
  classical
  exact {
    partner := fun v => if v ∈ S then F.partner v else G.partner v
    partner_partner := fun v => by
      by_cases hv : v ∈ S
      · simp only [if_pos hv, if_pos (hF hv), F.partner_partner]
      · have hgv : G.partner v ∉ S := fun h => hv ((hG.partner_mem_iff v).mp h)
        simp only [if_neg hv, if_neg hgv, G.partner_partner]
    partner_ne_self := fun v => by
      by_cases hv : v ∈ S
      · simpa only [if_pos hv] using F.partner_ne_self v
      · simpa only [if_neg hv] using G.partner_ne_self v }

theorem switch_partner (F G : Matching V) (S : Set V)
    (hF : F.Closed S) (hG : G.Closed S) (v : V) :
    (switch F G S hF hG).partner v = if v ∈ S then F.partner v else G.partner v := by
  classical
  rfl

theorem closed_pair (M : Matching V) (v : V) : M.Closed {v, M.partner v} := by
  intro w hw
  rcases hw with rfl | hw
  · exact Set.mem_insert_of_mem _ (Set.mem_singleton _)
  · rw [Set.mem_singleton_iff] at hw
    rw [hw, M.partner_partner]
    exact Set.mem_insert _ _

end Matching

def Realizes (colours : C → Matching V) (word : V → C) (M : Matching V) : Prop :=
  ∀ v, M.partner v = (colours (word v)).partner v ∧ word (M.partner v) = word v

def HasMixedMatching (colours : C → Matching V) : Prop :=
  ∃ (M : Matching V) (word : V → C), Realizes colours word M ∧
    ∃ v w, word v ≠ word w

theorem realizes_unique {colours : C → Matching V} {word : V → C}
    {M N : Matching V} (hM : Realizes colours word M) (hN : Realizes colours word N) :
    M = N := by
  apply Matching.ext
  funext v
  exact (hM v).1.trans (hN v).1.symm

theorem realizes_switch (colours : C → Matching V) (a b : C) (S : Set V)
    (ha : (colours a).Closed S) (hb : (colours b).Closed S) :
    Realizes colours (fun v => if v ∈ S then a else b)
      (Matching.switch (colours a) (colours b) S ha hb) := by
  classical
  intro v
  by_cases hv : v ∈ S
  · simp only [Matching.switch_partner, if_pos hv, if_pos (ha hv)]
    trivial
  · have hgv : (colours b).partner v ∉ S := fun h => hv ((hb.partner_mem_iff v).mp h)
    simp only [Matching.switch_partner, if_neg hv, if_neg hgv]
    trivial

theorem hasMixedMatching_of_closed_cut (colours : C → Matching V) {a b : C}
    (hab : a ≠ b) (S : Set V) (ha : (colours a).Closed S) (hb : (colours b).Closed S)
    (hin : S.Nonempty) (hout : Sᶜ.Nonempty) : HasMixedMatching colours := by
  classical
  refine ⟨Matching.switch (colours a) (colours b) S ha hb,
    fun v => if v ∈ S then a else b, realizes_switch colours a b S ha hb, ?_⟩
  obtain ⟨v, hv⟩ := hin
  obtain ⟨w, hw⟩ := hout
  refine ⟨v, w, ?_⟩
  simpa only [if_pos hv, if_neg hw] using hab

theorem hasMixedMatching_of_shared_edge (colours : C → Matching V) {a b : C}
    (hab : a ≠ b) {p q r : V}
    (ha : (colours a).partner p = q) (hb : (colours b).partner p = q)
    (hrp : r ≠ p) (hrq : r ≠ q) : HasMixedMatching colours := by
  have hca : (colours a).Closed ({p, q} : Set V) := by
    simpa only [ha] using (colours a).closed_pair p
  have hcb : (colours b).Closed ({p, q} : Set V) := by
    simpa only [hb] using (colours b).closed_pair p
  apply hasMixedMatching_of_closed_cut colours hab {p, q} hca hcb
  · exact ⟨p, Set.mem_insert _ _⟩
  · exact ⟨r, by simp only [Set.mem_compl_iff, Set.mem_insert_iff,
      Set.mem_singleton_iff, not_or]; exact ⟨hrp, hrq⟩⟩

def pairGraph (colours : C → Matching V) (a b : C) : SimpleGraph V :=
  (colours a).toGraph ⊔ (colours b).toGraph

theorem pairGraph_other_step (colours : C → Matching V) {a b : C} {v w z : V}
    (hfirst : (colours a).partner v = w) (hnext : (pairGraph colours a b).Adj w z)
    (hback : z ≠ v) : (colours b).partner w = z := by
  change (colours a).partner w = z ∨ (colours b).partner w = z at hnext
  rcases hnext with ha | hb
  · have hreturn : (colours a).partner w = v := by
      rw [← hfirst, (colours a).partner_partner]
    exact False.elim (hback (ha.symm.trans hreturn))
  · exact hb

theorem pairGraph_reachable_closed_left (colours : C → Matching V) (a b : C) (p : V) :
    (colours a).Closed {v | (pairGraph colours a b).Reachable p v} := by
  intro v hv
  exact hv.trans (SimpleGraph.Adj.reachable (show (pairGraph colours a b).Adj v
    ((colours a).partner v) from Or.inl rfl))

theorem pairGraph_reachable_closed_right (colours : C → Matching V) (a b : C) (p : V) :
    (colours b).Closed {v | (pairGraph colours a b).Reachable p v} := by
  intro v hv
  exact hv.trans (SimpleGraph.Adj.reachable (show (pairGraph colours a b).Adj v
    ((colours b).partner v) from Or.inr rfl))

theorem hasMixedMatching_of_not_reachable (colours : C → Matching V) {a b : C}
    (hab : a ≠ b) {p q : V} (hpq : ¬(pairGraph colours a b).Reachable p q) :
    HasMixedMatching colours := by
  apply hasMixedMatching_of_closed_cut colours hab
    {v | (pairGraph colours a b).Reachable p v}
    (pairGraph_reachable_closed_left colours a b p)
    (pairGraph_reachable_closed_right colours a b p)
  · exact ⟨p, SimpleGraph.Reachable.refl p⟩
  · exact ⟨q, hpq⟩

theorem pairGraph_preconnected_of_no_mixed (colours : C → Matching V) {a b : C}
    (hab : a ≠ b) (hno : ¬HasMixedMatching colours) :
    (pairGraph colours a b).Preconnected := by
  intro p q
  by_contra hpq
  exact hno (hasMixedMatching_of_not_reachable colours hab hpq)

theorem hasMixedMatching_of_shared_partner [Fintype V] (colours : C → Matching V)
    (hcard : 2 < Fintype.card V) {a b : C} (hab : a ≠ b) (p : V)
    (hshare : (colours a).partner p = (colours b).partner p) :
    HasMixedMatching colours := by
  classical
  have hex : ∃ r, r ≠ p ∧ r ≠ (colours a).partner p := by
    by_contra h
    have hsub : (Finset.univ : Finset V) ⊆ {p, (colours a).partner p} := by
      intro r _
      by_cases hrp : r = p
      · simp only [hrp, Finset.mem_insert, true_or]
      · have hrq : r = (colours a).partner p := by
          by_contra hrq
          exact h ⟨r, hrp, hrq⟩
        simp only [hrq, Finset.mem_insert, Finset.mem_singleton, or_true]
    have hle := Finset.card_le_card hsub
    rw [Finset.card_univ, Finset.card_pair ((colours a).partner_ne_self p).symm] at hle
    exact (Nat.not_le_of_lt hcard) hle
  obtain ⟨r, hrp, hrq⟩ := hex
  exact hasMixedMatching_of_shared_edge colours hab rfl hshare.symm hrp hrq

theorem colour_partner_injective_of_no_mixed [Fintype V] (colours : C → Matching V)
    (hcard : 2 < Fintype.card V) (hno : ¬HasMixedMatching colours) (p : V) :
    Function.Injective (fun a => (colours a).partner p) := by
  intro a b hshare
  by_contra hab
  exact hno (hasMixedMatching_of_shared_partner colours hcard hab p hshare)

theorem pairGraph_isCycles (colours : C → Matching V) {a b : C}
    (hdisjoint : ∀ v, (colours a).partner v ≠ (colours b).partner v) :
    (pairGraph colours a b).IsCycles := by
  intro v _
  have hs : (pairGraph colours a b).neighborSet v =
      {(colours a).partner v, (colours b).partner v} := by
    ext w
    simp only [SimpleGraph.mem_neighborSet, pairGraph, SimpleGraph.sup_adj,
      Matching.toGraph_adj, Set.mem_insert_iff, Set.mem_singleton_iff, eq_comm]
  rw [hs]
  exact Set.ncard_pair (hdisjoint v)

theorem exists_spanning_cycle_of_no_mixed [Fintype V] (colours : C → Matching V)
    (hcard : 2 < Fintype.card V) (hno : ¬HasMixedMatching colours) {a b : C}
    (hab : a ≠ b) (p : V) :
    ∃ walk : (pairGraph colours a b).Walk p p,
      walk.IsCycle ∧ ∀ v, v ∈ walk.support := by
  have hconnected := pairGraph_preconnected_of_no_mixed colours hab hno
  have hdisjoint : ∀ v, (colours a).partner v ≠ (colours b).partner v := by
    intro v h
    exact hab (colour_partner_injective_of_no_mixed colours hcard hno v h)
  have hcycles := pairGraph_isCycles colours hdisjoint
  let component := (pairGraph colours a b).connectedComponentMk p
  have hp : p ∈ component.supp := by
    rw [SimpleGraph.ConnectedComponent.mem_supp_iff]
  have hn : ((pairGraph colours a b).neighborSet p).Nonempty :=
    ⟨(colours a).partner p, Or.inl rfl⟩
  obtain ⟨walk, hcycle, hverts⟩ :=
    hcycles.exists_cycle_toSubgraph_verts_eq_connectedComponentSupp hp hn
  refine ⟨walk, hcycle, fun v => ?_⟩
  rw [← walk.mem_verts_toSubgraph, hverts,
    SimpleGraph.ConnectedComponent.mem_supp_iff,
    SimpleGraph.ConnectedComponent.eq]
  exact hconnected v p

end Krenn.ThreeMatching

-- formal/all-orders/ChordObstruction.lean

/-
Copyright (c) 2026 Rishi. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

namespace Krenn.ThreeMatching

open scoped Classical

namespace Chord

variable {n : ℕ}

theorem next_val (i : Fin (n + 2)) :
    (i + 1).val = if i.val + 1 < n + 2 then i.val + 1 else 0 := by
  rw [Fin.val_add_one]
  split_ifs with h h' h'
  · have hi := congrArg Fin.val h
    simp only [Fin.val_last] at hi
    omega
  · rfl
  · rfl
  · have hi : i = Fin.last (n + 1) := by
      apply Fin.ext
      simp only [Fin.val_last]
      omega
    exact False.elim (h hi)

theorem prev_val (i : Fin (n + 2)) :
    (i - 1).val = if i.val = 0 then n + 1 else i.val - 1 := by
  by_cases hi : i = 0
  · subst i
    simp
  · rw [Fin.val_sub_one_of_ne_zero hi, if_neg]
    exact fun h => hi (Fin.ext h)

theorem next_adj (i : Fin (n + 2)) :
    (SimpleGraph.cycleGraph (n + 2)).Adj i (i + 1) := by
  rw [← SimpleGraph.mem_neighborSet, SimpleGraph.cycleGraph_neighborSet]
  exact Set.mem_insert_of_mem _ (Set.mem_singleton _)

theorem prev_adj (i : Fin (n + 2)) :
    (SimpleGraph.cycleGraph (n + 2)).Adj i (i - 1) := by
  rw [← SimpleGraph.mem_neighborSet, SimpleGraph.cycleGraph_neighborSet]
  exact Set.mem_insert _ _

noncomputable def fill (H : Matching (Fin (n + 2))) (hole forward : Fin (n + 2) → Prop)
    (hclosed : ∀ i, hole i → hole (H.partner i))
    (hnext : ∀ i, ¬hole i → forward i → ¬hole (i + 1) ∧ ¬forward (i + 1))
    (hprev : ∀ i, ¬hole i → ¬forward i → ¬hole (i - 1) ∧ forward (i - 1)) :
    Matching (Fin (n + 2)) where
  partner i := if hole i then H.partner i else if forward i then i + 1 else i - 1
  partner_partner i := by
    by_cases hi : hole i
    · simp only [if_pos hi, if_pos (hclosed i hi), H.partner_partner]
    · by_cases hf : forward i
      · obtain ⟨hn, hnf⟩ := hnext i hi hf
        simp only [if_neg hi, if_pos hf, if_neg hn, if_neg hnf, add_sub_cancel_right]
      · obtain ⟨hp, hpf⟩ := hprev i hi hf
        simp only [if_neg hi, if_neg hf, if_neg hp, if_pos hpf, sub_add_cancel]
  partner_ne_self i := by
    by_cases hi : hole i
    · simpa only [if_pos hi] using H.partner_ne_self i
    · by_cases hf : forward i
      · simp only [if_neg hi, if_pos hf]
        intro h
        have ha := next_adj i
        rw [h] at ha
        exact (SimpleGraph.cycleGraph (n + 2)).irrefl ha
      · simp only [if_neg hi, if_neg hf]
        intro h
        have ha := prev_adj i
        rw [h] at ha
        exact (SimpleGraph.cycleGraph (n + 2)).irrefl ha

theorem fill_at_hole (H : Matching (Fin (n + 2))) (hole forward : Fin (n + 2) → Prop)
    (hclosed hnext hprev) {i : Fin (n + 2)} (hi : hole i) :
    (fill H hole forward hclosed hnext hprev).partner i = H.partner i := by
  simp only [fill, if_pos hi]

theorem fill_off_hole (H : Matching (Fin (n + 2))) (hole forward : Fin (n + 2) → Prop)
    (hclosed hnext hprev) {i : Fin (n + 2)} (hi : ¬hole i) :
    (SimpleGraph.cycleGraph (n + 2)).Adj i
      ((fill H hole forward hclosed hnext hprev).partner i) := by
  simp only [fill, if_neg hi]
  split_ifs
  · exact next_adj i
  · exact prev_adj i

def twoHoles (a b i : Fin (n + 2)) : Prop := i = a ∨ i = b

def twoForward (a b i : Fin (n + 2)) : Prop :=
  (i.val % 2 = a.val % 2) ↔ (i.val < a.val ∨ b.val < i.val)

theorem two_next {a b : Fin (n + 2)} (hab : a.val < b.val)
    (hparity : a.val % 2 ≠ b.val % 2) (heven : (n + 2) % 2 = 0)
    (i : Fin (n + 2)) (hi : ¬twoHoles a b i) (hf : twoForward a b i) :
    ¬twoHoles a b (i + 1) ∧ ¬twoForward a b (i + 1) := by
  simp only [twoHoles, twoForward, Fin.ext_iff] at hi hf ⊢
  rw [next_val]
  split_ifs <;> omega

theorem two_prev {a b : Fin (n + 2)} (hab : a.val < b.val)
    (hparity : a.val % 2 ≠ b.val % 2) (heven : (n + 2) % 2 = 0)
    (i : Fin (n + 2)) (hi : ¬twoHoles a b i) (hf : ¬twoForward a b i) :
    ¬twoHoles a b (i - 1) ∧ twoForward a b (i - 1) := by
  simp only [twoHoles, twoForward, Fin.ext_iff] at hi hf ⊢
  rw [prev_val]
  split_ifs <;> omega

theorem two_closed (H : Matching (Fin (n + 2))) {a b : Fin (n + 2)}
    (hab : H.partner a = b) (i : Fin (n + 2)) (hi : twoHoles a b i) :
    twoHoles a b (H.partner i) := by
  rcases hi with rfl | rfl
  · exact Or.inr hab
  · exact Or.inl (by rw [← hab, H.partner_partner])

noncomputable def fillTwo (H : Matching (Fin (n + 2))) {a b : Fin (n + 2)}
    (hab : a.val < b.val) (hH : H.partner a = b)
    (hparity : a.val % 2 ≠ b.val % 2) (heven : (n + 2) % 2 = 0) :
    Matching (Fin (n + 2)) :=
  fill H (twoHoles a b) (twoForward a b) (two_closed H hH)
    (two_next hab hparity heven) (two_prev hab hparity heven)

def fourHoles (a b c d i : Fin (n + 2)) : Prop := i = a ∨ i = b ∨ i = c ∨ i = d

def fourForward (a b c d i : Fin (n + 2)) : Prop :=
  (i.val % 2 = a.val % 2) ↔
    (i.val < a.val ∨ (b.val < i.val ∧ i.val < c.val) ∨ d.val < i.val)

theorem four_next {a b c d : Fin (n + 2)}
    (hab : a.val < b.val) (hbc : b.val < c.val) (hcd : c.val < d.val)
    (hac : a.val % 2 = c.val % 2) (hbd : b.val % 2 = d.val % 2)
    (hparity : a.val % 2 ≠ b.val % 2) (heven : (n + 2) % 2 = 0)
    (i : Fin (n + 2)) (hi : ¬fourHoles a b c d i) (hf : fourForward a b c d i) :
    ¬fourHoles a b c d (i + 1) ∧ ¬fourForward a b c d (i + 1) := by
  simp only [fourHoles, fourForward, Fin.ext_iff] at hi hf ⊢
  rw [next_val]
  split_ifs <;> omega

theorem four_prev {a b c d : Fin (n + 2)}
    (hab : a.val < b.val) (hbc : b.val < c.val) (hcd : c.val < d.val)
    (hac : a.val % 2 = c.val % 2) (hbd : b.val % 2 = d.val % 2)
    (hparity : a.val % 2 ≠ b.val % 2) (heven : (n + 2) % 2 = 0)
    (i : Fin (n + 2)) (hi : ¬fourHoles a b c d i) (hf : ¬fourForward a b c d i) :
    ¬fourHoles a b c d (i - 1) ∧ fourForward a b c d (i - 1) := by
  simp only [fourHoles, fourForward, Fin.ext_iff] at hi hf ⊢
  rw [prev_val]
  split_ifs <;> omega

theorem four_closed (H : Matching (Fin (n + 2))) {a b c d : Fin (n + 2)}
    (hac : H.partner a = c) (hbd : H.partner b = d)
    (i : Fin (n + 2)) (hi : fourHoles a b c d i) :
    fourHoles a b c d (H.partner i) := by
  rcases hi with rfl | rfl | rfl | rfl
  · exact Or.inr (Or.inr (Or.inl hac))
  · exact Or.inr (Or.inr (Or.inr hbd))
  · exact Or.inl (by rw [← hac, H.partner_partner])
  · exact Or.inr (Or.inl (by rw [← hbd, H.partner_partner]))

noncomputable def fillFour (H : Matching (Fin (n + 2))) {a b c d : Fin (n + 2)}
    (hab : a.val < b.val) (hbc : b.val < c.val) (hcd : c.val < d.val)
    (hHac : H.partner a = c) (hHbd : H.partner b = d)
    (hac : a.val % 2 = c.val % 2) (hbd : b.val % 2 = d.val % 2)
    (hparity : a.val % 2 ≠ b.val % 2) (heven : (n + 2) % 2 = 0) :
    Matching (Fin (n + 2)) :=
  fill H (fourHoles a b c d) (fourForward a b c d) (four_closed H hHac hHbd)
    (four_next hab hbc hcd hac hbd hparity heven)
    (four_prev hab hbc hcd hac hbd hparity heven)

theorem exists_interlacing_of_parity_preserving (H : Matching (Fin (n + 2)))
    (hparity : ∀ i, (H.partner i).val % 2 = i.val % 2) :
    ∃ a b c d : Fin (n + 2),
      a.val < b.val ∧ b.val < c.val ∧ c.val < d.val ∧
      H.partner a = c ∧ H.partner b = d ∧
      a.val % 2 = c.val % 2 ∧ b.val % 2 = d.val % 2 ∧ a.val % 2 ≠ b.val % 2 := by
  have hzero : 0 < (H.partner 0).val := by
    have hne := H.partner_ne_self 0
    have hv : (H.partner 0).val ≠ 0 := fun h => hne (Fin.ext h)
    omega
  have hex : ∃ k : ℕ, ∃ a b : Fin (n + 2),
      H.partner a = b ∧ a.val < b.val ∧ b.val - a.val = k :=
    ⟨(H.partner 0).val, 0, H.partner 0, rfl, hzero, Nat.sub_zero _⟩
  obtain ⟨a, b, hHab, hab, hgap⟩ := Nat.find_spec hex
  have hmin : ∀ i j : Fin (n + 2), H.partner i = j → i.val < j.val →
      Nat.find hex ≤ j.val - i.val := by
    intro i j hij hlt
    exact Nat.find_min' hex ⟨i, j, hij, hlt, rfl⟩
  have hbp : b.val % 2 = a.val % 2 := by simpa only [hHab] using hparity a
  let c : Fin (n + 2) := ⟨a.val + 1, by omega⟩
  let d := H.partner c
  have hcv : c.val = a.val + 1 := rfl
  have hac : a.val < c.val := by omega
  have hcb : c.val < b.val := by omega
  have hdp : d.val % 2 = c.val % 2 := hparity c
  have hHdc : H.partner d = c := H.partner_partner c
  have hdc : d ≠ c := H.partner_ne_self c
  have hout : d.val < a.val ∨ b.val < d.val := by
    by_contra hout
    have hinside : a.val < d.val ∧ d.val < b.val := by omega
    by_cases hcd : c.val < d.val
    · have hm := hmin c d rfl hcd
      omega
    · have hdc' : d.val < c.val := by
        have hneq : d.val ≠ c.val := fun h => hdc (Fin.ext h)
        omega
      have hm := hmin d c hHdc hdc'
      omega
  rcases hout with hda | hbd
  · refine ⟨d, a, c, b, hda, hac, hcb, hHdc, hHab, hdp, hbp.symm, ?_⟩
    omega
  · refine ⟨a, c, b, d, hac, hcb, hbd, hHab, rfl, hbp.symm, hdp.symm, ?_⟩
    omega

theorem exists_outside_four (hbig : 4 < n + 2) (a b c d : Fin (n + 2)) :
    ∃ i, ¬fourHoles a b c d i := by
  have hcard : ({a, b, c, d} : Finset (Fin (n + 2))).card <
      (Finset.univ : Finset (Fin (n + 2))).card := by
    have hle := (Finset.card_le_four : ({a, b, c, d} : Finset (Fin (n + 2))).card ≤ 4)
    simpa only [Finset.card_univ, Fintype.card_fin] using lt_of_le_of_lt hle hbig
  obtain ⟨i, _, hi⟩ := Finset.exists_mem_notMem_of_card_lt_card hcard
  exact ⟨i, by simpa only [fourHoles, Finset.mem_insert, Finset.mem_singleton] using hi⟩

theorem exists_hybrid_of_opposite_parity (H : Matching (Fin (n + 2)))
    (heven : (n + 2) % 2 = 0) (hbig : 4 < n + 2) {a b : Fin (n + 2)}
    (hab : a.val < b.val) (hH : H.partner a = b)
    (hparity : a.val % 2 ≠ b.val % 2) :
    ∃ M : Matching (Fin (n + 2)),
      (∀ i, M.partner i = H.partner i ∨
        (SimpleGraph.cycleGraph (n + 2)).Adj i (M.partner i)) ∧
      (∃ i, M.partner i = H.partner i) ∧
      (∃ i, (SimpleGraph.cycleGraph (n + 2)).Adj i (M.partner i)) := by
  let M := fillTwo H hab hH hparity heven
  have hhole (i) (hi : twoHoles a b i) : M.partner i = H.partner i :=
    fill_at_hole H _ _ _ _ _ hi
  have hout (i) (hi : ¬twoHoles a b i) :
      (SimpleGraph.cycleGraph (n + 2)).Adj i (M.partner i) :=
    fill_off_hole H _ _ _ _ _ hi
  refine ⟨M, ?_, ⟨a, hhole a (Or.inl rfl)⟩, ?_⟩
  · intro i
    by_cases hi : twoHoles a b i
    · exact Or.inl (hhole i hi)
    · exact Or.inr (hout i hi)
  · obtain ⟨i, hi⟩ := exists_outside_four hbig a b a b
    exact ⟨i, hout i (fun h => hi (h.elim Or.inl (fun hb => Or.inr (Or.inl hb))))⟩

theorem exists_hybrid_of_interlacing (H : Matching (Fin (n + 2)))
    (heven : (n + 2) % 2 = 0) (hbig : 4 < n + 2) {a b c d : Fin (n + 2)}
    (hab : a.val < b.val) (hbc : b.val < c.val) (hcd : c.val < d.val)
    (hHac : H.partner a = c) (hHbd : H.partner b = d)
    (hac : a.val % 2 = c.val % 2) (hbd : b.val % 2 = d.val % 2)
    (hparity : a.val % 2 ≠ b.val % 2) :
    ∃ M : Matching (Fin (n + 2)),
      (∀ i, M.partner i = H.partner i ∨
        (SimpleGraph.cycleGraph (n + 2)).Adj i (M.partner i)) ∧
      (∃ i, M.partner i = H.partner i) ∧
      (∃ i, (SimpleGraph.cycleGraph (n + 2)).Adj i (M.partner i)) := by
  let M := fillFour H hab hbc hcd hHac hHbd hac hbd hparity heven
  have hhole (i) (hi : fourHoles a b c d i) : M.partner i = H.partner i :=
    fill_at_hole H _ _ _ _ _ hi
  have hout (i) (hi : ¬fourHoles a b c d i) :
      (SimpleGraph.cycleGraph (n + 2)).Adj i (M.partner i) :=
    fill_off_hole H _ _ _ _ _ hi
  refine ⟨M, ?_, ⟨a, hhole a (Or.inl rfl)⟩, ?_⟩
  · intro i
    by_cases hi : fourHoles a b c d i
    · exact Or.inl (hhole i hi)
    · exact Or.inr (hout i hi)
  · obtain ⟨i, hi⟩ := exists_outside_four hbig a b c d
    exact ⟨i, hout i hi⟩

theorem exists_hybrid_matching (H : Matching (Fin (n + 2)))
    (heven : (n + 2) % 2 = 0) (hbig : 4 < n + 2) :
    ∃ M : Matching (Fin (n + 2)),
      (∀ i, M.partner i = H.partner i ∨
        (SimpleGraph.cycleGraph (n + 2)).Adj i (M.partner i)) ∧
      (∃ i, M.partner i = H.partner i) ∧
      (∃ i, (SimpleGraph.cycleGraph (n + 2)).Adj i (M.partner i)) := by
  by_cases hp : ∀ i, (H.partner i).val % 2 = i.val % 2
  · obtain ⟨a, b, c, d, hab, hbc, hcd, hHac, hHbd, hac, hbd, hparity⟩ :=
      exists_interlacing_of_parity_preserving H hp
    exact exists_hybrid_of_interlacing H heven hbig hab hbc hcd hHac hHbd hac hbd hparity
  · push Not at hp
    obtain ⟨a, hparity⟩ := hp
    let b := H.partner a
    have hne : a.val ≠ b.val := fun h => (H.partner_ne_self a) (Fin.ext h.symm)
    by_cases hab : a.val < b.val
    · exact exists_hybrid_of_opposite_parity H heven hbig hab rfl (Ne.symm hparity)
    · have hba : b.val < a.val := by omega
      exact exists_hybrid_of_opposite_parity H heven hbig hba
        (H.partner_partner a) hparity

end Chord

end Krenn.ThreeMatching

-- formal/all-orders/CycleCoordinates.lean

namespace Krenn.ThreeMatching

variable {V C : Type*} [Fintype V]

theorem exists_cycle_equiv_of_spanning {G : SimpleGraph V}
    (hcard : 2 < Fintype.card V) {p : V} (walk : G.Walk p p)
    (hcycle : walk.IsCycle) (hspan : ∀ v, v ∈ walk.support) :
    ∃ e : Fin (Fintype.card V) ≃ V, ∀ i j,
      (SimpleGraph.cycleGraph (Fintype.card V)).Adj i j → G.Adj (e i) (e j) := by
  classical
  have htail : walk.tail.IsHamiltonian := by
    apply hcycle.isPath_tail.isHamiltonian_of_mem
    intro v
    by_cases hv : v = p
    · subst v
      exact walk.tail.end_mem_support
    · have hmem := hspan v
      rw [← SimpleGraph.Walk.cons_support_tail hcycle.not_nil] at hmem
      exact (List.mem_cons.mp hmem).resolve_left hv
  have hh : walk.IsHamiltonianCycle := ⟨hcycle, htail⟩
  obtain ⟨copy⟩ := (SimpleGraph.cycleGraph_isContained_iff hcard).mpr
    ⟨p, walk, hcycle, hh.length_eq⟩
  have hbij : Function.Bijective copy := by
    exact ⟨copy.injective, copy.injective.surjective_of_finite
      (Fintype.equivFin V).symm⟩
  exact ⟨Equiv.ofBijective copy hbij, fun _ _ h => copy.toHom.map_rel h⟩

theorem exists_cycle_equiv_of_no_mixed (colours : C → Matching V)
    (hcard : 2 < Fintype.card V) (hno : ¬ HasMixedMatching colours)
    {a b : C} (hab : a ≠ b) (p : V) :
    ∃ e : Fin (Fintype.card V) ≃ V, ∀ i j,
      (SimpleGraph.cycleGraph (Fintype.card V)).Adj i j →
        (pairGraph colours a b).Adj (e i) (e j) := by
  obtain ⟨walk, hcycle, hspan⟩ := exists_spanning_cycle_of_no_mixed colours hcard hno hab p
  exact exists_cycle_equiv_of_spanning hcard walk hcycle hspan

end Krenn.ThreeMatching

-- formal/all-orders/MatchingTransport.lean

namespace Krenn.ThreeMatching

variable {V W C : Type*}

def Matching.map (M : Matching V) (e : V ≃ W) : Matching W where
  partner w := e (M.partner (e.symm w))
  partner_partner w := by simp only [Equiv.symm_apply_apply, M.partner_partner, Equiv.apply_symm_apply]
  partner_ne_self w := by
    intro h
    have : M.partner (e.symm w) = e.symm w := by simpa using congrArg e.symm h
    exact M.partner_ne_self _ this

@[simp] theorem Matching.map_partner (M : Matching V) (e : V ≃ W) (v : V) :
    (M.map e).partner (e v) = e (M.partner v) := by
  simp only [Matching.map, Equiv.symm_apply_apply]

theorem Realizes.map {colours : C → Matching V} {word : V → C} {M : Matching V}
    (h : Realizes colours word M) (e : V ≃ W) :
    Realizes (fun c => (colours c).map e) (word ∘ e.symm) (M.map e) := by
  intro w
  obtain ⟨v, rfl⟩ := e.surjective w
  simpa only [Function.comp_apply, Equiv.symm_apply_apply, Matching.map_partner] using
    And.intro (congrArg e (h v).1) (h v).2

theorem HasMixedMatching.map {colours : C → Matching V}
    (h : HasMixedMatching colours) (e : V ≃ W) :
    HasMixedMatching (fun c => (colours c).map e) := by
  obtain ⟨M, word, hreal, v, w, hne⟩ := h
  refine ⟨M.map e, word ∘ e.symm, hreal.map e, e v, e w, ?_⟩
  simpa only [Function.comp_apply, Equiv.symm_apply_apply] using hne

theorem exists_realizes_of_partner_cover (colours : C → Matching V) (M : Matching V)
    (hdisjoint : ∀ v, Function.Injective (fun c => (colours c).partner v))
    (hcover : ∀ v, ∃ c, M.partner v = (colours c).partner v) :
    ∃ word : V → C, Realizes colours word M := by
  classical
  choose word hword using hcover
  refine ⟨word, fun v => ⟨hword v, ?_⟩⟩
  apply hdisjoint (M.partner v)
  change (colours (word (M.partner v))).partner (M.partner v) =
    (colours (word v)).partner (M.partner v)
  rw [← hword (M.partner v), M.partner_partner]
  rw [hword v, (colours (word v)).partner_partner]

theorem hasMixedMatching_of_partner_cover (colours : C → Matching V) (M : Matching V)
    (hdisjoint : ∀ v, Function.Injective (fun c => (colours c).partner v))
    (hcover : ∀ v, ∃ c, M.partner v = (colours c).partner v)
    {a b : C} (hab : a ≠ b) {v w : V}
    (ha : M.partner v = (colours a).partner v)
    (hb : M.partner w = (colours b).partner w) :
    HasMixedMatching colours := by
  obtain ⟨word, hreal⟩ := exists_realizes_of_partner_cover colours M hdisjoint hcover
  have hva : word v = a := hdisjoint v ((hreal v).1.symm.trans ha)
  have hwb : word w = b := hdisjoint w ((hreal w).1.symm.trans hb)
  refine ⟨M, word, hreal, v, w, ?_⟩
  simpa only [hva, hwb] using hab

end Krenn.ThreeMatching

-- formal/all-orders/ThreeMatchingObstruction.lean

/-
Copyright (c) 2026 Rishi. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

namespace Krenn.ThreeMatching

variable {V C : Type*} [Fintype V]

theorem hasMixedMatching_of_three_colours (colours : C → Matching V)
    (hcard : 4 < Fintype.card V) {a b c : C}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    HasMixedMatching colours := by
  classical
  by_contra hno
  have htwo : 2 < Fintype.card V := by omega
  have hdisjoint := colour_partner_injective_of_no_mixed colours htwo hno
  obtain ⟨p⟩ := Fintype.card_pos_iff.mp (show 0 < Fintype.card V by omega)
  obtain ⟨n, hsize⟩ : ∃ n : ℕ, Fintype.card V = n + 2 :=
    ⟨Fintype.card V - 2, by omega⟩
  have heven : (n + 2) % 2 = 0 := by
    simpa only [hsize, Nat.even_iff] using (colours a).even_card
  have hbig : 4 < n + 2 := by omega
  obtain ⟨e, he⟩ : ∃ e : Fin (n + 2) ≃ V, ∀ i j,
      (SimpleGraph.cycleGraph (n + 2)).Adj i j →
        (pairGraph colours a b).Adj (e i) (e j) := by
    have hequiv := exists_cycle_equiv_of_no_mixed colours htwo hno hab p
    rw [hsize] at hequiv
    exact hequiv
  let H := (colours c).map e.symm
  obtain ⟨M, hcover, ⟨u, hu⟩, ⟨v, hv⟩⟩ :=
    Chord.exists_hybrid_matching H heven hbig
  let N := M.map e
  have hH (i : Fin (n + 2)) : e (H.partner i) = (colours c).partner (e i) := by
    simp only [H, Matching.map, Equiv.symm_symm, Equiv.apply_symm_apply]
  have hcoverN : ∀ w, ∃ k, N.partner w = (colours k).partner w := by
    intro w
    obtain ⟨i, rfl⟩ := e.surjective w
    change (∃ k, (M.map e).partner (e i) = (colours k).partner (e i))
    rw [Matching.map_partner]
    rcases hcover i with hi | hi
    · exact ⟨c, (congrArg e hi).trans (hH i)⟩
    · have hedge := he i (M.partner i) hi
      change (colours a).partner (e i) = e (M.partner i) ∨
        (colours b).partner (e i) = e (M.partner i) at hedge
      rcases hedge with ha | hb
      · exact ⟨a, ha.symm⟩
      · exact ⟨b, hb.symm⟩
  have hc : N.partner (e u) = (colours c).partner (e u) := by
    change (M.map e).partner (e u) = _
    rw [Matching.map_partner, hu, hH]
  have hedge := he v (M.partner v) hv
  change (colours a).partner (e v) = e (M.partner v) ∨
    (colours b).partner (e v) = e (M.partner v) at hedge
  rcases hedge with ha | hb
  · have hNa : N.partner (e v) = (colours a).partner (e v) := by
      exact (Matching.map_partner M e v).trans ha.symm
    exact hno (hasMixedMatching_of_partner_cover colours N hdisjoint hcoverN hac.symm hc hNa)
  · have hNb : N.partner (e v) = (colours b).partner (e v) := by
      exact (Matching.map_partner M e v).trans hb.symm
    exact hno (hasMixedMatching_of_partner_cover colours N hdisjoint hcoverN hbc.symm hc hNb)

theorem hasMixedMatching_three (colours : Fin 3 → Matching V)
    (hcard : 4 < Fintype.card V) : HasMixedMatching colours :=
  hasMixedMatching_of_three_colours colours hcard
    (a := 0) (b := 1) (c := 2) (by decide) (by decide) (by decide)

theorem colour_eq_of_no_mixed (colours : C → Matching V)
    (hcard : 4 < Fintype.card V) (hno : ¬HasMixedMatching colours)
    {a b : C} (hab : a ≠ b) (c : C) : c = a ∨ c = b := by
  by_contra h
  have hca : c ≠ a := fun hca => h (Or.inl hca)
  have hcb : c ≠ b := fun hcb => h (Or.inr hcb)
  exact hno (hasMixedMatching_of_three_colours colours hcard hab hca.symm hcb.symm)

end Krenn.ThreeMatching

-- formal/all-orders/ForcedMatchingSum.lean

namespace Krenn.ForcedMatchingSum

open MatchingModel ThreeMatching

variable {K : Type*} [CommRing K] [IsDomain K] {N D : ℕ}

private theorem closed_after_pair (M : Matching (Fin N)) (v : Fin N)
    (L : List (Fin N)) (hv : v ∉ L) (hn : L.Nodup)
    (hclosed : ∀ x ∈ v :: L, M.partner x ∈ v :: L) :
    ∀ x ∈ L.erase (M.partner v), M.partner x ∈ L.erase (M.partner v) := by
  intro x hx
  have hmem : x ∈ L ∧ x ≠ M.partner v := by
    simpa [hn.erase_eq_filter] using hx
  have hxv : x ≠ v := by intro h; exact hv (h ▸ hmem.1)
  have hpxv : M.partner x ≠ v := by
    intro h
    exact hmem.2 (M.partner_injective (h.trans (M.partner_partner v).symm))
  have hpxp : M.partner x ≠ M.partner v := fun h => hxv (M.partner_injective h)
  have hpL : M.partner x ∈ L :=
    (List.mem_cons.mp (hclosed x (List.mem_cons.mpr (Or.inr hmem.1)))).resolve_left hpxv
  simpa [hn.erase_eq_filter] using And.intro hpL hpxp

theorem pmSumListAux_ne_zero_of_forced (W : WeightsN N D K) (word : Fin N → Fin D)
    (M : Matching (Fin N))
    (hweight : ∀ v u, v < u →
      (W (mkEdge v u (word v) (word u)) ≠ 0 ↔ M.partner v = u)) :
    ∀ (n : ℕ) (L : List (Fin N)), L.length = n → L.Nodup →
      L.Pairwise (· < ·) → (∀ x ∈ L, M.partner x ∈ L) →
      pmSumListAux W word n L ≠ 0
  | 0, [], _, _, _, _ => by simp [pmSumListAux]
  | 0, _ :: _, hlen, _, _, _ => by simp at hlen
  | 1, [], hlen, _, _, _ => by simp at hlen
  | 1, [v], _, _, _, hclosed => by
    have h := hclosed v (by simp)
    simp only [List.mem_singleton] at h
    exact False.elim (M.partner_ne_self v h)
  | 1, _ :: _ :: _, hlen, _, _, _ => by simp at hlen
  | n + 2, [], hlen, _, _, _ => by simp at hlen
  | n + 2, [v], hlen, _, _, _ => by simp at hlen
  | n + 2, v :: u :: L, hlen, hnodup, hsorted, hclosed => by
    classical
    let tail := u :: L
    have ht : tail.Nodup := (List.nodup_cons.mp hnodup).2
    have hv : v ∉ tail := (List.nodup_cons.mp hnodup).1
    have horder : ∀ x ∈ tail, v < x := (List.pairwise_cons.mp hsorted).1
    have htorder : tail.Pairwise (· < ·) := (List.pairwise_cons.mp hsorted).2
    have hp : M.partner v ∈ tail :=
      (List.mem_cons.mp (hclosed v (by simp))).resolve_left (M.partner_ne_self v)
    have hlen' : (tail.erase (M.partner v)).length = n := by
      rw [List.length_erase_of_mem hp]
      change (u :: L).length - 1 = n
      simp only [List.length_cons] at hlen ⊢
      omega
    have hrec := pmSumListAux_ne_zero_of_forced W word M hweight n
      (tail.erase (M.partner v)) hlen' (ht.erase _) (htorder.erase _)
      (closed_after_pair M v tail hv ht hclosed)
    have hsum :
        (tail.map fun x => W (mkEdge v x (word v) (word x)) *
          pmSumListAux W word n (tail.erase x)).sum =
        W (mkEdge v (M.partner v) (word v) (word (M.partner v))) *
          pmSumListAux W word n (tail.erase (M.partner v)) := by
      rw [← List.sum_toFinset _ ht]
      apply Finset.sum_eq_single (M.partner v)
      · intro x hx hne
        have hxL : x ∈ tail := List.mem_toFinset.mp hx
        have hw : W (mkEdge v x (word v) (word x)) = 0 := by
          by_contra h
          exact hne ((hweight v x (horder x hxL)).mp h).symm
        rw [hw, zero_mul]
      · intro h
        exact False.elim (h (List.mem_toFinset.mpr hp))
    change (tail.map fun x => W (mkEdge v x (word v) (word x)) *
      pmSumListAux W word n (tail.erase x)).sum ≠ 0
    rw [hsum]
    exact mul_ne_zero ((hweight v (M.partner v) (horder _ hp)).mpr rfl) hrec

theorem pmSumN_ne_zero_of_forced (W : WeightsN N D K) (word : Fin N → Fin D)
    (M : Matching (Fin N))
    (hweight : ∀ v u, v < u →
      (W (mkEdge v u (word v) (word u)) ≠ 0 ↔ M.partner v = u)) :
    pmSumN N D W word ≠ 0 := by
  apply pmSumListAux_ne_zero_of_forced W word M hweight
    (vertices N).length (vertices N) rfl (vertices_nodup N) (vertices_pairwise_lt N)
  intro x _
  exact mem_vertices (M.partner x)

theorem allEqualList_eq (word : Fin N → Fin D) (L : List (Fin N))
    (h : allEqualList word L) {v w : Fin N} (hv : v ∈ L) (hw : w ∈ L) :
    word v = word w := by
  let : Trans (fun x y : Fin N => word x = word y)
      (fun x y : Fin N => word x = word y) (fun x y : Fin N => word x = word y) :=
    ⟨fun h₁ h₂ => h₁.trans h₂⟩
  cases L with
  | nil => simp at hv
  | cons a L =>
    have hchain : (a :: L).IsChain (fun x y => word x = word y) := h
    have ha : ∀ x ∈ a :: L, word a = word x := by
      intro x hx
      rcases List.mem_cons.mp hx with rfl | hx
      · rfl
      · exact hchain.rel_cons hx
    exact (ha v hv).symm.trans (ha w hw)

theorem not_allEqual_of_distinct (word : Fin N → Fin D) {v w : Fin N}
    (hne : word v ≠ word w) : ¬ allEqual word := by
  intro h
  exact hne (allEqualList_eq word (vertices N) h (mem_vertices v) (mem_vertices w))

def HasMatchingSupport (W : WeightsN N D K) (colours : Fin D → Matching (Fin N)) : Prop :=
  ∀ v u, v < u → ∀ i j,
    (W (mkEdge v u i j) ≠ 0 ↔ i = j ∧ (colours i).partner v = u)

theorem pmSumN_ne_zero_of_realizes (W : WeightsN N D K)
    (colours : Fin D → Matching (Fin N)) (hsupport : HasMatchingSupport W colours)
    (M : Matching (Fin N)) (word : Fin N → Fin D) (hreal : Realizes colours word M) :
    pmSumN N D W word ≠ 0 := by
  apply pmSumN_ne_zero_of_forced W word M
  intro v u hvu
  rw [hsupport v u hvu]
  constructor
  · rintro ⟨_, hp⟩
    exact (hreal v).1.trans hp
  · intro hp
    refine ⟨?_, (hreal v).1.symm.trans hp⟩
    simpa only [hp] using (hreal v).2.symm

theorem no_mixed_of_eqSystem_and_support (W : WeightsN N D K)
    (colours : Fin D → Matching (Fin N)) (hsupport : HasMatchingSupport W colours)
    (hEq : EqSystemN N D W) : ¬ HasMixedMatching colours := by
  rintro ⟨M, word, hreal, v, w, hne⟩
  have hnonzero := pmSumN_ne_zero_of_realizes W colours hsupport M word hreal
  have hzero := hEq word
  rw [if_neg (not_allEqual_of_distinct word hne)] at hzero
  exact hnonzero hzero

theorem not_eqSystemN_three_of_matching_support (hN : 4 < N)
    (W : WeightsN N 3 K) (colours : Fin 3 → Matching (Fin N))
    (hsupport : HasMatchingSupport W colours) : ¬ EqSystemN N 3 W := by
  intro hEq
  exact no_mixed_of_eqSystem_and_support W colours hsupport hEq
    (hasMixedMatching_three colours (by simpa only [Fintype.card_fin] using hN))

end Krenn.ForcedMatchingSum

-- formal/all-orders/EndpointDegree.lean

namespace Krenn

open scoped BigOperators

variable {K ι : Type*} [Field K] [CharZero K] [Fintype ι]

open scoped Classical in

theorem card_support_eq_one_of_endpoint_identities
    (w cofactor : ι → K) (β : K) (hβ : β ≠ 0)
    (hexpand : ∑ q, w q * cofactor q = β)
    (hendpoint : ∀ q, w q ≠ 0 → w q * cofactor q = β) :
    (Finset.univ.filter fun q => w q ≠ 0).card = 1 := by
  classical
  let s := Finset.univ.filter fun q => w q ≠ 0
  have hsum : (s.card : K) * β = β := by
    calc
      (s.card : K) * β = ∑ _q ∈ s, β := by simp
      _ = ∑ q, w q * cofactor q := by
        rw [Finset.sum_filter]
        apply Finset.sum_congr rfl
        intro q _
        by_cases hq : w q = 0
        · simp [hq]
        · simp [hq, hendpoint q hq]
      _ = β := hexpand
  have hcard : (s.card : K) = 1 :=
    mul_right_cancel₀ hβ (by simpa using hsum)
  exact Nat.cast_injective (R := K) (by simpa using hcard)

theorem exists_unique_support_of_endpoint_identities
    (w cofactor : ι → K) (β : K) (hβ : β ≠ 0)
    (hexpand : ∑ q, w q * cofactor q = β)
    (hendpoint : ∀ q, w q ≠ 0 → w q * cofactor q = β) :
    ∃! q, w q ≠ 0 := by
  classical
  obtain ⟨q, hq⟩ := Finset.card_eq_one.mp
    (card_support_eq_one_of_endpoint_identities w cofactor β hβ hexpand hendpoint)
  refine ⟨q, ?_, ?_⟩
  · have hmem : q ∈ Finset.univ.filter (fun r => w r ≠ 0) := by
      rw [hq]
      exact Finset.mem_singleton_self q
    exact (Finset.mem_filter.mp hmem).2
  · intro r hr
    have hmem : r ∈ Finset.univ.filter (fun r => w r ≠ 0) :=
      Finset.mem_filter.mpr ⟨Finset.mem_univ r, hr⟩
    rw [hq] at hmem
    exact Finset.mem_singleton.mp hmem

end Krenn

-- formal/all-orders/SupportMatching.lean

namespace Krenn.SupportMatching

open MatchingModel SiteAlgebra ThreeMatching ForcedMatchingSum
open scoped BigOperators

variable {K V : Type*} [CommRing K] [IsDomain K]

noncomputable def matchingOfUniqueSupport (S : V → V → K)
    (hsym : ∀ v u, S v u = S u v) (hdiag : ∀ v, S v v = 0)
    (hunique : ∀ v, ∃! u, S v u ≠ 0) : Matching V where
  partner v := (hunique v).choose
  partner_partner v := by
    apply Eq.symm
    apply (hunique ((hunique v).choose)).choose_spec.2
    rw [hsym]
    exact (hunique v).choose_spec.1
  partner_ne_self v := by
    intro h
    have hn := (hunique v).choose_spec.1
    rw [h, hdiag] at hn
    exact hn rfl

omit [IsDomain K] in
theorem matchingOfUniqueSupport_partner_iff (S : V → V → K)
    (hsym : ∀ v u, S v u = S u v) (hdiag : ∀ v, S v v = 0)
    (hunique : ∀ v, ∃! u, S v u ≠ 0) (v u : V) :
    (matchingOfUniqueSupport S hsym hdiag hunique).partner v = u ↔ S v u ≠ 0 := by
  constructor
  · intro h
    rw [← h]
    exact (hunique v).choose_spec.1
  · intro h
    exact ((hunique v).choose_spec.2 u h).symm

variable {N D : ℕ}

noncomputable def monochromaticWeight (W : WeightsN N D K) (i : Fin D)
    (v u : Fin N) : K := edgeMatrix W (v, i) (u, i)

noncomputable def colourMatchings (W : WeightsN N D K)
    (hunique : ∀ i v, ∃! u, monochromaticWeight W i v u ≠ 0) :
    Fin D → Matching (Fin N) := fun i =>
  matchingOfUniqueSupport (monochromaticWeight W i)
    (fun v u => edgeMatrix_symm W (v, i) (u, i))
    (fun v => edgeMatrix_same_site W v i i) (hunique i)

omit [IsDomain K] in

theorem hasMatchingSupport_of_diagonal_unique (W : WeightsN N D K)
    (hdiagonal : ∀ v u i j, i ≠ j → edgeMatrix W (v, i) (u, j) = 0)
    (hunique : ∀ i v, ∃! u, monochromaticWeight W i v u ≠ 0) :
    HasMatchingSupport W (colourMatchings W hunique) := by
  intro v u hvu i j
  by_cases hij : i = j
  · subst j
    simp only [true_and]
    rw [show (colourMatchings W hunique i).partner v = u ↔
      monochromaticWeight W i v u ≠ 0 from
      matchingOfUniqueSupport_partner_iff _ _ _ _ v u]
    rw [monochromaticWeight, edgeMatrix_ordered W v u hvu]
  · have hw : W (mkEdge v u i j) = 0 := by
      rw [← edgeMatrix_ordered W v u hvu]
      exact hdiagonal v u i j hij
    simp only [hw, ne_eq, not_true_eq_false, hij, false_and]

theorem not_eqSystemN_three_of_diagonal_unique (hN : 4 < N)
    (W : WeightsN N 3 K)
    (hdiagonal : ∀ v u i j, i ≠ j → edgeMatrix W (v, i) (u, j) = 0)
    (hunique : ∀ i v, ∃! u, monochromaticWeight W i v u ≠ 0) :
    ¬ EqSystemN N 3 W :=
  not_eqSystemN_three_of_matching_support hN W (colourMatchings W hunique)
    (hasMatchingSupport_of_diagonal_unique W hdiagonal hunique)

theorem not_eqSystemN_three_of_endpoint_identities
    {F : Type*} [Field F] [CharZero F] (hN : 4 < N) (W : WeightsN N 3 F)
    (cofactor : Fin 3 → Fin N → Fin N → F)
    (hdiagonal : ∀ v u i j, i ≠ j → edgeMatrix W (v, i) (u, j) = 0)
    (hexpand : ∀ i p, ∑ q, monochromaticWeight W i p q * cofactor i p q = 1)
    (hendpoint : ∀ i p q, monochromaticWeight W i p q ≠ 0 →
      monochromaticWeight W i p q * cofactor i p q = 1) : ¬ EqSystemN N 3 W := by
  apply not_eqSystemN_three_of_diagonal_unique hN W hdiagonal
  intro i p
  exact exists_unique_support_of_endpoint_identities
    (monochromaticWeight W i p) (cofactor i p) 1 one_ne_zero (hexpand i p) (hendpoint i p)

end Krenn.SupportMatching

-- formal/all-orders/PhysicalClosure.lean

namespace Krenn.PhysicalClosure

open MatchingModel SiteAlgebra RootResponse SupportMatching

variable {K : Type*} [Field K] [CharZero K]

theorem not_eqSystemN_of_diagonal_and_endpoint {N : ℕ} (hN : 6 ≤ N) (heven : Even N)
    (W : WeightsN N 3 K)
    (hdiagonal : ∀ v u i j, i ≠ j → edgeMatrix W (v, i) (u, j) = 0)
    (hendpoint : ∀ i p q, edgeMatrix W (p, i) (q, i) ≠ 0 →
      edgeMatrix W (p, i) (q, i) * pureCofactor W i p q = 1) : ¬ EqSystemN N 3 W := by
  intro hEq
  obtain ⟨m, hm⟩ := heven
  have hmpos : 0 < m := by omega
  obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.ne_of_gt hmpos)
  have hsize : N = 2 * (k + 1) := by omega
  clear hm
  subst N
  apply not_eqSystemN_three_of_endpoint_identities (by omega) W (pureCofactor W)
    hdiagonal ?_ hendpoint hEq
  intro i p
  exact pureCofactor_rowSum_eq_one k W hEq p i

end Krenn.PhysicalClosure

-- formal/all-orders/WickCovariance.lean

/-
Copyright (c) 2026 Rishi. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

namespace Krenn.WickCovariance

open scoped BigOperators Classical

variable {R E F : Type*} [Field R]
  [AddCommGroup E] [Module R E] [AddCommGroup F] [Module R F]

abbrev Slots (m : ℕ) := (_i : Fin m) × Fin 2

def covariancePair (B : E →ₗ[R] E →ₗ[R] R) :
    MultilinearMap R (fun _ : Fin 2 => E) R where
  toFun v := B (v 0) (v 1)
  map_update_add' v i x y := by
    fin_cases i <;> simp
  map_update_smul' v i c x := by
    fin_cases i <;> simp

@[simp]
theorem covariancePair_apply (B : E →ₗ[R] E →ₗ[R] R) (v : Fin 2 → E) :
    covariancePair B v = B (v 0) (v 1) := rfl

def pairingProduct (B : E →ₗ[R] E →ₗ[R] R) (m : ℕ) :
    MultilinearMap R (fun _ : Slots m => E) R :=
  (MultilinearMap.mkPiAlgebra R (Fin m) R).compMultilinearMap fun _ => covariancePair B

@[simp]
theorem pairingProduct_apply (B : E →ₗ[R] E →ₗ[R] R) (m : ℕ) (v : Slots m → E) :
    pairingProduct B m v = ∏ i : Fin m, B (v ⟨i, 0⟩) (v ⟨i, 1⟩) := rfl

noncomputable def wickMoment (B : E →ₗ[R] E →ₗ[R] R) (m : ℕ) :
    MultilinearMap R (fun _ : Slots m => E) R :=
  ((2 : R) ^ m * (m.factorial : R))⁻¹ •
    ∑ σ : Equiv.Perm (Slots m), (pairingProduct B m).domDomCongr σ

theorem wickMoment_apply (B : E →ₗ[R] E →ₗ[R] R) (m : ℕ) (v : Slots m → E) :
    wickMoment B m v = ((2 : R) ^ m * (m.factorial : R))⁻¹ *
      ∑ σ : Equiv.Perm (Slots m), ∏ i : Fin m,
        B (v (σ ⟨i, 0⟩)) (v (σ ⟨i, 1⟩)) := by
  simp [wickMoment, MultilinearMap.domDomCongr_apply]

@[simp]
theorem wickMoment_zero (B : E →ₗ[R] E →ₗ[R] R) (v : Slots 0 → E) :
    wickMoment B 0 v = 1 := by
  simp [wickMoment_apply]

theorem wickMoment_permute (B : E →ₗ[R] E →ₗ[R] R) (m : ℕ)
    (τ : Equiv.Perm (Slots m)) (v : Slots m → E) :
    wickMoment B m (fun i => v (τ i)) = wickMoment B m v := by
  simp only [wickMoment_apply]
  congr 1
  exact Fintype.sum_equiv (Equiv.mulLeft τ) _ _ (fun _ => rfl)

theorem wickMoment_const (B : E →ₗ[R] E →ₗ[R] R) (m : ℕ) (x : E) :
    wickMoment B m (fun _ => x) =
      ((2 : R) ^ m * (m.factorial : R))⁻¹ *
        ((2 * m).factorial : R) * B x x ^ m := by
  simp only [wickMoment_apply, Finset.prod_const, Finset.card_univ, Fintype.card_fin,
    Finset.sum_const, nsmul_eq_mul, Fintype.card_perm, Fintype.card_sigma,
    Finset.sum_const, Nat.cast_id]
  rw [Nat.mul_comm m 2]
  ring

theorem slots_one_cases (i : Slots 1) : i = ⟨0, 0⟩ ∨ i = ⟨0, 1⟩ := by
  rcases i with ⟨i, j⟩
  fin_cases i
  fin_cases j <;> simp

@[simp]
theorem wickMoment_one [CharZero R] (B : E →ₗ[R] E →ₗ[R] R)
    (hB : ∀ x y, B x y = B y x) (v : Slots 1 → E) :
    wickMoment B 1 v = B (v ⟨0, 0⟩) (v ⟨0, 1⟩) := by
  have hne : (⟨0, 0⟩ : Slots 1) ≠ ⟨0, 1⟩ := by decide
  have hterm (σ : Equiv.Perm (Slots 1)) :
      (∏ i : Fin 1, B (v (σ ⟨i, 0⟩)) (v (σ ⟨i, 1⟩))) =
        B (v ⟨0, 0⟩) (v ⟨0, 1⟩) := by
    rw [Fintype.prod_unique]
    change B (v (σ ⟨0, 0⟩)) (v (σ ⟨0, 1⟩)) = _
    rcases slots_one_cases (σ ⟨0, 0⟩) with h0 | h0
    · have h1 : σ ⟨0, 1⟩ = ⟨0, 1⟩ := by
        rcases slots_one_cases (σ ⟨0, 1⟩) with h1 | h1
        · exact False.elim (hne (σ.injective (h0.trans h1.symm)))
        · exact h1
      rw [h0, h1]
    · have h1 : σ ⟨0, 1⟩ = ⟨0, 0⟩ := by
        rcases slots_one_cases (σ ⟨0, 1⟩) with h1 | h1
        · exact h1
        · exact False.elim (hne (σ.injective (h0.trans h1.symm)))
      rw [h0, h1, hB]
  rw [wickMoment_apply]
  simp_rw [hterm]
  norm_num [Fintype.card_perm, Slots, nsmul_eq_mul]
  ring

theorem wickMoment_update_add (B : E →ₗ[R] E →ₗ[R] R) (m : ℕ)
    (v : Slots m → E) (i : Slots m) (x y : E) :
    wickMoment B m (Function.update v i (x + y)) =
      wickMoment B m (Function.update v i x) + wickMoment B m (Function.update v i y) :=
  (wickMoment B m).map_update_add v i x y

theorem wickMoment_update_smul (B : E →ₗ[R] E →ₗ[R] R) (m : ℕ)
    (v : Slots m → E) (i : Slots m) (c : R) (x : E) :
    wickMoment B m (Function.update v i (c • x)) =
      c * wickMoment B m (Function.update v i x) :=
  (wickMoment B m).map_update_smul v i c x

theorem wickMoment_linear_expansion {ι : Type*} [Fintype ι]
    (B : E →ₗ[R] E →ₗ[R] R) (m : ℕ)
    (a : Slots m → ι → R) (v : ι → E) :
    wickMoment B m (fun i => ∑ j, a i j • v j) =
      ∑ choices : Slots m → ι,
        (∏ i, a i (choices i)) * wickMoment B m (fun i => v (choices i)) := by
  classical
  rw [(wickMoment B m).map_sum]
  apply Finset.sum_congr rfl
  intro choices _
  exact (wickMoment B m).map_smul_univ (fun i => a i (choices i)) _

theorem wickMoment_naturality (B : F →ₗ[R] F →ₗ[R] R) (T : E →ₗ[R] F)
    (m : ℕ) (v : Slots m → E) :
    wickMoment (B.compl₁₂ T T) m v = wickMoment B m (fun i => T (v i)) := by
  simp only [wickMoment_apply, LinearMap.compl₁₂_apply]

theorem wickMoment_invariant (B : E →ₗ[R] E →ₗ[R] R) (T : E →ₗ[R] E)
    (hT : ∀ x y, B (T x) (T y) = B x y) (m : ℕ) (v : Slots m → E) :
    wickMoment B m (fun i => T (v i)) = wickMoment B m v := by
  simp only [wickMoment_apply, hT]

section ArbitrarySlots

variable {ι : Type*} [Fintype ι]

noncomputable def evenSlotsEquiv (h : Even (Fintype.card ι)) :
    Slots (Fintype.card ι / 2) ≃ ι :=
  Fintype.equivOfCardEq (by
    simp only [Slots, Fintype.card_sigma, Fintype.card_fin, Finset.sum_const,
      Finset.card_univ, smul_eq_mul]
    obtain ⟨k, hk⟩ := h
    omega)

noncomputable def centeredMoment (B : E →ₗ[R] E →ₗ[R] R) :
    MultilinearMap R (fun _ : ι => E) R :=
  if h : Even (Fintype.card ι) then
    (wickMoment B (Fintype.card ι / 2)).domDomCongr (evenSlotsEquiv h)
  else 0

theorem centeredMoment_of_even (B : E →ₗ[R] E →ₗ[R] R)
    (h : Even (Fintype.card ι)) (v : ι → E) :
    centeredMoment B v = wickMoment B (Fintype.card ι / 2)
      (fun i => v (evenSlotsEquiv h i)) := by
  simp only [centeredMoment, dif_pos h, MultilinearMap.domDomCongr_apply]

@[simp]
theorem centeredMoment_of_not_even (B : E →ₗ[R] E →ₗ[R] R)
    (h : ¬Even (Fintype.card ι)) (v : ι → E) : centeredMoment B v = 0 := by
  simp [centeredMoment, h]

theorem centeredMoment_naturality (B : F →ₗ[R] F →ₗ[R] R) (T : E →ₗ[R] F)
    (v : ι → E) :
    centeredMoment (B.compl₁₂ T T) v = centeredMoment B (fun i => T (v i)) := by
  by_cases h : Even (Fintype.card ι)
  · simp only [centeredMoment_of_even _ h]
    exact wickMoment_naturality B T _ _
  · simp only [centeredMoment_of_not_even _ h]

theorem centeredMoment_permute (B : E →ₗ[R] E →ₗ[R] R)
    (τ : Equiv.Perm ι) (v : ι → E) :
    centeredMoment B (fun i => v (τ i)) = centeredMoment B v := by
  by_cases h : Even (Fintype.card ι)
  · simp only [centeredMoment_of_even _ h]
    let e := evenSlotsEquiv (ι := ι) h
    have hw := wickMoment_permute B (Fintype.card ι / 2)
      ((e.trans τ).trans e.symm) (fun i => v (e i))
    simpa only [Equiv.trans_apply, Equiv.apply_symm_apply] using hw
  · simp only [centeredMoment_of_not_even _ h]

def meanProduct (μ : E →ₗ[R] R) : MultilinearMap R (fun _ : ι => E) R :=
  (MultilinearMap.mkPiAlgebra R ι R).compLinearMap fun _ => μ

@[simp]
theorem meanProduct_apply (μ : E →ₗ[R] R) (v : ι → E) :
    meanProduct μ v = ∏ i, μ (v i) := rfl

noncomputable def shiftedTerm (B : E →ₗ[R] E →ₗ[R] R) (μ : E →ₗ[R] R)
    (s : Finset ι) : MultilinearMap R (fun _ : ι => E) R := by
  classical
  exact ((meanProduct (ι := {i // i ∈ s}) μ).smulRight
    (centeredMoment (ι := {i // i ∉ s}) B)).uncurrySum.domDomCongr
      (Equiv.sumCompl fun i => i ∈ s)

theorem shiftedTerm_apply (B : E →ₗ[R] E →ₗ[R] R) (μ : E →ₗ[R] R)
    (s : Finset ι) (v : ι → E) :
    shiftedTerm B μ s v = (∏ i : {i // i ∈ s}, μ (v i)) *
      centeredMoment B (fun i : {i // i ∉ s} => v i) := rfl

noncomputable def shiftedMoment (B : E →ₗ[R] E →ₗ[R] R) (μ : E →ₗ[R] R) :
    MultilinearMap R (fun _ : ι => E) R :=
  ∑ s : Finset ι, shiftedTerm B μ s

theorem shiftedMoment_apply (B : E →ₗ[R] E →ₗ[R] R) (μ : E →ₗ[R] R) (v : ι → E) :
    shiftedMoment B μ v = ∑ s : Finset ι,
      (∏ i : {i // i ∈ s}, μ (v i)) *
        centeredMoment B (fun i : {i // i ∉ s} => v i) := by
  simp [shiftedMoment, shiftedTerm_apply]

theorem shiftedMoment_linear_expansion {κ : Type*} [Fintype κ]
    (B : E →ₗ[R] E →ₗ[R] R) (μ : E →ₗ[R] R)
    (a : ι → κ → R) (v : κ → E) :
    shiftedMoment B μ (fun i => ∑ j, a i j • v j) =
      ∑ choices : ι → κ,
        (∏ i, a i (choices i)) * shiftedMoment B μ (fun i => v (choices i)) := by
  rw [(shiftedMoment B μ).map_sum]
  apply Finset.sum_congr rfl
  intro choices _
  exact (shiftedMoment B μ).map_smul_univ (fun i => a i (choices i)) _

theorem shiftedMoment_naturality (B : F →ₗ[R] F →ₗ[R] R) (μ : F →ₗ[R] R)
    (T : E →ₗ[R] F) (v : ι → E) :
    shiftedMoment (B.compl₁₂ T T) (μ.comp T) v =
      shiftedMoment B μ (fun i => T (v i)) := by
  simp only [shiftedMoment_apply, LinearMap.comp_apply, centeredMoment_naturality]

theorem shiftedMoment_invariant (B : E →ₗ[R] E →ₗ[R] R) (μ : E →ₗ[R] R)
    (T : E →ₗ[R] E) (hT : ∀ x y, B (T x) (T y) = B x y) (v : ι → E) :
    shiftedMoment B μ (fun i => T (v i)) = shiftedMoment B (μ.comp T) v := by
  have hB : B.compl₁₂ T T = B := by
    ext x y
    exact hT x y
  rw [← shiftedMoment_naturality, hB]

end ArbitrarySlots

def replicaCovariance (B : E →ₗ[R] E →ₗ[R] R) :
    (E × E) →ₗ[R] (E × E) →ₗ[R] R :=
  B.compl₁₂ (LinearMap.fst R E E) (LinearMap.fst R E E) +
    B.compl₁₂ (LinearMap.snd R E E) (LinearMap.snd R E E)

@[simp]
theorem replicaCovariance_apply (B : E →ₗ[R] E →ₗ[R] R) (x y : E × E) :
    replicaCovariance B x y = B x.1 y.1 + B x.2 y.2 := rfl

def replicaLinear (a b c d : R) : (E × E) →ₗ[R] (E × E) :=
  (a • LinearMap.fst R E E + b • LinearMap.snd R E E).prod
    (c • LinearMap.fst R E E + d • LinearMap.snd R E E)

@[simp]
theorem replicaLinear_apply (a b c d : R) (x : E × E) :
    replicaLinear a b c d x = (a • x.1 + b • x.2, c • x.1 + d • x.2) := rfl

theorem replicaLinear_covariance (B : E →ₗ[R] E →ₗ[R] R) (a b c d : R)
    (hfirst : a ^ 2 + c ^ 2 = 1) (hsecond : b ^ 2 + d ^ 2 = 1)
    (hcross : a * b + c * d = 0) (x y : E × E) :
    replicaCovariance B (replicaLinear a b c d x) (replicaLinear a b c d y) =
      replicaCovariance B x y := by
  simp only [replicaCovariance_apply, replicaLinear_apply, map_add, map_smul,
    LinearMap.add_apply, LinearMap.smul_apply, smul_eq_mul]
  calc
    _ = (a ^ 2 + c ^ 2) * B x.1 y.1 + (b ^ 2 + d ^ 2) * B x.2 y.2 +
        (a * b + c * d) * (B x.1 y.2 + B x.2 y.1) := by ring
    _ = _ := by rw [hfirst, hsecond, hcross]; ring

def alternatingProduct (μ ν : E →ₗ[R] R) (x : E × E) : R :=
  μ x.1 * ν x.2 - ν x.1 * μ x.2

theorem alternatingProduct_replicaLinear (μ ν : E →ₗ[R] R)
    (a b c d : R) (x : E × E) :
    alternatingProduct μ ν (replicaLinear a b c d x) =
      (a * d - b * c) * alternatingProduct μ ν x := by
  simp only [alternatingProduct, replicaLinear_apply, map_add, map_smul, smul_eq_mul]
  ring

def replicaRotation (a b : R) : (E × E) →ₗ[R] (E × E) :=
  (a • LinearMap.fst R E E + b • LinearMap.snd R E E).prod
    ((-b) • LinearMap.fst R E E + a • LinearMap.snd R E E)

@[simp]
theorem replicaRotation_apply (a b : R) (x : E × E) :
    replicaRotation a b x = (a • x.1 + b • x.2, (-b) • x.1 + a • x.2) := rfl

theorem replicaRotation_covariance (B : E →ₗ[R] E →ₗ[R] R) (a b : R)
    (h : a ^ 2 + b ^ 2 = 1) (x y : E × E) :
    replicaCovariance B (replicaRotation a b x) (replicaRotation a b y) =
      replicaCovariance B x y := by
  simp only [replicaCovariance_apply, replicaRotation_apply, map_add, map_smul,
    LinearMap.add_apply, LinearMap.smul_apply, smul_eq_mul]
  calc
    _ = (a ^ 2 + b ^ 2) * (B x.1 y.1 + B x.2 y.2) := by ring
    _ = _ := by rw [h, one_mul]

theorem wickMoment_replicaRotation (B : E →ₗ[R] E →ₗ[R] R) (a b : R)
    (h : a ^ 2 + b ^ 2 = 1) (m : ℕ) (v : Slots m → E × E) :
    wickMoment (replicaCovariance B) m (fun i => replicaRotation a b (v i)) =
      wickMoment (replicaCovariance B) m v :=
  wickMoment_invariant _ _ (replicaRotation_covariance B a b h) m v

theorem shiftedMoment_replicaRotation {ι : Type*} [Fintype ι]
    (B : E →ₗ[R] E →ₗ[R] R) (μ : (E × E) →ₗ[R] R) (a b : R)
    (h : a ^ 2 + b ^ 2 = 1) (v : ι → E × E) :
    shiftedMoment (replicaCovariance B) μ (fun i => replicaRotation a b (v i)) =
      shiftedMoment (replicaCovariance B) (μ.comp (replicaRotation a b)) v :=
  shiftedMoment_invariant _ μ _ (replicaRotation_covariance B a b h) v

theorem shiftedMoment_replicaLinear {ι : Type*} [Fintype ι]
    (B : E →ₗ[R] E →ₗ[R] R) (μ : (E × E) →ₗ[R] R) (a b c d : R)
    (hfirst : a ^ 2 + c ^ 2 = 1) (hsecond : b ^ 2 + d ^ 2 = 1)
    (hcross : a * b + c * d = 0) (v : ι → E × E) :
    shiftedMoment (replicaCovariance B) μ (fun i => replicaLinear a b c d (v i)) =
      shiftedMoment (replicaCovariance B) (μ.comp (replicaLinear a b c d)) v :=
  shiftedMoment_invariant _ μ _ (replicaLinear_covariance B a b c d hfirst hsecond hcross) v

end Krenn.WickCovariance

-- formal/all-orders/WickCoefficientBridge.lean

/-
Copyright (c) 2026 Rishi. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

namespace Krenn.WickCoefficientBridge

open scoped BigOperators Classical
open WickCovariance

variable {R ι : Type*} [CommRing R] [Fintype ι] [DecidableEq ι]

noncomputable def topExponent (ι : Type*) [Fintype ι] : ι →₀ ℕ :=
  ∑ i, Finsupp.single i 1

@[simp]
theorem topExponent_apply (i : ι) : topExponent ι i = 1 := by
  simp [topExponent, Finsupp.single_apply]

@[simp]
theorem topExponent_degree : (topExponent ι).degree = Fintype.card ι := by
  simp [Finsupp.degree_eq_sum]

noncomputable def choiceExponent (f : ι → ι) : ι →₀ ℕ :=
  ∑ i, Finsupp.single (f i) 1

theorem choiceExponent_eq_top_iff (f : ι → ι) :
    choiceExponent f = topExponent ι ↔ Function.Bijective f := by
  constructor
  · intro h
    apply Function.Surjective.bijective_of_finite
    intro j
    by_contra hj
    have hn : ∀ i, f i ≠ j := by simpa only [not_exists] using hj
    have hc := congrArg (fun d : ι →₀ ℕ => d j) h
    simp [choiceExponent, hn] at hc
  · intro h
    exact h.sum_comp (fun i => Finsupp.single i 1)

omit [DecidableEq ι] in

theorem prod_X_choice (f : ι → ι) :
    (∏ i, (MvPolynomial.X (f i) : MvPolynomial ι R)) =
      MvPolynomial.monomial (choiceExponent f) 1 := by
  simpa only [choiceExponent, MvPolynomial.X] using
    (MvPolynomial.monomial_sum_one (R := R) Finset.univ
      (fun i => Finsupp.single (f i) 1)).symm

theorem coeff_top_prod_X_choice (f : ι → ι) :
    MvPolynomial.coeff (topExponent ι) (∏ i, (MvPolynomial.X (f i) : MvPolynomial ι R)) =
      if Function.Bijective f then 1 else 0 := by
  rw [prod_X_choice]
  simp only [MvPolynomial.coeff_monomial, choiceExponent_eq_top_iff]

noncomputable def bijectiveEquivPerm :
    {f : ι → ι // Function.Bijective f} ≃ Equiv.Perm ι where
  toFun f := Equiv.ofBijective f.1 f.2
  invFun σ := ⟨σ, σ.bijective⟩
  left_inv f := by rfl
  right_inv σ := by ext i; rfl

theorem sum_bijective_eq_sum_perm (w : (ι → ι) → R) :
    (∑ f : ι → ι, if Function.Bijective f then w f else 0) =
      ∑ σ : Equiv.Perm ι, w σ := by
  classical
  rw [← Finset.sum_filter]
  rw [Finset.sum_subtype (p := Function.Bijective) _
    (fun _ => by simp only [Finset.mem_filter, Finset.mem_univ, true_and])]
  exact Fintype.sum_equiv bijectiveEquivPerm _ _ (fun _ => rfl)

theorem coeff_top_weighted_choices (w : (ι → ι) → R) :
    MvPolynomial.coeff (topExponent ι)
      (∑ f : ι → ι, MvPolynomial.C (w f) * ∏ i, MvPolynomial.X (f i)) =
      ∑ σ : Equiv.Perm ι, w σ := by
  simp only [MvPolynomial.coeff_sum, MvPolynomial.coeff_C_mul, coeff_top_prod_X_choice]
  simp only [mul_ite, mul_one, mul_zero]
  exact sum_bijective_eq_sum_perm w

noncomputable def rawQuadratic (S : ι → ι → R) : MvPolynomial ι R :=
  ∑ i, ∑ j, MvPolynomial.C (S i j) * MvPolynomial.X i * MvPolynomial.X j

omit [DecidableEq ι] in
theorem rawQuadratic_eq_pairAssignments (S : ι → ι → R) :
    rawQuadratic S = ∑ f : Fin 2 → ι,
      MvPolynomial.C (S (f 0) (f 1)) * ∏ j : Fin 2, MvPolynomial.X (f j) := by
  unfold rawQuadratic
  calc
    _ = ∑ p : ι × ι, MvPolynomial.C (S p.1 p.2) *
        MvPolynomial.X p.1 * MvPolynomial.X p.2 := (Fintype.sum_prod_type _).symm
    _ = _ := by
      symm
      apply Fintype.sum_equiv (finTwoArrowEquiv ι)
      intro f
      simp [Fin.prod_univ_two, mul_assoc]

omit [DecidableEq ι] in

theorem rawQuadratic_isHomogeneous (S : ι → ι → R) :
    (rawQuadratic S).IsHomogeneous 2 := by
  apply MvPolynomial.IsHomogeneous.sum
  intro i _
  apply MvPolynomial.IsHomogeneous.sum
  intro j _
  exact (MvPolynomial.isHomogeneous_C_mul_X (S i j) i).mul
    (MvPolynomial.isHomogeneous_X _ j)

omit [DecidableEq ι] in

theorem rawQuadratic_pow_assignments (S : ι → ι → R) (m : ℕ) :
    rawQuadratic S ^ m = ∑ f : Slots m → ι,
      MvPolynomial.C (∏ i : Fin m, S (f ⟨i, 0⟩) (f ⟨i, 1⟩)) *
        ∏ j : Slots m, MvPolynomial.X (f j) := by
  calc
    rawQuadratic S ^ m = ∏ _i : Fin m, rawQuadratic S := by simp
    _ = ∏ _i : Fin m, ∑ f : Fin 2 → ι,
        MvPolynomial.C (S (f 0) (f 1)) * ∏ j : Fin 2, MvPolynomial.X (f j) := by
      rw [rawQuadratic_eq_pairAssignments]
    _ = ∑ f : Fin m → Fin 2 → ι, ∏ i : Fin m,
        (MvPolynomial.C (S (f i 0) (f i 1)) * ∏ j : Fin 2, MvPolynomial.X (f i j)) :=
      Fintype.prod_sum _
    _ = _ := by
      apply Fintype.sum_equiv (Equiv.piCurry (fun (_i : Fin m) (_j : Fin 2) => ι)).symm
      intro f
      simp only [Equiv.piCurry_symm_apply, Finset.prod_mul_distrib, ← map_prod,
        Fintype.prod_sigma, Sigma.uncurry]

theorem coeff_top_rawQuadratic_pow (m : ℕ) (S : Slots m → Slots m → R) :
    MvPolynomial.coeff (topExponent (Slots m)) (rawQuadratic S ^ m) =
      ∑ σ : Equiv.Perm (Slots m), ∏ i : Fin m, S (σ ⟨i, 0⟩) (σ ⟨i, 1⟩) := by
  rw [rawQuadratic_pow_assignments]
  exact coeff_top_weighted_choices (R := R) (ι := Slots m)
    (fun f => ∏ i : Fin m, S (f ⟨i, 0⟩) (f ⟨i, 1⟩))

section SplitCoefficients

variable {κ : Type*}

omit [Fintype ι] [DecidableEq ι] in

theorem coeff_sumRingEquiv (P : MvPolynomial (ι ⊕ κ) R)
    (d : ι →₀ ℕ) (e : κ →₀ ℕ) :
    MvPolynomial.coeff e (MvPolynomial.coeff d (MvPolynomial.sumRingEquiv R ι κ P)) =
      MvPolynomial.coeff (Finsupp.sumElim d e) P := by
  simp [MvPolynomial.sumRingEquiv, MvPolynomial.coeff,
    AddMonoidAlgebra.curryRingEquiv, AddMonoidAlgebra.curryAddEquiv]

omit [Fintype ι] [DecidableEq ι] in
theorem sumRingEquiv_rename_left (P : MvPolynomial ι R) :
    MvPolynomial.sumRingEquiv R ι κ (MvPolynomial.rename Sum.inl P) =
      MvPolynomial.map MvPolynomial.C P := by
  induction P using MvPolynomial.induction_on with
  | C r => simp
  | add P Q hP hQ => simp [map_add, hP, hQ]
  | mul_X P i hP => simp [map_mul, hP]

omit [Fintype ι] [DecidableEq ι] in
theorem sumRingEquiv_rename_right (P : MvPolynomial κ R) :
    MvPolynomial.sumRingEquiv R ι κ (MvPolynomial.rename Sum.inr P) =
      MvPolynomial.C P := by
  induction P using MvPolynomial.induction_on with
  | C r => simp
  | add P Q hP hQ => simp [map_add, hP, hQ]
  | mul_X P i hP => simp [map_mul, hP]

omit [Fintype ι] [DecidableEq ι] in

theorem coeff_rename_mul_rename (P : MvPolynomial ι R) (Q : MvPolynomial κ R)
    (d : ι →₀ ℕ) (e : κ →₀ ℕ) :
    MvPolynomial.coeff (Finsupp.sumElim d e)
      (MvPolynomial.rename Sum.inl P * MvPolynomial.rename Sum.inr Q) =
        MvPolynomial.coeff d P * MvPolynomial.coeff e Q := by
  rw [← coeff_sumRingEquiv, map_mul, sumRingEquiv_rename_left, sumRingEquiv_rename_right]
  rw [mul_comm (MvPolynomial.map MvPolynomial.C P), MvPolynomial.coeff_C_mul,
    MvPolynomial.coeff_map, mul_comm Q, MvPolynomial.coeff_C_mul]

variable [Fintype κ] [DecidableEq κ]

@[simp]
theorem topExponent_sumElim :
    Finsupp.sumElim (topExponent ι) (topExponent κ) = topExponent (ι ⊕ κ) := by
  ext i
  cases i <;> simp

theorem coeff_top_rename_mul_rename (P : MvPolynomial ι R) (Q : MvPolynomial κ R) :
    MvPolynomial.coeff (topExponent (ι ⊕ κ))
      (MvPolynomial.rename Sum.inl P * MvPolynomial.rename Sum.inr Q) =
        MvPolynomial.coeff (topExponent ι) P * MvPolynomial.coeff (topExponent κ) Q := by
  rw [← topExponent_sumElim, coeff_rename_mul_rename]

theorem coeff_top_sum_rename_pow (P : MvPolynomial ι R) (Q : MvPolynomial κ R) (n : ℕ) :
    MvPolynomial.coeff (topExponent (ι ⊕ κ))
      ((MvPolynomial.rename Sum.inl P + MvPolynomial.rename Sum.inr Q) ^ n) =
      ∑ k ∈ Finset.range (n + 1), (n.choose k : R) *
        MvPolynomial.coeff (topExponent ι) (P ^ k) *
        MvPolynomial.coeff (topExponent κ) (Q ^ (n - k)) := by
  rw [add_pow, MvPolynomial.coeff_sum]
  apply Finset.sum_congr rfl
  intro k _
  rw [show (↑(n.choose k) : MvPolynomial (ι ⊕ κ) R) =
      MvPolynomial.C (n.choose k : R) by simp]
  rw [mul_comm ((_ ^ k) * (_ ^ (n - k))), MvPolynomial.coeff_C_mul,
    ← map_pow, ← map_pow, coeff_top_rename_mul_rename]
  ring

end SplitCoefficients

theorem coeff_top_pow_eq_zero (P : MvPolynomial ι R) (hP : P.IsHomogeneous 2)
    {m k : ℕ} (hcard : Fintype.card ι = 2 * m) (hne : k ≠ m) :
    MvPolynomial.coeff (topExponent ι) (P ^ k) = 0 := by
  apply (hP.pow k).coeff_eq_zero
  rw [topExponent_degree, hcard]
  omega

theorem coeff_top_pow_eq_zero_of_odd (P : MvPolynomial ι R)
    (hP : P.IsHomogeneous 2) (hodd : ¬Even (Fintype.card ι)) (k : ℕ) :
    MvPolynomial.coeff (topExponent ι) (P ^ k) = 0 := by
  apply (hP.pow k).coeff_eq_zero
  rw [topExponent_degree]
  intro h
  apply hodd
  exact ⟨k, by omega⟩

section Relabelling

variable {κ : Type*} [Fintype κ] [DecidableEq κ]

theorem topExponent_mapDomain (e : ι ≃ κ) :
    (topExponent ι).mapDomain e = topExponent κ := by
  ext j
  rw [Finsupp.mapDomain_equiv_apply]
  simp

theorem coeff_top_rename_equiv (e : ι ≃ κ) (P : MvPolynomial ι R) :
    MvPolynomial.coeff (topExponent κ) (MvPolynomial.rename e P) =
      MvPolynomial.coeff (topExponent ι) P := by
  rw [← topExponent_mapDomain e, MvPolynomial.coeff_rename_mapDomain e e.injective]

omit [DecidableEq ι] [DecidableEq κ] in
theorem rawQuadratic_rename_equiv (e : ι ≃ κ) (S : κ → κ → R) :
    MvPolynomial.rename e (rawQuadratic (fun i j => S (e i) (e j))) = rawQuadratic S := by
  simp only [rawQuadratic, map_sum, map_mul, MvPolynomial.rename_C, MvPolynomial.rename_X]
  apply Fintype.sum_equiv e
  intro i
  apply Fintype.sum_equiv e
  intro j
  rfl

def blockCovariance (S : ι → ι → R) (T : κ → κ → R) : (ι ⊕ κ) → (ι ⊕ κ) → R
  | .inl i, .inl j => S i j
  | .inr i, .inr j => T i j
  | _, _ => 0

omit [DecidableEq ι] [DecidableEq κ] in
theorem rawQuadratic_blockCovariance (S : ι → ι → R) (T : κ → κ → R) :
    rawQuadratic (blockCovariance S T) =
      MvPolynomial.rename Sum.inl (rawQuadratic S) +
        MvPolynomial.rename Sum.inr (rawQuadratic T) := by
  simp [rawQuadratic, blockCovariance, Fintype.sum_sum_type, map_sum, map_mul]

end Relabelling

section Field

variable {K E : Type*} [Field K] [AddCommGroup E] [Module K E]

noncomputable def symmetricQuadratic (S : ι → ι → K) : MvPolynomial ι K :=
  MvPolynomial.C ((2 : K)⁻¹) * rawQuadratic S

noncomputable def dividedQuadratic (S : ι → ι → K) (m : ℕ) : MvPolynomial ι K :=
  MvPolynomial.C ((m.factorial : K)⁻¹) * symmetricQuadratic S ^ m

omit [DecidableEq ι] in
theorem symmetricQuadratic_isHomogeneous (S : ι → ι → K) :
    (symmetricQuadratic S).IsHomogeneous 2 :=
  (rawQuadratic_isHomogeneous S).C_mul _

omit [DecidableEq ι] in
theorem dividedQuadratic_rename_equiv {κ : Type*} [Fintype κ] [DecidableEq κ]
    (e : ι ≃ κ) (S : κ → κ → K) (m : ℕ) :
    MvPolynomial.rename e (dividedQuadratic (fun i j => S (e i) (e j)) m) =
      dividedQuadratic S m := by
  simp only [dividedQuadratic, symmetricQuadratic, map_mul, map_pow,
    MvPolynomial.rename_C, rawQuadratic_rename_equiv]

theorem coeff_top_dividedQuadratic (m : ℕ) (S : Slots m → Slots m → K) :
    MvPolynomial.coeff (topExponent (Slots m)) (dividedQuadratic S m) =
      ((2 : K) ^ m * (m.factorial : K))⁻¹ *
        ∑ σ : Equiv.Perm (Slots m), ∏ i : Fin m, S (σ ⟨i, 0⟩) (σ ⟨i, 1⟩) := by
  rw [dividedQuadratic, symmetricQuadratic, mul_pow, ← map_pow,
    MvPolynomial.coeff_C_mul, MvPolynomial.coeff_C_mul, coeff_top_rawQuadratic_pow]
  simp only [mul_inv_rev, inv_pow, mul_assoc]

theorem wickMoment_eq_coeff_dividedQuadratic (B : E →ₗ[K] E →ₗ[K] K)
    (m : ℕ) (v : Slots m → E) :
    wickMoment B m v = MvPolynomial.coeff (topExponent (Slots m))
      (dividedQuadratic (fun i j => B (v i) (v j)) m) := by
  rw [wickMoment_apply, coeff_top_dividedQuadratic]

theorem centeredMoment_eq_coeff_dividedQuadratic (B : E →ₗ[K] E →ₗ[K] K)
    (h : Even (Fintype.card ι)) (v : ι → E) :
    centeredMoment B v = MvPolynomial.coeff (topExponent ι)
      (dividedQuadratic (fun i j => B (v i) (v j)) (Fintype.card ι / 2)) := by
  rw [centeredMoment_of_even B h, wickMoment_eq_coeff_dividedQuadratic]
  rw [← coeff_top_rename_equiv (evenSlotsEquiv h)]
  exact congrArg (MvPolynomial.coeff (topExponent ι))
    (dividedQuadratic_rename_equiv (evenSlotsEquiv h)
      (fun i j => B (v i) (v j)) (Fintype.card ι / 2))

variable [CharZero K]

theorem coeff_top_divided_sum_factorization {κ : Type*} [Fintype κ] [DecidableEq κ]
    (P : MvPolynomial ι K) (Q : MvPolynomial κ K)
    (hP : P.IsHomogeneous 2) (_hQ : Q.IsHomogeneous 2) (m n : ℕ)
    (hm : Fintype.card ι = 2 * m) (_hn : Fintype.card κ = 2 * n) :
    MvPolynomial.coeff (topExponent (ι ⊕ κ))
      (MvPolynomial.C (((m + n).factorial : K)⁻¹) *
        (MvPolynomial.rename Sum.inl P + MvPolynomial.rename Sum.inr Q) ^ (m + n)) =
      MvPolynomial.coeff (topExponent ι) (MvPolynomial.C ((m.factorial : K)⁻¹) * P ^ m) *
        MvPolynomial.coeff (topExponent κ) (MvPolynomial.C ((n.factorial : K)⁻¹) * Q ^ n) := by
  rw [MvPolynomial.coeff_C_mul, coeff_top_sum_rename_pow]
  have hsum : (∑ k ∈ Finset.range (m + n + 1), ((m + n).choose k : K) *
      MvPolynomial.coeff (topExponent ι) (P ^ k) *
      MvPolynomial.coeff (topExponent κ) (Q ^ (m + n - k))) =
      ((m + n).choose m : K) * MvPolynomial.coeff (topExponent ι) (P ^ m) *
        MvPolynomial.coeff (topExponent κ) (Q ^ n) := by
    rw [Finset.sum_eq_single m]
    · simp only [Nat.add_sub_cancel_left]
    · intro k _ hkm
      rw [coeff_top_pow_eq_zero P hP hm hkm, mul_zero, zero_mul]
    · intro h
      exact False.elim (h (Finset.mem_range.mpr (by omega)))
  rw [hsum, MvPolynomial.coeff_C_mul, MvPolynomial.coeff_C_mul]
  have hfac : ((m + n).choose m : K) * (m.factorial : K) * (n.factorial : K) =
      ((m + n).factorial : K) := by
    exact_mod_cast (by simpa only [Nat.add_sub_cancel_left] using
      (Nat.choose_mul_factorial_mul_factorial (show m ≤ m + n by omega)))
  have hm0 : (m.factorial : K) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero m)
  have hn0 : (n.factorial : K) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero n)
  have hmn0 : ((m + n).factorial : K) ≠ 0 :=
    Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero (m + n))
  field_simp
  linear_combination (MvPolynomial.coeff (topExponent ι) (P ^ m) *
    MvPolynomial.coeff (topExponent κ) (Q ^ n)) * hfac

omit [CharZero K] [DecidableEq ι] in
theorem symmetricQuadratic_blockCovariance {κ : Type*} [Fintype κ] [DecidableEq κ]
    (S : ι → ι → K) (T : κ → κ → K) :
    symmetricQuadratic (blockCovariance S T) =
      MvPolynomial.rename Sum.inl (symmetricQuadratic S) +
        MvPolynomial.rename Sum.inr (symmetricQuadratic T) := by
  simp only [symmetricQuadratic, rawQuadratic_blockCovariance, map_mul,
    MvPolynomial.rename_C, mul_add]

theorem coeff_top_divided_blockCovariance {κ : Type*} [Fintype κ] [DecidableEq κ]
    (S : ι → ι → K) (T : κ → κ → K) (m n : ℕ)
    (hm : Fintype.card ι = 2 * m) (hn : Fintype.card κ = 2 * n) :
    MvPolynomial.coeff (topExponent (ι ⊕ κ)) (dividedQuadratic (blockCovariance S T) (m + n)) =
      MvPolynomial.coeff (topExponent ι) (dividedQuadratic S m) *
        MvPolynomial.coeff (topExponent κ) (dividedQuadratic T n) := by
  simp only [dividedQuadratic, symmetricQuadratic_blockCovariance]
  exact coeff_top_divided_sum_factorization _ _ (symmetricQuadratic_isHomogeneous S)
    (symmetricQuadratic_isHomogeneous T) m n hm hn

omit [CharZero K] in

theorem coeff_top_divided_blockCovariance_of_odd {κ : Type*}
    [Fintype κ] [DecidableEq κ] (S : ι → ι → K) (T : κ → κ → K)
    (hodd : ¬Even (Fintype.card ι)) (m : ℕ) :
    MvPolynomial.coeff (topExponent (ι ⊕ κ))
      (dividedQuadratic (blockCovariance S T) m) = 0 := by
  rw [dividedQuadratic, symmetricQuadratic_blockCovariance,
    MvPolynomial.coeff_C_mul, coeff_top_sum_rename_pow]
  simp only [coeff_top_pow_eq_zero_of_odd _ (symmetricQuadratic_isHomogeneous S) hodd,
    mul_zero, zero_mul, Finset.sum_const_zero]

omit [CharZero K] in

theorem centeredMoment_relabel {κ : Type*} [Fintype κ] [DecidableEq κ]
    (B : E →ₗ[K] E →ₗ[K] K) (e : ι ≃ κ) (v : κ → E) :
    centeredMoment B (fun i => v (e i)) = centeredMoment B v := by
  have hc := Fintype.card_congr e
  by_cases h : Even (Fintype.card ι)
  · have hk : Even (Fintype.card κ) := hc ▸ h
    rw [centeredMoment_eq_coeff_dividedQuadratic B h,
      centeredMoment_eq_coeff_dividedQuadratic B hk]
    rw [← coeff_top_rename_equiv e]
    rw [dividedQuadratic_rename_equiv e (fun i j => B (v i) (v j)), hc]
  · have hk : ¬Even (Fintype.card κ) := by simpa only [hc] using h
    simp only [centeredMoment_of_not_even _ h, centeredMoment_of_not_even _ hk]

theorem centeredMoment_independent_replicas {κ : Type*} [Fintype κ] [DecidableEq κ]
    (B : E →ₗ[K] E →ₗ[K] K) (v : ι → E) (w : κ → E) :
    centeredMoment (replicaCovariance B)
      (Sum.elim (fun i => (v i, (0 : E))) (fun j => ((0 : E), w j))) =
      centeredMoment B v * centeredMoment B w := by
  have hcov : (fun i j => replicaCovariance B
      (Sum.elim (fun i => (v i, (0 : E))) (fun j => ((0 : E), w j)) i)
      (Sum.elim (fun i => (v i, (0 : E))) (fun j => ((0 : E), w j)) j)) =
      blockCovariance (fun i j => B (v i) (v j)) (fun i j => B (w i) (w j)) := by
    funext i j
    cases i <;> cases j <;> simp [blockCovariance]
  by_cases hi : Even (Fintype.card ι)
  · by_cases hk : Even (Fintype.card κ)
    · have hi' : Fintype.card ι = 2 * (Fintype.card ι / 2) := by
        obtain ⟨m, hm⟩ := hi
        omega
      have hk' : Fintype.card κ = 2 * (Fintype.card κ / 2) := by
        obtain ⟨m, hm⟩ := hk
        omega
      have hsum : Even (Fintype.card (ι ⊕ κ)) := by
        rw [Fintype.card_sum]
        exact hi.add hk
      have hhalf : Fintype.card (ι ⊕ κ) / 2 =
          Fintype.card ι / 2 + Fintype.card κ / 2 := by
        rw [Fintype.card_sum]
        omega
      rw [centeredMoment_eq_coeff_dividedQuadratic _ hsum, hcov, hhalf,
        coeff_top_divided_blockCovariance _ _ _ _ hi' hk',
        centeredMoment_eq_coeff_dividedQuadratic B hi,
        centeredMoment_eq_coeff_dividedQuadratic B hk]
    · have hs : ¬Even (Fintype.card (ι ⊕ κ)) := by
        simp only [Fintype.card_sum]
        intro h
        exact hk ((Nat.even_add.mp h).mp hi)
      simp only [centeredMoment_of_not_even _ hs,
        centeredMoment_of_not_even _ hk, mul_zero]
  · by_cases hs : Even (Fintype.card (ι ⊕ κ))
    · rw [centeredMoment_eq_coeff_dividedQuadratic _ hs, hcov,
        coeff_top_divided_blockCovariance_of_odd _ _ hi,
        centeredMoment_of_not_even _ hi, zero_mul]
    · simp only [centeredMoment_of_not_even _ hs,
        centeredMoment_of_not_even _ hi, zero_mul]

end Field

end Krenn.WickCoefficientBridge

-- formal/all-orders/WickRootBridge.lean

namespace Krenn.WickRootBridge

open scoped BigOperators Classical
open WickCovariance WickCoefficientBridge

variable {R ι : Type*} [CommRing R] [Fintype ι] [DecidableEq ι]

noncomputable def linearPolynomial (μ : ι → R) : MvPolynomial ι R :=
  ∑ i, MvPolynomial.C (μ i) * MvPolynomial.X i

omit [DecidableEq ι] in
theorem linearPolynomial_isHomogeneous (μ : ι → R) :
    (linearPolynomial μ).IsHomogeneous 1 := by
  apply MvPolynomial.IsHomogeneous.sum
  intro i _
  exact MvPolynomial.isHomogeneous_C_mul_X _ _

theorem topExponent_multinomial : (topExponent ι).multinomial = (Fintype.card ι).factorial := by
  rw [Finsupp.multinomial_eq_of_support_subset (Finset.subset_univ _)]
  simp [Nat.multinomial]

theorem coeff_top_sum_X_pow (k : ℕ) :
    MvPolynomial.coeff (topExponent ι) ((∑ i : ι, MvPolynomial.X i : MvPolynomial ι R) ^ k) =
      if Fintype.card ι = k then ((Fintype.card ι).factorial : R) else 0 := by
  rw [MvPolynomial.coeff_sum_X_pow_of_fintype, topExponent_multinomial]
  have hd : (topExponent ι).sum (fun _ m => m) = Fintype.card ι :=
    topExponent_degree (ι := ι)
  rw [hd]
  split_ifs <;> simp

def auxiliaryCovariance {κ : Type*} (S : ι → ι → R) (μ : ι → R) :
    (ι ⊕ κ) → (ι ⊕ κ) → R
  | .inl i, .inl j => S i j
  | .inl i, .inr _ => μ i
  | .inr _, .inl j => μ j
  | .inr _, .inr _ => 0

omit [DecidableEq ι] in
theorem rawQuadratic_auxiliaryCovariance {κ : Type*} [Fintype κ]
    (S : ι → ι → R) (μ : ι → R) :
    rawQuadratic (auxiliaryCovariance (κ := κ) S μ) =
      MvPolynomial.rename Sum.inl (rawQuadratic S) +
        2 * (MvPolynomial.rename Sum.inl (linearPolynomial μ) *
          MvPolynomial.rename Sum.inr (∑ i : κ, MvPolynomial.X i)) := by
  have hmul : MvPolynomial.rename Sum.inl (linearPolynomial μ) *
      MvPolynomial.rename Sum.inr (∑ i : κ, MvPolynomial.X i) =
      ∑ i : ι, ∑ j : κ,
        MvPolynomial.C (μ i) * MvPolynomial.X (Sum.inl i) * MvPolynomial.X (Sum.inr j) := by
    simp only [linearPolynomial, map_sum, map_mul, MvPolynomial.rename_C,
      MvPolynomial.rename_X, Finset.sum_mul, Finset.mul_sum]
    exact Finset.sum_comm
  rw [hmul]
  simp only [rawQuadratic, auxiliaryCovariance, Fintype.sum_sum_type,
    MvPolynomial.C_0, zero_mul, Finset.sum_const_zero, add_zero,
    map_sum, map_mul, MvPolynomial.rename_C, MvPolynomial.rename_X,
    Finset.sum_add_distrib]
  rw [Finset.sum_comm (f := fun j : κ => fun i : ι =>
    MvPolynomial.C (μ i) * MvPolynomial.X (Sum.inr j) * MvPolynomial.X (Sum.inl i))]
  have hcross : (∑ i : ι, ∑ j : κ,
      MvPolynomial.C (μ i) * MvPolynomial.X (Sum.inr j) * MvPolynomial.X (Sum.inl i)) =
      ∑ i : ι, ∑ j : κ,
      MvPolynomial.C (μ i) * MvPolynomial.X (Sum.inl i) * MvPolynomial.X (Sum.inr j) := by
    apply Finset.sum_congr rfl
    intro i _
    apply Finset.sum_congr rfl
    intro j _
    ring
  rw [hcross]
  ring

section Field

variable {K : Type*} [Field K] [CharZero K]

omit [DecidableEq ι] in

theorem symmetricQuadratic_auxiliaryCovariance {κ : Type*} [Fintype κ]
    (S : ι → ι → K) (μ : ι → K) :
    symmetricQuadratic (auxiliaryCovariance (κ := κ) S μ) =
      MvPolynomial.rename Sum.inl (symmetricQuadratic S) +
        MvPolynomial.rename Sum.inl (linearPolynomial μ) *
          MvPolynomial.rename Sum.inr (∑ i : κ, MvPolynomial.X i) := by
  rw [symmetricQuadratic, rawQuadratic_auxiliaryCovariance]
  simp only [symmetricQuadratic, map_mul, MvPolynomial.rename_C, mul_add]
  have htwo : (MvPolynomial.C ((2 : K)⁻¹) : MvPolynomial (ι ⊕ κ) K) * 2 = 1 := by
    rw [show (2 : MvPolynomial (ι ⊕ κ) K) = MvPolynomial.C (2 : K) from
        (map_ofNat MvPolynomial.C 2).symm,
      ← map_mul, inv_mul_cancel₀ (by norm_num : (2 : K) ≠ 0), map_one]
  linear_combination (MvPolynomial.rename Sum.inl (linearPolynomial μ) *
    MvPolynomial.rename Sum.inr (∑ i : κ, MvPolynomial.X i)) * htwo

theorem coeff_top_auxiliary_root {κ : Type*} [Fintype κ] [DecidableEq κ]
    (Q L : MvPolynomial ι K) (k d : ℕ) (hd : Fintype.card κ = d) :
    MvPolynomial.coeff (topExponent (ι ⊕ κ))
      (MvPolynomial.C (((k + d).factorial : K)⁻¹) *
        (MvPolynomial.rename Sum.inl Q +
          MvPolynomial.rename Sum.inl L *
            MvPolynomial.rename Sum.inr (∑ i : κ, MvPolynomial.X i)) ^ (k + d)) =
      MvPolynomial.coeff (topExponent ι)
        (MvPolynomial.C ((k.factorial : K)⁻¹) * L ^ d * Q ^ k) := by
  rw [MvPolynomial.coeff_C_mul, add_comm (MvPolynomial.rename Sum.inl Q), add_pow,
    MvPolynomial.coeff_sum]
  have hterm : ∀ j : ℕ,
      MvPolynomial.coeff (topExponent (ι ⊕ κ))
        (((MvPolynomial.rename Sum.inl L *
            MvPolynomial.rename Sum.inr (∑ i : κ, MvPolynomial.X i)) ^ j *
          (MvPolynomial.rename Sum.inl Q) ^ (k + d - j)) *
          ((k + d).choose j : MvPolynomial (ι ⊕ κ) K)) =
        ((k + d).choose j : K) *
          MvPolynomial.coeff (topExponent ι) (L ^ j * Q ^ (k + d - j)) *
            (if d = j then (d.factorial : K) else 0) := by
    intro j
    rw [show ((k + d).choose j : MvPolynomial (ι ⊕ κ) K) =
        MvPolynomial.C ((k + d).choose j : K) by simp]
    rw [mul_comm (_ * _), MvPolynomial.coeff_C_mul]
    have hpoly : ((MvPolynomial.rename Sum.inl L *
        MvPolynomial.rename Sum.inr (∑ i : κ, MvPolynomial.X i)) ^ j *
        (MvPolynomial.rename Sum.inl Q) ^ (k + d - j)) =
        MvPolynomial.rename Sum.inl (L ^ j * Q ^ (k + d - j)) *
          MvPolynomial.rename Sum.inr ((∑ i : κ, MvPolynomial.X i) ^ j) := by
      simp only [mul_pow, map_mul, map_pow]
      ring
    rw [hpoly, coeff_top_rename_mul_rename, coeff_top_sum_X_pow, hd]
    ring
  simp_rw [hterm]
  rw [Finset.sum_eq_single d]
  · simp only [Nat.add_sub_cancel_right, eq_self, ↓reduceIte]
    rw [mul_assoc (MvPolynomial.C _) (L ^ d), MvPolynomial.coeff_C_mul]
    have hfac : ((k + d).choose d : K) * (d.factorial : K) * (k.factorial : K) =
        ((k + d).factorial : K) := by
      exact_mod_cast (by simpa only [Nat.add_sub_cancel_right] using
        (Nat.choose_mul_factorial_mul_factorial (show d ≤ k + d by omega)))
    have hk0 : (k.factorial : K) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero k)
    have hkd0 : ((k + d).factorial : K) ≠ 0 :=
      Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero (k + d))
    field_simp
    linear_combination MvPolynomial.coeff (topExponent ι) (L ^ d * Q ^ k) * hfac
  · intro j _ hj
    rw [if_neg (Ne.symm hj), mul_zero]
  · intro h
    exact False.elim (h (Finset.mem_range.mpr (by omega)))

theorem centeredMoment_isotropic_roots {κ E : Type*}
    [Fintype κ] [DecidableEq κ] [AddCommGroup E] [Module K E]
    (B : E →ₗ[K] E →ₗ[K] K) (v : ι → E) (g : E)
    (k d : ℕ) (hi : Fintype.card ι = 2 * k + d) (hd : Fintype.card κ = d)
    (hgg : B g g = 0) (hcross : ∀ i, B (v i) g = B g (v i)) :
    centeredMoment B (Sum.elim v (fun _ : κ => g)) =
      MvPolynomial.coeff (topExponent ι)
        (MvPolynomial.C ((k.factorial : K)⁻¹) *
          linearPolynomial (fun i => B g (v i)) ^ d *
            symmetricQuadratic (fun i j => B (v i) (v j)) ^ k) := by
  have heven : Even (Fintype.card (ι ⊕ κ)) := by
    refine ⟨k + d, ?_⟩
    simp only [Fintype.card_sum, hi, hd]
    omega
  have hhalf : Fintype.card (ι ⊕ κ) / 2 = k + d := by
    simp only [Fintype.card_sum, hi, hd]
    omega
  have hcov : (fun i j => B (Sum.elim v (fun _ : κ => g) i)
      (Sum.elim v (fun _ : κ => g) j)) =
      auxiliaryCovariance (fun i j => B (v i) (v j)) (fun i => B g (v i)) := by
    funext i j
    cases i <;> cases j <;> simp [auxiliaryCovariance, hgg, hcross]
  rw [centeredMoment_eq_coeff_dividedQuadratic _ heven, hcov, hhalf,
    dividedQuadratic, symmetricQuadratic_auxiliaryCovariance,
    coeff_top_auxiliary_root _ _ k d hd]

end Field

end Krenn.WickRootBridge

-- formal/all-orders/WickShiftedBridge.lean

namespace Krenn.WickShiftedBridge

open scoped BigOperators Classical
open WickCovariance WickCoefficientBridge WickRootBridge

variable {R ι : Type*} [CommRing R] [Fintype ι] [DecidableEq ι]

noncomputable def subsetExponent (s : Finset ι) : ι →₀ ℕ :=
  ∑ i ∈ s, Finsupp.single i 1

omit [Fintype ι] in
@[simp]
theorem subsetExponent_apply (s : Finset ι) (i : ι) :
    subsetExponent s i = if i ∈ s then 1 else 0 := by
  simp [subsetExponent, Finsupp.single_apply, Finset.sum_ite_eq']

omit [Fintype ι] in
@[simp]
theorem subsetExponent_support (s : Finset ι) : (subsetExponent s).support = s := by
  ext i
  simp

theorem subsetExponent_sum_compl (s : Finset ι) :
    subsetExponent s + subsetExponent sᶜ = topExponent ι := by
  ext i
  by_cases hi : i ∈ s <;> simp [hi]

omit [Fintype ι] in
theorem subsetExponent_injective : Function.Injective (subsetExponent (ι := ι)) := by
  intro s t h
  simpa using congrArg Finsupp.support h

theorem subsetExponent_degree (s : Finset ι) : (subsetExponent s).degree = s.card := by
  rw [Finsupp.degree_eq_sum]
  simp [Finset.sum_const]

theorem antidiagonal_top_eq :
    Finset.HasAntidiagonal.antidiagonal (topExponent ι) =
      Finset.univ.image (fun s : Finset ι => (subsetExponent s, subsetExponent sᶜ)) := by
  ext ⟨a, b⟩
  simp only [Finset.HasAntidiagonal.mem_antidiagonal, Finset.mem_image, Finset.mem_univ, true_and,
    Prod.mk.injEq]
  constructor
  · intro h
    refine ⟨a.support, ?_, ?_⟩
    · ext i
      have hi := congrArg (fun f : ι →₀ ℕ => f i) h
      simp only [Finsupp.add_apply, topExponent_apply] at hi
      by_cases ha : a i = 0
      · simp [ha]
      · simp [ha]
        omega
    · ext i
      have hi := congrArg (fun f : ι →₀ ℕ => f i) h
      simp only [Finsupp.add_apply, topExponent_apply] at hi
      by_cases ha : a i = 0
      · simp [ha]
        omega
      · simp [ha]
        omega
  · rintro ⟨s, rfl, rfl⟩
    exact subsetExponent_sum_compl s

theorem coeff_top_mul (P Q : MvPolynomial ι R) :
    MvPolynomial.coeff (topExponent ι) (P * Q) =
      ∑ s : Finset ι, MvPolynomial.coeff (subsetExponent s) P *
        MvPolynomial.coeff (subsetExponent sᶜ) Q := by
  rw [MvPolynomial.coeff_mul, antidiagonal_top_eq, Finset.sum_image]
  intro s _ t _ h
  exact subsetExponent_injective (congrArg Prod.fst h)

omit [Fintype ι] in

theorem subsetExponent_mapDomain (s : Finset ι) :
    (topExponent {i // i ∈ s}).mapDomain Subtype.val = subsetExponent s := by
  ext i
  by_cases hi : i ∈ s
  · rw [show i = (⟨i, hi⟩ : {i // i ∈ s}).val from rfl,
      Finsupp.mapDomain_apply Subtype.val_injective]
    simp [hi]
  · rw [Finsupp.mapDomain_of_notMem_range]
    · simp [hi]
    · simpa using hi

omit [Fintype ι] in

theorem coeff_subset_eq_restrict (s : Finset ι) (P : MvPolynomial ι R) :
    MvPolynomial.coeff (subsetExponent s) P =
      MvPolynomial.coeff (topExponent {i // i ∈ s})
        (MvPolynomial.killCompl (Subtype.val_injective (p := fun i => i ∈ s)) P) := by
  rw [MvPolynomial.coeff_killCompl, subsetExponent_mapDomain]

omit [Fintype ι] in
theorem subsetExponent_multinomial (s : Finset ι) :
    (subsetExponent s).multinomial = s.card.factorial := by
  rw [Finsupp.multinomial_eq, subsetExponent_support]
  have hp : (∏ i ∈ s, (subsetExponent s i).factorial) = 1 := by
    apply Finset.prod_eq_one
    intro i hi
    simp [hi]
  simp only [Nat.multinomial, hp, Nat.div_one]
  congr 1
  simp

theorem coeff_subset_linearPolynomial_pow (μ : ι → R) (s : Finset ι) (d : ℕ) :
    MvPolynomial.coeff (subsetExponent s) (linearPolynomial μ ^ d) =
      if s.card = d then (s.card.factorial : R) * ∏ i ∈ s, μ i else 0 := by
  have hlin : linearPolynomial μ = ∑ i : ι, μ i • (MvPolynomial.X i : MvPolynomial ι R) := by
    simp only [linearPolynomial, MvPolynomial.smul_eq_C_mul]
  rw [hlin, MvPolynomial.coeff_linearCombination_X_pow_of_fintype,
    subsetExponent_multinomial]
  have hdeg : (subsetExponent s).sum (fun _ m => m) = s.card := subsetExponent_degree s
  rw [hdeg]
  split_ifs
  · simp [Finsupp.prod]
  · rfl

omit [Fintype ι] [DecidableEq ι] in
theorem restrict_X_of_mem (s : Finset ι) (i : ι) (hi : i ∈ s) :
    MvPolynomial.killCompl (Subtype.val_injective (p := fun i => i ∈ s))
      (MvPolynomial.X i : MvPolynomial ι R) = MvPolynomial.X (⟨i, hi⟩ : {i // i ∈ s}) := by
  have hrename : (MvPolynomial.X i : MvPolynomial ι R) =
      MvPolynomial.rename Subtype.val (MvPolynomial.X (⟨i, hi⟩ : {i // i ∈ s})) := by simp
  rw [hrename, MvPolynomial.killCompl_rename_app]

omit [Fintype ι] [DecidableEq ι] in
theorem restrict_X_of_not_mem (s : Finset ι) (i : ι) (hi : i ∉ s) :
    MvPolynomial.killCompl (Subtype.val_injective (p := fun i => i ∈ s))
      (MvPolynomial.X i : MvPolynomial ι R) = 0 := by
  apply MvPolynomial.killCompl_monomial_eq_zero_of_notMem_range (a := i)
  · simp
  · simpa using hi

theorem sum_restrict_support {A : Type*} [AddCommMonoid A]
    (s : Finset ι) (f : ι → A) (hz : ∀ i, i ∉ s → f i = 0) :
    (∑ i : ι, f i) = ∑ i : {i // i ∈ s}, f i := by
  rw [← Fintype.sum_subtype_add_sum_subtype (fun i => i ∈ s) f]
  rw [show (∑ i : {i // i ∉ s}, f i) = 0 from
    Finset.sum_eq_zero (fun i _ => hz i i.property), add_zero]
  congr!

theorem restrict_rawQuadratic (s : Finset ι) (S : ι → ι → R) :
    MvPolynomial.killCompl (Subtype.val_injective (p := fun i => i ∈ s)) (rawQuadratic S) =
      rawQuadratic (fun i j : {i // i ∈ s} => S i j) := by
  simp only [rawQuadratic, map_sum, map_mul, MvPolynomial.killCompl_C]
  rw [sum_restrict_support s _ (by
    intro i hi
    simp only [restrict_X_of_not_mem s i hi, mul_zero, zero_mul, Finset.sum_const_zero])]
  apply Finset.sum_congr rfl
  intro i _
  rw [sum_restrict_support s _ (by
    intro j hj
    simp only [restrict_X_of_not_mem s j hj, mul_zero])]
  apply Finset.sum_congr rfl
  intro j _
  rw [restrict_X_of_mem s i i.property, restrict_X_of_mem s j j.property]

section Field

variable {K E : Type*} [Field K] [CharZero K] [AddCommGroup E] [Module K E]

omit [CharZero K] in
theorem restrict_dividedQuadratic (s : Finset ι) (S : ι → ι → K) (k : ℕ) :
    MvPolynomial.killCompl (Subtype.val_injective (p := fun i => i ∈ s)) (dividedQuadratic S k) =
      dividedQuadratic (fun i j : {i // i ∈ s} => S i j) k := by
  simp only [dividedQuadratic, symmetricQuadratic, map_mul, map_pow,
    MvPolynomial.killCompl_C, restrict_rawQuadratic]

omit [CharZero K] in

theorem coeff_subset_dividedQuadratic (B : E →ₗ[K] E →ₗ[K] K) (v : ι → E)
    (s : Finset ι) (k : ℕ) (hk : s.card = 2 * k) :
    MvPolynomial.coeff (subsetExponent s) (dividedQuadratic (fun i j => B (v i) (v j)) k) =
      centeredMoment B (fun i : {i // i ∈ s} => v i) := by
  have hc : Fintype.card {i // i ∈ s} = 2 * k := by simpa using hk
  have heven : Even (Fintype.card {i // i ∈ s}) := ⟨k, by omega⟩
  rw [coeff_subset_eq_restrict, restrict_dividedQuadratic,
    centeredMoment_eq_coeff_dividedQuadratic _ heven]
  rw [hc, Nat.mul_div_right k (by omega : 0 < 2)]

omit [CharZero K] in

theorem coeff_subset_dividedQuadratic_of_ne (S : ι → ι → K)
    (s : Finset ι) (k : ℕ) (hk : s.card ≠ 2 * k) :
    MvPolynomial.coeff (subsetExponent s) (dividedQuadratic S k) = 0 := by
  apply ((symmetricQuadratic_isHomogeneous S).pow k).C_mul _ |>.coeff_eq_zero
  rw [subsetExponent_degree]
  omega

noncomputable def meanSlice (B : E →ₗ[K] E →ₗ[K] K) (μ : E →ₗ[K] K)
    (d : ℕ) (v : ι → E) : K :=
  ∑ s : Finset ι, if s.card = d then shiftedTerm B μ s v else 0

omit [DecidableEq ι] in

theorem meanSlice_eq_coeff (B : E →ₗ[K] E →ₗ[K] K) (μ : E →ₗ[K] K)
    (v : ι → E) (d k : ℕ) (hcard : Fintype.card ι = d + 2 * k) :
    meanSlice B μ d v =
      MvPolynomial.coeff (topExponent ι)
        (MvPolynomial.C ((d.factorial : K)⁻¹) *
          linearPolynomial (fun i => μ (v i)) ^ d *
            dividedQuadratic (fun i j => B (v i) (v j)) k) := by
  classical
  rw [meanSlice, mul_assoc, MvPolynomial.coeff_C_mul, coeff_top_mul, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro s _
  rw [coeff_subset_linearPolynomial_pow]
  by_cases hs : s.card = d
  · rw [if_pos hs, if_pos hs]
    have hcompl : sᶜ.card = 2 * k := by
      rw [Finset.card_compl, hs, hcard]
      omega
    rw [coeff_subset_dividedQuadratic B v sᶜ k hcompl, shiftedTerm_apply]
    rw [← Finset.prod_subtype (p := fun i => i ∈ s) s (fun _ => Iff.rfl)
      (fun i => μ (v i))]
    simp only [hs]
    have hd0 : (d.factorial : K) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero d)
    field_simp
    congr 1
    exact centeredMoment_relabel B
      (Equiv.subtypeEquivRight (fun i : ι => (Finset.mem_compl (s := s) (a := i)).symm))
      (fun i : {i // i ∈ sᶜ} => v i)
  · rw [if_neg hs, if_neg hs]
    simp

omit [DecidableEq ι] [CharZero K] in

theorem shiftedMoment_eq_sum_meanSlice (B : E →ₗ[K] E →ₗ[K] K)
    (μ : E →ₗ[K] K) (v : ι → E) :
    shiftedMoment B μ v = ∑ d ∈ Finset.range (Fintype.card ι + 1), meanSlice B μ d v := by
  simp only [shiftedMoment_apply, meanSlice, shiftedTerm_apply]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro s _
  rw [Finset.sum_eq_single s.card]
  · simp
  · intro d _ hd
    rw [if_neg (Ne.symm hd)]
  · intro h
    exact False.elim (h (Finset.mem_range.mpr (by have := Finset.card_le_univ s; omega)))

omit [CharZero K] [DecidableEq ι] in

theorem meanSlice_eq_zero_of_odd (B : E →ₗ[K] E →ₗ[K] K) (μ : E →ₗ[K] K)
    (v : ι → E) (d : ℕ) (hodd : ¬Even (Fintype.card ι - d)) :
    meanSlice B μ d v = 0 := by
  classical
  apply Finset.sum_eq_zero
  intro s _
  split_ifs with hs
  · rw [shiftedTerm_apply]
    have hc : Fintype.card {i // i ∉ s} = Fintype.card ι - d := by
      simpa only [Finset.mem_compl, Fintype.card_coe, Finset.card_compl, hs] using
        (show Fintype.card {i // i ∈ sᶜ} = sᶜ.card from Fintype.card_coe sᶜ)
    rw [centeredMoment_of_not_even B (by simpa only [hc] using hodd), mul_zero]
  · rfl

omit [DecidableEq ι] in

theorem shiftedMoment_eq_coeff_sum (B : E →ₗ[K] E →ₗ[K] K)
    (μ : E →ₗ[K] K) (v : ι → E) :
    shiftedMoment B μ v =
      ∑ d ∈ Finset.range (Fintype.card ι + 1),
        if Even (Fintype.card ι - d) then
          MvPolynomial.coeff (topExponent ι)
            (MvPolynomial.C ((d.factorial : K)⁻¹) *
              linearPolynomial (fun i => μ (v i)) ^ d *
                dividedQuadratic (fun i j => B (v i) (v j)) ((Fintype.card ι - d) / 2))
        else 0 := by
  rw [shiftedMoment_eq_sum_meanSlice]
  apply Finset.sum_congr rfl
  intro d hd
  by_cases heven : Even (Fintype.card ι - d)
  · rw [if_pos heven]
    apply meanSlice_eq_coeff
    have hdn : d ≤ Fintype.card ι := by simpa using Finset.mem_range.mp hd
    obtain ⟨k, hk⟩ := heven
    omega
  · rw [if_neg heven, meanSlice_eq_zero_of_odd B μ v d heven]

end Field

end Krenn.WickShiftedBridge

-- formal/all-orders/WickReplicaBridge.lean

namespace Krenn.WickReplicaBridge

open scoped BigOperators Classical
open WickCovariance WickCoefficientBridge WickShiftedBridge

variable {K E ι κ : Type*} [Field K] [CharZero K]
  [AddCommGroup E] [Module K E] [Fintype ι] [Fintype κ]

def replicaMean (μ ν : E →ₗ[K] K) : (E × E) →ₗ[K] K :=
  μ.comp (LinearMap.fst K E E) + ν.comp (LinearMap.snd K E E)

omit [CharZero K] in
@[simp]
theorem replicaMean_apply (μ ν : E →ₗ[K] K) (x : E × E) :
    replicaMean μ ν x = μ x.1 + ν x.2 := rfl

def complementSumEquiv (s : Finset ι) (t : Finset κ) :
    {z : ι ⊕ κ // z ∉ s.disjSum t} ≃ ({i : ι // i ∉ s} ⊕ {j : κ // j ∉ t}) :=
  Equiv.subtypeSum.trans (Equiv.sumCongr
    (Equiv.subtypeEquivRight (fun _ => not_congr Finset.inl_mem_disjSum))
    (Equiv.subtypeEquivRight (fun _ => not_congr Finset.inr_mem_disjSum)))

theorem centered_complement_independent (B : E →ₗ[K] E →ₗ[K] K)
    (v : ι → E) (w : κ → E) (s : Finset ι) (t : Finset κ) :
    centeredMoment (replicaCovariance B)
      (fun z : {z : ι ⊕ κ // z ∉ s.disjSum t} =>
        Sum.elim (fun i => (v i, (0 : E))) (fun j => ((0 : E), w j)) z.val) =
      centeredMoment B (fun i : {i // i ∉ s} => v i) *
        centeredMoment B (fun j : {j // j ∉ t} => w j) := by
  rw [← centeredMoment_relabel (replicaCovariance B) (complementSumEquiv s t).symm]
  have hfun : (fun i => Sum.elim (fun i => (v i, (0 : E)))
      (fun j => ((0 : E), w j)) ((complementSumEquiv s t).symm i).val) =
      Sum.elim (fun i : {i // i ∉ s} => (v i, (0 : E)))
        (fun j : {j // j ∉ t} => ((0 : E), w j)) := by
    funext i
    cases i <;> rfl
  rw [hfun]
  exact centeredMoment_independent_replicas B _ _

theorem shiftedTerm_independent_replicas (B : E →ₗ[K] E →ₗ[K] K)
    (μ ν : E →ₗ[K] K) (v : ι → E) (w : κ → E) (s : Finset ι) (t : Finset κ) :
    shiftedTerm (replicaCovariance B) (replicaMean μ ν) (s.disjSum t)
      (Sum.elim (fun i => (v i, (0 : E))) (fun j => ((0 : E), w j))) =
      shiftedTerm B μ s v * shiftedTerm B ν t w := by
  rw [shiftedTerm_apply, shiftedTerm_apply, shiftedTerm_apply]
  have hc := centered_complement_independent B v w s t
  let : DecidableEq (ι ⊕ κ) := Classical.decEq _
  have hc' : centeredMoment (replicaCovariance B)
      (fun i : {i : ι ⊕ κ // i ∉ s.disjSum t} =>
        Sum.elim (fun i => (v i, (0 : E))) (fun j => ((0 : E), w j)) i.val) =
      centeredMoment B (fun i : {i // i ∉ s} => v i) *
        centeredMoment B (fun j : {j // j ∉ t} => w j) := by
    convert hc using 1
    congr!
  rw [hc']
  rw [← Finset.prod_subtype (s.disjSum t) (fun _ => Iff.rfl)
    (fun z => replicaMean μ ν
      (Sum.elim (fun i => (v i, (0 : E))) (fun j => ((0 : E), w j)) z))]
  rw [Finset.prod_disjSum]
  simp only [Sum.elim_inl, Sum.elim_inr, replicaMean_apply, map_zero, add_zero, zero_add]
  rw [← Finset.prod_subtype s (fun _ => Iff.rfl) (fun i => μ (v i)),
    ← Finset.prod_subtype t (fun _ => Iff.rfl) (fun j => ν (w j))]
  ring

theorem shiftedMoment_independent_replicas (B : E →ₗ[K] E →ₗ[K] K)
    (μ ν : E →ₗ[K] K) (v : ι → E) (w : κ → E) :
    shiftedMoment (replicaCovariance B) (replicaMean μ ν)
      (Sum.elim (fun i => (v i, (0 : E))) (fun j => ((0 : E), w j))) =
      shiftedMoment B μ v * shiftedMoment B ν w := by
  simp only [shiftedMoment, sum_apply]
  calc
    _ = ∑ st : Finset ι × Finset κ, shiftedTerm B μ st.1 v * shiftedTerm B ν st.2 w := by
      apply Fintype.sum_equiv Finset.sumEquiv.toEquiv
      intro s
      rw [← Finset.toLeft_disjSum_toRight (u := s), shiftedTerm_independent_replicas]
      simp [Finset.sumEquiv]
    _ = _ := by rw [Fintype.sum_prod_type, Finset.sum_mul_sum]

omit [CharZero K] in

theorem linearPolynomial_rename_equiv (e : ι ≃ κ) (μ : κ → K) :
    MvPolynomial.rename e (WickRootBridge.linearPolynomial (fun i => μ (e i))) =
      WickRootBridge.linearPolynomial μ := by
  simp only [WickRootBridge.linearPolynomial, map_sum, map_mul,
    MvPolynomial.rename_C, MvPolynomial.rename_X]
  exact Fintype.sum_equiv e _ _ (fun _ => rfl)

theorem shiftedMoment_relabel (B : E →ₗ[K] E →ₗ[K] K) (μ : E →ₗ[K] K)
    (e : ι ≃ κ) (v : κ → E) :
    shiftedMoment B μ (fun i => v (e i)) = shiftedMoment B μ v := by
  have hc := Fintype.card_congr e
  rw [shiftedMoment_eq_coeff_sum, shiftedMoment_eq_coeff_sum, hc]
  apply Finset.sum_congr rfl
  intro d _
  split_ifs
  · rw [← coeff_top_rename_equiv e]
    apply congrArg (MvPolynomial.coeff (topExponent κ))
    simp only [map_mul, map_pow, MvPolynomial.rename_C,
      linearPolynomial_rename_equiv e (fun i => μ (v i)),
      dividedQuadratic_rename_equiv e (fun i j => B (v i) (v j))]
  · rfl

theorem shiftedMoment_permute (B : E →ₗ[K] E →ₗ[K] K) (μ : E →ₗ[K] K)
    (τ : Equiv.Perm ι) (v : ι → E) :
    shiftedMoment B μ (fun i => v (τ i)) = shiftedMoment B μ v :=
  shiftedMoment_relabel B μ τ v

end Krenn.WickReplicaBridge

-- formal/all-orders/ResponseFactor.lean

namespace Krenn.ResponseFactor

variable {K σ : Type*} [CommRing K] [IsDomain K]

theorem exists_common_factor (H : σ → MvPolynomial σ K)
    {a b : σ} (hab : a ≠ b)
    (hcross : ∀ i j, MvPolynomial.X i * H j = MvPolynomial.X j * H i) :
    ∃ q : MvPolynomial σ K, ∀ i, H i = MvPolynomial.X i * q := by
  have hd : MvPolynomial.X a ∣ MvPolynomial.X b * H a := by
    rw [← hcross a b]
    exact dvd_mul_right _ _
  have hda : MvPolynomial.X a ∣ H a :=
    (MvPolynomial.X_dvd_mul_iff.mp hd).resolve_left (by simpa using hab)
  obtain ⟨q, hq⟩ := hda
  refine ⟨q, fun i => ?_⟩
  apply mul_left_cancel₀ (MvPolynomial.X_ne_zero (R := K) a)
  calc
    MvPolynomial.X a * H i = MvPolynomial.X i * H a := hcross a i
    _ = MvPolynomial.X a * (MvPolynomial.X i * q) := by rw [hq]; ring

theorem common_factor_unique (H : σ → MvPolynomial σ K) {a : σ}
    {q r : MvPolynomial σ K}
    (hq : H a = MvPolynomial.X a * q) (hr : H a = MvPolynomial.X a * r) : q = r :=
  mul_left_cancel₀ (MvPolynomial.X_ne_zero a) (hq.symm.trans hr)

theorem mixed_response_eq_zero {H f : MvPolynomial σ K}
    (hf : f ≠ 0) (hreflection : f * H = 0) : H = 0 :=
  (mul_eq_zero.mp hreflection).resolve_left hf

end Krenn.ResponseFactor

-- formal/all-orders/FiniteResponseRigidity.lean

namespace Krenn.FiniteResponseRigidity

variable {K σ : Type*} [CommRing K] [IsDomain K]

theorem polynomial_eq_one_of_rescaling_square (p : Polynomial K) (s : K)
    (hs : s ≠ 0) (hzero : p.eval 0 = 1)
    (h : (p.comp (Polynomial.C s * Polynomial.X)) ^ 2 = p) : p = 1 := by
  have hd := congrArg Polynomial.natDegree h
  rw [Polynomial.natDegree_pow, Polynomial.natDegree_comp,
    Polynomial.natDegree_C_mul_X s hs, mul_one] at hd
  have hp : p = Polynomial.C (p.coeff 0) :=
    Polynomial.eq_C_of_natDegree_eq_zero (by omega)
  have hc : p.coeff 0 = 1 := by
    rw [Polynomial.coeff_zero_eq_eval_zero]
    exact hzero
  simpa only [hc, Polynomial.C_1] using hp

noncomputable def lineMap (x : σ → K) : MvPolynomial σ K →+* Polynomial K :=
  MvPolynomial.eval₂Hom Polynomial.C (fun i => Polynomial.C (x i) * Polynomial.X)

noncomputable def scaleVariables (s : K) : MvPolynomial σ K →+* MvPolynomial σ K :=
  MvPolynomial.eval₂Hom MvPolynomial.C (fun i => MvPolynomial.C s * MvPolynomial.X i)

omit [IsDomain K] in
theorem lineMap_scaleVariables (x : σ → K) (s : K) (g : MvPolynomial σ K) :
    lineMap x (scaleVariables s g) =
      (lineMap x g).comp (Polynomial.C s * Polynomial.X) := by
  have hhom : (lineMap x).comp (scaleVariables s) =
      (Polynomial.compRingHom (Polynomial.C s * Polynomial.X)).comp (lineMap x) := by
    ext <;> simp [lineMap, scaleVariables, mul_left_comm]
  exact RingHom.congr_fun hhom g

omit [IsDomain K] in
theorem eval_lineMap (x : σ → K) (t : K) (g : MvPolynomial σ K) :
    (lineMap x g).eval t = MvPolynomial.eval (fun i => x i * t) g := by
  have hhom : (Polynomial.evalRingHom t).comp (lineMap x) =
      MvPolynomial.eval (fun i => x i * t) := by
    ext <;> simp [lineMap]
  exact RingHom.congr_fun hhom g

theorem eq_one_of_rescaling_square [Infinite K] (g : MvPolynomial σ K) (s : K)
    (hs : s ≠ 0) (hzero : MvPolynomial.eval (fun _ => 0) g = 1)
    (h : (scaleVariables s g) ^ 2 = g) : g = 1 := by
  apply MvPolynomial.funext
  intro x
  have hline : lineMap x g = 1 := by
    apply polynomial_eq_one_of_rescaling_square _ s hs
    · simpa only [eval_lineMap, mul_zero] using hzero
    · have hh := congrArg (lineMap x) h
      simpa only [map_pow, lineMap_scaleVariables] using hh
  have hx := congrArg (Polynomial.eval 1) hline
  simpa only [eval_lineMap, mul_one, Polynomial.eval_one, map_one] using hx

end Krenn.FiniteResponseRigidity

-- formal/all-orders/OddResponseVanishing.lean

namespace Krenn.OddResponseVanishing

open scoped BigOperators
open MatchingModel SiteAlgebra RootResponse

variable {K : Type*} {N D : ℕ}

section Ring

variable [CommRing K]

noncomputable def siteScalar : K →+* SiteRing N D K := project.comp MvPolynomial.C

@[simp]
theorem siteScalar_apply (a : K) :
    siteScalar (N := N) (D := D) a = project (MvPolynomial.C a) := rfl

noncomputable def retainedCoefficient (p : V N) (ι : V N → Fin D)
    (q : SiteRing N D K) : K :=
  MvPolynomial.coeff (wordExponent ι ((vertices N).erase p)) (Quotient.out q)

@[simp]
theorem retainedCoefficient_project (p : V N) (ι : V N → Fin D)
    (P : MatchingPolynomial N D K) :
    retainedCoefficient p ι (project P) =
      MvPolynomial.coeff (wordExponent ι ((vertices N).erase p)) P := by
  apply coeff_eq_of_project_eq ι _ ((vertices_nodup N).erase p)
  exact Ideal.Quotient.mk_out (project P)

noncomputable def retainedCoefficientHom (p : V N) (ι : V N → Fin D) :
    SiteRing N D K →+ K where
  toFun := retainedCoefficient p ι
  map_zero' := by
    rw [← map_zero project, retainedCoefficient_project]
    exact MvPolynomial.coeff_zero _
  map_add' := by
    intro q r
    obtain ⟨P, rfl⟩ := Ideal.Quotient.mk_surjective q
    obtain ⟨Q, rfl⟩ := Ideal.Quotient.mk_surjective r
    change retainedCoefficient p ι (project P + project Q) =
      retainedCoefficient p ι (project P) + retainedCoefficient p ι (project Q)
    calc
      _ = retainedCoefficient p ι (project (P + Q)) :=
        congrArg (retainedCoefficient p ι) (map_add project P Q).symm
      _ = _ := by rw [retainedCoefficient_project, MvPolynomial.coeff_add,
        retainedCoefficient_project, retainedCoefficient_project]

theorem retainedCoefficient_scalar_mul (p : V N) (ι : V N → Fin D)
    (a : K) (q : SiteRing N D K) :
    retainedCoefficient p ι (siteScalar a * q) = a * retainedCoefficient p ι q := by
  obtain ⟨P, rfl⟩ := Ideal.Quotient.mk_surjective q
  change retainedCoefficient p ι (project (MvPolynomial.C a) * project P) =
    a * retainedCoefficient p ι (project P)
  calc
    _ = retainedCoefficient p ι (project (MvPolynomial.C a * P)) :=
      congrArg (retainedCoefficient p ι) (map_mul project (MvPolynomial.C a) P).symm
    _ = _ := by rw [retainedCoefficient_project, MvPolynomial.coeff_C_mul,
      retainedCoefficient_project]

abbrev ParameterTensor (N D : ℕ) (K : Type*) [CommRing K] :=
  MvPolynomial (Fin D) (SiteRing N D K)

noncomputable def coefficientPolynomial (p : V N) (ι : V N → Fin D)
    (T : ParameterTensor N D K) : MvPolynomial (Fin D) K :=
  AddMonoidAlgebra.map (retainedCoefficientHom p ι) T

@[simp]
theorem coeff_coefficientPolynomial (p : V N) (ι : V N → Fin D)
    (T : ParameterTensor N D K) (s : Fin D →₀ ℕ) :
    MvPolynomial.coeff s (coefficientPolynomial p ι T) =
      retainedCoefficient p ι (MvPolynomial.coeff s T) :=
  MvPolynomial.coeff_addMonoidAlgebraMap _ _ _

theorem eval_coefficientPolynomial (p : V N) (ι : V N → Fin D)
    (T : ParameterTensor N D K) (a : Fin D → K) :
    MvPolynomial.eval a (coefficientPolynomial p ι T) =
      retainedCoefficient p ι (MvPolynomial.eval (fun i => siteScalar (a i)) T) := by
  classical
  induction T using MvPolynomial.induction_on' with
  | monomial m c =>
    unfold coefficientPolynomial
    have hmap : AddMonoidAlgebra.map (retainedCoefficientHom p ι)
        (MvPolynomial.monomial m c) =
        MvPolynomial.monomial m (retainedCoefficient p ι c) :=
      AddMonoidAlgebra.map_single _ _ _
    rw [hmap, MvPolynomial.eval_monomial, MvPolynomial.eval_monomial]
    have hprod : m.prod (fun i n => siteScalar (N := N) (D := D) (a i) ^ n) =
        siteScalar (m.prod (fun i n => a i ^ n)) := by
      rw [map_finsuppProd]
      simp only [map_pow]
    rw [hprod, mul_comm c, retainedCoefficient_scalar_mul]
    ring
  | add P Q ih ih' =>
    have hadd : retainedCoefficient p ι
        (MvPolynomial.eval (fun i => siteScalar (a i)) P +
          MvPolynomial.eval (fun i => siteScalar (a i)) Q) =
        retainedCoefficient p ι (MvPolynomial.eval (fun i => siteScalar (a i)) P) +
          retainedCoefficient p ι (MvPolynomial.eval (fun i => siteScalar (a i)) Q) :=
      (retainedCoefficientHom p ι).map_add _ _
    simp only [coefficientPolynomial, AddMonoidAlgebra.map_add, map_add] at ih ih' ⊢
    rw [hadd, ih, ih']

theorem coefficientPolynomial_homogeneous (p : V N) (ι : V N → Fin D)
    (T : ParameterTensor N D K) (n : ℕ)
    (hT : MvPolynomial.IsWeightedHomogeneous (fun _ : Fin D => (1 : ℕ)) T n) :
    MvPolynomial.IsWeightedHomogeneous (fun _ : Fin D => (1 : ℕ))
      (coefficientPolynomial p ι T) n := by
  intro m hm
  rw [coeff_coefficientPolynomial] at hm
  apply hT
  intro hz
  rw [hz] at hm
  exact hm ((retainedCoefficientHom p ι).map_zero)

end Ring

section Field

variable [Field K] [CharZero K]

noncomputable def rowAt (W : WeightsN N D K) (p : V N) (a : Fin D → K) :
    MatchingPolynomial N D K := rootFamilyRow W p (fun i => MvPolynomial.C (a i))

noncomputable def oddResponse (W : WeightsN N D K) (p : V N)
    (k r : ℕ) (a : Fin D → K) : SiteRing N D K :=
  if r ≤ k then project (MvPolynomial.C (((k - r).factorial : K)⁻¹) *
    rowAt W p a ^ (2 * r + 1) * deletedQuadratic W p ^ (k - r)) else 0

noncomputable def parameterRow (W : WeightsN N D K) (p : V N) : ParameterTensor N D K :=
  ∑ i : Fin D, MvPolynomial.X i *
    MvPolynomial.C (project (rowPolynomial (edgeMatrix W) (p, i)))

noncomputable def oddResponseTensor (W : WeightsN N D K) (p : V N)
    (k r : ℕ) : ParameterTensor N D K :=
  if r ≤ k then MvPolynomial.C (siteScalar (((k - r).factorial : K)⁻¹)) *
    parameterRow W p ^ (2 * r + 1) *
      MvPolynomial.C (project (deletedQuadratic W p)) ^ (k - r) else 0

noncomputable def oddResponsePolynomial (W : WeightsN N D K) (p : V N)
    (k r : ℕ) (ι : V N → Fin D) : MvPolynomial (Fin D) K :=
  coefficientPolynomial p ι (oddResponseTensor W p k r)

omit [CharZero K] in
theorem eval_parameterRow (W : WeightsN N D K) (p : V N) (a : Fin D → K) :
    MvPolynomial.eval (fun i => siteScalar (N := N) (D := D) (a i)) (parameterRow W p) =
      project (rowAt W p a) := by
  classical
  unfold parameterRow rowAt rootFamilyRow
  simp only [map_sum, map_mul, MvPolynomial.eval_X, MvPolynomial.eval_C, siteScalar_apply]

omit [CharZero K] in

theorem eval_oddResponseTensor (W : WeightsN N D K) (p : V N)
    (k r : ℕ) (a : Fin D → K) :
    MvPolynomial.eval (fun i => siteScalar (N := N) (D := D) (a i))
      (oddResponseTensor W p k r) = oddResponse W p k r a := by
  unfold oddResponseTensor oddResponse
  by_cases hr : r ≤ k
  · rw [if_pos hr, if_pos hr]
    simp only [map_mul, map_pow, MvPolynomial.eval_C]
    rw [eval_parameterRow]
    simp only [siteScalar_apply]
  · rw [if_neg hr, if_neg hr, map_zero]

omit [CharZero K] in

theorem eval_oddResponsePolynomial (W : WeightsN N D K) (p : V N)
    (k r : ℕ) (ι : V N → Fin D) (a : Fin D → K) :
    MvPolynomial.eval a (oddResponsePolynomial W p k r ι) =
      retainedCoefficient p ι (oddResponse W p k r a) := by
  rw [oddResponsePolynomial, eval_coefficientPolynomial, eval_oddResponseTensor]

theorem oddResponse_zero (k : ℕ) (W : WeightsN (2 * (k + 1)) D K)
    (hW : EqSystemN (2 * (k + 1)) D W) (p : V (2 * (k + 1))) (a : Fin D → K) :
    oddResponse W p k 0 a = ∑ i : Fin D, siteScalar (a i) * project (pureRootWord p i) := by
  simp only [oddResponse, Nat.zero_le, if_true, Nat.sub_zero, Nat.mul_zero,
    zero_add, pow_one, rowAt, siteScalar_apply]
  exact rootFamily_response_eq_pure k W hW p _

omit [CharZero K] in

theorem oddResponse_terminal (W : WeightsN N D K) (p : V N) (k : ℕ) (a : Fin D → K) :
    oddResponse W p k k a = project (rowAt W p a ^ (2 * k + 1)) := by
  simp [oddResponse]

omit [CharZero K] in
@[simp]
theorem oddResponse_above_terminal (W : WeightsN N D K) (p : V N)
    (k r : ℕ) (hr : k < r) (a : Fin D → K) : oddResponse W p k r a = 0 := by
  simp [oddResponse, Nat.not_le_of_gt hr]

omit [CharZero K] in

theorem parameterRow_homogeneous (W : WeightsN N D K) (p : V N) :
    MvPolynomial.IsWeightedHomogeneous (fun _ : Fin D => (1 : ℕ)) (parameterRow W p) 1 := by
  classical
  unfold parameterRow
  apply MvPolynomial.IsWeightedHomogeneous.sum
  intro i _
  simpa using
    (MvPolynomial.isWeightedHomogeneous_X (SiteRing N D K) (fun _ : Fin D => (1 : ℕ)) i).mul
      (MvPolynomial.isWeightedHomogeneous_C (fun _ : Fin D => (1 : ℕ))
        (project (rowPolynomial (edgeMatrix W) (p, i))))

omit [CharZero K] in

theorem oddResponseTensor_homogeneous (W : WeightsN N D K) (p : V N) (k r : ℕ) :
    MvPolynomial.IsWeightedHomogeneous (fun _ : Fin D => (1 : ℕ))
      (oddResponseTensor W p k r) (2 * r + 1) := by
  unfold oddResponseTensor
  by_cases hr : r ≤ k
  · rw [if_pos hr]
    simpa [nsmul_eq_mul] using
      ((parameterRow_homogeneous W p).pow (2 * r + 1)).C_mul
        (siteScalar (((k - r).factorial : K)⁻¹)) |>.mul
      ((MvPolynomial.isWeightedHomogeneous_C (fun _ : Fin D => (1 : ℕ))
        (project (deletedQuadratic W p))).pow (k - r))
  · rw [if_neg hr]
    exact MvPolynomial.isWeightedHomogeneous_zero _ _ _

omit [CharZero K] in
theorem oddResponsePolynomial_homogeneous (W : WeightsN N D K) (p : V N)
    (k r : ℕ) (ι : V N → Fin D) :
    MvPolynomial.IsWeightedHomogeneous (fun _ : Fin D => (1 : ℕ))
      (oddResponsePolynomial W p k r ι) (2 * r + 1) :=
  coefficientPolynomial_homogeneous p ι _ _ (oddResponseTensor_homogeneous W p k r)

omit [CharZero K] in

theorem retainedCoefficient_pureRootWord (p q : V N) (hqp : q ≠ p) (h i : Fin D) :
    retainedCoefficient (K := K) p (fun _ => h) (project (pureRootWord (R := K) p i)) =
      if h = i then 1 else 0 := by
  classical
  rw [pureRootWord, retainedCoefficient_project, MvPolynomial.coeff_monomial]
  by_cases hi : h = i
  · simp [hi]
  · have hq : q ∈ (vertices N).erase p :=
      (List.mem_erase_of_ne hqp).mpr (mem_vertices q)
    have hone : wordExponent (fun _ : V N => i) ((vertices N).erase p) (q, i) = 1 := by
      rw [wordExponent_selected, ((vertices_nodup N).erase p).count, if_pos hq]
    have hzero := wordExponent_wrong_color (fun _ : V N => h) ((vertices N).erase p)
      q i (Ne.symm hi)
    have hex : wordExponent (fun _ : V N => i) ((vertices N).erase p) ≠
        wordExponent (fun _ : V N => h) ((vertices N).erase p) := by
      intro heq
      rw [heq, hzero] at hone
      norm_num at hone
    rw [if_neg hex, if_neg hi]

theorem oddResponsePolynomial_zero_pure (k : ℕ) (W : WeightsN (2 * (k + 1)) D K)
    (hW : EqSystemN (2 * (k + 1)) D W) (p : V (2 * (k + 1))) (h : Fin D) :
    oddResponsePolynomial W p k 0 (fun _ => h) = MvPolynomial.X h := by
  classical
  have hlen : ((vertices (2 * (k + 1))).erase p).length = 2 * k + 1 := by
    rw [List.length_erase_of_mem (mem_vertices p)]
    simp
    omega
  have hne : (vertices (2 * (k + 1))).erase p ≠ [] := by
    intro hh
    rw [hh] at hlen
    simp at hlen
  obtain ⟨q, hq⟩ := List.exists_mem_of_ne_nil _ hne
  have hqp : q ≠ p := by
    intro hh
    subst q
    exact (vertices_nodup _).not_mem_erase hq
  apply MvPolynomial.funext
  intro a
  rw [eval_oddResponsePolynomial, oddResponse_zero k W hW p a, MvPolynomial.eval_X]
  have hsum : retainedCoefficient p (fun _ => h)
      (∑ i : Fin D, siteScalar (a i) * project (pureRootWord p i)) =
      ∑ i : Fin D, retainedCoefficient p (fun _ => h)
        (siteScalar (a i) * project (pureRootWord p i)) :=
      map_sum (retainedCoefficientHom p (fun _ => h)) _ _
  rw [hsum]
  simp_rw [retainedCoefficient_scalar_mul, retainedCoefficient_pureRootWord p q hqp]
  simp

omit [CharZero K] in

theorem pure_response_common_factor (W : WeightsN N D K) (p : V N) (k r : ℕ)
    {a b : Fin D} (hab : a ≠ b)
    (hreflection : ∀ i j : Fin D,
      MvPolynomial.X i * oddResponsePolynomial W p k r (fun _ => j) =
        MvPolynomial.X j * oddResponsePolynomial W p k r (fun _ => i)) :
    ∃ q : MvPolynomial (Fin D) K, ∀ i : Fin D,
      oddResponsePolynomial W p k r (fun _ => i) = MvPolynomial.X i * q :=
  ResponseFactor.exists_common_factor _ hab hreflection

omit [CharZero K] in

theorem pure_response_factor_homogeneous (W : WeightsN N D K) (p : V N) (k r : ℕ)
    (i : Fin D) (q : MvPolynomial (Fin D) K)
    (hq : oddResponsePolynomial W p k r (fun _ => i) = MvPolynomial.X i * q) :
    MvPolynomial.IsWeightedHomogeneous (fun _ : Fin D => (1 : ℕ)) q (2 * r) := by
  intro m hm
  have hpoly := oddResponsePolynomial_homogeneous W p k r (fun _ => i)
  rw [hq] at hpoly
  have hc : MvPolynomial.coeff (Finsupp.single i 1 + m) (MvPolynomial.X i * q) ≠ 0 := by
    rw [MvPolynomial.coeff_X_mul]
    exact hm
  have hd := hpoly hc
  rw [map_add, Finsupp.weight_single] at hd
  simp only [one_nsmul] at hd
  omega

theorem mixed_response_zero_of_reflection (W : WeightsN N D K) (p : V N)
    (k r : ℕ) (ι : V N → Fin D) (h : Fin D)
    (hreflection : MvPolynomial.X h * oddResponsePolynomial W p k r ι = 0) :
    oddResponsePolynomial W p k r ι = 0 :=
  ResponseFactor.mixed_response_eq_zero (MvPolynomial.X_ne_zero h) hreflection

noncomputable def finiteScalarFactor (k : ℕ) (q : ℕ → MvPolynomial (Fin D) K) :
    MvPolynomial (Fin D) K :=
  ∑ r ∈ Finset.range (k + 1), MvPolynomial.C (((2 * r + 1).factorial : K)⁻¹) * q r

omit [CharZero K] in

theorem finiteScalarFactor_eval_zero (k : ℕ) (q : ℕ → MvPolynomial (Fin D) K)
    (hq : ∀ r ≤ k, MvPolynomial.IsWeightedHomogeneous (fun _ : Fin D => (1 : ℕ)) (q r) (2 * r))
    (hzero : q 0 = 1) : MvPolynomial.eval (fun _ => 0) (finiteScalarFactor k q) = 1 := by
  classical
  unfold finiteScalarFactor
  rw [map_sum, Finset.sum_eq_single 0]
  · simp [hzero]
  · intro r hr hr0
    have hrk : r ≤ k := by
      have := Finset.mem_range.mp hr
      omega
    have heval : MvPolynomial.eval (fun _ => 0) (q r) = 0 := by
      rw [MvPolynomial.eval_zero']
      change MvPolynomial.coeff 0 (q r) = 0
      exact (hq r hrk).coeff_eq_zero 0 (by simp only [map_zero]; omega)
    rw [map_mul, MvPolynomial.eval_C, heval, mul_zero]
  · simp

theorem pure_linear_factor_eq_one (k : ℕ) (W : WeightsN (2 * (k + 1)) D K)
    (hW : EqSystemN (2 * (k + 1)) D W) (p : V (2 * (k + 1)))
    (i : Fin D) (q : MvPolynomial (Fin D) K)
    (hq : oddResponsePolynomial W p k 0 (fun _ => i) = MvPolynomial.X i * q) : q = 1 := by
  rw [oddResponsePolynomial_zero_pure k W hW p i] at hq
  apply mul_left_cancel₀ (MvPolynomial.X_ne_zero (R := K) i)
  simpa only [mul_one] using hq.symm

theorem factors_zero_of_finiteScalarFactor_eq_one (k : ℕ)
    (q : ℕ → MvPolynomial (Fin D) K)
    (hq : ∀ r ≤ k, MvPolynomial.IsWeightedHomogeneous (fun _ : Fin D => (1 : ℕ)) (q r) (2 * r))
    (hsum : finiteScalarFactor k q = 1) (r : ℕ) (hr : r ≤ k) (hpos : 0 < r) : q r = 0 := by
  classical
  let w := fun _ : Fin D => (1 : ℕ)
  have hh := congrArg (MvPolynomial.weightedHomogeneousComponent w (2 * r)) hsum
  unfold finiteScalarFactor at hh
  rw [map_sum, Finset.sum_eq_single r] at hh
  · have hsame : MvPolynomial.weightedHomogeneousComponent w (2 * r)
        (MvPolynomial.C (((2 * r + 1).factorial : K)⁻¹) * q r) =
        MvPolynomial.C (((2 * r + 1).factorial : K)⁻¹) * q r :=
      MvPolynomial.weightedHomogeneousComponent_eq_self ((hq r hr).C_mul _)
    have hone : MvPolynomial.weightedHomogeneousComponent w (2 * r)
        (1 : MvPolynomial (Fin D) K) = 0 :=
      (MvPolynomial.isWeightedHomogeneous_one K w).weightedHomogeneousComponent_ne (2 * r) (by omega)
    rw [hsame, hone] at hh
    have hnz : (MvPolynomial.C (((2 * r + 1).factorial : K)⁻¹) : MvPolynomial (Fin D) K) ≠ 0 := by
      apply MvPolynomial.C_ne_zero.mpr
      exact inv_ne_zero (Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero _))
    exact (mul_eq_zero.mp hh).resolve_left hnz
  · intro s hs hsr
    have hs' : s ≤ k := by
      have := Finset.mem_range.mp hs
      omega
    have hhom := (hq s hs').C_mul (((2 * s + 1).factorial : K)⁻¹)
    exact hhom.weightedHomogeneousComponent_ne (2 * r) (by omega)
  · intro hnot
    exact False.elim (hnot (Finset.mem_range.mpr (by omega)))

theorem factors_zero_of_rescaling_square (k : ℕ)
    (q : ℕ → MvPolynomial (Fin D) K)
    (hq : ∀ r ≤ k, MvPolynomial.IsWeightedHomogeneous (fun _ : Fin D => (1 : ℕ)) (q r) (2 * r))
    (s : K) (hs : s ≠ 0)
    (hzero : MvPolynomial.eval (fun _ => 0) (finiteScalarFactor k q) = 1)
    (hrotation : (FiniteResponseRigidity.scaleVariables s (finiteScalarFactor k q)) ^ 2 =
      finiteScalarFactor k q) (r : ℕ) (hr : r ≤ k) (hpos : 0 < r) : q r = 0 := by
  have hg := FiniteResponseRigidity.eq_one_of_rescaling_square _ s hs hzero hrotation
  exact factors_zero_of_finiteScalarFactor_eq_one k q hq hg r hr hpos

theorem factors_zero_of_normalized_rotation (k : ℕ)
    (q : ℕ → MvPolynomial (Fin D) K)
    (hq : ∀ r ≤ k, MvPolynomial.IsWeightedHomogeneous (fun _ : Fin D => (1 : ℕ)) (q r) (2 * r))
    (hzero : q 0 = 1) (s : K) (hs : s ≠ 0)
    (hrotation : (FiniteResponseRigidity.scaleVariables s (finiteScalarFactor k q)) ^ 2 =
      finiteScalarFactor k q) (r : ℕ) (hr : r ≤ k) (hpos : 0 < r) : q r = 0 :=
  factors_zero_of_rescaling_square k q hq s hs (finiteScalarFactor_eval_zero k q hq hzero)
    hrotation r hr hpos

end Field

end Krenn.OddResponseVanishing

-- formal/all-orders/ReflectionResponses.lean

namespace Krenn.ReflectionResponses

open scoped BigOperators Classical
open WickCovariance

variable {R E F U κ : Type*} [Field R]
  [AddCommGroup E] [Module R E] [AddCommGroup F] [Module R F]
  [AddCommGroup U] [Module R U]

def pairValue (f : MultilinearMap R (fun _ : Fin 2 => F) U) (x y : F) : U :=
  f.curryLeft x (fun _ => y)

theorem pairValue_add_left (f : MultilinearMap R (fun _ : Fin 2 => F) U)
    (x y z : F) : pairValue f (x + y) z = pairValue f x z + pairValue f y z := by
  simp [pairValue, map_add]

theorem pairValue_smul_left (f : MultilinearMap R (fun _ : Fin 2 => F) U)
    (a : R) (x y : F) : pairValue f (a • x) y = a • pairValue f x y := by
  simp [pairValue, map_smul]

theorem pairValue_add_right (f : MultilinearMap R (fun _ : Fin 2 => F) U)
    (x y z : F) : pairValue f x (y + z) = pairValue f x y + pairValue f x z := by
  have h := (f.curryLeft x).map_update_add (fun _ => (0 : F)) 0 y z
  have hu (w : F) : Function.update (fun _ : Fin 1 => (0 : F)) 0 w = (fun _ => w) := by
    funext i
    fin_cases i
    rfl
  rw [hu, hu, hu] at h
  exact h

theorem pairValue_smul_right (f : MultilinearMap R (fun _ : Fin 2 => F) U)
    (a : R) (x y : F) : pairValue f x (a • y) = a • pairValue f x y := by
  have h := (f.curryLeft x).map_update_smul (fun _ => (0 : F)) 0 a y
  have hu (w : F) : Function.update (fun _ : Fin 1 => (0 : F)) 0 w = (fun _ => w) := by
    funext i
    fin_cases i
    rfl
  rw [hu, hu] at h
  exact h

def pairAlternation (f : MultilinearMap R (fun _ : Fin 2 => F) U)
    (l r : E →ₗ[R] F) (u v : E) : U :=
  pairValue f (l u) (r v) - pairValue f (l v) (r u)

theorem pairAlternation_determinant (f : MultilinearMap R (fun _ : Fin 2 => F) U)
    (hsym : ∀ x y, pairValue f x y = pairValue f y x)
    (l r : E →ₗ[R] F) (a b c d : R) (u v : E) :
    pairAlternation f (a • l + c • r) (b • l + d • r) u v =
      (a * d - b * c) • pairAlternation f l r u v := by
  simp only [pairAlternation, LinearMap.add_apply, LinearMap.smul_apply,
    pairValue_add_left, pairValue_add_right, pairValue_smul_left, pairValue_smul_right]
  rw [hsym (l v) (l u), hsym (r v) (r u), hsym (r u) (l v), hsym (r v) (l u)]
  module

abbrev PairSlots (n : ℕ) (κ : Type*) : Type _ :=
  match n with
  | 0 => κ
  | n + 1 => Fin 2 ⊕ PairSlots n κ

instance pairSlotsFintype [Fintype κ] (n : ℕ) : Fintype (PairSlots n κ) := by
  induction n with
  | zero => exact inferInstanceAs (Fintype κ)
  | succ n ih => exact inferInstanceAs (Fintype (Fin 2 ⊕ PairSlots n κ))

def SlotSymmetric {ι : Type*} (f : MultilinearMap R (fun _ : ι => F) U) : Prop :=
  ∀ (τ : Equiv.Perm ι) (z : ι → F), f (fun i => z (τ i)) = f z

@[simp]
theorem pairValue_eq (f : MultilinearMap R (fun _ : Fin 2 => F) U) (x y : F) :
    pairValue f x y = f (fun i => if i = 0 then x else y) := by
  unfold pairValue
  rw [MultilinearMap.curryLeft_apply]
  congr 1
  funext i
  fin_cases i <;> rfl

theorem pairValue_currySum_symmetric
    (f : MultilinearMap R (fun _ : Fin 2 ⊕ κ => F) U) (hf : SlotSymmetric f)
    (x y : F) : pairValue f.currySum x y = pairValue f.currySum y x := by
  ext z
  simp only [pairValue_eq, MultilinearMap.currySum_apply']
  have h := hf (Equiv.sumCongr (Equiv.swap (0 : Fin 2) 1) (Equiv.refl κ))
    (Sum.elim (fun i => if i = 0 then x else y) z)
  have hv : (fun i => Sum.elim (fun j => if j = 0 then x else y) z
      (Equiv.sumCongr (Equiv.swap (0 : Fin 2) 1) (Equiv.refl κ) i)) =
      Sum.elim (fun j => if j = 0 then y else x) z := by
    funext i
    cases i with
    | inl i => fin_cases i <;> simp
    | inr i => rfl
  rw [hv] at h
  exact h.symm

theorem currySum_symmetric_right
    (f : MultilinearMap R (fun _ : Fin 2 ⊕ κ => F) U) (hf : SlotSymmetric f)
    (z : Fin 2 → F) : SlotSymmetric (f.currySum z) := by
  intro τ w
  have h := hf (Equiv.sumCongr (Equiv.refl (Fin 2)) τ) (Sum.elim z w)
  have hv : (fun i => Sum.elim z w (Equiv.sumCongr (Equiv.refl (Fin 2)) τ i)) =
      Sum.elim z (fun i => w (τ i)) := by
    funext i
    cases i <;> rfl
  rw [hv] at h
  exact h

def contractSite (f : MultilinearMap R (fun _ : Fin 2 ⊕ κ => F) U)
    (l r : E →ₗ[R] F) (u v : E) : MultilinearMap R (fun _ : κ => F) U :=
  pairAlternation f.currySum l r u v

theorem contractSite_symmetric
    (f : MultilinearMap R (fun _ : Fin 2 ⊕ κ => F) U) (hf : SlotSymmetric f)
    (l r : E →ₗ[R] F) (u v : E) : SlotSymmetric (contractSite f l r u v) := by
  intro τ z
  unfold contractSite pairAlternation
  simp only [pairValue_eq, sub_apply]
  rw [currySum_symmetric_right f hf _ τ z, currySum_symmetric_right f hf _ τ z]

theorem contractSite_determinant
    (f : MultilinearMap R (fun _ : Fin 2 ⊕ κ => F) U) (hf : SlotSymmetric f)
    (l r : E →ₗ[R] F) (a b c d : R) (u v : E) :
    contractSite f (a • l + c • r) (b • l + d • r) u v =
      (a * d - b * c) • contractSite f l r u v :=
  pairAlternation_determinant f.currySum (pairValue_currySum_symmetric f hf) l r a b c d u v

theorem contractSite_smul
    (f : MultilinearMap R (fun _ : Fin 2 ⊕ κ => F) U)
    (a : R) (l r : E →ₗ[R] F) (u v : E) :
    contractSite (a • f) l r u v = a • contractSite f l r u v := by
  ext z
  simp [contractSite, pairAlternation, pairValue_eq, smul_sub]

def contractSites : (n : ℕ) →
    MultilinearMap R (fun _ : PairSlots n κ => F) U →
    (E →ₗ[R] F) → (E →ₗ[R] F) → (Fin n → E) → (Fin n → E) →
    MultilinearMap R (fun _ : κ => F) U
  | 0, f, _, _, _, _ => f
  | n + 1, f, l, r, u, v =>
      contractSites n (contractSite f l r (u 0) (v 0)) l r (Fin.tail u) (Fin.tail v)

theorem contractSites_smul (n : ℕ)
    (f : MultilinearMap R (fun _ : PairSlots n κ => F) U)
    (a : R) (l r : E →ₗ[R] F) (u v : Fin n → E) :
    contractSites n (a • f) l r u v = a • contractSites n f l r u v := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [contractSites]
    rw [contractSite_smul]
    exact ih _ _ _

theorem contractSites_determinant (n : ℕ)
    (f : MultilinearMap R (fun _ : PairSlots n κ => F) U) (hf : SlotSymmetric f)
    (l r : E →ₗ[R] F) (a b c d : R) (u v : Fin n → E) :
    contractSites n f (a • l + c • r) (b • l + d • r) u v =
      (a * d - b * c) ^ n • contractSites n f l r u v := by
  induction n with
  | zero => simp only [contractSites, pow_zero, one_smul]
  | succ n ih =>
    simp only [contractSites]
    rw [contractSite_determinant f hf l r a b c d, contractSites_smul]
    rw [ih _ (contractSite_symmetric f hf l r (u 0) (v 0))]
    rw [smul_smul, pow_succ']

theorem contractSites_symmetric (n : ℕ)
    (f : MultilinearMap R (fun _ : PairSlots n κ => F) U) (hf : SlotSymmetric f)
    (l r : E →ₗ[R] F) (u v : Fin n → E) :
    SlotSymmetric (contractSites n f l r u v) := by
  induction n with
  | zero => exact hf
  | succ n ih =>
    exact ih _ (contractSite_symmetric f hf l r (u 0) (v 0)) _ _

theorem contractSite_compLinearMap
    (f : MultilinearMap R (fun _ : Fin 2 ⊕ κ => F) U)
    (T : F →ₗ[R] F) (l r : E →ₗ[R] F) (u v : E) :
    contractSite (f.compLinearMap (fun _ => T)) l r u v =
      (contractSite f (T.comp l) (T.comp r) u v).compLinearMap (fun _ => T) := by
  ext z
  simp only [contractSite, pairAlternation, pairValue_eq, sub_apply,
    MultilinearMap.compLinearMap_apply, MultilinearMap.currySum_apply', LinearMap.comp_apply]
  congr 1 <;> congr 1 <;> funext i <;> cases i with
  | inl i => fin_cases i <;> rfl
  | inr i => rfl

theorem contractSites_compLinearMap (n : ℕ)
    (f : MultilinearMap R (fun _ : PairSlots n κ => F) U)
    (T : F →ₗ[R] F) (l r : E →ₗ[R] F) (u v : Fin n → E) :
    contractSites n (f.compLinearMap (fun _ => T)) l r u v =
      (contractSites n f (T.comp l) (T.comp r) u v).compLinearMap (fun _ => T) := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [contractSites, contractSite_compLinearMap]
    exact ih _ _ _

def replicaLeft : E →ₗ[R] E × E := (LinearMap.id : E →ₗ[R] E).prod 0

def replicaRight : E →ₗ[R] E × E := (0 : E →ₗ[R] E).prod LinearMap.id

@[simp] theorem replicaLeft_apply (x : E) : replicaLeft (R := R) x = (x, 0) := rfl
@[simp] theorem replicaRight_apply (x : E) : replicaRight (R := R) x = (0, x) := rfl

theorem replicaLinear_comp_left (a b c d : R) :
    (replicaLinear (E := E) a b c d).comp replicaLeft = a • replicaLeft + c • replicaRight := by
  ext x <;> simp [replicaLinear, replicaLeft, replicaRight]

theorem replicaLinear_comp_right (a b c d : R) :
    (replicaLinear (E := E) a b c d).comp replicaRight = b • replicaLeft + d • replicaRight := by
  ext x <;> simp [replicaLinear, replicaLeft, replicaRight]

noncomputable def reflectedMoment [Fintype κ] (B : E →ₗ[R] E →ₗ[R] R)
    (n : ℕ) (u v : Fin n → E) : MultilinearMap R (fun _ : κ => E × E) R :=
  contractSites n (centeredMoment (ι := PairSlots n κ) (replicaCovariance B))
    replicaLeft replicaRight u v

theorem centeredMoment_slotSymmetric [Fintype κ]
    (B : E →ₗ[R] E →ₗ[R] R) (n : ℕ) :
    SlotSymmetric (centeredMoment (ι := PairSlots n κ) (replicaCovariance B)) :=
  centeredMoment_permute _

theorem reflectedMoment_replicaLinear [Fintype κ]
    (B : E →ₗ[R] E →ₗ[R] R) (n : ℕ) (u v : Fin n → E)
    (a b c d : R) (hfirst : a ^ 2 + c ^ 2 = 1)
    (hsecond : b ^ 2 + d ^ 2 = 1) (hcross : a * b + c * d = 0)
    (z : κ → E × E) :
    reflectedMoment B n u v (fun i => replicaLinear a b c d (z i)) =
      (a * d - b * c) ^ n * reflectedMoment B n u v z := by
  let f := centeredMoment (ι := PairSlots n κ) (replicaCovariance B)
  let T := replicaLinear (E := E) a b c d
  have hinv : f.compLinearMap (fun _ => T) = f := by
    ext w
    change centeredMoment _ (fun i => T (w i)) = centeredMoment _ w
    have hcov : (replicaCovariance B).compl₁₂ T T = replicaCovariance B := by
      apply LinearMap.ext
      intro x
      apply LinearMap.ext
      intro y
      exact replicaLinear_covariance B a b c d hfirst hsecond hcross x y
    rw [← centeredMoment_naturality, hcov]
  have h := contractSites_compLinearMap n f T replicaLeft replicaRight u v
  rw [hinv, replicaLinear_comp_left, replicaLinear_comp_right,
    contractSites_determinant n f (centeredMoment_slotSymmetric B n)] at h
  have he := congrArg (fun g : MultilinearMap R (fun _ : κ => E × E) R => g z) h
  simp only [MultilinearMap.compLinearMap_apply, smul_apply, smul_eq_mul] at he
  have hdet : (a * d - b * c) ^ 2 = 1 := by
    calc
      _ = (a ^ 2 + c ^ 2) * (b ^ 2 + d ^ 2) - (a * b + c * d) ^ 2 := by ring
      _ = 1 := by rw [hfirst, hsecond, hcross]; ring
  have hpow : (a * d - b * c) ^ n * (a * d - b * c) ^ n = 1 := by
    rw [← mul_pow, ← pow_two, hdet, one_pow]
  change (contractSites n f replicaLeft replicaRight u v) (fun i => T (z i)) =
    (a * d - b * c) ^ n * (contractSites n f replicaLeft replicaRight u v) z
  calc
    _ = ((a * d - b * c) ^ n * (a * d - b * c) ^ n) *
        (contractSites n f replicaLeft replicaRight u v) (fun i => T (z i)) := by rw [hpow, one_mul]
    _ = (a * d - b * c) ^ n * (contractSites n f replicaLeft replicaRight u v) z := by
      rw [mul_assoc, ← he]

theorem reflectedMoment_eq_zero_of_reflection [Fintype κ] [CharZero R]
    (B : E →ₗ[R] E →ₗ[R] R) (n : ℕ) (hn : Odd n) (u v : Fin n → E)
    (a b c d : R) (hfirst : a ^ 2 + c ^ 2 = 1)
    (hsecond : b ^ 2 + d ^ 2 = 1) (hcross : a * b + c * d = 0)
    (hdet : a * d - b * c = -1) (z : κ → E × E)
    (hfix : ∀ i, replicaLinear a b c d (z i) = z i) :
    reflectedMoment B n u v z = 0 := by
  have h := reflectedMoment_replicaLinear B n u v a b c d hfirst hsecond hcross z
  simp only [hfix, hdet, hn.neg_one_pow, neg_one_mul] at h
  have htwo : (2 : R) * reflectedMoment B n u v z = 0 := by
    calc
      _ = reflectedMoment B n u v z - -reflectedMoment B n u v z := by ring
      _ = 0 := sub_eq_zero.mpr h
  exact (mul_eq_zero.mp htwo).resolve_left (by norm_num)

theorem reflectedMoment_const_eq_zero [Fintype κ] [CharZero R]
    (B : E →ₗ[R] E →ₗ[R] R) (n : ℕ) (hn : Odd n) (u v : Fin n → E)
    (L : E) (s t : R) (hst : s ^ 2 + t ^ 2 ≠ 0) :
    reflectedMoment B n u v (fun _ : κ => (s • L, t • L)) = 0 := by
  let a : R := (s ^ 2 - t ^ 2) / (s ^ 2 + t ^ 2)
  let b : R := (2 * s * t) / (s ^ 2 + t ^ 2)
  have hnorm : a ^ 2 + b ^ 2 = 1 := by
    dsimp [a, b]
    field_simp
    ring
  have hs : a * s + b * t = s := by
    dsimp [a, b]
    field_simp
    ring
  have ht : b * s + (-a) * t = t := by
    dsimp [a, b]
    field_simp
    ring
  apply reflectedMoment_eq_zero_of_reflection B n hn u v a b b (-a)
  · exact hnorm
  · simpa only [neg_sq, add_comm] using hnorm
  · ring
  · calc
      a * -a - b * b = -(a ^ 2 + b ^ 2) := by ring
      _ = -1 := by rw [hnorm]
  · intro i
    simp only [replicaLinear_apply, smul_smul, ← add_smul]
    rw [hs, ht]

noncomputable def rootPolynomial [Fintype κ]
    (f : MultilinearMap R (fun _ : κ => F) R) (X Y : F) : MvPolynomial (Fin 2) R :=
  ∑ A : Finset κ,
    MvPolynomial.C (f (A.piecewise (fun _ => Y) (fun _ => X))) *
      MvPolynomial.X 0 ^ (Fintype.card κ - A.card) * MvPolynomial.X 1 ^ A.card

theorem eval_rootPolynomial [Fintype κ]
    (f : MultilinearMap R (fun _ : κ => F) R) (X Y : F) (s t : R) :
    MvPolynomial.eval (fun i => if i = 0 then s else t) (rootPolynomial f X Y) =
      f (fun _ => s • X + t • Y) := by
  classical
  unfold rootPolynomial
  simp only [map_sum, map_mul, MvPolynomial.eval_C, map_pow, MvPolynomial.eval_X,
    ite_true, show (1 : Fin 2) ≠ 0 by decide, ite_false]
  rw [show (fun _ : κ => s • X + t • Y) =
      (fun _ => t • Y) + (fun _ => s • X) by funext i; simp [add_comm]]
  rw [f.map_add_univ]
  apply Finset.sum_congr rfl
  intro A _
  have hv : A.piecewise (fun _ => t • Y) (fun _ => s • X) =
      (fun i => (if i ∈ A then t else s) •
        (A.piecewise (fun _ => Y) (fun _ => X) i)) := by
    funext i
    by_cases hi : i ∈ A <;> simp [Finset.piecewise, hi]
  rw [hv, f.map_smul_univ]
  have hp : (∏ i : κ, if i ∈ A then t else s) =
      t ^ A.card * s ^ (Fintype.card κ - A.card) := by
    rw [Finset.prod_ite]
    have hA : Finset.univ.filter (fun i : κ => i ∈ A) = A := by ext i; simp
    have hAc : Finset.univ.filter (fun i : κ => i ∉ A) = Aᶜ := by ext i; simp
    rw [hA, hAc, Finset.prod_const, Finset.prod_const, Finset.card_compl]
  rw [hp, smul_eq_mul]
  ring

theorem rootPolynomial_reflectedMoment_eq_zero [Fintype κ] [CharZero R]
    (B : E →ₗ[R] E →ₗ[R] R) (n : ℕ) (hn : Odd n) (u v : Fin n → E) (L : E) :
    rootPolynomial (reflectedMoment B n u v (κ := κ)) (L, 0) (0, L) = 0 := by
  let P := rootPolynomial (reflectedMoment B n u v (κ := κ)) (L, 0) (0, L)
  let δ : MvPolynomial (Fin 2) R := MvPolynomial.X 0 ^ 2 + MvPolynomial.X 1 ^ 2
  have hzero : δ * P = 0 := by
    apply MvPolynomial.funext
    intro z
    have hz : (fun i : Fin 2 => if i = 0 then z 0 else z 1) = z := by
      funext i
      fin_cases i <;> rfl
    have he : MvPolynomial.eval z P =
        reflectedMoment B n u v (fun _ : κ => (z 0 • L, z 1 • L)) := by
      rw [← hz]
      rw [eval_rootPolynomial]
      congr 1
      funext i
      simp
    simp only [map_mul, map_zero]
    by_cases hh : z 0 ^ 2 + z 1 ^ 2 = 0
    · have hd : MvPolynomial.eval z δ = 0 := by simpa [δ] using hh
      rw [hd, zero_mul]
    · rw [he, reflectedMoment_const_eq_zero B n hn u v L (z 0) (z 1) hh, mul_zero]
  have hδ : δ ≠ 0 := by
    intro h
    have he := congrArg (MvPolynomial.eval (fun i : Fin 2 => if i = 0 then (1 : R) else 0)) h
    norm_num [δ] at he
  exact (mul_eq_zero.mp hzero).resolve_left hδ

noncomputable def twoExponent (a b : ℕ) : Fin 2 →₀ ℕ := Finsupp.single 0 a + Finsupp.single 1 b

theorem twoExponent_eq_iff (a b c d : ℕ) :
    twoExponent a b = twoExponent c d ↔ a = c ∧ b = d := by
  constructor
  · intro h
    constructor
    · simpa [twoExponent] using congrArg (fun m => m 0) h
    · simpa [twoExponent] using congrArg (fun m => m 1) h
  · rintro ⟨rfl, rfl⟩
    rfl

theorem X_pow_mul_X_pow (a b : ℕ) :
    (MvPolynomial.X 0 ^ a * MvPolynomial.X 1 ^ b : MvPolynomial (Fin 2) R) =
      MvPolynomial.monomial (twoExponent a b) 1 := by
  rw [MvPolynomial.X_pow_eq_monomial, MvPolynomial.X_pow_eq_monomial,
    MvPolynomial.monomial_mul]
  simp only [one_mul]
  rfl

theorem coeff_rootPolynomial_one [Fintype κ]
    (f : MultilinearMap R (fun _ : κ => F) R) (X Y : F) :
    MvPolynomial.coeff (twoExponent (Fintype.card κ - 1) 1) (rootPolynomial f X Y) =
      ∑ i : κ, f (Function.update (fun _ : κ => X) i Y) := by
  classical
  unfold rootPolynomial
  rw [MvPolynomial.coeff_sum]
  have heach (A : Finset κ) :
      MvPolynomial.coeff (twoExponent (Fintype.card κ - 1) 1)
        (MvPolynomial.C (f (A.piecewise (fun _ => Y) (fun _ => X))) *
          MvPolynomial.X 0 ^ (Fintype.card κ - A.card) * MvPolynomial.X 1 ^ A.card) =
      if A.card = 1 then f (A.piecewise (fun _ => Y) (fun _ => X)) else 0 := by
    rw [mul_assoc, X_pow_mul_X_pow, MvPolynomial.coeff_C_mul]
    simp only [MvPolynomial.coeff_monomial, twoExponent_eq_iff]
    by_cases hA : A.card = 1
    · simp [hA]
    · simp [hA]
  simp_rw [heach]
  rw [← Finset.sum_filter]
  have hfilter : Finset.univ.filter (fun A : Finset κ => A.card = 1) =
      (Finset.univ : Finset κ).powersetCard 1 := by
    ext A
    simp
  rw [hfilter, Finset.powersetCard_one, Finset.sum_map]
  apply Finset.sum_congr rfl
  intro i _
  congr 1
  funext j
  simp [Finset.piecewise, Function.update, eq_comm]

theorem sum_one_root_replacements_eq_zero [Fintype κ] [CharZero R]
    (B : E →ₗ[R] E →ₗ[R] R) (n : ℕ) (hn : Odd n) (u v : Fin n → E) (L : E) :
    (∑ i : κ, reflectedMoment B n u v
      (Function.update (fun _ : κ => (L, 0)) i (0, L))) = 0 := by
  rw [← coeff_rootPolynomial_one]
  rw [rootPolynomial_reflectedMoment_eq_zero B n hn u v L]
  exact MvPolynomial.coeff_zero _

theorem symmetric_one_root_replacements
    (f : MultilinearMap R (fun _ : κ => F) R) (hf : SlotSymmetric f)
    (X Y : F) (i j : κ) :
    f (Function.update (fun _ : κ => X) i Y) =
      f (Function.update (fun _ : κ => X) j Y) := by
  have h := hf (Equiv.swap i j) (Function.update (fun _ : κ => X) i Y)
  simpa only [Function.update_apply_equiv_apply, Equiv.symm_swap,
    Equiv.swap_apply_left, Function.comp_def] using h.symm

theorem one_root_replacement_eq_zero [Fintype κ] [CharZero R]
    (B : E →ₗ[R] E →ₗ[R] R) (n : ℕ) (hn : Odd n) (u v : Fin n → E)
    (L : E) (j : κ) :
    reflectedMoment B n u v (Function.update (fun _ : κ => (L, 0)) j (0, L)) = 0 := by
  have hs : SlotSymmetric (reflectedMoment B n u v (κ := κ)) :=
    contractSites_symmetric n _ (centeredMoment_slotSymmetric B n) _ _ u v
  have h := sum_one_root_replacements_eq_zero (κ := κ) B n hn u v L
  have he (i : κ) := symmetric_one_root_replacements _ hs (L, 0) (0, L) i j
  simp_rw [he] at h
  simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul] at h
  have hc : (Fintype.card κ : R) ≠ 0 := by
    apply Nat.cast_ne_zero.mpr
    exact Nat.ne_of_gt (Fintype.card_pos_iff.mpr ⟨j⟩)
  exact (mul_eq_zero.mp h).resolve_left hc

end Krenn.ReflectionResponses

-- formal/all-orders/BinaryPairing.lean

namespace Krenn.BinaryPairing

open scoped BigOperators Classical

variable {ι R : Type*} [Fintype ι] [CommRing R]

abbrev Tensor (ι R : Type*) := (ι → Bool) → R

def complement (w : ι → Bool) : ι → Bool := fun i => !(w i)

omit [Fintype ι] in
@[simp] theorem complement_complement (w : ι → Bool) : complement (complement w) = w := by
  funext i
  exact Bool.not_not (w i)

def complementEquiv : (ι → Bool) ≃ (ι → Bool) where
  toFun := complement
  invFun := complement
  left_inv := complement_complement
  right_inv := complement_complement

def sign (w : ι → Bool) : R := ∏ i, if w i then (-1 : R) else 1

noncomputable def pairing (P Q : Tensor ι R) : R :=
  ∑ w : ι → Bool, sign w * P w * Q (complement w)

@[simp] theorem sign_false : sign (fun _ : ι => false) = (1 : R) := by simp [sign]

@[simp] theorem sign_true : sign (fun _ : ι => true) = (-1 : R) ^ Fintype.card ι := by
  simp [sign]

theorem sign_complement (w : ι → Bool) :
    sign (complement w) = (-1 : R) ^ Fintype.card ι * sign w := by
  have heach (i : ι) : (if complement w i then (-1 : R) else 1) =
      (-1 : R) * (if w i then -1 else 1) := by
    cases h : w i <;> simp [complement, h]
  simp only [sign, heach, Finset.prod_mul_distrib, Finset.prod_const, Finset.card_univ]

theorem pairing_swap (P Q : Tensor ι R) :
    pairing Q P = (-1 : R) ^ Fintype.card ι * pairing P Q := by
  rw [pairing, ← Equiv.sum_comp (complementEquiv (ι := ι))]
  change (∑ w : ι → Bool, sign (complement w) * Q (complement w) *
    P (complement (complement w))) = _
  simp only [sign_complement, complement_complement]
  rw [pairing, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro w _
  ring

theorem pairing_add_left (P Q U : Tensor ι R) :
    pairing (P + Q) U = pairing P U + pairing Q U := by
  simp only [pairing, Pi.add_apply, mul_add, add_mul, Finset.sum_add_distrib]

theorem pairing_add_right (P Q U : Tensor ι R) :
    pairing P (Q + U) = pairing P Q + pairing P U := by
  simp only [pairing, Pi.add_apply, mul_add, Finset.sum_add_distrib]

theorem pairing_smul_left (c : R) (P Q : Tensor ι R) :
    pairing (c • P) Q = c * pairing P Q := by
  simp only [pairing, Pi.smul_apply, smul_eq_mul, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro w _
  ring

theorem pairing_smul_right (c : R) (P Q : Tensor ι R) :
    pairing P (c • Q) = c * pairing P Q := by
  simp only [pairing, Pi.smul_apply, smul_eq_mul, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro w _
  ring

noncomputable def pure (b : Bool) : Tensor ι R := fun w => if w = (fun _ => b) then 1 else 0

theorem pairing_pure_left (b : Bool) (P : Tensor ι R) :
    pairing (pure b) P = sign (fun _ : ι => b) * P (fun _ => !b) := by
  classical
  simp only [pairing, pure]
  rw [Finset.sum_eq_single (fun _ : ι => b)]
  · simp only [ite_true, mul_one]
    rfl
  · intro w _ hw
    simp [hw]
  · simp

theorem pairing_pure_false (P : Tensor ι R) : pairing (pure false) P = P (fun _ => true) := by
  rw [pairing_pure_left]
  simp

theorem pairing_pure_true (P : Tensor ι R) :
    pairing (pure true) P = (-1 : R) ^ Fintype.card ι * P (fun _ => false) := by
  rw [pairing_pure_left]
  simp

omit [Fintype ι] in
theorem complement_eq_constant_iff (w : ι → Bool) (b : Bool) :
    complement w = (fun _ => b) ↔ w = (fun _ => !b) := by
  have h : complement (fun _ : ι => !b) = (fun _ => b) := by
    funext i
    exact Bool.not_not b
  constructor
  · intro hw
    exact (complementEquiv (ι := ι)).injective (hw.trans h.symm)
  · intro hw
    rw [hw, h]

theorem pairing_pure_right (P : Tensor ι R) (b : Bool) :
    pairing P (pure b) = sign (fun _ : ι => !b) * P (fun _ => !b) := by
  classical
  simp only [pairing, pure, complement_eq_constant_iff]
  rw [Finset.sum_eq_single (fun _ : ι => !b)]
  · simp
  · intro w _ hw
    simp [hw]
  · simp

theorem pairing_right_pure_true (P : Tensor ι R) :
    pairing P (pure true) = P (fun _ => false) := by
  rw [pairing_pure_right]
  simp

theorem pairing_right_pure_false (P : Tensor ι R) :
    pairing P (pure false) = (-1 : R) ^ Fintype.card ι * P (fun _ => true) := by
  rw [pairing_pure_right]
  simp

noncomputable def bilinearPairing : Tensor ι R →ₗ[R] Tensor ι R →ₗ[R] R where
  toFun P := {
    toFun := pairing P
    map_add' Q U := pairing_add_right P Q U
    map_smul' c Q := pairing_smul_right c P Q }
  map_add' P Q := by
    apply LinearMap.ext
    intro U
    exact pairing_add_left P Q U
  map_smul' c P := by
    apply LinearMap.ext
    intro Q
    exact pairing_smul_left c P Q

theorem pairing_pure_combinations [Nonempty ι] (a b c d : R) :
    pairing (a • pure false + b • pure true : Tensor ι R)
      (c • pure false + d • pure true) = a * d + (-1 : R) ^ Fintype.card ι * b * c := by
  rw [pairing_add_left, pairing_smul_left, pairing_smul_left,
    pairing_pure_false, pairing_pure_true]
  simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  simp only [pure, funext_iff, Bool.false_eq_true, Bool.true_eq_false,
    forall_const, ite_false, ite_true, mul_zero, mul_one, zero_add, add_zero]
  ring

theorem pairing_pure_combinations_odd [Nonempty ι] (hodd : Odd (Fintype.card ι))
    (a b c d : R) :
    pairing (a • pure false + b • pure true : Tensor ι R)
      (c • pure false + d • pure true) = a * d - b * c := by
  rw [pairing_pure_combinations, hodd.neg_one_pow]
  ring

theorem pairing_symmetric_of_even (heven : Even (Fintype.card ι)) (P Q : Tensor ι R) :
    pairing P Q = pairing Q P := by
  rw [pairing_swap, heven.neg_one_pow, one_mul]

end Krenn.BinaryPairing

-- formal/all-orders/ReflectionTensorBridge.lean

namespace Krenn.ReflectionTensorBridge

open scoped BigOperators Classical
open ReflectionResponses WickCovariance WickCoefficientBridge

variable {R E F U κ : Type*} [Field R]
  [AddCommGroup E] [Module R E] [AddCommGroup F] [Module R F]
  [AddCommGroup U] [Module R U]

abbrev Words : ℕ → Type
  | 0 => Unit
  | n + 1 => Bool × Words n

instance wordsFintype (n : ℕ) : Fintype (Words n) := by
  induction n with
  | zero => exact inferInstanceAs (Fintype Unit)
  | succ n ih => exact inferInstanceAs (Fintype (Bool × Words n))

def wordSign : (n : ℕ) → Words n → R
  | 0, _ => 1
  | n + 1, w => (if w.1 then -1 else 1) * wordSign n w.2

def wordInputs : (n : ℕ) → (E →ₗ[R] F) → (E →ₗ[R] F) →
    (Fin n → E) → (Fin n → E) → Words n → (κ → F) → PairSlots n κ → F
  | 0, _, _, _, _, _, z => z
  | n + 1, l, r, u, v, w, z =>
      Sum.elim (fun i : Fin 2 =>
        if i = 0 then l (if w.1 then v 0 else u 0)
        else r (if w.1 then u 0 else v 0))
        (wordInputs n l r (Fin.tail u) (Fin.tail v) w.2 z)

theorem contractSites_expansion (n : ℕ)
    (f : MultilinearMap R (fun _ : PairSlots n κ => F) U)
    (l r : E →ₗ[R] F) (u v : Fin n → E) (z : κ → F) :
    contractSites n f l r u v z =
      ∑ w : Words n, wordSign (R := R) n w • f (wordInputs n l r u v w z) := by
  induction n with
  | zero => simp [contractSites, wordSign, wordInputs]
  | succ n ih =>
    simp only [contractSites, ih, Fintype.sum_prod_type, Fintype.sum_bool,
      wordSign, wordInputs, contractSite, pairAlternation, pairValue_eq, sub_apply,
      MultilinearMap.currySum_apply', ite_true, Bool.false_eq_true, ite_false]
    simp only [one_mul, neg_one_mul, smul_sub, neg_smul]
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro w _
    module

def wordsEquiv : (n : ℕ) → Words n ≃ (Fin n → Bool)
  | 0 => {
      toFun := fun _ i => Fin.elim0 i
      invFun := fun _ => ()
      left_inv := fun w => by cases w; rfl
      right_inv := fun w => by funext i; exact Fin.elim0 i }
  | n + 1 => {
      toFun := fun w => Fin.cons w.1 (wordsEquiv n w.2)
      invFun := fun w => (w 0, (wordsEquiv n).symm (Fin.tail w))
      left_inv := fun w => by
        simp only [Fin.cons_zero, Fin.tail_cons, Equiv.symm_apply_apply, Prod.mk.eta]
      right_inv := fun w => by
        simp only [Equiv.apply_symm_apply]
        exact Fin.cons_self_tail w }

theorem wordSign_eq_sign (n : ℕ) (w : Words n) :
    wordSign (R := R) n w = BinaryPairing.sign (wordsEquiv n w) := by
  induction n with
  | zero => simp [wordSign, BinaryPairing.sign]
  | succ n ih =>
    rw [wordSign, BinaryPairing.sign, Fin.prod_univ_succ]
    simp only [wordsEquiv, Equiv.coe_fn_mk, Fin.cons_zero, Fin.cons_succ]
    rw [ih]
    rfl

def prependSlot (n : ℕ) : Fin n ⊕ κ → Fin (n + 1) ⊕ κ := Sum.map Fin.succ id

def splitSlotsEquiv {η : Type*} : (n : ℕ) →
    PairSlots n (κ ⊕ η) ≃ (Fin n ⊕ κ) ⊕ (Fin n ⊕ η)
  | 0 => {
      toFun := Sum.elim (fun i => Sum.inl (Sum.inr i)) (fun j => Sum.inr (Sum.inr j))
      invFun := Sum.elim (Sum.elim Fin.elim0 Sum.inl) (Sum.elim Fin.elim0 Sum.inr)
      left_inv := fun i => by cases i <;> rfl
      right_inv := fun i => by
        cases i with
        | inl i => cases i with
          | inl i => exact Fin.elim0 i
          | inr i => rfl
        | inr i => cases i with
          | inl i => exact Fin.elim0 i
          | inr i => rfl }
  | n + 1 => by
      let e : PairSlots n (κ ⊕ η) ≃ (Fin n ⊕ κ) ⊕ (Fin n ⊕ η) :=
        splitSlotsEquiv (η := η) n
      let f : PairSlots (n + 1) (κ ⊕ η) →
          (Fin (n + 1) ⊕ κ) ⊕ (Fin (n + 1) ⊕ η) :=
        Sum.elim (fun i : Fin 2 => if i = 0 then Sum.inl (Sum.inl 0) else Sum.inr (Sum.inl 0))
          (fun i => Sum.map (prependSlot n) (prependSlot n) (e i))
      let g : ((Fin (n + 1) ⊕ κ) ⊕ (Fin (n + 1) ⊕ η)) →
          PairSlots (n + 1) (κ ⊕ η) :=
        Sum.elim
          (Sum.elim (Fin.cases (Sum.inl 0) (fun i => Sum.inr (e.symm (Sum.inl (Sum.inl i)))))
            (fun i => Sum.inr (e.symm (Sum.inl (Sum.inr i)))))
          (Sum.elim (Fin.cases (Sum.inl 1) (fun i => Sum.inr (e.symm (Sum.inr (Sum.inl i)))))
            (fun i => Sum.inr (e.symm (Sum.inr (Sum.inr i)))))
      have hg (i : (Fin n ⊕ κ) ⊕ (Fin n ⊕ η)) :
          g (Sum.map (prependSlot n) (prependSlot n) i) = Sum.inr (e.symm i) := by
        cases i with
        | inl i => cases i <;> rfl
        | inr i => cases i <;> rfl
      refine { toFun := f, invFun := g, left_inv := ?_, right_inv := ?_ }
      · intro i
        cases i with
        | inl i => fin_cases i <;> simp [f, g]
        | inr i =>
          change g (Sum.map (prependSlot n) (prependSlot n) (e i)) = Sum.inr i
          rw [hg, e.symm_apply_apply]
      · intro i
        cases i with
        | inl i => cases i with
          | inl i =>
            cases i using Fin.cases with
            | zero => simp [f, g]
            | succ i => simp [f, g, e.apply_symm_apply, prependSlot]
          | inr i => simp [f, g, e.apply_symm_apply, prependSlot]
        | inr i => cases i with
          | inl i =>
            cases i using Fin.cases with
            | zero => simp [f, g]
            | succ i => simp [f, g, e.apply_symm_apply, prependSlot]
          | inr i => simp [f, g, e.apply_symm_apply, prependSlot]

def leftWord (n : ℕ) (u v : Fin n → E) (w : Words n) : Fin n → E :=
  fun i => if wordsEquiv n w i then v i else u i

def rightWord (n : ℕ) (u v : Fin n → E) (w : Words n) : Fin n → E :=
  fun i => if wordsEquiv n w i then u i else v i

def splitReplicaInputs {η : Type*} (n : ℕ) (u v : Fin n → E) (w : Words n)
    (z : κ → E) (t : η → E) : (Fin n ⊕ κ) ⊕ (Fin n ⊕ η) → E × E :=
  Sum.elim (fun i => (Sum.elim (leftWord n u v w) z i, 0))
    (fun i => (0, Sum.elim (rightWord n u v w) t i))

theorem wordInputs_eq_split {η : Type*} (n : ℕ) (u v : Fin n → E) (w : Words n)
    (z : κ → E) (t : η → E) :
    wordInputs n (replicaLeft (R := R)) replicaRight u v w
      (Sum.elim (fun i => (z i, 0)) (fun i => (0, t i))) =
      fun i => splitReplicaInputs n u v w z t (splitSlotsEquiv (κ := κ) (η := η) n i) := by
  induction n with
  | zero =>
    funext i
    cases i <;> rfl
  | succ n ih =>
    funext i
    cases i with
    | inl i =>
      fin_cases i <;>
        simp [wordInputs, splitSlotsEquiv, splitReplicaInputs, leftWord, rightWord, wordsEquiv]
    | inr i =>
      have h := congrFun (ih (Fin.tail u) (Fin.tail v) w.2) i
      simp only [wordInputs, Sum.elim_inr]
      rw [h]
      cases he : splitSlotsEquiv (κ := κ) (η := η) n i with
      | inl i => cases i with
        | inl i =>
          simp [splitSlotsEquiv, splitReplicaInputs, prependSlot, leftWord, wordsEquiv, he]
          rfl
        | inr i => simp [splitSlotsEquiv, splitReplicaInputs, prependSlot, he]
      | inr i => cases i with
        | inl i =>
          simp [splitSlotsEquiv, splitReplicaInputs, prependSlot, rightWord, wordsEquiv, he]
          rfl
        | inr i => simp [splitSlotsEquiv, splitReplicaInputs, prependSlot, he]

theorem centeredMoment_wordInputs_factor [CharZero R] [Fintype κ]
    {η : Type*} [Fintype η] (B : E →ₗ[R] E →ₗ[R] R)
    (n : ℕ) (u v : Fin n → E) (w : Words n) (z : κ → E) (t : η → E) :
    centeredMoment (replicaCovariance B)
      (wordInputs n (replicaLeft (R := R)) replicaRight u v w
        (Sum.elim (fun i => (z i, 0)) (fun i => (0, t i)))) =
      centeredMoment B (Sum.elim (leftWord n u v w) z) *
        centeredMoment B (Sum.elim (rightWord n u v w) t) := by
  rw [wordInputs_eq_split]
  rw [centeredMoment_relabel _ (splitSlotsEquiv (κ := κ) (η := η) n)]
  exact centeredMoment_independent_replicas B _ _

theorem reflectedMoment_factor_sum [CharZero R] [Fintype κ]
    {η : Type*} [Fintype η] (B : E →ₗ[R] E →ₗ[R] R)
    (n : ℕ) (u v : Fin n → E) (z : κ → E) (t : η → E) :
    reflectedMoment B n u v
      (Sum.elim (fun i => (z i, 0)) (fun i => (0, t i))) =
      ∑ w : Words n, wordSign (R := R) n w *
        (centeredMoment B (Sum.elim (leftWord n u v w) z) *
          centeredMoment B (Sum.elim (rightWord n u v w) t)) := by
  rw [reflectedMoment, contractSites_expansion]
  apply Finset.sum_congr rfl
  intro w _
  rw [centeredMoment_wordInputs_factor, smul_eq_mul]

noncomputable def momentTensor [Fintype κ] (B : E →ₗ[R] E →ₗ[R] R)
    (n : ℕ) (u v : Fin n → E) (z : κ → E) : BinaryPairing.Tensor (Fin n) R :=
  fun w => centeredMoment B (Sum.elim (fun i => if w i then v i else u i) z)

theorem reflectedMoment_eq_pairing [CharZero R] [Fintype κ]
    {η : Type*} [Fintype η] (B : E →ₗ[R] E →ₗ[R] R)
    (n : ℕ) (u v : Fin n → E) (z : κ → E) (t : η → E) :
    reflectedMoment B n u v
      (Sum.elim (fun i => (z i, 0)) (fun i => (0, t i))) =
      BinaryPairing.pairing (momentTensor B n u v z) (momentTensor B n u v t) := by
  classical
  rw [reflectedMoment_factor_sum, BinaryPairing.pairing]
  convert! (Fintype.sum_equiv (wordsEquiv n)
    (fun w => wordSign (R := R) n w *
      (centeredMoment B (Sum.elim (leftWord n u v w) z) *
        centeredMoment B (Sum.elim (rightWord n u v w) t)))
    (fun w => BinaryPairing.sign w * momentTensor B n u v z w *
      momentTensor B n u v t (BinaryPairing.complement w)) ?_) using 1
  · congr 1
    ext w
    simp
  intro w
  rw [wordSign_eq_sign]
  have hr : Sum.elim (rightWord n u v w) t =
      Sum.elim (fun i => if BinaryPairing.complement (wordsEquiv n w) i then v i else u i) t := by
    funext i
    cases i with
    | inl i =>
      cases h : wordsEquiv n w i <;> simp [rightWord, BinaryPairing.complement, h]
    | inr i => rfl
  rw [hr]
  change BinaryPairing.sign (wordsEquiv n w) *
      (momentTensor B n u v z (wordsEquiv n w) *
        momentTensor B n u v t (BinaryPairing.complement (wordsEquiv n w))) = _
  ring

theorem pairing_momentTensor_roots_eq_zero [CharZero R]
    (B : E →ₗ[R] E →ₗ[R] R) (n p : ℕ) (hn : Odd n)
    (u v : Fin n → E) (g : E) :
    BinaryPairing.pairing
      (momentTensor B n u v (fun _ : Fin p => g))
      (momentTensor B n u v (fun _ : Unit => g)) = 0 := by
  rw [← reflectedMoment_eq_pairing]
  have hz : Sum.elim (fun _ : Fin p => (g, 0)) (fun _ : Unit => (0, g)) =
      Function.update (fun _ : Fin p ⊕ Unit => (g, 0)) (Sum.inr ()) (0, g) := by
    funext i
    cases i with
    | inl i => simp
    | inr i => cases i; simp
  rw [hz]
  convert! (one_root_replacement_eq_zero (κ := Fin p ⊕ Unit) B n hn u v g (Sum.inr ())) using 1
  congr 1
  funext i
  simp [Function.update]

end Krenn.ReflectionTensorBridge

-- formal/all-orders/WickPairing.lean

namespace Krenn.WickPairing

open scoped BigOperators Classical
open WickCovariance WickCoefficientBridge WickShiftedBridge WickReplicaBridge
open ReflectionResponses ReflectionTensorBridge

variable {K E : Type*} [Field K] [CharZero K] [AddCommGroup E] [Module K E]

noncomputable def responseTensor {n : ℕ} (B : E →ₗ[K] E →ₗ[K] K)
    (μ : E →ₗ[K] K) (u v : Fin n → E) : BinaryPairing.Tensor (Fin n) K :=
  fun w => shiftedMoment B μ (fun i => if w i then v i else u i)

abbrev NoAux := Fin 0 ⊕ Fin 0

def noAuxValues : NoAux → E × E := Sum.elim Fin.elim0 Fin.elim0

noncomputable def contractedShifted {n : ℕ} (B : E →ₗ[K] E →ₗ[K] K)
    (μ ν : E →ₗ[K] K) (u v : Fin n → E) : K :=
  contractSites n (shiftedMoment (replicaCovariance B) (replicaMean μ ν))
    replicaLeft replicaRight u v noAuxValues

omit [CharZero K] in
theorem replicaMean_comp_linear (μ ν : E →ₗ[K] K) (a b c d : K) :
    (replicaMean μ ν).comp (replicaLinear a b c d) =
      replicaMean (a • μ + c • ν) (b • μ + d • ν) := by
  apply LinearMap.ext
  intro x
  simp only [LinearMap.comp_apply, replicaMean_apply, replicaLinear_apply,
    map_add, map_smul, LinearMap.add_apply, LinearMap.smul_apply, smul_eq_mul]
  ring

theorem contractedShifted_linear {n : ℕ} (B : E →ₗ[K] E →ₗ[K] K)
    (μ ν : E →ₗ[K] K) (u v : Fin n → E) (a b c d : K)
    (h1 : a * a + c * c = 1) (h2 : b * b + d * d = 1)
    (h12 : a * b + c * d = 0) :
    contractedShifted B (a • μ + c • ν) (b • μ + d • ν) u v =
      (a * d - b * c) ^ n * contractedShifted B μ ν u v := by
  let T := replicaLinear (E := E) a b c d
  let f := shiftedMoment (ι := PairSlots n NoAux) (replicaCovariance B) (replicaMean μ ν)
  have hf : SlotSymmetric f := fun τ z => shiftedMoment_permute _ _ τ z
  have hcov : ∀ x y, replicaCovariance B (T x) (T y) = replicaCovariance B x y :=
    replicaLinear_covariance B a b c d
      (by simpa only [pow_two] using h1) (by simpa only [pow_two] using h2) h12
  have hm : shiftedMoment (ι := PairSlots n NoAux) (replicaCovariance B)
      (replicaMean (a • μ + c • ν) (b • μ + d • ν)) =
      f.compLinearMap (fun _ => T) := by
    ext z
    rw [MultilinearMap.compLinearMap_apply]
    change _ = shiftedMoment (replicaCovariance B) (replicaMean μ ν) (fun i => T (z i))
    rw [shiftedMoment_invariant _ _ T hcov, replicaMean_comp_linear]
  unfold contractedShifted
  rw [hm, contractSites_compLinearMap, replicaLinear_comp_left, replicaLinear_comp_right,
    contractSites_determinant n f hf]
  simp only [MultilinearMap.compLinearMap_apply, smul_apply, smul_eq_mul]
  congr 1
  congr 1
  funext i
  cases i with
  | inl i => exact Fin.elim0 i
  | inr i => exact Fin.elim0 i

theorem contractedShifted_rotation {n : ℕ} (B : E →ₗ[K] E →ₗ[K] K)
    (μ ν : E →ₗ[K] K) (u v : Fin n → E) (a b : K) (hab : a * a + b * b = 1) :
    contractedShifted B (a • μ - b • ν) (b • μ + a • ν) u v =
      contractedShifted B μ ν u v := by
  have h := contractedShifted_linear B μ ν u v a b (-b) a
    (by simpa only [neg_mul_neg] using hab) (by rw [add_comm]; exact hab) (by ring)
  have hdet : a * a - b * (-b) = 1 := by
    simpa only [mul_neg, sub_neg_eq_add] using hab
  have hc : a • μ + (-b) • ν = a • μ - b • ν := by module
  simpa only [hc, hdet, one_pow, one_mul] using h

theorem contractedShifted_diagonal {n : ℕ} (B : E →ₗ[K] E →ₗ[K] K)
    (μ : E →ₗ[K] K) (u v : Fin n → E) (s : K) (hs : s * s = 2) :
    contractedShifted B μ μ u v = contractedShifted B 0 (s • μ) u v := by
  have hab : (s / 2) * (s / 2) + (s / 2) * (s / 2) = 1 := by
    field_simp
    linear_combination 2 * hs
  have h := contractedShifted_rotation B μ μ u v (s / 2) (s / 2) hab
  rw [sub_self, ← add_smul, show s / 2 + s / 2 = s by ring] at h
  exact h.symm

theorem shiftedMoment_sum_fin_zero {n : ℕ} (B : E →ₗ[K] E →ₗ[K] K)
    (μ : E →ₗ[K] K) (v : Fin n → E) :
    shiftedMoment B μ (Sum.elim v (Fin.elim0 : Fin 0 → E)) = shiftedMoment B μ v := by
  have hfun : Sum.elim v (Fin.elim0 : Fin 0 → E) =
      fun i => v (Equiv.sumEmpty (Fin n) (Fin 0) i) := by
    funext i
    cases i with
    | inl i => rfl
    | inr i => exact Fin.elim0 i
  rw [hfun, shiftedMoment_relabel]

theorem contractedShifted_eq_pairing {n : ℕ} (B : E →ₗ[K] E →ₗ[K] K)
    (μ ν : E →ₗ[K] K) (u v : Fin n → E) :
    contractedShifted B μ ν u v =
      BinaryPairing.pairing (responseTensor B μ u v) (responseTensor B ν u v) := by
  rw [contractedShifted, contractSites_expansion, BinaryPairing.pairing]
  convert! (Fintype.sum_equiv (wordsEquiv n)
    (fun w => wordSign (R := K) n w •
      shiftedMoment (replicaCovariance B) (replicaMean μ ν)
        (wordInputs n replicaLeft replicaRight u v w noAuxValues))
    (fun w => BinaryPairing.sign w * responseTensor B μ u v w *
      responseTensor B ν u v (BinaryPairing.complement w)) ?_) using 1
  · congr 1
    ext w
    simp
  intro w
  have hz : noAuxValues (E := E) =
      Sum.elim (fun i : Fin 0 => (Fin.elim0 i, (0 : E)))
        (fun j : Fin 0 => ((0 : E), Fin.elim0 j)) := by
    funext i
    cases i with
    | inl i => exact Fin.elim0 i
    | inr i => exact Fin.elim0 i
  rw [hz, wordInputs_eq_split, shiftedMoment_relabel _ _ (splitSlotsEquiv n)]
  simp only [splitReplicaInputs]
  rw [shiftedMoment_independent_replicas B μ ν
    (Sum.elim (leftWord n u v w) Fin.elim0) (Sum.elim (rightWord n u v w) Fin.elim0),
    shiftedMoment_sum_fin_zero, shiftedMoment_sum_fin_zero, wordSign_eq_sign, smul_eq_mul]
  have hr : rightWord n u v w =
      fun i => if BinaryPairing.complement (wordsEquiv n w) i then v i else u i := by
    funext i
    cases h : wordsEquiv n w i <;> simp [rightWord, BinaryPairing.complement, h]
  rw [hr]
  change BinaryPairing.sign (wordsEquiv n w) *
      (responseTensor B μ u v (wordsEquiv n w) *
        responseTensor B ν u v (BinaryPairing.complement (wordsEquiv n w))) = _
  ring

theorem response_pairing_rotation {n : ℕ} (B : E →ₗ[K] E →ₗ[K] K)
    (μ ν : E →ₗ[K] K) (u v : Fin n → E) (a b : K) (hab : a * a + b * b = 1) :
    BinaryPairing.pairing (responseTensor B (a • μ - b • ν) u v)
      (responseTensor B (b • μ + a • ν) u v) =
      BinaryPairing.pairing (responseTensor B μ u v) (responseTensor B ν u v) := by
  simp only [← contractedShifted_eq_pairing]
  exact contractedShifted_rotation B μ ν u v a b hab

theorem response_pairing_diagonal {n : ℕ} (B : E →ₗ[K] E →ₗ[K] K)
    (μ : E →ₗ[K] K) (u v : Fin n → E) (s : K) (hs : s * s = 2) :
    BinaryPairing.pairing (responseTensor B μ u v) (responseTensor B μ u v) =
      BinaryPairing.pairing (responseTensor B 0 u v) (responseTensor B (s • μ) u v) := by
  simp only [← contractedShifted_eq_pairing]
  exact contractedShifted_diagonal B μ u v s hs

theorem response_pairing_diagonal_line {n : ℕ} (B : E →ₗ[K] E →ₗ[K] K)
    (μ ν : E →ₗ[K] K) (u v : Fin n → E) (s : K) (hs : s * s = 2) (t : K) :
    BinaryPairing.pairing (responseTensor B (μ + t • ν) u v)
      (responseTensor B (μ + t • ν) u v) =
      BinaryPairing.pairing (responseTensor B 0 u v)
        (responseTensor B (s • (μ + t • ν)) u v) :=
  response_pairing_diagonal B (μ + t • ν) u v s hs

end Krenn.WickPairing

-- formal/all-orders/WickFinitePairing.lean

namespace Krenn.WickFinitePairing

open scoped BigOperators Classical
open WickCovariance WickReplicaBridge

variable {ι κ K E : Type*} [Fintype ι] [Fintype κ]

def wordEquiv (e : ι ≃ κ) : (ι → Bool) ≃ (κ → Bool) where
  toFun w := fun j => w (e.symm j)
  invFun w := fun i => w (e i)
  left_inv w := by funext i; simp
  right_inv w := by funext i; simp

@[simp] theorem sign_wordEquiv [CommRing K] (e : ι ≃ κ) (w : ι → Bool) :
    BinaryPairing.sign (R := K) (wordEquiv e w) = BinaryPairing.sign w := by
  unfold BinaryPairing.sign
  exact Equiv.prod_comp e.symm (fun i => if w i then (-1 : K) else 1)

omit [Fintype ι] [Fintype κ] in
@[simp] theorem complement_wordEquiv (e : ι ≃ κ) (w : ι → Bool) :
    BinaryPairing.complement (wordEquiv e w) =
      wordEquiv e (BinaryPairing.complement w) := rfl

theorem pairing_reindex [CommRing K] (e : ι ≃ κ)
    (P Q : BinaryPairing.Tensor κ K) :
    BinaryPairing.pairing (fun w => P (wordEquiv e w))
      (fun w => Q (wordEquiv e w)) = BinaryPairing.pairing P Q := by
  unfold BinaryPairing.pairing
  exact Fintype.sum_equiv (wordEquiv e) _ _ (fun w => by simp)

variable [Field K] [CharZero K] [AddCommGroup E] [Module K E]

noncomputable def responseTensor (B : E →ₗ[K] E →ₗ[K] K)
    (μ : E →ₗ[K] K) (u v : ι → E) : BinaryPairing.Tensor ι K :=
  fun w => shiftedMoment B μ (fun i => if w i then v i else u i)

theorem responseTensor_reindex (B : E →ₗ[K] E →ₗ[K] K)
    (μ : E →ₗ[K] K) (u v : κ → E) (e : ι ≃ κ) (w : ι → Bool) :
    responseTensor B μ (fun i => u (e i)) (fun i => v (e i)) w =
      responseTensor B μ u v (wordEquiv e w) := by
  unfold responseTensor
  have h := shiftedMoment_relabel B μ e
    (fun j => if wordEquiv e w j then v j else u j)
  simpa only [wordEquiv, Equiv.coe_fn_mk, Equiv.symm_apply_apply] using h

theorem response_pairing_rotation (B : E →ₗ[K] E →ₗ[K] K)
    (μ ν : E →ₗ[K] K) (u v : ι → E) (a b : K) (hab : a * a + b * b = 1) :
    BinaryPairing.pairing (responseTensor B (a • μ - b • ν) u v)
      (responseTensor B (b • μ + a • ν) u v) =
      BinaryPairing.pairing (responseTensor B μ u v) (responseTensor B ν u v) := by
  let e := (Fintype.equivFin ι).symm
  have h := WickPairing.response_pairing_rotation B μ ν
    (fun i => u (e i)) (fun i => v (e i)) a b hab
  have hr (ξ : E →ₗ[K] K) :
      WickPairing.responseTensor B ξ (fun i => u (e i)) (fun i => v (e i)) =
        fun w => responseTensor B ξ u v (wordEquiv e w) := by
    funext w
    exact responseTensor_reindex B ξ u v e w
  simp only [hr, pairing_reindex] at h
  exact h

theorem response_pairing_diagonal (B : E →ₗ[K] E →ₗ[K] K)
    (μ : E →ₗ[K] K) (u v : ι → E) (s : K) (hs : s * s = 2) :
    BinaryPairing.pairing (responseTensor B μ u v) (responseTensor B μ u v) =
      BinaryPairing.pairing (responseTensor B 0 u v) (responseTensor B (s • μ) u v) := by
  have hab : (s / 2) * (s / 2) + (s / 2) * (s / 2) = 1 := by
    field_simp
    linear_combination 2 * hs
  have h := response_pairing_rotation B μ μ u v (s / 2) (s / 2) hab
  rw [sub_self, ← add_smul, show s / 2 + s / 2 = s by ring] at h
  exact h.symm

theorem response_pairing_diagonal_line (B : E →ₗ[K] E →ₗ[K] K)
    (μ ν : E →ₗ[K] K) (u v : ι → E) (s : K) (hs : s * s = 2) (t : K) :
    BinaryPairing.pairing (responseTensor B (μ + t • ν) u v)
      (responseTensor B (μ + t • ν) u v) =
      BinaryPairing.pairing (responseTensor B 0 u v)
        (responseTensor B (s • (μ + t • ν)) u v) :=
  response_pairing_diagonal B (μ + t • ν) u v s hs

end Krenn.WickFinitePairing

-- formal/all-orders/OddRotation.lean

namespace Krenn.OddRotation

open scoped BigOperators Classical
open MvPolynomial

variable {K σ : Type*} [Field K] [CharZero K]

noncomputable def alternatingFactor (i j : σ) : MvPolynomial (σ ⊕ σ) K :=
  X (Sum.inl i) * X (Sum.inr j) - X (Sum.inl j) * X (Sum.inr i)

noncomputable def leftCopy : MvPolynomial σ K →+* MvPolynomial (σ ⊕ σ) K :=
  (rename (Sum.inl : σ → σ ⊕ σ)).toRingHom

noncomputable def rightCopy : MvPolynomial σ K →+* MvPolynomial (σ ⊕ σ) K :=
  (rename (Sum.inr : σ → σ ⊕ σ)).toRingHom

noncomputable def rotatedLeft (s : K) : MvPolynomial σ K →+* MvPolynomial (σ ⊕ σ) K :=
  eval₂Hom C (fun i => C s * (X (Sum.inl i) - X (Sum.inr i)))

noncomputable def rotatedRight (s : K) : MvPolynomial σ K →+* MvPolynomial (σ ⊕ σ) K :=
  eval₂Hom C (fun i => C s * (X (Sum.inl i) + X (Sum.inr i)))

omit [CharZero K] in
@[simp] theorem eval_leftCopy (a : σ ⊕ σ → K) (g : MvPolynomial σ K) :
    eval a (leftCopy g) = eval (fun i => a (Sum.inl i)) g :=
  eval_rename _ _ _

omit [CharZero K] in
@[simp] theorem eval_rightCopy (a : σ ⊕ σ → K) (g : MvPolynomial σ K) :
    eval a (rightCopy g) = eval (fun i => a (Sum.inr i)) g :=
  eval_rename _ _ _

omit [CharZero K] in
@[simp] theorem eval_rotatedLeft (a : σ ⊕ σ → K) (s : K) (g : MvPolynomial σ K) :
    eval a (rotatedLeft s g) =
      eval (fun i => s * (a (Sum.inl i) - a (Sum.inr i))) g := by
  have hhom : (eval a).comp (rotatedLeft s) =
      eval (fun i => s * (a (Sum.inl i) - a (Sum.inr i))) := by
    ext <;> simp [rotatedLeft]
  exact RingHom.congr_fun hhom g

omit [CharZero K] in
@[simp] theorem eval_rotatedRight (a : σ ⊕ σ → K) (s : K) (g : MvPolynomial σ K) :
    eval a (rotatedRight s g) =
      eval (fun i => s * (a (Sum.inl i) + a (Sum.inr i))) g := by
  have hhom : (eval a).comp (rotatedRight s) =
      eval (fun i => s * (a (Sum.inl i) + a (Sum.inr i))) := by
    ext <;> simp [rotatedRight]
  exact RingHom.congr_fun hhom g

theorem alternatingFactor_ne_zero {i j : σ} (hij : i ≠ j) :
    alternatingFactor (K := K) i j ≠ 0 := by
  classical
  intro hz
  have h := congrArg (eval (Sum.elim (fun a => if a = i then 1 else 0)
    (fun b => if b = j then 1 else 0))) hz
  simp [alternatingFactor, hij, hij.symm] at h

theorem cancel_alternating_rotation (g : MvPolynomial σ K) {i j : σ}
    (hij : i ≠ j) (s : K)
    (hrotation : ∀ a b : σ → K,
      (a i * b j - a j * b i) *
          (eval (fun h => s * (a h - b h)) g * eval (fun h => s * (a h + b h)) g) =
        (a i * b j - a j * b i) * (eval a g * eval b g)) :
    rotatedLeft s g * rotatedRight s g = leftCopy g * rightCopy g := by
  apply mul_left_cancel₀ (alternatingFactor_ne_zero hij)
  apply MvPolynomial.funext
  intro a
  simpa only [map_mul, eval_rotatedLeft, eval_rotatedRight, eval_leftCopy,
    eval_rightCopy, alternatingFactor, map_sub, eval_X] using
    hrotation (fun i => a (Sum.inl i)) (fun i => a (Sum.inr i))

theorem rescaling_square_of_alternating_rotation (g : MvPolynomial σ K) {i j : σ}
    (hij : i ≠ j) (s : K) (hzero : eval (fun _ => 0) g = 1)
    (hrotation : ∀ a b : σ → K,
      (a i * b j - a j * b i) *
          (eval (fun h => s * (a h - b h)) g * eval (fun h => s * (a h + b h)) g) =
        (a i * b j - a j * b i) * (eval a g * eval b g)) :
    (FiniteResponseRigidity.scaleVariables s g) ^ 2 = g := by
  have hpoly := cancel_alternating_rotation g hij s hrotation
  apply MvPolynomial.funext
  intro a
  have h := congrArg (eval (Sum.elim a (fun _ => 0))) hpoly
  simp only [map_mul, eval_rotatedLeft, eval_rotatedRight, eval_leftCopy,
    eval_rightCopy, Sum.elim_inl, Sum.elim_inr, sub_zero, add_zero, hzero, mul_one] at h
  have hs : eval a (FiniteResponseRigidity.scaleVariables s g) =
      eval (fun i => s * a i) g := by
    have hh : (eval a).comp (FiniteResponseRigidity.scaleVariables s) =
        eval (fun i => s * a i) := by
      ext <;> simp [FiniteResponseRigidity.scaleVariables]
    exact RingHom.congr_fun hh g
  rw [map_pow, hs, pow_two]
  exact h

section ActualResponse

variable {ι E : Type*} [Fintype ι] [Nonempty ι] [AddCommGroup E] [Module K E]

omit [CharZero K] in

theorem pairing_factored_response (B : E →ₗ[K] E →ₗ[K] K)
    (μ : (σ → K) →ₗ[K] (E →ₗ[K] K)) (u v : ι → E)
    (g : MvPolynomial σ K) (i j : σ) (hodd : Odd (Fintype.card ι))
    (hfactor : ∀ a : σ → K, WickFinitePairing.responseTensor B (μ a) u v =
      eval a g • (a i • BinaryPairing.pure false + a j • BinaryPairing.pure true))
    (a b : σ → K) :
    BinaryPairing.pairing (WickFinitePairing.responseTensor B (μ a) u v)
      (WickFinitePairing.responseTensor B (μ b) u v) =
      (a i * b j - a j * b i) * (eval a g * eval b g) := by
  rw [hfactor a, hfactor b, BinaryPairing.pairing_smul_left,
    BinaryPairing.pairing_smul_right, BinaryPairing.pairing_pure_combinations_odd hodd]
  ring

theorem actual_alternating_rotation (B : E →ₗ[K] E →ₗ[K] K)
    (μ : (σ → K) →ₗ[K] (E →ₗ[K] K)) (u v : ι → E)
    (g : MvPolynomial σ K) (i j : σ) (hodd : Odd (Fintype.card ι))
    (hfactor : ∀ a : σ → K, WickFinitePairing.responseTensor B (μ a) u v =
      eval a g • (a i • BinaryPairing.pure false + a j • BinaryPairing.pure true))
    (s : K) (hs : s * s + s * s = 1) (a b : σ → K) :
    (a i * b j - a j * b i) *
        (eval (fun h => s * (a h - b h)) g * eval (fun h => s * (a h + b h)) g) =
      (a i * b j - a j * b i) * (eval a g * eval b g) := by
  have h := WickFinitePairing.response_pairing_rotation B (μ a) (μ b) u v s s hs
  have hm : μ (s • a - s • b) = s • μ a - s • μ b := by simp
  have hp : μ (s • a + s • b) = s • μ a + s • μ b := by simp
  rw [← hm, ← hp, pairing_factored_response B μ u v g i j hodd hfactor,
    pairing_factored_response B μ u v g i j hodd hfactor] at h
  have hd : (s • a - s • b) i * (s • a + s • b) j -
      (s • a - s • b) j * (s • a + s • b) i = a i * b j - a j * b i := by
    simp only [Pi.sub_apply, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
    linear_combination (a i * b j - a j * b i) * hs
  rw [hd] at h
  have ha' : (fun h => s * (a h - b h)) = s • a - s • b := by
    funext x
    simp only [Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
    ring
  have hb' : (fun h => s * (a h + b h)) = s • a + s • b := by
    funext x
    simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
    ring
  simpa only [ha', hb'] using h

theorem actual_scalar_factor_eq_one (B : E →ₗ[K] E →ₗ[K] K)
    (μ : (σ → K) →ₗ[K] (E →ₗ[K] K)) (u v : ι → E)
    (g : MvPolynomial σ K) {i j : σ} (hij : i ≠ j)
    (hodd : Odd (Fintype.card ι))
    (hfactor : ∀ a : σ → K, WickFinitePairing.responseTensor B (μ a) u v =
      eval a g • (a i • BinaryPairing.pure false + a j • BinaryPairing.pure true))
    (hzero : eval (fun _ => 0) g = 1) (s : K) (hs : s * s + s * s = 1) : g = 1 := by
  have hs0 : s ≠ 0 := by intro h; simp [h] at hs
  apply FiniteResponseRigidity.eq_one_of_rescaling_square g s hs0 hzero
  exact rescaling_square_of_alternating_rotation g hij s hzero
    (actual_alternating_rotation B μ u v g i j hodd hfactor s hs)

theorem higher_factors_zero_of_actual_rotation {D : ℕ}
    (B : E →ₗ[K] E →ₗ[K] K)
    (μ : (Fin D → K) →ₗ[K] (E →ₗ[K] K)) (u v : ι → E)
    (k : ℕ) (q : ℕ → MvPolynomial (Fin D) K)
    (hq : ∀ r ≤ k, IsWeightedHomogeneous (fun _ : Fin D => (1 : ℕ)) (q r) (2 * r))
    (hzero : q 0 = 1) {i j : Fin D} (hij : i ≠ j)
    (hodd : Odd (Fintype.card ι))
    (hfactor : ∀ a : Fin D → K, WickFinitePairing.responseTensor B (μ a) u v =
      eval a (OddResponseVanishing.finiteScalarFactor k q) •
        (a i • BinaryPairing.pure false + a j • BinaryPairing.pure true))
    (s : K) (hs : s * s + s * s = 1)
    (r : ℕ) (hr : r ≤ k) (hpos : 0 < r) : q r = 0 := by
  have hnorm := OddResponseVanishing.finiteScalarFactor_eval_zero k q hq hzero
  have hg := actual_scalar_factor_eq_one B μ u v
    (OddResponseVanishing.finiteScalarFactor k q) hij hodd hfactor hnorm s hs
  exact OddResponseVanishing.factors_zero_of_finiteScalarFactor_eq_one k q hq hg r hr hpos

theorem actual_response_eq_linear (B : E →ₗ[K] E →ₗ[K] K)
    (μ : (σ → K) →ₗ[K] (E →ₗ[K] K)) (u v : ι → E)
    (g : MvPolynomial σ K) {i j : σ} (hij : i ≠ j)
    (hodd : Odd (Fintype.card ι))
    (hfactor : ∀ a : σ → K, WickFinitePairing.responseTensor B (μ a) u v =
      eval a g • (a i • BinaryPairing.pure false + a j • BinaryPairing.pure true))
    (hzero : eval (fun _ => 0) g = 1) (s : K) (hs : s * s + s * s = 1)
    (a : σ → K) : WickFinitePairing.responseTensor B (μ a) u v =
      a i • BinaryPairing.pure false + a j • BinaryPairing.pure true := by
  have hg := actual_scalar_factor_eq_one B μ u v g hij hodd hfactor hzero s hs
  rw [hfactor a, hg, map_one, one_smul]

end ActualResponse

end Krenn.OddRotation

-- formal/all-orders/WickPhysicalBridge.lean

namespace Krenn.WickPhysicalBridge

open scoped BigOperators Classical
open MatchingModel SiteAlgebra RootResponse OddResponseVanishing
open WickCovariance WickCoefficientBridge WickRootBridge ReflectionTensorBridge

variable {K : Type*} {N D : ℕ} [Field K]

abbrev PhysicalSpace (N D : ℕ) (K : Type*) := SiteVariable N D → K

noncomputable def physicalBasis (z : SiteVariable N D) : PhysicalSpace N D K := Pi.single z 1

noncomputable def physicalCovariance (W : WeightsN N D K) :
    PhysicalSpace N D K →ₗ[K] PhysicalSpace N D K →ₗ[K] K :=
  Matrix.toBilin' (edgeMatrix W)

@[simp]
theorem physicalCovariance_basis (W : WeightsN N D K) (z t : SiteVariable N D) :
    physicalCovariance W (physicalBasis z) (physicalBasis t) = edgeMatrix W z t :=
  Matrix.toBilin'_single _ _ _

noncomputable def physicalRoot (p : V N) (a : Fin D → K) : PhysicalSpace N D K :=
  ∑ i, a i • physicalBasis (p, i)

theorem physicalCovariance_root_basis (W : WeightsN N D K) (p : V N)
    (a : Fin D → K) (z : SiteVariable N D) :
    physicalCovariance W (physicalRoot p a) (physicalBasis z) =
      ∑ i, a i * edgeMatrix W (p, i) z := by
  simp only [physicalRoot, map_sum, map_smul, LinearMap.sum_apply,
    LinearMap.smul_apply, smul_eq_mul, physicalCovariance_basis]

theorem physicalCovariance_basis_root (W : WeightsN N D K) (p : V N)
    (a : Fin D → K) (z : SiteVariable N D) :
    physicalCovariance W (physicalBasis z) (physicalRoot p a) =
      ∑ i, a i * edgeMatrix W (p, i) z := by
  simp only [physicalRoot, map_sum, map_smul, smul_eq_mul, physicalCovariance_basis]
  apply Finset.sum_congr rfl
  intro i _
  rw [edgeMatrix_symm]

theorem physicalRoot_isotropic (W : WeightsN N D K) (p : V N) (a : Fin D → K) :
    physicalCovariance W (physicalRoot p a) (physicalRoot p a) = 0 := by
  simp only [physicalRoot, map_sum, map_smul, LinearMap.sum_apply,
    LinearMap.smul_apply, smul_eq_mul, physicalCovariance_basis,
    edgeMatrix_same_site, mul_zero, Finset.sum_const_zero]

section Restriction

variable {σ τ A : Type*} [Fintype σ] [Fintype τ] [AddCommMonoid A]

theorem sum_of_supported_injection (f : σ → τ) (hf : Function.Injective f)
    (g : τ → A) (hg : ∀ j, j ∉ Set.range f → g j = 0) :
    (∑ j : τ, g j) = ∑ i : σ, g (f i) := by
  classical
  calc
    _ = ∑ j ∈ Finset.univ.image f, g j := by
      symm
      apply Finset.sum_subset (Finset.subset_univ _)
      intro j _ hj
      apply hg
      rintro ⟨i, rfl⟩
      exact hj (Finset.mem_image.mpr ⟨i, Finset.mem_univ _, rfl⟩)
    _ = _ := Finset.sum_image (fun i _ j _ hij => hf hij)

end Restriction

section PolynomialRestriction

variable {σ τ : Type*} [Fintype σ] [Fintype τ]

omit [Fintype σ] [Fintype τ] in
theorem killCompl_X_image (f : σ → τ) (hf : Function.Injective f) (i : σ) :
    MvPolynomial.killCompl (R := K) hf (MvPolynomial.X (f i)) = MvPolynomial.X i := by
  simpa only [MvPolynomial.rename_X] using
    MvPolynomial.killCompl_rename_app hf (MvPolynomial.X i : MvPolynomial σ K)

omit [Fintype σ] [Fintype τ] in
theorem killCompl_X_outside (f : σ → τ) (hf : Function.Injective f) (j : τ)
    (hj : j ∉ Set.range f) :
    MvPolynomial.killCompl (R := K) hf (MvPolynomial.X j) = 0 := by
  simp only [MvPolynomial.killCompl, MvPolynomial.aeval_X, dif_neg hj]

theorem killCompl_linearPolynomial (f : σ → τ) (hf : Function.Injective f) (μ : τ → K) :
    MvPolynomial.killCompl hf (linearPolynomial μ) = linearPolynomial (fun i => μ (f i)) := by
  simp only [linearPolynomial, map_sum, map_mul, MvPolynomial.killCompl_C]
  rw [sum_of_supported_injection f hf]
  · simp_rw [killCompl_X_image]
  · intro j hj
    rw [killCompl_X_outside f hf j hj, mul_zero]

theorem killCompl_symmetricQuadratic (f : σ → τ) (hf : Function.Injective f)
    (S : τ → τ → K) :
    MvPolynomial.killCompl hf (WickCoefficientBridge.symmetricQuadratic S) =
      WickCoefficientBridge.symmetricQuadratic (fun i j => S (f i) (f j)) := by
  simp only [WickCoefficientBridge.symmetricQuadratic, rawQuadratic,
    map_mul, map_sum, MvPolynomial.killCompl_C]
  congr 1
  rw [sum_of_supported_injection f hf]
  · apply Finset.sum_congr rfl
    intro i _
    rw [sum_of_supported_injection f hf]
    · simp_rw [killCompl_X_image]
    · intro j hj
      rw [killCompl_X_outside f hf j hj, mul_zero]
  · intro j hj
    simp only [killCompl_X_outside f hf j hj, mul_zero, zero_mul, Finset.sum_const_zero]

end PolynomialRestriction

section SelectedSites

def selectedInput (S : Finset (V N)) (ι : V N → Fin D) (q : ↥S) :
    SiteVariable N D := (q.1, ι q.1)

theorem selectedInput_injective (S : Finset (V N)) (ι : V N → Fin D) :
    Function.Injective (selectedInput S ι) := by
  intro q r h
  apply Subtype.ext
  exact congrArg Prod.fst h

noncomputable def selectedRestriction (S : Finset (V N)) (ι : V N → Fin D) :
    MatchingPolynomial N D K →ₐ[K] MvPolynomial (↥S) K :=
  MvPolynomial.killCompl (selectedInput_injective S ι)

theorem topExponent_map_selectedInput (S : Finset (V N)) (ι : V N → Fin D) :
    (topExponent (↥S)).mapDomain (selectedInput S ι) =
      ∑ q ∈ S, Finsupp.single (q, ι q) 1 := by
  classical
  rw [topExponent]
  change (Finsupp.mapDomain.addMonoidHom (selectedInput S ι))
    (∑ i : ↥S, Finsupp.single i 1) = _
  rw [map_sum (Finsupp.mapDomain.addMonoidHom (selectedInput S ι))]
  change (∑ i : ↥S, (Finsupp.single i 1).mapDomain (selectedInput S ι)) = _
  simp only [Finsupp.mapDomain_single, selectedInput]
  symm
  exact Finset.sum_subtype S (fun q => Iff.rfl) _

theorem coeff_selectedRestriction (S : Finset (V N)) (ι : V N → Fin D)
    (P : MatchingPolynomial N D K) :
    MvPolynomial.coeff (topExponent (↥S)) (selectedRestriction S ι P) =
      MvPolynomial.coeff (∑ q ∈ S, Finsupp.single (q, ι q) 1) P := by
  rw [selectedRestriction, MvPolynomial.coeff_killCompl,
    topExponent_map_selectedInput]

theorem wordExponent_eq_list_sum (ι : V N → Fin D) (L : List (V N)) :
    wordExponent ι L = (L.map (fun q => Finsupp.single (q, ι q) 1)).sum := by
  induction L with
  | nil => rfl
  | cons q L ih => simp only [wordExponent, List.map_cons, List.sum_cons, ih]

theorem wordExponent_eq_finset_sum (ι : V N → Fin D) (L : List (V N))
    (hL : L.Nodup) :
    wordExponent ι L = ∑ q ∈ L.toFinset, Finsupp.single (q, ι q) 1 := by
  rw [wordExponent_eq_list_sum]
  exact (List.sum_toFinset _ hL).symm

theorem coeff_selectedRestriction_list (ι : V N → Fin D) (L : List (V N))
    (hL : L.Nodup) (P : MatchingPolynomial N D K) :
    MvPolynomial.coeff (topExponent (↥L.toFinset))
      (selectedRestriction L.toFinset ι P) =
        MvPolynomial.coeff (wordExponent ι L) P := by
  rw [coeff_selectedRestriction, wordExponent_eq_finset_sum ι L hL]

theorem selectedRestriction_eraseSite (S : Finset (V N)) (ι : V N → Fin D)
    (p : V N) (hp : p ∉ S) (P : MatchingPolynomial N D K) :
    selectedRestriction S ι (eraseSite p P) = selectedRestriction S ι P := by
  classical
  induction P using MvPolynomial.induction_on with
  | C a => simp only [eraseSite_C]
  | add P Q ihP ihQ => simp only [map_add, ihP, ihQ]
  | mul_X P z ih =>
    simp only [map_mul, ih, eraseSite_X]
    by_cases hz : z.1 = p
    · rw [if_pos hz, map_zero]
      have hout : z ∉ Set.range (selectedInput S ι) := by
        rintro ⟨q, hq⟩
        have hqp : q.1 = p := (congrArg Prod.fst hq).trans hz
        exact hp (hqp ▸ q.2)
      rw [show selectedRestriction S ι (MvPolynomial.X z) = 0 from
        killCompl_X_outside _ _ _ hout]
    · rw [if_neg hz]

theorem selectedRestriction_rowAt (S : Finset (V N)) (ι : V N → Fin D)
    (W : WeightsN N D K) (p : V N) (a : Fin D → K) :
    selectedRestriction S ι (rowAt W p a) =
      linearPolynomial (fun q : ↥S =>
        physicalCovariance W (physicalRoot p a) (physicalBasis (selectedInput S ι q))) := by
  classical
  simp only [rowAt, rootFamilyRow, map_sum, map_mul,
    selectedRestriction, MvPolynomial.killCompl_C]
  have hrow : ∀ i, MvPolynomial.killCompl (selectedInput_injective S ι)
      (rowPolynomial (edgeMatrix W) (p, i)) =
        linearPolynomial (fun q : ↥S => edgeMatrix W (p, i) (selectedInput S ι q)) :=
    fun i => killCompl_linearPolynomial _ _ _
  simp_rw [hrow]
  simp only [linearPolynomial, physicalCovariance_root_basis, map_sum,
    Finset.mul_sum, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro q _
  apply Finset.sum_congr rfl
  intro i _
  rw [map_mul]
  ring

theorem selectedRestriction_deletedQuadratic (S : Finset (V N))
    (ι : V N → Fin D) (W : WeightsN N D K) (p : V N) (hp : p ∉ S) :
    selectedRestriction S ι (deletedQuadratic W p) =
      WickCoefficientBridge.symmetricQuadratic (fun q r : ↥S =>
        physicalCovariance W (physicalBasis (selectedInput S ι q))
          (physicalBasis (selectedInput S ι r))) := by
  rw [deletedQuadratic, selectedRestriction_eraseSite S ι p hp]
  change MvPolynomial.killCompl (selectedInput_injective S ι)
    (WickCoefficientBridge.symmetricQuadratic (edgeMatrix W)) = _
  rw [killCompl_symmetricQuadratic]
  simp only [physicalCovariance_basis]

end SelectedSites

section PhysicalRootMoments

variable [CharZero K]

theorem centeredMoment_selected_roots {κ : Type*} [Fintype κ] [DecidableEq κ]
    (S : Finset (V N)) (ι : V N → Fin D) (W : WeightsN N D K) (p : V N)
    (a : Fin D → K) (k d : ℕ) (hS : S.card = 2 * k + d)
    (hκ : Fintype.card κ = d) (hp : p ∉ S) :
    centeredMoment (physicalCovariance W)
      (Sum.elim (fun q : ↥S => physicalBasis (selectedInput S ι q))
        (fun _ : κ => physicalRoot p a)) =
      MvPolynomial.coeff (∑ q ∈ S, Finsupp.single (q, ι q) 1)
        (MvPolynomial.C ((k.factorial : K)⁻¹) *
          rowAt W p a ^ d * deletedQuadratic W p ^ k) := by
  classical
  rw [centeredMoment_isotropic_roots (physicalCovariance W) _ (physicalRoot p a)
    k d (by simpa using hS) hκ (physicalRoot_isotropic W p a)
    (fun q => by rw [physicalCovariance_basis_root, physicalCovariance_root_basis])]
  rw [← coeff_selectedRestriction S ι]
  simp only [map_mul, map_pow, selectedRestriction_rowAt,
    selectedRestriction_deletedQuadratic S ι W p hp]
  rw [show selectedRestriction S ι (MvPolynomial.C ((k.factorial : K)⁻¹)) =
    MvPolynomial.C ((k.factorial : K)⁻¹) from MvPolynomial.killCompl_C _ _]

noncomputable def retainedSites (p : V N) : Finset (V N) :=
  ((vertices N).erase p).toFinset

theorem root_not_mem_retainedSites (p : V N) : p ∉ retainedSites p := by
  simpa only [retainedSites, List.mem_toFinset] using
    (vertices_nodup N).not_mem_erase (a := p)

theorem retainedSites_card (p : V N) : (retainedSites p).card = N - 1 := by
  rw [retainedSites, List.toFinset_card_of_nodup ((vertices_nodup N).erase p),
    List.length_erase_of_mem (mem_vertices p)]
  simp

theorem centeredMoment_eq_eval_oddResponsePolynomial (k r : ℕ) (hr : r ≤ k)
    (W : WeightsN (2 * (k + 1)) D K) (p : V (2 * (k + 1)))
    (a : Fin D → K) (ι : V (2 * (k + 1)) → Fin D) :
    centeredMoment (physicalCovariance W)
      (Sum.elim (fun q : ↥(retainedSites p) =>
        physicalBasis (selectedInput (retainedSites p) ι q))
        (fun _ : Fin (2 * r + 1) => physicalRoot p a)) =
      MvPolynomial.eval a (oddResponsePolynomial W p k r ι) := by
  rw [centeredMoment_selected_roots (retainedSites p) ι W p a (k - r) (2 * r + 1)
    (by rw [retainedSites_card]; omega) (Fintype.card_fin _) (root_not_mem_retainedSites p)]
  rw [eval_oddResponsePolynomial]
  simp only [oddResponse, hr, if_true, retainedCoefficient_project]
  rw [wordExponent_eq_finset_sum ι _ ((vertices_nodup _).erase p)]
  rfl

end PhysicalRootMoments

end Krenn.WickPhysicalBridge

-- formal/all-orders/EvenResponse.lean

namespace Krenn.EvenResponse

open MatchingModel SiteAlgebra

open scoped BigOperators

variable {K A σ : Type*} [Field K] [CharZero K] [CommRing A] [Algebra K A]

noncomputable def dividedPower (P : MvPolynomial σ A) (n : ℕ) : MvPolynomial σ A :=
  MvPolynomial.C (algebraMap K A ((n.factorial : K)⁻¹)) * P ^ n

omit [CharZero K] in
@[simp] theorem dividedPower_zero (P : MvPolynomial σ A) :
    dividedPower (K := K) P 0 = 1 := by simp [dividedPower]

theorem factorial_inverse_succ (n : ℕ) :
    (((n + 1).factorial : K)⁻¹) * (n + 1 : K) = (n.factorial : K)⁻¹ := by
  have hn : (n + 1 : K) ≠ 0 := Nat.cast_add_one_ne_zero n
  have hf : (n.factorial : K) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero n)
  rw [Nat.factorial_succ, Nat.cast_mul, Nat.cast_add, Nat.cast_one]
  field_simp

theorem pderiv_dividedPower_succ (P : MvPolynomial σ A) (z : σ) (n : ℕ) :
    MvPolynomial.pderiv z (dividedPower (K := K) P (n + 1)) =
      dividedPower (K := K) P n * MvPolynomial.pderiv z P := by
  have hscalar : algebraMap K A (((n + 1).factorial : K)⁻¹) * (n + 1 : A) =
      algebraMap K A ((n.factorial : K)⁻¹) := by
    simpa only [map_mul, map_add, map_natCast, map_one] using
      congrArg (algebraMap K A) (factorial_inverse_succ (K := K) n)
  simp only [dividedPower, MvPolynomial.pderiv_C_mul, Derivation.leibniz_pow,
    Nat.add_sub_cancel, smul_eq_mul]
  have hC : MvPolynomial.C (algebraMap K A (((n + 1).factorial : K)⁻¹)) *
      MvPolynomial.C (n + 1 : A) =
      (MvPolynomial.C (algebraMap K A ((n.factorial : K)⁻¹)) : MvPolynomial σ A) := by
    rw [← map_mul, hscalar]
  calc
    _ = (MvPolynomial.C (algebraMap K A (((n + 1).factorial : K)⁻¹)) *
      MvPolynomial.C (n + 1 : A)) * P ^ n * MvPolynomial.pderiv z P := by
        simp only [map_add, map_natCast, map_one]
        ring
    _ = _ := by rw [hC]

noncomputable def oddResponse (m : ℕ) (Q L : MvPolynomial σ A) : MvPolynomial σ A :=
  ∑ r ∈ Finset.range (m + 1),
    dividedPower (K := K) L (2 * r + 1) * dividedPower (K := K) Q (m - r)

noncomputable def evenResponse (m : ℕ) (Q L : MvPolynomial σ A) : MvPolynomial σ A :=
  ∑ r ∈ Finset.range (m + 1),
    dividedPower (K := K) L (2 * r) * dividedPower (K := K) Q (m - r)

noncomputable def lowerOddResponse (m : ℕ) (Q L : MvPolynomial σ A) : MvPolynomial σ A :=
  ∑ r ∈ Finset.range m,
    dividedPower (K := K) L (2 * r + 1) * dividedPower (K := K) Q (m - 1 - r)

omit [CharZero K] in
theorem lowerOddResponse_succ (m : ℕ) (Q L : MvPolynomial σ A) :
    lowerOddResponse (K := K) (m + 1) Q L = oddResponse (K := K) m Q L := by
  simp only [lowerOddResponse, oddResponse, Nat.add_sub_cancel]

theorem pderiv_oddResponse (m : ℕ) (Q L : MvPolynomial σ A) (z : σ) :
    MvPolynomial.pderiv z (oddResponse (K := K) m Q L) =
      MvPolynomial.pderiv z L * evenResponse (K := K) m Q L +
      MvPolynomial.pderiv z Q * lowerOddResponse (K := K) m Q L := by
  classical
  unfold oddResponse
  simp only [map_sum, MvPolynomial.pderiv_mul, pderiv_dividedPower_succ,
    Finset.sum_add_distrib]
  congr 1
  · simp only [evenResponse, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro r _
    ring
  · rw [Finset.sum_range_succ]
    simp only [Nat.sub_self, dividedPower_zero, MvPolynomial.pderiv_one, mul_zero, add_zero]
    simp only [lowerOddResponse, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro r hr
    have hrm : r < m := Finset.mem_range.mp hr
    have hpow : m - r = (m - 1 - r) + 1 := by omega
    rw [hpow, pderiv_dividedPower_succ]
    ring

theorem pderiv_evenResponse_of_pderiv_quadratic_zero
    (m : ℕ) (Q L : MvPolynomial σ A) (z : σ)
    (hQ : MvPolynomial.pderiv z Q = 0) :
    MvPolynomial.pderiv z (evenResponse (K := K) m Q L) =
      MvPolynomial.pderiv z L * lowerOddResponse (K := K) m Q L := by
  classical
  have hDQ : ∀ n, MvPolynomial.pderiv z (dividedPower (K := K) Q n) = 0 := by
    intro n
    cases n with
    | zero => simp
    | succ n => rw [pderiv_dividedPower_succ, hQ, mul_zero]
  unfold evenResponse
  simp only [map_sum, MvPolynomial.pderiv_mul, hDQ, mul_zero, add_zero]
  rw [Finset.sum_range_succ']
  simp only [Nat.mul_zero, dividedPower_zero, MvPolynomial.pderiv_one, zero_mul, add_zero]
  simp only [lowerOddResponse, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro r _
  have heven : 2 * (r + 1) = (2 * r + 1) + 1 := by omega
  have hsub : m - (r + 1) = m - 1 - r := by omega
  rw [heven, pderiv_dividedPower_succ, hsub]
  ring

section Maps

variable {B τ : Type*} [CommRing B] [Algebra K B]
    (f : MvPolynomial σ A →+* MvPolynomial τ B)
    (hf : ∀ a : K, f (MvPolynomial.C (algebraMap K A a)) =
      MvPolynomial.C (algebraMap K B a))

include hf

omit [CharZero K] in
theorem map_dividedPower (P : MvPolynomial σ A) (n : ℕ) :
    f (dividedPower (K := K) P n) = dividedPower (K := K) (f P) n := by
  simp only [dividedPower, map_mul, map_pow, hf]

omit [CharZero K] in
theorem map_oddResponse (m : ℕ) (Q L : MvPolynomial σ A) :
    f (oddResponse (K := K) m Q L) = oddResponse (K := K) m (f Q) (f L) := by
  simp only [oddResponse, map_sum, map_mul, map_dividedPower f hf]

omit [CharZero K] in
theorem map_evenResponse (m : ℕ) (Q L : MvPolynomial σ A) :
    f (evenResponse (K := K) m Q L) = evenResponse (K := K) m (f Q) (f L) := by
  simp only [evenResponse, map_sum, map_mul, map_dividedPower f hf]

omit [CharZero K] in
theorem map_lowerOddResponse (m : ℕ) (Q L : MvPolynomial σ A) :
    f (lowerOddResponse (K := K) m Q L) =
      lowerOddResponse (K := K) m (f Q) (f L) := by
  simp only [lowerOddResponse, map_sum, map_mul, map_dividedPower f hf]

end Maps

theorem rootExtract_oddResponse {N D : ℕ} (m : ℕ)
    (Q L : MatchingPolynomial N D A) (q : V N) (h : Fin D) :
    RootResponse.rootExtract q h (oddResponse (K := K) m Q L) =
      RootResponse.rootExtract q h L *
        evenResponse (K := K) m (RootResponse.eraseSite q Q) (RootResponse.eraseSite q L) +
      RootResponse.rootExtract q h Q *
        lowerOddResponse (K := K) m (RootResponse.eraseSite q Q)
          (RootResponse.eraseSite q L) := by
  simp only [RootResponse.rootExtract, pderiv_oddResponse, map_add, map_mul,
    map_evenResponse (RootResponse.eraseSite q) (fun _ => RootResponse.eraseSite_C q _),
    map_lowerOddResponse (RootResponse.eraseSite q) (fun _ => RootResponse.eraseSite_C q _)]

section RootAlgebra

variable {R : Type*} [Field R] {N D : ℕ}

theorem pderiv_eraseSite_of_ne (P : MatchingPolynomial N D R)
    (p q : V N) (h : Fin D) (hpq : p ≠ q) :
    MvPolynomial.pderiv (q, h) (RootResponse.eraseSite p P) =
      RootResponse.eraseSite p (MvPolynomial.pderiv (q, h) P) := by
  classical
  induction P using MvPolynomial.induction_on with
  | C a => simp
  | add P Q hP hQ => simp only [map_add, hP, hQ]
  | mul_X P z hP =>
    by_cases hz : z.1 = p
    · have hzq : (q, h) ≠ z := by
        intro heq
        have := congrArg Prod.fst heq
        exact hpq (hz.symm.trans this.symm)
      simp [RootResponse.eraseSite_X, hz, MvPolynomial.pderiv_X, hzq]
    · simp only [map_mul, RootResponse.eraseSite_X, if_neg hz,
        MvPolynomial.pderiv_mul, map_add, hP]
      by_cases heq : (q, h) = z
      · simp [MvPolynomial.pderiv_X, heq]
      · simp [MvPolynomial.pderiv_X, heq]

theorem pderiv_rowPolynomial
    (S : SiteVariable N D → SiteVariable N D → R) (z t : SiteVariable N D) :
    MvPolynomial.pderiv t (rowPolynomial S z) = MvPolynomial.C (S z t) := by
  classical
  simp [rowPolynomial, MvPolynomial.pderiv_X, Pi.single_apply]

theorem rootExtract_rowPolynomial
    (S : SiteVariable N D → SiteVariable N D → R) (z : SiteVariable N D)
    (q : V N) (h : Fin D) :
    RootResponse.rootExtract q h (rowPolynomial S z) = MvPolynomial.C (S z (q, h)) := by
  rw [RootResponse.rootExtract, pderiv_rowPolynomial, RootResponse.eraseSite_C]

end RootAlgebra

theorem rootExtract_deletedQuadratic {N D : ℕ} (W : WeightsN N D K)
    (p q : V N) (h : Fin D) (hpq : p ≠ q) :
    RootResponse.rootExtract q h (RootResponse.deletedQuadratic W p) =
      RootResponse.eraseSite q
        (RootResponse.eraseSite p (rowPolynomial (edgeMatrix W) (q, h))) := by
  rw [RootResponse.rootExtract, RootResponse.deletedQuadratic,
    pderiv_eraseSite_of_ne _ p q h hpq, pderiv_sourceQuadratic]

end Krenn.EvenResponse

-- formal/all-orders/WickEvenResponse.lean

namespace Krenn.WickEvenResponse

open scoped BigOperators Classical
open WickCovariance WickCoefficientBridge WickRootBridge WickShiftedBridge

variable {K E ι : Type*} [Field K] [CharZero K]
  [AddCommGroup E] [Module K E] [Fintype ι]

theorem sum_range_pairs {A : Type*} [AddCommMonoid A] (f : ℕ → A) (m : ℕ) :
    (∑ d ∈ Finset.range (2 * m), f d) =
      ∑ r ∈ Finset.range m, (f (2 * r) + f (2 * r + 1)) := by
  induction m with
  | zero => simp
  | succ m ih =>
    rw [show 2 * (m + 1) = (2 * m + 1) + 1 by omega,
      Finset.sum_range_succ, Finset.sum_range_succ, ih, Finset.sum_range_succ]
    exact add_assoc _ _ _

omit [CharZero K] in

theorem meanSlice_odd_eq_zero (B : E →ₗ[K] E →ₗ[K] K)
    (μ : E →ₗ[K] K) (v : ι → E) (m r : ℕ)
    (hcard : Fintype.card ι = 2 * m) (hr : r < m) :
    meanSlice B μ (2 * r + 1) v = 0 := by
  apply meanSlice_eq_zero_of_odd
  rw [hcard]
  rintro ⟨k, hk⟩
  omega

omit [CharZero K] in

theorem meanSlice_even_eq_zero (B : E →ₗ[K] E →ₗ[K] K)
    (μ : E →ₗ[K] K) (v : ι → E) (m r : ℕ)
    (hcard : Fintype.card ι = 2 * m + 1) (hr : r ≤ m) :
    meanSlice B μ (2 * r) v = 0 := by
  apply meanSlice_eq_zero_of_odd
  rw [hcard]
  rintro ⟨k, hk⟩
  omega

theorem shiftedMoment_eq_evenResponse (B : E →ₗ[K] E →ₗ[K] K)
    (μ : E →ₗ[K] K) (v : ι → E) (m : ℕ)
    (hcard : Fintype.card ι = 2 * m) :
    shiftedMoment B μ v =
      MvPolynomial.coeff (topExponent ι)
        (EvenResponse.evenResponse (K := K) m
          (symmetricQuadratic (fun i j => B (v i) (v j)))
          (linearPolynomial (fun i => μ (v i)))) := by
  rw [shiftedMoment_eq_sum_meanSlice, hcard, Finset.sum_range_succ, sum_range_pairs]
  have hsum : (∑ r ∈ Finset.range m,
      (meanSlice B μ (2 * r) v + meanSlice B μ (2 * r + 1) v)) =
      ∑ r ∈ Finset.range m, meanSlice B μ (2 * r) v := by
    apply Finset.sum_congr rfl
    intro r hr
    rw [meanSlice_odd_eq_zero B μ v m r hcard (Finset.mem_range.mp hr), add_zero]
  rw [hsum, ← Finset.sum_range_succ]
  simp only [EvenResponse.evenResponse, MvPolynomial.coeff_sum]
  apply Finset.sum_congr rfl
  intro r hr
  have hrm : r ≤ m := by simpa using Finset.mem_range.mp hr
  rw [meanSlice_eq_coeff B μ v (2 * r) (m - r) (by omega)]
  simp only [EvenResponse.dividedPower, dividedQuadratic, Algebra.algebraMap_self,
    RingHom.id_apply]

theorem shiftedMoment_eq_oddResponse (B : E →ₗ[K] E →ₗ[K] K)
    (μ : E →ₗ[K] K) (v : ι → E) (m : ℕ)
    (hcard : Fintype.card ι = 2 * m + 1) :
    shiftedMoment B μ v =
      MvPolynomial.coeff (topExponent ι)
        (EvenResponse.oddResponse (K := K) m
          (symmetricQuadratic (fun i j => B (v i) (v j)))
          (linearPolynomial (fun i => μ (v i)))) := by
  rw [shiftedMoment_eq_sum_meanSlice, hcard,
    show 2 * m + 1 + 1 = 2 * (m + 1) by omega, sum_range_pairs]
  simp only [EvenResponse.oddResponse, MvPolynomial.coeff_sum]
  apply Finset.sum_congr rfl
  intro r hr
  have hrm : r ≤ m := by simpa using Finset.mem_range.mp hr
  rw [meanSlice_even_eq_zero B μ v m r hcard hrm, zero_add,
    meanSlice_eq_coeff B μ v (2 * r + 1) (m - r) (by omega)]
  simp only [EvenResponse.dividedPower, dividedQuadratic, Algebra.algebraMap_self,
    RingHom.id_apply]

end Krenn.WickEvenResponse

-- formal/all-orders/PhysicalReflection.lean

namespace Krenn.PhysicalReflection

open scoped BigOperators Classical
open MatchingModel SiteAlgebra RootResponse OddResponseVanishing
open WickCovariance WickCoefficientBridge WickPhysicalBridge ReflectionTensorBridge

section Reindex

variable {K E ι κ : Type*} [Field K] [CharZero K]
  [AddCommGroup E] [Module K E] [Fintype ι] [Fintype κ]

noncomputable def reindexWord (e : ι ≃ κ) : (ι → Bool) ≃ (κ → Bool) :=
  Equiv.arrowCongr e (Equiv.refl Bool)

omit [CharZero K] in
theorem sign_reindexWord (e : ι ≃ κ) (w : ι → Bool) :
    BinaryPairing.sign (R := K) (reindexWord e w) = BinaryPairing.sign w := by
  exact Equiv.prod_comp e.symm (fun i => if w i then (-1 : K) else 1)

omit [CharZero K] in
theorem pairing_reindex (e : ι ≃ κ) (P Q : BinaryPairing.Tensor κ K) :
    BinaryPairing.pairing (fun w => P (reindexWord e w))
      (fun w => Q (reindexWord e w)) = BinaryPairing.pairing P Q := by
  classical
  rw [BinaryPairing.pairing, BinaryPairing.pairing]
  apply Fintype.sum_equiv (reindexWord e)
  intro w
  rw [sign_reindexWord]
  rfl

noncomputable def indexedMomentTensor {η : Type*} [Fintype η]
    (B : E →ₗ[K] E →ₗ[K] K) (u v : ι → E) (z : η → E) :
    BinaryPairing.Tensor ι K :=
  fun w => centeredMoment B (Sum.elim (fun i => if w i then v i else u i) z)

omit [CharZero K] in
theorem indexedMomentTensor_reindex {η : Type*} [Fintype η]
    (B : E →ₗ[K] E →ₗ[K] K) (e : ι ≃ κ) (u v : κ → E)
    (z : η → E) (w : ι → Bool) :
    indexedMomentTensor B (u ∘ e) (v ∘ e) z w =
      indexedMomentTensor B u v z (reindexWord e w) := by
  classical
  rw [indexedMomentTensor, indexedMomentTensor]
  convert! centeredMoment_relabel B
    (Equiv.sumCongr e (Equiv.refl η))
    (Sum.elim (fun i => if reindexWord e w i then v i else u i) z) using 1
  congr 1
  funext i
  cases i <;> simp [reindexWord, Function.comp_def]

theorem pairing_indexedMoment_roots_eq_zero (B : E →ₗ[K] E →ₗ[K] K)
    (u v : ι → E) (g : E) (p : ℕ) (hι : Odd (Fintype.card ι)) :
    BinaryPairing.pairing
      (indexedMomentTensor B u v (fun _ : Fin p => g))
      (indexedMomentTensor B u v (fun _ : Fin 1 => g)) = 0 := by
  classical
  let e := Fintype.equivFin ι
  let u' := u ∘ e.symm
  let v' := v ∘ e.symm
  have hreindex {η : Type} [Fintype η] (z : η → E) :
      indexedMomentTensor B u v z =
        fun w => momentTensor B (Fintype.card ι) u' v' z (reindexWord e w) := by
    funext w
    convert! indexedMomentTensor_reindex B e u' v' z w using 1
    simp [u', v', Function.comp_def]
  rw [hreindex (fun _ : Fin p => g), hreindex (fun _ : Fin 1 => g), pairing_reindex e]
  have hunit : momentTensor B (Fintype.card ι) u' v' (fun _ : Fin 1 => g) =
      momentTensor B (Fintype.card ι) u' v' (fun _ : Unit => g) := by
    funext w
    let t : Fin 1 ≃ Unit := Fintype.equivOfCardEq (by simp)
    unfold momentTensor
    convert! centeredMoment_relabel B (Equiv.sumCongr (Equiv.refl _) t)
      (Sum.elim (fun i => if w i then v' i else u' i) (fun _ : Unit => g)) using 1
    congr 1
    funext i
    cases i <;> rfl
  rw [hunit]
  exact pairing_momentTensor_roots_eq_zero B _ p hι u' v' g

end Reindex

section PhysicalTensors

variable {K : Type*} {N D : ℕ} [Field K] [CharZero K]

noncomputable def receivingWord (S : Finset (V N))
    (ι ρ : V N → Fin D) (w : ↥S → Bool) : V N → Fin D :=
  fun q => if hq : q ∈ S then if w ⟨q, hq⟩ then ρ q else ι q else ι q

theorem receivingWord_at (S : Finset (V N)) (ι ρ : V N → Fin D)
    (w : ↥S → Bool) (q : ↥S) :
    receivingWord S ι ρ w q = if w q then ρ q else ι q := by
  simp [receivingWord, q.2]

noncomputable def originalResponseTensor (k : ℕ)
    (W : WeightsN (2 * (k + 1)) D K) (p : V (2 * (k + 1))) (r : ℕ)
    (ι ρ : V (2 * (k + 1)) → Fin D) (a : Fin D → K) :
    BinaryPairing.Tensor (↥(retainedSites p)) K :=
  fun w => MvPolynomial.eval a
    (oddResponsePolynomial W p k r (receivingWord (retainedSites p) ι ρ w))

theorem originalResponseTensor_eq_moments (k r : ℕ) (hr : r ≤ k)
    (W : WeightsN (2 * (k + 1)) D K) (p : V (2 * (k + 1)))
    (ι ρ : V (2 * (k + 1)) → Fin D) (a : Fin D → K) :
    originalResponseTensor k W p r ι ρ a =
      indexedMomentTensor (physicalCovariance W)
        (fun q : ↥(retainedSites p) => physicalBasis (q.1, ι q.1))
        (fun q : ↥(retainedSites p) => physicalBasis (q.1, ρ q.1))
        (fun _ : Fin (2 * r + 1) => physicalRoot p a) := by
  classical
  funext w
  rw [originalResponseTensor, ← centeredMoment_eq_eval_oddResponsePolynomial k r hr]
  unfold indexedMomentTensor
  congr 1
  funext z
  cases z with
  | inl q =>
    simp only [Sum.elim_inl, selectedInput, receivingWord_at]
    cases w q <;> rfl
  | inr q => rfl

theorem originalResponseTensor_reflection (k r : ℕ) (hr : r ≤ k)
    (W : WeightsN (2 * (k + 1)) D K) (p : V (2 * (k + 1)))
    (ι ρ : V (2 * (k + 1)) → Fin D) (a : Fin D → K) :
    BinaryPairing.pairing (originalResponseTensor k W p r ι ρ a)
      (originalResponseTensor k W p 0 ι ρ a) = 0 := by
  rw [originalResponseTensor_eq_moments k r hr,
    originalResponseTensor_eq_moments k 0 (Nat.zero_le k)]
  exact pairing_indexedMoment_roots_eq_zero _ _ _ _ _
    (by simpa only [Fintype.card_coe, retainedSites_card] using
      (show Odd (2 * (k + 1) - 1) from ⟨k, by omega⟩))

omit [CharZero K] in
theorem wordExponent_eq_constant_iff (ι : V N → Fin D) (L : List (V N))
    (hL : L.Nodup) (h : Fin D) :
    wordExponent ι L = wordExponent (fun _ => h) L ↔ ∀ q ∈ L, ι q = h := by
  constructor
  · intro heq q hq
    by_contra hne
    have hone : wordExponent ι L (q, ι q) = 1 := by
      rw [wordExponent_selected, hL.count, if_pos hq]
    rw [heq, wordExponent_wrong_color (fun _ => h) L q (ι q) hne] at hone
    exact Nat.one_ne_zero hone.symm
  · intro hagree
    induction L with
    | nil => rfl
    | cons q L ih =>
      rw [wordExponent, wordExponent, hagree q (by simp)]
      congr 1
      exact ih hL.of_cons (fun t ht => hagree t (by simp [ht]))

omit [CharZero K] in
theorem retainedCoefficient_pureRootWord_word (p : V N) (ι : V N → Fin D)
    (h : Fin D) :
    retainedCoefficient (K := K) p ι (project (pureRootWord p h)) =
      if ∀ q ∈ (vertices N).erase p, ι q = h then 1 else 0 := by
  classical
  rw [pureRootWord, retainedCoefficient_project, MvPolynomial.coeff_monomial]
  have heq : wordExponent (fun _ => h) ((vertices N).erase p) =
      wordExponent ι ((vertices N).erase p) ↔
        ∀ q ∈ (vertices N).erase p, ι q = h :=
    eq_comm.trans (wordExponent_eq_constant_iff ι _ ((vertices_nodup N).erase p) h)
  simp only [heq]

theorem original_linear_response (k : ℕ) (W : WeightsN (2 * (k + 1)) D K)
    (hW : EqSystemN (2 * (k + 1)) D W) (p : V (2 * (k + 1)))
    (a : Fin D → K) (ι : V (2 * (k + 1)) → Fin D) :
    MvPolynomial.eval a (oddResponsePolynomial W p k 0 ι) =
      ∑ h, a h * if ∀ q ∈ (vertices (2 * (k + 1))).erase p, ι q = h then 1 else 0 := by
  rw [eval_oddResponsePolynomial, oddResponse_zero k W hW p a]
  change (retainedCoefficientHom p ι) _ = _
  rw [map_sum]
  change (∑ h, retainedCoefficient p ι (siteScalar (a h) * project (pureRootWord p h))) = _
  simp only [retainedCoefficient_scalar_mul, retainedCoefficient_pureRootWord_word]

omit [CharZero K] in
theorem wordExponent_congr_list (ι ρ : V N → Fin D) (L : List (V N))
    (h : ∀ q ∈ L, ι q = ρ q) : wordExponent ι L = wordExponent ρ L := by
  induction L with
  | nil => rfl
  | cons q L ih =>
    rw [wordExponent, wordExponent, h q (by simp)]
    congr 1
    exact ih (fun t ht => h t (by simp [ht]))

omit [CharZero K] in

theorem oddResponsePolynomial_congr_word (W : WeightsN N D K) (p : V N)
    (k r : ℕ) (ι ρ : V N → Fin D)
    (h : ∀ q ∈ (vertices N).erase p, ι q = ρ q) :
    oddResponsePolynomial W p k r ι = oddResponsePolynomial W p k r ρ := by
  apply MvPolynomial.ext
  intro m
  simp only [oddResponsePolynomial, coeff_coefficientPolynomial, retainedCoefficient]
  rw [wordExponent_congr_list ι ρ _ h]

theorem original_linear_response_of_constant (k : ℕ)
    (W : WeightsN (2 * (k + 1)) D K) (hW : EqSystemN (2 * (k + 1)) D W)
    (p : V (2 * (k + 1))) (a : Fin D → K) (ι : V (2 * (k + 1)) → Fin D)
    (i : Fin D) (hι : ∀ q ∈ (vertices (2 * (k + 1))).erase p, ι q = i) :
    MvPolynomial.eval a (oddResponsePolynomial W p k 0 ι) = a i := by
  rw [oddResponsePolynomial_congr_word W p k 0 ι (fun _ => i) hι,
    oddResponsePolynomial_zero_pure k W hW p i, MvPolynomial.eval_X]

theorem retainedSites_nonempty (k : ℕ) (p : V (2 * (k + 1))) :
    Nonempty (↥(retainedSites p)) := by
  apply Fintype.card_pos_iff.mp
  rw [Fintype.card_coe, retainedSites_card]
  omega

theorem originalResponseTensor_linear_pair (k : ℕ)
    (W : WeightsN (2 * (k + 1)) D K) (hW : EqSystemN (2 * (k + 1)) D W)
    (p : V (2 * (k + 1))) (a : Fin D → K) (i j : Fin D) (hij : i ≠ j) :
    originalResponseTensor k W p 0 (fun _ => i) (fun _ => j) a =
      a i • BinaryPairing.pure false + a j • BinaryPairing.pure true := by
  classical
  have : Nonempty (↥(retainedSites p)) := retainedSites_nonempty k p
  funext w
  by_cases hwf : w = fun _ => false
  · subst w
    rw [originalResponseTensor, original_linear_response_of_constant k W hW p a _ i]
    · simp [BinaryPairing.pure, funext_iff]
    · intro q hq
      have hqS : q ∈ retainedSites p := List.mem_toFinset.mpr hq
      simp [receivingWord, hqS]
  · by_cases hwt : w = fun _ => true
    · subst w
      rw [originalResponseTensor, original_linear_response_of_constant k W hW p a _ j]
      · simp [BinaryPairing.pure, funext_iff]
      · intro q hq
        have hqS : q ∈ retainedSites p := List.mem_toFinset.mpr hq
        simp [receivingWord, hqS]
    · have htrue : ∃ q, w q = true := by
        by_contra h
        apply hwf
        funext q
        have hq : w q ≠ true := fun ht => h ⟨q, ht⟩
        cases hw : w q <;> simp_all
      have hfalse : ∃ q, w q = false := by
        by_contra h
        apply hwt
        funext q
        have hq : w q ≠ false := fun ht => h ⟨q, ht⟩
        cases hw : w q <;> simp_all
      obtain ⟨q, hq⟩ := htrue
      obtain ⟨t, ht⟩ := hfalse
      rw [originalResponseTensor, original_linear_response k W hW p a]
      have hzero : ∀ h : Fin D, ¬∀ z ∈ (vertices (2 * (k + 1))).erase p,
          receivingWord (retainedSites p) (fun _ => i) (fun _ => j) w z = h := by
        intro h hc
        have hq' := hc q.1 (List.mem_toFinset.mp q.2)
        have ht' := hc t.1 (List.mem_toFinset.mp t.2)
        have hj : j = h := by simpa [receivingWord, q.2, hq] using hq'
        have hi : i = h := by simpa [receivingWord, t.2, ht] using ht'
        exact hij (hi.trans hj.symm)
      simp only [hzero, if_false, mul_zero, Finset.sum_const_zero,
        Pi.add_apply, Pi.smul_apply, smul_eq_mul, BinaryPairing.pure,
        if_neg hwf, if_neg hwt, mul_zero, add_zero]

omit [CharZero K] in
theorem originalResponseTensor_false (k r : ℕ)
    (W : WeightsN (2 * (k + 1)) D K) (p : V (2 * (k + 1)))
    (ι ρ : V (2 * (k + 1)) → Fin D) (a : Fin D → K) :
    originalResponseTensor k W p r ι ρ a (fun _ => false) =
      MvPolynomial.eval a (oddResponsePolynomial W p k r ι) := by
  rw [originalResponseTensor]
  congr 1
  apply oddResponsePolynomial_congr_word
  intro q hq
  have hqS : q ∈ retainedSites p := List.mem_toFinset.mpr hq
  simp [receivingWord, hqS]

omit [CharZero K] in
theorem originalResponseTensor_true (k r : ℕ)
    (W : WeightsN (2 * (k + 1)) D K) (p : V (2 * (k + 1)))
    (ι ρ : V (2 * (k + 1)) → Fin D) (a : Fin D → K) :
    originalResponseTensor k W p r ι ρ a (fun _ => true) =
      MvPolynomial.eval a (oddResponsePolynomial W p k r ρ) := by
  rw [originalResponseTensor]
  congr 1
  apply oddResponsePolynomial_congr_word
  intro q hq
  have hqS : q ∈ retainedSites p := List.mem_toFinset.mpr hq
  simp [receivingWord, hqS]

theorem pure_response_cross (k r : ℕ) (hr : r ≤ k)
    (W : WeightsN (2 * (k + 1)) D K) (hW : EqSystemN (2 * (k + 1)) D W)
    (p : V (2 * (k + 1))) (i j : Fin D) :
    MvPolynomial.X i * oddResponsePolynomial W p k r (fun _ => j) =
      MvPolynomial.X j * oddResponsePolynomial W p k r (fun _ => i) := by
  by_cases hij : i = j
  · subst j
    rfl
  apply MvPolynomial.funext
  intro a
  have href := originalResponseTensor_reflection k r hr W p (fun _ => i) (fun _ => j) a
  rw [originalResponseTensor_linear_pair k W hW p a i j hij,
    BinaryPairing.pairing_add_right, BinaryPairing.pairing_smul_right,
    BinaryPairing.pairing_smul_right, BinaryPairing.pairing_right_pure_false,
    BinaryPairing.pairing_right_pure_true, originalResponseTensor_true,
    originalResponseTensor_false] at href
  have ho : Odd (Fintype.card (↥(retainedSites p))) := by
    rw [Fintype.card_coe, retainedSites_card]
    exact ⟨k, by omega⟩
  rw [ho.neg_one_pow] at href
  simp only [map_mul, MvPolynomial.eval_X]
  linear_combination -href

theorem originalResponseTensor_linear_mixed (k : ℕ)
    (W : WeightsN (2 * (k + 1)) D K) (hW : EqSystemN (2 * (k + 1)) D W)
    (p : V (2 * (k + 1))) (a : Fin D → K) (ι : V (2 * (k + 1)) → Fin D)
    (h : Fin D)
    (hnon : ¬∃ c, ∀ q ∈ (vertices (2 * (k + 1))).erase p, ι q = c)
    (havoid : ∀ q ∈ (vertices (2 * (k + 1))).erase p, ι q ≠ h) :
    originalResponseTensor k W p 0 ι (fun _ => h) a =
      a h • BinaryPairing.pure true := by
  classical
  funext w
  by_cases hwt : w = fun _ => true
  · subst w
    rw [originalResponseTensor_true, oddResponsePolynomial_zero_pure k W hW p h,
      MvPolynomial.eval_X]
    simp [BinaryPairing.pure]
  · have hfalse : ∃ q, w q = false := by
      by_contra hn
      apply hwt
      funext q
      have hq : w q ≠ false := fun ht => hn ⟨q, ht⟩
      cases hw : w q <;> simp_all
    obtain ⟨t, ht⟩ := hfalse
    rw [originalResponseTensor, original_linear_response k W hW p a]
    have hzero : ∀ c, ¬∀ q ∈ (vertices (2 * (k + 1))).erase p,
        receivingWord (retainedSites p) ι (fun _ => h) w q = c := by
      intro c hc
      have ht' : ι t.1 = c := by
        simpa [receivingWord, t.2, ht] using hc t.1 (List.mem_toFinset.mp t.2)
      have hch : c ≠ h := by
        rw [← ht']
        exact havoid t.1 (List.mem_toFinset.mp t.2)
      have hwf : ∀ q : ↥(retainedSites p), w q = false := by
        intro q
        by_cases hq : w q = true
        · have hh : h = c := by
            simpa [receivingWord, q.2, hq] using hc q.1 (List.mem_toFinset.mp q.2)
          exact False.elim (hch hh.symm)
        · cases heq : w q <;> simp_all
      apply hnon
      refine ⟨c, ?_⟩
      intro q hq
      have hqS : q ∈ retainedSites p := List.mem_toFinset.mpr hq
      simpa [receivingWord, hqS, hwf ⟨q, hqS⟩] using hc q hq
    simp only [hzero, if_false, mul_zero, Finset.sum_const_zero,
      Pi.smul_apply, smul_eq_mul, BinaryPairing.pure, if_neg hwt, mul_zero]

theorem mixed_response_cross (k r : ℕ) (hr : r ≤ k)
    (W : WeightsN (2 * (k + 1)) D K) (hW : EqSystemN (2 * (k + 1)) D W)
    (p : V (2 * (k + 1))) (ι : V (2 * (k + 1)) → Fin D) (h : Fin D)
    (hnon : ¬∃ c, ∀ q ∈ (vertices (2 * (k + 1))).erase p, ι q = c)
    (havoid : ∀ q ∈ (vertices (2 * (k + 1))).erase p, ι q ≠ h) :
    MvPolynomial.X h * oddResponsePolynomial W p k r ι = 0 := by
  apply MvPolynomial.funext
  intro a
  have href := originalResponseTensor_reflection k r hr W p ι (fun _ => h) a
  rw [originalResponseTensor_linear_mixed k W hW p a ι h hnon havoid,
    BinaryPairing.pairing_smul_right, BinaryPairing.pairing_right_pure_true,
    originalResponseTensor_false] at href
  simpa only [map_mul, MvPolynomial.eval_X, map_zero] using href

end PhysicalTensors

end Krenn.PhysicalReflection

-- formal/all-orders/WholeBinaryResponse.lean

namespace Krenn.WholeBinaryResponse

open scoped BigOperators Classical
open MatchingModel SiteAlgebra RootResponse OddResponseVanishing
open WickCovariance WickCoefficientBridge WickRootBridge WickPhysicalBridge WickShiftedBridge
open MvPolynomial

variable {K : Type*} [Field K] [CharZero K] {N D : ℕ}

noncomputable def rootVector (p : V N) : (Fin D → K) →ₗ[K] PhysicalSpace N D K where
  toFun := physicalRoot p
  map_add' a b := by
    simp only [physicalRoot, Pi.add_apply, add_smul, Finset.sum_add_distrib]
  map_smul' c a := by
    simp only [physicalRoot, Pi.smul_apply, smul_eq_mul, RingHom.id_apply,
      Finset.smul_sum, smul_smul]

noncomputable def rootMean (W : WeightsN N D K) (p : V N) :
    (Fin D → K) →ₗ[K] (PhysicalSpace N D K →ₗ[K] K) :=
  (physicalCovariance W).comp (rootVector p)

omit [CharZero K] in
@[simp] theorem rootMean_apply (W : WeightsN N D K) (p : V N) (a : Fin D → K) :
    rootMean W p a = physicalCovariance W (physicalRoot p a) := rfl

omit [CharZero K] in

theorem wordExponent_congr_list (L : List (V N)) (ι ν : V N → Fin D)
    (h : ∀ v ∈ L, ι v = ν v) : wordExponent ι L = wordExponent ν L := by
  induction L with
  | nil => rfl
  | cons v L ih =>
    simp only [wordExponent, h v (List.mem_cons_self ..)]
    rw [ih (fun w hw => h w (List.mem_cons_of_mem _ hw))]

theorem oddResponsePolynomial_congr (W : WeightsN N D K) (p : V N)
    (m r : ℕ) (ι ν : V N → Fin D)
    (h : ∀ v ∈ retainedSites p, ι v = ν v) :
    oddResponsePolynomial W p m r ι = oddResponsePolynomial W p m r ν := by
  apply MvPolynomial.funext
  intro a
  simp only [eval_oddResponsePolynomial, retainedCoefficient]
  congr 1
  exact wordExponent_congr_list _ _ _ (fun v hv => h v (List.mem_toFinset.mpr hv))

theorem meanSlice_eq_isotropic_root_moment {E ι : Type*}
    [AddCommGroup E] [Module K E] [Fintype ι]
    (B : E →ₗ[K] E →ₗ[K] K) (v : ι → E) (g : E) (k d : ℕ)
    (hcard : Fintype.card ι = 2 * k + d)
    (hgg : B g g = 0) (hcross : ∀ i, B (v i) g = B g (v i)) :
    meanSlice B (B g) d v = ((d.factorial : K)⁻¹) *
      centeredMoment B (Sum.elim v (fun _ : Fin d => g)) := by
  classical
  rw [meanSlice_eq_coeff B (B g) v d k (by omega),
    centeredMoment_isotropic_roots B v g k d hcard (Fintype.card_fin _) hgg hcross]
  rw [← MvPolynomial.coeff_C_mul]
  unfold dividedQuadratic
  congr 1
  ring

theorem shiftedMoment_eq_oddResponse_sum (m : ℕ)
    (W : WeightsN (2 * (m + 1)) D K) (p : V (2 * (m + 1)))
    (a : Fin D → K) (ι : V (2 * (m + 1)) → Fin D) :
    shiftedMoment (physicalCovariance W) (rootMean W p a)
      (fun q : ↥(retainedSites p) => physicalBasis (selectedInput (retainedSites p) ι q)) =
      ∑ r ∈ Finset.range (m + 1), (((2 * r + 1).factorial : K)⁻¹) *
        eval a (oddResponsePolynomial W p m r ι) := by
  classical
  have hcard : Fintype.card ↥(retainedSites p) = 2 * m + 1 := by
    simp only [Fintype.card_coe, retainedSites_card]
    omega
  rw [shiftedMoment_eq_sum_meanSlice, hcard,
    show 2 * m + 1 + 1 = 2 * (m + 1) by omega, WickEvenResponse.sum_range_pairs]
  apply Finset.sum_congr rfl
  intro r hr
  have hrm : r ≤ m := by simpa using Finset.mem_range.mp hr
  rw [WickEvenResponse.meanSlice_even_eq_zero _ _ _ m r hcard hrm, zero_add,
    rootMean_apply]
  rw [meanSlice_eq_isotropic_root_moment _ _ _ (m - r) (2 * r + 1)
    (by omega) (physicalRoot_isotropic W p a)
    (fun i => by rw [physicalCovariance_basis_root, physicalCovariance_root_basis])]
  rw [centeredMoment_eq_eval_oddResponsePolynomial m r hrm]

noncomputable def binaryWord (p : V N) (i j : Fin D)
    (w : ↥(retainedSites p) → Bool) : V N → Fin D :=
  fun v => if hv : v ∈ retainedSites p then if w ⟨v, hv⟩ then j else i else i

@[simp] theorem binaryWord_retained (p : V N) (i j : Fin D)
    (w : ↥(retainedSites p) → Bool) (v : ↥(retainedSites p)) :
    binaryWord p i j w v = if w v then j else i := by
  simp [binaryWord, v.property]

theorem responseTensor_eq_oddResponse_sum (m : ℕ)
    (W : WeightsN (2 * (m + 1)) D K) (p : V (2 * (m + 1)))
    (a : Fin D → K) (i j : Fin D) (w : ↥(retainedSites p) → Bool) :
    WickFinitePairing.responseTensor (physicalCovariance W) (rootMean W p a)
      (fun v : ↥(retainedSites p) => physicalBasis (v.1, i))
      (fun v : ↥(retainedSites p) => physicalBasis (v.1, j)) w =
      ∑ r ∈ Finset.range (m + 1), (((2 * r + 1).factorial : K)⁻¹) *
        eval a (oddResponsePolynomial W p m r (binaryWord p i j w)) := by
  rw [← shiftedMoment_eq_oddResponse_sum m W p a (binaryWord p i j w)]
  unfold WickFinitePairing.responseTensor
  congr 1
  funext v
  simp only [selectedInput, binaryWord_retained]
  cases w v <;> rfl

theorem oddResponsePolynomial_binary_const (W : WeightsN N D K) (p : V N)
    (m r : ℕ) (i j : Fin D) (b : Bool) :
    oddResponsePolynomial W p m r (binaryWord p i j (fun _ => b)) =
      oddResponsePolynomial W p m r (fun _ => if b then j else i) := by
  apply oddResponsePolynomial_congr
  intro v hv
  simp only [binaryWord, dif_pos hv]

theorem actual_binary_factorization (m : ℕ)
    (W : WeightsN (2 * (m + 1)) D K) (p : V (2 * (m + 1)))
    (q : ℕ → MvPolynomial (Fin D) K) (i j : Fin D)
    (hpure : ∀ r ≤ m, ∀ h : Fin D,
      oddResponsePolynomial W p m r (fun _ => h) = X h * q r)
    (hmixed : ∀ r ≤ m, ∀ w : ↥(retainedSites p) → Bool,
      w ≠ (fun _ => false) → w ≠ (fun _ => true) →
      oddResponsePolynomial W p m r (binaryWord p i j w) = 0)
    (a : Fin D → K) :
    WickFinitePairing.responseTensor (physicalCovariance W) (rootMean W p a)
      (fun v : ↥(retainedSites p) => physicalBasis (v.1, i))
      (fun v : ↥(retainedSites p) => physicalBasis (v.1, j)) =
      eval a (finiteScalarFactor m q) •
        (a i • BinaryPairing.pure false + a j • BinaryPairing.pure true) := by
  classical
  let : Nonempty ↥(retainedSites p) := Fintype.card_pos_iff.mp (by
    simp only [Fintype.card_coe, retainedSites_card]
    omega)
  funext w
  rw [responseTensor_eq_oddResponse_sum]
  by_cases hw0 : w = (fun _ => false)
  · subst w
    simp only [oddResponsePolynomial_binary_const, Bool.false_eq_true, ↓reduceIte]
    have hsum : (∑ r ∈ Finset.range (m + 1), (((2 * r + 1).factorial : K)⁻¹) *
        eval a (oddResponsePolynomial W p m r (fun _ => i))) =
        eval a (finiteScalarFactor m q) * a i := by
      simp only [finiteScalarFactor, map_sum, map_mul, eval_C, Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro r hr
      rw [hpure r (by simpa using Finset.mem_range.mp hr), map_mul, eval_X]
      ring
    rw [hsum]
    simp [BinaryPairing.pure, _root_.funext_iff]
  · by_cases hw1 : w = (fun _ => true)
    · subst w
      simp only [oddResponsePolynomial_binary_const, ↓reduceIte]
      have hsum : (∑ r ∈ Finset.range (m + 1), (((2 * r + 1).factorial : K)⁻¹) *
          eval a (oddResponsePolynomial W p m r (fun _ => j))) =
          eval a (finiteScalarFactor m q) * a j := by
        simp only [finiteScalarFactor, map_sum, map_mul, eval_C, Finset.sum_mul]
        apply Finset.sum_congr rfl
        intro r hr
        rw [hpure r (by simpa using Finset.mem_range.mp hr), map_mul, eval_X]
        ring
      rw [hsum]
      simp [BinaryPairing.pure, _root_.funext_iff]
    · have hz : (∑ r ∈ Finset.range (m + 1), (((2 * r + 1).factorial : K)⁻¹) *
          eval a (oddResponsePolynomial W p m r (binaryWord p i j w))) = 0 := by
        apply Finset.sum_eq_zero
        intro r hr
        rw [hmixed r (by simpa using Finset.mem_range.mp hr) w hw0 hw1, map_zero, mul_zero]
      rw [hz]
      simp [BinaryPairing.pure, hw0, hw1]

theorem exists_third_colour (i j : Fin 3) : ∃ h : Fin 3, h ≠ i ∧ h ≠ j := by
  fin_cases i <;> fin_cases j <;> decide

theorem binaryWord_nonconstant (p : V N) {i j : Fin D} (hij : i ≠ j)
    (w : ↥(retainedSites p) → Bool)
    (hw0 : w ≠ (fun _ => false)) (hw1 : w ≠ (fun _ => true)) :
    ¬∃ c, ∀ q ∈ (vertices N).erase p, binaryWord p i j w q = c := by
  classical
  have hf : ∃ v, w v = false := by
    by_contra h
    push Not at h
    apply hw1
    funext v
    cases hv : w v <;> simp_all
  have ht : ∃ v, w v = true := by
    by_contra h
    push Not at h
    apply hw0
    funext v
    cases hv : w v <;> simp_all
  obtain ⟨v, hv⟩ := hf
  obtain ⟨t, ht⟩ := ht
  rintro ⟨c, hc⟩
  have hv' := hc v (List.mem_toFinset.mp v.property)
  have ht' := hc t (List.mem_toFinset.mp t.property)
  rw [binaryWord_retained, hv] at hv'
  rw [binaryWord_retained, ht] at ht'
  simp only [Bool.false_eq_true, ↓reduceIte] at hv' ht'
  exact hij (hv'.trans ht'.symm)

theorem binary_mixed_response_zero (m r : ℕ) (hr : r ≤ m)
    (W : WeightsN (2 * (m + 1)) 3 K) (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p : V (2 * (m + 1))) {i j : Fin 3} (hij : i ≠ j)
    (w : ↥(retainedSites p) → Bool)
    (hw0 : w ≠ (fun _ => false)) (hw1 : w ≠ (fun _ => true)) :
    oddResponsePolynomial W p m r (binaryWord p i j w) = 0 := by
  obtain ⟨h, hhi, hhj⟩ := exists_third_colour i j
  apply mixed_response_zero_of_reflection _ _ _ _ _ h
  apply PhysicalReflection.mixed_response_cross m r hr W hW p _ h
  · exact binaryWord_nonconstant p hij w hw0 hw1
  · intro v hv
    have hv' : v ∈ retainedSites p := List.mem_toFinset.mpr hv
    simp only [binaryWord, dif_pos hv']
    split_ifs <;> exact Ne.symm ‹h ≠ _›

theorem exists_actual_pure_factors (m : ℕ)
    (W : WeightsN (2 * (m + 1)) 3 K) (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p : V (2 * (m + 1))) :
    ∃ q : ℕ → MvPolynomial (Fin 3) K,
      (∀ r ≤ m, ∀ i : Fin 3,
        oddResponsePolynomial W p m r (fun _ => i) = X i * q r) ∧
      (∀ r ≤ m, IsWeightedHomogeneous (fun _ : Fin 3 => (1 : ℕ)) (q r) (2 * r)) ∧
      q 0 = 1 := by
  classical
  have hex (r : ℕ) : ∃ q : MvPolynomial (Fin 3) K,
      (r ≤ m → ∀ i : Fin 3, oddResponsePolynomial W p m r (fun _ => i) = X i * q) ∧ True := by
    by_cases hr : r ≤ m
    · obtain ⟨q, hq⟩ := pure_response_common_factor W p m r
        (a := (0 : Fin 3)) (b := (1 : Fin 3)) (by decide)
        (PhysicalReflection.pure_response_cross m r hr W hW p)
      exact ⟨q, (fun _ => hq), trivial⟩
    · exact ⟨0, (fun h => False.elim (hr h)), trivial⟩
  choose q ho using hex
  have hq (r : ℕ) := (ho r).1
  refine ⟨q, hq, ?_, ?_⟩
  · intro r hr
    exact pure_response_factor_homogeneous W p m r (0 : Fin 3) (q r) (hq r hr 0)
  · exact pure_linear_factor_eq_one m W hW p (0 : Fin 3) (q 0) (hq 0 (by omega) 0)

theorem pure_response_zero_of_rotation (m r : ℕ) (hr : r ≤ m) (hpos : 0 < r)
    (W : WeightsN (2 * (m + 1)) 3 K) (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p : V (2 * (m + 1))) (i : Fin 3) (s : K) (hs : s * s + s * s = 1) :
    oddResponsePolynomial W p m r (fun _ => i) = 0 := by
  classical
  obtain ⟨q, hpure, hhom, hzero⟩ := exists_actual_pure_factors m W hW p
  let : Nonempty ↥(retainedSites p) := Fintype.card_pos_iff.mp (by
    simp only [Fintype.card_coe, retainedSites_card]
    omega)
  have hodd : Odd (Fintype.card ↥(retainedSites p)) := by
    simp only [Fintype.card_coe, retainedSites_card]
    exact ⟨m, by omega⟩
  have hfactor := actual_binary_factorization m W p q (0 : Fin 3) (1 : Fin 3) hpure
    (fun t ht w hw0 hw1 => binary_mixed_response_zero m t ht W hW p (by decide) w hw0 hw1)
  have hqzero := OddRotation.higher_factors_zero_of_actual_rotation
    (physicalCovariance W) (rootMean W p)
    (fun v : ↥(retainedSites p) => physicalBasis (v.1, (0 : Fin 3)))
    (fun v : ↥(retainedSites p) => physicalBasis (v.1, (1 : Fin 3)))
    m q hhom hzero (by decide) hodd hfactor s hs r hr hpos
  rw [hpure r hr i, hqzero, mul_zero]

theorem mixed_response_zero (m r : ℕ) (hr : r ≤ m)
    (W : WeightsN (2 * (m + 1)) 3 K) (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p : V (2 * (m + 1))) (ι : V (2 * (m + 1)) → Fin 3)
    (hnon : ¬∃ c, ∀ q ∈ (vertices (2 * (m + 1))).erase p, ι q = c)
    (havoid : ∃ h : Fin 3, ∀ q ∈ (vertices (2 * (m + 1))).erase p, ι q ≠ h) :
    oddResponsePolynomial W p m r ι = 0 := by
  obtain ⟨h, hh⟩ := havoid
  exact mixed_response_zero_of_reflection W p m r ι h
    (PhysicalReflection.mixed_response_cross m r hr W hW p ι h hnon hh)

theorem whole_binary_response_zero_of_rotation (m r : ℕ) (hr : r ≤ m) (hpos : 0 < r)
    (W : WeightsN (2 * (m + 1)) 3 K) (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p : V (2 * (m + 1))) (ι : V (2 * (m + 1)) → Fin 3)
    (hbinary : ∃ i j : Fin 3, ∀ v ∈ retainedSites p, ι v = i ∨ ι v = j)
    (s : K) (hs : s * s + s * s = 1) : oddResponsePolynomial W p m r ι = 0 := by
  classical
  by_cases hpure : ∃ c, ∀ q ∈ (vertices (2 * (m + 1))).erase p, ι q = c
  · obtain ⟨c, hc⟩ := hpure
    rw [oddResponsePolynomial_congr W p m r ι (fun _ => c)
      (fun v hv => hc v (List.mem_toFinset.mp hv))]
    exact pure_response_zero_of_rotation m r hr hpos W hW p c s hs
  · apply mixed_response_zero m r hr W hW p ι hpure
    obtain ⟨i, j, hij⟩ := hbinary
    obtain ⟨h, hhi, hhj⟩ := exists_third_colour i j
    refine ⟨h, ?_⟩
    intro v hv
    rcases hij v (List.mem_toFinset.mpr hv) with hvi | hvj
    · rw [hvi]; exact hhi.symm
    · rw [hvj]; exact hhj.symm

noncomputable def halfRotation : ℂ := (Real.sqrt 2 : ℂ) / 2

theorem halfRotation_normalized : halfRotation * halfRotation + halfRotation * halfRotation = 1 := by
  have hs : (Real.sqrt 2 : ℂ) * (Real.sqrt 2 : ℂ) = 2 := by
    norm_cast
    nlinarith [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)]
  unfold halfRotation
  field_simp
  linear_combination 2 * hs

theorem whole_binary_response_zero (m r : ℕ) (hr : r ≤ m) (hpos : 0 < r)
    (W : WeightsN (2 * (m + 1)) 3 ℂ) (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p : V (2 * (m + 1))) (ι : V (2 * (m + 1)) → Fin 3)
    (hbinary : ∃ i j : Fin 3, ∀ v ∈ retainedSites p, ι v = i ∨ ι v = j) :
    oddResponsePolynomial W p m r ι = 0 :=
  whole_binary_response_zero_of_rotation m r hr hpos W hW p ι hbinary
    halfRotation halfRotation_normalized

theorem pure_response_zero (m r : ℕ) (hr : r ≤ m) (hpos : 0 < r)
    (W : WeightsN (2 * (m + 1)) 3 ℂ) (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p : V (2 * (m + 1))) (i : Fin 3) :
    oddResponsePolynomial W p m r (fun _ => i) = 0 :=
  whole_binary_response_zero m r hr hpos W hW p (fun _ => i)
    ⟨i, i, fun _ _ => Or.inl rfl⟩

theorem whole_binary_coefficient_zero (m r : ℕ) (hr : r ≤ m) (hpos : 0 < r)
    (W : WeightsN (2 * (m + 1)) 3 ℂ) (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p : V (2 * (m + 1))) (ι : V (2 * (m + 1)) → Fin 3)
    (hbinary : ∃ i j : Fin 3, ∀ v ∈ retainedSites p, ι v = i ∨ ι v = j)
    (a : Fin 3 → ℂ) :
    coeff (wordExponent ι ((vertices (2 * (m + 1))).erase p))
      (C (((m - r).factorial : ℂ)⁻¹) * rowAt W p a ^ (2 * r + 1) *
        deletedQuadratic W p ^ (m - r)) = 0 := by
  have h := congrArg (eval a) (whole_binary_response_zero m r hr hpos W hW p ι hbinary)
  simpa only [eval_oddResponsePolynomial, oddResponse, hr, if_true,
    retainedCoefficient_project, map_zero] using h

end Krenn.WholeBinaryResponse

-- formal/all-orders/ReplicaCovariance.lean

namespace Krenn.ReplicaCovariance

open scoped Matrix

section Domain

variable {R : Type*} [CommRing R] [IsDomain R]

def cross₂ (v w : Fin 2 → R) : R := v 0 * w 1 - v 1 * w 0

def dot₂ (v w : Fin 2 → R) : R := v 0 * w 0 + v 1 * w 1

theorem normal_form_entries
    {p₀ p₁ q₀ q₁ m₀₀ m₀₁ m₁₀ m₁₁ b b' : R}
    (hp : p₀ * p₁ ≠ 0) (hq : q₀ * q₁ ≠ 0)
    (hc : p₀ * q₀ + p₁ * q₁ ≠ 0)
    (h₀₁ : m₀₁ = p₀ * q₁ * b) (h₁₀ : m₁₀ = p₁ * q₀ * b')
    (hP : p₀ ^ 2 * m₁₀ + p₀ * p₁ * (m₁₁ - m₀₀) - p₁ ^ 2 * m₀₁ = 0)
    (hQ : q₀ ^ 2 * m₀₁ + q₀ * q₁ * (m₁₁ - m₀₀) - q₁ ^ 2 * m₁₀ = 0) :
    b = b' ∧ ∃ a : R,
      m₀₀ = a + b * p₀ * q₀ ∧ m₀₁ = b * p₀ * q₁ ∧
      m₁₀ = b * p₁ * q₀ ∧ m₁₁ = a + b * p₁ * q₁ := by
  have hP' : p₀ * p₁ *
      ((m₁₁ - m₀₀) - (p₁ * q₁ * b - p₀ * q₀ * b')) = 0 := by
    calc
      _ = p₀ ^ 2 * m₁₀ + p₀ * p₁ * (m₁₁ - m₀₀) - p₁ ^ 2 * m₀₁ := by
        rw [h₀₁, h₁₀]
        ring
      _ = 0 := hP
  have hQ' : q₀ * q₁ *
      ((m₁₁ - m₀₀) - (p₁ * q₁ * b' - p₀ * q₀ * b)) = 0 := by
    calc
      _ = q₀ ^ 2 * m₀₁ + q₀ * q₁ * (m₁₁ - m₀₀) - q₁ ^ 2 * m₁₀ := by
        rw [h₀₁, h₁₀]
        ring
      _ = 0 := hQ
  have hdP : m₁₁ - m₀₀ = p₁ * q₁ * b - p₀ * q₀ * b' :=
    sub_eq_zero.mp ((mul_eq_zero.mp hP').resolve_left hp)
  have hdQ : m₁₁ - m₀₀ = p₁ * q₁ * b' - p₀ * q₀ * b :=
    sub_eq_zero.mp ((mul_eq_zero.mp hQ').resolve_left hq)
  have hbb : (p₀ * q₀ + p₁ * q₁) * (b - b') = 0 := by
    calc
      _ = (p₁ * q₁ * b - p₀ * q₀ * b') -
          (p₁ * q₁ * b' - p₀ * q₀ * b) := by ring
      _ = 0 := by rw [← hdP, ← hdQ]; ring
  have hb : b = b' := sub_eq_zero.mp ((mul_eq_zero.mp hbb).resolve_left hc)
  refine ⟨hb, m₀₀ - b * p₀ * q₀, ?_, ?_, ?_, ?_⟩
  · ring
  · rw [h₀₁]
    ring
  · rw [h₁₀, ← hb]
    ring
  · calc
      m₁₁ = m₀₀ + (m₁₁ - m₀₀) := by ring
      _ = (m₀₀ - b * p₀ * q₀) + b * p₁ * q₁ := by rw [hdP, ← hb]; ring

theorem normal_form_of_wedges_and_divisibility
    {M : Matrix (Fin 2) (Fin 2) R} {P Q : Fin 2 → R} {b b' : R}
    (hp : P 0 * P 1 ≠ 0) (hq : Q 0 * Q 1 ≠ 0) (hc : dot₂ P Q ≠ 0)
    (h₀₁ : M 0 1 = P 0 * Q 1 * b) (h₁₀ : M 1 0 = P 1 * Q 0 * b')
    (hP : cross₂ P (M *ᵥ P) = 0) (hQ : cross₂ Q (Mᵀ *ᵥ Q) = 0) :
    b = b' ∧ ∃ a : R, M = a • (1 : Matrix (Fin 2) (Fin 2) R) +
      b • Matrix.vecMulVec P Q := by
  have hP' : P 0 ^ 2 * M 1 0 + P 0 * P 1 * (M 1 1 - M 0 0) -
      P 1 ^ 2 * M 0 1 = 0 := by
    calc
      _ = cross₂ P (M *ᵥ P) := by
        simp [cross₂, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
        ring
      _ = 0 := hP
  have hQ' : Q 0 ^ 2 * M 0 1 + Q 0 * Q 1 * (M 1 1 - M 0 0) -
      Q 1 ^ 2 * M 1 0 = 0 := by
    calc
      _ = cross₂ Q (Mᵀ *ᵥ Q) := by
        simp [cross₂, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
        ring
      _ = 0 := hQ
  obtain ⟨hb, a, h₀₀, h₀₁', h₁₀', h₁₁⟩ :=
    normal_form_entries hp hq hc h₀₁ h₁₀ hP' hQ'
  refine ⟨hb, a, ?_⟩
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.vecMulVec, h₀₀, h₀₁', h₁₀', h₁₁, mul_assoc]

theorem normal_form_of_eigenvectors_and_divisibility
    {M : Matrix (Fin 2) (Fin 2) R} {P Q : Fin 2 → R} {b b' lval rval : R}
    (hp : P 0 * P 1 ≠ 0) (hq : Q 0 * Q 1 ≠ 0) (hc : dot₂ P Q ≠ 0)
    (h₀₁ : M 0 1 = P 0 * Q 1 * b) (h₁₀ : M 1 0 = P 1 * Q 0 * b')
    (hP : M *ᵥ P = lval • P) (hQ : Mᵀ *ᵥ Q = rval • Q) :
    b = b' ∧ ∃ a : R, M = a • (1 : Matrix (Fin 2) (Fin 2) R) +
      b • Matrix.vecMulVec P Q := by
  apply normal_form_of_wedges_and_divisibility hp hq hc h₀₁ h₁₀
  · rw [hP]
    simp [cross₂]
    ring
  · rw [hQ]
    simp [cross₂]
    ring

theorem scalar_outer_coefficients_unique
    {P Q : Fin 2 → R} {a b a' b' : R} (hpq : P 0 * Q 1 ≠ 0)
    (h : a • (1 : Matrix (Fin 2) (Fin 2) R) + b • Matrix.vecMulVec P Q =
      a' • (1 : Matrix (Fin 2) (Fin 2) R) + b' • Matrix.vecMulVec P Q) :
    a = a' ∧ b = b' := by
  have h₀₁ := congrArg (fun M : Matrix (Fin 2) (Fin 2) R => M 0 1) h
  have hb : b = b' := by
    apply mul_right_cancel₀ hpq
    simpa [Matrix.vecMulVec] using h₀₁
  have h₀₀ := congrArg (fun M : Matrix (Fin 2) (Fin 2) R => M 0 0) h
  have ha : a = a' := by
    apply add_right_cancel (b := b * (P 0 * Q 0))
    simpa [Matrix.vecMulVec, ← hb] using h₀₀
  exact ⟨ha, hb⟩

end Domain

section AdaptedFrames

variable {K : Type*} [Field K]

def adaptedFrame (P : Fin 2 → K) (s : K) : Matrix (Fin 2) (Fin 2) K :=
  !![P 1 / s, -(P 0 / s); P 0 / s, P 1 / s]

theorem adaptedFrame_orthogonal {P : Fin 2 → K} {s : K}
    (hs : s ≠ 0) (hsq : s ^ 2 = dot₂ P P) :
    (adaptedFrame P s)ᵀ * adaptedFrame P s = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [adaptedFrame, Matrix.mul_apply, Fin.sum_univ_two, dot₂] at * <;>
    field_simp
  all_goals
    try rw [hsq]
    ring

theorem adaptedFrame_first_coordinate {P : Fin 2 → K} {s : K} :
    (adaptedFrame P s *ᵥ P) 0 = 0 := by
  simp [adaptedFrame, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  ring

theorem cross₂_eq_zero_of_adapted_frame
    {M N : Matrix (Fin 2) (Fin 2) K} {P : Fin 2 → K} {s : K}
    (hs : s ≠ 0)
    (hcov : N = adaptedFrame P s * M * (adaptedFrame P s)ᵀ)
    (hzero : N 0 1 = 0) : cross₂ P (M *ᵥ P) = 0 := by
  have hentry := congrArg (fun A : Matrix (Fin 2) (Fin 2) K => A 0 1) hcov
  rw [hzero] at hentry
  have hscaled : cross₂ P (M *ᵥ P) = -s ^ 2 *
      (adaptedFrame P s * M * (adaptedFrame P s)ᵀ) 0 1 := by
    simp [cross₂, Matrix.mulVec, Matrix.vecMul, dotProduct, Matrix.mul_apply, adaptedFrame,
      Fin.sum_univ_two]
    field_simp
    ring
  rw [hscaled, ← hentry]
  ring

end AdaptedFrames

noncomputable section IndependentParameters

variable {K : Type*} [CommRing K] [IsDomain K]

def parameterP : Fin 2 → MvPolynomial (Fin 4) K :=
  ![MvPolynomial.X 0, MvPolynomial.X 1]

def parameterQ : Fin 2 → MvPolynomial (Fin 4) K :=
  ![MvPolynomial.X 2, MvPolynomial.X 3]

theorem parameterP_product_ne_zero :
    parameterP (K := K) 0 * parameterP (K := K) 1 ≠ 0 := by
  exact mul_ne_zero (MvPolynomial.X_ne_zero 0) (MvPolynomial.X_ne_zero 1)

theorem parameterQ_product_ne_zero :
    parameterQ (K := K) 0 * parameterQ (K := K) 1 ≠ 0 := by
  exact mul_ne_zero (MvPolynomial.X_ne_zero 2) (MvPolynomial.X_ne_zero 3)

theorem parameter_dot_ne_zero :
    dot₂ (parameterP (K := K)) (parameterQ (K := K)) ≠ 0 := by
  intro h
  have heval := congrArg (MvPolynomial.eval (![1, 0, 1, 0] : Fin 4 → K)) h
  simp [dot₂, parameterP, parameterQ, MvPolynomial.eval_add,
    MvPolynomial.eval_mul, MvPolynomial.eval_X] at heval

theorem parameterP_norm_ne_zero :
    dot₂ (parameterP (K := K)) (parameterP (K := K)) ≠ 0 := by
  intro h
  have heval := congrArg (MvPolynomial.eval (![1, 0, 0, 0] : Fin 4 → K)) h
  simp [dot₂, parameterP, MvPolynomial.eval_add,
    MvPolynomial.eval_mul, MvPolynomial.eval_X] at heval

theorem parameterQ_norm_ne_zero :
    dot₂ (parameterQ (K := K)) (parameterQ (K := K)) ≠ 0 := by
  intro h
  have heval := congrArg (MvPolynomial.eval (![0, 0, 1, 0] : Fin 4 → K)) h
  simp [dot₂, parameterQ, MvPolynomial.eval_add,
    MvPolynomial.eval_mul, MvPolynomial.eval_X] at heval

theorem polynomial_normal_form
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    (h₀₁ : parameterP (K := K) 0 * parameterQ (K := K) 1 ∣ M 0 1)
    (h₁₀ : parameterP (K := K) 1 * parameterQ (K := K) 0 ∣ M 1 0)
    (hP : cross₂ (parameterP (K := K)) (M *ᵥ parameterP (K := K)) = 0)
    (hQ : cross₂ (parameterQ (K := K)) (Mᵀ *ᵥ parameterQ (K := K)) = 0) :
    ∃ a b : MvPolynomial (Fin 4) K,
      M = a • (1 : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) +
        b • Matrix.vecMulVec (parameterP (K := K)) (parameterQ (K := K)) := by
  obtain ⟨b, hb⟩ := h₀₁
  obtain ⟨b', hb'⟩ := h₁₀
  obtain ⟨_, a, ha⟩ := normal_form_of_wedges_and_divisibility
    parameterP_product_ne_zero parameterQ_product_ne_zero parameter_dot_ne_zero
    hb hb' hP hQ
  exact ⟨a, b, ha⟩

theorem polynomial_normal_form_unique
    {a b a' b' : MvPolynomial (Fin 4) K}
    (h : a • (1 : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) +
        b • Matrix.vecMulVec (parameterP (K := K)) (parameterQ (K := K)) =
      a' • (1 : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) +
        b' • Matrix.vecMulVec (parameterP (K := K)) (parameterQ (K := K))) :
    a = a' ∧ b = b' := by
  exact scalar_outer_coefficients_unique
    (mul_ne_zero (MvPolynomial.X_ne_zero 0) (MvPolynomial.X_ne_zero 3)) h

end IndependentParameters

noncomputable section PolynomialCovariance

variable {K : Type*} [Field K]

def columnAssignment (P Q : Fin 2 → K) : Fin 4 → K :=
  ![P 0, P 1, Q 0, Q 1]

def evalAtColumns (M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K))
    (P Q : Fin 2 → K) : Matrix (Fin 2) (Fin 2) K :=
  fun i j => MvPolynomial.eval (columnAssignment P Q) (M i j)

omit [Field K] in
theorem columnAssignment_recover (z : Fin 4 → K) :
    columnAssignment ![z 0, z 1] ![z 2, z 3] = z := by
  ext i
  fin_cases i <;> rfl

theorem eval_right_wedge
    (M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) (z : Fin 4 → K) :
    MvPolynomial.eval z (cross₂ (parameterP (K := K))
      (M *ᵥ parameterP (K := K))) =
      cross₂ ![z 0, z 1] (evalAtColumns M ![z 0, z 1] ![z 2, z 3] *ᵥ ![z 0, z 1]) := by
  simp [cross₂, parameterP, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
    evalAtColumns, columnAssignment_recover, map_sub, map_add, map_mul,
    MvPolynomial.eval_X]

theorem eval_left_wedge
    (M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) (z : Fin 4 → K) :
    MvPolynomial.eval z (cross₂ (parameterQ (K := K))
      (Mᵀ *ᵥ parameterQ (K := K))) =
      cross₂ ![z 2, z 3] ((evalAtColumns M ![z 0, z 1] ![z 2, z 3])ᵀ *ᵥ ![z 2, z 3]) := by
  simp [cross₂, parameterQ, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
    evalAtColumns, columnAssignment_recover, map_sub, map_add, map_mul,
    MvPolynomial.eval_X]

def OrthogonalCovariant
    (M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) : Prop :=
  ∀ (O : Matrix (Fin 2) (Fin 2) K) (P Q : Fin 2 → K), Oᵀ * O = 1 →
    evalAtColumns M (O *ᵥ P) (O *ᵥ Q) = O * evalAtColumns M P Q * Oᵀ

theorem evalAtColumns_transverse_right_zero
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    (h₀₁ : parameterP (K := K) 0 * parameterQ (K := K) 1 ∣ M 0 1)
    {P Q : Fin 2 → K} (hp : P 0 = 0) : evalAtColumns M P Q 0 1 = 0 := by
  obtain ⟨b, hb⟩ := h₀₁
  simp [evalAtColumns, hb, parameterP, parameterQ, columnAssignment, hp,
    MvPolynomial.eval_mul, MvPolynomial.eval_X]

theorem evalAtColumns_transverse_left_zero
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    (h₁₀ : parameterP (K := K) 1 * parameterQ (K := K) 0 ∣ M 1 0)
    {P Q : Fin 2 → K} (hq : Q 0 = 0) : evalAtColumns M P Q 1 0 = 0 := by
  obtain ⟨b, hb⟩ := h₁₀
  simp [evalAtColumns, hb, parameterP, parameterQ, columnAssignment, hq,
    MvPolynomial.eval_mul, MvPolynomial.eval_X]

variable [IsAlgClosed K]

theorem evaluated_right_wedge_zero
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    (hcov : OrthogonalCovariant M)
    (h₀₁ : parameterP (K := K) 0 * parameterQ (K := K) 1 ∣ M 0 1)
    {P Q : Fin 2 → K} (hnorm : dot₂ P P ≠ 0) :
    cross₂ P (evalAtColumns M P Q *ᵥ P) = 0 := by
  obtain ⟨s, hsq⟩ := IsAlgClosed.exists_pow_nat_eq (dot₂ P P) zero_lt_two
  have hs : s ≠ 0 := by
    intro hs
    apply hnorm
    rw [← hsq, hs]
    simp
  apply cross₂_eq_zero_of_adapted_frame hs
    (hcov (adaptedFrame P s) P Q (adaptedFrame_orthogonal hs hsq))
  exact evalAtColumns_transverse_right_zero h₀₁ adaptedFrame_first_coordinate

theorem evaluated_left_wedge_zero
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    (hcov : OrthogonalCovariant M)
    (h₁₀ : parameterP (K := K) 1 * parameterQ (K := K) 0 ∣ M 1 0)
    {P Q : Fin 2 → K} (hnorm : dot₂ Q Q ≠ 0) :
    cross₂ Q ((evalAtColumns M P Q)ᵀ *ᵥ Q) = 0 := by
  obtain ⟨s, hsq⟩ := IsAlgClosed.exists_pow_nat_eq (dot₂ Q Q) zero_lt_two
  have hs : s ≠ 0 := by
    intro hs
    apply hnorm
    rw [← hsq, hs]
    simp
  have hrot := hcov (adaptedFrame Q s) P Q (adaptedFrame_orthogonal hs hsq)
  have ht : (evalAtColumns M (adaptedFrame Q s *ᵥ P)
      (adaptedFrame Q s *ᵥ Q))ᵀ =
      adaptedFrame Q s * (evalAtColumns M P Q)ᵀ * (adaptedFrame Q s)ᵀ := by
    rw [hrot]
    simp [Matrix.transpose_mul, Matrix.mul_assoc]
  apply cross₂_eq_zero_of_adapted_frame hs ht
  exact evalAtColumns_transverse_left_zero h₁₀ adaptedFrame_first_coordinate

theorem polynomial_right_wedge_zero
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    (hcov : OrthogonalCovariant M)
    (h₀₁ : parameterP (K := K) 0 * parameterQ (K := K) 1 ∣ M 0 1) :
    cross₂ (parameterP (K := K)) (M *ᵥ parameterP (K := K)) = 0 := by
  have hprod : dot₂ (parameterP (K := K)) (parameterP (K := K)) *
      cross₂ (parameterP (K := K)) (M *ᵥ parameterP (K := K)) = 0 := by
    apply MvPolynomial.funext
    intro z
    rw [map_zero, map_mul, eval_right_wedge]
    have hnormeval : MvPolynomial.eval z
        (dot₂ (parameterP (K := K)) (parameterP (K := K))) =
        dot₂ ![z 0, z 1] ![z 0, z 1] := by
      simp [dot₂, parameterP, map_add, map_mul, MvPolynomial.eval_X]
    rw [hnormeval]
    by_cases hn : dot₂ ![z 0, z 1] ![z 0, z 1] = 0
    · rw [hn, zero_mul]
    · rw [evaluated_right_wedge_zero hcov h₀₁ hn, mul_zero]
  exact (mul_eq_zero.mp hprod).resolve_left parameterP_norm_ne_zero

theorem polynomial_left_wedge_zero
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    (hcov : OrthogonalCovariant M)
    (h₁₀ : parameterP (K := K) 1 * parameterQ (K := K) 0 ∣ M 1 0) :
    cross₂ (parameterQ (K := K)) (Mᵀ *ᵥ parameterQ (K := K)) = 0 := by
  have hprod : dot₂ (parameterQ (K := K)) (parameterQ (K := K)) *
      cross₂ (parameterQ (K := K)) (Mᵀ *ᵥ parameterQ (K := K)) = 0 := by
    apply MvPolynomial.funext
    intro z
    rw [map_zero, map_mul, eval_left_wedge]
    have hnormeval : MvPolynomial.eval z
        (dot₂ (parameterQ (K := K)) (parameterQ (K := K))) =
        dot₂ ![z 2, z 3] ![z 2, z 3] := by
      simp [dot₂, parameterQ, map_add, map_mul, MvPolynomial.eval_X]
    rw [hnormeval]
    by_cases hn : dot₂ ![z 2, z 3] ![z 2, z 3] = 0
    · rw [hn, zero_mul]
    · rw [evaluated_left_wedge_zero hcov h₁₀ hn, mul_zero]
  exact (mul_eq_zero.mp hprod).resolve_left parameterQ_norm_ne_zero

theorem polynomial_normal_form_of_covariance
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    (hcov : OrthogonalCovariant M)
    (h₀₁ : parameterP (K := K) 0 * parameterQ (K := K) 1 ∣ M 0 1)
    (h₁₀ : parameterP (K := K) 1 * parameterQ (K := K) 0 ∣ M 1 0) :
    ∃ a b : MvPolynomial (Fin 4) K,
      M = a • (1 : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) +
        b • Matrix.vecMulVec (parameterP (K := K)) (parameterQ (K := K)) := by
  exact polynomial_normal_form h₀₁ h₁₀
    (polynomial_right_wedge_zero hcov h₀₁) (polynomial_left_wedge_zero hcov h₁₀)

end PolynomialCovariance

end Krenn.ReplicaCovariance

-- formal/all-orders/GramInvariants.lean

namespace Krenn.GramInvariants

open Krenn.ReplicaCovariance
open scoped Matrix

section MatrixAlgebra

variable {R : Type*} [CommRing R] [IsDomain R]

theorem scalar_outer_unique_of_nonzero
    {P Q : Fin 2 → R} {a b a' b' : R} (hp : P ≠ 0) (hq : Q ≠ 0)
    (h : a • (1 : Matrix (Fin 2) (Fin 2) R) + b • Matrix.vecMulVec P Q =
      a' • (1 : Matrix (Fin 2) (Fin 2) R) + b' • Matrix.vecMulVec P Q) :
    a = a' ∧ b = b' := by
  have h₀₀ := congrArg (fun M : Matrix (Fin 2) (Fin 2) R => M 0 0) h
  have h₀₁ := congrArg (fun M : Matrix (Fin 2) (Fin 2) R => M 0 1) h
  have h₁₁ := congrArg (fun M : Matrix (Fin 2) (Fin 2) R => M 1 1) h
  change a * 1 + b * (P 0 * Q 0) = a' * 1 + b' * (P 0 * Q 0) at h₀₀
  change a * 0 + b * (P 0 * Q 1) = a' * 0 + b' * (P 0 * Q 1) at h₀₁
  change a * 1 + b * (P 1 * Q 1) = a' * 1 + b' * (P 1 * Q 1) at h₁₁
  simp only [mul_one] at h₀₀ h₁₁
  simp only [mul_zero, zero_add] at h₀₁
  have hd₀₀ : a - a' = -(b - b') * (P 0 * Q 0) := by
    linear_combination h₀₀
  have hd₁₁ : a - a' = -(b - b') * (P 1 * Q 1) := by
    linear_combination h₁₁
  have hd₀₁ : (b - b') * (P 0 * Q 1) = 0 := by
    linear_combination h₀₁
  have ha : a = a' := by
    apply sub_eq_zero.mp
    have hs : (a - a') ^ 2 = 0 := by
      calc
        _ = (-(b - b') * (P 0 * Q 0)) * (-(b - b') * (P 1 * Q 1)) := by
          exact (pow_two (a - a')).trans (congrArg₂ (· * ·) hd₀₀ hd₁₁)
        _ = ((b - b') * (P 0 * Q 1)) * ((b - b') * (P 1 * Q 0)) := by ring
        _ = 0 := by rw [hd₀₁, zero_mul]
    have hs' : (a - a') * (a - a') = 0 := by simpa [pow_two] using hs
    exact (mul_eq_zero.mp hs').elim id id
  obtain ⟨i, hi⟩ := Function.ne_iff.mp hp
  obtain ⟨j, hj⟩ := Function.ne_iff.mp hq
  have hij := congrArg (fun M : Matrix (Fin 2) (Fin 2) R => M i j) h
  have hb : b = b' := by
    apply mul_right_cancel₀ (mul_ne_zero hi hj)
    simpa [Matrix.vecMulVec, ← ha] using hij
  exact ⟨ha, hb⟩

omit [IsDomain R] in

theorem conjugate_scalar_outer
    {O : Matrix (Fin 2) (Fin 2) R} (ho : Oᵀ * O = 1)
    (P Q : Fin 2 → R) (a b : R) :
    Oᵀ * (a • (1 : Matrix (Fin 2) (Fin 2) R) +
      b • Matrix.vecMulVec (O *ᵥ P) (O *ᵥ Q)) * O =
      a • (1 : Matrix (Fin 2) (Fin 2) R) + b • Matrix.vecMulVec P Q := by
  simp only [Matrix.mul_add, Matrix.add_mul, Matrix.mul_smul, Matrix.smul_mul,
    Matrix.mul_one, Matrix.mul_vecMulVec, Matrix.vecMulVec_mul,
    ← Matrix.mulVec_transpose, Matrix.mulVec_mulVec, ho, Matrix.one_mulVec]

end MatrixAlgebra

noncomputable section ScalarCovariance

variable {K : Type*} [Field K]

def framePullback (O : Matrix (Fin 2) (Fin 2) K) :
    MvPolynomial (Fin 4) K →+* MvPolynomial (Fin 4) K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    (columnAssignment ((O.map MvPolynomial.C) *ᵥ parameterP (K := K))
      ((O.map MvPolynomial.C) *ᵥ parameterQ (K := K)))

def OrthogonalInvariant (p : MvPolynomial (Fin 4) K) : Prop :=
  ∀ O : Matrix (Fin 2) (Fin 2) K, Oᵀ * O = 1 → framePullback O p = p

theorem eval_framePullback (O : Matrix (Fin 2) (Fin 2) K)
    (p : MvPolynomial (Fin 4) K) (z : Fin 4 → K) :
    MvPolynomial.eval z (framePullback O p) =
      MvPolynomial.eval (columnAssignment (O *ᵥ ![z 0, z 1])
        (O *ᵥ ![z 2, z 3])) p := by
  change MvPolynomial.eval z (MvPolynomial.eval₂ MvPolynomial.C _ p) = _
  rw [← MvPolynomial.eval_assoc]
  have hassign : MvPolynomial.eval z ∘
      columnAssignment ((O.map MvPolynomial.C) *ᵥ parameterP (K := K))
        ((O.map MvPolynomial.C) *ᵥ parameterQ (K := K)) =
      columnAssignment (O *ᵥ ![z 0, z 1]) (O *ᵥ ![z 2, z 3]) := by
    ext i
    fin_cases i <;>
      simp [columnAssignment, parameterP, parameterQ, Matrix.mulVec, dotProduct,
        Fin.sum_univ_two, map_add, map_mul, MvPolynomial.eval_C, MvPolynomial.eval_X]
  rw [hassign]

theorem eval_normal_form
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    {a b : MvPolynomial (Fin 4) K}
    (hm : M = a • (1 : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) +
      b • Matrix.vecMulVec (parameterP (K := K)) (parameterQ (K := K)))
    (P Q : Fin 2 → K) :
    evalAtColumns M P Q =
      MvPolynomial.eval (columnAssignment P Q) a • (1 : Matrix (Fin 2) (Fin 2) K) +
      MvPolynomial.eval (columnAssignment P Q) b • Matrix.vecMulVec P Q := by
  rw [hm]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [evalAtColumns, columnAssignment, parameterP, parameterQ, Matrix.vecMulVec,
      map_add, map_mul, MvPolynomial.eval_X]

theorem evaluated_coefficients_invariant
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    {a b : MvPolynomial (Fin 4) K} (hcov : OrthogonalCovariant M)
    (hm : M = a • (1 : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) +
      b • Matrix.vecMulVec (parameterP (K := K)) (parameterQ (K := K)))
    {O : Matrix (Fin 2) (Fin 2) K} (ho : Oᵀ * O = 1)
    {P Q : Fin 2 → K} (hp : P ≠ 0) (hq : Q ≠ 0) :
    MvPolynomial.eval (columnAssignment (O *ᵥ P) (O *ᵥ Q)) a =
        MvPolynomial.eval (columnAssignment P Q) a ∧
      MvPolynomial.eval (columnAssignment (O *ᵥ P) (O *ᵥ Q)) b =
        MvPolynomial.eval (columnAssignment P Q) b := by
  have hforms :
      MvPolynomial.eval (columnAssignment (O *ᵥ P) (O *ᵥ Q)) a •
          (1 : Matrix (Fin 2) (Fin 2) K) +
        MvPolynomial.eval (columnAssignment (O *ᵥ P) (O *ᵥ Q)) b •
          Matrix.vecMulVec P Q =
      MvPolynomial.eval (columnAssignment P Q) a • (1 : Matrix (Fin 2) (Fin 2) K) +
        MvPolynomial.eval (columnAssignment P Q) b • Matrix.vecMulVec P Q := by
    calc
      _ = Oᵀ * evalAtColumns M (O *ᵥ P) (O *ᵥ Q) * O := by
        rw [eval_normal_form hm, conjugate_scalar_outer ho]
      _ = Oᵀ * (O * evalAtColumns M P Q * Oᵀ) * O := by rw [hcov O P Q ho]
      _ = (Oᵀ * O) * evalAtColumns M P Q * (Oᵀ * O) := by
        simp only [Matrix.mul_assoc]
      _ = evalAtColumns M P Q := by rw [ho]; simp
      _ = _ := eval_normal_form hm P Q
  exact scalar_outer_unique_of_nonzero hp hq hforms

variable [Infinite K]

theorem normal_form_coefficients_invariant
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    {a b : MvPolynomial (Fin 4) K} (hcov : OrthogonalCovariant M)
    (hm : M = a • (1 : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) +
      b • Matrix.vecMulVec (parameterP (K := K)) (parameterQ (K := K))) :
    OrthogonalInvariant a ∧ OrthogonalInvariant b := by
  have hext (p : MvPolynomial (Fin 4) K)
      (hp : ∀ (O : Matrix (Fin 2) (Fin 2) K), Oᵀ * O = 1 →
        ∀ (P Q : Fin 2 → K), P ≠ 0 → Q ≠ 0 →
          MvPolynomial.eval (columnAssignment (O *ᵥ P) (O *ᵥ Q)) p =
            MvPolynomial.eval (columnAssignment P Q) p) : OrthogonalInvariant p := by
    intro O ho
    have hprod :
        (dot₂ (parameterP (K := K)) (parameterP (K := K)) *
          dot₂ (parameterQ (K := K)) (parameterQ (K := K))) *
          (framePullback O p - p) = 0 := by
      apply MvPolynomial.funext
      intro z
      simp only [map_mul, map_sub, map_zero, eval_framePullback]
      have hrecover : MvPolynomial.eval z p =
          MvPolynomial.eval (columnAssignment ![z 0, z 1] ![z 2, z 3]) p := by
        rw [columnAssignment_recover]
      rw [hrecover]
      have hevalP : MvPolynomial.eval z
          (dot₂ (parameterP (K := K)) (parameterP (K := K))) =
          dot₂ ![z 0, z 1] ![z 0, z 1] := by
        simp [dot₂, parameterP, map_add, map_mul, MvPolynomial.eval_X]
      have hevalQ : MvPolynomial.eval z
          (dot₂ (parameterQ (K := K)) (parameterQ (K := K))) =
          dot₂ ![z 2, z 3] ![z 2, z 3] := by
        simp [dot₂, parameterQ, map_add, map_mul, MvPolynomial.eval_X]
      rw [hevalP, hevalQ]
      by_cases hP : dot₂ ![z 0, z 1] ![z 0, z 1] = 0
      · rw [hP, zero_mul, zero_mul]
      by_cases hQ : dot₂ ![z 2, z 3] ![z 2, z 3] = 0
      · rw [hQ, mul_zero, zero_mul]
      have hp' : (![z 0, z 1] : Fin 2 → K) ≠ 0 := by
        intro hz
        apply hP
        rw [hz]
        simp [dot₂]
      have hq' : (![z 2, z 3] : Fin 2 → K) ≠ 0 := by
        intro hz
        apply hQ
        rw [hz]
        simp [dot₂]
      rw [hp O ho _ _ hp' hq', sub_self, mul_zero]
    exact sub_eq_zero.mp ((mul_eq_zero.mp hprod).resolve_left
      (mul_ne_zero parameterP_norm_ne_zero parameterQ_norm_ne_zero))
  constructor
  · apply hext a
    intro O ho P Q hp hq
    exact (evaluated_coefficients_invariant hcov hm ho hp hq).1
  · apply hext b
    intro O ho P Q hp hq
    exact (evaluated_coefficients_invariant hcov hm ho hp hq).2

end ScalarCovariance

noncomputable section GramMaps

variable {K : Type*} [CommRing K]

def gramMap : MvPolynomial (Fin 3) K →+* MvPolynomial (Fin 4) K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    ![dot₂ (parameterP (K := K)) (parameterP (K := K)),
      dot₂ (parameterQ (K := K)) (parameterQ (K := K)),
      dot₂ (parameterP (K := K)) (parameterQ (K := K))]

def axisGramMap : MvPolynomial (Fin 3) K →+* MvPolynomial (Fin 3) K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    ![MvPolynomial.X 0 ^ 2 + MvPolynomial.X 1 ^ 2,
      MvPolynomial.X 2 ^ 2, MvPolynomial.X 1 * MvPolynomial.X 2]

def axisRestriction : MvPolynomial (Fin 4) K →+* MvPolynomial (Fin 3) K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    ![MvPolynomial.X 0, MvPolynomial.X 1, 0, MvPolynomial.X 2]

theorem axisRestriction_comp_gramMap :
    (axisRestriction (K := K)).comp gramMap = axisGramMap := by
  apply MvPolynomial.ringHom_ext
  · intro r
    simp [axisRestriction, gramMap, axisGramMap]
  · intro i
    fin_cases i <;>
      simp [axisRestriction, gramMap, axisGramMap, dot₂, parameterP, parameterQ, pow_two]

theorem eval_axisGramMap (p : MvPolynomial (Fin 3) K) (z : Fin 3 → K) :
    MvPolynomial.eval z (axisGramMap p) =
      MvPolynomial.eval ![z 0 ^ 2 + z 1 ^ 2, z 2 ^ 2, z 1 * z 2] p := by
  change MvPolynomial.eval z (MvPolynomial.eval₂ MvPolynomial.C _ p) = _
  rw [← MvPolynomial.eval_assoc]
  have hassign : MvPolynomial.eval z ∘
      (![MvPolynomial.X 0 ^ 2 + MvPolynomial.X 1 ^ 2,
        MvPolynomial.X 2 ^ 2, MvPolynomial.X 1 * MvPolynomial.X 2] :
          Fin 3 → MvPolynomial (Fin 3) K) =
      ![z 0 ^ 2 + z 1 ^ 2, z 2 ^ 2, z 1 * z 2] := by
    ext i
    fin_cases i <;> simp [map_add, map_mul, map_pow, MvPolynomial.eval_X]
  rw [hassign]

end GramMaps

noncomputable section GramInjectivity

variable {K : Type*} [Field K] [IsAlgClosed K]

theorem exists_axis_gram_preimage (z : Fin 3 → K) (hτ : z 1 ≠ 0) :
    ∃ w : Fin 3 → K,
      ![w 0 ^ 2 + w 1 ^ 2, w 2 ^ 2, w 1 * w 2] = z := by
  obtain ⟨v, hv⟩ := IsAlgClosed.exists_pow_nat_eq (z 1) zero_lt_two
  have hv0 : v ≠ 0 := by
    intro h
    apply hτ
    rw [← hv, h]
    simp
  obtain ⟨a, ha⟩ := IsAlgClosed.exists_pow_nat_eq (z 0 - (z 2 / v) ^ 2) zero_lt_two
  refine ⟨![a, z 2 / v, v], ?_⟩
  ext i
  fin_cases i
  · change a ^ 2 + (z 2 / v) ^ 2 = z 0
    rw [ha]
    ring
  · exact hv
  · change (z 2 / v) * v = z 2
    simp [hv0]

theorem axisGramMap_injective : Function.Injective (axisGramMap (K := K)) := by
  have hker (p : MvPolynomial (Fin 3) K) (hp : axisGramMap p = 0) : p = 0 := by
    have hprod : MvPolynomial.X 1 * p = 0 := by
      apply MvPolynomial.funext
      intro z
      rw [map_zero, map_mul, MvPolynomial.eval_X]
      by_cases hz : z 1 = 0
      · rw [hz, zero_mul]
      obtain ⟨w, hw⟩ := exists_axis_gram_preimage z hz
      have heval := congrArg (MvPolynomial.eval w) hp
      rw [eval_axisGramMap, hw, map_zero] at heval
      rw [heval, mul_zero]
    exact (mul_eq_zero.mp hprod).resolve_left (MvPolynomial.X_ne_zero 1)
  intro p q hpq
  apply sub_eq_zero.mp
  apply hker
  rw [map_sub, hpq, sub_self]

theorem gramMap_injective : Function.Injective (gramMap (K := K)) := by
  intro p q hpq
  apply axisGramMap_injective
  have hcomp := congrArg (fun f : MvPolynomial (Fin 3) K →+*
      MvPolynomial (Fin 3) K => f p) (axisRestriction_comp_gramMap (K := K))
  have hcomp' := congrArg (fun f : MvPolynomial (Fin 3) K →+*
      MvPolynomial (Fin 3) K => f q) (axisRestriction_comp_gramMap (K := K))
  change axisRestriction (gramMap p) = axisGramMap p at hcomp
  change axisRestriction (gramMap q) = axisGramMap q at hcomp'
  rw [← hcomp, ← hcomp', hpq]

end GramInjectivity

section PowerSums

variable {A B : Type*} [CommRing A] [CommRing B]

theorem power_sum_mem_range (φ : A →+* B) {s t : B}
    (hs : s + t ∈ φ.range) (hp : s * t ∈ φ.range) (n : ℕ) :
    s ^ n + t ^ n ∈ φ.range := by
  induction n using Nat.twoStepInduction with
  | zero => simpa using φ.range.add_mem φ.range.one_mem φ.range.one_mem
  | one => simpa using hs
  | more n hn hn' =>
    have hm : (s + t) * (s ^ (n + 1) + t ^ (n + 1)) -
        (s * t) * (s ^ n + t ^ n) ∈ φ.range :=
      φ.range.sub_mem (φ.range.mul_mem hs hn') (φ.range.mul_mem hp hn)
    have heq : (s + t) * (s ^ (n + 1) + t ^ (n + 1)) -
        (s * t) * (s ^ n + t ^ n) = s ^ (n + 2) + t ^ (n + 2) := by
      rw [pow_succ, pow_succ, show n + 2 = (n + 1) + 1 by omega,
        pow_succ, pow_succ, pow_succ, pow_succ]
      ring
    rw [heq] at hm
    exact hm

end PowerSums

noncomputable section LightConeMonomials

variable {K : Type*} [CommRing K]

def lightGramMap : MvPolynomial (Fin 3) K →+* MvPolynomial (Fin 4) K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    ![MvPolynomial.X 0 * MvPolynomial.X 1,
      MvPolynomial.X 2 * MvPolynomial.X 3,
      MvPolynomial.X 0 * MvPolynomial.X 3 + MvPolynomial.X 1 * MvPolynomial.X 2]

def lightReflection : MvPolynomial (Fin 4) K →+* MvPolynomial (Fin 4) K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    ![MvPolynomial.X 1, MvPolynomial.X 0, MvPolynomial.X 3, MvPolynomial.X 2]

def lightScaling (r s : K) : MvPolynomial (Fin 4) K →+* MvPolynomial (Fin 4) K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    ![MvPolynomial.C r * MvPolynomial.X 0, MvPolynomial.C s * MvPolynomial.X 1,
      MvPolynomial.C r * MvPolynomial.X 2, MvPolynomial.C s * MvPolynomial.X 3]

@[simp] theorem lightScaling_C (r s a : K) :
    lightScaling r s (MvPolynomial.C a) = MvPolynomial.C a := by
  simp [lightScaling]

@[simp] theorem lightScaling_X (r s : K) (i : Fin 4) :
    lightScaling r s (MvPolynomial.X i) =
      (![MvPolynomial.C r * MvPolynomial.X 0, MvPolynomial.C s * MvPolynomial.X 1,
        MvPolynomial.C r * MvPolynomial.X 2, MvPolynomial.C s * MvPolynomial.X 3] i :
          MvPolynomial (Fin 4) K) := by
  simp [lightScaling]

@[simp] theorem lightReflection_C (a : K) :
    lightReflection (MvPolynomial.C a) = MvPolynomial.C a := by
  simp [lightReflection]

@[simp] theorem lightReflection_X (i : Fin 4) :
    lightReflection (MvPolynomial.X i) =
      (![MvPolynomial.X 1, MvPolynomial.X 0, MvPolynomial.X 3, MvPolynomial.X 2] i :
        MvPolynomial (Fin 4) K) := by
  simp [lightReflection]

private theorem monomial_four (d : Fin 4 →₀ ℕ) (a : K) :
    MvPolynomial.monomial d a = MvPolynomial.C a *
      (MvPolynomial.X 0 ^ d 0 * MvPolynomial.X 1 ^ d 1 *
        MvPolynomial.X 2 ^ d 2 * MvPolynomial.X 3 ^ d 3) := by
  have hd : Finsupp.indicator Finset.univ (fun i _ => d i) = d := by
    ext i
    simp
  have hm := MvPolynomial.prod_X_pow (R := K) d Finset.univ
  rw [hd] at hm
  calc
    _ = MvPolynomial.C a * MvPolynomial.monomial d 1 := by
      rw [MvPolynomial.C_mul_monomial, mul_one]
    _ = _ := by
      rw [← hm]
      congr 1
      simp [Fin.prod_univ_succ, mul_assoc]

theorem lightScaling_monomial (r s : K) (d : Fin 4 →₀ ℕ) (a : K) :
    lightScaling r s (MvPolynomial.monomial d a) =
      MvPolynomial.monomial d (a * r ^ (d 0 + d 2) * s ^ (d 1 + d 3)) := by
  rw [monomial_four, monomial_four]
  simp only [map_mul, map_pow, lightScaling_C, lightScaling_X]
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.cons_val_three]
  dsimp [Matrix.vecHead, Matrix.vecTail]
  simp only [pow_add, mul_pow]
  ring

theorem coeff_lightScaling (r s : K) (p : MvPolynomial (Fin 4) K) (d : Fin 4 →₀ ℕ) :
    MvPolynomial.coeff d (lightScaling r s p) =
      MvPolynomial.coeff d p * r ^ (d 0 + d 2) * s ^ (d 1 + d 3) := by
  have hs := congrArg (lightScaling r s) (MvPolynomial.as_sum p)
  rw [map_sum] at hs
  rw [hs, MvPolynomial.coeff_sum]
  simp only [lightScaling_monomial, MvPolynomial.coeff_monomial]
  rw [Finset.sum_eq_single d]
  · simp
  · intro b hb hbd
    simp [hbd]
  · intro hd
    have hcoeff : MvPolynomial.coeff d p = 0 :=
      (MvPolynomial.notMem_support_iff).mp hd
    simp [hcoeff]

private theorem light_generator_mem (i : Fin 3) :
    (![MvPolynomial.X 0 * MvPolynomial.X 1,
      MvPolynomial.X 2 * MvPolynomial.X 3,
      MvPolynomial.X 0 * MvPolynomial.X 3 + MvPolynomial.X 1 * MvPolynomial.X 2] i :
        MvPolynomial (Fin 4) K) ∈ (lightGramMap (K := K)).range := by
  refine ⟨MvPolynomial.X i, ?_⟩
  simp [lightGramMap]

private theorem light_power_sum_mem (n : ℕ) :
    ((MvPolynomial.X 0 * MvPolynomial.X 3) ^ n +
      (MvPolynomial.X 1 * MvPolynomial.X 2) ^ n : MvPolynomial (Fin 4) K) ∈
      (lightGramMap (K := K)).range := by
  apply power_sum_mem_range
  · exact light_generator_mem 2
  · have h : ((MvPolynomial.X 0 * MvPolynomial.X 1) *
        (MvPolynomial.X 2 * MvPolynomial.X 3) : MvPolynomial (Fin 4) K) ∈
        (lightGramMap (K := K)).range := (lightGramMap (K := K)).range.mul_mem
      (light_generator_mem 0) (light_generator_mem 1)
    convert h using 1
    ring

theorem balanced_monomial_symmetrization_mem (d : Fin 4 →₀ ℕ) (a : K)
    (hd : d 0 + d 2 = d 1 + d 3) :
    MvPolynomial.monomial d a + lightReflection (MvPolynomial.monomial d a) ∈
      (lightGramMap (K := K)).range := by
  have hC : (MvPolynomial.C a : MvPolynomial (Fin 4) K) ∈
      (lightGramMap (K := K)).range := ⟨MvPolynomial.C a, by simp [lightGramMap]⟩
  have hA : (MvPolynomial.X 0 * MvPolynomial.X 1 : MvPolynomial (Fin 4) K) ∈
      (lightGramMap (K := K)).range := light_generator_mem 0
  have hB : (MvPolynomial.X 2 * MvPolynomial.X 3 : MvPolynomial (Fin 4) K) ∈
      (lightGramMap (K := K)).range := light_generator_mem 1
  by_cases h : d 1 ≤ d 0
  · have h₀ : d 0 = d 1 + (d 0 - d 1) := by omega
    have h₃ : d 3 = d 2 + (d 0 - d 1) := by omega
    have heq : MvPolynomial.monomial d a = MvPolynomial.C a *
        (MvPolynomial.X 0 * MvPolynomial.X 1) ^ d 1 *
        (MvPolynomial.X 2 * MvPolynomial.X 3) ^ d 2 *
        (MvPolynomial.X 0 * MvPolynomial.X 3) ^ (d 0 - d 1) := by
      conv_lhs => rw [monomial_four, h₀, h₃]
      simp only [pow_add, mul_pow]
      ring
    rw [heq]
    simp only [map_mul, map_pow, lightReflection_C, lightReflection_X]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three]
    dsimp [Matrix.vecHead, Matrix.vecTail]
    have hm := (lightGramMap (K := K)).range.mul_mem
      ((lightGramMap (K := K)).range.mul_mem
        ((lightGramMap (K := K)).range.mul_mem hC
          ((lightGramMap (K := K)).range.pow_mem hA (d 1)))
        ((lightGramMap (K := K)).range.pow_mem hB (d 2)))
      (light_power_sum_mem (d 0 - d 1))
    convert hm using 1
    ring
  · have h₁ : d 1 = d 0 + (d 1 - d 0) := by omega
    have h₂ : d 2 = d 3 + (d 1 - d 0) := by omega
    have heq : MvPolynomial.monomial d a = MvPolynomial.C a *
        (MvPolynomial.X 0 * MvPolynomial.X 1) ^ d 0 *
        (MvPolynomial.X 2 * MvPolynomial.X 3) ^ d 3 *
        (MvPolynomial.X 1 * MvPolynomial.X 2) ^ (d 1 - d 0) := by
      conv_lhs => rw [monomial_four, h₁, h₂]
      simp only [pow_add, mul_pow]
      ring
    rw [heq]
    simp only [map_mul, map_pow, lightReflection_C, lightReflection_X]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three]
    dsimp [Matrix.vecHead, Matrix.vecTail]
    have hm := (lightGramMap (K := K)).range.mul_mem
      ((lightGramMap (K := K)).range.mul_mem
        ((lightGramMap (K := K)).range.mul_mem hC
          ((lightGramMap (K := K)).range.pow_mem hA (d 0)))
        ((lightGramMap (K := K)).range.pow_mem hB (d 3)))
      (light_power_sum_mem (d 1 - d 0))
    convert hm using 1
    ring

end LightConeMonomials

noncomputable section LightConeRepresentation

variable {K : Type*} [Field K] [CharZero K]

theorem balanced_of_lightScaling_two
    (p : MvPolynomial (Fin 4) K) (hscale : lightScaling 2 (2 : K)⁻¹ p = p) :
    ∀ d ∈ p.support, d 0 + d 2 = d 1 + d 3 := by
  intro d hd
  have hc : MvPolynomial.coeff d p ≠ 0 := MvPolynomial.mem_support_iff.mp hd
  have hcoeff := congrArg (MvPolynomial.coeff d) hscale
  rw [coeff_lightScaling] at hcoeff
  have hpow : (2 : K) ^ (d 0 + d 2) = (2 : K) ^ (d 1 + d 3) := by
    have hprod : (2 : K) ^ (d 0 + d 2) * ((2 : K)⁻¹) ^ (d 1 + d 3) = 1 := by
      apply mul_left_cancel₀ hc
      simpa [mul_assoc] using hcoeff
    have hm := congrArg (fun a : K => a * (2 : K) ^ (d 1 + d 3)) hprod
    simpa [mul_assoc, ← mul_pow, two_ne_zero] using hm
  have hnat : (2 : ℕ) ^ (d 0 + d 2) = (2 : ℕ) ^ (d 1 + d 3) := by
    apply Nat.cast_injective (R := K)
    simpa using hpow
  exact Nat.pow_right_injective (by decide : 2 ≤ (2 : ℕ)) hnat

theorem light_gram_representation_of_balanced_reflection
    (p : MvPolynomial (Fin 4) K)
    (hbalance : ∀ d ∈ p.support, d 0 + d 2 = d 1 + d 3)
    (hreflection : lightReflection p = p) :
    ∃ g : MvPolynomial (Fin 3) K, lightGramMap g = p := by
  have hsum : ∑ d ∈ p.support, MvPolynomial.monomial d (MvPolynomial.coeff d p) = p :=
    MvPolynomial.support_sum_monomial_coeff p
  have hsumsym : p + lightReflection p =
      ∑ d ∈ p.support, (MvPolynomial.monomial d (MvPolynomial.coeff d p) +
        lightReflection (MvPolynomial.monomial d (MvPolynomial.coeff d p))) := by
    rw [Finset.sum_add_distrib, ← map_sum, hsum]
  have hsym : p + lightReflection p ∈ (lightGramMap (K := K)).range := by
    rw [hsumsym]
    apply (lightGramMap (K := K)).range.sum_mem
    intro d hd
    exact balanced_monomial_symmetrization_mem d _ (hbalance d hd)
  have hhalf : (MvPolynomial.C ((2 : K)⁻¹) : MvPolynomial (Fin 4) K) ∈
      (lightGramMap (K := K)).range :=
    ⟨MvPolynomial.C ((2 : K)⁻¹), by simp [lightGramMap]⟩
  have hp := (lightGramMap (K := K)).range.mul_mem hhalf hsym
  have heq : MvPolynomial.C ((2 : K)⁻¹) * (p + lightReflection p) = p := by
    rw [hreflection]
    calc
      _ = (MvPolynomial.C ((2 : K)⁻¹) * MvPolynomial.C (2 : K)) * p := by
        simp only [map_ofNat]
        ring
      _ = p := by rw [← map_mul, inv_mul_cancel₀ (two_ne_zero : (2 : K) ≠ 0), map_one, one_mul]
  rw [heq] at hp
  exact hp

end LightConeRepresentation

noncomputable section LightConeCoordinates

variable {K : Type*} [Field K] [CharZero K]

def cartesianOfLight (i : K) (z : Fin 4 → K) : Fin 4 → K :=
  ![(z 0 + z 1) / 2, (-i / 2) * (z 0 - z 1),
    (z 2 + z 3) / 2, (-i / 2) * (z 2 - z 3)]

def lightOfCartesian (i : K) (z : Fin 4 → K) : Fin 4 → K :=
  ![z 0 + i * z 1, z 0 - i * z 1, z 2 + i * z 3, z 2 - i * z 3]

def toLightCone (i : K) : MvPolynomial (Fin 4) K →+* MvPolynomial (Fin 4) K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    ![MvPolynomial.C ((2 : K)⁻¹) * (MvPolynomial.X 0 + MvPolynomial.X 1),
      MvPolynomial.C (-i / 2) * (MvPolynomial.X 0 - MvPolynomial.X 1),
      MvPolynomial.C ((2 : K)⁻¹) * (MvPolynomial.X 2 + MvPolynomial.X 3),
      MvPolynomial.C (-i / 2) * (MvPolynomial.X 2 - MvPolynomial.X 3)]

def fromLightCone (i : K) : MvPolynomial (Fin 4) K →+* MvPolynomial (Fin 4) K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    ![MvPolynomial.X 0 + MvPolynomial.C i * MvPolynomial.X 1,
      MvPolynomial.X 0 - MvPolynomial.C i * MvPolynomial.X 1,
      MvPolynomial.X 2 + MvPolynomial.C i * MvPolynomial.X 3,
      MvPolynomial.X 2 - MvPolynomial.C i * MvPolynomial.X 3]

omit [CharZero K] in
theorem eval_toLightCone (i : K) (p : MvPolynomial (Fin 4) K) (z : Fin 4 → K) :
    MvPolynomial.eval z (toLightCone i p) = MvPolynomial.eval (cartesianOfLight i z) p := by
  change MvPolynomial.eval z (MvPolynomial.eval₂ MvPolynomial.C _ p) = _
  rw [← MvPolynomial.eval_assoc]
  have hassign : MvPolynomial.eval z ∘
      (![MvPolynomial.C ((2 : K)⁻¹) * (MvPolynomial.X 0 + MvPolynomial.X 1),
        MvPolynomial.C (-i / 2) * (MvPolynomial.X 0 - MvPolynomial.X 1),
        MvPolynomial.C ((2 : K)⁻¹) * (MvPolynomial.X 2 + MvPolynomial.X 3),
        MvPolynomial.C (-i / 2) * (MvPolynomial.X 2 - MvPolynomial.X 3)] :
          Fin 4 → MvPolynomial (Fin 4) K) = cartesianOfLight i z := by
    ext j
    fin_cases j <;> simp [cartesianOfLight, map_add, map_sub, map_mul,
      MvPolynomial.eval_C, MvPolynomial.eval_X, div_eq_mul_inv, mul_comm]
  rw [hassign]

omit [CharZero K] in
theorem eval_fromLightCone (i : K) (p : MvPolynomial (Fin 4) K) (z : Fin 4 → K) :
    MvPolynomial.eval z (fromLightCone i p) = MvPolynomial.eval (lightOfCartesian i z) p := by
  change MvPolynomial.eval z (MvPolynomial.eval₂ MvPolynomial.C _ p) = _
  rw [← MvPolynomial.eval_assoc]
  have hassign : MvPolynomial.eval z ∘
      (![MvPolynomial.X 0 + MvPolynomial.C i * MvPolynomial.X 1,
        MvPolynomial.X 0 - MvPolynomial.C i * MvPolynomial.X 1,
        MvPolynomial.X 2 + MvPolynomial.C i * MvPolynomial.X 3,
        MvPolynomial.X 2 - MvPolynomial.C i * MvPolynomial.X 3] :
          Fin 4 → MvPolynomial (Fin 4) K) = lightOfCartesian i z := by
    ext j
    fin_cases j <;> simp [lightOfCartesian, map_add, map_sub, map_mul,
      MvPolynomial.eval_C, MvPolynomial.eval_X]
  rw [hassign]

theorem cartesian_light_inverse {i : K} (hi : i ^ 2 = -1) (z : Fin 4 → K) :
    cartesianOfLight i (lightOfCartesian i z) = z := by
  ext j
  fin_cases j <;> simp [cartesianOfLight, lightOfCartesian] <;> field_simp
  all_goals
    ring_nf
    simp [hi]

variable [Infinite K]

theorem fromLightCone_toLightCone {i : K} (hi : i ^ 2 = -1)
    (p : MvPolynomial (Fin 4) K) : fromLightCone i (toLightCone i p) = p := by
  apply MvPolynomial.funext
  intro z
  rw [eval_fromLightCone, eval_toLightCone, cartesian_light_inverse hi]

def scalingFrame (i : K) : Matrix (Fin 2) (Fin 2) K :=
  !![5 / 4, 3 * i / 4; -(3 * i / 4), 5 / 4]

omit [Infinite K] in
theorem scalingFrame_orthogonal {i : K} (hi : i ^ 2 = -1) :
    (scalingFrame i)ᵀ * scalingFrame i = 1 := by
  ext j k
  fin_cases j <;> fin_cases k <;>
    simp [scalingFrame, Matrix.mul_apply, Fin.sum_univ_two] <;> field_simp
  all_goals
    ring_nf <;> norm_num [hi]

omit [CharZero K] [Infinite K] in
theorem eval_lightScaling (r s : K) (p : MvPolynomial (Fin 4) K) (z : Fin 4 → K) :
    MvPolynomial.eval z (lightScaling r s p) =
      MvPolynomial.eval ![r * z 0, s * z 1, r * z 2, s * z 3] p := by
  change MvPolynomial.eval z (MvPolynomial.eval₂ MvPolynomial.C _ p) = _
  rw [← MvPolynomial.eval_assoc]
  have hassign : MvPolynomial.eval z ∘
      (![MvPolynomial.C r * MvPolynomial.X 0, MvPolynomial.C s * MvPolynomial.X 1,
        MvPolynomial.C r * MvPolynomial.X 2, MvPolynomial.C s * MvPolynomial.X 3] :
          Fin 4 → MvPolynomial (Fin 4) K) = ![r * z 0, s * z 1, r * z 2, s * z 3] := by
    ext j
    fin_cases j <;> simp [map_mul, MvPolynomial.eval_C, MvPolynomial.eval_X]
  rw [hassign]

omit [CharZero K] [Infinite K] in
theorem eval_lightReflection (p : MvPolynomial (Fin 4) K) (z : Fin 4 → K) :
    MvPolynomial.eval z (lightReflection p) = MvPolynomial.eval ![z 1, z 0, z 3, z 2] p := by
  change MvPolynomial.eval z (MvPolynomial.eval₂ MvPolynomial.C _ p) = _
  rw [← MvPolynomial.eval_assoc]
  have hassign : MvPolynomial.eval z ∘
      (![MvPolynomial.X 1, MvPolynomial.X 0, MvPolynomial.X 3, MvPolynomial.X 2] :
          Fin 4 → MvPolynomial (Fin 4) K) = ![z 1, z 0, z 3, z 2] := by
    ext j
    fin_cases j <;> simp [MvPolynomial.eval_X]
  rw [hassign]

omit [Infinite K] in
theorem cartesian_scalingFrame {i : K} (hi : i ^ 2 = -1) (z : Fin 4 → K) :
    cartesianOfLight i ![2 * z 0, (2 : K)⁻¹ * z 1, 2 * z 2, (2 : K)⁻¹ * z 3] =
      columnAssignment (scalingFrame i *ᵥ ![(cartesianOfLight i z) 0, (cartesianOfLight i z) 1])
        (scalingFrame i *ᵥ ![(cartesianOfLight i z) 2, (cartesianOfLight i z) 3]) := by
  ext j
  fin_cases j <;>
    simp [cartesianOfLight, scalingFrame, columnAssignment, Matrix.mulVec,
      dotProduct, Fin.sum_univ_two] <;> field_simp
  all_goals
    ring_nf <;> (norm_num [hi]; ring)

def reflectionFrame : Matrix (Fin 2) (Fin 2) K := !![1, 0; 0, -1]

omit [CharZero K] [Infinite K] in
theorem reflectionFrame_orthogonal :
    (reflectionFrame (K := K))ᵀ * reflectionFrame = 1 := by
  ext j k
  fin_cases j <;> fin_cases k <;>
    simp [reflectionFrame, Matrix.mul_apply, Fin.sum_univ_two]

omit [CharZero K] [Infinite K] in
theorem cartesian_reflectionFrame (i : K) (z : Fin 4 → K) :
    cartesianOfLight i ![z 1, z 0, z 3, z 2] =
      columnAssignment (reflectionFrame *ᵥ ![(cartesianOfLight i z) 0, (cartesianOfLight i z) 1])
        (reflectionFrame *ᵥ ![(cartesianOfLight i z) 2, (cartesianOfLight i z) 3]) := by
  ext j
  fin_cases j <;>
    simp [cartesianOfLight, reflectionFrame, columnAssignment, Matrix.mulVec,
      dotProduct, Fin.sum_univ_two] <;> ring

theorem lightScaling_toLightCone {i : K} (hi : i ^ 2 = -1)
    (p : MvPolynomial (Fin 4) K) :
    lightScaling 2 (2 : K)⁻¹ (toLightCone i p) =
      toLightCone i (framePullback (scalingFrame i) p) := by
  apply MvPolynomial.funext
  intro z
  rw [eval_lightScaling, eval_toLightCone, eval_toLightCone, eval_framePullback,
    cartesian_scalingFrame hi]

omit [CharZero K] in
theorem lightReflection_toLightCone (i : K) (p : MvPolynomial (Fin 4) K) :
    lightReflection (toLightCone i p) = toLightCone i (framePullback reflectionFrame p) := by
  apply MvPolynomial.funext
  intro z
  rw [eval_lightReflection, eval_toLightCone, eval_toLightCone, eval_framePullback,
    cartesian_reflectionFrame]

theorem light_gram_representation_of_orthogonalInvariant
    {i : K} (hi : i ^ 2 = -1) (p : MvPolynomial (Fin 4) K)
    (hp : OrthogonalInvariant p) :
    ∃ g : MvPolynomial (Fin 3) K, lightGramMap g = toLightCone i p := by
  apply light_gram_representation_of_balanced_reflection
  · apply balanced_of_lightScaling_two
    rw [lightScaling_toLightCone hi, hp _ (scalingFrame_orthogonal hi)]
  · rw [lightReflection_toLightCone, hp _ reflectionFrame_orthogonal]

def doubleThird : MvPolynomial (Fin 3) K →+* MvPolynomial (Fin 3) K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    ![MvPolynomial.X 0, MvPolynomial.X 1, 2 * MvPolynomial.X 2]

omit [CharZero K] in
theorem fromLightCone_comp_lightGramMap {i : K} (hi : i ^ 2 = -1) :
    (fromLightCone i).comp lightGramMap = (gramMap (K := K)).comp doubleThird := by
  apply MvPolynomial.ringHom_ext
  · intro a
    simp [fromLightCone, lightGramMap, gramMap, doubleThird]
  · intro j
    apply MvPolynomial.funext
    intro z
    change MvPolynomial.eval z (fromLightCone i (lightGramMap (MvPolynomial.X j))) =
      MvPolynomial.eval z (gramMap (doubleThird (MvPolynomial.X j)))
    rw [eval_fromLightCone]
    fin_cases j <;>
      simp [lightGramMap, gramMap, doubleThird, lightOfCartesian, dot₂,
        parameterP, parameterQ, map_add, map_mul, MvPolynomial.eval_X]
    all_goals
      ring_nf
      norm_num [hi, map_ofNat]

variable [IsAlgClosed K]

theorem gram_representation_of_orthogonalInvariant
    (p : MvPolynomial (Fin 4) K) (hp : OrthogonalInvariant p) :
    ∃ g : MvPolynomial (Fin 3) K, gramMap g = p := by
  obtain ⟨i, hi⟩ := IsAlgClosed.exists_pow_nat_eq (-1 : K) zero_lt_two
  obtain ⟨g, hg⟩ := light_gram_representation_of_orthogonalInvariant hi p hp
  refine ⟨doubleThird g, ?_⟩
  have hcomp := congrArg (fun f : MvPolynomial (Fin 3) K →+*
      MvPolynomial (Fin 4) K => f g) (fromLightCone_comp_lightGramMap hi)
  change fromLightCone i (lightGramMap g) = gramMap (doubleThird g) at hcomp
  rw [← hcomp, hg, fromLightCone_toLightCone hi]

theorem normal_form_coefficients_gram_representation
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    {a b : MvPolynomial (Fin 4) K} (hcov : OrthogonalCovariant M)
    (hm : M = a • (1 : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) +
      b • Matrix.vecMulVec (parameterP (K := K)) (parameterQ (K := K))) :
    ∃ A B : MvPolynomial (Fin 3) K, gramMap A = a ∧ gramMap B = b := by
  obtain ⟨ha, hb⟩ := normal_form_coefficients_invariant hcov hm
  obtain ⟨A, hA⟩ := gram_representation_of_orthogonalInvariant a ha
  obtain ⟨B, hB⟩ := gram_representation_of_orthogonalInvariant b hb
  exact ⟨A, B, hA, hB⟩

theorem orthogonal_covariant_gram_normal_form
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    (hcov : OrthogonalCovariant M)
    (h₀₁ : parameterP (K := K) 0 * parameterQ (K := K) 1 ∣ M 0 1)
    (h₁₀ : parameterP (K := K) 1 * parameterQ (K := K) 0 ∣ M 1 0) :
    ∃ A B : MvPolynomial (Fin 3) K,
      M = gramMap A • (1 : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) +
        gramMap B • Matrix.vecMulVec (parameterP (K := K)) (parameterQ (K := K)) := by
  obtain ⟨a, b, hm⟩ := polynomial_normal_form_of_covariance hcov h₀₁ h₁₀
  obtain ⟨A, B, hA, hB⟩ := normal_form_coefficients_gram_representation hcov hm
  exact ⟨A, B, by simpa [hA, hB] using hm⟩

theorem orthogonal_covariant_gram_normal_form_unique
    {M : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    (hcov : OrthogonalCovariant M)
    (h₀₁ : parameterP (K := K) 0 * parameterQ (K := K) 1 ∣ M 0 1)
    (h₁₀ : parameterP (K := K) 1 * parameterQ (K := K) 0 ∣ M 1 0) :
    ∃! AB : MvPolynomial (Fin 3) K × MvPolynomial (Fin 3) K,
      M = gramMap AB.1 • (1 : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) +
        gramMap AB.2 • Matrix.vecMulVec (parameterP (K := K)) (parameterQ (K := K)) := by
  obtain ⟨A, B, hm⟩ := orthogonal_covariant_gram_normal_form hcov h₀₁ h₁₀
  refine ⟨(A, B), hm, ?_⟩
  intro AB hAB
  obtain ⟨hA, hB⟩ := polynomial_normal_form_unique (hAB.symm.trans hm)
  exact Prod.ext (gramMap_injective hA) (gramMap_injective hB)

end LightConeCoordinates

end Krenn.GramInvariants

-- formal/all-orders/PolynomialODE.lean

/-
Copyright (c) 2026 Rishi. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

namespace Krenn

open Polynomial

section Domain

variable {R : Type*} [CommRing R] [IsDomain R]

theorem eq_zero_of_derivative_add_C_mul_eq_zero {p : R[X]} {d : R}
    (hd : d ≠ 0) (h : derivative p + C d * p = 0) : p = 0 := by
  by_contra hp
  have hcoeff := congrArg (fun q : R[X] => q.coeff p.natDegree) h
  have htop : p.coeff (p.natDegree + 1) = 0 :=
    coeff_eq_zero_of_natDegree_lt (Nat.lt_succ_self p.natDegree)
  have hleading : d * p.leadingCoeff = 0 := by
    simpa [coeff_derivative, coeff_C_mul, htop] using hcoeff
  exact (mul_ne_zero hd (leadingCoeff_ne_zero.mpr hp)) hleading

theorem eq_C_coeff_zero_of_derivative_add_C_mul_eq_C {p : R[X]} {d k : R}
    (hd : d ≠ 0) (h : derivative p + C d * p = C k) : p = C (p.coeff 0) := by
  apply eq_C_of_natDegree_eq_zero
  by_contra hdegree
  have hp : p ≠ 0 := fun hp => hdegree (hp ▸ natDegree_zero)
  have hcoeff := congrArg (fun q : R[X] => q.coeff p.natDegree) h
  have htop : p.coeff (p.natDegree + 1) = 0 :=
    coeff_eq_zero_of_natDegree_lt (Nat.lt_succ_self p.natDegree)
  have hleading : d * p.leadingCoeff = 0 := by
    simpa only [coeff_add, coeff_derivative, coeff_C_mul, htop, zero_mul, zero_add,
      coeff_natDegree, coeff_C, if_neg hdegree] using hcoeff
  exact (mul_ne_zero hd (leadingCoeff_ne_zero.mpr hp)) hleading

theorem mul_coeff_zero_of_derivative_add_C_mul_eq_C {p : R[X]} {d k : R}
    (hd : d ≠ 0) (h : derivative p + C d * p = C k) : d * p.coeff 0 = k := by
  have hp := eq_C_coeff_zero_of_derivative_add_C_mul_eq_C hd h
  have hderivative : derivative p = 0 := by rw [hp, derivative_C]
  simpa only [coeff_add, hderivative, coeff_zero, coeff_C_mul, coeff_C_zero, zero_add]
    using congrArg (fun q : R[X] => q.coeff 0) h

theorem eq_C_of_derivative_add_C_mul_eq_C_mul {p : R[X]} {d a : R}
    (hd : d ≠ 0) (h : derivative p + C d * p = C (d * a)) : p = C a := by
  have hcoeff : p.coeff 0 = a :=
    mul_left_cancel₀ hd (mul_coeff_zero_of_derivative_add_C_mul_eq_C hd h)
  simpa [hcoeff] using eq_C_coeff_zero_of_derivative_add_C_mul_eq_C hd h

theorem endpoint_eq_of_polynomial_ode {p : R[X]} {d β η α : R}
    (hd : d ≠ 0) (hη : η ≠ 0)
    (h : derivative p + C d * p = C (β * η))
    (hzero : p.coeff 0 = η * α) : β = d * α := by
  have hscalar := mul_coeff_zero_of_derivative_add_C_mul_eq_C hd h
  rw [hzero] at hscalar
  apply mul_right_cancel₀ hη
  simpa [mul_assoc, mul_comm, mul_left_comm] using hscalar.symm

end Domain

section Field

variable {K : Type*} [Field K]

theorem eq_C_div_of_derivative_add_C_mul_eq_C {p : K[X]} {d k : K}
    (hd : d ≠ 0) (h : derivative p + C d * p = C k) : p = C (k / d) := by
  have hcoeff : p.coeff 0 = k / d := by
    apply (eq_div_iff hd).2
    simpa [mul_comm] using mul_coeff_zero_of_derivative_add_C_mul_eq_C hd h
  simpa [hcoeff] using eq_C_coeff_zero_of_derivative_add_C_mul_eq_C hd h

end Field

end Krenn

-- formal/all-orders/EndpointPDE.lean

namespace Krenn.EndpointPDE

open MvPolynomial
open Krenn.GramInvariants

noncomputable section ChainRule

variable {K : Type*} [Field K]

theorem axisRestriction_gramMap (p : MvPolynomial (Fin 3) K) :
    axisRestriction (gramMap p) = axisGramMap p :=
  DFunLike.congr_fun axisRestriction_comp_gramMap p

theorem eval_zero_gramMap (p : MvPolynomial (Fin 3) K) :
    MvPolynomial.eval (0 : Fin 4 → K) (gramMap p) =
      MvPolynomial.eval (0 : Fin 3 → K) p := by
  change MvPolynomial.eval (0 : Fin 4 → K) (MvPolynomial.eval₂ C _ p) = _
  rw [← MvPolynomial.eval_assoc]
  have hassign : MvPolynomial.eval (0 : Fin 4 → K) ∘
      ![Krenn.ReplicaCovariance.dot₂
          (Krenn.ReplicaCovariance.parameterP (K := K))
          (Krenn.ReplicaCovariance.parameterP (K := K)),
        Krenn.ReplicaCovariance.dot₂
          (Krenn.ReplicaCovariance.parameterQ (K := K))
          (Krenn.ReplicaCovariance.parameterQ (K := K)),
        Krenn.ReplicaCovariance.dot₂
          (Krenn.ReplicaCovariance.parameterP (K := K))
          (Krenn.ReplicaCovariance.parameterQ (K := K))] =
      (0 : Fin 3 → K) := by
    funext i
    fin_cases i <;>
      simp [Krenn.ReplicaCovariance.dot₂,
        Krenn.ReplicaCovariance.parameterP,
        Krenn.ReplicaCovariance.parameterQ]
  rw [hassign]

@[simp] theorem axisRestriction_C (a : K) :
    axisRestriction (C a) = (C a : MvPolynomial (Fin 3) K) := by
  simp [axisRestriction]

@[simp] theorem axisRestriction_X (i : Fin 4) :
    axisRestriction (X i) = (![X 0, X 1, 0, X 2] i : MvPolynomial (Fin 3) K) := by
  simp [axisRestriction]

@[simp] theorem axisGramMap_C (a : K) :
    axisGramMap (C a) = (C a : MvPolynomial (Fin 3) K) := by
  simp [axisGramMap]

theorem axisRestriction_pderiv_gramMap (p : MvPolynomial (Fin 3) K) :
    axisRestriction (pderiv 2 (gramMap p)) =
      X 0 * axisGramMap (pderiv 2 p) := by
  induction p using MvPolynomial.induction_on with
  | C a => simp [gramMap, axisGramMap, axisRestriction]
  | add p q hp hq => simp [hp, hq, mul_add]
  | mul_X p j hp =>
    simp only [map_mul, pderiv_mul, map_add, hp, axisRestriction_gramMap]
    fin_cases j <;>
      simp [gramMap, axisGramMap, axisRestriction,
        Krenn.ReplicaCovariance.dot₂,
        Krenn.ReplicaCovariance.parameterP,
        Krenn.ReplicaCovariance.parameterQ, pderiv_X]
    all_goals ring

theorem axisRestriction_offDiagonal_derivative (b : MvPolynomial (Fin 3) K) :
    axisRestriction (pderiv 2 (X 0 * X 3 * gramMap b)) =
      X 0 ^ 2 * X 2 * axisGramMap (pderiv 2 b) := by
  simp only [pderiv_mul, pderiv_X, Pi.single_apply]
  simp only [show (0 : Fin 4) ≠ 2 by decide, show (3 : Fin 4) ≠ 2 by decide,
    ite_false, zero_mul, mul_zero, add_zero, zero_add]
  rw [map_mul, map_mul, axisRestriction_pderiv_gramMap]
  simp only [axisRestriction_X, Matrix.cons_val_zero, Matrix.cons_val_three]
  dsimp [Matrix.vecHead, Matrix.vecTail]
  ring

end ChainRule

noncomputable section Univariate

variable {K : Type*} [Field K]

def cPolynomialEquiv : MvPolynomial (Fin 3) K ≃ₐ[K]
    Polynomial (MvPolynomial (Fin 2) K) :=
  (renameEquiv K (Equiv.swap (0 : Fin 3) 2)).trans (finSuccEquiv K 2)

theorem cPolynomialEquiv_C (a : K) :
    cPolynomialEquiv (C a) = Polynomial.C (C a) := by
  simp [cPolynomialEquiv, renameEquiv_apply, finSuccEquiv_apply]

theorem cPolynomialEquiv_X (j : Fin 3) :
    cPolynomialEquiv (X j) =
      (![Polynomial.C (X 1), Polynomial.C (X 0), Polynomial.X] j :
        Polynomial (MvPolynomial (Fin 2) K)) := by
  fin_cases j <;>
    simp [cPolynomialEquiv, renameEquiv_apply, finSuccEquiv_apply, Equiv.swap_apply_def]
  all_goals rfl

theorem cPolynomialEquiv_pderiv (p : MvPolynomial (Fin 3) K) :
    cPolynomialEquiv (pderiv 2 p) =
      Polynomial.derivative (cPolynomialEquiv p) := by
  induction p using MvPolynomial.induction_on with
  | C a => simp [cPolynomialEquiv_C]
  | add p q hp hq => simp [hp, hq]
  | mul_X p j hp =>
    simp only [pderiv_mul, map_add, map_mul, hp, Polynomial.derivative_mul,
      cPolynomialEquiv_X]
    fin_cases j <;> simp [pderiv_X]

theorem eq_zero_of_c_ode {b : MvPolynomial (Fin 3) K} {d : K}
    (hd : d ≠ 0) (h : pderiv 2 b + C d * b = 0) : b = 0 := by
  apply cPolynomialEquiv.injective
  rw [map_zero]
  apply Krenn.eq_zero_of_derivative_add_C_mul_eq_zero (C_ne_zero.mpr hd)
  simpa only [map_add, map_mul, cPolynomialEquiv_C, cPolynomialEquiv_pderiv,
    map_zero] using congrArg cPolynomialEquiv h

theorem eq_C_div_of_c_ode {a : MvPolynomial (Fin 3) K} {d k : K}
    (hd : d ≠ 0) (h : pderiv 2 a + C d * a = C k) : a = C (k / d) := by
  apply cPolynomialEquiv.injective
  rw [cPolynomialEquiv_C]
  apply Krenn.eq_C_of_derivative_add_C_mul_eq_C_mul (C_ne_zero.mpr hd)
  have hdk : d * (k / d) = k := by field_simp
  have h' := congrArg cPolynomialEquiv h
  simp only [map_add, map_mul, cPolynomialEquiv_C, cPolynomialEquiv_pderiv] at h'
  simpa only [← Polynomial.C_mul, ← map_mul, hdk] using h'

end Univariate

noncomputable section Boundary

variable {K : Type*} [Field K] [IsAlgClosed K]

def OffDiagonalBoundary (b : MvPolynomial (Fin 3) K) (d : K) : Prop :=
  axisRestriction (pderiv 2 (X 0 * X 3 * gramMap b) +
    C d * X 0 * (X 0 * X 3 * gramMap b)) = 0

def ScalarBoundary (a : MvPolynomial (Fin 3) K) (d k : K) : Prop :=
  axisRestriction (pderiv 2 (gramMap a) + C d * X 0 * gramMap a -
    C k * X 0) = 0

theorem c_ode_of_offDiagonalBoundary {b : MvPolynomial (Fin 3) K} {d : K}
    (h : OffDiagonalBoundary b d) : pderiv 2 b + C d * b = 0 := by
  have hp : X 0 ^ 2 * X 2 * axisGramMap (pderiv 2 b + C d * b) = 0 := by
    have h' := h
    unfold OffDiagonalBoundary at h'
    rw [map_add, axisRestriction_offDiagonal_derivative] at h'
    simp only [map_mul, axisRestriction_C, axisRestriction_X,
      axisRestriction_gramMap, Matrix.cons_val_zero, Matrix.cons_val_three] at h'
    dsimp [Matrix.vecHead, Matrix.vecTail] at h'
    simp only [map_add, map_mul, axisGramMap_C]
    convert h' using 1; ring
  have hz : axisGramMap (pderiv 2 b + C d * b) = 0 :=
    (mul_eq_zero.mp hp).resolve_left (mul_ne_zero (pow_ne_zero _ (X_ne_zero 0))
      (X_ne_zero 2))
  exact axisGramMap_injective (hz.trans (map_zero axisGramMap).symm)

theorem offDiagonal_eq_zero {b : MvPolynomial (Fin 3) K} {d : K}
    (hd : d ≠ 0) (h : OffDiagonalBoundary b d) : b = 0 :=
  eq_zero_of_c_ode hd (c_ode_of_offDiagonalBoundary h)

theorem c_ode_of_scalarBoundary {a : MvPolynomial (Fin 3) K} {d k : K}
    (h : ScalarBoundary a d k) : pderiv 2 a + C d * a = C k := by
  have hp : X 0 * axisGramMap (pderiv 2 a + C d * a - C k) = 0 := by
    have h' := h
    unfold ScalarBoundary at h'
    rw [map_sub, map_add, axisRestriction_pderiv_gramMap] at h'
    simp only [map_mul, axisRestriction_C, axisRestriction_X,
      axisRestriction_gramMap, Matrix.cons_val_zero] at h'
    simp only [map_sub, map_add, map_mul, axisGramMap_C]
    convert h' using 1; ring
  have hz : axisGramMap (pderiv 2 a + C d * a - C k) = 0 :=
    (mul_eq_zero.mp hp).resolve_left (X_ne_zero 0)
  exact sub_eq_zero.mp (axisGramMap_injective
    (hz.trans (map_zero axisGramMap).symm))

theorem scalar_eq_constant {a : MvPolynomial (Fin 3) K} {d k : K}
    (hd : d ≠ 0) (h : ScalarBoundary a d k) : a = C (k / d) :=
  eq_C_div_of_c_ode hd (c_ode_of_scalarBoundary h)

theorem endpoint_of_scalarBoundary {a : MvPolynomial (Fin 3) K} {d β η α : K}
    (hd : d ≠ 0) (hη : η ≠ 0) (h : ScalarBoundary a d (β * η))
    (hzero : MvPolynomial.eval (0 : Fin 3 → K) a = η * α) : β = d * α := by
  have ha := scalar_eq_constant hd h
  have hconst : β * η / d = η * α := by simpa [ha] using hzero
  apply mul_right_cancel₀ hη
  have hprod := (div_eq_iff hd).mp hconst
  simpa [mul_assoc, mul_comm, mul_left_comm] using hprod

end Boundary

noncomputable section MatrixEndpoint

open Krenn.ReplicaCovariance
open scoped Matrix

variable {K : Type*} [Field K] [IsAlgClosed K] [CharZero K]

def MatrixOffDiagonalBoundary
    (T : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) (d : K) : Prop :=
  axisRestriction (pderiv 2 (T 0 1) + C d * X 0 * T 0 1) = 0

def MatrixScalarBoundary
    (T : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)) (d k : K) : Prop :=
  axisRestriction (pderiv 2 (T 1 1) + C d * X 0 * T 1 1 - C k * X 0) = 0

omit [IsAlgClosed K] [CharZero K] in

theorem offDiagonalBoundary_of_matrix_normal_form
    {T : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    {a b : MvPolynomial (Fin 3) K} {d : K}
    (ht : T = gramMap a • 1 + gramMap b • Matrix.vecMulVec parameterP parameterQ)
    (h : MatrixOffDiagonalBoundary T d) : OffDiagonalBoundary b d := by
  have hentry : T 0 1 = X 0 * X 3 * gramMap b := by
    rw [ht]
    simp [Matrix.vecMulVec, parameterP, parameterQ]
    ring
  simpa only [MatrixOffDiagonalBoundary, hentry, OffDiagonalBoundary] using h

omit [IsAlgClosed K] [CharZero K] in

theorem scalarBoundary_of_matrix_normal_form
    {T : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)}
    {a b : MvPolynomial (Fin 3) K} {d k : K}
    (ht : T = gramMap a • 1 + gramMap b • Matrix.vecMulVec parameterP parameterQ)
    (hb : b = 0) (h : MatrixScalarBoundary T d k) : ScalarBoundary a d k := by
  have hentry : T 1 1 = gramMap a := by simp [ht, hb]
  simpa only [MatrixScalarBoundary, hentry, ScalarBoundary] using h

theorem endpoint_of_covariant_matrix_boundaries
    {T : Matrix (Fin 2) (Fin 2) (MvPolynomial (Fin 4) K)} {d β η α : K}
    (hd : d ≠ 0) (hη : η ≠ 0)
    (hcov : OrthogonalCovariant T)
    (h₀₁ : parameterP (K := K) 0 * parameterQ (K := K) 1 ∣ T 0 1)
    (h₁₀ : parameterP (K := K) 1 * parameterQ (K := K) 0 ∣ T 1 0)
    (hoff : MatrixOffDiagonalBoundary T d)
    (hscalar : MatrixScalarBoundary T d (β * η))
    (horigin : MvPolynomial.eval (0 : Fin 4 → K) (T 1 1) = η * α) :
    β = d * α := by
  obtain ⟨a, b, ht⟩ := orthogonal_covariant_gram_normal_form hcov h₀₁ h₁₀
  have hb : b = 0 := offDiagonal_eq_zero hd
    (offDiagonalBoundary_of_matrix_normal_form ht hoff)
  apply endpoint_of_scalarBoundary hd hη
    (scalarBoundary_of_matrix_normal_form ht hb hscalar)
  have hentry : T 1 1 = gramMap a := by simp [ht, hb]
  rw [hentry] at horigin
  simpa only [eval_zero_gramMap] using horigin

end MatrixEndpoint

end Krenn.EndpointPDE

-- formal/all-orders/ReplicaKernel.lean

namespace Krenn.ReplicaKernel

open MvPolynomial
open scoped BigOperators Matrix
open Krenn.ReplicaCovariance
open Krenn.GramInvariants
open Krenn.EndpointPDE

noncomputable section Substitution

variable {K σ τ : Type*} [CommRing K] [Fintype σ]

theorem pderiv_substitution (f : σ → MvPolynomial τ K)
    (p : MvPolynomial σ K) (j : τ) :
    pderiv j (eval₂Hom C f p) =
      ∑ i : σ, eval₂Hom C f (pderiv i p) * pderiv j (f i) := by
  classical
  induction p using MvPolynomial.induction_on with
  | C a => simp
  | add p q hp hq =>
    simp only [map_add, hp, hq, add_mul, Finset.sum_add_distrib]
  | mul_X p n hp =>
    simp only [map_mul, pderiv_mul, hp, eval₂Hom_X', map_add,
      pderiv_X, Pi.single_apply, Finset.sum_add_distrib, add_mul,
      Finset.sum_mul]
    simp only [apply_ite, map_one, map_zero, mul_one, mul_zero, ite_mul, zero_mul]
    rw [Finset.sum_ite_eq]
    simp only [Finset.mem_univ, ite_true]
    congr 1
    apply Finset.sum_congr rfl
    intro i _
    ring

end Substitution

noncomputable section Construction

variable {K ι : Type*} [Field K] [Fintype ι]

abbrev MeanPolynomial (K : Type*) [CommRing K] := MvPolynomial (Fin 4) K
abbrev ReplicaPolynomial (K : Type*) [CommRing K] := MvPolynomial (Fin 4 × Fin 2) K
abbrev CartesianPolynomial (K : Type*) [CommRing K] := MvPolynomial (Fin 4) K

def meanCopy (i : Fin 2) : MeanPolynomial K →+* ReplicaPolynomial K :=
  eval₂Hom C (fun j => X (j, i))

def zeroAuxiliary : ReplicaPolynomial K →+* CartesianPolynomial K :=
  eval₂Hom C (fun ji => (![parameterP (K := K) ji.2,
    parameterQ (K := K) ji.2, 0, 0] : Fin 4 → CartesianPolynomial K) ji.1)

def binaryMean (i : Fin 2) : MeanPolynomial K →+* CartesianPolynomial K :=
  eval₂Hom C ![parameterP (K := K) i, parameterQ (K := K) i, 0, 0]

theorem zeroAuxiliary_meanCopy (i : Fin 2) (p : MeanPolynomial K) :
    zeroAuxiliary (meanCopy i p) = binaryMean i p := by
  have hh : zeroAuxiliary.comp (meanCopy (K := K) i) = binaryMean i := by
    apply MvPolynomial.ringHom_ext
    · intro a
      simp [zeroAuxiliary, meanCopy, binaryMean]
    · intro j
      simp [zeroAuxiliary, meanCopy, binaryMean]
  exact DFunLike.congr_fun hh p

def contraction {σ : Type*} (κ : ι → ι → K)
    (A B : ι → MvPolynomial σ K) : MvPolynomial σ K :=
  ∑ s : ι, ∑ t : ι, C (κ s t) * A s * B t

def kernel (κ : ι → ι → K) (E : ι → MeanPolynomial K) : ReplicaPolynomial K :=
  contraction κ (fun s => meanCopy 0 (E s)) (fun s => meanCopy 1 (E s))

def scalarKernel (κ : ι → ι → K) (E : ι → MeanPolynomial K) :
    CartesianPolynomial K := zeroAuxiliary (kernel κ E)

def kernelMatrix (κ : ι → ι → K) (E : ι → MeanPolynomial K) :
    Matrix (Fin 2) (Fin 2) (CartesianPolynomial K) :=
  fun i j => zeroAuxiliary (pderiv (2, i) (pderiv (3, j) (kernel κ E)))

def correctedMatrix (κ : ι → ι → K) (E : ι → MeanPolynomial K) (e : K) :
    Matrix (Fin 2) (Fin 2) (CartesianPolynomial K) :=
  kernelMatrix κ E + (C e * scalarKernel κ E) • 1

theorem pderiv_meanCopy (r : Fin 4) (k i : Fin 2) (p : MeanPolynomial K) :
    pderiv (r, k) (meanCopy i p) =
      if k = i then meanCopy i (pderiv r p) else 0 := by
  classical
  rw [meanCopy, pderiv_substitution]
  simp only [pderiv_X, Pi.single_apply, Prod.mk.injEq]
  by_cases hi : k = i
  · subst k
    simp [and_true, eq_comm]
  · simp [hi, Ne.symm hi]

theorem pderiv_contraction {σ : Type*} (κ : ι → ι → K)
    (A B : ι → MvPolynomial σ K) (j : σ) :
    pderiv j (contraction κ A B) =
      contraction κ (fun s => pderiv j (A s)) B +
        contraction κ A (fun s => pderiv j (B s)) := by
  simp only [contraction, map_sum, pderiv_mul, pderiv_C, zero_mul, zero_add,
    Finset.sum_add_distrib]

theorem map_contraction {σ τ : Type*} (f : MvPolynomial σ K →+* MvPolynomial τ K)
    (hf : ∀ a, f (C a) = C a) (κ : ι → ι → K)
    (A B : ι → MvPolynomial σ K) :
    f (contraction κ A B) = contraction κ (fun s => f (A s)) (fun s => f (B s)) := by
  simp only [contraction, map_sum, map_mul, hf]

@[simp] theorem contraction_zero_left {σ : Type*} (κ : ι → ι → K)
    (B : ι → MvPolynomial σ K) : contraction κ (fun _ => 0) B = 0 := by
  simp [contraction]

@[simp] theorem contraction_zero_right {σ : Type*} (κ : ι → ι → K)
    (A : ι → MvPolynomial σ K) : contraction κ A (fun _ => 0) = 0 := by
  simp [contraction]

@[simp] theorem zeroAuxiliary_C (a : K) :
    zeroAuxiliary (C a) = (C a : CartesianPolynomial K) := by
  simp [zeroAuxiliary]

theorem kernelMatrix_zero_one (κ : ι → ι → K) (E : ι → MeanPolynomial K) :
    kernelMatrix κ E 0 1 = contraction κ
      (fun s => binaryMean 0 (pderiv 2 (E s)))
      (fun s => binaryMean 1 (pderiv 3 (E s))) := by
  unfold kernelMatrix kernel
  simp only [pderiv_contraction, pderiv_meanCopy, ite_true,
    show (1 : Fin 2) ≠ 0 by decide, show (0 : Fin 2) ≠ 1 by decide, ite_false,
    contraction_zero_left, contraction_zero_right, zero_add, add_zero]
  rw [map_contraction zeroAuxiliary zeroAuxiliary_C]
  simp only [zeroAuxiliary_meanCopy]

theorem kernelMatrix_one_one (κ : ι → ι → K) (E : ι → MeanPolynomial K) :
    kernelMatrix κ E 1 1 = contraction κ
      (fun s => binaryMean 0 (E s))
      (fun s => binaryMean 1 (pderiv 2 (pderiv 3 (E s)))) := by
  unfold kernelMatrix kernel
  simp only [pderiv_contraction, pderiv_meanCopy, ite_true,
    show (1 : Fin 2) ≠ 0 by decide, ite_false, contraction_zero_left, zero_add]
  rw [map_contraction zeroAuxiliary zeroAuxiliary_C]
  simp only [zeroAuxiliary_meanCopy]

theorem scalarKernel_eq (κ : ι → ι → K) (E : ι → MeanPolynomial K) :
    scalarKernel κ E = contraction κ (fun s => binaryMean 0 (E s))
      (fun s => binaryMean 1 (E s)) := by
  simp only [scalarKernel, kernel, contraction, map_sum, map_mul,
    zeroAuxiliary_meanCopy]
  simp [zeroAuxiliary]

theorem contraction_add_left {σ : Type*} (κ : ι → ι → K)
    (A B D : ι → MvPolynomial σ K) :
    contraction κ (fun s => A s + B s) D =
      contraction κ A D + contraction κ B D := by
  simp [contraction, add_mul, mul_add, Finset.sum_add_distrib]

theorem contraction_add_right {σ : Type*} (κ : ι → ι → K)
    (A B D : ι → MvPolynomial σ K) :
    contraction κ A (fun s => B s + D s) =
      contraction κ A B + contraction κ A D := by
  simp [contraction, mul_add, Finset.sum_add_distrib]

theorem contraction_mul_left {σ : Type*} (κ : ι → ι → K)
    (A B : ι → MvPolynomial σ K) (c : MvPolynomial σ K) :
    contraction κ (fun s => c * A s) B = c * contraction κ A B := by
  simp only [contraction, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro s _
  apply Finset.sum_congr rfl
  intro t _
  ring

theorem contraction_mul_right {σ : Type*} (κ : ι → ι → K)
    (A B : ι → MvPolynomial σ K) (c : MvPolynomial σ K) :
    contraction κ A (fun s => c * B s) = c * contraction κ A B := by
  simp only [contraction, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro s _
  apply Finset.sum_congr rfl
  intro t _
  ring

theorem correctedMatrix_zero_one (κ : ι → ι → K)
    (E : ι → MeanPolynomial K) (e : K) :
    correctedMatrix κ E e 0 1 = kernelMatrix κ E 0 1 := by
  simp [correctedMatrix]

theorem correctedMatrix_one_one (κ : ι → ι → K)
    (E : ι → MeanPolynomial K) (e : K) :
    correctedMatrix κ E e 1 1 = contraction κ
      (fun s => binaryMean 0 (E s))
      (fun s => binaryMean 1 (pderiv 2 (pderiv 3 (E s)) + C e * E s)) := by
  simp only [correctedMatrix, Matrix.add_apply, Matrix.smul_apply,
    Matrix.one_apply_eq, smul_eq_mul, mul_one, kernelMatrix_one_one,
    scalarKernel_eq, map_add, map_mul]
  have hc : binaryMean (K := K) 1 (C e) = C e := by simp [binaryMean]
  rw [hc, contraction_add_right, contraction_mul_right]

end Construction

noncomputable section Covariance

variable {K : Type*} [Field K]

def replicaFrameAssignment (O : Matrix (Fin 2) (Fin 2) K)
    (ji : Fin 4 × Fin 2) : ReplicaPolynomial K :=
  ∑ k : Fin 2, C (O ji.2 k) * X (ji.1, k)

def replicaFramePullback (O : Matrix (Fin 2) (Fin 2) K) :
    ReplicaPolynomial K →+* ReplicaPolynomial K :=
  eval₂Hom C (replicaFrameAssignment O)

def KernelInvariant (g : ReplicaPolynomial K) : Prop :=
  ∀ O : Matrix (Fin 2) (Fin 2) K, Oᵀ * O = 1 → replicaFramePullback O g = g

def auxiliaryMatrix (g : ReplicaPolynomial K) :
    Matrix (Fin 2) (Fin 2) (CartesianPolynomial K) :=
  fun i j => zeroAuxiliary (pderiv (2, i) (pderiv (3, j) g))

def matrixFramePullback (O : Matrix (Fin 2) (Fin 2) K)
    (M : Matrix (Fin 2) (Fin 2) (CartesianPolynomial K)) :
    Matrix (Fin 2) (Fin 2) (CartesianPolynomial K) :=
  fun i j => framePullback O (M i j)

theorem pderiv_replicaFrameAssignment (O : Matrix (Fin 2) (Fin 2) K)
    (r s : Fin 4) (k i : Fin 2) :
    pderiv (r, k) (replicaFrameAssignment O (s, i)) =
      if s = r then C (O i k) else 0 := by
  classical
  by_cases hs : s = r
  · subst s
    fin_cases k <;>
      simp [replicaFrameAssignment, Fin.sum_univ_two, pderiv_X]
  · simp [replicaFrameAssignment, pderiv_X, Prod.mk.injEq, hs]

theorem pderiv_replicaFramePullback (O : Matrix (Fin 2) (Fin 2) K)
    (r : Fin 4) (k : Fin 2) (g : ReplicaPolynomial K) :
    pderiv (r, k) (replicaFramePullback O g) =
      ∑ i : Fin 2, C (O i k) * replicaFramePullback O (pderiv (r, i) g) := by
  classical
  rw [replicaFramePullback, pderiv_substitution]
  simp only [Fintype.sum_prod_type, pderiv_replicaFrameAssignment]
  rw [Finset.sum_comm]
  simp only [mul_ite, mul_zero, Finset.sum_ite_eq', Finset.mem_univ, ite_true]
  apply Finset.sum_congr rfl
  intro i _
  rw [mul_comm]

theorem zeroAuxiliary_replicaFramePullback (O : Matrix (Fin 2) (Fin 2) K)
    (g : ReplicaPolynomial K) :
    zeroAuxiliary (replicaFramePullback O g) =
      framePullback O (zeroAuxiliary g) := by
  have hh : zeroAuxiliary.comp (replicaFramePullback (K := K) O) =
      (framePullback O).comp zeroAuxiliary := by
    apply MvPolynomial.ringHom_ext
    · intro a
      simp [zeroAuxiliary, replicaFramePullback, framePullback]
    · intro ji
      rcases ji with ⟨r, i⟩
      fin_cases r <;> fin_cases i <;>
        simp [zeroAuxiliary, replicaFramePullback, replicaFrameAssignment,
          framePullback, parameterP, parameterQ, columnAssignment,
          Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  exact DFunLike.congr_fun hh g

theorem auxiliaryMatrix_framePullback (O : Matrix (Fin 2) (Fin 2) K)
    (g : ReplicaPolynomial K) :
    auxiliaryMatrix (replicaFramePullback O g) =
      (O.map (C : K →+* CartesianPolynomial K))ᵀ *
        matrixFramePullback O (auxiliaryMatrix g) *
        O.map (C : K →+* CartesianPolynomial K) := by
  apply Matrix.ext
  intro i j
  simp only [auxiliaryMatrix, pderiv_replicaFramePullback, map_sum,
    pderiv_mul, pderiv_C, zero_mul, zero_add, map_mul,
    zeroAuxiliary_C, zeroAuxiliary_replicaFramePullback]
  simp only [matrixFramePullback, auxiliaryMatrix, Matrix.mul_apply, Matrix.transpose_apply, Matrix.map_apply,
    Fin.sum_univ_two]
  ring

theorem auxiliaryMatrix_covariant {g : ReplicaPolynomial K}
    (hg : KernelInvariant g) : OrthogonalCovariant (auxiliaryMatrix g) := by
  intro O P Q ho
  have hm := auxiliaryMatrix_framePullback O g
  rw [hg O ho] at hm
  have hoo : O * Oᵀ = 1 := mul_eq_one_comm.mp ho
  have hooC : O.map (C : K →+* CartesianPolynomial K) * (O.map (C : K →+* CartesianPolynomial K))ᵀ = 1 := by
    apply Matrix.ext
    intro i j
    have hij := congrArg (fun A : Matrix (Fin 2) (Fin 2) K => (C (A i j) : CartesianPolynomial K)) hoo
    simpa [Matrix.mul_apply, Matrix.transpose_apply, Matrix.map_apply,
      Matrix.one_apply, apply_ite, Fin.sum_univ_two] using hij
  have hconj : O.map (C : K →+* CartesianPolynomial K) * auxiliaryMatrix g * (O.map (C : K →+* CartesianPolynomial K))ᵀ =
      matrixFramePullback O (auxiliaryMatrix g) := by
    conv_lhs => rw [hm]
    simp only [Matrix.mul_assoc, hooC, Matrix.mul_one]
    rw [← Matrix.mul_assoc, hooC, Matrix.one_mul]
  apply Matrix.ext
  intro i j
  have hij := congrArg (fun A : Matrix (Fin 2) (Fin 2) (CartesianPolynomial K) =>
      MvPolynomial.eval (columnAssignment P Q) (A i j)) hconj.symm
  have hP : (![columnAssignment P Q 0, columnAssignment P Q 1] : Fin 2 → K) = P := by
    funext k
    fin_cases k <;> rfl
  have hQ : (![columnAssignment P Q 2, columnAssignment P Q 3] : Fin 2 → K) = Q := by
    funext k
    fin_cases k <;> rfl
  simpa [matrixFramePullback, evalAtColumns, eval_framePullback, hP, hQ,
    Matrix.mul_apply, Matrix.transpose_apply, Matrix.map_apply, Fin.sum_univ_two] using hij

theorem zeroAuxiliary_invariant {g : ReplicaPolynomial K}
    (hg : KernelInvariant g) : OrthogonalInvariant (zeroAuxiliary g) := by
  intro O ho
  rw [← zeroAuxiliary_replicaFramePullback, hg O ho]

theorem evalAtColumns_add
    (M N : Matrix (Fin 2) (Fin 2) (CartesianPolynomial K)) (P Q : Fin 2 → K) :
    evalAtColumns (M + N) P Q = evalAtColumns M P Q + evalAtColumns N P Q := by
  apply Matrix.ext
  intro i j
  simp [evalAtColumns]

theorem evalAtColumns_scalar (f : CartesianPolynomial K) (P Q : Fin 2 → K) :
    evalAtColumns (f • (1 : Matrix (Fin 2) (Fin 2) (CartesianPolynomial K))) P Q =
      MvPolynomial.eval (columnAssignment P Q) f • (1 : Matrix (Fin 2) (Fin 2) K) := by
  apply Matrix.ext
  intro i j
  by_cases hij : i = j
  · simp [evalAtColumns, hij]
  · simp [evalAtColumns, hij]

theorem covariant_add_scalar
    {M : Matrix (Fin 2) (Fin 2) (CartesianPolynomial K)} {f : CartesianPolynomial K}
    (hm : OrthogonalCovariant M) (hf : OrthogonalInvariant f) :
    OrthogonalCovariant (M + f • 1) := by
  intro O P Q ho
  have hoo : O * Oᵀ = 1 := mul_eq_one_comm.mp ho
  have hP : (![columnAssignment P Q 0, columnAssignment P Q 1] : Fin 2 → K) = P := by
    funext k
    fin_cases k <;> rfl
  have hQ : (![columnAssignment P Q 2, columnAssignment P Q 3] : Fin 2 → K) = Q := by
    funext k
    fin_cases k <;> rfl
  have hfeval := congrArg (MvPolynomial.eval (columnAssignment P Q)) (hf O ho)
  rw [eval_framePullback, hP, hQ] at hfeval
  rw [evalAtColumns_add, evalAtColumns_scalar, hm O P Q ho,
    evalAtColumns_add, evalAtColumns_scalar, hfeval]
  simp only [Matrix.mul_add, Matrix.add_mul, Matrix.mul_smul, Matrix.smul_mul,
    Matrix.mul_one, hoo]

variable {ι : Type*} [Fintype ι]

theorem correctedMatrix_covariant {κ : ι → ι → K} {E : ι → MeanPolynomial K} {e : K}
    (hg : KernelInvariant (kernel κ E)) : OrthogonalCovariant (correctedMatrix κ E e) := by
  apply covariant_add_scalar (auxiliaryMatrix_covariant hg)
  intro O ho
  have hf := zeroAuxiliary_invariant hg O ho
  change framePullback O (scalarKernel κ E) = scalarKernel κ E at hf
  change framePullback O (C e * scalarKernel κ E) = C e * scalarKernel κ E
  rw [map_mul, hf]
  simp [framePullback]

end Covariance

noncomputable section SourceBoundaries

variable {K ι : Type*} [Field K] [Fintype ι]

def meanXAxis : MeanPolynomial K →+* MeanPolynomial K :=
  eval₂Hom C ![X 0, 0, 0, 0]

def meanYAxis : MeanPolynomial K →+* MeanPolynomial K :=
  eval₂Hom C ![0, X 1, 0, 0]

def meanBinaryProjection : MeanPolynomial K →+* MeanPolynomial K :=
  eval₂Hom C ![X 0, X 1, 0, 0]

def zeroVariable (i : Fin 4) : MeanPolynomial K →+* MeanPolynomial K :=
  eval₂Hom C (fun j => if j = i then 0 else X j)

theorem X_dvd_sub_zeroVariable (i : Fin 4) (p : MeanPolynomial K) :
    X i ∣ p - zeroVariable i p := by
  classical
  induction p using MvPolynomial.induction_on with
  | C a => simp [zeroVariable]
  | add p q hp hq =>
    rw [map_add]
    convert dvd_add hp hq using 1; ring
  | mul_X p j hp =>
    rw [map_mul]
    by_cases hij : j = i
    · subst j
      simp [zeroVariable]
    · have hh := dvd_mul_of_dvd_left hp (X j)
      simpa [zeroVariable, hij, sub_mul] using hh

theorem X_dvd_of_zeroVariable_eq_zero (i : Fin 4) {p : MeanPolynomial K}
    (h : zeroVariable i p = 0) : X i ∣ p := by
  simpa only [h, sub_zero] using X_dvd_sub_zeroVariable i p

theorem zeroVariable_binaryProjection_zero (p : MeanPolynomial K) :
    zeroVariable 0 (meanBinaryProjection p) = meanYAxis p := by
  have hh : (zeroVariable (K := K) 0).comp meanBinaryProjection = meanYAxis := by
    apply MvPolynomial.ringHom_ext
    · intro a
      simp [zeroVariable, meanBinaryProjection, meanYAxis]
    · intro j
      fin_cases j <;> simp [zeroVariable, meanBinaryProjection, meanYAxis]
  exact DFunLike.congr_fun hh p

theorem zeroVariable_binaryProjection_one (p : MeanPolynomial K) :
    zeroVariable 1 (meanBinaryProjection p) = meanXAxis p := by
  have hh : (zeroVariable (K := K) 1).comp meanBinaryProjection = meanXAxis := by
    apply MvPolynomial.ringHom_ext
    · intro a
      simp [zeroVariable, meanBinaryProjection, meanXAxis]
    · intro j
      fin_cases j <;> simp [zeroVariable, meanBinaryProjection, meanXAxis]
  exact DFunLike.congr_fun hh p

theorem binaryMean_binaryProjection (i : Fin 2) (p : MeanPolynomial K) :
    binaryMean i (meanBinaryProjection p) = binaryMean i p := by
  have hh : (binaryMean (K := K) i).comp meanBinaryProjection = binaryMean i := by
    apply MvPolynomial.ringHom_ext
    · intro a
      simp [binaryMean, meanBinaryProjection]
    · intro j
      fin_cases j <;> simp [binaryMean, meanBinaryProjection]
  exact DFunLike.congr_fun hh p

theorem parameterP_dvd_binaryMean (i : Fin 2) {p : MeanPolynomial K}
    (h : meanYAxis p = 0) : parameterP i ∣ binaryMean i p := by
  have hz : zeroVariable 0 (meanBinaryProjection p) = 0 := by
    rw [zeroVariable_binaryProjection_zero, h]
  have hd := map_dvd (binaryMean (K := K) i) (X_dvd_of_zeroVariable_eq_zero 0 hz)
  rw [binaryMean_binaryProjection] at hd
  simpa [binaryMean] using hd

theorem parameterQ_dvd_binaryMean (i : Fin 2) {p : MeanPolynomial K}
    (h : meanXAxis p = 0) : parameterQ i ∣ binaryMean i p := by
  have hz : zeroVariable 1 (meanBinaryProjection p) = 0 := by
    rw [zeroVariable_binaryProjection_one, h]
  have hd := map_dvd (binaryMean (K := K) i) (X_dvd_of_zeroVariable_eq_zero 1 hz)
  rw [binaryMean_binaryProjection] at hd
  simpa [binaryMean] using hd

theorem mul_dvd_contraction {σ : Type*} (κ : ι → ι → K)
    (A B : ι → MvPolynomial σ K) {p q : MvPolynomial σ K}
    (hA : ∀ s, p ∣ A s) (hB : ∀ s, q ∣ B s) : p * q ∣ contraction κ A B := by
  unfold contraction
  apply Finset.dvd_sum
  intro s _
  apply Finset.dvd_sum
  intro t _
  simpa [mul_assoc, mul_comm, mul_left_comm] using
    dvd_mul_of_dvd_right (mul_dvd_mul (hA s) (hB t)) (C (κ s t))

theorem kernelMatrix_one_zero (κ : ι → ι → K) (E : ι → MeanPolynomial K) :
    kernelMatrix κ E 1 0 = contraction κ
      (fun s => binaryMean 0 (pderiv 3 (E s)))
      (fun s => binaryMean 1 (pderiv 2 (E s))) := by
  unfold kernelMatrix kernel
  simp only [pderiv_contraction, pderiv_meanCopy, ite_true,
    show (0 : Fin 2) ≠ 1 by decide, show (1 : Fin 2) ≠ 0 by decide, ite_false,
    contraction_zero_left, contraction_zero_right, zero_add, add_zero]
  rw [map_contraction zeroAuxiliary zeroAuxiliary_C]
  simp only [zeroAuxiliary_meanCopy]

theorem correctedMatrix_offDiagonal_divisibility
    (κ : ι → ι → K) (E : ι → MeanPolynomial K) (e : K)
    (hu : ∀ s, meanYAxis (pderiv 2 (E s)) = 0)
    (hv : ∀ s, meanXAxis (pderiv 3 (E s)) = 0) :
    parameterP (K := K) 0 * parameterQ (K := K) 1 ∣ correctedMatrix κ E e 0 1 ∧
      parameterP (K := K) 1 * parameterQ (K := K) 0 ∣ correctedMatrix κ E e 1 0 := by
  constructor
  · rw [correctedMatrix_zero_one, kernelMatrix_zero_one]
    exact mul_dvd_contraction κ _ _
      (fun s => parameterP_dvd_binaryMean 0 (hu s))
      (fun s => parameterQ_dvd_binaryMean 1 (hv s))
  · have hentry : correctedMatrix κ E e 1 0 = kernelMatrix κ E 1 0 := by
      simp [correctedMatrix]
    rw [hentry, kernelMatrix_one_zero, mul_comm]
    exact mul_dvd_contraction κ _ _
      (fun s => parameterQ_dvd_binaryMean 0 (hv s))
      (fun s => parameterP_dvd_binaryMean 1 (hu s))

theorem pderiv_binaryMean_zero (p : MeanPolynomial K) :
    pderiv 2 (binaryMean 0 p) = binaryMean 0 (pderiv 1 p) := by
  induction p using MvPolynomial.induction_on with
  | C a => simp [binaryMean]
  | add p q hp hq => simp only [map_add, hp, hq]
  | mul_X p j hp =>
    simp only [map_mul, pderiv_mul, map_add, hp]
    fin_cases j <;> simp [binaryMean, parameterP, parameterQ, pderiv_X]

theorem pderiv_binaryMean_one (p : MeanPolynomial K) :
    pderiv 2 (binaryMean 1 p) = 0 := by
  induction p using MvPolynomial.induction_on with
  | C a => simp [binaryMean]
  | add p q hp hq => simp only [map_add, hp, hq, add_zero]
  | mul_X p j hp =>
    simp only [map_mul, pderiv_mul, hp, zero_mul, zero_add]
    fin_cases j <;> simp [binaryMean, parameterP, parameterQ, pderiv_X]

theorem axisRestriction_binaryMean_zero_Xaxis (p : MeanPolynomial K) :
    axisRestriction (binaryMean 0 (meanXAxis p)) = axisRestriction (binaryMean 0 p) := by
  have hh : (axisRestriction (K := K)).comp ((binaryMean 0).comp meanXAxis) =
      axisRestriction.comp (binaryMean 0) := by
    apply MvPolynomial.ringHom_ext
    · intro a
      simp [axisRestriction, binaryMean, meanXAxis]
    · intro j
      fin_cases j <;> simp [axisRestriction, binaryMean, meanXAxis, parameterP, parameterQ]
  exact DFunLike.congr_fun hh p

def scalarContraction (κ : ι → ι → K) (A B : ι → K) : K :=
  ∑ s : ι, ∑ t : ι, κ s t * A s * B t

theorem eval_contraction {σ : Type*} (κ : ι → ι → K)
    (A B : ι → MvPolynomial σ K) (z : σ → K) :
    MvPolynomial.eval z (contraction κ A B) =
      scalarContraction κ (fun s => MvPolynomial.eval z (A s))
        (fun s => MvPolynomial.eval z (B s)) := by
  simp [contraction, scalarContraction]

theorem eval_zero_binaryMean (i : Fin 2) (p : MeanPolynomial K) :
    MvPolynomial.eval (0 : Fin 4 → K) (binaryMean i p) =
      MvPolynomial.eval (0 : Fin 4 → K) p := by
  change MvPolynomial.eval (0 : Fin 4 → K) (eval₂ C _ p) = _
  rw [← MvPolynomial.eval_assoc]
  have hh : MvPolynomial.eval (0 : Fin 4 → K) ∘
      ![parameterP (K := K) i, parameterQ (K := K) i, 0, 0] =
      (0 : Fin 4 → K) := by
    funext j
    fin_cases j <;> fin_cases i <;> simp [parameterP, parameterQ]
  rw [hh]

theorem correctedMatrix_origin (κ : ι → ι → K)
    (E : ι → MeanPolynomial K) (e : K) :
    MvPolynomial.eval (0 : Fin 4 → K) (correctedMatrix κ E e 1 1) =
      scalarContraction κ (fun s => MvPolynomial.eval (0 : Fin 4 → K) (E s))
        (fun s => MvPolynomial.eval (0 : Fin 4 → K)
          (pderiv 2 (pderiv 3 (E s)) + C e * E s)) := by
  rw [correctedMatrix_one_one, eval_contraction]
  simp only [eval_zero_binaryMean]

@[simp] theorem binaryMean_C (i : Fin 2) (a : K) :
    binaryMean i (C a) = (C a : CartesianPolynomial K) := by simp [binaryMean]

@[simp] theorem binaryMean_X (i : Fin 2) (j : Fin 4) :
    binaryMean i (X j) =
      (![parameterP i, parameterQ i, 0, 0] j : CartesianPolynomial K) := by
  simp [binaryMean]

theorem axis_drift_of_mean_identity (p rhs : MeanPolynomial K) (d : K)
    (h : meanXAxis (pderiv 1 p + C d * X 0 * p) = rhs) :
    axisRestriction (binaryMean 0 (pderiv 1 p) + C d * X 0 * binaryMean 0 p) =
      axisRestriction (binaryMean 0 rhs) := by
  have hh := congrArg (fun a : MeanPolynomial K => axisRestriction (binaryMean 0 a)) h
  rw [axisRestriction_binaryMean_zero_Xaxis] at hh
  simpa only [map_add, map_mul, binaryMean_C, binaryMean_X, parameterP,
    Matrix.cons_val_zero] using hh

theorem drift_contraction (κ : ι → ι → K)
    (A B : ι → CartesianPolynomial K) (c : CartesianPolynomial K)
    (hB : ∀ s, pderiv 2 (B s) = 0) :
    pderiv 2 (contraction κ A B) + c * contraction κ A B =
      contraction κ (fun s => pderiv 2 (A s) + c * A s) B := by
  rw [pderiv_contraction]
  simp only [hB, contraction_zero_right, add_zero]
  rw [contraction_add_left, contraction_mul_left]

theorem correctedMatrix_offDiagonalBoundary (κ : ι → ι → K)
    (E : ι → MeanPolynomial K) (d e : K)
    (hsource : ∀ s, meanXAxis
      (pderiv 1 (pderiv 2 (E s)) + C d * X 0 * pderiv 2 (E s)) = 0) :
    MatrixOffDiagonalBoundary (correctedMatrix κ E e) d := by
  unfold MatrixOffDiagonalBoundary
  rw [correctedMatrix_zero_one, kernelMatrix_zero_one]
  rw [drift_contraction κ _ _ (C d * X 0)
    (fun s => pderiv_binaryMean_one (pderiv 3 (E s)))]
  rw [map_contraction axisRestriction axisRestriction_C]
  have hh : ∀ s, axisRestriction
      (pderiv 2 (binaryMean 0 (pderiv 2 (E s))) +
        C d * X 0 * binaryMean 0 (pderiv 2 (E s))) = 0 := by
    intro s
    rw [pderiv_binaryMean_zero]
    simpa only [map_zero] using axis_drift_of_mean_identity (pderiv 2 (E s)) 0 d
      (hsource s)
  simp only [hh, contraction_zero_left]

theorem correctedMatrix_scalarBoundary (κ : ι → ι → K)
    (E : ι → MeanPolynomial K) (b : ι → K) (d e β η : K)
    (hsource : ∀ s, meanXAxis (pderiv 1 (E s) + C d * X 0 * E s) =
      X 0 * C β * C (b s))
    (hcap : contraction κ (fun s => C (b s))
      (fun s => binaryMean 1 (pderiv 2 (pderiv 3 (E s)) + C e * E s)) = C η) :
    MatrixScalarBoundary (correctedMatrix κ E e) d (β * η) := by
  unfold MatrixScalarBoundary
  rw [correctedMatrix_one_one]
  rw [drift_contraction κ _ _ (C d * X 0)
    (fun s => pderiv_binaryMean_one
      (pderiv 2 (pderiv 3 (E s)) + C e * E s))]
  rw [map_sub, map_contraction axisRestriction axisRestriction_C]
  have hh : ∀ s, axisRestriction
      (pderiv 2 (binaryMean 0 (E s)) + C d * X 0 * binaryMean 0 (E s)) =
      X 0 * C β * C (b s) := by
    intro s
    rw [pderiv_binaryMean_zero]
    have hs := axis_drift_of_mean_identity (E s) (X 0 * C β * C (b s)) d (hsource s)
    simpa only [map_mul, binaryMean_X, binaryMean_C, parameterP,
      Matrix.cons_val_zero, axisRestriction_X, axisRestriction_C] using hs
  simp only [hh]
  rw [contraction_mul_left]
  have hcapAxis := congrArg axisRestriction hcap
  rw [map_contraction axisRestriction axisRestriction_C] at hcapAxis
  simp only [axisRestriction_C] at hcapAxis
  rw [hcapAxis]
  simp only [map_mul, axisRestriction_C, axisRestriction_X, Matrix.cons_val_zero]
  ring

variable [IsAlgClosed K] [CharZero K]

theorem endpoint_of_tensor_kernel
    (κ : ι → ι → K) (E : ι → MeanPolynomial K) (b : ι → K) {d e β η α : K}
    (hd : d ≠ 0) (hη : η ≠ 0)
    (hcov : KernelInvariant (kernel κ E))
    (hu : ∀ s, meanYAxis (pderiv 2 (E s)) = 0)
    (hv : ∀ s, meanXAxis (pderiv 3 (E s)) = 0)
    (hmixed : ∀ s, meanXAxis
      (pderiv 1 (pderiv 2 (E s)) + C d * X 0 * pderiv 2 (E s)) = 0)
    (hsource : ∀ s, meanXAxis (pderiv 1 (E s) + C d * X 0 * E s) =
      X 0 * C β * C (b s))
    (hcap : contraction κ (fun s => C (b s))
      (fun s => binaryMean 1 (pderiv 2 (pderiv 3 (E s)) + C e * E s)) = C η)
    (horigin : scalarContraction κ
      (fun s => MvPolynomial.eval (0 : Fin 4 → K) (E s))
      (fun s => MvPolynomial.eval (0 : Fin 4 → K)
        (pderiv 2 (pderiv 3 (E s)) + C e * E s)) = η * α) : β = d * α := by
  obtain ⟨h₀₁, h₁₀⟩ := correctedMatrix_offDiagonal_divisibility κ E e hu hv
  exact endpoint_of_covariant_matrix_boundaries hd hη (correctedMatrix_covariant hcov)
    h₀₁ h₁₀ (correctedMatrix_offDiagonalBoundary κ E d e hmixed)
    (correctedMatrix_scalarBoundary κ E b d e β η hsource hcap)
    ((correctedMatrix_origin κ E e).trans horigin)

end SourceBoundaries

end Krenn.ReplicaKernel

-- formal/all-orders/CofactorDiagonal.lean

namespace Krenn.CofactorDiagonal

open MatchingModel SiteAlgebra
open scoped BigOperators

variable {R V C : Type*} [CommRing R] [Fintype V] [DecidableEq V]

theorem block_eq_zero_of_cofactor_identity
    (A B Q : Matrix V V R) (hAQ : A * Q = 1) (hBQ : B * Q = 0) : B = 0 := by
  have hQA : Q * A = 1 := mul_eq_one_comm.mp hAQ
  calc
    B = B * (Q * A) := by rw [hQA, mul_one]
    _ = (B * Q) * A := (mul_assoc B Q A).symm
    _ = 0 := by rw [hBQ, zero_mul]

theorem offDiagonal_eq_zero (B : C → C → Matrix V V R) (Q : C → Matrix V V R)
    (hdiag : ∀ h, B h h * Q h = 1)
    (hmixed : ∀ i h, i ≠ h → B i h * Q h = 0) {i h : C} (hih : i ≠ h) :
    B i h = 0 :=
  block_eq_zero_of_cofactor_identity (B h h) (B i h) (Q h) (hdiag h) (hmixed i h hih)

variable {N D : ℕ}

noncomputable def sourceBlock (W : WeightsN N D R) (i h : Fin D) :
    Matrix (Fin N) (Fin N) R := fun p q => edgeMatrix W (p, i) (q, h)

theorem source_diagonal_of_cofactor_sums (W : WeightsN N D R)
    (Q : Fin D → Matrix (Fin N) (Fin N) R)
    (hpure : ∀ h p q, ∑ r, edgeMatrix W (p, h) (r, h) * Q h r q =
      if p = q then 1 else 0)
    (hmixed : ∀ i h, i ≠ h → ∀ p q,
      ∑ r, edgeMatrix W (p, i) (r, h) * Q h r q = 0) :
    ∀ p q i h, i ≠ h → edgeMatrix W (p, i) (q, h) = 0 := by
  have hd : ∀ h, sourceBlock W h h * Q h = 1 := by
    intro h
    ext p q
    exact hpure h p q
  have hm : ∀ i h, i ≠ h → sourceBlock W i h * Q h = 0 := by
    intro i h hih
    ext p q
    exact hmixed i h hih p q
  intro p q i h hih
  exact congrFun (congrFun (offDiagonal_eq_zero (sourceBlock W) Q hd hm hih) p) q

end Krenn.CofactorDiagonal

-- formal/all-orders/CofactorResponse.lean

namespace Krenn.CofactorResponse

open MatchingModel SiteAlgebra RootResponse
open scoped BigOperators

variable {R : Type*} [Field R] [CharZero R] {N D : ℕ}

omit [CharZero R] in

theorem coeff_eraseSite_of_omitted (p : V N) (P : MatchingPolynomial N D R)
    (m : SiteVariable N D →₀ ℕ) (hm : ∀ i, m (p, i) = 0) :
    MvPolynomial.coeff m (eraseSite p P) = MvPolynomial.coeff m P := by
  classical
  induction P using MvPolynomial.induction_on generalizing m with
  | C a => rw [eraseSite_C]
  | add P Q hP hQ =>
    rw [map_add, MvPolynomial.coeff_add, MvPolynomial.coeff_add, hP _ hm, hQ _ hm]
  | mul_X P z hP =>
    rw [map_mul, eraseSite_X]
    by_cases hz : z.1 = p
    · have hmz : m z = 0 := by simpa only [← hz] using hm z.2
      simp only [if_pos hz, mul_zero, MvPolynomial.coeff_zero,
        MvPolynomial.coeff_mul_X', Finsupp.mem_support_iff, hmz, ne_eq,
        not_true_eq_false, if_false]
    · rw [if_neg hz, MvPolynomial.coeff_mul_X', MvPolynomial.coeff_mul_X']
      congr 1
      apply hP
      intro i
      simp only [Finsupp.tsub_apply, hm, Nat.zero_sub]

omit [CharZero R] in
theorem coeff_word_eraseSite (p : V N) (P : MatchingPolynomial N D R)
    (ι : V N → Fin D) (L : List (V N)) (hp : p ∉ L) :
    MvPolynomial.coeff (wordExponent ι L) (eraseSite p P) =
      MvPolynomial.coeff (wordExponent ι L) P :=
  coeff_eraseSite_of_omitted p P _ (wordExponent_not_mem ι L p hp)

theorem coeff_dividedSourcePower_list (W : WeightsN N D R) (ι : V N → Fin D)
    (k : ℕ) (L : List (V N)) (hlen : L.length = 2 * k) (hL : L.Pairwise (· < ·)) :
    MvPolynomial.coeff (wordExponent ι L) (dividedSourcePower W k) =
      pmSumList W ι L := by
  rw [dividedSourcePower, MvPolynomial.coeff_C_mul,
    coeff_sourceQuadratic_pow W ι k L hlen hL, pmSumList, hlen]
  rw [← mul_assoc, inv_mul_cancel₀ (Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero k)), one_mul]

theorem pmSumList_rootExpansion (W : WeightsN N D R) (ι : V N → Fin D)
    (k : ℕ) (S : List (V N)) (hlenS : S.length = 2 * (k + 1))
    (hS : S.Pairwise (· < ·)) (p : V N) (hpS : p ∈ S) :
    pmSumList W ι S = ((S.erase p).map fun q =>
      edgeMatrix W (p, ι p) (q, ι q) * pmSumList W ι ((S.erase p).erase q)).sum := by
  have hSnodup : S.Nodup := hS.imp (fun h => ne_of_lt h)
  let L := S.erase p
  have hnodup : L.Nodup := hSnodup.erase p
  have hp : p ∉ L := hSnodup.not_mem_erase
  have hlen : L.length = 2 * k + 1 := by
    dsimp [L]
    rw [List.length_erase_of_mem hpS, hlenS]
    omega
  have hex : wordExponent ι (p :: L) = wordExponent ι S :=
    (wordExponent_erase ι S p hpS).symm
  have hrec := coeff_sourceQuadratic_pow_succ W ι k p L hp hnodup
  rw [hex, coeff_sourceQuadratic_pow W ι (k + 1) S hlenS hS] at hrec
  have hterm : (L.map fun q => edgeMatrix W (p, ι p) (q, ι q) *
      MvPolynomial.coeff (wordExponent ι (L.erase q)) (sourceQuadratic W ^ k)).sum =
      (k.factorial : R) * (L.map fun q => edgeMatrix W (p, ι p) (q, ι q) *
        pmSumList W ι (L.erase q)).sum := by
    rw [← List.sum_map_mul_left]
    congr 1
    apply List.map_congr_left
    intro q hq
    have hlq : (L.erase q).length = 2 * k := by
      rw [List.length_erase_of_mem hq, hlen]
      omega
    rw [coeff_sourceQuadratic_pow W ι k (L.erase q) hlq
      (List.Pairwise.erase q (List.Pairwise.erase p hS))]
    rw [pmSumList, hlq]
    ring
  rw [hterm] at hrec
  have hfac : ((k + 1).factorial : R) = (k + 1 : R) * (k.factorial : R) := by
    rw [Nat.factorial_succ, Nat.cast_mul, Nat.cast_add, Nat.cast_one]
  have hf : ((k + 1).factorial : R) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero _)
  apply mul_left_cancel₀ hf
  rw [pmSumList, hlenS]
  calc
    _ = (k + 1 : R) * ((k.factorial : R) *
      (L.map fun q => edgeMatrix W (p, ι p) (q, ι q) * pmSumList W ι (L.erase q)).sum) := hrec
    _ = _ := by rw [hfac]; ring

theorem coeff_two_rows_dividedPower (W : WeightsN N D R) (ι : V N → Fin D)
    (z t : SiteVariable N D) (k : ℕ) (L : List (V N))
    (hlen : L.length = 2 * (k + 1)) (hL : L.Pairwise (· < ·)) :
    MvPolynomial.coeff (wordExponent ι L)
      (rowPolynomial (edgeMatrix W) z * rowPolynomial (edgeMatrix W) t *
        dividedSourcePower W k) =
      (L.map fun r => edgeMatrix W z (r, ι r) *
        ((L.erase r).map fun s => edgeMatrix W t (s, ι s) *
          pmSumList W ι ((L.erase r).erase s)).sum).sum := by
  have hn : L.Nodup := hL.imp (fun h => ne_of_lt h)
  rw [mul_assoc, coeff_rowPolynomial_mul _ _ _ _ hn]
  congr 1
  apply List.map_congr_left
  intro r hr
  rw [coeff_rowPolynomial_mul _ _ _ _ (hn.erase r)]
  congr 1
  congr 1
  apply List.map_congr_left
  intro s hs
  have hlen' : ((L.erase r).erase s).length = 2 * k := by
    rw [List.length_erase_of_mem hs, List.length_erase_of_mem hr, hlen]
    omega
  rw [coeff_dividedSourcePower_list W ι k _ hlen' ((hL.erase r).erase s)]

def retainedVertices (p q : V N) : List (V N) := ((vertices N).erase p).erase q

theorem mem_retainedVertices (p q r : V N) :
    r ∈ retainedVertices p q ↔ r ≠ p ∧ r ≠ q := by
  constructor
  · intro hr
    constructor
    · intro h
      subst r
      exact (vertices_nodup N).not_mem_erase (List.mem_of_mem_erase hr)
    · intro h
      subst r
      exact ((vertices_nodup N).erase p).not_mem_erase hr
  · rintro ⟨hrp, hrq⟩
    exact (List.mem_erase_of_ne hrq).mpr
      ((List.mem_erase_of_ne hrp).mpr (mem_vertices r))

theorem retainedVertices_length (p q : V N) (hpq : p ≠ q) :
    (retainedVertices p q).length = N - 2 := by
  rw [retainedVertices, List.length_erase_of_mem
    ((List.mem_erase_of_ne hpq.symm).mpr (mem_vertices q)),
    List.length_erase_of_mem (mem_vertices p), vertices_eq_finRange]
  simp
  omega

theorem retainedVertices_nodup (p q : V N) : (retainedVertices p q).Nodup :=
  ((vertices_nodup N).erase p).erase q

theorem retainedVertices_sorted (p q : V N) : (retainedVertices p q).Pairwise (· < ·) :=
  ((vertices_pairwise_lt N).erase p).erase q

theorem pureCofactor_retained_rootExpansion (k : ℕ) (W : WeightsN (2 * (k + 2)) D R)
    (h : Fin D) (p q r : V (2 * (k + 2)))
    (hpq : p ≠ q) (hrp : r ≠ p) (hrq : r ≠ q) :
    pureCofactor W h r q =
      (((retainedVertices p q).erase r).map fun s => edgeMatrix W (p, h) (s, h) *
        pmSumList W (fun _ => h) (((retainedVertices p q).erase r).erase s)).sum := by
  rw [pureCofactor, if_neg hrq]
  change pmSumList W (fun _ => h) (retainedVertices r q) = _
  have hlen : (retainedVertices r q).length = 2 * (k + 1) := by
    rw [retainedVertices_length r q hrq]
    omega
  have hp : p ∈ retainedVertices r q := (mem_retainedVertices r q p).mpr ⟨hrp.symm, hpq⟩
  rw [pmSumList_rootExpansion W (fun _ => h) k (retainedVertices r q) hlen
    (retainedVertices_sorted r q) p hp]
  have heq : (retainedVertices r q).erase p = (retainedVertices p q).erase r := by
    unfold retainedVertices
    rw [List.erase_comm q p, List.erase_comm r p, List.erase_comm r q]
  rw [heq]

theorem cofactorSum_eq_two_row_coefficient (k : ℕ) (W : WeightsN (2 * (k + 2)) D R)
    (i h : Fin D) (p q : V (2 * (k + 2))) (hpq : p ≠ q) :
    (∑ r, edgeMatrix W (p, i) (r, h) * pureCofactor W h r q) =
      MvPolynomial.coeff (wordExponent (fun _ => h) (retainedVertices p q))
        (rowPolynomial (edgeMatrix W) (p, i) * rowPolynomial (edgeMatrix W) (p, h) *
          dividedSourcePower W k) := by
  classical
  have hlen : (retainedVertices p q).length = 2 * (k + 1) := by
    rw [retainedVertices_length p q hpq]
    omega
  rw [coeff_two_rows_dividedPower W (fun _ => h) (p, i) (p, h) k
    (retainedVertices p q) hlen (retainedVertices_sorted p q)]
  have hrestrict :
      (∑ r, edgeMatrix W (p, i) (r, h) * pureCofactor W h r q) =
      ((retainedVertices p q).map fun r =>
        edgeMatrix W (p, i) (r, h) * pureCofactor W h r q).sum := by
    rw [← List.sum_toFinset _ (retainedVertices_nodup p q)]
    symm
    apply Finset.sum_subset (Finset.subset_univ _)
    intro r _ hr
    by_cases hrp : r = p
    · subst r
      rw [edgeMatrix_same_site, zero_mul]
    by_cases hrq : r = q
    · subst r
      rw [pureCofactor_self, mul_zero]
    exact False.elim (hr (List.mem_toFinset.mpr ((mem_retainedVertices p q r).mpr ⟨hrp, hrq⟩)))
  rw [hrestrict]
  congr 1
  apply List.map_congr_left
  intro r hr
  obtain ⟨hrp, hrq⟩ := (mem_retainedVertices p q r).mp hr
  rw [pureCofactor_retained_rootExpansion k W h p q r hpq hrp hrq]

omit [CharZero R] in

theorem pmSumListAux_congr_word (W : WeightsN N D R) (ι κ : V N → Fin D) :
    ∀ n L, (∀ v ∈ L, ι v = κ v) → pmSumListAux W ι n L = pmSumListAux W κ n L
  | 0, _, _ => rfl
  | 1, _, _ => rfl
  | _ + 2, [], _ => rfl
  | _ + 2, [_], _ => rfl
  | n + 2, v :: u :: L, h => by
    simp only [pmSumListAux]
    congr 1
    apply List.map_congr_left
    intro r hr
    rw [h v (by simp), h r (List.mem_cons.mpr (Or.inr hr))]
    rw [pmSumListAux_congr_word W ι κ n ((u :: L).erase r)
      (fun x hx => h x (List.mem_cons.mpr (Or.inr (List.mem_of_mem_erase hx))))]

def oneDefectWord (p : V N) (i h : Fin D) : V N → Fin D :=
  fun v => if v = p then i else h

theorem allEqual_oneDefect_iff (hN : 2 ≤ N) (p : V N) (i h : Fin D) :
    allEqual (oneDefectWord p i h) ↔ i = h := by
  have : Nontrivial (Fin N) := by
    refine ⟨⟨⟨0, by omega⟩, ⟨1, by omega⟩, ?_⟩⟩
    intro heq
    have := congrArg Fin.val heq
    simp at this
  obtain ⟨q, hqp⟩ := exists_ne p
  rw [allEqual_iff_constant_at _ p]
  constructor
  · intro hw
    have hq := congrFun hw q
    simpa [oneDefectWord, hqp] using hq.symm
  · intro hi
    subst i
    funext v
    simp [oneDefectWord]

theorem cofactorSum_same_root (k : ℕ) (W : WeightsN (2 * (k + 2)) D R)
    (hW : EqSystemN (2 * (k + 2)) D W)
    (p : V (2 * (k + 2))) (i h : Fin D) :
    (∑ r, edgeMatrix W (p, i) (r, h) * pureCofactor W h r p) =
      if i = h then 1 else 0 := by
  classical
  let word := oneDefectWord p i h
  have hEq := hW word
  rw [pmSumN_rootExpansion (k + 1) W word p] at hEq
  have heq :
      (((vertices (2 * (k + 2))).erase p).map fun r =>
        edgeMatrix W (p, word p) (r, word r) *
          pmSumList W word (((vertices (2 * (k + 2))).erase p).erase r)).sum =
      ∑ r, edgeMatrix W (p, i) (r, h) * pureCofactor W h r p := by
    let L := (vertices (2 * (k + 2))).erase p
    have hn : L.Nodup := (vertices_nodup _).erase p
    rw [← List.sum_toFinset _ hn]
    calc
      _ = ∑ r ∈ L.toFinset, edgeMatrix W (p, i) (r, h) * pureCofactor W h r p := by
        apply Finset.sum_congr rfl
        intro r hr
        have hrp : r ≠ p := by
          intro hrp
          subst r
          exact (vertices_nodup _).not_mem_erase (List.mem_toFinset.mp hr)
        simp only [word, oneDefectWord, if_neg hrp]
        rw [pureCofactor_symm W h r p, pureCofactor, if_neg hrp.symm]
        congr 1
        apply pmSumListAux_congr_word
        intro v hv
        have hvp : v ≠ p := by
          intro hvp
          subst v
          exact (vertices_nodup _).not_mem_erase (List.mem_of_mem_erase hv)
        simp [oneDefectWord, hvp]
      _ = _ := by
        apply Finset.sum_subset (Finset.subset_univ _)
        intro r _ hr
        have hrp : r = p := by
          by_contra h
          exact hr (List.mem_toFinset.mpr ((List.mem_erase_of_ne h).mpr (mem_vertices r)))
        subst r
        rw [edgeMatrix_same_site, zero_mul]
  rw [heq] at hEq
  simpa only [word, allEqual_oneDefect_iff (N := 2 * (k + 2)) (by omega)] using hEq

theorem source_diagonal_of_two_row_vanishing (k : ℕ)
    (W : WeightsN (2 * (k + 2)) D R) (hW : EqSystemN (2 * (k + 2)) D W)
    (hvanish : ∀ p q, p ≠ q → ∀ i h,
      MvPolynomial.coeff (wordExponent (fun _ => h) (retainedVertices p q))
        (rowPolynomial (edgeMatrix W) (p, i) * rowPolynomial (edgeMatrix W) (p, h) *
          dividedSourcePower W k) = 0) :
    ∀ p q i h, i ≠ h → edgeMatrix W (p, i) (q, h) = 0 := by
  apply CofactorDiagonal.source_diagonal_of_cofactor_sums W (pureCofactor W)
  · intro h p q
    by_cases hpq : p = q
    · subst q
      simpa only [if_pos rfl] using cofactorSum_same_root k W hW p h h
    · rw [if_neg hpq, cofactorSum_eq_two_row_coefficient k W h h p q hpq]
      exact hvanish p q hpq h h
  · intro i h hih p q
    by_cases hpq : p = q
    · subst q
      simpa only [if_neg hih] using cofactorSum_same_root k W hW p i h
    · rw [cofactorSum_eq_two_row_coefficient k W i h p q hpq]
      exact hvanish p q hpq i h

noncomputable def omittedTwoRowPolynomial (W : WeightsN N D R)
    (p q : V N) (i h : Fin D) (k : ℕ) : MatchingPolynomial N D R :=
  eraseSite q (rowPolynomial (edgeMatrix W) (p, i)) *
    eraseSite q (rowPolynomial (edgeMatrix W) (p, h)) *
      (MvPolynomial.C ((k.factorial : R)⁻¹) *
        eraseSite q (deletedQuadratic W p) ^ k)

theorem cofactorSum_eq_omitted_two_row_coefficient (k : ℕ)
    (W : WeightsN (2 * (k + 2)) D R) (i h : Fin D)
    (p q : V (2 * (k + 2))) (hpq : p ≠ q) :
    (∑ r, edgeMatrix W (p, i) (r, h) * pureCofactor W h r q) =
      MvPolynomial.coeff (wordExponent (fun _ => h) (retainedVertices p q))
        (omittedTwoRowPolynomial W p q i h k) := by
  have hp : p ∉ retainedVertices p q := by simp [mem_retainedVertices]
  have hq : q ∉ retainedVertices p q := by simp [mem_retainedVertices]
  rw [cofactorSum_eq_two_row_coefficient k W i h p q hpq]
  rw [← coeff_word_eraseSite p _ (fun _ => h) _ hp,
    ← coeff_word_eraseSite q _ (fun _ => h) _ hq]
  congr 1
  simp only [dividedSourcePower, map_mul, map_pow, eraseSite_C,
    eraseSite_rowPolynomial, omittedTwoRowPolynomial, deletedQuadratic]

theorem source_diagonal_of_omission_vanishing (k : ℕ)
    (W : WeightsN (2 * (k + 2)) D R) (hW : EqSystemN (2 * (k + 2)) D W)
    (hvanish : ∀ p q, p ≠ q → ∀ i h,
      MvPolynomial.coeff (wordExponent (fun _ => h) (retainedVertices p q))
        (omittedTwoRowPolynomial W p q i h k) = 0) :
    ∀ p q i h, i ≠ h → edgeMatrix W (p, i) (q, h) = 0 := by
  apply source_diagonal_of_two_row_vanishing k W hW
  intro p q hpq i h
  rw [← cofactorSum_eq_two_row_coefficient k W i h p q hpq,
    cofactorSum_eq_omitted_two_row_coefficient k W i h p q hpq]
  exact hvanish p q hpq i h

end Krenn.CofactorResponse

-- formal/all-orders/OmittedResponse.lean

namespace Krenn.OmittedResponse

open scoped BigOperators
open MatchingModel SiteAlgebra RootResponse CofactorResponse

variable {K : Type*} [Field K] [CharZero K] {N D : ℕ}

omit [CharZero K] in

theorem oddResponse_term (k r : ℕ) (Q L : MatchingPolynomial N D K) :
    EvenResponse.dividedPower (K := K) L (2 * r + 1) *
      EvenResponse.dividedPower (K := K) Q (k - r) =
    MvPolynomial.C (((2 * r + 1).factorial : K)⁻¹) *
      (MvPolynomial.C (((k - r).factorial : K)⁻¹) * L ^ (2 * r + 1) * Q ^ (k - r)) := by
  simp only [EvenResponse.dividedPower, Algebra.algebraMap_self, RingHom.id_apply]
  ring

omit [CharZero K] in

theorem coeff_oddResponse_eq_linear_of_higher_zero
    (k : ℕ) (Q L : MatchingPolynomial N D K) (m : SiteVariable N D →₀ ℕ)
    (hzero : ∀ r, 0 < r → r ≤ k →
      MvPolynomial.coeff m
        (MvPolynomial.C (((k - r).factorial : K)⁻¹) * L ^ (2 * r + 1) * Q ^ (k - r)) = 0) :
    MvPolynomial.coeff m (EvenResponse.oddResponse (K := K) k Q L) =
      MvPolynomial.coeff m (MvPolynomial.C ((k.factorial : K)⁻¹) * L * Q ^ k) := by
  classical
  simp only [EvenResponse.oddResponse, MvPolynomial.coeff_sum, oddResponse_term,
    MvPolynomial.coeff_C_mul]
  rw [Finset.sum_eq_single 0]
  · simp
  · intro r hr hr0
    rw [hzero r (Nat.pos_of_ne_zero hr0) (by have := Finset.mem_range.mp hr; omega), mul_zero]
  · simp

omit [CharZero K] in

theorem raw_coefficient_zero_of_response_zero (W : WeightsN N D K)
    (p : V N) (k r : ℕ) (hr : r ≤ k) (ι : V N → Fin D) (a : Fin D → K)
    (hz : OddResponseVanishing.oddResponsePolynomial W p k r ι = 0) :
    MvPolynomial.coeff (wordExponent ι ((vertices N).erase p))
      (MvPolynomial.C (((k - r).factorial : K)⁻¹) *
        OddResponseVanishing.rowAt W p a ^ (2 * r + 1) *
        deletedQuadratic W p ^ (k - r)) = 0 := by
  have h := congrArg (MvPolynomial.eval a) hz
  rw [OddResponseVanishing.eval_oddResponsePolynomial] at h
  simpa only [OddResponseVanishing.oddResponse, if_pos hr,
    OddResponseVanishing.retainedCoefficient_project, map_zero] using h

theorem coeff_source_oddResponse (k : ℕ) (W : WeightsN (2 * (k + 1)) D K)
    (hW : EqSystemN (2 * (k + 1)) D W) (p : V (2 * (k + 1)))
    (ι : V (2 * (k + 1)) → Fin D) (a : Fin D → K)
    (hzero : ∀ r, 0 < r → r ≤ k →
      OddResponseVanishing.oddResponsePolynomial W p k r ι = 0) :
    MvPolynomial.coeff (wordExponent ι ((vertices (2 * (k + 1))).erase p))
      (EvenResponse.oddResponse (K := K) k (deletedQuadratic W p)
        (OddResponseVanishing.rowAt W p a)) =
      ∑ i : Fin D, a i * MvPolynomial.coeff
        (wordExponent ι ((vertices (2 * (k + 1))).erase p)) (pureRootWord p i) := by
  classical
  rw [coeff_oddResponse_eq_linear_of_higher_zero k _ _ _
    (fun r hp hr => raw_coefficient_zero_of_response_zero W p k r hr ι a (hzero r hp hr))]
  have h := OddResponseVanishing.oddResponse_zero k W hW p a
  have hc := congrArg (OddResponseVanishing.retainedCoefficient p ι) h
  change _ = _ at hc
  rw [show OddResponseVanishing.oddResponse W p k 0 a =
      project (MvPolynomial.C ((k.factorial : K)⁻¹) *
        OddResponseVanishing.rowAt W p a * deletedQuadratic W p ^ k) by
      simp [OddResponseVanishing.oddResponse]] at hc
  rw [OddResponseVanishing.retainedCoefficient_project] at hc
  rw [hc]
  change (OddResponseVanishing.retainedCoefficientHom p ι)
    (∑ i, OddResponseVanishing.siteScalar (a i) * project (pureRootWord p i)) = _
  rw [map_sum]
  apply Finset.sum_congr rfl
  intro i _
  exact (OddResponseVanishing.retainedCoefficient_scalar_mul p ι (a i) _).trans
    (congrArg (a i * ·) (OddResponseVanishing.retainedCoefficient_project p ι _))

theorem coeff_rootExtract (P : MatchingPolynomial N D K)
    (q : V N) (ι : V N → Fin D) (L : List (V N)) (hq : q ∉ L) :
    MvPolynomial.coeff (wordExponent ι L) (rootExtract q (ι q) P) =
      MvPolynomial.coeff (wordExponent ι (q :: L)) P := by
  rw [rootExtract, coeff_word_eraseSite q _ ι L hq]
  exact (coeff_root_pderiv P ι q L hq).symm

theorem coeff_retained_rootExtract (P : MatchingPolynomial N D K)
    (p q : V N) (hpq : p ≠ q) (ι : V N → Fin D) :
    MvPolynomial.coeff (wordExponent ι (retainedVertices p q))
      (rootExtract q (ι q) P) =
      MvPolynomial.coeff (wordExponent ι ((vertices N).erase p)) P := by
  have hq : q ∉ retainedVertices p q := by simp [mem_retainedVertices]
  rw [coeff_rootExtract P q ι _ hq]
  congr 1
  rw [wordExponent, wordExponent_erase ι _ q
    ((List.mem_erase_of_ne hpq.symm).mpr (mem_vertices q))]
  rfl

theorem coeff_omitted_source (k : ℕ) (W : WeightsN (2 * (k + 1)) D K)
    (hW : EqSystemN (2 * (k + 1)) D W)
    (p q : V (2 * (k + 1))) (hpq : p ≠ q)
    (ι : V (2 * (k + 1)) → Fin D) (a : Fin D → K)
    (hzero : ∀ r, 0 < r → r ≤ k →
      OddResponseVanishing.oddResponsePolynomial W p k r ι = 0) :
    MvPolynomial.coeff (wordExponent ι (retainedVertices p q))
      (rootExtract q (ι q) (OddResponseVanishing.rowAt W p a) *
        EvenResponse.evenResponse (K := K) k
          (eraseSite q (deletedQuadratic W p))
          (eraseSite q (OddResponseVanishing.rowAt W p a)) +
       rootExtract q (ι q) (deletedQuadratic W p) *
        EvenResponse.lowerOddResponse (K := K) k
          (eraseSite q (deletedQuadratic W p))
          (eraseSite q (OddResponseVanishing.rowAt W p a))) =
      ∑ i : Fin D, a i * MvPolynomial.coeff
        (wordExponent ι ((vertices (2 * (k + 1))).erase p)) (pureRootWord p i) := by
  rw [← EvenResponse.rootExtract_oddResponse, coeff_retained_rootExtract _ p q hpq ι]
  exact coeff_source_oddResponse k W hW p ι a hzero

end Krenn.OmittedResponse

-- formal/all-orders/PhysicalEndpoint.lean

namespace Krenn.PhysicalEndpoint

open scoped BigOperators
open MatchingModel SiteAlgebra RootResponse
open MvPolynomial

variable {K : Type*} [Field K] {N D : ℕ}

abbrev PhysicalPolynomial (N D : ℕ) (K : Type*) [CommRing K] :=
  MatchingPolynomial N D K

abbrev MeanTensor (N D : ℕ) (K : Type*) [CommRing K] :=
  MvPolynomial (Fin 4) (PhysicalPolynomial N D K)

noncomputable def receivingPolynomial (n : SiteVariable N D →₀ ℕ)
    (P : MeanTensor N D K) : ReplicaKernel.MeanPolynomial K :=
  AddMonoidAlgebra.map (MvPolynomial.lcoeff K n).toAddMonoidHom P

@[simp] theorem coeff_receivingPolynomial (n : SiteVariable N D →₀ ℕ)
    (P : MeanTensor N D K) (a : Fin 4 →₀ ℕ) :
    coeff a (receivingPolynomial n P) = coeff n (coeff a P) :=
  coeff_addMonoidAlgebraMap _ _ _

@[simp] theorem receivingPolynomial_add (n : SiteVariable N D →₀ ℕ)
    (P Q : MeanTensor N D K) :
    receivingPolynomial n (P + Q) = receivingPolynomial n P + receivingPolynomial n Q :=
  AddMonoidAlgebra.map_add _ _ _

@[simp] theorem receivingPolynomial_zero (n : SiteVariable N D →₀ ℕ) :
    receivingPolynomial (K := K) n (0 : MeanTensor N D K) = 0 :=
  AddMonoidAlgebra.map_zero _

theorem receivingPolynomial_pderiv (n : SiteVariable N D →₀ ℕ)
    (P : MeanTensor N D K) (j : Fin 4) :
    receivingPolynomial n (pderiv j P) = pderiv j (receivingPolynomial n P) := by
  ext a
  simp only [coeff_receivingPolynomial, coeff_pderiv]
  have hcast : ((a j : PhysicalPolynomial N D K) + 1) = C ((a j : K) + 1) := by
    simp
  rw [hcast, mul_comm, coeff_C_mul, mul_comm]

@[simp] theorem receivingPolynomial_C (n : SiteVariable N D →₀ ℕ)
    (P : PhysicalPolynomial N D K) :
    receivingPolynomial n (C P) = C (coeff n P) := by
  unfold receivingPolynomial
  exact AddMonoidAlgebra.map_single _ _ _

theorem eval_receivingPolynomial (n : SiteVariable N D →₀ ℕ)
    (P : MeanTensor N D K) (a : Fin 4 → K) :
    eval a (receivingPolynomial n P) =
      coeff n (eval (fun j => C (a j)) P) := by
  classical
  induction P using MvPolynomial.induction_on' with
  | monomial s q =>
    unfold receivingPolynomial
    have hmap : AddMonoidAlgebra.map (lcoeff K n).toAddMonoidHom (monomial s q) =
        monomial s (coeff n q) := AddMonoidAlgebra.map_single _ _ _
    rw [hmap, eval_monomial, eval_monomial]
    have hprod : s.prod (fun j k => (C (a j) : PhysicalPolynomial N D K) ^ k) =
        C (s.prod (fun j k => a j ^ k)) := by
      rw [map_finsuppProd]
      simp only [map_pow]
    rw [hprod, mul_comm q, coeff_C_mul]
    ring
  | add P Q hP hQ =>
    simp only [receivingPolynomial_add, map_add, coeff_add, hP, hQ]

noncomputable def retainedQuadratic (W : WeightsN N D K) (p q : V N) :
    PhysicalPolynomial N D K := eraseSite q (deletedQuadratic W p)

noncomputable def retainedRow (W : WeightsN N D K) (p q : V N) (i : Fin D) :
    PhysicalPolynomial N D K := eraseSite q (rowPolynomial (edgeMatrix W) (p, i))

noncomputable def endpointRows (W : WeightsN N D K) (p q : V N) (b h : Fin D) :
    Fin 4 → PhysicalPolynomial N D K :=
  ![retainedRow W p q b, retainedRow W q p b,
    retainedRow W p q h, retainedRow W q p h]

noncomputable def meanRow (rows : Fin 4 → PhysicalPolynomial N D K) :
    MeanTensor N D K := ∑ j : Fin 4, X j * C (rows j)

@[simp] theorem pderiv_meanRow (rows : Fin 4 → PhysicalPolynomial N D K) (j : Fin 4) :
    pderiv j (meanRow rows) = C (rows j) := by
  classical
  simp [meanRow, pderiv_X, Pi.single_apply]

@[simp] theorem eval_meanRow (rows : Fin 4 → PhysicalPolynomial N D K)
    (a : Fin 4 → K) :
    eval (fun j => C (a j)) (meanRow rows) = ∑ j : Fin 4, C (a j) * rows j := by
  simp [meanRow]

variable [CharZero K]

noncomputable def physicalEvenResponse (m : ℕ)
    (Q : PhysicalPolynomial N D K) (rows : Fin 4 → PhysicalPolynomial N D K) :
    MeanTensor N D K :=
  EvenResponse.evenResponse (K := K) m (C Q) (meanRow rows)

omit [CharZero K] in

theorem eval_physicalEvenResponse (m : ℕ)
    (Q : PhysicalPolynomial N D K) (rows : Fin 4 → PhysicalPolynomial N D K)
    (a : Fin 4 → K) :
    eval (fun j => C (a j)) (physicalEvenResponse m Q rows) =
      EvenResponse.evenResponse (K := K) m Q (∑ j : Fin 4, C (a j) * rows j) := by
  unfold physicalEvenResponse
  have hf : ∀ c : K, eval (fun j => (C (a j) : PhysicalPolynomial N D K))
      (C (algebraMap K (PhysicalPolynomial N D K) c)) =
      (C (algebraMap K K c) : PhysicalPolynomial N D K) := by simp
  rw [EvenResponse.map_evenResponse (eval (fun j => C (a j))) hf]
  simp

theorem pderiv_physicalEvenResponse (m : ℕ)
    (Q : PhysicalPolynomial N D K) (rows : Fin 4 → PhysicalPolynomial N D K)
    (j : Fin 4) :
    pderiv j (physicalEvenResponse m Q rows) =
      C (rows j) * EvenResponse.lowerOddResponse (K := K) m (C Q) (meanRow rows) := by
  unfold physicalEvenResponse
  rw [EvenResponse.pderiv_evenResponse_of_pderiv_quadratic_zero m _ _ j
    (by simp), pderiv_meanRow]

theorem eval_pderiv_receivingEvenResponse (m : ℕ)
    (Q : PhysicalPolynomial N D K) (rows : Fin 4 → PhysicalPolynomial N D K)
    (n : SiteVariable N D →₀ ℕ) (a : Fin 4 → K) (j : Fin 4) :
    eval a (pderiv j (receivingPolynomial n (physicalEvenResponse m Q rows))) =
      coeff n (rows j * EvenResponse.lowerOddResponse (K := K) m Q
        (∑ k : Fin 4, C (a k) * rows k)) := by
  rw [← receivingPolynomial_pderiv, eval_receivingPolynomial,
    pderiv_physicalEvenResponse]
  have hf : ∀ c : K, eval (fun k => (C (a k) : PhysicalPolynomial N D K))
      (C (algebraMap K (PhysicalPolynomial N D K) c)) =
      (C (algebraMap K K c) : PhysicalPolynomial N D K) := by simp
  rw [map_mul, eval_C, EvenResponse.map_lowerOddResponse
    (eval (fun k => C (a k))) hf]
  simp

noncomputable def endpointResponse (m : ℕ) (W : WeightsN N D K)
    (p q : V N) (b h : Fin D) (n : SiteVariable N D →₀ ℕ) :
    ReplicaKernel.MeanPolynomial K :=
  receivingPolynomial n
    (physicalEvenResponse m (retainedQuadratic W p q) (endpointRows W p q b h))

omit [CharZero K] in
theorem eval_endpointResponse (m : ℕ) (W : WeightsN N D K)
    (p q : V N) (b h : Fin D) (n : SiteVariable N D →₀ ℕ) (a : Fin 4 → K) :
    eval a (endpointResponse m W p q b h n) =
      coeff n (EvenResponse.evenResponse (K := K) m (retainedQuadratic W p q)
        (∑ j : Fin 4, C (a j) * endpointRows W p q b h j)) := by
  rw [endpointResponse, eval_receivingPolynomial, eval_physicalEvenResponse]

theorem eval_pderiv_endpointResponse (m : ℕ) (W : WeightsN N D K)
    (p q : V N) (b h : Fin D) (n : SiteVariable N D →₀ ℕ) (a : Fin 4 → K)
    (j : Fin 4) :
    eval a (pderiv j (endpointResponse m W p q b h n)) =
      coeff n (endpointRows W p q b h j *
        EvenResponse.lowerOddResponse (K := K) m (retainedQuadratic W p q)
          (∑ k : Fin 4, C (a k) * endpointRows W p q b h k)) := by
  exact eval_pderiv_receivingEvenResponse m _ _ n a j

omit [CharZero K] in
theorem eraseSite_commute (p q : V N) (P : PhysicalPolynomial N D K) :
    eraseSite p (eraseSite q P) = eraseSite q (eraseSite p P) := by
  have h : (eraseSite (R := K) (D := D) p).comp (eraseSite q) =
      (eraseSite q).comp (eraseSite p) := by
    apply MvPolynomial.ringHom_ext
    · intro c
      simp
    · intro z
      simp only [RingHom.comp_apply, eraseSite_X]
      split_ifs <;> simp_all only [map_zero, eraseSite_X, ite_true, ite_false]
  exact RingHom.congr_fun h P

theorem extractedQuadratic_eq_retainedRow (W : WeightsN N D K)
    (p q : V N) (h : Fin D) (hpq : p ≠ q) :
    rootExtract q h (deletedQuadratic W p) = retainedRow W q p h := by
  rw [EvenResponse.rootExtract_deletedQuadratic W p q h hpq,
    eraseSite_commute, eraseSite_rowPolynomial]
  rfl

noncomputable def twoColorParameters (b h : Fin D) (s t : K) : Fin D → K :=
  fun i => (if i = b then s else 0) + (if i = h then t else 0)

omit [CharZero K] in
theorem rowAt_twoColorParameters (W : WeightsN N D K) (p : V N)
    (b h : Fin D) (s t : K) :
    OddResponseVanishing.rowAt W p (twoColorParameters b h s t) =
      C s * rowPolynomial (edgeMatrix W) (p, b) +
      C t * rowPolynomial (edgeMatrix W) (p, h) := by
  classical
  have hc (i : Fin D) (j : Fin D) (a : K) :
      (C (if i = j then a else 0) : PhysicalPolynomial N D K) =
        if i = j then C a else 0 := by split_ifs <;> simp
  simp only [OddResponseVanishing.rowAt, rootFamilyRow, twoColorParameters,
    map_add, hc, add_mul, Finset.sum_add_distrib, ite_mul, zero_mul]
  simp

omit [CharZero K] in
theorem eraseSite_rowAt_twoColorParameters (W : WeightsN N D K) (p q : V N)
    (b h : Fin D) (s t : K) :
    eraseSite q (OddResponseVanishing.rowAt W p (twoColorParameters b h s t)) =
      C s * retainedRow W p q b + C t * retainedRow W p q h := by
  rw [rowAt_twoColorParameters]
  simp [retainedRow]

omit [CharZero K] in

theorem rootExtract_rowAt_twoColorParameters (W : WeightsN N D K) (p q : V N)
    (b h j : Fin D) (s t : K) :
    rootExtract q j (OddResponseVanishing.rowAt W p (twoColorParameters b h s t)) =
      C (s * edgeMatrix W (p, b) (q, j) + t * edgeMatrix W (p, h) (q, j)) := by
  rw [rowAt_twoColorParameters, rootExtract_add]
  simp only [rootExtract_mul, rootExtract_C, eraseSite_C, zero_mul, zero_add,
    EvenResponse.rootExtract_rowPolynomial]
  rw [← map_mul, ← map_mul, ← map_add]

omit [CharZero K] in

theorem coeff_pureRootWord_wrong_color (p q : V N) (hpq : p ≠ q)
    (ι : V N → Fin D) (h : Fin D) (hh : h ≠ ι q) :
    coeff (wordExponent ι ((vertices N).erase p)) (pureRootWord (R := K) p h) = 0 := by
  classical
  have hq : q ∈ (vertices N).erase p :=
    (List.mem_erase_of_ne hpq.symm).mpr (mem_vertices q)
  have hn : ((vertices N).erase p).Nodup := (vertices_nodup N).erase p
  have heq : wordExponent (fun _ => h) ((vertices N).erase p) ≠
      wordExponent ι ((vertices N).erase p) := by
    intro heq
    have he := congrArg (fun n : SiteVariable N D →₀ ℕ => n (q, h)) heq
    rw [wordExponent_selected, hn.count, if_pos hq,
      wordExponent_wrong_color ι _ q h hh] at he
    exact Nat.one_ne_zero he
  rw [pureRootWord, coeff_monomial]
  exact if_neg heq

noncomputable def meanPplane : ReplicaKernel.MeanPolynomial K →+*
    ReplicaKernel.MeanPolynomial K := eval₂Hom C ![X 0, 0, X 2, 0]

noncomputable def meanQplane : ReplicaKernel.MeanPolynomial K →+*
    ReplicaKernel.MeanPolynomial K := eval₂Hom C ![0, X 1, 0, X 3]

omit [CharZero K] in
theorem eval_meanPplane (P : ReplicaKernel.MeanPolynomial K) (a : Fin 4 → K) :
    eval a (meanPplane P) = eval ![a 0, 0, a 2, 0] P := by
  change eval₂ (RingHom.id K) a (eval₂ C ![X 0, 0, X 2, 0] P) = _
  rw [← eval₂_assoc]
  congr 1
  funext j
  fin_cases j <;> simp

theorem numerical_source_boundary (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (ι : V (2 * (m + 1)) → Fin D) (hι : ι q = b)
    (hdiag : edgeMatrix W (p, h) (q, b) = 0)
    (hzero : ∀ r, 0 < r → r ≤ m →
      OddResponseVanishing.oddResponsePolynomial W p m r ι = 0) (s t : K) :
    coeff (wordExponent ι (CofactorResponse.retainedVertices p q))
      (C (s * edgeMatrix W (p, b) (q, b)) *
          EvenResponse.evenResponse (K := K) m (retainedQuadratic W p q)
            (C s * retainedRow W p q b + C t * retainedRow W p q h) +
        retainedRow W q p b *
          EvenResponse.lowerOddResponse (K := K) m (retainedQuadratic W p q)
            (C s * retainedRow W p q b + C t * retainedRow W p q h)) =
      s * coeff (wordExponent ι ((vertices (2 * (m + 1))).erase p))
        (pureRootWord p b) := by
  classical
  have hz := OmittedResponse.coeff_omitted_source m W hW p q hpq ι
    (twoColorParameters b h s t) hzero
  rw [hι, rootExtract_rowAt_twoColorParameters, hdiag, mul_zero, add_zero,
    extractedQuadratic_eq_retainedRow W p q b hpq,
    eraseSite_rowAt_twoColorParameters] at hz
  unfold retainedQuadratic
  rw [hz]
  have hpure := coeff_pureRootWord_wrong_color (K := K) p q hpq ι h
    (hι.symm ▸ hbh.symm)
  simp only [twoColorParameters, add_mul, Finset.sum_add_distrib, ite_mul, zero_mul]
  simp only [Finset.sum_ite_eq', Finset.mem_univ, if_true, hpure, mul_zero, add_zero]

theorem mean_source_boundary (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (ι : V (2 * (m + 1)) → Fin D) (hι : ι q = b)
    (hdiag : edgeMatrix W (p, h) (q, b) = 0)
    (hzero : ∀ r, 0 < r → r ≤ m →
      OddResponseVanishing.oddResponsePolynomial W p m r ι = 0) :
    meanPplane (pderiv 1 (endpointResponse m W p q b h
        (wordExponent ι (CofactorResponse.retainedVertices p q))) +
      C (edgeMatrix W (p, b) (q, b)) * X 0 * endpointResponse m W p q b h
        (wordExponent ι (CofactorResponse.retainedVertices p q))) =
      X 0 * C (coeff (wordExponent ι ((vertices (2 * (m + 1))).erase p))
        (pureRootWord p b)) := by
  apply MvPolynomial.funext
  intro a
  rw [eval_meanPplane]
  simp only [map_add, map_mul, eval_C, eval_X]
  rw [eval_pderiv_endpointResponse, eval_endpointResponse]
  have hrow : (∑ j : Fin 4, C (![a 0, 0, a 2, 0] j) * endpointRows W p q b h j) =
      C (a 0) * retainedRow W p q b + C (a 2) * retainedRow W p q h := by
    simp [Fin.sum_univ_succ, endpointRows]
  rw [hrow]
  have hn := numerical_source_boundary m W hW p q hpq b h hbh ι hι hdiag hzero
    (a 0) (a 2)
  rw [coeff_add, coeff_C_mul] at hn
  dsimp [endpointRows]
  convert hn using 1
  ring

omit [CharZero K] in

theorem mean_pderiv_commute (P : ReplicaKernel.MeanPolynomial K) (i j : Fin 4) :
    pderiv i (pderiv j P) = pderiv j (pderiv i P) := by
  classical
  by_cases hij : i = j
  · subst j
    rfl
  · ext n
    simp only [coeff_pderiv, Finsupp.add_apply, Finsupp.single_apply,
      if_neg hij, if_neg (Ne.symm hij), add_zero]
    rw [show (n + Finsupp.single i 1) + Finsupp.single j 1 =
      (n + Finsupp.single j 1) + Finsupp.single i 1 by ac_rfl]
    ring

omit [CharZero K] in
theorem pderiv_meanPplane_two (P : ReplicaKernel.MeanPolynomial K) :
    pderiv 2 (meanPplane P) = meanPplane (pderiv 2 P) := by
  rw [meanPplane, ReplicaKernel.pderiv_substitution]
  simp [Fin.sum_univ_succ, pderiv_X]

omit [CharZero K] in
theorem meanXAxis_meanPplane (P : ReplicaKernel.MeanPolynomial K) :
    ReplicaKernel.meanXAxis (meanPplane P) = ReplicaKernel.meanXAxis P := by
  have h : ReplicaKernel.meanXAxis.comp (meanPplane (K := K)) =
      ReplicaKernel.meanXAxis := by
    apply MvPolynomial.ringHom_ext
    · intro c
      simp [ReplicaKernel.meanXAxis, meanPplane]
    · intro j
      fin_cases j <;> simp [ReplicaKernel.meanXAxis, meanPplane]
  exact RingHom.congr_fun h P

theorem mean_mixed_boundary (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (ι : V (2 * (m + 1)) → Fin D) (hι : ι q = b)
    (hdiag : edgeMatrix W (p, h) (q, b) = 0)
    (hzero : ∀ r, 0 < r → r ≤ m →
      OddResponseVanishing.oddResponsePolynomial W p m r ι = 0) :
    ReplicaKernel.meanXAxis
      (pderiv 1 (pderiv 2 (endpointResponse m W p q b h
        (wordExponent ι (CofactorResponse.retainedVertices p q)))) +
      C (edgeMatrix W (p, b) (q, b)) * X 0 *
        pderiv 2 (endpointResponse m W p q b h
          (wordExponent ι (CofactorResponse.retainedVertices p q)))) = 0 := by
  have hs := congrArg (pderiv (R := K) (σ := Fin 4) 2)
    (mean_source_boundary m W hW p q hpq b h hbh ι hι hdiag hzero)
  rw [pderiv_meanPplane_two] at hs
  rw [(pderiv (R := K) (σ := Fin 4) 2).map_add] at hs
  simp only [pderiv_mul, pderiv_C, pderiv_X_of_ne (by decide : (0 : Fin 4) ≠ 2),
    zero_mul, mul_zero, zero_add, add_zero] at hs
  rw [mean_pderiv_commute _ 2 1] at hs
  have hh := congrArg ReplicaKernel.meanXAxis hs
  rw [meanXAxis_meanPplane, map_zero] at hh
  exact hh

theorem mean_scalar_boundary (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (ι : V (2 * (m + 1)) → Fin D) (hι : ι q = b)
    (hdiag : edgeMatrix W (p, h) (q, b) = 0)
    (hzero : ∀ r, 0 < r → r ≤ m →
      OddResponseVanishing.oddResponsePolynomial W p m r ι = 0) :
    ReplicaKernel.meanXAxis
      (pderiv 1 (endpointResponse m W p q b h
        (wordExponent ι (CofactorResponse.retainedVertices p q))) +
      C (edgeMatrix W (p, b) (q, b)) * X 0 * endpointResponse m W p q b h
        (wordExponent ι (CofactorResponse.retainedVertices p q))) =
      X 0 * C (coeff (wordExponent ι ((vertices (2 * (m + 1))).erase p))
        (pureRootWord p b)) := by
  have hs := congrArg ReplicaKernel.meanXAxis
    (mean_source_boundary m W hW p q hpq b h hbh ι hι hdiag hzero)
  rw [meanXAxis_meanPplane] at hs
  simpa [ReplicaKernel.meanXAxis] using hs

theorem numerical_second_source_boundary (m : ℕ)
    (W : WeightsN (2 * (m + 1)) D K) (hW : EqSystemN (2 * (m + 1)) D W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (ι : V (2 * (m + 1)) → Fin D) (hι : ι q = h)
    (hdiag : edgeMatrix W (p, b) (q, h) = 0)
    (hzero : ∀ r, 0 < r → r ≤ m →
      OddResponseVanishing.oddResponsePolynomial W p m r ι = 0) (s t : K) :
    coeff (wordExponent ι (CofactorResponse.retainedVertices p q))
      (C (t * edgeMatrix W (p, h) (q, h)) *
          EvenResponse.evenResponse (K := K) m (retainedQuadratic W p q)
            (C s * retainedRow W p q b + C t * retainedRow W p q h) +
        retainedRow W q p h *
          EvenResponse.lowerOddResponse (K := K) m (retainedQuadratic W p q)
            (C s * retainedRow W p q b + C t * retainedRow W p q h)) =
      t * coeff (wordExponent ι ((vertices (2 * (m + 1))).erase p))
        (pureRootWord p h) := by
  classical
  have hz := OmittedResponse.coeff_omitted_source m W hW p q hpq ι
    (twoColorParameters b h s t) hzero
  rw [hι, rootExtract_rowAt_twoColorParameters, hdiag, mul_zero, zero_add,
    extractedQuadratic_eq_retainedRow W p q h hpq,
    eraseSite_rowAt_twoColorParameters] at hz
  unfold retainedQuadratic
  rw [hz]
  have hpure := coeff_pureRootWord_wrong_color (K := K) p q hpq ι b
    (hι.symm ▸ hbh)
  simp only [twoColorParameters, add_mul, Finset.sum_add_distrib, ite_mul, zero_mul]
  simp only [Finset.sum_ite_eq', Finset.mem_univ, if_true, hpure, mul_zero, zero_add]

theorem mean_second_source_boundary (m : ℕ)
    (W : WeightsN (2 * (m + 1)) D K) (hW : EqSystemN (2 * (m + 1)) D W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (ι : V (2 * (m + 1)) → Fin D) (hι : ι q = h)
    (hdiag : edgeMatrix W (p, b) (q, h) = 0)
    (hzero : ∀ r, 0 < r → r ≤ m →
      OddResponseVanishing.oddResponsePolynomial W p m r ι = 0) :
    meanPplane (pderiv 3 (endpointResponse m W p q b h
        (wordExponent ι (CofactorResponse.retainedVertices p q))) +
      C (edgeMatrix W (p, h) (q, h)) * X 2 * endpointResponse m W p q b h
        (wordExponent ι (CofactorResponse.retainedVertices p q))) =
      X 2 * C (coeff (wordExponent ι ((vertices (2 * (m + 1))).erase p))
        (pureRootWord p h)) := by
  apply MvPolynomial.funext
  intro a
  rw [eval_meanPplane]
  simp only [map_add, map_mul, eval_C, eval_X]
  rw [eval_pderiv_endpointResponse, eval_endpointResponse]
  have hrow : (∑ j : Fin 4, C (![a 0, 0, a 2, 0] j) * endpointRows W p q b h j) =
      C (a 0) * retainedRow W p q b + C (a 2) * retainedRow W p q h := by
    simp [Fin.sum_univ_succ, endpointRows]
  rw [hrow]
  have hn := numerical_second_source_boundary m W hW p q hpq b h hbh ι hι hdiag hzero
    (a 0) (a 2)
  rw [coeff_add, coeff_C_mul] at hn
  dsimp [endpointRows]
  convert hn using 1
  ring

theorem mean_v_boundary (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (ι : V (2 * (m + 1)) → Fin D) (hι : ι q = h)
    (hdiag : edgeMatrix W (p, b) (q, h) = 0)
    (hzero : ∀ r, 0 < r → r ≤ m →
      OddResponseVanishing.oddResponsePolynomial W p m r ι = 0) :
    ReplicaKernel.meanXAxis (pderiv 3 (endpointResponse m W p q b h
      (wordExponent ι (CofactorResponse.retainedVertices p q)))) = 0 := by
  have hs := congrArg ReplicaKernel.meanXAxis
    (mean_second_source_boundary m W hW p q hpq b h hbh ι hι hdiag hzero)
  rw [meanXAxis_meanPplane] at hs
  simpa [ReplicaKernel.meanXAxis] using hs

noncomputable def pureRetainedWord (p q : V N) (h : Fin D) : PhysicalPolynomial N D K :=
  monomial (wordExponent (fun _ => h) (CofactorResponse.retainedVertices p q)) 1

omit [CharZero K] in
theorem rootExtract_pureRootWord (p q : V N) (hpq : p ≠ q) (i h : Fin D) :
    rootExtract q i (pureRootWord (R := K) p h) =
      if i = h then pureRetainedWord p q h else 0 := by
  classical
  have hq : q ∈ (vertices N).erase p :=
    (List.mem_erase_of_ne hpq.symm).mpr (mem_vertices q)
  have hn : ((vertices N).erase p).Nodup := (vertices_nodup N).erase p
  unfold rootExtract pureRootWord
  rw [pderiv_monomial]
  by_cases hi : i = h
  · subst i
    rw [if_pos rfl, wordExponent_selected, hn.count, if_pos hq]
    simp only [Nat.cast_one, mul_one]
    rw [wordExponent_erase (fun _ => h) _ q hq, add_tsub_cancel_left]
    exact eraseSite_wordMonomial q _ _ hn.not_mem_erase
  · rw [if_neg hi, wordExponent_wrong_color (fun _ => h) _ q i hi]
    simp

theorem coeff_pureRootWord_eq_retained (p q : V N) (hpq : p ≠ q)
    (ι : V N → Fin D) (h : Fin D) (hι : ι q = h) :
    coeff (wordExponent ι ((vertices N).erase p)) (pureRootWord (R := K) p h) =
      coeff (wordExponent ι (CofactorResponse.retainedVertices p q))
        (pureRetainedWord p q h) := by
  rw [← OmittedResponse.coeff_retained_rootExtract _ p q hpq ι, hι,
    rootExtract_pureRootWord p q hpq h h, if_pos rfl]

end Krenn.PhysicalEndpoint

-- formal/all-orders/RetainedBinary.lean

namespace Krenn.RetainedBinary

open scoped BigOperators
open MvPolynomial MatchingModel SiteAlgebra RootResponse CofactorResponse PhysicalEndpoint

variable {K : Type*} [Field K] [CharZero K] {N D : ℕ}

abbrev RetainedSites (p q : V N) := {v : V N // v ≠ p ∧ v ≠ q}

noncomputable def receivingWord (p q : V N) (b h : Fin D)
    (w : RetainedSites p q → Bool) : V N → Fin D :=
  fun v => if hv : v ≠ p ∧ v ≠ q then if w ⟨v, hv⟩ then h else b else h

omit [CharZero K] in
@[simp] theorem receivingWord_at_q (p q : V N) (b h : Fin D)
    (w : RetainedSites p q → Bool) : receivingWord p q b h w q = h := by
  simp [receivingWord]

@[simp] theorem receivingWord_at_retained (p q : V N) (b h : Fin D)
    (w : RetainedSites p q → Bool) (v : RetainedSites p q) :
    receivingWord p q b h w v = if w v then h else b := by
  simp only [receivingWord, dif_pos v.property]

@[simp] theorem receivingWord_true (p q : V N) (b h : Fin D) :
    receivingWord p q b h (fun _ => true) = fun _ => h := by
  funext v
  simp [receivingWord]

omit [CharZero K] in

theorem coeff_pureRetainedWord (p q : V N) (b h : Fin D) (hbh : b ≠ h)
    (w : RetainedSites p q → Bool) :
    coeff (wordExponent (receivingWord p q b h w) (retainedVertices p q))
      (pureRetainedWord (K := K) p q h) =
      BinaryPairing.pure true w := by
  classical
  unfold pureRetainedWord BinaryPairing.pure
  rw [coeff_monomial]
  by_cases hw : w = (fun _ => true)
  · simp [hw]
  · rw [if_neg hw]
    apply if_neg
    intro heq
    apply hw
    funext v
    by_contra hv
    have hfalse : w v = false := Bool.eq_false_of_not_eq_true hv
    have hmem : v.val ∈ retainedVertices p q := (mem_retainedVertices p q v.val).mpr v.property
    have hcolor : h ≠ receivingWord p q b h w v.val := by
      rw [receivingWord_at_retained, hfalse]
      exact hbh.symm
    have hc := congrArg (fun n : SiteVariable N D →₀ ℕ => n (v.val, h)) heq
    rw [wordExponent_selected, (retainedVertices_nodup p q).count, if_pos hmem,
      wordExponent_wrong_color _ _ v.val h hcolor] at hc
    exact Nat.one_ne_zero hc

noncomputable def retainedListEquiv (p q : V N) :
    RetainedSites p q ≃ ↥(retainedVertices p q).toFinset where
  toFun v := ⟨v.val, List.mem_toFinset.mpr ((mem_retainedVertices p q v.val).mpr v.property)⟩
  invFun v := ⟨v.val, (mem_retainedVertices p q v.val).mp (List.mem_toFinset.mp v.property)⟩
  left_inv _ := rfl
  right_inv _ := rfl

theorem card_retainedSites (p q : V N) (hpq : p ≠ q) :
    Fintype.card (RetainedSites p q) = N - 2 := by
  rw [Fintype.card_congr (retainedListEquiv p q), Fintype.card_coe,
    List.toFinset_card_of_nodup (retainedVertices_nodup p q), retainedVertices_length p q hpq]

theorem even_card_retainedSites (k : ℕ) (p q : V (2 * (k + 2))) (hpq : p ≠ q) :
    Even (Fintype.card (RetainedSites p q)) := by
  rw [card_retainedSites p q hpq]
  exact ⟨k + 1, by omega⟩

theorem wordExponent_congr_on_list (ι κ : V N → Fin D) (L : List (V N))
    (h : ∀ v ∈ L, ι v = κ v) : wordExponent ι L = wordExponent κ L := by
  induction L with
  | nil => rfl
  | cons v L ih =>
    simp only [wordExponent, h v (by simp), ih (fun u hu => h u (by simp [hu]))]

omit [CharZero K] in

theorem coeff_pureRetainedWord_false (p q : V N) (b h : Fin D) (hbh : b ≠ h)
    (w : RetainedSites p q → Bool) :
    coeff (wordExponent (receivingWord p q b h w) (retainedVertices p q))
      (pureRetainedWord (K := K) p q b) = BinaryPairing.pure false w := by
  classical
  unfold pureRetainedWord BinaryPairing.pure
  rw [coeff_monomial]
  by_cases hw : w = (fun _ => false)
  · rw [if_pos hw]
    apply if_pos
    apply wordExponent_congr_on_list
    intro v hv
    have hpq := (mem_retainedVertices p q v).mp hv
    simp [receivingWord, hpq, hw]
  · rw [if_neg hw]
    apply if_neg
    intro heq
    apply hw
    funext v
    by_contra hv
    have htrue : w v = true := Bool.eq_true_of_not_eq_false hv
    have hmem : v.val ∈ retainedVertices p q := (mem_retainedVertices p q v.val).mpr v.property
    have hcolor : b ≠ receivingWord p q b h w v.val := by
      rw [receivingWord_at_retained, htrue]
      exact hbh
    have hc := congrArg (fun n : SiteVariable N D →₀ ℕ => n (v.val, b)) heq
    rw [wordExponent_selected, (retainedVertices_nodup p q).count, if_pos hmem,
      wordExponent_wrong_color _ _ v.val b hcolor] at hc
    exact Nat.one_ne_zero hc

end Krenn.RetainedBinary

-- formal/all-orders/EndpointSource.lean

namespace Krenn.EndpointSource

open scoped BigOperators
open MatchingModel SiteAlgebra RootResponse PhysicalEndpoint
open MvPolynomial

variable {K : Type*} [Field K] [CharZero K] {N D : ℕ}

omit [CharZero K] in

theorem wordExponent_update_not_mem (ι : V N → Fin D) (L : List (V N))
    (q : V N) (h : Fin D) (hq : q ∉ L) :
    wordExponent (Function.update ι q h) L = wordExponent ι L := by
  classical
  induction L with
  | nil => rfl
  | cons v L ih =>
    have hvq : v ≠ q := by intro hvq; subst v; simp at hq
    have hqL : q ∉ L := by intro h; exact hq (List.mem_cons.mpr (Or.inr h))
    simp only [wordExponent, Function.update_of_ne hvq, ih hqL]

omit [CharZero K] in
theorem retainedExponent_update (p q : V N) (ι : V N → Fin D) (h : Fin D) :
    wordExponent (Function.update ι q h) (CofactorResponse.retainedVertices p q) =
      wordExponent ι (CofactorResponse.retainedVertices p q) :=
  wordExponent_update_not_mem ι _ q h (by simp [CofactorResponse.mem_retainedVertices])

def OnPalette (ι : V N → Fin D) (b h : Fin D) : Prop :=
  ∀ v, ι v = b ∨ ι v = h

omit [CharZero K] in
theorem onPalette_update (ι : V N → Fin D) (b h j : Fin D) (q : V N)
    (hι : OnPalette ι b h) (hj : j = b ∨ j = h) :
    OnPalette (Function.update ι q j) b h := by
  classical
  intro v
  by_cases hv : v = q
  · simpa [hv] using hj
  · simpa [Function.update_of_ne hv] using hι v

def OriginalHigherZeroOnPalette (m : ℕ) (W : WeightsN N D K) (p : V N)
    (b h : Fin D) : Prop :=
  ∀ ι, OnPalette ι b h → ∀ r, 0 < r → r ≤ m →
    OddResponseVanishing.oddResponsePolynomial W p m r ι = 0

def DiagonalSource (W : WeightsN N D K) : Prop :=
  ∀ p q b h, b ≠ h → edgeMatrix W (p, b) (q, h) = 0

theorem scalar_boundary (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W) (hdiag : DiagonalSource W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (hz : OriginalHigherZeroOnPalette m W p b h)
    (ι : V (2 * (m + 1)) → Fin D) (hι : OnPalette ι b h) :
    ReplicaKernel.meanXAxis
      (pderiv 1 (endpointResponse m W p q b h
        (wordExponent ι (CofactorResponse.retainedVertices p q))) +
      C (edgeMatrix W (p, b) (q, b)) * X 0 * endpointResponse m W p q b h
        (wordExponent ι (CofactorResponse.retainedVertices p q))) =
      X 0 * C (coeff (wordExponent ι (CofactorResponse.retainedVertices p q))
        (pureRetainedWord p q b)) := by
  classical
  have he := mean_scalar_boundary m W hW p q hpq b h hbh
    (Function.update ι q b) (by simp) (hdiag p q h b hbh.symm)
    (hz (Function.update ι q b) (onPalette_update ι b h b q hι (Or.inl rfl)))
  rw [retainedExponent_update] at he
  rw [coeff_pureRootWord_eq_retained p q hpq _ b (by simp), retainedExponent_update] at he
  exact he

theorem mixed_boundary (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W) (hdiag : DiagonalSource W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (hz : OriginalHigherZeroOnPalette m W p b h)
    (ι : V (2 * (m + 1)) → Fin D) (hι : OnPalette ι b h) :
    ReplicaKernel.meanXAxis
      (pderiv 1 (pderiv 2 (endpointResponse m W p q b h
        (wordExponent ι (CofactorResponse.retainedVertices p q)))) +
      C (edgeMatrix W (p, b) (q, b)) * X 0 *
        pderiv 2 (endpointResponse m W p q b h
          (wordExponent ι (CofactorResponse.retainedVertices p q)))) = 0 := by
  classical
  have he := mean_mixed_boundary m W hW p q hpq b h hbh
    (Function.update ι q b) (by simp) (hdiag p q h b hbh.symm)
    (hz (Function.update ι q b) (onPalette_update ι b h b q hι (Or.inl rfl)))
  rw [retainedExponent_update] at he
  exact he

theorem v_boundary (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W) (hdiag : DiagonalSource W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (hz : OriginalHigherZeroOnPalette m W p b h)
    (ι : V (2 * (m + 1)) → Fin D) (hι : OnPalette ι b h) :
    ReplicaKernel.meanXAxis (pderiv 3 (endpointResponse m W p q b h
      (wordExponent ι (CofactorResponse.retainedVertices p q)))) = 0 := by
  classical
  have he := mean_v_boundary m W hW p q hpq b h hbh
    (Function.update ι q h) (by simp) (hdiag p q b h hbh)
    (hz (Function.update ι q h) (onPalette_update ι b h h q hι (Or.inr rfl)))
  rw [retainedExponent_update] at he
  exact he

omit [CharZero K] in
theorem retainedQuadratic_symm (W : WeightsN N D K) (p q : V N) :
    retainedQuadratic W p q = retainedQuadratic W q p := by
  exact eraseSite_commute q p (sourceQuadratic W)

omit [CharZero K] in
theorem retainedVertices_symm (p q : V N) :
    CofactorResponse.retainedVertices p q = CofactorResponse.retainedVertices q p :=
  List.erase_comm p q

omit [CharZero K] in
theorem eval_meanYAxis (P : ReplicaKernel.MeanPolynomial K) (a : Fin 4 → K) :
    eval a (ReplicaKernel.meanYAxis P) = eval ![0, a 1, 0, 0] P := by
  change eval₂ (RingHom.id K) a (eval₂ C ![0, X 1, 0, 0] P) = _
  rw [← eval₂_assoc]
  congr 1
  funext j
  fin_cases j <;> simp

theorem u_boundary (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W) (hdiag : DiagonalSource W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (hz : OriginalHigherZeroOnPalette m W q b h)
    (ι : V (2 * (m + 1)) → Fin D) (hι : OnPalette ι b h) :
    ReplicaKernel.meanYAxis (pderiv 2 (endpointResponse m W p q b h
      (wordExponent ι (CofactorResponse.retainedVertices p q)))) = 0 := by
  classical
  apply MvPolynomial.funext
  intro a
  rw [eval_meanYAxis, eval_pderiv_endpointResponse]
  have hrow : (∑ j : Fin 4, C (![0, a 1, 0, 0] j) * endpointRows W p q b h j) =
      C (a 1) * retainedRow W q p b := by simp [Fin.sum_univ_succ, endpointRows]
  rw [hrow]
  dsimp [endpointRows]
  have he := numerical_second_source_boundary m W hW q p hpq.symm b h hbh
    (Function.update ι p h) (by simp) (hdiag q p b h hbh)
    (hz (Function.update ι p h) (onPalette_update ι b h h p hι (Or.inr rfl))) (a 1) 0
  rw [retainedExponent_update q p ι h, retainedVertices_symm q p] at he
  rw [retainedQuadratic_symm W q p] at he
  simpa only [mul_zero, zero_mul, C_0, zero_add, add_zero, coeff_zero, map_zero] using he

omit [CharZero K] in
theorem eraseSite_idempotent (q : V N) (P : PhysicalPolynomial N D K) :
    eraseSite q (eraseSite q P) = eraseSite q P := by
  induction P using MvPolynomial.induction_on with
  | C c => simp
  | add P Q hP hQ => simp only [map_add, hP, hQ]
  | mul_X P z hP =>
    rw [map_mul, map_mul, hP]
    by_cases hq : z.1 = q <;> simp only [eraseSite_X, hq, ite_true, ite_false, map_zero]

omit [CharZero K] in

theorem coeff_erased_row_mul (q : V N) (L : List (V N)) (hq : q ∉ L)
    (ι : V N → Fin D) (row P : PhysicalPolynomial N D K) :
    coeff (wordExponent ι L) (eraseSite q row * P) =
      coeff (wordExponent ι L) (row * P) := by
  calc
    _ = coeff (wordExponent ι L) (eraseSite q (eraseSite q row * P)) :=
      (CofactorResponse.coeff_word_eraseSite q _ ι L hq).symm
    _ = coeff (wordExponent ι L) (eraseSite q (row * P)) := by
      simp only [map_mul, eraseSite_idempotent]
    _ = _ := CofactorResponse.coeff_word_eraseSite q _ ι L hq

omit [CharZero K] in

theorem coeff_retainedRow_pure_other (W : WeightsN N D K)
    (hdiag : DiagonalSource W) (p q : V N) (b h : Fin D) (hbh : b ≠ h)
    (P : PhysicalPolynomial N D K) :
    coeff (wordExponent (fun _ => h) (CofactorResponse.retainedVertices p q))
      (retainedRow W p q b * P) = 0 := by
  classical
  rw [retainedRow, coeff_erased_row_mul q _
    (by simp [CofactorResponse.mem_retainedVertices]), coeff_rowPolynomial_mul _ _ _ _
      (CofactorResponse.retainedVertices_nodup p q)]
  simp only [hdiag p _ b h hbh, zero_mul]
  have hz (L : List (V N)) : (L.map (fun _ => (0 : K))).sum = 0 := by
    induction L with
    | nil => rfl
    | cons v L ih => simp only [List.map_cons, List.sum_cons, ih, zero_add]
  exact hz _

theorem pure_second_response_pderiv_zero (m : ℕ) (W : WeightsN N D K)
    (hdiag : DiagonalSource W) (p q : V N) (b h : Fin D) (hbh : b ≠ h)
    (j : Fin 4) (hj : j = 0 ∨ j = 1) :
    pderiv j (endpointResponse m W p q b h
      (wordExponent (fun _ => h) (CofactorResponse.retainedVertices p q))) = 0 := by
  apply MvPolynomial.funext
  intro a
  rw [eval_pderiv_endpointResponse, map_zero]
  rcases hj with rfl | rfl
  · exact coeff_retainedRow_pure_other W hdiag p q b h hbh _
  · rw [retainedVertices_symm p q]
    exact coeff_retainedRow_pure_other W hdiag q p b h hbh _

theorem coeff_zero_of_pderiv_zero (P : ReplicaKernel.MeanPolynomial K)
    (i : Fin 4) (n : Fin 4 →₀ ℕ) (hn : n i ≠ 0) (hP : pderiv i P = 0) :
    coeff n P = 0 := by
  classical
  have hle : Finsupp.single i 1 ≤ n := Finsupp.single_le_iff.mpr (by omega)
  have hi : (n - Finsupp.single i 1 : Fin 4 →₀ ℕ) i + 1 = n i := by
    simp only [Finsupp.tsub_apply, Finsupp.single_eq_same]
    omega
  have hc := congrArg (coeff (n - Finsupp.single i 1)) hP
  have hiK : ((n - Finsupp.single i 1 : Fin 4 →₀ ℕ) i : K) + 1 = (n i : K) := by
    exact_mod_cast hi
  rw [coeff_pderiv, tsub_add_cancel_of_le hle, hiK, coeff_zero] at hc
  exact (mul_eq_zero.mp hc).resolve_right (Nat.cast_ne_zero.mpr hn)

theorem binaryMean_constant_of_pderiv_zero (P : ReplicaKernel.MeanPolynomial K)
    (h₀ : pderiv 0 P = 0) (h₁ : pderiv 1 P = 0) (i : Fin 2) :
    ReplicaKernel.binaryMean i P = C (eval (0 : Fin 4 → K) P) := by
  classical
  have hmon (n : Fin 4 →₀ ℕ) (hn : n ∈ P.support) :
      ReplicaKernel.binaryMean i (monomial n (coeff n P)) =
        C (eval (0 : Fin 4 → K) (monomial n (coeff n P))) := by
    have hn₀ : n 0 = 0 := by
      by_contra h
      exact (mem_support_iff.mp hn) (coeff_zero_of_pderiv_zero P 0 n h h₀)
    have hn₁ : n 1 = 0 := by
      by_contra h
      exact (mem_support_iff.mp hn) (coeff_zero_of_pderiv_zero P 1 n h h₁)
    simp only [ReplicaKernel.binaryMean, eval₂Hom_monomial, eval_monomial, map_mul]
    simp [Fin.prod_univ_succ, hn₀, hn₁]
  calc
    _ = ∑ n ∈ P.support, ReplicaKernel.binaryMean i (monomial n (coeff n P)) := by
      rw [← map_sum, ← as_sum P]
    _ = ∑ n ∈ P.support, C (eval (0 : Fin 4 → K) (monomial n (coeff n P))) := by
      apply Finset.sum_congr rfl
      intro n hn
      exact hmon n hn
    _ = _ := by rw [← map_sum, ← map_sum, ← as_sum P]

theorem pure_second_cap_binaryMean (m : ℕ) (W : WeightsN N D K)
    (hdiag : DiagonalSource W) (p q : V N) (b h : Fin D) (hbh : b ≠ h) (i : Fin 2) :
    ReplicaKernel.binaryMean i
      (pderiv 2 (pderiv 3 (endpointResponse m W p q b h
        (wordExponent (fun _ => h) (CofactorResponse.retainedVertices p q)))) +
       C (edgeMatrix W (p, h) (q, h)) * endpointResponse m W p q b h
        (wordExponent (fun _ => h) (CofactorResponse.retainedVertices p q))) =
      C (eval (0 : Fin 4 → K)
        (pderiv 2 (pderiv 3 (endpointResponse m W p q b h
          (wordExponent (fun _ => h) (CofactorResponse.retainedVertices p q)))) +
        C (edgeMatrix W (p, h) (q, h)) * endpointResponse m W p q b h
          (wordExponent (fun _ => h) (CofactorResponse.retainedVertices p q)))) := by
  apply binaryMean_constant_of_pderiv_zero _ _ _ i
  · rw [(pderiv (R := K) (σ := Fin 4) 0).map_add,
      mean_pderiv_commute _ 0 2, mean_pderiv_commute _ 0 3,
      pure_second_response_pderiv_zero m W hdiag p q b h hbh 0 (Or.inl rfl)]
    simp only [pderiv_C_mul,
      pure_second_response_pderiv_zero m W hdiag p q b h hbh 0 (Or.inl rfl),
      map_zero, mul_zero, zero_add]
  · rw [(pderiv (R := K) (σ := Fin 4) 1).map_add,
      mean_pderiv_commute _ 1 2, mean_pderiv_commute _ 1 3,
      pure_second_response_pderiv_zero m W hdiag p q b h hbh 1 (Or.inr rfl)]
    simp only [pderiv_C_mul,
      pure_second_response_pderiv_zero m W hdiag p q b h hbh 1 (Or.inr rfl),
      map_zero, mul_zero, zero_add]

theorem cap_origin (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W) (hdiag : DiagonalSource W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (hz : OriginalHigherZeroOnPalette m W p b h)
    (ι : V (2 * (m + 1)) → Fin D) (hι : OnPalette ι b h) :
    eval (0 : Fin 4 → K)
      (pderiv 2 (pderiv 3 (endpointResponse m W p q b h
        (wordExponent ι (CofactorResponse.retainedVertices p q)))) +
      C (edgeMatrix W (p, h) (q, h)) * endpointResponse m W p q b h
        (wordExponent ι (CofactorResponse.retainedVertices p q))) =
      coeff (wordExponent ι (CofactorResponse.retainedVertices p q))
        (pureRetainedWord p q h) := by
  classical
  have hs := mean_second_source_boundary m W hW p q hpq b h hbh
    (Function.update ι q h) (by simp) (hdiag p q b h hbh)
    (hz (Function.update ι q h) (onPalette_update ι b h h q hι (Or.inr rfl)))
  rw [retainedExponent_update, coeff_pureRootWord_eq_retained p q hpq _ h (by simp),
    retainedExponent_update] at hs
  have hd := congrArg (pderiv (R := K) (σ := Fin 4) 2) hs
  rw [pderiv_meanPplane_two] at hd
  rw [(pderiv (R := K) (σ := Fin 4) 2).map_add] at hd
  simp only [pderiv_mul, pderiv_C, pderiv_X_self, zero_mul, zero_add, mul_one] at hd
  have he := congrArg (eval (0 : Fin 4 → K)) hd
  rw [eval_meanPplane] at he
  have hvec : ![(0 : K), 0, 0, 0] = (0 : Fin 4 → K) := by
    funext j; fin_cases j <;> rfl
  simp only [Pi.zero_apply, hvec, map_add, map_mul, eval_C, eval_X, zero_mul,
    mul_zero, add_zero, map_one] at he
  simpa only [map_add, map_mul, eval_C, one_mul] using he

theorem pure_second_cap (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W) (hdiag : DiagonalSource W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (hz : OriginalHigherZeroOnPalette m W p b h) (i : Fin 2) :
    ReplicaKernel.binaryMean i
      (pderiv 2 (pderiv 3 (endpointResponse m W p q b h
        (wordExponent (fun _ => h) (CofactorResponse.retainedVertices p q)))) +
      C (edgeMatrix W (p, h) (q, h)) * endpointResponse m W p q b h
        (wordExponent (fun _ => h) (CofactorResponse.retainedVertices p q))) = 1 := by
  rw [pure_second_cap_binaryMean m W hdiag p q b h hbh i,
    cap_origin m W hW hdiag p q hpq b h hbh hz (fun _ => h) (fun _ => Or.inr rfl)]
  simp [pureRetainedWord]

omit [CharZero K] in
theorem evenResponse_zero_mean (m : ℕ) (Q : PhysicalPolynomial N D K) :
    EvenResponse.evenResponse (K := K) m Q 0 =
      EvenResponse.dividedPower (K := K) Q m := by
  classical
  unfold EvenResponse.evenResponse
  rw [Finset.sum_eq_single 0]
  · simp
  · intro r _ hr
    have hp : 2 * r ≠ 0 := by omega
    simp [EvenResponse.dividedPower, hp]
  · simp

theorem response_origin_eq_pureCofactor (m : ℕ)
    (W : WeightsN (2 * (m + 1)) D K)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) :
    eval (0 : Fin 4 → K) (endpointResponse m W p q b h
      (wordExponent (fun _ => b) (CofactorResponse.retainedVertices p q))) =
      RootResponse.pureCofactor W b p q := by
  classical
  rw [eval_endpointResponse]
  simp only [Pi.zero_apply, C_0, zero_mul, Finset.sum_const_zero]
  rw [evenResponse_zero_mean]
  have hp : p ∉ CofactorResponse.retainedVertices p q := by
    simp [CofactorResponse.mem_retainedVertices]
  have hq : q ∉ CofactorResponse.retainedVertices p q := by
    simp [CofactorResponse.mem_retainedVertices]
  have hex : EvenResponse.dividedPower (K := K) (retainedQuadratic W p q) m =
      eraseSite q (eraseSite p (dividedSourcePower W m)) := by
    simp [EvenResponse.dividedPower, retainedQuadratic, deletedQuadratic,
      dividedSourcePower]
  rw [hex, CofactorResponse.coeff_word_eraseSite q _ _ _ hq,
    CofactorResponse.coeff_word_eraseSite p _ _ _ hp]
  have hlen : (CofactorResponse.retainedVertices p q).length = 2 * m := by
    rw [CofactorResponse.retainedVertices_length p q hpq]
    omega
  rw [dividedSourcePower, coeff_C_mul,
    coeff_sourceQuadratic_pow W (fun _ => b) m _ hlen
      (List.Pairwise.erase q (List.Pairwise.erase p (vertices_pairwise_lt _))),
    RootResponse.pureCofactor, if_neg hpq, pmSumList]
  change (m.factorial : K)⁻¹ * ((m.factorial : K) *
      pmSumListAux W (fun _ => b) (2 * m) (CofactorResponse.retainedVertices p q)) =
    pmSumListAux W (fun _ => b) (CofactorResponse.retainedVertices p q).length
      (CofactorResponse.retainedVertices p q)
  rw [hlen]
  have hf : (m.factorial : K) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero m)
  rw [← mul_assoc, inv_mul_cancel₀ hf, one_mul]

open RetainedBinary

noncomputable def endpointTensor (m : ℕ) (W : WeightsN N D K)
    (p q : V N) (b h : Fin D) :
    (RetainedSites p q → Bool) → ReplicaKernel.MeanPolynomial K :=
  fun w => endpointResponse m W p q b h
    (wordExponent (receivingWord p q b h w) (CofactorResponse.retainedVertices p q))

theorem receivingWord_onPalette (p q : V N) (b h : Fin D)
    (w : RetainedSites p q → Bool) : OnPalette (receivingWord p q b h w) b h := by
  intro v
  unfold receivingWord
  split_ifs <;> simp

noncomputable def binaryKernel (p q : V N)
    (w z : RetainedSites p q → Bool) : K :=
  if z = BinaryPairing.complement w then BinaryPairing.sign w else 0

omit [CharZero K] in
theorem C_binarySign (p q : V N) (w : RetainedSites p q → Bool) :
    (C (BinaryPairing.sign (R := K) w) : ReplicaKernel.MeanPolynomial K) =
      BinaryPairing.sign w := by
  classical
  rw [BinaryPairing.sign, map_prod]
  apply Finset.prod_congr rfl
  intro v _
  cases w v <;> simp only [Bool.false_eq_true, if_false, if_true, map_one, map_neg]

omit [CharZero K] in

theorem contraction_eq_binaryPairing (p q : V N)
    (A B : (RetainedSites p q → Bool) → ReplicaKernel.MeanPolynomial K) :
    ReplicaKernel.contraction (binaryKernel (K := K) p q) A B =
      BinaryPairing.pairing A B := by
  classical
  unfold ReplicaKernel.contraction BinaryPairing.pairing
  refine Finset.sum_congr (by ext w; simp) ?_
  intro w _
  rw [Finset.sum_eq_single (BinaryPairing.complement w)]
  · simp only [binaryKernel, if_true, C_binarySign]
  · intro z _ hz
    simp only [binaryKernel, if_neg hz, map_zero, zero_mul]
  · simp

omit [CharZero K] in
theorem scalarContraction_eq_binaryPairing (p q : V N)
    (A B : (RetainedSites p q → Bool) → K) :
    ReplicaKernel.scalarContraction (binaryKernel (K := K) p q) A B =
      BinaryPairing.pairing A B := by
  classical
  unfold ReplicaKernel.scalarContraction BinaryPairing.pairing
  refine Finset.sum_congr (by ext w; simp) ?_
  intro w _
  rw [Finset.sum_eq_single (BinaryPairing.complement w)]
  · simp only [binaryKernel, if_true]
  · intro z _ hz
    simp only [binaryKernel, if_neg hz, zero_mul]
  · simp

theorem tensor_cap (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W) (hdiag : DiagonalSource W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (hz : OriginalHigherZeroOnPalette m W p b h) :
    ReplicaKernel.contraction (binaryKernel (K := K) p q)
      (fun w => C (BinaryPairing.pure false w))
      (fun w => ReplicaKernel.binaryMean 1
        (pderiv 2 (pderiv 3 (endpointTensor m W p q b h w)) +
          C (edgeMatrix W (p, h) (q, h)) * endpointTensor m W p q b h w)) = 1 := by
  rw [contraction_eq_binaryPairing]
  have hC : (fun w : RetainedSites p q → Bool =>
      (C (BinaryPairing.pure false w) : ReplicaKernel.MeanPolynomial K)) =
        BinaryPairing.pure false := by
    funext w
    unfold BinaryPairing.pure
    split_ifs <;> simp
  rw [hC, BinaryPairing.pairing_pure_false]
  change ReplicaKernel.binaryMean 1
    (pderiv 2 (pderiv 3 (endpointResponse m W p q b h
      (wordExponent (receivingWord p q b h (fun _ => true))
        (CofactorResponse.retainedVertices p q)))) +
      C (edgeMatrix W (p, h) (q, h)) * endpointResponse m W p q b h
        (wordExponent (receivingWord p q b h (fun _ => true))
          (CofactorResponse.retainedVertices p q))) = 1
  rw [receivingWord_true]
  exact pure_second_cap m W hW hdiag p q hpq b h hbh hz 1

theorem tensor_cap_origin (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W) (hdiag : DiagonalSource W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (hz : OriginalHigherZeroOnPalette m W p b h) (w : RetainedSites p q → Bool) :
    eval (0 : Fin 4 → K)
      (pderiv 2 (pderiv 3 (endpointTensor m W p q b h w)) +
        C (edgeMatrix W (p, h) (q, h)) * endpointTensor m W p q b h w) =
      BinaryPairing.pure true w := by
  rw [endpointTensor, cap_origin m W hW hdiag p q hpq b h hbh hz
    (receivingWord p q b h w) (receivingWord_onPalette p q b h w)]
  exact coeff_pureRetainedWord p q b h hbh w

omit [CharZero K] in
theorem receivingExponent_false (p q : V N) (b h : Fin D) :
    wordExponent (receivingWord p q b h (fun _ => false)) (CofactorResponse.retainedVertices p q) =
      wordExponent (fun _ => b) (CofactorResponse.retainedVertices p q) := by
  apply wordExponent_congr_on_list
  intro v hv
  have hpq := (CofactorResponse.mem_retainedVertices p q v).mp hv
  simp [receivingWord, hpq]

theorem tensor_origin (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W) (hdiag : DiagonalSource W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (hz : OriginalHigherZeroOnPalette m W p b h) :
    ReplicaKernel.scalarContraction (binaryKernel (K := K) p q)
      (fun w => eval (0 : Fin 4 → K) (endpointTensor m W p q b h w))
      (fun w => eval (0 : Fin 4 → K)
        (pderiv 2 (pderiv 3 (endpointTensor m W p q b h w)) +
          C (edgeMatrix W (p, h) (q, h)) * endpointTensor m W p q b h w)) =
      RootResponse.pureCofactor W b p q := by
  rw [scalarContraction_eq_binaryPairing]
  have hcap : (fun w : RetainedSites p q → Bool => eval (0 : Fin 4 → K)
      (pderiv 2 (pderiv 3 (endpointTensor m W p q b h w)) +
        C (edgeMatrix W (p, h) (q, h)) * endpointTensor m W p q b h w)) =
        BinaryPairing.pure true := by
    funext w
    exact tensor_cap_origin m W hW hdiag p q hpq b h hbh hz w
  rw [hcap, BinaryPairing.pairing_pure_right]
  simp only [Bool.not_true, BinaryPairing.sign_false, one_mul]
  rw [endpointTensor, receivingExponent_false]
  exact response_origin_eq_pureCofactor m W p q hpq b h

variable [IsAlgClosed K]

theorem endpoint_of_original_source (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (hW : EqSystemN (2 * (m + 1)) D W) (hdiag : DiagonalSource W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (hp : OriginalHigherZeroOnPalette m W p b h)
    (hq : OriginalHigherZeroOnPalette m W q b h)
    (hd : edgeMatrix W (p, b) (q, b) ≠ 0)
    (hcov : ReplicaKernel.KernelInvariant
      (ReplicaKernel.kernel (binaryKernel (K := K) p q) (endpointTensor m W p q b h))) :
    edgeMatrix W (p, b) (q, b) * RootResponse.pureCofactor W b p q = 1 := by
  have he := ReplicaKernel.endpoint_of_tensor_kernel
    (binaryKernel (K := K) p q) (endpointTensor m W p q b h)
    (BinaryPairing.pure false) (d := edgeMatrix W (p, b) (q, b))
    (e := edgeMatrix W (p, h) (q, h)) (β := 1) (η := 1)
    (α := RootResponse.pureCofactor W b p q) hd one_ne_zero hcov
    (fun w => u_boundary m W hW hdiag p q hpq b h hbh hq
      (receivingWord p q b h w) (receivingWord_onPalette p q b h w))
    (fun w => v_boundary m W hW hdiag p q hpq b h hbh hp
      (receivingWord p q b h w) (receivingWord_onPalette p q b h w))
    (fun w => mixed_boundary m W hW hdiag p q hpq b h hbh hp
      (receivingWord p q b h w) (receivingWord_onPalette p q b h w))
    (by
      intro w
      have hs := scalar_boundary m W hW hdiag p q hpq b h hbh hp
        (receivingWord p q b h w) (receivingWord_onPalette p q b h w)
      rw [coeff_pureRetainedWord_false p q b h hbh w] at hs
      simpa only [endpointTensor, map_one, mul_one] using hs)
    (by simpa only [map_one] using tensor_cap m W hW hdiag p q hpq b h hbh hp)
    (by simpa only [one_mul] using tensor_origin m W hW hdiag p q hpq b h hbh hp)
  exact he.symm
end Krenn.EndpointSource

-- formal/all-orders/PhysicalMeanWick.lean

namespace Krenn.PhysicalMeanWick

open scoped BigOperators
open MvPolynomial MatchingModel SiteAlgebra RootResponse
open WickCovariance WickPhysicalBridge WickRootBridge

variable {K τ : Type*} [Field K] [CharZero K] [Fintype τ] {N D : ℕ}

noncomputable def meanRow (W : WeightsN N D K) (z : τ → SiteVariable N D)
    (a : τ → K) : MatchingPolynomial N D K :=
  ∑ j, C (a j) * rowPolynomial (edgeMatrix W) (z j)

noncomputable def meanFunctional (W : WeightsN N D K) (z : τ → SiteVariable N D)
    (a : τ → K) : PhysicalSpace N D K →ₗ[K] K :=
  ∑ j, a j • physicalCovariance W (physicalBasis (z j))

omit [CharZero K] in
theorem meanFunctional_basis (W : WeightsN N D K) (z : τ → SiteVariable N D)
    (a : τ → K) (t : SiteVariable N D) :
    meanFunctional W z a (physicalBasis t) = ∑ j, a j * edgeMatrix W (z j) t := by
  simp [meanFunctional, physicalCovariance_basis]

omit [CharZero K] in
theorem selectedRestriction_meanRow (W : WeightsN N D K)
    (S : Finset (V N)) (ι : V N → Fin D) (z : τ → SiteVariable N D) (a : τ → K) :
    selectedRestriction S ι (meanRow W z a) =
      linearPolynomial (fun v : ↥S => meanFunctional W z a
        (physicalBasis (selectedInput S ι v))) := by
  classical
  simp only [meanRow, map_sum, map_mul]
  have hrow : ∀ j, selectedRestriction S ι (rowPolynomial (edgeMatrix W) (z j)) =
      linearPolynomial (fun v : ↥S => edgeMatrix W (z j) (selectedInput S ι v)) :=
    fun j => killCompl_linearPolynomial _ _ _
  simp only [selectedRestriction, MvPolynomial.killCompl_C] at hrow ⊢
  simp_rw [hrow]
  simp only [linearPolynomial, meanFunctional_basis, map_sum, map_mul, Finset.sum_mul,
    Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro v _
  apply Finset.sum_congr rfl
  intro j _
  ring

omit [CharZero K] in

theorem selectedRestriction_sourceQuadratic (W : WeightsN N D K)
    (S : Finset (V N)) (ι : V N → Fin D) :
    selectedRestriction S ι (sourceQuadratic W) =
      WickCoefficientBridge.symmetricQuadratic (fun u v : ↥S =>
        physicalCovariance W (physicalBasis (selectedInput S ι u))
          (physicalBasis (selectedInput S ι v))) := by
  change MvPolynomial.killCompl (selectedInput_injective S ι)
    (WickCoefficientBridge.symmetricQuadratic (edgeMatrix W)) = _
  rw [killCompl_symmetricQuadratic]
  simp only [physicalCovariance_basis]

theorem shiftedMoment_even_selected (W : WeightsN N D K)
    (S : Finset (V N)) (ι : V N → Fin D) (z : τ → SiteVariable N D) (a : τ → K)
    (m : ℕ) (hS : S.card = 2 * m) :
    shiftedMoment (physicalCovariance W) (meanFunctional W z a)
      (fun v : ↥S => physicalBasis (selectedInput S ι v)) =
      coeff (∑ v ∈ S, Finsupp.single (v, ι v) 1)
        (EvenResponse.evenResponse (K := K) m (sourceQuadratic W) (meanRow W z a)) := by
  rw [WickEvenResponse.shiftedMoment_eq_evenResponse _ _ _ m (by simpa using hS)]
  rw [← selectedRestriction_sourceQuadratic, ← selectedRestriction_meanRow]
  have he := EvenResponse.map_evenResponse (K := K) (selectedRestriction S ι).toRingHom
    (fun c => by simp [selectedRestriction]) m (sourceQuadratic W) (meanRow W z a)
  change selectedRestriction S ι (EvenResponse.evenResponse (K := K) m
    (sourceQuadratic W) (meanRow W z a)) = _ at he
  calc
    _ = coeff (WickCoefficientBridge.topExponent (↥S))
        (selectedRestriction S ι (EvenResponse.evenResponse (K := K) m
          (sourceQuadratic W) (meanRow W z a))) := congrArg _ he.symm
    _ = _ := coeff_selectedRestriction S ι _

noncomputable def meanFunctionalLinear (W : WeightsN N D K) (z : τ → SiteVariable N D) :
    (τ → K) →ₗ[K] (PhysicalSpace N D K →ₗ[K] K) where
  toFun := meanFunctional W z
  map_add' := by
    intro a b
    simp [meanFunctional, add_smul, Finset.sum_add_distrib]
  map_smul' := by
    intro t a
    simp [meanFunctional, mul_smul, Finset.smul_sum]

end Krenn.PhysicalMeanWick

-- formal/all-orders/RetainedMeanWick.lean

namespace Krenn.RetainedMeanWick

open scoped BigOperators
open MvPolynomial MatchingModel SiteAlgebra RootResponse CofactorResponse
open PhysicalEndpoint RetainedBinary WickCovariance WickPhysicalBridge PhysicalMeanWick

variable {K τ : Type*} [Field K] [CharZero K] [Fintype τ] {N D : ℕ}

noncomputable def coreRow (W : WeightsN N D K) (p q : V N) (z : SiteVariable N D) :
    PhysicalPolynomial N D K := eraseSite q (eraseSite p (rowPolynomial (edgeMatrix W) z))

omit [CharZero K] in
@[simp] theorem coreRow_left (W : WeightsN N D K) (p q : V N) (i : Fin D) :
    coreRow W p q (p, i) = retainedRow W p q i := by
  rw [coreRow, eraseSite_rowPolynomial]
  rfl

omit [CharZero K] in
@[simp] theorem coreRow_right (W : WeightsN N D K) (p q : V N) (i : Fin D) :
    coreRow W p q (q, i) = retainedRow W q p i := by
  rw [coreRow, eraseSite_commute, eraseSite_rowPolynomial]
  rfl

omit [CharZero K] in
theorem erased_meanRow (W : WeightsN N D K) (p q : V N)
    (z : τ → SiteVariable N D) (a : τ → K) :
    eraseSite q (eraseSite p (PhysicalMeanWick.meanRow W z a)) =
      ∑ j, C (a j) * coreRow W p q (z j) := by
  simp only [PhysicalMeanWick.meanRow, map_sum, map_mul, eraseSite_C, coreRow]

omit [CharZero K] in

theorem coeff_evenResponse_core (m : ℕ) (W : WeightsN N D K) (p q : V N)
    (ι : V N → Fin D) (z : τ → SiteVariable N D) (a : τ → K) :
    coeff (wordExponent ι (retainedVertices p q))
      (EvenResponse.evenResponse (K := K) m (sourceQuadratic W) (PhysicalMeanWick.meanRow W z a)) =
    coeff (wordExponent ι (retainedVertices p q))
      (EvenResponse.evenResponse (K := K) m (retainedQuadratic W p q)
        (∑ j, C (a j) * coreRow W p q (z j))) := by
  have hp : p ∉ retainedVertices p q := by simp [mem_retainedVertices]
  have hq : q ∉ retainedVertices p q := by simp [mem_retainedVertices]
  rw [← coeff_word_eraseSite p _ ι _ hp, ← coeff_word_eraseSite q _ ι _ hq]
  rw [EvenResponse.map_evenResponse (eraseSite p) (fun _ => eraseSite_C p _),
    EvenResponse.map_evenResponse (eraseSite q) (fun _ => eraseSite_C q _), erased_meanRow]
  rfl

theorem shiftedMoment_retained_even (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (ι : V (2 * (m + 1)) → Fin D)
    (z : τ → SiteVariable (2 * (m + 1)) D) (a : τ → K) :
    shiftedMoment (physicalCovariance W) (meanFunctional W z a)
      (fun v : RetainedSites p q => physicalBasis (v.val, ι v.val)) =
      coeff (wordExponent ι (retainedVertices p q))
        (EvenResponse.evenResponse (K := K) m (retainedQuadratic W p q)
          (∑ j, C (a j) * coreRow W p q (z j))) := by
  let L := retainedVertices p q
  let vals : ↥L.toFinset → PhysicalSpace (2 * (m + 1)) D K :=
    fun v => physicalBasis (selectedInput L.toFinset ι v)
  have hv : (fun v : RetainedSites p q => physicalBasis (v.val, ι v.val)) =
      fun v => vals (retainedListEquiv p q v) := rfl
  rw [hv, WickReplicaBridge.shiftedMoment_relabel _ _ (retainedListEquiv p q)]
  have hcard : L.toFinset.card = 2 * m := by
    rw [List.toFinset_card_of_nodup (retainedVertices_nodup p q), retainedVertices_length p q hpq]
    omega
  rw [shiftedMoment_even_selected W L.toFinset ι z a m hcard,
    ← wordExponent_eq_finset_sum ι L (retainedVertices_nodup p q)]
  exact coeff_evenResponse_core m W p q ι z a

noncomputable def coefficientTensor (m : ℕ) (W : WeightsN N D K)
    (p q : V N) (b h : Fin D) (z : Fin 4 → SiteVariable N D) :
    BinaryPairing.Tensor (RetainedSites p q) (ReplicaKernel.MeanPolynomial K) :=
  fun w => receivingPolynomial (wordExponent (receivingWord p q b h w) (retainedVertices p q))
    (physicalEvenResponse m (retainedQuadratic W p q) (fun j => coreRow W p q (z j)))

theorem eval_coefficientTensor (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D)
    (z : Fin 4 → SiteVariable (2 * (m + 1)) D)
    (w : RetainedSites p q → Bool) (a : Fin 4 → K) :
    eval a (coefficientTensor m W p q b h z w) =
      WickFinitePairing.responseTensor (physicalCovariance W) (meanFunctional W z a)
        (fun v : RetainedSites p q => physicalBasis (v.val, b))
        (fun v : RetainedSites p q => physicalBasis (v.val, h)) w := by
  rw [coefficientTensor, eval_receivingPolynomial, eval_physicalEvenResponse,
    ← shiftedMoment_retained_even m W p q hpq _ z a]
  unfold WickFinitePairing.responseTensor
  congr 1
  funext v
  rw [receivingWord_at_retained]
  cases w v <;> rfl

end Krenn.RetainedMeanWick

-- formal/all-orders/WickFiniteOrthogonal.lean

namespace Krenn.WickFiniteOrthogonal

open scoped Classical
open WickFinitePairing

variable {K E ι : Type*} [Field K] [CharZero K]
  [AddCommGroup E] [Module K E] [Fintype ι]

theorem response_pairing_linear (B : E →ₗ[K] E →ₗ[K] K)
    (μ ν : E →ₗ[K] K) (u v : ι → E) (a b c d : K)
    (h1 : a * a + c * c = 1) (h2 : b * b + d * d = 1)
    (h12 : a * b + c * d = 0) :
    BinaryPairing.pairing (responseTensor B (a • μ + c • ν) u v)
      (responseTensor B (b • μ + d • ν) u v) =
      (a * d - b * c) ^ Fintype.card ι *
        BinaryPairing.pairing (responseTensor B μ u v) (responseTensor B ν u v) := by
  let e := (Fintype.equivFin ι).symm
  have h := WickPairing.contractedShifted_linear B μ ν
    (fun i => u (e i)) (fun i => v (e i)) a b c d h1 h2 h12
  simp only [WickPairing.contractedShifted_eq_pairing] at h
  have hr (ξ : E →ₗ[K] K) :
      WickPairing.responseTensor B ξ (fun i => u (e i)) (fun i => v (e i)) =
        fun w => responseTensor B ξ u v (wordEquiv e w) := by
    funext w
    exact responseTensor_reindex B ξ u v e w
  simp only [hr, pairing_reindex] at h
  exact h

theorem response_pairing_orthogonal_even (B : E →ₗ[K] E →ₗ[K] K)
    (μ ν : E →ₗ[K] K) (u v : ι → E) (a b c d : K)
    (h1 : a * a + c * c = 1) (h2 : b * b + d * d = 1)
    (h12 : a * b + c * d = 0) (heven : Even (Fintype.card ι)) :
    BinaryPairing.pairing (responseTensor B (a • μ + c • ν) u v)
      (responseTensor B (b • μ + d • ν) u v) =
      BinaryPairing.pairing (responseTensor B μ u v) (responseTensor B ν u v) := by
  have hdet : (a * d - b * c) ^ 2 = 1 := by
    calc
      _ = (a * a + c * c) * (b * b + d * d) - (a * b + c * d) ^ 2 := by ring
      _ = 1 := by rw [h1, h2, h12]; ring
  have hpow : (a * d - b * c) ^ Fintype.card ι = 1 := by
    obtain ⟨k, hk⟩ := heven
    rw [hk, ← two_mul, pow_mul, hdet, one_pow]
  rw [response_pairing_linear B μ ν u v a b c d h1 h2 h12, hpow, one_mul]

end Krenn.WickFiniteOrthogonal

-- formal/all-orders/EndpointCovariance.lean

namespace Krenn.EndpointCovariance

open scoped BigOperators Matrix
open MvPolynomial MatchingModel SiteAlgebra RootResponse CofactorResponse PhysicalEndpoint
open EndpointSource RetainedBinary WickCovariance WickPhysicalBridge PhysicalMeanWick

variable {K : Type*} [Field K] [CharZero K] {N D : ℕ}

def endpointPoints (p q : V N) (b h : Fin D) : Fin 4 → SiteVariable N D :=
  ![(p, b), (q, b), (p, h), (q, h)]

omit [CharZero K] in
theorem coreRow_endpointPoints (W : WeightsN N D K) (p q : V N) (b h : Fin D)
    (j : Fin 4) :
    RetainedMeanWick.coreRow W p q (endpointPoints p q b h j) =
      endpointRows W p q b h j := by
  fin_cases j <;> simp [endpointPoints, endpointRows]

omit [CharZero K] in
theorem eval_meanCopy (i : Fin 2) (P : ReplicaKernel.MeanPolynomial K)
    (a : Fin 4 × Fin 2 → K) :
    eval a (ReplicaKernel.meanCopy i P) = eval (fun j => a (j, i)) P := by
  change eval₂ (RingHom.id K) a (eval₂ C _ P) = _
  rw [← eval₂_assoc]
  simp only [eval₂_X]
  rfl

omit [CharZero K] in
theorem eval_endpointKernel (m : ℕ) (W : WeightsN N D K) (p q : V N) (b h : Fin D)
    (a : Fin 4 × Fin 2 → K) :
    eval a (ReplicaKernel.kernel (binaryKernel (K := K) p q) (endpointTensor m W p q b h)) =
      BinaryPairing.pairing
        (fun w => eval (fun j => a (j, 0)) (endpointTensor m W p q b h w))
        (fun w => eval (fun j => a (j, 1)) (endpointTensor m W p q b h w)) := by
  rw [ReplicaKernel.kernel, ReplicaKernel.eval_contraction,
    scalarContraction_eq_binaryPairing]
  simp only [eval_meanCopy]

omit [CharZero K] in
theorem eval_replicaFramePullback (O : Matrix (Fin 2) (Fin 2) K)
    (P : ReplicaKernel.ReplicaPolynomial K) (a : Fin 4 × Fin 2 → K) :
    eval a (ReplicaKernel.replicaFramePullback O P) =
      eval (fun ji => ∑ k : Fin 2, O ji.2 k * a (ji.1, k)) P := by
  change eval₂ (RingHom.id K) a (eval₂ C _ P) = _
  rw [← eval₂_assoc]
  congr 1
  funext ji
  simp [ReplicaKernel.replicaFrameAssignment]

theorem eval_endpointTensor_eq_responseTensor (m : ℕ)
    (W : WeightsN (2 * (m + 1)) D K)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (a : Fin 4 → K)
    (w : RetainedSites p q → Bool) :
    eval a (endpointTensor m W p q b h w) =
      WickFinitePairing.responseTensor (physicalCovariance W)
        (meanFunctional W (endpointPoints p q b h) a)
        (fun v : RetainedSites p q => physicalBasis (v.val, b))
        (fun v : RetainedSites p q => physicalBasis (v.val, h)) w := by
  rw [endpointTensor, eval_endpointResponse]
  have hm := RetainedMeanWick.shiftedMoment_retained_even m W p q hpq
    (receivingWord p q b h w) (endpointPoints p q b h) a
  simp only [coreRow_endpointPoints] at hm
  rw [← hm]
  unfold WickFinitePairing.responseTensor
  congr 1
  funext v
  rw [receivingWord_at_retained]
  cases w v <;> rfl

omit [CharZero K] in
theorem meanFunctional_pair_transform (W : WeightsN N D K)
    (z : Fin 4 → SiteVariable N D) (a b : Fin 4 → K) (s t : K) :
    meanFunctional W z (fun j => s * a j + t * b j) =
      s • meanFunctional W z a + t • meanFunctional W z b := by
  change meanFunctionalLinear W z (s • a + t • b) = _
  rw [map_add, map_smul, map_smul]
  rfl

theorem endpoint_kernel_invariant (m : ℕ)
    (W : WeightsN (2 * (m + 1)) D K)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) :
    ReplicaKernel.KernelInvariant
      (ReplicaKernel.kernel (binaryKernel (K := K) p q) (endpointTensor m W p q b h)) := by
  intro O hO
  apply MvPolynomial.funext
  intro a
  rw [eval_replicaFramePullback, eval_endpointKernel, eval_endpointKernel]
  have ht (v : Fin 4 → K) :
      (fun w : RetainedSites p q → Bool => eval v (endpointTensor m W p q b h w)) =
        WickFinitePairing.responseTensor (physicalCovariance W)
          (meanFunctional W (endpointPoints p q b h) v)
          (fun r : RetainedSites p q => physicalBasis (r.val, b))
          (fun r : RetainedSites p q => physicalBasis (r.val, h)) := by
    funext w
    exact eval_endpointTensor_eq_responseTensor m W p q hpq b h v w
  rw [ht, ht, ht, ht]
  simp only [Fin.sum_univ_two]
  rw [meanFunctional_pair_transform, meanFunctional_pair_transform]
  have hoo : O * Oᵀ = 1 := mul_eq_one_comm.mp hO
  have h₀ : O 0 0 * O 0 0 + O 0 1 * O 0 1 = 1 := by
    have hh := congrArg (fun M : Matrix (Fin 2) (Fin 2) K => M 0 0) hoo
    simpa only [Matrix.mul_apply, Matrix.transpose_apply, Matrix.one_apply,
      Fin.sum_univ_two, if_true] using hh
  have h₁ : O 1 0 * O 1 0 + O 1 1 * O 1 1 = 1 := by
    have hh := congrArg (fun M : Matrix (Fin 2) (Fin 2) K => M 1 1) hoo
    simpa only [Matrix.mul_apply, Matrix.transpose_apply, Matrix.one_apply,
      Fin.sum_univ_two, if_true] using hh
  have h₀₁ : O 0 0 * O 1 0 + O 0 1 * O 1 1 = 0 := by
    have hh := congrArg (fun M : Matrix (Fin 2) (Fin 2) K => M 0 1) hoo
    simpa only [Matrix.mul_apply, Matrix.transpose_apply, Matrix.one_apply,
      Fin.sum_univ_two, if_neg (by decide : (0 : Fin 2) ≠ 1)] using hh
  have heven : Even (Fintype.card (RetainedSites p q)) := by
    rw [card_retainedSites p q hpq]
    exact ⟨m, by omega⟩
  exact WickFiniteOrthogonal.response_pairing_orthogonal_even (physicalCovariance W)
    (meanFunctional W (endpointPoints p q b h) (fun j => a (j, 0)))
    (meanFunctional W (endpointPoints p q b h) (fun j => a (j, 1)))
    (fun r : RetainedSites p q => physicalBasis (r.val, b))
    (fun r : RetainedSites p q => physicalBasis (r.val, h))
    (O 0 0) (O 1 0) (O 0 1) (O 1 1) h₀ h₁ h₀₁ heven

variable [IsAlgClosed K]

theorem supported_endpoint_from_original_binary_responses (m : ℕ)
    (W : WeightsN (2 * (m + 1)) D K) (hW : EqSystemN (2 * (m + 1)) D W)
    (hdiag : DiagonalSource W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D) (hbh : b ≠ h)
    (hp : OriginalHigherZeroOnPalette m W p b h)
    (hq : OriginalHigherZeroOnPalette m W q b h)
    (hd : edgeMatrix W (p, b) (q, b) ≠ 0) :
    edgeMatrix W (p, b) (q, b) * RootResponse.pureCofactor W b p q = 1 := by
  exact endpoint_of_original_source m W hW hdiag p q hpq b h hbh hp hq hd
    (endpoint_kernel_invariant m W p q hpq b h)

end Krenn.EndpointCovariance

-- formal/all-orders/BinarySourceInterface.lean

namespace Krenn.BinarySourceInterface

open MatchingModel SiteAlgebra RootResponse RetainedBinary

theorem originalHigherZeroOnPalette (m : ℕ)
    (W : WeightsN (2 * (m + 1)) 3 ℂ) (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p : V (2 * (m + 1))) (b h : Fin 3) :
    EndpointSource.OriginalHigherZeroOnPalette m W p b h := by
  intro ι hι r hpos hr
  apply WholeBinaryResponse.whole_binary_response_zero m r hr hpos W hW p ι
  exact ⟨b, h, fun v _ => hι v⟩

theorem receivingWord_onPalette {N D : ℕ} (p q : V N) (b h : Fin D)
    (w : RetainedSites p q → Bool) : EndpointSource.OnPalette (receivingWord p q b h w) b h := by
  intro v
  unfold receivingWord
  split_ifs <;> simp

theorem omitted_higher_zero (m : ℕ)
    (W : WeightsN (2 * (m + 1)) 3 ℂ) (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p q : V (2 * (m + 1))) (b h : Fin 3) (w : RetainedSites p q → Bool)
    (r : ℕ) (hpos : 0 < r) (hr : r ≤ m) :
    OddResponseVanishing.oddResponsePolynomial W p m r (receivingWord p q b h w) = 0 :=
  originalHigherZeroOnPalette m W hW p b h _ (receivingWord_onPalette p q b h w) r hpos hr

noncomputable def normTwo : ℂ := 2 * WholeBinaryResponse.halfRotation

theorem normTwo_sq : normTwo * normTwo = 2 := by
  have h := WholeBinaryResponse.halfRotation_normalized
  unfold normTwo
  linear_combination 2 * h

end Krenn.BinarySourceInterface

-- formal/all-orders/PairingDerivative.lean

namespace Krenn.PairingDerivative

open scoped BigOperators
open BinaryPairing

variable {ι R S σ : Type*} [Fintype ι] [CommRing R] [CommRing S]

theorem map_sign (f : R →+* S) (w : ι → Bool) :
    f (sign w) = sign w := by
  simp only [sign, map_prod]
  apply Finset.prod_congr rfl
  intro i _
  split_ifs <;> simp

theorem map_pairing (f : R →+* S) (E F : Tensor ι R) :
    f (pairing E F) = pairing (fun w => f (E w)) (fun w => f (F w)) := by
  simp only [pairing, map_sum, map_mul, map_sign]

theorem pderiv_pairing (z : σ) (E F : Tensor ι (MvPolynomial σ R)) :
    MvPolynomial.pderiv z (pairing E F) =
      pairing (fun w => MvPolynomial.pderiv z (E w)) F +
      pairing E (fun w => MvPolynomial.pderiv z (F w)) := by
  classical
  have hsign (w : ι → Bool) : (sign w : MvPolynomial σ R) = MvPolynomial.C (sign w : R) :=
    (map_sign MvPolynomial.C w).symm
  simp only [pairing, hsign, map_sum, MvPolynomial.pderiv_mul,
    MvPolynomial.pderiv_C, zero_mul, zero_add, Finset.sum_add_distrib]

theorem pderiv_pairing_self_even (heven : Even (Fintype.card ι))
    (z : σ) (E : Tensor ι (MvPolynomial σ R)) :
    MvPolynomial.pderiv z (pairing E E) =
      2 * pairing E (fun w => MvPolynomial.pderiv z (E w)) := by
  rw [pderiv_pairing, pairing_symmetric_of_even heven
    (fun w => MvPolynomial.pderiv z (E w)) E]
  ring

theorem differentiated_norm_two_rotation {K : Type*} [Field K] [CharZero K]
    (heven : Even (Fintype.card ι)) (z : σ) (s : K) (hsq : s * s = 2)
    (E F Es V Vs : Tensor ι (MvPolynomial σ K))
    (hE : ∀ w, MvPolynomial.pderiv z (E w) = V w)
    (hF : ∀ w, MvPolynomial.pderiv z (F w) = 0)
    (hEs : ∀ w, MvPolynomial.pderiv z (Es w) = MvPolynomial.C s * Vs w)
    (hrotation : pairing E E = pairing F Es) :
    MvPolynomial.C s * pairing E V = pairing F Vs := by
  have h := congrArg (MvPolynomial.pderiv z) hrotation
  rw [pderiv_pairing_self_even heven, pderiv_pairing] at h
  have he : (fun w => MvPolynomial.pderiv z (E w)) = V := funext hE
  have hf : (fun w => MvPolynomial.pderiv z (F w)) = 0 := funext hF
  have hes : (fun w => MvPolynomial.pderiv z (Es w)) = (MvPolynomial.C s : MvPolynomial σ K) • Vs := by
    funext w
    simpa only [Pi.smul_apply, smul_eq_mul] using hEs w
  rw [he, hf, hes, pairing_smul_right] at h
  have hz : pairing (0 : Tensor ι (MvPolynomial σ K)) Es = 0 := by simp [pairing]
  rw [hz, zero_add] at h
  have hs : s ≠ 0 := by
    intro hs
    simp [hs] at hsq
  have hCs : (MvPolynomial.C s : MvPolynomial σ K) ≠ 0 := MvPolynomial.C_ne_zero.mpr hs
  apply mul_left_cancel₀ hCs
  calc
    MvPolynomial.C s * (MvPolynomial.C s * pairing E V) = 2 * pairing E V := by
      rw [← mul_assoc, ← map_mul, hsq, map_ofNat]
    _ = _ := h

end Krenn.PairingDerivative

-- formal/all-orders/OmissionCancellation.lean

namespace Krenn.OmissionCancellation

variable {R M : Type*} [CommRing R] [IsDomain R]
  [AddCommGroup M] [Module R M]

theorem pairing_eq_of_response_and_rotation
    (B : M →ₗ[R] M →ₗ[R] R) (E F Es V Vs H : M) (s f d : R)
    (hs : s ≠ 0) (hf : f ≠ 0)
    (hV : V = f • H - d • E)
    (hVs : Vs = (s * f) • H - (s * d) • Es)
    (hrotation : B E E = B F Es)
    (hderivative : s * B E V = B F Vs) : B E H = B F H := by
  rw [hV, hVs] at hderivative
  simp only [map_sub, map_smul, smul_eq_mul] at hderivative
  rw [← hrotation] at hderivative
  apply mul_left_cancel₀ (mul_ne_zero hs hf)
  linear_combination hderivative

theorem pure_coefficient_eq_of_response_and_rotation
    {ι : Type*} [Fintype ι] (E F Es V Vs : BinaryPairing.Tensor ι R) (s f d : R)
    (hs : s ≠ 0) (hf : f ≠ 0)
    (hV : V = f • BinaryPairing.pure true - d • E)
    (hVs : Vs = (s * f) • BinaryPairing.pure true - (s * d) • Es)
    (hrotation : BinaryPairing.pairing E E = BinaryPairing.pairing F Es)
    (hderivative : s * BinaryPairing.pairing E V = BinaryPairing.pairing F Vs) :
    E (fun _ => false) = F (fun _ => false) := by
  have h := pairing_eq_of_response_and_rotation BinaryPairing.bilinearPairing
    E F Es V Vs (BinaryPairing.pure true) s f d hs hf hV hVs hrotation hderivative
  change BinaryPairing.pairing E (BinaryPairing.pure true) =
    BinaryPairing.pairing F (BinaryPairing.pure true) at h
  simpa only [BinaryPairing.pairing_right_pure_true] using h

theorem polarized_quadratic_coefficient_eq_zero
    {K A E : Type*} [Field K] [CharZero K] [CommRing A] [Algebra K A]
    [AddCommGroup E] [Module K E]
    (C : A →ₗ[K] K) (L : E →ₗ[K] A) (Q : A)
    (hzero : ∀ v, C ((L v) ^ 2 * Q) = 0) (v w : E) :
    C (L v * L w * Q) = 0 := by
  have hexpand : L (v + w) ^ 2 * Q =
      L v ^ 2 * Q + L w ^ 2 * Q + (2 : K) • (L v * L w * Q) := by
    rw [map_add]
    simp only [Algebra.smul_def, map_ofNat]
    ring
  have h := hzero (v + w)
  rw [hexpand, map_add, map_add, map_smul, hzero v, hzero w] at h
  simp only [zero_add, smul_eq_mul] at h
  exact (mul_eq_zero.mp h).resolve_left (by norm_num)

end Krenn.OmissionCancellation

-- formal/all-orders/OmissionDegree.lean

namespace Krenn.OmissionDegree

open scoped BigOperators
open MatchingModel SiteAlgebra EvenResponse

variable {K : Type*} [Field K] [CharZero K]

theorem quadratic_coefficient_zero_of_constant_even_series
    (k : ℕ) (c : ℕ → K)
    (hconstant : ∀ t : K, (∑ r ∈ Finset.range (k + 2), c r * t ^ (2 * r)) = c 0) :
    c 1 = 0 := by
  classical
  let P : Polynomial K := ∑ r ∈ Finset.range (k + 2),
    Polynomial.C (c r) * Polynomial.X ^ (2 * r)
  have hP : P = Polynomial.C (c 0) := by
    apply Polynomial.funext
    intro t
    simpa only [P, Polynomial.eval_finsetSum, Polynomial.eval_mul,
      Polynomial.eval_C, Polynomial.eval_pow, Polynomial.eval_X] using hconstant t
  have hc := congrArg (fun p : Polynomial K => p.coeff 2) hP
  simp only [P, Polynomial.finsetSum_coeff, Polynomial.coeff_C_mul_X_pow,
    Polynomial.coeff_C] at hc
  rw [Finset.sum_eq_single 1] at hc
  · simpa using hc
  · intro r _ hr
    simp [hr]
  · simp

omit [CharZero K] in

theorem dividedPower_C_mul {σ : Type*} (P : MvPolynomial σ K) (a : K) (n : ℕ) :
    dividedPower (K := K) (MvPolynomial.C a * P) n =
      MvPolynomial.C (a ^ n) * dividedPower (K := K) P n := by
  simp only [dividedPower, Algebra.algebraMap_self, RingHom.id_apply,
    mul_pow, map_pow]
  ring

theorem squared_row_coefficient_zero {σ : Type*}
    (k : ℕ) (Q L : MvPolynomial σ K) (m : σ →₀ ℕ)
    (hconstant : ∀ t : K,
      MvPolynomial.coeff m (evenResponse (K := K) (k + 1) Q (MvPolynomial.C t * L)) =
        MvPolynomial.coeff m (dividedPower (K := K) Q (k + 1))) :
    MvPolynomial.coeff m (L ^ 2 * dividedPower (K := K) Q k) = 0 := by
  classical
  let c : ℕ → K := fun r => MvPolynomial.coeff m
    (dividedPower (K := K) L (2 * r) * dividedPower (K := K) Q (k + 1 - r))
  have hc : c 1 = 0 := by
    apply quadratic_coefficient_zero_of_constant_even_series k c
    intro t
    have ht := hconstant t
    simp only [evenResponse, MvPolynomial.coeff_sum, dividedPower_C_mul,
      mul_assoc, MvPolynomial.coeff_C_mul] at ht
    simp only [c, Nat.mul_zero, dividedPower_zero, Nat.sub_zero, one_mul]
    simpa only [Nat.add_assoc, show (1 + 1 : ℕ) = 2 from rfl, mul_comm] using ht
  have hfac : ((2 : ℕ).factorial : K)⁻¹ ≠ 0 := inv_ne_zero (by norm_num)
  apply (mul_eq_zero.mp (show ((2 : ℕ).factorial : K)⁻¹ *
    MvPolynomial.coeff m (L ^ 2 * dividedPower (K := K) Q k) = 0 from ?_)).resolve_left hfac
  simpa only [c, Nat.mul_one, Nat.add_sub_cancel, dividedPower, Algebra.algebraMap_self,
    RingHom.id_apply, mul_assoc, MvPolynomial.coeff_C_mul] using hc

theorem two_row_coefficient_zero {σ E : Type*} [AddCommGroup E] [Module K E]
    (k : ℕ) (Q : MvPolynomial σ K) (L : E →ₗ[K] MvPolynomial σ K)
    (m : σ →₀ ℕ)
    (hconstant : ∀ v, MvPolynomial.coeff m (evenResponse (K := K) (k + 1) Q (L v)) =
      MvPolynomial.coeff m (dividedPower (K := K) Q (k + 1))) (v w : E) :
    MvPolynomial.coeff m (L v * L w * dividedPower (K := K) Q k) = 0 := by
  apply OmissionCancellation.polarized_quadratic_coefficient_eq_zero
    (MvPolynomial.lcoeff K m) L (dividedPower (K := K) Q k) _ v w
  intro u
  apply squared_row_coefficient_zero k Q (L u) m
  intro t
  have ht := hconstant (t • u)
  simpa only [map_smul, MvPolynomial.smul_eq_C_mul] using ht

noncomputable def omittedRowLinear {N D : ℕ} (W : WeightsN N D K)
    (p q : V N) : (Fin D → K) →ₗ[K] MatchingPolynomial N D K where
  toFun a := RootResponse.eraseSite q (OddResponseVanishing.rowAt W p a)
  map_add' := by
    intro a b
    simp [OddResponseVanishing.rowAt, RootResponse.rootFamilyRow,
      add_mul, Finset.sum_add_distrib]
  map_smul' := by
    intro t a
    simp [OddResponseVanishing.rowAt, RootResponse.rootFamilyRow,
      MvPolynomial.smul_eq_C_mul, mul_assoc, Finset.mul_sum]

omit [CharZero K] in
@[simp]
theorem omittedRowLinear_single {N D : ℕ} (W : WeightsN N D K)
    (p q : V N) (i : Fin D) :
    omittedRowLinear W p q (Pi.single i 1) =
      RootResponse.eraseSite q (rowPolynomial (edgeMatrix W) (p, i)) := by
  classical
  simp [omittedRowLinear, OddResponseVanishing.rowAt, RootResponse.rootFamilyRow,
    Pi.single_apply]

theorem omitted_two_row_zero_of_pure_even_constancy {N D : ℕ}
    (k : ℕ) (W : WeightsN N D K) (p q : V N) (i h : Fin D)
    (hconstant : ∀ a : Fin D → K,
      MvPolynomial.coeff (wordExponent (fun _ => h) (CofactorResponse.retainedVertices p q))
        (evenResponse (K := K) (k + 1)
          (RootResponse.eraseSite q (RootResponse.deletedQuadratic W p))
          (omittedRowLinear W p q a)) =
      MvPolynomial.coeff (wordExponent (fun _ => h) (CofactorResponse.retainedVertices p q))
        (dividedPower (K := K)
          (RootResponse.eraseSite q (RootResponse.deletedQuadratic W p)) (k + 1))) :
    MvPolynomial.coeff (wordExponent (fun _ => h) (CofactorResponse.retainedVertices p q))
      (CofactorResponse.omittedTwoRowPolynomial W p q i h k) = 0 := by
  have hz := two_row_coefficient_zero k _ (omittedRowLinear W p q) _ hconstant
    (Pi.single i 1) (Pi.single h 1)
  simpa only [omittedRowLinear_single, CofactorResponse.omittedTwoRowPolynomial,
    dividedPower, Algebra.algebraMap_self, RingHom.id_apply] using hz

end Krenn.OmissionDegree

-- formal/all-orders/OmissionTensor.lean

namespace Krenn.OmissionTensor

open scoped BigOperators
open MvPolynomial MatchingModel SiteAlgebra RootResponse CofactorResponse PhysicalEndpoint RetainedBinary

variable {K : Type*} [Field K] [CharZero K] {N : ℕ}

noncomputable def omissionRows (W : WeightsN N 3 K) (p q : V N) (h : Fin 3) :
    Fin 4 → PhysicalPolynomial N 3 K :=
  ![retainedRow W p q 0, retainedRow W p q 1, retainedRow W p q 2, retainedRow W q p h]

noncomputable def responseTensor (m : ℕ) (W : WeightsN N 3 K) (p q : V N) (b h : Fin 3) :
    BinaryPairing.Tensor (RetainedSites p q) (ReplicaKernel.MeanPolynomial K) :=
  fun w => receivingPolynomial (wordExponent (receivingWord p q b h w) (retainedVertices p q))
    (physicalEvenResponse m (retainedQuadratic W p q) (omissionRows W p q h))

noncomputable def directionZero : ReplicaKernel.MeanPolynomial K →+*
    ReplicaKernel.MeanPolynomial K := eval₂Hom C (fun j => if j = 3 then 0 else X j)

omit [CharZero K] in
@[simp] theorem directionZero_C (a : K) : directionZero (C a) = C a := by
  simp [directionZero]

omit [CharZero K] in
@[simp] theorem directionZero_X (j : Fin 4) :
    directionZero (X j : ReplicaKernel.MeanPolynomial K) = if j = 3 then 0 else X j := by
  simp [directionZero]

omit [CharZero K] in
theorem eval_directionZero (P : ReplicaKernel.MeanPolynomial K) (a : Fin 4 → K) :
    eval a (directionZero P) = eval (fun j => if j = 3 then 0 else a j) P := by
  change eval₂ (RingHom.id K) a (eval₂ C (fun j => if j = 3 then 0 else X j) P) = _
  rw [← eval₂_assoc]
  congr 1
  funext j
  by_cases hj : j = 3 <;> simp [hj]

omit [CharZero K] in
theorem omissionRows_castSucc (W : WeightsN N 3 K) (p q : V N) (h i : Fin 3) :
    omissionRows W p q h i.castSucc = retainedRow W p q i := by
  fin_cases i <;> rfl

omit [CharZero K] in
theorem omissionRows_three (W : WeightsN N 3 K) (p q : V N) (h : Fin 3) :
    omissionRows W p q h 3 = retainedRow W q p h := rfl

omit [CharZero K] in

theorem mean_omissionRows_directionZero (W : WeightsN N 3 K)
    (p q : V N) (h : Fin 3) (a : Fin 4 → K) :
    (∑ j : Fin 4, C (if j = 3 then 0 else a j) * omissionRows W p q h j) =
      eraseSite q (OddResponseVanishing.rowAt W p (fun i => a i.castSucc)) := by
  simp [Fin.sum_univ_succ, omissionRows, OddResponseVanishing.rowAt,
    rootFamilyRow, retainedRow]

omit [CharZero K] in

theorem eval_directionZero_responseTensor (m : ℕ) (W : WeightsN N 3 K)
    (p q : V N) (b h : Fin 3) (w : RetainedSites p q → Bool) (a : Fin 4 → K) :
    eval a (directionZero (responseTensor m W p q b h w)) =
      coeff (wordExponent (receivingWord p q b h w) (retainedVertices p q))
        (EvenResponse.evenResponse (K := K) m (retainedQuadratic W p q)
          (eraseSite q (OddResponseVanishing.rowAt W p (fun i => a i.castSucc)))) := by
  rw [eval_directionZero, responseTensor, eval_receivingPolynomial,
    eval_physicalEvenResponse, mean_omissionRows_directionZero]

theorem eval_directionZero_pderiv_responseTensor (m : ℕ) (W : WeightsN N 3 K)
    (p q : V N) (b h : Fin 3) (w : RetainedSites p q → Bool) (a : Fin 4 → K) :
    eval a (directionZero (pderiv 3 (responseTensor m W p q b h w))) =
      coeff (wordExponent (receivingWord p q b h w) (retainedVertices p q))
        (retainedRow W q p h *
          EvenResponse.lowerOddResponse (K := K) m (retainedQuadratic W p q)
            (eraseSite q (OddResponseVanishing.rowAt W p (fun i => a i.castSucc)))) := by
  rw [eval_directionZero, responseTensor, ← receivingPolynomial_pderiv,
    pderiv_physicalEvenResponse, eval_receivingPolynomial]
  simp only [map_mul, eval_C, omissionRows_three]
  rw [EvenResponse.map_lowerOddResponse (eval
    (fun j => C (if j = 3 then 0 else a j))) (fun _ => by simp)]
  simp only [eval_C, meanRow, map_sum, map_mul, eval_X]
  rw [mean_omissionRows_directionZero]

noncomputable def directPolynomial (W : WeightsN N 3 K) (p q : V N) (h : Fin 3) :
    ReplicaKernel.MeanPolynomial K :=
  ∑ i : Fin 3, X i.castSucc * C (edgeMatrix W (p, i) (q, h))

omit [CharZero K] in
theorem eval_directPolynomial (W : WeightsN N 3 K) (p q : V N) (h : Fin 3)
    (a : Fin 4 → K) :
    eval a (directPolynomial W p q h) =
      ∑ i : Fin 3, a i.castSucc * edgeMatrix W (p, i) (q, h) := by
  simp [directPolynomial]

omit [CharZero K] in
theorem rootExtract_rowAt (W : WeightsN N 3 K) (p q : V N) (h : Fin 3)
    (a : Fin 3 → K) :
    rootExtract q h (OddResponseVanishing.rowAt W p a) =
      C (∑ i : Fin 3, a i * edgeMatrix W (p, i) (q, h)) := by
  simp only [OddResponseVanishing.rowAt, rootFamilyRow, rootExtract,
    map_sum, pderiv_C_mul, EvenResponse.pderiv_rowPolynomial,
    map_mul, eraseSite_C]

theorem omitted_source_polynomial (m : ℕ) (W : WeightsN (2 * (m + 1)) 3 K)
    (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin 3) (hbh : b ≠ h)
    (w : RetainedSites p q → Bool)
    (hzero : ∀ r, 0 < r → r ≤ m →
      OddResponseVanishing.oddResponsePolynomial W p m r (receivingWord p q b h w) = 0) :
    directionZero (pderiv 3 (responseTensor m W p q b h w)) =
      X h.castSucc * C (BinaryPairing.pure true w : K) -
        directPolynomial W p q h * directionZero (responseTensor m W p q b h w) := by
  classical
  apply MvPolynomial.funext
  intro a
  rw [eval_directionZero_pderiv_responseTensor]
  simp only [map_sub, map_mul, eval_X, eval_C, eval_directPolynomial,
    eval_directionZero_responseTensor]
  have hs := OmittedResponse.coeff_omitted_source m W hW p q hpq
    (receivingWord p q b h w) (fun i => a i.castSucc) hzero
  rw [receivingWord_at_q, rootExtract_rowAt,
    extractedQuadratic_eq_retainedRow W p q h hpq, coeff_add, coeff_C_mul] at hs
  have hrhs : (∑ i : Fin 3, a i.castSucc *
      coeff (wordExponent (receivingWord p q b h w) ((vertices (2 * (m + 1))).erase p))
        (pureRootWord p i)) = a h.castSucc * (BinaryPairing.pure true w : K) := by
    rw [Finset.sum_eq_single h]
    · rw [coeff_pureRootWord_eq_retained p q hpq _ h (receivingWord_at_q p q b h w),
        coeff_pureRetainedWord p q b h hbh w]
    · intro i _ hi
      rw [coeff_pureRootWord_wrong_color p q hpq _ i
        (by simpa only [receivingWord_at_q] using hi), mul_zero]
    · simp
  rw [hrhs] at hs
  exact eq_sub_of_add_eq' hs

end Krenn.OmissionTensor

-- formal/all-orders/OmissionRotation.lean

namespace Krenn.OmissionRotation

open scoped BigOperators
open MvPolynomial MatchingModel SiteAlgebra RootResponse CofactorResponse
open PhysicalEndpoint RetainedBinary WickCovariance WickPhysicalBridge PhysicalMeanWick
open RetainedMeanWick OmissionTensor BinaryPairing FiniteResponseRigidity

variable {K : Type*} [Field K] [CharZero K] {N D : ℕ}

noncomputable def constantTensor {ι : Type*}
    (E : BinaryPairing.Tensor ι (ReplicaKernel.MeanPolynomial K)) :
    BinaryPairing.Tensor ι (ReplicaKernel.MeanPolynomial K) :=
  fun w => C (eval (fun _ => 0) (E w))

omit [CharZero K] in
theorem eval_scaleVariables (s : K) (P : ReplicaKernel.MeanPolynomial K) (a : Fin 4 → K) :
    eval a (scaleVariables s P) = eval (fun i => s * a i) P := by
  change eval₂ (RingHom.id K) a (eval₂ C (fun i => C s * X i) P) = _
  rw [← eval₂_assoc]
  congr 1
  funext i
  simp

theorem coefficientTensor_rotation (m : ℕ) (W : WeightsN (2 * (m + 1)) D K)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin D)
    (z : Fin 4 → SiteVariable (2 * (m + 1)) D) (s : K) (hs : s * s = 2) :
    pairing (coefficientTensor m W p q b h z) (coefficientTensor m W p q b h z) =
      pairing (constantTensor (coefficientTensor m W p q b h z))
        (fun w => scaleVariables s (coefficientTensor m W p q b h z w)) := by
  classical
  apply MvPolynomial.funext
  intro a
  simp only [PairingDerivative.map_pairing, constantTensor, eval_C, eval_scaleVariables]
  have hE : (fun w => eval a (coefficientTensor m W p q b h z w)) =
      WickFinitePairing.responseTensor (physicalCovariance W) (meanFunctional W z a)
        (fun v : RetainedSites p q => physicalBasis (v.val, b))
        (fun v : RetainedSites p q => physicalBasis (v.val, h)) := by
    funext w
    exact eval_coefficientTensor m W p q hpq b h z w a
  have hF : (fun w => eval (fun _ => 0) (coefficientTensor m W p q b h z w)) =
      WickFinitePairing.responseTensor (physicalCovariance W) 0
        (fun v : RetainedSites p q => physicalBasis (v.val, b))
        (fun v : RetainedSites p q => physicalBasis (v.val, h)) := by
    funext w
    rw [eval_coefficientTensor m W p q hpq]
    simp [meanFunctional]
  have hEs : (fun w => eval (fun i => s * a i) (coefficientTensor m W p q b h z w)) =
      WickFinitePairing.responseTensor (physicalCovariance W) (s • meanFunctional W z a)
        (fun v : RetainedSites p q => physicalBasis (v.val, b))
        (fun v : RetainedSites p q => physicalBasis (v.val, h)) := by
    funext w
    rw [eval_coefficientTensor m W p q hpq]
    congr 2
    exact (meanFunctionalLinear W z).map_smul s a
  rw [hE, hF, hEs]
  exact WickFinitePairing.response_pairing_diagonal _ _ _ _ s hs

def omissionPoints (p q : V N) (h : Fin 3) : Fin 4 → SiteVariable N 3 :=
  ![(p, 0), (p, 1), (p, 2), (q, h)]

omit [CharZero K] in
theorem coefficientTensor_omission (m : ℕ) (W : WeightsN N 3 K)
    (p q : V N) (b h : Fin 3) :
    coefficientTensor m W p q b h (omissionPoints p q h) =
      OmissionTensor.responseTensor m W p q b h := by
  have hrows : (fun j => coreRow W p q (omissionPoints p q h j)) = omissionRows W p q h := by
    funext j
    fin_cases j <;> simp [omissionPoints, omissionRows]
  funext w
  simp only [coefficientTensor, OmissionTensor.responseTensor, hrows]

theorem omitted_tensor_rotation (m : ℕ) (W : WeightsN (2 * (m + 1)) 3 K)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin 3) (s : K) (hs : s * s = 2) :
    pairing (OmissionTensor.responseTensor m W p q b h)
      (OmissionTensor.responseTensor m W p q b h) =
      pairing (constantTensor (OmissionTensor.responseTensor m W p q b h))
        (fun w => scaleVariables s (OmissionTensor.responseTensor m W p q b h w)) := by
  simpa only [coefficientTensor_omission] using
    coefficientTensor_rotation m W p q hpq b h (omissionPoints p q h) s hs

end Krenn.OmissionRotation

-- formal/all-orders/OmissionConstancy.lean

namespace Krenn.OmissionConstancy

open scoped BigOperators
open MvPolynomial MatchingModel SiteAlgebra RootResponse CofactorResponse
open PhysicalEndpoint RetainedBinary OmissionTensor OmissionRotation
open BinaryPairing FiniteResponseRigidity

variable {K : Type*} [Field K] [CharZero K]

omit [CharZero K] in
@[simp] theorem scaleVariables_X {σ : Type*} (s : K) (i : σ) :
    scaleVariables s (X i : MvPolynomial σ K) = C s * X i := by
  simp [scaleVariables]

omit [CharZero K] in
@[simp] theorem scaleVariables_C {σ : Type*} (s a : K) :
    scaleVariables s (C a : MvPolynomial σ K) = C a := by
  simp [scaleVariables]

omit [CharZero K] in

theorem pderiv_scaleVariables {σ : Type*} (j : σ) (s : K)
    (P : MvPolynomial σ K) :
    pderiv j (scaleVariables s P) = C s * scaleVariables s (pderiv j P) := by
  classical
  induction P using MvPolynomial.induction_on with
  | C a => simp
  | add P Q hP hQ => simp [hP, hQ, mul_add]
  | mul_X P i hP =>
    by_cases hi : i = j
    · subst i
      simp only [map_mul, scaleVariables_X, pderiv_mul, pderiv_C,
        pderiv_X_self, mul_one, hP, map_add, zero_mul, zero_add]
      ring
    · simp only [map_mul, scaleVariables_X, pderiv_mul, pderiv_C,
        pderiv_X_of_ne hi, mul_zero, add_zero, hP]
      ring

omit [CharZero K] in

theorem directionZero_scaleVariables (s : K) (P : ReplicaKernel.MeanPolynomial K) :
    directionZero (scaleVariables s P) = scaleVariables s (directionZero P) := by
  have h : directionZero.comp (scaleVariables s) =
      (scaleVariables s).comp directionZero := by
    ext j <;> simp [directionZero, scaleVariables]
    split_ifs <;> simp
  exact RingHom.congr_fun h P

omit [CharZero K] in
theorem scale_directPolynomial {N : ℕ} (s : K) (W : WeightsN N 3 K)
    (p q : V N) (h : Fin 3) :
    scaleVariables s (directPolynomial W p q h) = C s * directPolynomial W p q h := by
  simp only [directPolynomial, map_sum, map_mul, scaleVariables_X,
    scaleVariables_C, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  ring

omit [CharZero K] in
theorem map_pure {R S ι : Type*} [CommRing R] [CommRing S] [Fintype ι]
    (f : R →+* S) (b : Bool) (w : ι → Bool) :
    f (BinaryPairing.pure b w) = BinaryPairing.pure b w := by
  classical
  simp [BinaryPairing.pure]

theorem pure_tensor_constancy (m : ℕ) (W : WeightsN (2 * (m + 1)) 3 K)
    (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin 3) (hbh : b ≠ h)
    (s : K) (hsq : s * s = 2)
    (hzero : ∀ w : RetainedSites p q → Bool, ∀ r, 0 < r → r ≤ m →
      OddResponseVanishing.oddResponsePolynomial W p m r
        (receivingWord p q b h w) = 0) :
    directionZero (OmissionTensor.responseTensor m W p q b h (fun _ => false)) =
      C (eval (fun _ => 0)
        (OmissionTensor.responseTensor m W p q b h (fun _ => false))) := by
  classical
  let E := OmissionTensor.responseTensor m W p q b h
  let F := constantTensor E
  let Es := fun w => scaleVariables s (E w)
  let Vt := fun w => pderiv 3 (E w)
  let Vst := fun w => scaleVariables s (Vt w)
  have heven : Even (Fintype.card (RetainedSites p q)) := by
    rw [card_retainedSites p q hpq]
    exact ⟨m, by omega⟩
  have hrot := omitted_tensor_rotation m W p q hpq b h s hsq
  have hder : C s * pairing E Vt = pairing F Vst := by
    apply PairingDerivative.differentiated_norm_two_rotation heven 3 s hsq
      E F Es Vt Vst
    · intro w; rfl
    · intro w; exact pderiv_C
    · intro w; exact pderiv_scaleVariables 3 s (E w)
    · exact hrot
  let E0 := fun w => directionZero (E w)
  let F0 := fun w => directionZero (F w)
  let Es0 := fun w => directionZero (Es w)
  let V0 := fun w => directionZero (Vt w)
  let Vs0 := fun w => directionZero (Vst w)
  have hrot0 : pairing E0 E0 = pairing F0 Es0 := by
    have hh := congrArg directionZero hrot
    simpa only [PairingDerivative.map_pairing] using hh
  have hder0 : C s * pairing E0 V0 = pairing F0 Vs0 := by
    have hh := congrArg directionZero hder
    simpa only [map_mul, directionZero_C, PairingDerivative.map_pairing] using hh
  have hV0 : V0 = (X h.castSucc : ReplicaKernel.MeanPolynomial K) •
      BinaryPairing.pure true - directPolynomial W p q h • E0 := by
    funext w
    change directionZero (pderiv 3 (responseTensor m W p q b h w)) =
      X h.castSucc * BinaryPairing.pure true w -
        directPolynomial W p q h * directionZero (responseTensor m W p q b h w)
    rw [omitted_source_polynomial m W hW p q hpq b h hbh w (hzero w),
      map_pure (MvPolynomial.C (σ := Fin 4) (R := K)) true w]
  have hVs0 : Vs0 = (C s * X h.castSucc) • BinaryPairing.pure true -
      (C s * directPolynomial W p q h) • Es0 := by
    funext w
    have hh := congrArg (scaleVariables s) (congrFun hV0 w)
    simpa only [Vs0, Vst, Vt, E0, Es0, Es, directionZero_scaleVariables,
      Pi.sub_apply, Pi.smul_apply, smul_eq_mul, map_sub, map_mul,
      scale_directPolynomial, scaleVariables_X, map_pure] using hh
  have hs : s ≠ 0 := by
    intro hs
    simp [hs] at hsq
  have hCs : (C s : ReplicaKernel.MeanPolynomial K) ≠ 0 := C_ne_zero.mpr hs
  have hf : (X h.castSucc : ReplicaKernel.MeanPolynomial K) ≠ 0 := X_ne_zero _
  have hh := OmissionCancellation.pure_coefficient_eq_of_response_and_rotation
    E0 F0 Es0 V0 Vs0 (C s) (X h.castSucc) (directPolynomial W p q h)
    hCs hf hV0 hVs0 hrot0 hder0
  simpa only [E0, F0, F, constantTensor, directionZero_C] using hh

theorem pure_even_constancy (m : ℕ) (W : WeightsN (2 * (m + 1)) 3 K)
    (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin 3) (hbh : b ≠ h)
    (s : K) (hsq : s * s = 2)
    (hzero : ∀ w : RetainedSites p q → Bool, ∀ r, 0 < r → r ≤ m →
      OddResponseVanishing.oddResponsePolynomial W p m r
        (receivingWord p q b h w) = 0)
    (a : Fin 3 → K) :
    coeff (wordExponent (fun _ => b) (retainedVertices p q))
      (EvenResponse.evenResponse (K := K) m (retainedQuadratic W p q)
        (OmissionDegree.omittedRowLinear W p q a)) =
    coeff (wordExponent (fun _ => b) (retainedVertices p q))
      (EvenResponse.dividedPower (K := K) (retainedQuadratic W p q) m) := by
  classical
  have hc := pure_tensor_constancy m W hW p q hpq b h hbh s hsq hzero
  let a4 : Fin 4 → K := ![a 0, a 1, a 2, 0]
  have ha : (fun i : Fin 3 => a4 i.castSucc) = a := by
    funext i; fin_cases i <;> rfl
  have hexp : wordExponent (receivingWord p q b h (fun _ => false))
      (retainedVertices p q) = wordExponent (fun _ => b) (retainedVertices p q) := by
    apply wordExponent_congr_on_list
    intro v hv
    simp [receivingWord, (mem_retainedVertices p q v).mp hv]
  have hc0 := congrArg (eval (fun _ : Fin 4 => (0 : K))) hc
  have hca := congrArg (eval a4) hc
  rw [eval_directionZero_responseTensor, ha, hexp] at hca
  rw [eval_directionZero_responseTensor, hexp] at hc0
  rw [eval_C] at hca hc0
  rw [← hc0] at hca
  simpa only [OmissionDegree.omittedRowLinear, LinearMap.coe_mk, AddHom.coe_mk,
    OddResponseVanishing.rowAt, rootFamilyRow, zero_mul,
    Finset.sum_const_zero, map_zero, EndpointSource.evenResponse_zero_mean] using hca

theorem pure_even_constancy_of_eqSystem (m : ℕ)
    (W : WeightsN (2 * (m + 1)) 3 ℂ)
    (hW : EqSystemN (2 * (m + 1)) 3 W)
    (p q : V (2 * (m + 1))) (hpq : p ≠ q) (b h : Fin 3) (hbh : b ≠ h)
    (a : Fin 3 → ℂ) :
    coeff (wordExponent (fun _ => b) (retainedVertices p q))
      (EvenResponse.evenResponse (K := ℂ) m (retainedQuadratic W p q)
        (OmissionDegree.omittedRowLinear W p q a)) =
    coeff (wordExponent (fun _ => b) (retainedVertices p q))
      (EvenResponse.dividedPower (K := ℂ) (retainedQuadratic W p q) m) :=
  pure_even_constancy m W hW p q hpq b h hbh
    BinarySourceInterface.normTwo BinarySourceInterface.normTwo_sq
    (BinarySourceInterface.omitted_higher_zero m W hW p q b h) a

end Krenn.OmissionConstancy

-- formal/all-orders/DiagonalSource.lean

namespace Krenn.DiagonalSource

open MatchingModel SiteAlgebra

theorem diagonal_of_eqSystem (k : ℕ) (W : WeightsN (2 * (k + 2)) 3 ℂ)
    (hW : EqSystemN (2 * (k + 2)) 3 W) :
    ∀ p q i h, i ≠ h → edgeMatrix W (p, i) (q, h) = 0 := by
  apply CofactorResponse.source_diagonal_of_omission_vanishing k W hW
  intro p q hpq i h
  obtain ⟨j, hjh⟩ := exists_ne h
  apply OmissionDegree.omitted_two_row_zero_of_pure_even_constancy k W p q i h
  intro a
  exact OmissionConstancy.pure_even_constancy (k + 1) W hW p q hpq h j hjh.symm
    BinarySourceInterface.normTwo BinarySourceInterface.normTwo_sq
    (fun w r hpos hr => BinarySourceInterface.omitted_higher_zero
      (k + 1) W hW p q h j w r hpos hr) a

end Krenn.DiagonalSource

-- formal/all-orders/KrennConjecture.lean

namespace Krenn.KrennConjecture

open MatchingModel SiteAlgebra RootResponse

theorem exists_retained_size {N : ℕ} (hN : 6 ≤ N) (heven : Even N) :
    ∃ k : ℕ, N = 2 * (k + 2) := by
  obtain ⟨m, hm⟩ := heven
  refine ⟨m - 2, ?_⟩
  omega

theorem supported_endpoint_of_diagonal_eqSystem (m : ℕ)
    (W : WeightsN (2 * (m + 1)) 3 ℂ) (hW : EqSystemN (2 * (m + 1)) 3 W)
    (hdiag : EndpointSource.DiagonalSource W) (b : Fin 3)
    (p q : V (2 * (m + 1))) (hd : edgeMatrix W (p, b) (q, b) ≠ 0) :
    edgeMatrix W (p, b) (q, b) * pureCofactor W b p q = 1 := by
  have hpq : p ≠ q := by
    intro hpq
    subst q
    exact hd (edgeMatrix_same_site W p b b)
  obtain ⟨h, hhb, _⟩ := WholeBinaryResponse.exists_third_colour b b
  exact EndpointCovariance.supported_endpoint_from_original_binary_responses m W hW
    hdiag p q hpq b h hhb.symm
    (BinarySourceInterface.originalHigherZeroOnPalette m W hW p b h)
    (BinarySourceInterface.originalHigherZeroOnPalette m W hW q b h) hd

theorem not_eqSystemN_three {N : ℕ} (hN : 6 ≤ N) (heven : Even N)
    (W : WeightsN N 3 ℂ) : ¬ EqSystemN N 3 W := by
  obtain ⟨k, hsize⟩ := exists_retained_size hN heven
  subst N
  intro hW
  have hdiag := DiagonalSource.diagonal_of_eqSystem k W hW
  exact PhysicalClosure.not_eqSystemN_of_diagonal_and_endpoint hN heven W hdiag
    (fun i p q hd =>
      supported_endpoint_of_diagonal_eqSystem (k + 1) W hW hdiag i p q hd) hW

end Krenn.KrennConjecture

-- formal/upstream-adapter/UpstreamAdapter.lean

namespace Krenn.UpstreamAdapter

variable {N D : ℕ} {R : Type}

def toLocalWeights (W : MonochromaticQuantumGraph.WeightsN N D R) :
    MatchingModel.WeightsN N D R :=
  fun e => W ⟨e.u, e.v, e.i, e.j⟩

theorem vertices_eq : ∀ n : ℕ,
    MatchingModel.vertices n = MonochromaticQuantumGraph.vertices n
  | 0 => rfl
  | n + 1 => by
    simp only [MatchingModel.vertices, MonochromaticQuantumGraph.vertices, vertices_eq n]

theorem allEqual_iff (ι : Fin N → Fin D) :
    MatchingModel.allEqual ι ↔ MonochromaticQuantumGraph.allEqual ι := by
  simp only [MatchingModel.allEqual, MonochromaticQuantumGraph.allEqual,
    MatchingModel.allEqualList, MonochromaticQuantumGraph.allEqualList, vertices_eq]

variable [Semiring R]

theorem pmSumListAux_eq (W : MonochromaticQuantumGraph.WeightsN N D R)
    (ι : Fin N → Fin D) : ∀ (n : ℕ) (L : List (Fin N)),
      MatchingModel.pmSumListAux (toLocalWeights W) ι n L =
        MonochromaticQuantumGraph.pmSumListAux W ι n L
  | 0, _ => rfl
  | 1, _ => rfl
  | _ + 2, [] => rfl
  | _ + 2, [_] => rfl
  | n + 2, a :: b :: L => by
    simp only [MatchingModel.pmSumListAux, MonochromaticQuantumGraph.pmSumListAux]
    congr 1
    refine List.map_congr_left fun u _ => ?_
    rw [pmSumListAux_eq W ι n ((b :: L).erase u)]
    rfl

theorem pmSumN_eq (W : MonochromaticQuantumGraph.WeightsN N D R)
    (ι : Fin N → Fin D) :
    MatchingModel.pmSumN N D (toLocalWeights W) ι =
      MonochromaticQuantumGraph.pmSumN N D W ι := by
  simp only [MatchingModel.pmSumN, MonochromaticQuantumGraph.pmSumN,
    MatchingModel.pmSumList, MonochromaticQuantumGraph.pmSumList,
    vertices_eq, pmSumListAux_eq]

theorem eqSystemN_iff (W : MonochromaticQuantumGraph.WeightsN N D R) :
    MatchingModel.EqSystemN N D (toLocalWeights W) ↔
      MonochromaticQuantumGraph.EqSystemN N D W := by
  simp only [MatchingModel.EqSystemN, MonochromaticQuantumGraph.EqSystemN,
    pmSumN_eq, allEqual_iff]

end Krenn.UpstreamAdapter

namespace OMA.AllOrders

open MonochromaticQuantumGraph

lemma restrict_sum {N D : ℕ} (embed : Fin 3 → Fin D)
    (W : WeightsN N D ℂ) (σ : V N → Fin 3) :
    ∀ (n : ℕ) (L : List (V N)),
      pmSumListAux (fun e => W (mkEdge e.u e.v (embed e.i) (embed e.j))) σ n L =
        pmSumListAux W (fun v => embed (σ v)) n L
  | 0, _ => rfl
  | 1, _ => rfl
  | _ + 2, [] => rfl
  | _ + 2, [_] => rfl
  | n + 2, v :: u :: L => by
      simp only [pmSumListAux]
      congr 1
      refine List.map_congr_left fun w _ => ?_
      rw [restrict_sum embed W σ n ((u :: L).erase w)]
      rfl

lemma restrict_chain {N D : ℕ} (embed : Fin 3 → Fin D)
    (hi : Function.Injective embed) (σ : V N → Fin 3) (L : List (V N)) :
    allEqualList (fun v => embed (σ v)) L ↔ allEqualList σ L := by
  unfold allEqualList
  induction L with
  | nil => simp
  | cons a L ih =>
    cases L with
    | nil => simp
    | cons b L =>
      simp only [List.isChain_cons_cons, hi.eq_iff]

lemma restrict_palette {N D : ℕ} (hD : 3 ≤ D) (W : WeightsN N D ℂ)
    (hW : EqSystemN N D W) : ∃ U : WeightsN N 3 ℂ, EqSystemN N 3 U := by
  let embed : Fin 3 → Fin D := fun i => ⟨i.val, Nat.lt_of_lt_of_le i.isLt hD⟩
  have hi : Function.Injective embed := by
    intro a b h
    apply Fin.ext
    exact congrArg (fun i : Fin D => i.val) h
  refine ⟨fun e => W (mkEdge e.u e.v (embed e.i) (embed e.j)), ?_⟩
  intro σ
  have hmono : allEqual (fun v : V N => embed (σ v)) ↔ allEqual σ :=
    restrict_chain embed hi σ (vertices N)
  unfold pmSumN pmSumList
  rw [restrict_sum]
  simpa only [pmSumN, pmSumList, hmono] using hW (fun v => embed (σ v))

end OMA.AllOrders

theorem OMA.solution : type_of% @MonochromaticQuantumGraph.eqSystem_no_solution_ge6_ge3 := by
  intro N D hN heven hD h
  obtain ⟨W, hW⟩ := h
  obtain ⟨U, hU⟩ := OMA.AllOrders.restrict_palette hD W hW
  exact Krenn.KrennConjecture.not_eqSystemN_three hN heven
    (Krenn.UpstreamAdapter.toLocalWeights U)
    ((Krenn.UpstreamAdapter.eqSystemN_iff U).mpr hU)

/-
                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "{}"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright {yyyy} {name of copyright owner}

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

-/
