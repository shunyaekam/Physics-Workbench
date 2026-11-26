import CountingProof

theorem verifiedCounting : TransportCounting.CountingBound :=
  TransportCounting.Cover.counting

#print axioms verifiedCounting

open TransportCounting
-- The coefficient two is sharp even for a three-site simple cycle.
example : positiveSum [0,1,2] [(0,2)] = (1 : Int) ∧ demand (0,2) [0,1,2] = 1 := by decide
example : ¬ (positiveSum [0,1,2] [(0,2)] ≤ (3 : Int) - 3*demand (0,2) [0,1,2]) := by decide
-- Overlapping interiors can charge the same part of a cycle twice.
example : ¬ (positiveSum [0,1,2] [(0,2),(0,2)] ≤ (3 : Int) - 2*demand (0,2) [0,1,2]) := by decide
