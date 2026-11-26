import Init

/-! Polygon lower bound for a chain of any finite length. The scalar theorem
uses only the listed laws of ordered commutative additive monoids. Positive
real exponents, the reduction from quantum costs, and the optimal upper bound
are proved in the manuscript. This module checks the telescoping lower bound
and the local crossing implication used in the counting lemma. -/

namespace Workbench.TransportPolygon

/-- Explicit hypotheses on the scalar arithmetic so the proof needs only Init. -/
structure ScalarLaws (S : Type u) [Zero S] [Add S] [LE S] : Prop where
  refl (a : S) : a ≤ a
  trans {a b c : S} : a ≤ b → b ≤ c → a ≤ c
  addZero (a : S) : a + 0 = a
  assoc (a b c : S) : (a + b) + c = a + (b + c)
  comm (a b : S) : a + b = b + a
  addMono {a b c d : S} : a ≤ b → c ≤ d → a + c ≤ b + d

/-- The endpoint of a walk specified by its start and successive vertices. -/
def endpoint (start : V) : List V → V
  | [] => start
  | next :: tail => endpoint next tail

/-- The sum of its edge costs. A walk of length zero costs zero. -/
def pathSum [Zero S] [Add S] (cost : V → V → S) (start : V) : List V → S
  | [] => 0
  | next :: tail => cost start next + pathSum cost next tail

/-- A sum of exactly n copies of the uniform error. -/
def copies [Zero S] [Add S] (error : S) : Nat → S
  | 0 => 0
  | n + 1 => copies error n + error

variable {S : Type u} {V : Type v} [Zero S] [Add S] [LE S]

private theorem interchange (laws : ScalarLaws S) (a b c d : S) :
    (a + b) + (c + d) = (a + c) + (d + b) := by
  rw [laws.assoc a b, laws.comm b (c + d), laws.assoc c d b, laws.assoc a c]

/-- Triangle inequalities on individual edges imply a polygon inequality. -/
theorem triangleAlongWalk (laws : ScalarLaws S) (cost : V → V → S)
    (diag : ∀ u, cost u u = 0)
    (triangle : ∀ u v w, cost u w ≤ cost u v + cost v w)
    (start : V) (walk : List V) :
    cost start (endpoint start walk) ≤ pathSum cost start walk := by
  induction walk generalizing start with
  | nil => simpa [endpoint, pathSum, diag] using laws.refl (0 : S)
  | cons next tail ih =>
    exact laws.trans (triangle start next (endpoint next tail))
      (laws.addMono (laws.refl _) (ih next))

/-- Replacing every approximant edge by its target adds at most m error terms. -/
theorem pathError (laws : ScalarLaws S) (target approx : V → V → S) (error : S)
    (upper : ∀ u v, approx u v ≤ target u v + error)
    (start : V) (walk : List V) :
    pathSum approx start walk ≤ pathSum target start walk + copies error walk.length := by
  induction walk generalizing start with
  | nil => simpa [pathSum, copies, laws.addZero] using laws.refl (0 : S)
  | cons next tail ih =>
    have h := laws.addMono (upper start next) (ih next)
    rw [interchange laws] at h
    exact h

/-- With m edges, the endpoint target is bounded by the sum of edge targets
plus m+1 copies of the uniform error. This holds for every finite walk. -/
theorem polygonLowerBound (laws : ScalarLaws S) (target approx : V → V → S)
    (error : S) (diag : ∀ u, approx u u = 0)
    (triangle : ∀ u v w, approx u w ≤ approx u v + approx v w)
    (upper : ∀ u v, approx u v ≤ target u v + error)
    (lower : ∀ u v, target u v ≤ approx u v + error)
    (start : V) (walk : List V) :
    target start (endpoint start walk) ≤
      pathSum target start walk + copies error (walk.length + 1) := by
  have h := laws.trans (triangleAlongWalk laws approx diag triangle start walk)
    (pathError laws target approx error upper start walk)
  have total := laws.trans (lower start (endpoint start walk))
    (laws.addMono h (laws.refl error))
  rw [laws.assoc] at total
  exact total

/-- A concrete scalar model covering integer data and common-denominator scaling. -/
def integerLaws : ScalarLaws Int :=
  ⟨Int.le_refl, Int.le_trans, Int.add_zero, Int.add_assoc, Int.add_comm,
   Int.add_le_add⟩

private theorem copiesInt (e : Int) (n : Nat) : copies e n = (n : Int) * e := by
  induction n with
  | zero => simp [copies]
  | succ n ih => simp [copies, ih, Int.add_mul]

/-- The usual multiplied form for integer or scaled-rational certificates. -/
theorem integerPolygonLowerBound (target approx : V → V → Int)
    (error : Int) (diag : ∀ u, approx u u = 0)
    (triangle : ∀ u v w, approx u w ≤ approx u v + approx v w)
    (upper : ∀ u v, approx u v ≤ target u v + error)
    (lower : ∀ u v, target u v ≤ approx u v + error)
    (start : V) (walk : List V) :
    target start (endpoint start walk) - pathSum target start walk ≤
      ((walk.length + 1 : Nat) : Int) * error := by
  have h := polygonLowerBound integerLaws target approx error diag triangle upper lower start walk
  rw [copiesInt] at h
  exact Int.sub_left_le_of_le_add h

/-- A cycle edge crosses the whole index interval [left, right] downwards. -/
def crossesDown (left right source destination : Nat) : Prop :=
  right ≤ source ∧ destination ≤ left

/-- Local geometric step of the counting lemma. In a forward traversal of a
block with left exterior ending at a, the predecessor of the first internal
vertex lies at or below a. The successor is either internal or the right exit,
so both following vertices exceed a. If the first vertex is marked as an
endpoint of a downward crossing of J, its entry edge must cross all of J upwards.
This uses no assumptions about how the rest of the cycle is arranged. -/
theorem markedEntryCrossesUp {a left right prev first next : Nat}
    (proper : left < right) (entry : prev ≤ a)
    (internal : a < first) (continues : a < next)
    (marked : crossesDown left right prev first ∨ crossesDown left right first next) :
    prev ≤ left ∧ right ≤ first := by
  cases marked with
  | inl incoming =>
    have impossible : first < first :=
      Nat.lt_of_le_of_lt incoming.2 (Nat.lt_of_lt_of_le proper
        (Nat.le_trans incoming.1 (Nat.le_trans entry (Nat.le_of_lt internal))))
    exact False.elim ((Nat.lt_irrefl first) impossible)
  | inr outgoing =>
    exact ⟨Nat.le_trans entry (Nat.le_trans (Nat.le_of_lt continues) outgoing.2), outgoing.1⟩

#print axioms triangleAlongWalk
#print axioms pathError
#print axioms polygonLowerBound
#print axioms integerPolygonLowerBound
#print axioms markedEntryCrossesUp

end Workbench.TransportPolygon
