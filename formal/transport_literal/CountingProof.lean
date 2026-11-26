import Counting
namespace TransportCounting.Cover
abbrev I := TransportCounting.Interval

def bit (p : Prop) [Decidable p] : Int := if p then 1 else 0
def l (s : I) (t : Nat) := bit (s.1 < t)
def r (s : I) (t : Nat) := bit (s.2 ≤ t)
def ins (s : I) (t : Nat) := bit (s.1 < t ∧ t < s.2)
def span (s : I) (u v : Nat) := bit (u ≤ s.1 ∧ s.2 ≤ v)

def total {α : Type} (f : α → Int) (s : List α) : Int := (s.map f).sum
@[simp] theorem tt_nil {α} (f : α → Int) : total f [] = 0 := rfl
@[simp] theorem tt_cons {α} (f : α → Int) (x) (xs) : total f (x::xs) = f x + total f xs := by simp [total]
theorem tt_le {α} (xs : List α) (f g : α → Int) (h : ∀ x ∈ xs, f x ≤ g x) : total f xs ≤ total g xs := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
    simp only [tt_cons]
    have h₁ := h x (by simp)
    have h₂ := ih (fun y hy => h y (by simp [hy]))
    omega
theorem tt_sub {α} (xs : List α) (f g : α → Int) :
    total (fun x => f x - g x) xs = total f xs - total g xs := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp only [tt_cons, ih]; omega

theorem tt_zero {α} {xs : List α} {f : α → Int} (h : ∀ x ∈ xs, f x = 0) : total f xs = 0 := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
    simp only [tt_cons]
    rw [h x (by simp),ih (fun y hy => h y (by simp [hy]))]; omega

theorem atMostOne (xs : List I) (hd : xs.Pairwise disjointInterior) (t : Nat) :
    total (fun s => ins s t) xs ≤ 1 := by
  induction xs with
  | nil => simp
  | cons s xs ih =>
    have ⟨dis,tail⟩ := List.pairwise_cons.mp hd
    simp only [tt_cons]
    by_cases h : s.1 < t ∧ t < s.2
    · have z := tt_zero (xs:=xs) (f:=fun i => ins i t) (by
        intro i hi
        have no := dis i hi t
        simp only [ins,bit]; split <;> omega)
      simp [ins,bit,h,z] at *
    · have v := ih tail
      simpa [ins,bit,h] using v

theorem bound_total (xs : List I) (hd : xs.Pairwise disjointInterior) (t : Nat)
    (f : I → Int) (h : ∀ i ∈ xs, f i ≤ ins i t) : total f xs ≤ 1 :=
  Int.le_trans (tt_le xs f _ h) (atMostOne xs hd t)

/-- The distinguished interval is strictly enclosed by s on both sides. -/
def inside (s j : I) := s.1 < j.1 ∧ j.2 < s.2
instance (s j : I) : Decidable (inside s j) := inferInstanceAs (Decidable (_ ∧ _))
/-- Each ordinary interval gives a step at its left endpoint below the pivot and
at its right endpoint above the pivot. An enclosing interval steps at the pivot's left edge. -/
def label (j s : I) (t : Nat) : Int :=
  if inside s j then bit (j.1 < t)
  else if t < j.2 then l s t else r s t
def residual (j s : I) (u v : Nat) := label j s v - label j s u - span s u v

-- The exceptional interval makes a unit jump at its right endpoint.
def big (j : I) (t : Nat) := bit (j.2 ≤ t)
def du (j : I) (u v : Nat) := big j v - big j u - 2 * span j u v

