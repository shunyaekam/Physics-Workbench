"""Exact recurrence certificates for corner-to-corner lattice paths, OEIS A216211 and A333686."""
from collections import Counter
from functools import lru_cache

@lru_cache(None)
def step(state, marked=-1):
    """Process one column. -1 denotes the component connected to the start."""
    width = len(state)
    result = Counter()
    for vertical in range(1 << (width-1)):
        graph = [set() for _ in state]
        degree = [int(label != 0) for label in state]
        for i, label in enumerate(state):
            if label > 0:
                j = state.index(label)
                if i != j:
                    graph[i].add(j)
                    graph[j].add(i)
        for i in range(width-1):
            if vertical & (1 << i):
                graph[i].add(i+1)
                graph[i+1].add(i)
                degree[i] += 1
                degree[i+1] += 1
        if max(degree)>2 or (marked >= 0 and degree[marked] == 0):
            continue
        # Degree one forces a new outgoing edge. Degree zero means an unused site.
        active = {i for i in range(width) if degree[i]}
        following = [0]*width
        while active:
            stack = [min(active)]
            component = set()
            while stack:
                i = stack.pop()
                if i in component:
                    continue
                component.add(i)
                stack.extend(graph[i] - component)
            active -= component
            tips = [i for i in component if degree[i] == 1]
            anchored = any(state[i] == -1 for i in component)
            if len(tips) != (1 if anchored else 2):
                break
            for i in tips:
                following[i] = -1 if anchored else min(tips)+1
        else:
            result[tuple(following)] += 1
    return result

def start(width, row):
    return tuple(-1 if i == row else 0 for i in range(width))

def frontier(width):
    states = [start(width,0)]
    for s in states:
        for t in step(s):
            if t not in states:
                states.append(t)
    return states

def apply(vector, marked=-1):
    out = Counter()
    for s, weight in vector.items():
        for t,mult in step(s, marked).items():
            out[t] += mult*weight
    return out

def product(a,b):
    out = [0]*(len(a)+len(b)-1)
    for i,x in enumerate(a):
        for j,y in enumerate(b):
            out[i+j] += x*y
    return out

def check_generating_function(sequence, lag, numerator, factors):
    denominator = [1]
    for factor in factors:
        denominator = product(denominator, factor)
    assert denominator == [1]+[-c for c in lag]
    prefix = product(sequence, denominator)[:len(sequence)]
    assert prefix == numerator+[0]*(len(prefix)-len(numerator))

def enumerate_paths(width, columns, target, marked=None):
    # Independent small-grid check, traversing vertices directly from the source.
    goal = ((columns-1)*width)+target
    neighbors = [[] for _ in range(width*columns)]
    for v in range(width*columns):
        x,y = divmod(v,width)
        for i,j in ((x-1,y),(x+1,y),(x,y-1),(x,y+1)):
            if 0 <= i < columns and 0 <= j < width:
                neighbors[v].append(i*width+j)
    def visit(v,used):
        if v == goal:
            return int(marked is None or used & (1 << marked) != 0)
        return sum(visit(u,used | (1 << u)) for u in neighbors[v] if not used & (1 << u))
    return visit(0,1)

def certificates():
    four = frontier(4)
    v = Counter({start(4,0):1})
    a = []
    lag4 = [12,-54,124,-133,-16,175,-94,-69,40,12,-4,-1]
    for n in range(1,13+len(four)):
        v = apply(v)
        a.append(v[start(4,0)])
    assert a[:12]==[1,4,28,178,1008,5493,29879,163357,895519,4911542,26932856,147666219]
    for j in range(12, len(a)):
        assert a[j] == sum(c*a[j-k] for k,c in enumerate(lag4,1))
    three = frontier(3)
    lag3 = [10,10,0,-10,-10,1]
    # For n>=0 the transfer is T^n M T^n. M forces the marked central site.
    # Advancing n acts linearly on endomorphisms by B -> T B T.
    b = []
    left = Counter({start(3,0):1})
    right = {s:int(s==start(3,2)) for s in three}
    for n in range(6+len(three)**2):
        middle = apply(left,1)
        b.append(sum(weight*right[s] for s,weight in middle.items()))
        left = apply(left)
        right = {s:sum(mult*right[t] for t,mult in step(s).items()) for s in three}
    assert b[:6]==[1,10,101,1105,12046,131399]
    for j in range(6,len(b)):
        assert b[j]==sum(c*b[j-k] for k,c in enumerate(lag3,1))
    check_generating_function([0]+a, lag4, [0,1,-8,34,-66,21,85,-64,-45,26,11,-3,-1],
                              [[1,-8,15,-5,-9,2,1],[1,-4,7,-3,-7,2,1]])
    check_generating_function(b, lag3, product([1,-3,-1],[1,3,1,1]),
                              [[1,-1],[1,1],[1,1,1],[1,-11,1]])
    for n in range(1,6):
        assert a[n-1] == enumerate_paths(4,n,0)
    for n in range(4):
        assert b[n] == enumerate_paths(3,2*n+1,2,marked=3*n+1)
    return len(four),len(three),a,b

if __name__ == '__main__':
    w4,w3,a,b = certificates()
    print('A216211:',w4,'states;',len(a)-12,'exact zero recurrence residuals.')
    print('A333686:',w3,'states;',len(b)-6,'exact zero recurrence residuals.')
