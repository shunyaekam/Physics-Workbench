#include <array>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <random>
#include <string>
#include <vector>

using Check = std::array<unsigned, 2>;

class Search {
    int n, rank, distance, limit;
    std::mt19937 rng;

    int pick(int choices) { return rng() % choices; }

    static unsigned letter(const Check& r, int j) {
        return ((r[0] >> j) & 1U) | (((r[1] >> j) & 1U) << 1);
    }

    static void multiply(Check& r, int j, unsigned p) {
        if (p & 1) r[0] ^= 1U << j;
        if (p & 2) r[1] ^= 1U << j;
    }

    static int weight(const Check& r) { return __builtin_popcount(r[0] | r[1]); }

    int cost(const std::vector<Check>& checks) const {
        std::array<unsigned char, 4096> frequencies{};
        std::array<std::array<unsigned, 3>, 12> columns{};
        int bad = 0;
        for (int i = 0; i < rank; ++i) {
            for (int j = 0; j < i; ++j) {
                const unsigned overlaps = (checks[i][0] & checks[j][1]) ^
                                          (checks[i][1] & checks[j][0]);
                bad += __builtin_parity(overlaps);
            }
        }
        for (int q = 0; q < n; ++q) {
            unsigned x = 0, z = 0;
            for (int r = 0; r < rank; ++r) {
                x |= ((checks[r][0] >> q) & 1U) << r;
                z |= ((checks[r][1] >> q) & 1U) << r;
            }
            columns[q] = {x, z, x ^ z};
            for (unsigned s : columns[q]) {
                bad += frequencies[s]++;
                bad += 2 * (s == 0);
            }
        }
        if (distance == 3) return bad;
        int triples = 0;
        for (int i = 0; i < n; ++i)
            for (int j = 0; j < i; ++j)
                for (unsigned a : columns[i])
                    for (unsigned b : columns[j])
                        triples += frequencies[a ^ b];
        return 4 * bad + triples / 3;
    }

    bool propose(Check& r) {
        const int j = pick(n);
        const unsigned old = letter(r, j);
        if (old == 0) {
            int source = pick(n);
            while (!letter(r, source)) source = pick(n);
            multiply(r, source, letter(r, source));
            multiply(r, j, 1 + pick(3));
        } else if (pick(10) == 0) {
            if (weight(r) < limit) return false;
            multiply(r, j, old);
        } else {
            multiply(r, j, old ^ (1 + pick(3)));
        }
        if (weight(r) < limit && pick(3) == 0) {
            int vacant = pick(n);
            while (letter(r, vacant)) vacant = pick(n);
            multiply(r, vacant, 1 + pick(3));
        }
        return true;
    }

public:
    Search(int n, int k, int d, int w, unsigned seed)
        : n(n), rank(n-k), distance(d), limit(w), rng(seed) {}

    bool run(int restarts) {
        constexpr int steps = 30000;
        for (int run = 0; run < restarts; ++run) {
            std::vector<Check> checks(rank);
            for (auto& r : checks) {
                while (weight(r) < limit) {
                    int q = pick(n);
                    multiply(r, q, 1 + pick(3));
                }
            }
            int score = cost(checks);
            for (int t = 0; t < steps; ++t) {
                if (score == 0) {
                    std::cerr << "restart " << run << ", iteration " << t << "\n";
                    for (const Check& r : checks) {
                        for (int q = 0; q < n; ++q) std::cout << "IXZY"[letter(r, q)];
                        std::cout << '\n';
                    }
                    return true;
                }
                Check& row = checks[pick(rank)];
                const Check saved = row;
                if (!propose(row)) continue;
                const double remaining = 1.0 - double(t) / steps;
                const double temperature = distance == 3
                    ? .12 + 1.18 * remaining * remaining
                    : .22 + 4.8 * remaining * remaining;
                const int next = cost(checks);
                if (next <= score || std::generate_canonical<double, 32>(rng)
                                          < std::exp((score - next) / temperature)) {
                    score = next;
                } else {
                    row = saved;
                }
            }
        }
        return false;
    }
};

int main(int argc, char** argv) {
    if (argc != 7) {
        std::cerr << "Usage: search n k distance weight seed restarts\n";
        return 2;
    }
    try {
        const int n = std::stoi(argv[1]), k = std::stoi(argv[2]);
        const int d = std::stoi(argv[3]), w = std::stoi(argv[4]);
        const auto seed = std::stoul(argv[5]);
        const int runs = std::stoi(argv[6]);
        if (n < 2 || n > 12 || k < 1 || k >= n || (d != 3 && d != 4)
                || w < 2 || w > n || runs < 1 || seed > UINT32_MAX) return 2;
        return Search(n, k, d, w, static_cast<unsigned>(seed)).run(runs) ? 0 : 1;
    } catch (const std::exception&) { return 2; }
}
