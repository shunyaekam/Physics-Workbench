"""Screen the Wigner–Husimi inequality on cubic-phase Gaussian wave packets.

Run from any directory. All integrations are numerical diagnostics.
Definitions and normalization appear in the companion local-stability note.
"""
from math import pi, sqrt

import numpy as np
from scipy.integrate import quad
from scipy.special import ai_zeros, airy, roots_hermitenorm


def fourier_norm(envelope, phase):
    # With F(t) = integral f(v) exp(-itv) dv/(2 pi), dt = 2 pi/(M dv).
    return np.abs(np.fft.fft(envelope * np.exp(1j * phase))).mean()


def screen(points, half_width, gaussian_nodes):
    v = np.linspace(-half_width, half_width, points, endpoint=False)
    node, weight = roots_hermitenorm(gaussian_nodes)
    weight /= sqrt(2*pi)
    out = {}
    for kappa in (0, 0.05, 0.1, 0.25, 0.5, 1, 2):
        wigner = fourier_norm(np.exp(-v*v/4), kappa*v**3/4)
        for width in (0.4, 0.6, 0.8, 1, 1.25, 1.6, 2.5):
            h = 1/sqrt(1+width**2)
            cubic = kappa * (h*v)**3
            # The Fourier norm is unchanged by reflecting the sign of the
            # quadratic chirp (complex conjugation followed by v -> -v).
            norms = [fourier_norm(np.exp(-v*v/2),
                                  cubic + 3*kappa*width*h*b*(h*v)**2)
                     for b in node[node > 0]]
            mean_norm = 2 * (weight[node > 0] @ norms)
            husimi = (width + 1/width)*mean_norm**2/2
            if kappa == 0 and max(abs(wigner-1),
                                   abs(husimi-(width+1/width)/2)) > 1e-10:
                raise ArithmeticError('Vacuum / squeezed-vacuum control failed')
            out[kappa, width] = (wigner, husimi)
    return out


def airy_wigner_norm(kappa):
    # Complete the cube in the Wigner Fourier integral. After shifting its
    # argument to y, the signed density is exp(b*y-b**3/3)*Ai(y).
    b = 1/(4*(3*kappa/4)**(2/3))
    zeros = ai_zeros(512)[0]
    negative = sum(quad(lambda y: -np.exp(b*y-b**3/3)*airy(y)[0], lo, hi)[0]
                   for hi, lo in zip(zeros[::2], zeros[1::2]))
    return 1+2*negative


def direct_husimi(kappa, width):
    # Independent use of the position-space wavefunction in the original
    # overlap. No change of variables inside the Gaussian window.
    x = np.linspace(-32, 32, 8192, endpoint=False)
    q = np.linspace(-20, 20, 501)
    psi = (pi**(-0.25)/sqrt(width) *
           np.exp(-(x/width)**2/2 + 1j*kappa*(x/width)**3))
    marginal = [np.abs(np.fft.fft(pi**(-0.25)*np.exp(-(x-center)**2/2)*psi)).mean()
                for center in q]
    return (np.trapz(marginal, q)/2)**2


if __name__ == '__main__':
    coarse = screen(4096, 16, 48)
    fine = screen(8192, 20, 96)
    print('kappa  width at largest ratio  Wigner norm  Husimi bound  ratio')
    for k in sorted({k for k, s in fine}):
        width = max((s for k0, s in fine if k0 == k),
                    key=lambda s: fine[k, s][0] / fine[k, s][1])
        w, h = fine[k, width]
        print(f'{k:5g}  {width:22g}  {w:11.8f}  {h:12.8f}  {w/h:.8f}')
    difference = max(abs(w/h - coarse[key][0]/coarse[key][1])
                     for key, (w, h) in fine.items())
    print(f'Maximum absolute change in ratio across both grids: {difference:.6g}')

    w, h = fine[0.25, 1.25]
    w_direct, h_direct = airy_wigner_norm(0.25), direct_husimi(0.25, 1.25)
    print(f'Independent check at (0.25, 1.25): W={w_direct:.8f}, H={h_direct:.8f}')
    if max(abs(w-w_direct), abs(h-h_direct)) > 0.002:
        raise ArithmeticError('Independent non-Gaussian check failed')
