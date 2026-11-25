# Five spin-sequence distances in Table 2

Zhang, Shen, Kumar and Pistoia give 12 even-length sequences in Table 2 of their revised preprint. We evaluated their skew-symmetry distance exactly for each sequence under their Appendix A, Eqs. (5)–(9). Five reported distances are higher than the minima obtained from Eq. (9). All twelve printed entries match the deletion-only minima. Eq. (9) permits either one insertion or one deletion after any rotation. This observation concerns the printed data and formula. It does not establish which code the authors ran. [Table 2](https://arxiv.org/html/2504.00987v2#S4.T2) · [Appendix A](https://arxiv.org/html/2504.00987v2#A1)

| Length | Sequence prefix | Printed | Best deletion | Best insertion | Exact minimum |
|---:|:---|---:|---:|---:|---:|
| 92 | EE01 | 12 | 12 | 9 | **9** |
| 98 | 993A | 13 | 13 | 12 | **12** |
| 106 | 696D | 14 | 14 | 9 | **9** |
| 110 | 33F8 | 16 | 16 | 15 | **15** |
| 120 | 84AD | 18 | 18 | 17 | **17** |

## One witness anyone can check

Read `EE01C0E77667DD34DAE94B5` as 92 bits, most significant first. Move the first five bits to the end. Insert a 1 after the first 56 bits of the rotated word. Compare pairs of bits at equal distances from the center of this 93-bit word. Even offsets should match, odd offsets should differ. The failures occur at offsets 6, 8, 16, 17, 19, 24, 33, 42 and 44. That single allowed edit puts the distance at most 9. To prove equality, the checker covers all 92 rotations, 92 deletions and 186 signed insertions per rotation, or 25,576 operations. None gives 8 or fewer failures.

The two 92-bit rows are distinct under reversal and whole-string complementation, the symmetries listed in the preprint’s §II.2. Flipping every other bit maps one row to the other. Their hexadecimal XOR is 23 copies of the digit 5. This known energy symmetry multiplies the correlation at offset k by (−1)ᵏ, so its square is preserved. The energy and single-spin escape measurements on those two rows describe equivalent landscapes. [Sequence symmetries in the preprint](https://arxiv.org/html/2504.00987v2#S2.SS2) · [Earlier symmetry analysis](https://arxiv.org/abs/1512.02475)

## Interpretation and replay

The minimum over all even rows is still 9. The calculation supports the preprint’s stated threshold of 9 for these examples. The ground-state energies are a separate quantity. For the five odd-length rows, every printed value is reproduced by minimizing Eq. (5) over cyclic rotations. The receipt lists the as-printed and best-rotation values separately.

Run `python3 checks/zhang_table.py` from the research branch. It requires only Python’s standard library. One calculation edits character strings and compares symmetric positions. A second enumerates moves from the opposite end using shifts, masks and reversed half-words. They must agree on the complete frequency distribution and the expected operation count for each row. The saved results include every minimum, the edits that attain it, and the offsets to check. This is a reproducible audit of a preprint. Author confirmation and priority for this observation are unverified. [Checker](zhang_table.py) · [All 17 receipts](../campaign/finite-spins-table2.json)
