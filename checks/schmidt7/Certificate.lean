import Std
namespace SchmidtSeven
set_option maxRecDepth 10000
set_option maxHeartbeats 4000000

-- The labels of a wedge are zero-based; gaps are numbered one through seven.
def choose : List Nat → Nat → List (List Nat)
  | _, 0 => [[]]
  | [], _+1 => []
  | a::xs, k+1 => (choose xs k).map (a :: ·) ++ choose xs (k+1)

def wedges := choose (List.range 7) 4

def wedgeMask (f : List Nat) : Nat := f.foldl (fun m i => m + 2^i) 0
def plane (f : List Nat) : Bool := f.foldl Nat.xor 0 == 0

-- Fill the four gap slots from narrowest to widest. Every earlier selection
-- is admissible at a later slot, so only the number already used is subtracted.
def weight (f k : List Nat) : Nat :=
  k.zipIdx.foldl (fun total (j, chosen) => total * ((f.filter (· < j)).length - chosen)) 1

structure Row where
  kind : Nat
  mask : Nat
  pin : Nat
  mul : Nat

def pop (mask : Nat) := ((List.range 7).filter (fun i => mask.testBit i)).length

def rhs (r : Row) : Nat := match r.kind with
  | 0 | 1 => 1
  | 2 => 3
  | _ => 2

def valid (r : Row) (small : Bool) : Bool :=
  r.mask < 128 && match r.kind with
  | 0 => pop r.mask == 3
  | 1 => pop r.mask == 5
  | 2 => pop r.mask == 6
  | 3 => pop r.mask == 6 && r.mask.testBit r.pin
  | 4 => small && pop r.mask == 2
  | _ => false

def applies (r : Row) (mask : Nat) : Bool :=
  if r.kind == 0 || r.kind == 4 then (r.mask &&& mask) == r.mask
  else (r.mask &&& mask) == mask && (r.kind != 3 || mask.testBit r.pin)

def check (key : List Nat) (den : Nat) (rs : List Row) (small : Bool) : Bool :=
  den > 0 && rs.all (fun r => valid r small) &&
  rs.foldl (fun s r => s+r.mul*rhs r) 0 ==
    den * ((wedges.filter plane).map (fun f => weight f key)).sum &&
  wedges.all (fun f =>
    den * weight f key <= (rs.filter (fun r => applies r (wedgeMask f))).foldl (fun s r => s+r.mul) 0)
end SchmidtSeven
