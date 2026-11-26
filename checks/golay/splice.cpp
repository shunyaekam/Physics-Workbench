// Delete two gates and insert one arbitrary controlled-Pauli anywhere among
// the survivors. Commute the insertion through the suffix in the Pauli frame.
#include "stabilizer.hpp"
#include <iostream>
#include <vector>
#include <algorithm>
#include <stdexcept>
#include <string>
#include <map>

struct Pauli {Bits x=0,z=0;};
Pauli operator^(Pauli a,Pauli b){return {a.x^b.x,a.z^b.z};}
using Images=std::array<std::array<Pauli,4>,n>;
Bits anti(const State& s,int i,int p){
    return ((p&1)?s.z[i]:0)^((p&2)?s.x[i]:0);
}
void extend(Images& images,Gate g){
    auto u=images[g.a][g.p],v=images[g.b][g.q];
    for(int axis=1;axis<=3;++axis){
        if(axis!=g.p) images[g.a][axis]=images[g.a][axis]^v;
        if(axis!=g.q) images[g.b][axis]=images[g.b][axis]^u;
    }
}
bool in_plane(Bits v,Bits a,Bits b){return v==a || v==b || v==(a^b);}
bool reachable_after(const State& end,const std::vector<int>& order,
                   Pauli u,Pauli v,Bits au,Bits av,int allowed){
    for(int i:order){
        Bits x=end.x[i]^(((v.x>>i)&1)?au:0)^(((u.x>>i)&1)?av:0);
        Bits z=end.z[i]^(((v.z>>i)&1)?au:0)^(((u.z>>i)&1)?av:0);
        if(x && z && x!=z && --allowed<0) return false;
    }
    return true;
}
// Controlled Pauli gates are polynomials in their two one-wire axes.
bool obviously_commutes(Gate a, Gate b){
    return (a.a!=b.a || a.p==b.p) && (a.a!=b.b || a.p==b.q) &&
           (a.b!=b.a || a.q==b.p) && (a.b!=b.b || a.q==b.q);
}
void check_swap(Gate a,Gate b){
    // Two batches span all single-qubit X and Z Paulis. Splice predicates
    // depend only on this binary action. The local-axis test also certifies
    // exact unitary commutation from the controlled-phase polynomial.
    for(int axis=0;axis<2;++axis){
        State first{};
        for(int i=0;i<n;++i) (axis ? first.z : first.x)[i]=1u<<i;
        State second=first;
        apply(first,a);apply(first,b);
        apply(second,b);apply(second,a);
        if(first.x!=second.x || first.z!=second.z) throw std::logic_error("Invalid commute pruning");
    }
}
int main(int argc,char** argv){
    bool check=false,tail=false,canonical=false;
    for(int i=1;i<argc;++i){
        std::string option(argv[i]);
        if(option=="--check") check=true;
        else if(option=="--tail") tail=true;
        else if(option=="--canonical") canonical=true;
        else return 2;
    }
    const int allowed=tail?2:0;
    State initial;for(auto& x:initial.x)std::cin>>x;for(auto& z:initial.z)std::cin>>z;
    std::vector<Gate> seed;Gate g;
    while(std::cin>>g.a>>g.b>>g.p>>g.q){
        if(g.a<0||g.a>=n||g.b<0||g.b>=n||g.a==g.b||g.p<1||g.p>3||g.q<1||g.q>3) return 2;
        seed.push_back(g);
    }
    if(seed.size()<2 || seed.size()>44) return 2;
    if(tail && seed.size()<3) return 2;
    std::vector<Gate> all;
    for(int a=0;a<n;++a) for(int p=1;p<=3;++p)
        for(int b=a+1;b<n;++b) for(int q=1;q<=3;++q) all.push_back({a,b,p,q});
    std::map<std::array<int,4>,std::vector<Gate>> blocked;
    if(canonical) for(auto next:seed){
        auto key=std::array<int,4>{next.a,next.b,next.p,next.q};
        if(blocked.count(key)) continue;
        auto& options=blocked[key];
        for(auto insert:all){
            if(!obviously_commutes(insert,next)) options.push_back(insert);
            else if(check) check_swap(insert,next);
        }
    }
    uint64_t trials=0,direct=0,skipped=0;
    for(size_t first=0;first<seed.size();++first) for(size_t second=first+1;second<seed.size();++second)
    for(size_t third=tail?second+1:seed.size();third<(tail?seed.size():seed.size()+1);++third){
        std::vector<Gate> retained;
        for(size_t j=0;j<seed.size();++j)if(j!=first && j!=second && j!=third)retained.push_back(seed[j]);
        if(retained.size()+(tail?3:2)!=seed.size()) throw std::logic_error("Wrong gate count after deletion");
        State end=initial;std::vector<State> before{end};
        for(auto op:retained){apply(end,op);before.push_back(end);}
        std::vector<int> order;
        for(int i=0;i<n;++i) if(mixed(end,i))order.push_back(i);
        int n_mixed=int(order.size());
        for(int i=0;i<n;++i) if(!mixed(end,i))order.push_back(i);
        Images images{};
        for(int i=0;i<n;++i){
            images[i][1]={1u<<i,0};images[i][2]={0,1u<<i};images[i][3]={1u<<i,1u<<i};
        }
        for(int cut=int(retained.size());cut>=0;--cut){
            const State& prefix=before[cut];
            // Test the rightmost cut in each commuting run. A left cut with a
            // commuting next gate is represented by a later cut of this mask.
            auto options=&all;
            if(canonical && size_t(cut)<retained.size()){
                auto next=retained[cut];
                options=&blocked.at({next.a,next.b,next.p,next.q});
            }
            skipped+=all.size()-options->size();
            for(auto insert:*options){
                int a=insert.a,b=insert.b,p=insert.p,q=insert.q;
                ++trials;Bits au=anti(prefix,a,p),av=anti(prefix,b,q);
                bool passes=true;
                // A rank-two site's columns can become dependent only if
                // their span and span(au,av) share a nonzero vector.
                int permanent=0;
                for(int site=0;site<n_mixed;++site){
                    int i=order[site];
                    Bits x=end.x[i],z=end.z[i];
                    if(!in_plane(x,au,av) && !in_plane(z,au,av) && !in_plane(x^z,au,av)){
                        if(++permanent>allowed){passes=false;break;}
                    }
                    if(!tail) break;
                }
                if(check && (trials<=3 || trials%65537==0)){
                    State slow=prefix;
                    apply(slow,{a,b,p,q});
                    for(size_t j=cut;j<retained.size();++j) apply(slow,retained[j]);
                    auto u=images[a][p],v=images[b][q];
                    int slow_mixed=0;
                    for(int i=0;i<n;++i){
                        Bits x=end.x[i]^(((v.x>>i)&1)?au:0)^(((u.x>>i)&1)?av:0);
                        Bits z=end.z[i]^(((v.z>>i)&1)?au:0)^(((u.z>>i)&1)?av:0);
                        if(x!=slow.x[i] || z!=slow.z[i])
                            throw std::logic_error("Suffix transform disagrees with direct replay");
                        if(mixed(slow,i)) ++slow_mixed;
                    }
                    if((slow_mixed<=allowed)!=(passes && reachable_after(end,order,u,v,au,av,allowed)))
                        throw std::logic_error("Product predicate disagrees with direct replay");
                }
                if(!passes) continue;
                ++direct;
                if(reachable_after(end,order,images[a][p],images[b][q],au,av,allowed)){
                    std::cout<<"{";
                    if(canonical) std::cout<<"\"equivalent_skipped\":"<<skipped<<",";
                    std::cout<<"\"found\":true,\"trials\":"<<trials<<",\"direct\":"<<direct
                             <<",\"omit\":["<<first<<","<<second;
                    if(tail) std::cout<<","<<third;
                    std::cout<<"],\"insert_at\":"<<cut
                             <<",\"gate\":["<<a<<","<<b<<","<<p<<","<<q<<"]}\n";
                    return 0;
                }
            }
            if(cut)extend(images,retained[cut-1]);
        }
    }
    std::cout<<"{";
    if(canonical) std::cout<<"\"equivalent_skipped\":"<<skipped<<",";
    std::cout<<"\"found\":false,\"trials\":"<<trials<<",\"direct\":"<<direct<<"}\n";
}
