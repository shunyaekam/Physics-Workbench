import Std

namespace HydrogenSeries

/-- OEIS A145646's Maple constant, converted to exact integer arithmetic.
At the indices checked below, there are no rounding ties. -/
def wavelength (n : Nat) : Int :=
  Int.ofNat ((2 * n ^ 2 * 10 ^ 16 + 10973731568527) / (2 * 10973731568527))

def recurrence (n : Nat) : Int :=
  3 * wavelength (n - 1) - 4 * wavelength (n - 2) + 4 * wavelength (n - 3)
    - 3 * wavelength (n - 4) + wavelength (n - 5)

theorem first_failure :
    (∀ i : Fin 9, wavelength (i.val + 6) = recurrence (i.val + 6)) ∧
      wavelength 15 = 205035 ∧ recurrence 15 = 205034 := by decide

theorem refutation : ¬ (∀ n : Nat, 5 < n → wavelength n = recurrence n) := by
  intro h
  have equality := h 15 (by decide)
  rw [first_failure.2.1, first_failure.2.2] at equality
  contradiction

def gap (n : Nat) : Int := wavelength (n+1) - wavelength n

def gapRule (n : Nat) : Int :=
  2 * gap (n-1) - 2 * gap (n-2) + 2 * gap (n-3) - gap (n-4)

theorem first_gap_failure :
    (∀ i : Fin 9, gap (i.val+5) = gapRule (i.val+5)) ∧
      gap 14 = 26427 ∧ gapRule 14 = 26426 := by decide

end HydrogenSeries

#print axioms HydrogenSeries.refutation

#print axioms HydrogenSeries.first_gap_failure
