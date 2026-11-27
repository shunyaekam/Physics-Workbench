from random import Random

def check(n, order):
    heights = [0] + [4] * (n - 1)
    count = [0] * n
    available = {i for i, sand in enumerate(heights) if sand >= 4}
    while available:
        i = order(available)
        count[i] += 1
        heights[i] -= 4
        for j in (i, i, (i - 1) % n, (i + 1) % n):
            if j:
                heights[j] += 1
                if heights[j] >= 4:
                    available.add(j)
        if heights[i] < 4:
            available.remove(i)
    each = [(i * (n - i) + (0 if n % 2 else min(i, n-i))) // 2 for i in range(n)]
    assert each == count
    assert heights == [0] + [2 if 2*i == n else 3 for i in range(1,n)]
    return sum(count)

rng = Random(42)
for n in range(1, 51):
    expected = sum(j * (n-j) for j in range(1, n//2+1))
    for order in (min, max, lambda active: rng.choice(tuple(active))):
        assert check(n, order) == expected
print('150 legal serial stabilizations, 1 ≤ n ≤ 50, with per-vertex odometers and terminal heights verified')
