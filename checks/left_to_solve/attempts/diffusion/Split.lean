import Mathlib.Algebra.BigOperators.Group.List.Basic
import Mathlib.Data.Nat.Find
import Mathlib.Algebra.Group.Prod
import Mathlib.Algebra.Group.Int.Defs

namespace DiffusionSplit

abbrev Word := List (ℤ × ℤ)

def FirstArrival (x : ℤ × ℤ) (u : Word) : Prop :=
  u.sum = x ∧ ∀ j < u.length, (u.take j).sum ≠ x

/-- Every word ending at x splits uniquely into a first-arrival prefix and a
zero-displacement suffix. The split also covers empty words and x = 0. -/
theorem unique_split (w : Word) (x : ℤ × ℤ) (hend : w.sum = x) :
    ∃! uv : Word × Word, uv.1 ++ uv.2 = w ∧ FirstArrival x uv.1 ∧ uv.2.sum = 0 := by
  classical
  have hex : ∃ k, (w.take k).sum = x := ⟨w.length, by simpa using hend⟩
  let k := Nat.find hex
  have hk : (w.take k).sum = x := Nat.find_spec hex
  have hlen : k ≤ w.length := Nat.find_min' hex (by simpa using hend)
  have hcut : (w.take k).length = k := by simp [List.length_take, min_eq_left hlen]
  have hfirst : FirstArrival x (w.take k) := by
    refine ⟨hk, ?_⟩
    intro j hj
    rw [hcut] at hj
    rw [List.take_take, min_eq_left hj.le]
    exact Nat.find_min hex hj
  have hloop : (w.drop k).sum = 0 := by
    have h := congrArg List.sum (List.take_append_drop k w)
    rw [List.sum_append, hk, hend] at h
    exact add_eq_left.mp h
  refine ⟨(w.take k, w.drop k), ⟨List.take_append_drop _ _, hfirst, hloop⟩, ?_⟩
  rintro ⟨u,v⟩ ⟨huv, hu, _⟩
  change u ++ v = w at huv
  have hule : k ≤ u.length := Nat.find_min' hex (by rw [← huv, List.take_left]; exact hu.1)
  have heq : k = u.length := by
    apply le_antisymm hule
    by_contra! hlt
    have hp : (u.take k).sum = x := by
      rwa [← huv, List.take_append_of_le_length hule] at hk
    exact hu.2 k hlt hp
  rw [heq, ← huv, List.take_left, List.drop_left]

/-- Restricting the cut to words of a fixed length over any allowed alphabet
gives the counting bijection used by first-hit renewal. -/
noncomputable def joinEquiv (allowed : Set (ℤ × ℤ)) (t : ℕ) (x : ℤ × ℤ) :
    {uv : Word × Word // FirstArrival x uv.1 ∧ uv.2.sum = 0 ∧
      uv.1.length + uv.2.length = t ∧ ∀ a ∈ uv.1 ++ uv.2, a ∈ allowed} ≃
    {w : Word // w.sum = x ∧ w.length = t ∧ ∀ a ∈ w, a ∈ allowed} := by
  let join := fun (p : {uv : Word × Word // FirstArrival x uv.1 ∧ uv.2.sum = 0 ∧
      uv.1.length + uv.2.length = t ∧ ∀ a ∈ uv.1 ++ uv.2, a ∈ allowed}) =>
    (⟨p.val.1 ++ p.val.2, by
      refine ⟨?_, ?_, p.property.2.2.2⟩
      · rw [List.sum_append, p.property.1.1, p.property.2.1, add_zero]
      · simpa only [List.length_append] using p.property.2.2.1⟩ :
        {w : Word // w.sum = x ∧ w.length = t ∧ ∀ a ∈ w, a ∈ allowed})
  apply Equiv.ofBijective join
  constructor
  · intro p q heq
    apply Subtype.ext
    have he : p.val.1 ++ p.val.2 = q.val.1 ++ q.val.2 := congrArg Subtype.val heq
    have uniq := unique_split (join q).val x (join q).property.1
    exact uniq.unique ⟨he, p.property.1, p.property.2.1⟩
      ⟨rfl, q.property.1, q.property.2.1⟩
  · intro w
    obtain ⟨uv, huv, _⟩ := unique_split w.val x w.property.1
    refine ⟨⟨uv, huv.2.1, huv.2.2, ?_, ?_⟩, Subtype.ext huv.1⟩
    · rw [← List.length_append, huv.1, w.property.2.1]
    · rw [huv.1]
      exact w.property.2.2

end DiffusionSplit
