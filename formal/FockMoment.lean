import Init.Data.Nat.SOM
import Init.Omega

/- Algebraic step of the phase-invariant Wigner bound, Lean 4.19.0.
   The coefficients in each list are in descending order. -/
namespace Workbench.Fock
open Nat.SOM

private def horner (cs : List Nat) (n : Nat) :=
  cs.foldl (fun acc c => acc * n + c) 0

def moment (n : Nat) := horner [70, 140, 170, 100, 24] n

private def tailCoeffs := [120, 1620, 9672, 33516, 74088, 107730, 102244, 60606, 20324]

-- Build the same univariate expressions in Lean's verified polynomial normalizer.
private def poly (cs : List Nat) (x : Expr) :=
  cs.foldl (fun acc c => Expr.add (.mul acc x) (.num c)) (.num 0)

private def power (x : Expr) : Nat → Expr
  | 0 => .num 1
  | k+1 => .mul (power x k) x

private def mom (x : Expr) := poly [70, 140, 170, 100, 24] x

private def plus (x : Expr) (n : Nat) := x.add (.num n)

private theorem expansion (n : Nat) :
    (n+2)^8 * moment n =
    (n+1)^8 * moment (n+2) + (horner tailCoeffs n * n + 3000) := by
  let x := Expr.var 0
  let lhs := (power (plus x 2) 8).mul (mom x)
  let rhs := ((power (plus x 1) 8).mul (mom (plus x 2))).add
    (plus ((poly tailCoeffs x).mul x) 3000)
  exact Expr.eq_of_toPoly_eq (.leaf n) lhs rhs (by decide)

theorem fourthMoment_step (n : Nat) :
    (n+1)^8 * moment (n+2) < (n+2)^8 * moment n := by
  rw [expansion]
  omega

theorem baseMoments : moment 1 = 504 ∧ moment 2 = 3144 := by decide

#print axioms fourthMoment_step
#print axioms baseMoments
end Workbench.Fock
