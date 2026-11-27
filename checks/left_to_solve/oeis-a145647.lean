import OMAStatements.S_oeis_a145647

open OMA.S_oeis_a145647

theorem OMA.disproof : ¬ (type_of% @OMA.S_oeis_a145647.main) := by
  intro h
  have h14 := h.2.2 14 (by decide)
  exact (by decide : ¬ (gap 14 = 2 * gap (14-1) - 2 * gap (14-2) +
    2 * gap (14-3) - gap (14-4))) h14
