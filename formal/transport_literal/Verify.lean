import TransportLiteral

/-! The statement on this side of the proof boundary spells out the arithmetic.
The theorem below must elaborate against it, even if the implementation changes. -/
namespace LiteralContract

private def energy (i : Fin 3) : ℕ := if i = 0 then 0 else if i = 1 then 9 else 25
private noncomputable def fourthRootGap (f : Fin 3 → ℝ) (i j : Fin 3) := Real.sqrt (Real.sqrt |f i - f j|)

theorem exactCuts (i j : Fin 3) :
    Real.sqrt |(energy i : ℝ) - (energy j : ℝ)| =
      fourthRootGap (fun k => if k = 0 then 16 else 0) i j +
      fourthRootGap (fun k => if k = 1 then 1 else 0) i j +
      fourthRootGap (fun k => if k = 2 then 81 else 0) i j :=
  TransportLiteral.lowerExponentRealization i j

theorem threeCosts :
    Real.sqrt |(0 : ℝ) - 9| = 3 ∧ Real.sqrt |(9 : ℝ) - 25| = 4 ∧
    Real.sqrt |(0 : ℝ) - 25| = 5 := TransportLiteral.squareRootCosts

private def fits (x y z e : ℝ) : Prop :=
  abs (|x - y| - 3) ≤ e ∧ abs (|y - z| - 4) ≤ e ∧ abs (|x - z| - 5) ≤ e

theorem optimum :
    (∀ x y z e : ℝ, fits x y z e → (2 : ℝ)/3 ≤ e) ∧
    fits 0 (7/3) (17/3) (2/3) ∧ (¬ ∃ x y z : ℝ, fits x y z 0) :=
  ⟨TransportLiteral.lower, TransportLiteral.attained, TransportLiteral.noExactLine⟩

#print axioms LiteralContract.exactCuts
#print axioms LiteralContract.threeCosts
#print axioms LiteralContract.optimum
end LiteralContract
