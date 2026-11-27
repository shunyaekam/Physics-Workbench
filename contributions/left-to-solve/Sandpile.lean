import Lean

/-!
# The one-row toroidal sandpile

Sources: https://oeis.org/A293452, https://oeis.org/A249872, https://oeis.org/A023855.
Credit: @shunyaekam

Site zero is a sink. On a strip of width one, the two vertical neighbors
of each nonsink site are that site itself, so a legal toppling costs it
two grains net. Both horizontal edges are retained, even when their
endpoints coincide.
-/

namespace OMA.S_oeis_a293452

abbrev Heights (n : Nat) := Fin n → Nat

def initial (n : Nat) : Heights n :=
  fun j => if j.val = 0 then 0 else 4

def topple {n : Nat} (c : Heights n) (i : Fin n) : Heights n :=
  fun j => if j.val = 0 then 0 else
    (if j = i then c j - 2 else c j) +
    (if j.val = (i.val + 1) % n then 1 else 0) +
    (if j.val = (i.val + n - 1) % n then 1 else 0)

/-- The list records every toppling, in order, up to stabilization. -/
def completes {n : Nat} : Heights n → List (Fin n) → Prop
  | c, [] => ∀ j, c j < 4
  | c, i :: rest => i.val ≠ 0 ∧ 4 ≤ c i ∧ completes (topple c i) rest

/-- A023855 in the OEIS offset-one convention. -/
def rectangleSum (n : Nat) : Nat :=
  ((List.range ((n + 1) / 2)).map (fun j => (j + 1) * (n - j))).sum

end OMA.S_oeis_a293452

open OMA.S_oeis_a293452

theorem OMA.disproof : ¬ (∀ n : Nat, 1 ≤ n → ∀ m : Nat, (∃ moves : List (Fin n), completes (initial n) moves ∧ moves.length = m) ↔ m = rectangleSum n) := by
  intro claim
  have stable : completes (initial 1) [] := by
    intro j
    have hz : j.val = 0 := by have hj := j.isLt; omega
    simp [initial, hz]
  have wrong : 0 = rectangleSum 1 :=
    (claim 1 (by decide) 0).mp ⟨[], stable, rfl⟩
  have corrected : rectangleSum 1 = 1 := by decide
  omega

#print axioms OMA.disproof