-- A comparison of integers splits into finitely many linear-order cases.
macro "order_cases" : tactic => `(tactic|
  (simp only [residual, label, inside, l, r, span, ins, du, big, bit] at *
   repeat' first | split at * <;> rename_i h | omega))
theorem residualLeft (j s : I) (u v : Nat) (h : u<v) (k : v<j.2) (_hs : s.1<s.2) (hj : j.1<j.2) :
    0 ≤ residual j s u v ∧ residual j s u v ≤ ins s v := by
  constructor <;> order_cases
theorem residualRight (j s : I) (u v : Nat) (_h : u<v) (k : j.2≤u) (_hs : s.1<s.2) (hj : j.1<j.2) :
    0 ≤ residual j s u v ∧ residual j s u v ≤ ins s u := by
  constructor <;> order_cases
theorem residualSpan (j s : I) (u v : Nat) (_h : u<v) (k : u≤j.1) (g : j.2≤v) (_hs : s.1<s.2) (hj : j.1<j.2) :
    0 ≤ residual j s u v ∧ residual j s u v ≤ ins s j.1 := by
  constructor <;> order_cases
theorem residualCross (j s : I) (u v : Nat) (h : u<v) (k : j.1<u) (k' : u<j.2) (g : j.2≤v) (_hs : s.1<s.2) (hj : j.1<j.2) :
    0 ≤ -residual j s u v ∧ -residual j s u v ≤ ins s u := by
  constructor <;> order_cases
theorem tt_const_zero (xs : List I) : total (fun _ => 0) xs = 0 := tt_zero (by simp)
theorem tt_nonneg (xs : List I) (f : I → Int) (h : ∀ i ∈ xs, 0 ≤ f i) : 0 ≤ total f xs := by
  have v := tt_le xs (fun _ => 0) f h
  rwa [tt_const_zero] at v

theorem tt_neg (xs : List I) (f : I → Int) : total (fun i => -f i) xs = -total f xs := by
  induction xs with
  | nil => simp
  | cons s xs ih => simp only [tt_cons,ih]; omega

def Y (xs : List I) (j : I) (t : Nat) := big j t + total (fun s => label j s t) xs
def D (xs : List I) (j : I) (u v : Nat) := 2 * span j u v + total (fun s => span s u v) xs
theorem ascending (xs : List I) (j : I) (u v : Nat)
    (h : u < v) (hj : j.1<j.2) (hs : ∀ s ∈ xs, s.1<s.2) (hd : xs.Pairwise disjointInterior) :
    (-1 : Int) ≤ Y xs j v - Y xs j u - D xs j u v ∧ Y xs j v - Y xs j u - D xs j u v ≤ 1 := by
  have key : Y xs j v - Y xs j u - D xs j u v = du j u v + total (fun s => residual j s u v) xs := by
    simp only [Y,D,du,residual,tt_sub]; omega
  rw [key]
  let f := fun s => residual j s u v
  have two : ∀ t, (∀ s ∈ xs, 0 ≤ f s ∧ f s ≤ ins s t) → 0 ≤ total f xs ∧ total f xs ≤ 1 :=
    fun t hr => ⟨tt_nonneg xs f (fun s hi => (hr s hi).1),bound_total xs hd t f (fun s hi => (hr s hi).2)⟩
  by_cases left : v < j.2
  · have eq : du j u v = 0 := by
        simp only [du,big,span,bit]
        repeat' first | split <;> rename_i h | omega
    have b := two v (fun s hi => residualLeft j s u v h left (hs s hi) hj)
    dsimp [f] at b; omega
  by_cases right : j.2 ≤ u
  · have eq : du j u v = 0 := by
        simp only [du,big,span,bit]
        repeat' first | split <;> rename_i h | omega
    have b := two u (fun s hi => residualRight j s u v h right (hs s hi) hj)
    dsimp [f] at b; omega
  by_cases sp : u ≤ j.1
  · have eq : du j u v = -1 := by
        simp only [du,big,span,bit]
        repeat' first | split <;> rename_i h | omega
    have b := two j.1 (fun s hi => residualSpan j s u v h sp (by omega) (hs s hi) hj)
    dsimp [f] at b; omega
  · have eq : du j u v = 1 := by
        simp only [du,big,span,bit]
        repeat' first | split <;> rename_i h | omega
    have neg := fun s hi => residualCross j s u v h (by omega) (by omega) (by omega) (hs s hi) hj
    have a := tt_nonneg xs (fun s => -f s) (fun s hi => (neg s hi).1)
    have b := bound_total xs hd u (fun s => -f s) (fun s hi => (neg s hi).2)
    rw [tt_neg] at a b
    dsimp [f] at a b; omega

theorem tt_congr (xs : List I) (f g : I → Int) (h : ∀ s ∈ xs, f s = g s) : total f xs = total g xs :=
  Int.le_antisymm (tt_le xs f g (fun s hi => by rw [h s hi]; exact Int.le_refl _)) (tt_le xs g f (fun s hi => by rw [h s hi]; exact Int.le_refl _))
theorem edgeUp (s : I) (u v : Nat) (h : u<v) (_hs : s.1<s.2) : edge s u v = -span s u v := by
  simp only [edge,span,bit]
  repeat' first | split at * <;> rename_i h | omega
theorem edgeDown (s : I) (u v : Nat) (h : u<v) (_hs : s.1<s.2) : edge s v u = span s u v := by
  simp only [edge,span,bit]
  repeat' first | split at * <;> rename_i h | omega
theorem edgeEq (s : I) (u : Nat) : edge s u u = 0 := by simp [edge, and_comm]
def weight (xs : List I) (j : I) (u v : Nat) := 2 * edge j u v + total (fun s => edge s u v) xs
theorem directed (xs : List I) (j : I) (u v : Nat)
    (hj : j.1<j.2) (hs : ∀ s ∈ xs, s.1<s.2) (hd : xs.Pairwise disjointInterior) :
    weight xs j u v ≤ 1 + Y xs j u - Y xs j v := by
  by_cases up : u<v
  · have a := ascending xs j u v up hj hs hd
    have e := tt_congr xs (fun s => edge s u v) (fun s => -span s u v) (fun s hi => edgeUp s u v up (hs s hi))
    rw [weight,e,tt_neg,edgeUp j u v up hj]
    dsimp only [D] at a
    omega
  by_cases down : v<u
  · have a := ascending xs j v u down hj hs hd
    have e := tt_congr xs (fun s => edge s u v) (fun s => span s v u) (fun s hi => edgeDown s v u down (hs s hi))
    rw [weight,e,edgeDown j v u down hj]
    dsimp only [D] at a
    omega
  · have eq : u=v := by omega
    subst v; simp [weight,edgeEq,tt_const_zero]

theorem tt_add (xs : List I) (f g : I → Int) :
    total (fun x => f x + g x) xs = total f xs + total g xs := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp only [tt_cons,ih]; omega

theorem walkBound (xs : List I) (j : I) (start u : Nat) (rest : List Nat)
    (hj : j.1<j.2) (hs : ∀ s ∈ xs, s.1<s.2) (hd : xs.Pairwise disjointInterior) :
    2 * walk j start u rest + total (fun s => walk s start u rest) xs ≤
    (rest.length:Int) + 1 + Y xs j u - Y xs j start := by
  induction rest generalizing u with
  | nil => simpa [walk,weight] using directed xs j u start hj hs hd
  | cons v rest ih =>
    have a := directed xs j u v hj hs hd
    have b := ih v
    simp only [walk,tt_add,List.length_cons,Int.natCast_succ] at *
    unfold weight at a
    change 2 * (edge j u v + walk j start v rest) + (total (fun s => edge s u v) xs +
      total (fun s => walk s start v rest) xs) ≤ _
    omega

theorem filtered_sum (cycle : List Nat) (xs : List I) :
    positiveSum cycle xs = total (fun s => demand s cycle) (xs.filter (fun s => decide (0 < demand s cycle))) := by
  induction xs with
  | nil => rfl
  | cons s xs ih =>
    by_cases pos : 0 < demand s cycle
    · simp only [positiveSum,List.map_cons,List.sum_cons] at *
      simp [pos, Int.max_eq_right (Int.le_of_lt pos), ih,tt_cons]
    · simp only [positiveSum,List.map_cons,List.sum_cons] at *
      simp [pos, Int.max_eq_left (show demand s cycle ≤ 0 by omega),ih]

/-- The argument works for arbitrary closed walks and every distinguished interval. -/
theorem closedWalkCounting (cycle : List Nat) (fam : List I) (j : I)
    (hv : ∀ s ∈ fam, s.1 < s.2) (hd : fam.Pairwise disjointInterior) (hj : j.1 < j.2) :
    positiveSum cycle fam ≤ (cycle.length : Int) - 2 * demand j cycle := by
  let xs := fam.filter (fun s => decide (0 < demand s cycle))
  have hs : ∀ s ∈ xs, s.1<s.2 := fun s hi => hv s (List.mem_filter.mp hi).1
  have dis : xs.Pairwise disjointInterior := hd.filter _
  have w : 2 * demand j cycle + total (fun s => demand s cycle) xs ≤ (cycle.length:Int) := by
    cases cycle with
    | nil => simp [demand,tt_zero (xs:=xs) (f:=fun _ => 0) (by simp)]
    | cons u rest =>
      have a := walkBound xs j u u rest hj hs dis
      simp only [demand,List.length_cons,Int.natCast_succ]
      omega
  have f := filtered_sum cycle fam
  change positiveSum cycle fam = total _ xs at f
  omega

theorem counting : CountingBound := by
  intro cycle fam j _ _ _ hv hd hj _ _
  exact closedWalkCounting cycle fam j hv hd hj

#print axioms counting
end TransportCounting.Cover
