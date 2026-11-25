"""Numerical triage for Gagatsos Conjecture 1 in a squeezed two-coherent-state family."""
from math import cos, cosh, exp, pi, sqrt

import numpy as np
from scipy.stats import qmc

from verify import require


def coordinates(center, radius, count):
    step = 2*radius/count
    return center-radius+(np.arange(count)+0.5)*step, step


def evaluate(b, u, phase, squeeze, count):
    # Squeeze both coherent components, with the vacuum x width scaled by w.
    # Wigner L1 is squeeze invariant, so integrate that side before squeezing.
    w = exp(squeeze)
    sep = sqrt(2)*b
    norm = 1+u*u+2*u*exp(-b*b/2)*cos(phase)
    x, dx = coordinates(sep/2, sep/2+9, count)
    p, dp = coordinates(0, 9, count)
    x = x[:, None]
    interference = 2*u*np.exp(-(x-sep/2)**2)*np.cos(sep*p-phase)
    wigner = np.exp(-p*p)*(np.exp(-x*x)+u*u*np.exp(-(x-sep)**2)+interference)/(pi*norm)
    left = float(np.abs(wigner).sum()*dx*dp)
    wigner_mass = float(wigner.sum()*dx*dp)

    width = 1+w*w
    shift = w*sep
    x, dx = coordinates(shift/2, shift/2+10*sqrt(width), count)
    p, dp = coordinates(0, 10*sqrt(width)/w, count)
    x = x[:, None]
    # Absolute coherent overlap follows by integrating the displaced Gaussian
    # wavefunctions. A common unit-modulus phase cancels in the Husimi density.
    common = sqrt(2*w/(width*norm*2*pi))*np.exp(-p*p*w*w/(2*width))
    amplitude = common*(np.exp(-x*x/(2*width)) +
                        u*np.exp(-(x-shift)**2/(2*width))*np.exp(1j*(phase-p*shift/width)))
    root_q = np.abs(amplitude)
    right = float((root_q.sum()*dx*dp)**2/(8*pi))
    q_mass = float((root_q**2).sum()*dx*dp)
    require(max(abs(q_mass-1),abs(wigner_mass-1))<1e-6, "quadrature missed state normalization")
    return dict(grid=count, wigner_l1=left, husimi_bound=right, residual=left-right)


def controls():
    for s in (0, 0.7):
        r = evaluate(1,0,0,s,96)
        require(abs(r["wigner_l1"]-1)<1e-10 and abs(r["husimi_bound"]-cosh(s))<1e-10,
                "coherent/squeezed vacuum normalization failed")
    near_one = evaluate(0.01,1,pi,0,384)
    require(abs(near_one["wigner_l1"]-(4*exp(-0.5)-1))<0.002, "odd cat Fock limit failed")


def search(round_no):
    controls()
    # A disjoint contiguous block of a deterministic low-discrepancy design.
    sampler = qmc.Sobol(4,scramble=False)
    sampler.fast_forward(1+32*(round_no-1))
    batch = []
    for a,c,f,s in sampler.random(32):
        params = dict(b=0.15+3.85*a,u=exp(-2.5*c),phase=pi*f,squeeze=2*s-1)
        batch.append((evaluate(**params,count=120)["residual"],params))
    shortlist = sorted(batch,key=lambda item:item[0],reverse=True)[:3]
    cases = [{"state":p,"checks":[evaluate(**p,count=m) for m in (240,480)]} for _,p in shortlist]
    return dict(target="gagatsos-2026-c1",role="numerical_triage",states=len(batch),
                sobol_start=1+32*(round_no-1),finalists=cases,
                status="needs_interval_check" if any(c["checks"][-1]["residual"]>0 for c in cases)
                else "no_positive_refined_residual",
                scope="Top three coarse candidates refined. Both grids use midpoint quadrature; tail and integration errors are uncertified.")
