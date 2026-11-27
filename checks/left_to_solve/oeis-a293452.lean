import OMAStatements.S_oeis_a293452

open OMA.S_oeis_a293452

theorem OMA.disproof : ¬ (type_of% @OMA.S_oeis_a293452.main) := by
  intro claim
  have stable : completes (initial 1) [] := by
    intro j
    have hz : j.val = 0 := by have hj := j.isLt; omega
    simp [initial, hz]
  have wrong : 0 = rectangleSum 1 :=
    (claim 1 (by decide) 0).mp ⟨[], stable, rfl⟩
  have corrected : rectangleSum 1 = 1 := by decide
  omega
