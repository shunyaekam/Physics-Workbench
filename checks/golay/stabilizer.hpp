#pragma once
#include <array>
#include <cstdint>

constexpr int n = 23;
using Bits = uint32_t;
struct Gate { int a, b, p, q; }; // X=1, Z=2, Y=3
struct State { std::array<Bits,n> x{}, z{}; };

inline void apply(State& s, Gate g) {
    auto anti = [&](int i, int axis) {
        return ((axis&1) ? s.z[i] : 0) ^ ((axis&2) ? s.x[i] : 0);
    };
    Bits u=anti(g.a,g.p), v=anti(g.b,g.q);
    if (g.p&1) s.x[g.a]^=v;
    if (g.p&2) s.z[g.a]^=v;
    if (g.q&1) s.x[g.b]^=u;
    if (g.q&2) s.z[g.b]^=u;
}

inline bool mixed(const State& s,int i) {
    return s.x[i] && s.z[i] && s.x[i]!=s.z[i];
}
