"""Exact transfer certificate for OEIS A358696. Python 3, standard library."""
from collections import Counter
from itertools import product

width = 5
blank = (0,) * width
coefficients = (6, 1, -20, 37, 16, -12, -7, 5, -1)

def transitions(current, first=False, last=False):
    result = Counter()
    for vertical in range(1 << (width-1)):
        outgoing = []
        neighbors = {i:set() for i in range(width)}
        for i in range(width-1):
            if vertical >> i & 1:
                neighbors[i].add(i+1)
                neighbors[i+1].add(i)
        for i,label in enumerate(current):
            if label:
                j = current.index(label)
                if i != j:
                    neighbors[i].add(j)
                    neighbors[j].add(i)
        for i in range(width):
            vert = ((vertical << 1) >> i & 1) + (vertical >> i & 1)
            partial = vert + bool(current[i])
            required = first or last or i in (0,width-1)
            if partial > 2 or (required and partial == 0) or (last and partial == 1):
                break
            outgoing.append(int(partial == 1))
        else:
            active = {i for i in range(width) if current[i] or neighbors[i] or outgoing[i]}
            comps = []
            while active:
                stack = [min(active)]
                comp = set()
                while stack:
                    u = stack.pop()
                    if u in comp: continue
                    comp.add(u)
                    stack.extend(neighbors[u]-comp)
                active -= comp
                comps.append(comp)
            if last:
                if len(comps)==1: result[blank] += 1
                continue
            state = [0] * width
            for j,comp in enumerate(comps,1):
                tips = sorted(i for i in comp if outgoing[i])
                if len(tips) != 2: break
                for i in tips: state[i] = min(tips) + 1
            else:
                result[tuple(state)] += 1
    return result

def advance(vector):
    answer=Counter()
    for s,weight in vector.items():
        for t,mult in transitions(s).items():
            answer[t] += weight * mult
    return answer

def main():
    initial = transitions(blank,first=True)
    vectors=[initial]
    for _ in range(10):
        vectors.append(advance(vectors[-1]))
    values=[sum(w*transitions(s,last=True)[blank] for s,w in d.items()) for d in vectors]
    states=set().union(*vectors)
    relation=[vectors[9][s]-sum(c*v[s] for c,v in zip(coefficients,reversed(vectors[:9]))) for s in sorted(states)]
    print(len(states),'reachable states; a(2)..a(12)',values)
    print('v9-6v8-...+v0:',relation)
    assert not any(relation)
    assert values[:9]==[1,5,36,191,1123,6410,37165,214515,1240200]

if __name__=='__main__': main()
