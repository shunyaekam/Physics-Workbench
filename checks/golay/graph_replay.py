"""Turn a graph path into a signed forward circuit consisting only of CNOTs and local gates."""
import stim
from graph_inputs import decompose, target_sim


def axis_to_z(axis,wire):
    # Basis change mapping the positive Pauli axis to Z.
    c=stim.Circuit()
    if axis=="Y": c.append("S_DAG",[wire])
    if axis!="Z": c.append("H",[wire])
    return c


def controlled_pauli(c,a,b,p,q):
    change=axis_to_z(p,a)+axis_to_z(q,b)
    c+=change
    c.append("H",[b]);c.append("CX",[a,b]);c.append("H",[b])
    c+=change.inverse()


def construct(prefix,result):
    adj,local=decompose(prefix)
    undo=stim.Circuit()
    for a,b,p,q in prefix:
        controlled_pauli(undo,a,b,p,q)
    undo+=local.inverse()
    cost=len(prefix)
    for kind,a,b in result["moves"]:
        near=lambda i: [j for j in range(23) if adj[i]>>j&1]
        if kind=="L":
            neighbors=near(a)
            undo.append("SQRT_X",[a])
            if neighbors: undo.append("S_DAG",neighbors)
            for j in neighbors: adj[j]^=adj[a]^(1<<j)
        elif kind=="C":
            undo.append("CX",[a,b])
            if adj[a]>>b&1: undo.append("Z",[a])
            for j in near(b):
                if j!=a:
                    adj[j]^=1<<a;adj[a]^=1<<j
            cost+=1
        elif kind=="Z":
            controlled_pauli(undo,a,b,"Z","Z")
            adj[a]^=1<<b;adj[b]^=1<<a;cost+=1
        else: raise ValueError("Unknown graph move")
    if any(adj) or cost!=result["cost"]: raise ArithmeticError("Graph or gate-count mismatch")
    return signed_forward(undo,cost)


def signed_forward(undo,cost):
    sim=target_sim();sim.do(undo)
    prepare=stim.Circuit()
    for i in range(23):
        bloch=sim.peek_bloch(i)
        if bloch.weight!=1: raise ArithmeticError("Residual entanglement in Stim")
        if bloch.sign.real<0: prepare.append("X",[i])
        axis=bloch[0]
        if axis!=3: prepare.append("H",[i])
        if axis==2: prepare.append("S",[i])
    forward=prepare+undo.inverse()
    actual=sum(len(op.targets_copy())//2 for op in forward if op.name=="CX")
    fresh=stim.TableauSimulator();fresh.do(forward)
    if actual!=cost or fresh.canonical_stabilizers()!=target_sim().canonical_stabilizers():
        raise ArithmeticError("Signed forward verification failed")
    return forward


def inverse_axes(forward):
    """Commute local basis changes to the end of the inverse preparation."""
    # Stim's single-wire inverse tableau transports the physical gate axes into
    # the accumulated local frame. Pauli signs only change free local corrections.
    frames=[stim.Tableau(1) for _ in range(23)]
    result=[]
    for op in forward.inverse():
        wires=[t.value for t in op.targets_copy()]
        if op.name=="CX":
            for a,b in zip(wires[::2],wires[1::2]):
                P="IXYZ"[frames[a].z_output(0)[0]]
                Q="IXYZ"[frames[b].x_output(0)[0]]
                result.append((a,b,P,Q))
        else:
            inv=stim.gate_data(op.name).tableau.inverse()
            for i in wires: frames[i]=inv.then(frames[i])
    return result
