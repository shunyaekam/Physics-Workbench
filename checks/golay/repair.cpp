// Search an exact stabilizer neighborhood: omit gates, then synthesize a shorter
// suffix on the remaining mixed sites. Integers index binary stabilizer generators.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <stdexcept>
#include <vector>

#include "stabilizer.hpp"

// Fundamental circuits of the binary column matroid, with the two columns at
// each physical site grouped together. A pure tensor factor corresponds to a
// direct summand, so each component of m sites costs at least m-1 entanglers.
struct Groups {
    std::array<int,n> root;
    Groups(){std::iota(root.begin(),root.end(),0);}
    int find(int i){while(root[i]!=i){root[i]=root[root[i]];i=root[i];}return i;}
    void join(int a,int b){root[find(a)]=find(b);}
};
int components(const State& s,const std::vector<int>& sites,Groups& groups) {
    std::array<Bits,n> pivot{},support{};
    std::array<int,n> owner{};
    for (int i:sites) for (Bits column:{s.x[i],s.z[i]}) {
        Bits used=0;
        while(column) {
            int bit=31-__builtin_clz(column);
            if(!pivot[bit]) {
                pivot[bit]=column; support[bit]=used^(Bits(1)<<bit); owner[bit]=i;
                break;
            }
            column^=pivot[bit];used^=support[bit];
        }
        if(!column) while(used){
            int bit=__builtin_ctz(used);groups.join(i,owner[bit]);used&=used-1;
        }
    }
    int count=0;
    for(int i:sites) if(groups.find(i)==i) ++count;
    return count;
}

struct Search {
    int drop,save;
    std::vector<Gate> seed,tail,answer;
    std::vector<int> omissions,winning_omissions;
    uint64_t masks=0, entered=0, children=0, bound_prunes=0, slack_nodes=0;
    bool found=false;

    bool repair(const State& state,int budget){
        ++entered;
        std::vector<int> sites;
        for(int i=0;i<n;++i) if(mixed(state,i)) sites.push_back(i);
        if(sites.empty()) return true;
        if(int(sites.size())>2*budget){++bound_prunes;return false;}
        Groups groups;
        int lower=int(sites.size())-components(state,sites,groups);
        if(lower>budget){++bound_prunes;return false;}
        if(lower<budget) {
            // With spare gates a circuit may temporarily couple independent
            // factors or use a pure spectator. Enumerate every wire pair.
            ++slack_nodes;
            sites.resize(n);
            std::iota(sites.begin(),sites.end(),0);
        }
        for(size_t a=0;a<sites.size();++a) for(size_t b=0;b<a;++b) {
            int i=sites[a],j=sites[b];
            if(lower==budget && groups.find(i)!=groups.find(j)) continue;
            for(int p=1;p<=3;++p) for(int q=1;q<=3;++q) {
                Gate gate{i,j,p,q}; State next=state;
                apply(next,gate); ++children;
                tail.push_back(gate);
                if(repair(next,budget-1)) return true;
                tail.pop_back();
            }
        }
        return false;
    }

    void visit(int pos,int left,State state){
        if(found) return;
        if(!left){
            for(int i=pos;i<int(seed.size());++i) apply(state,seed[i]);
            ++masks;
            if(repair(state,drop-save)){
                found=true;answer=tail;winning_omissions=omissions;
            }
            return;
        }
        for(int i=pos;i<=int(seed.size())-left && !found;++i){
            omissions.push_back(i);visit(i+1,left-1,state);omissions.pop_back();
            apply(state,seed[i]);
        }
    }
};

int main(int argc,char** argv){
    if(argc==2 && std::string(argv[1])=="--components"){
        State sample;
        while(std::cin>>sample.x[0]){
            for(int i=1;i<n;++i) if(!(std::cin>>sample.x[i])) return 2;
            for(auto& z:sample.z) if(!(std::cin>>z)) return 2;
            Groups groups;
            std::vector<int> sites;
            for(int i=0;i<n;++i) if(mixed(sample,i)) sites.push_back(i);
            components(sample,sites,groups);
            for(int i=0;i<n;++i) std::cout<<groups.find(i)<<" ";
            std::cout<<"\n";
        }
        return 0;
    }
    if(argc!=3) return 2;
    Search search{};
    search.drop=std::stoi(argv[1]);search.save=std::stoi(argv[2]);
    State state;
    for(auto& a:state.x) std::cin>>a;
    for(auto& a:state.z) std::cin>>a;
    Gate g;
    while(std::cin>>g.a>>g.b>>g.p>>g.q){
        if(g.a<0||g.a>=n||g.b<0||g.b>=n||g.a==g.b||g.p<1||g.p>3||g.q<1||g.q>3) return 2;
        search.seed.push_back(g);
    }
    if(search.drop<1 || search.drop>int(search.seed.size()) || search.save<0 || search.save>search.drop) return 2;
    search.visit(0,search.drop,state);
    std::cout<<"{\"masks\":"<<search.masks<<",\"repair_nodes\":"<<search.entered
             <<",\"suffix_gates_scored\":"<<search.children<<",\"bound_prunes\":"<<search.bound_prunes
             <<",\"slack_nodes\":"<<search.slack_nodes<<",\"found\":"<<(search.found?"true":"false")<<",\"omitted\":[";
    for(size_t i=0;i<search.winning_omissions.size();++i) std::cout<<(i?",":"")<<search.winning_omissions[i];
    std::cout<<"],\"tail\":[";
    for(size_t i=0;i<search.answer.size();++i){
        auto h=search.answer[i];std::cout<<(i?",":"")<<"["<<h.a<<","<<h.b<<","<<h.p<<","<<h.q<<"]";
    }
    std::cout<<"]}\n";
}
