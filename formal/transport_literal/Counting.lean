import Init

namespace TransportCounting

abbrev Interval := Nat × Nat

/-- A descending span contributes +1 and an ascending span contributes -1. -/
def edge (i : Interval) (u v : Nat) : Int :=
  (if i.2 ≤ u ∧ v ≤ i.1 then 1 else 0) - (if u ≤ i.1 ∧ i.2 ≤ v then 1 else 0)

/-- Include the return edge from the last vertex to the start. -/
def walk (i : Interval) (start u : Nat) : List Nat → Int
  | [] => edge i u start
  | v :: vs => edge i u v + walk i start v vs

def demand (i : Interval) : List Nat → Int
  | [] => 0
  | u :: vs => walk i u u vs

def disjointInterior (i j : Interval) : Prop :=
  ∀ t : Nat, ¬(i.1 < t ∧ t < i.2 ∧ j.1 < t ∧ t < j.2)

def positiveSum (cycle : List Nat) (family : List Interval) : Int :=
  (family.map (fun i => max 0 (demand i cycle))).sum

/-- The all-simple-cycles counting lemma from the polygon manuscript.
Indices in a finite spectrum can be numbered by natural numbers. -/
def CountingBound : Prop :=
  ∀ (cycle : List Nat) (family : List Interval) (j : Interval),
    2 ≤ cycle.length → cycle.Nodup → family.Nodup →
    (∀ i ∈ family, i.1 < i.2) → family.Pairwise disjointInterior →
    j.1 < j.2 → 0 < demand j cycle →
    (∀ i : Interval, i.1 < i.2 → demand i cycle ≤ demand j cycle) →
    positiveSum cycle family ≤ (cycle.length : Int) - 2 * demand j cycle

private def side (a u : Nat) : Int := if u ≤ a then 1 else 0

private theorem adjacentEdge (a u v : Nat) :
    edge (a,a+1) u v = side a v - side a u := by
  simp only [edge, side]
  split <;> split <;> split <;> split <;> omega

private theorem walkAdjacent (a start u : Nat) (rest : List Nat) :
    walk (a,a+1) start u rest = side a start - side a u := by
  induction rest generalizing u with
  | nil => exact adjacentEdge a u start
  | cons v vs ih =>
    simp only [walk, adjacentEdge, ih]
    omega

/-- The first reduction in the counting proof. This applies even to repeated
vertices, since crossings of any adjacent cut telescope on a closed walk. -/
theorem adjacentBalance (a : Nat) (cycle : List Nat) : demand (a,a+1) cycle = 0 := by
  cases cycle with
  | nil => rfl
  | cons u vs => simp only [demand, walkAdjacent, Int.sub_self]

end TransportCounting
