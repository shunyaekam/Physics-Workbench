#include <array>
#include <iostream>
#include <map>
#include <vector>
using Masks = std::array<int, 1024>;

int rank_at_most(const std::vector<int>& low, int a, int b) {
    int rank = 0;
    std::array<int, 10> pivots{};
    for (int row : low) {
        if (__builtin_parity(row & a) || __builtin_parity(row & b)) continue;
        for (int j = 9; j >= 0; --j) {
            if (!(row & (1 << j))) continue;
            if (pivots[j]) {
                row ^= pivots[j];
            } else {
                pivots[j] = row;
                if (++rank == 8) return rank;
                break;
            }
        }
    }
    return rank;
}

int main() {
    std::vector<std::array<int, 2>> errors;
    for (int x = 0; x < 1024; ++x) {
        for (int z = 0; z < 1024; ++z) {
            int weight = __builtin_popcount(x | z);
            if (weight >= 1 && weight <= 3) errors.push_back({x, z});
        }
    }
    std::array<int, 10> adjacency{};
    int graphs = 0, graphs_with_codes = 0;
    std::map<int, int> hist;
    std::map<std::array<int,11>,int> enumerators;
    while (std::cin >> adjacency[0]) {
        for (int i = 1; i < 10; ++i) if (!(std::cin >> adjacency[i])) return 2;
        for (int i = 0; i < 10; ++i) {
            if (adjacency[i] < 0 || adjacency[i] >= 1024 || ((adjacency[i] >> i) & 1)) return 2;
            for (int j = 0; j < i; ++j) {
                if (((adjacency[i] >> j) & 1) != ((adjacency[j] >> i) & 1)) return 2;
            }
        }
        ++graphs;
        Masks gamma{};
        std::vector<int> low;
        for (int x = 1; x < 1024; ++x) {
            gamma[x] = gamma[x & (x-1)] ^ adjacency[__builtin_ctz(x)];
            if (__builtin_popcount(x | gamma[x]) <= 5) low.push_back(x);
        }
        std::array<bool, 1024> forbidden{};
        std::vector<int> short_graph_elements;
        for (auto [x,z] : errors) {
            int s = z ^ gamma[x];
            if (s) forbidden[s] = true;
            else short_graph_elements.push_back(x);
        }
        std::vector<int> allowed;
        for (int v = 1; v < 1024; ++v) {
            for (int x : short_graph_elements) {
                if (__builtin_parity(v & x)) { forbidden[v] = true; break; }
            }
            if (!forbidden[v]) allowed.push_back(v);
        }
        bool has_code = false;
        for (int a : allowed) {
            for (int b : allowed) {
                if (a >= b || b >= (a ^ b) || forbidden[a ^ b]) continue;
                has_code = true;
                int r = rank_at_most(low, a, b);
                ++hist[r];
                std::array<int,11> spectrum{};
                for (int x = 0; x < 1024; ++x) {
                    if (!__builtin_parity(x & a) && !__builtin_parity(x & b))
                        ++spectrum[__builtin_popcount(x | gamma[x])];
                }
                ++enumerators[spectrum];
                if (r == 8) {
                    std::cerr << "Found a candidate, graph " << graphs << " labels " << a << ' ' << b << '\n';
                }
            }
        }
        graphs_with_codes += has_code;
    }
    std::cout << "graphs " << graphs << "\ngraphs_with_codes " << graphs_with_codes;
    std::cout << "\nerrors " << errors.size() << "\nrank : subspaces\n";
    for (auto [r,n] : hist) std::cout << r << ' ' << n << '\n';
    for (auto [counts,multiplicity] : enumerators) {
        std::cout << "enumerator";
        for (int count : counts) std::cout << " " << count;
        std::cout << " multiplicity " << multiplicity << '\n';
    }
    std::array<int,11> known{1,0,0,0,0,0,90,0,135,0,30};
    return (std::cin.eof() && graphs == 3990 && graphs_with_codes == 10
            && errors.size() == 3675 && hist.size() == 1 && hist[0] == 47
            && enumerators.size() == 1 && enumerators[known] == 47) ? 0 : 1;
}
