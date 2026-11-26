"""Exact six-site tests and separate floating-point LP stress tests for the polygon theorem."""
from fractions import Fraction
from itertools import combinations, permutations
from random import Random


def interval_costs(n, weights):
    return {(i, j): sum(w for (a, b), w in weights.items() if i <= a < b <= j)
            for i, j in combinations(range(n), 2)}


def chain_maximum(n, d, extreme_endpoints=False):
    largest = Fraction(0)
    for size in range(3, n + 1):
        for chain in combinations(range(n), size):
            if extreme_endpoints and (chain[0], chain[-1]) != (0, n - 1):
                continue
            deficit = d[chain[0], chain[-1]] - sum(d[i, j] for i, j in zip(chain, chain[1:]))
            largest = max(largest, Fraction(deficit, size))
    return largest


def cycle_incidence(n):
    """Integer rows for directed simple cycles, indexed by length."""
    import numpy as np

    pairs = {pair: i for i, pair in enumerate(combinations(range(n), 2))}
    result = {}
    for size in range(2, n + 1):
        rows = []
        for sites in combinations(range(n), size):
            for tail in permutations(sites[1:]):
                cycle = (sites[0], *tail)
                row = [0] * len(pairs)
                for i, j in zip(cycle, cycle[1:] + cycle[:1]):
                    row[pairs[min(i, j), max(i, j)]] += 1 if i > j else -1
                rows.append(row)
        result[size] = np.array(rows, dtype=np.int64)
    return result


def cycle_maximum(n, d, incidence):
    import numpy as np

    # For these six-site fixtures the largest absolute cycle sum is under 400.
    values = np.array([d[p] for p in combinations(range(n), 2)], dtype=np.int64)
    return max(Fraction(int((rows @ values).max()), k) for k, rows in incidence.items())


def exact_challenge():
    n = 6
    incidence = cycle_incidence(n)
    atoms = [(i, j) for i, j in combinations(range(n), 2) if j - i >= 2]
    for mask in range(1 << len(atoms)):
        weights = {p: (mask >> i) & 1 for i, p in enumerate(atoms)}
        costs = interval_costs(n, weights)
        if not (cycle_maximum(n, costs, incidence) == chain_maximum(n, costs)
                == chain_maximum(n, costs, extreme_endpoints=True)):
            raise ArithmeticError(f'Cycle or chain mismatch for six-site mask {mask}')
    print('Exact integer/rational comparisons passed on 1,024 six-site binary atom arrays.')

    diagonals = ((0, 20, 5, 0, 5), (20, 25, 5, 5), (30, 25, 30), (50, 55), (56,))
    costs = {(i, i + length): v for length, row in enumerate(diagonals, 1)
             for i, v in enumerate(row)}
    if any(costs[i, j] + costs[j, k] > costs[i, k] for i, j, k in combinations(range(n), 3)):
        raise ArithmeticError('Negative control should be superadditive')
    if (cycle_maximum(n, costs, incidence), chain_maximum(n, costs)) != (9, Fraction(25, 3)):
        raise ArithmeticError('Negative control did not separate chain and cycle optima')
    print('Superadditive negative control: maximum cycle 9, maximum increasing chain 25/3.')


def lp_challenge():
    import numpy as np
    from scipy.optimize import linprog

    rng = Random(111925)
    worst_error = 0.
    for _ in range(120):
        n = rng.randint(6, 14)
        weights = {pair: rng.choice((0, 0, 1, 17, 221)) for pair in combinations(range(n), 2)}
        costs = interval_costs(n, weights)
        rows, bounds = [], []
        for (i, j), value in costs.items():
            row = np.zeros(n)
            row[i], row[j] = -1, 1
            rows.extend((np.r_[row, -1], np.r_[-row, -1]))
            bounds.extend((value, -value))
        for i in range(n-1):
            row = np.zeros(n + 1)
            row[i], row[i + 1] = 1, -1
            rows.append(row)
            bounds.append(0)
        result = linprog(np.r_[np.zeros(n), 1], A_ub=rows, b_ub=bounds,
                         bounds=[(0, 0)] + [(None, None)]*(n-1) + [(0, None)], method='highs')
        if not result.success:
            raise ArithmeticError(result.message)
        exact = chain_maximum(n, costs, extreme_endpoints=True)
        error = abs(result.fun - float(exact))
        if not np.isfinite(error) or error > 1e-8:
            raise ArithmeticError(f'Floating LP disagreed with exact chain at {n} sites by {error}')
        worst_error = max(worst_error, error)
    print(f'120 floating-point LPs through 14 sites passed; largest absolute discrepancy {worst_error:.4g}.')


if __name__ == '__main__':
    exact_challenge()
    lp_challenge()
