# A hydrogen wavelength recurrence fails at level 15

OEIS A145646 records the nearest integer to the wavelength in ångströms under the series-limit rule a(n) = round(c n²). Colin Barker proposed a fifth-order recurrence in 2019. Through level 14 it agrees with the executable definition in the entry. At level 15 the recurrence produces 205,034 Å. Rounding gives 205,035 Å. This tests an integer sequence conjecture about a physical scale. [Source and conventions](https://oeis.org/A145646)

The conclusion even follows without fixing the Rydberg constant to the decimal used in the entry. Row 9 is 73,813 and row 12 is 131,222. Rounding bounds give 147625/162 ≤ c ≤ 262445/288. For every scale consistent with those two rows the rounded values at levels 10 through 15 are respectively 91,127, 110,263, 131,222, 154,004, 178,608 and 205,035. For each new row the entire interval lies strictly inside its nearest-integer bin. Row 12 is supplied directly by the table. Substitution of the first five in Barker’s rule yields 205,034.

[Exact interval replay](replay_hydrogen.py) · [Lean certificate for the source’s executable convention](Hydrogen.lean)

The same discrepancy propagates to the forward differences in A145647. At level 14 the gap is 26,427 Å; the proposed gap recurrence gives 26,426 Å. Both failures are the same rounding effect. [Difference sequence](https://oeis.org/A145647)
