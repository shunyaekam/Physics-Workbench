"""Search for violations of the seven-frame pair bound by complex Stiefel ascent."""
import argparse
from itertools import combinations

import numpy as np
import torch

from pair_extension import planes, projector_score


def wedge_pairs(rows, pairs):
    return torch.stack([
        rows[:, :, a, :, None] * rows[:, :, b, None, :] -
        rows[:, :, b, :, None] * rows[:, :, a, None, :]
        for a, b in pairs
    ], dim=2)


def objective(u, groups):
    rows = u[groups]
    row_pairs = [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)]
    p = wedge_pairs(rows[:, :, :, :2], row_pairs)[:, :, :, 0, 1]
    remaining = wedge_pairs(rows[:, :, :, 2:], row_pairs[::-1])
    pairs = list(combinations(range(5), 2))
    remaining = remaining[..., [a for a, _ in pairs], [b for _, b in pairs]]
    signs = u.real.new_tensor([1, -1, 1, 1, -1, 1])
    minors = (p[..., None] * signs[:, None] * remaining).sum(dim=2)
    return minors.sum(dim=1).abs().square().sum()


def ascent(frame, groups, steps):
    """Retract along the Stiefel tangent gradient and backtrack on the actual score."""
    u = torch.tensor(frame)
    rate = .24
    score = objective(u, groups).item()
    for _ in range(steps):
        u = u.detach().requires_grad_()
        objective(u, groups).backward()
        g = u.grad
        tangent = g - u @ ((u.mH @ g + g.mH @ u) / 2)
        if torch.linalg.norm(tangent).item() < 1e-10:
            break
        with torch.no_grad():
            for _ in range(14):
                point = torch.linalg.qr(u + rate * tangent)[0]
                value = objective(point, groups).item()
                if value > score:
                    u, score = point, value
                    rate = min(.8, rate * 1.2)
                    break
                rate *= .5
            else:
                break
    return u.detach().numpy(), score


def run(d, restarts, steps, seed):
    groups = planes(d)
    rng = np.random.default_rng(seed)
    ev = []
    for i in range(restarts):
        start = rng.normal(size=(d, 7)) + 1j * rng.normal(size=(d, 7))
        if i % 2:
            start = .15 * start + np.eye(d, 7)
        frame = np.linalg.qr(start)[0]
        final, value = ascent(frame, torch.tensor(groups), steps)
        replay = projector_score(final, groups)
        if abs(replay - value) > 1e-10 or not np.isfinite(replay):
            raise ArithmeticError('Optimization failed direct minor replay')
        if np.linalg.norm(final.conj().T @ final - np.eye(7)) > 1e-10:
            raise ArithmeticError('Returned point failed orthonormality check')
        if replay > 2 + 1e-8:
            np.save(f'pair_extension_witness_d{d}_{seed}_{i}.npy', final)
            print('Numerical violation for dimension, seed, start, score', d, seed, i, replay)
            break
        ev.append(replay)
    if ev:
        print(f'd={d}, seed={seed}, optimized starts={len(ev)}, {steps} steps per start, '
              f'endpoint range [{min(ev):.12f}, {max(ev):.12f}]')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--dimension', type=int, default=16, choices=(16, 32, 64))
    parser.add_argument('--starts', type=int, default=12)
    parser.add_argument('--steps', type=int, default=120)
    parser.add_argument('--seed', type=int, default=16607)
    args = parser.parse_args()
    torch.set_num_threads(1)
    run(args.dimension, args.starts, args.steps, args.seed)
