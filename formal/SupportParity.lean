import Init

namespace Workbench

-- A word assigns an alphabet symbol to each coordinate in a finite list.
abbrev Word := Nat → Nat

def different (a b : Nat) : Bool := decide (a ≠ b)
def rainbow (a b c : Nat) : Bool := decide (a ≠ b ∧ b ≠ c ∧ a ≠ c)

def parity (sites : List Nat) (f : Nat → Bool) : Bool :=
  sites.foldr (fun i acc => Bool.xor (f i) acc) false

def hamming (sites : List Nat) (x y : Word) : Bool :=
  parity sites (fun i => different (x i) (y i))

def oddTriple (sites : List Nat) (x y z : Word) : Bool :=
  parity sites (fun i => rainbow (x i) (y i) (z i))

private theorem local_triangle (a b c : Nat) :
    rainbow a b c = ((different a b).xor (different b c)).xor (different a c) := by
  by_cases h : a = b <;> by_cases g : b = c <;> by_cases j : a = c <;>
    simp_all [rainbow, different]

private theorem shuffle (a b c d e f : Bool) :
    (((a.xor b).xor c).xor ((d.xor e).xor f)) =
      (((a.xor d).xor (b.xor e)).xor (c.xor f)) := by
  cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;> rfl

theorem triangle_parity (sites : List Nat) (x y z : Word) :
    oddTriple sites x y z =
      ((hamming sites x y).xor (hamming sites y z)).xor (hamming sites x z) := by
  induction sites with
  | nil => rfl
  | cons i tail ih =>
    change (rainbow (x i) (y i) (z i)).xor (oddTriple tail x y z) = _
    rw [local_triangle, ih]
    apply shuffle

private theorem infer_triangle (a b c u v w : Bool)
    (hu : ((a.xor u).xor b) = false)
    (hv : ((b.xor v).xor c) = false)
    (hw : ((a.xor w).xor c) = false) :
    ((u.xor v).xor w) = false := by
  cases a <;> cases b <;> cases c <;> cases u <;> cases v <;> cases w <;> simp_all

-- The certificate graph may test triples through one fixed member of S.
theorem anchor_iff_all (sites : List Nat) (S : Word → Prop) (a : Word) (ha : S a) :
    (∀ x y, S x → S y → oddTriple sites a x y = false) ↔
    (∀ x y z, S x → S y → S z → oddTriple sites x y z = false) := by
  constructor
  · intro h x y z hx hy hz
    rw [triangle_parity]
    apply infer_triangle (hamming sites a x) (hamming sites a y) (hamming sites a z)
    · simpa only [triangle_parity] using h x y hx hy
    · simpa only [triangle_parity] using h y z hy hz
    · simpa only [triangle_parity] using h x z hx hz
  · intro h x y hx hy
    exact h a x y ha hx hy

#print axioms triangle_parity
#print axioms anchor_iff_all
end Workbench
