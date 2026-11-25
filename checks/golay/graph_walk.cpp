// Construct a fresh graph-state suffix. Each CZ deletion and row addition
// costs one entangler; toggling the subgraph on a vertex's neighbors is free.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <random>
#include <vector>

constexpr int n=23;
using Graph=std::array<uint32_t,n>;
int pop(uint32_t x){return __builtin_popcount(x);}
int next(uint32_t& x){int i=__builtin_ctz(x);x&=x-1;return i;}

struct Move {char kind; int a,b;};
int size(const Graph& g){
    int count=0;for(auto neighbors:g) count+=pop(neighbors);return count/2;
}
void perform(Graph& g,Move move){
    int a=move.a,b=move.b;
    if(move.kind=='L'){
        for(uint32_t rest=g[a];rest;){
            int j=next(rest); g[j]^=g[a]^(1u<<j);
        }
    }else if(move.kind=='C'){
        uint32_t changed=g[b]&~(1u<<a);
        g[a]^=changed;
        for(;changed;){int j=next(changed);g[j]^=1u<<a;}
    }else{
        g[a]^=1u<<b;g[b]^=1u<<a;
    }
}
int local_gain(const Graph& g,int i){
    int twice_edges=0,deg=pop(g[i]);
    for(uint32_t r=g[i];r;){int j=next(r);twice_edges+=pop(g[i]&g[j]);}
    return twice_edges-deg*(deg-1)/2;
}

struct Frontier {int prefix; Graph graph;};
struct Best {int cost=1000,frontier=-1; std::vector<Move> path;};

void trial(const Frontier& f,int id,std::mt19937& rng,Best& best){
    Graph g=f.graph;
    std::vector<Move> moves;
    auto act=[&](Move m){perform(g,m);moves.push_back(m);};
    auto randomize=[&](int steps){
        for(int j=0;j<steps;++j){
            int i=rng()%n;if(pop(g[i])>1) act({'L',i,i});
        }
    };
    randomize(rng()%27);
    for(int cost=f.prefix;cost<best.cost;++cost){
        // Free local complementations can expose twin vertices and remove edges.
        if(rng()%6==0) randomize(rng()%9);
        for(int pass=0;pass<n;++pass){
            int gain=0,index=-1,ties=0;
            for(int i=0;i<n;++i){
                int d=local_gain(g,i);
                if(d>gain){gain=d;index=i;ties=1;}
                else if(d==gain && d>0 && rng()%++ties==0) index=i;
            }
            if(index<0) break;
            act({'L',index,index});
        }
        int e=size(g);
        if(cost+e<best.cost){
            best={cost+e,id,moves};
            for(int i=0;i<n;++i) for(int j=i+1;j<n;++j)
                if(g[i]&(1u<<j)) best.path.push_back({'Z',i,j});
            if(best.cost<=43) return;
        }
        if(e==0 || cost+1>=best.cost) return;
        Move selected{};
        int high=-100000;
        int jitter=(rng()%6==0)?100:28;
        for(int i=0;i<n;++i) if(g[i]){
            for(int j=0;j<n;++j) if(i!=j && g[j]){
                bool adjacent=(g[i]>>j)&1;
                int common=pop(g[i]&g[j]);
                auto consider=[&](char kind,int gain,int frees){
                    int score=gain*22+frees*18+int(rng()%jitter);
                    if(score>high){high=score;selected={kind,i,j};}
                };
                if(adjacent && i<j)
                    consider('Z',1,(pop(g[i])==1)+(pop(g[j])==1));
                int gain=2*common-pop(g[j])+int(adjacent);
                if(gain>=0 && pop(g[j])>int(adjacent))
                    consider('C',gain,pop(g[i])==gain);
            }
        }
        act(selected);
    }
}

int main(int argc,char** argv){
    if(argc!=3) return 2;
    std::mt19937 rng(std::stoul(argv[1]));
    int requested=std::stoi(argv[2]),tried=0;
    std::vector<Frontier> inputs;
    Frontier f;
    while(std::cin>>f.prefix){
        for(auto& row:f.graph) if(!(std::cin>>row)) return 2;
        inputs.push_back(f);
    }
    if(inputs.empty()||requested<1) return 2;
    Best best;
    for(;tried<requested && best.cost>43;++tried){
        int id=tried%inputs.size();
        trial(inputs[id],id,rng,best);
    }
    std::cout<<"{\"trials\":"<<tried<<",\"cost\":"<<best.cost<<",\"frontier\":"<<best.frontier<<",\"moves\":[";
    for(size_t i=0;i<best.path.size();++i){
        auto m=best.path[i];
        std::cout<<(i?",":"")<<"[\""<<m.kind<<"\","<<m.a<<","<<m.b<<"]";
    }
    std::cout<<"]}\n";
}
