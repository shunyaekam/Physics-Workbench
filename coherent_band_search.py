"""Probe coherent Fock superpositions beyond the fixed three-level screen."""
from itertools import count
from pathlib import Path

import numpy as np

from lab import write
from three_level_search import quantities


OUT = Path(__file__).resolve().parent / 'campaign/coherent-bands'
BANDS = ((0, 1, 2, 3, 4, 5, 6), (2, 3, 4, 5, 6, 7), (0, 1, 3, 6, 9, 12),
         (5, 6, 7, 8, 9, 10, 11), (0, 2, 4, 8, 16, 24))


def advance():
    OUT.mkdir(parents=True, exist_ok=True)
    batch = next(i for i in count(1) if not (OUT/f'{i:08d}.json').exists())
    levels = BANDS[(batch-1) % len(BANDS)]
    seed = 373997 + batch
    rng = np.random.default_rng(seed)
    rows = []
    for trial in range(32):
        # Rotate the dominant level, and also test broadly spread amplitudes.
        components = rng.integers(-12, 13, (len(levels), 2))
        if np.any(np.all(components == 0, axis=1)):
            continue
        if trial % 2:
            components[trial//2 % len(levels)] *= 6
        c = components[:, 0] + 1j*components[:, 1]
        w, h = quantities(levels, c, 128, 96)
        rows.append((w/h, trial, components, w, h))
    top = sorted(rows, key=lambda row: row[0], reverse=True)[:3]
    # Retain a contender with appreciable negative volume even if the raw
    # ratio prefers nearly coherent states.
    negative = [row for row in rows if row[3] > 1.1]
    if negative:
        best = max(negative, key=lambda row: row[0])
        if all(row[1] != best[1] for row in top):
            top.append(best)
    finalists = []
    for _, trial, components, w, h in top:
        c = components[:, 0] + 1j*components[:, 1]
        refined = [quantities(levels, c, nr, na) for nr, na in ((256, 192), (512, 384))]
        finalists.append(dict(trial=trial, coefficients=components.tolist(),
                              coarse=[w, h], refined=refined))
    control = quantities((0, 1, 2, 3), [0, 1, 0, 0], 512, 384)
    if max(abs(control[0]-(4*np.exp(-0.5)-1)), abs(control[1]-np.pi/2)) > 0.0003:
        raise ArithmeticError('Fock normalization control failed')
    flagged = any(w > h for row in finalists for w, h in row['refined'])
    write(OUT/f'{batch:08d}.json', dict(batch=batch, seed=seed, levels=levels,
          tested=len(rows), control=control, finalists=finalists,
          status='needs_rigorous_enclosure' if flagged else 'screen_only'))
    print(f'Batch {batch} screened {len(rows)} states on {levels}. '
          f'Largest finalist ratio on the finest grid: '
          f'{max(row["refined"][-1][0]/row["refined"][-1][1] for row in finalists):.8f}.')


if __name__ == '__main__':
    advance()
