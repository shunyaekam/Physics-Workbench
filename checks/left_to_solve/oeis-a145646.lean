import OMAStatements.S_oeis_a145646

open OMA.S_oeis_a145646

theorem OMA.disproof : ¬ (type_of% @OMA.S_oeis_a145646.main) := by
  intro h
  have h15 := h.2.2 15 (by decide)
  exact (by decide : ¬ (wavelength 15 = 3 * wavelength (15-1) - 4 * wavelength (15-2) +
    4 * wavelength (15-3) - 3 * wavelength (15-4) + wavelength (15-5))) h15
