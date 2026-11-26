---
title: Five better spherical packings
affiliation: Student, Department of Physical Sciences, The Open University
packing-figure: true
abstract: |
  How widely can you separate the closest two points on a sphere? At five sizes, the deposited configurations have greater minimum separation than the corresponding entries in Henry Cohn’s table on November 25, 2026. Four of them fit on an ordinary sphere.
---

# The closest pair

```{=html}
<figure class="packing-figure">
  <canvas id="sphere" data-coordinates="coordinates.json" tabindex="0" aria-label="Rotatable sphere with 418 equal caps. The closest pair is highlighted." aria-describedby="instructions"></canvas>
  <figcaption>
    <span class="packing-context">Three dimensions · 418 points</span>
    <div class="packing-measure"><span>Minimum angular separation</span><output id="angle">10.3789768°</output></div>
    <span id="pair">Centers 12 and 26</span>
    <div class="packing-controls" role="group" aria-label="Choose a configuration">
      <button type="button" id="prior" aria-pressed="false">Previous</button>
      <button type="button" id="ours" aria-pressed="true">Ours</button>
    </div>
    <button type="button" id="center">Center closest pair</button>
  </figcaption>
</figure>
```

<p id="instructions"><span class="packing-gesture">Drag or use the arrow keys to rotate the sphere. </span>Each cap’s angular radius is half the closest-pair separation.</p>

# All five comparisons

Smaller maximum cosine means greater separation. The new bounds below are strict. Each comparison links to the prior table entry and the new coordinates.

```{=html}
<table><thead><tr><th>Dimension</th><th>Points</th><th>Prior maximum cosine</th><th>New upper bound</th><th>Least angle</th></tr></thead><tbody><tr><td>3</td><td><a href="https://github.com/shunyaekam/oo-research/blob/research/checks/packing_bounds/3-327/points.csv">327</a></td><td><a href="https://spherical-codes.org/code/3/327">0.979170695575</a></td><td>0.979170312</td><td>11.7148240°</td></tr>
<tr><td>3</td><td><a href="https://github.com/shunyaekam/oo-research/blob/research/checks/packing_bounds/3-418/points.csv">418</a></td><td><a href="https://spherical-codes.org/code/3/418">0.983664967676</a></td><td>0.983637642</td><td>10.3789768°</td></tr>
<tr><td>3</td><td><a href="https://github.com/shunyaekam/oo-research/blob/research/checks/packing_bounds/3-577/points.csv">577</a></td><td><a href="https://spherical-codes.org/code/3/577">0.988154316960</a></td><td>0.988152320</td><td>8.8284410°</td></tr>
<tr><td>3</td><td><a href="https://github.com/shunyaekam/oo-research/blob/research/checks/packing_bounds/3-636/points.csv">636</a></td><td><a href="https://spherical-codes.org/code/3/636">0.989239710497</a></td><td>0.989234488</td><td>8.4148307°</td></tr>
<tr><td>7</td><td><a href="https://github.com/shunyaekam/oo-research/blob/research/checks/packing_bounds/7-151/points.csv">151</a></td><td><a href="https://spherical-codes.org/code/7/151">0.545859542775</a></td><td>0.545833304</td><td>56.9183729°</td></tr></tbody></table>
```

# Verification

The coordinates are finite decimals. Clearing their denominators gives integer directions. For each pair the checker compares its squared dot product with the product of its squared lengths times the proposed bound squared, accounting for the sign of the dot product. It tested all 519,885 candidate pairs, then repeated the calculation on the deposited prior coordinates. A second program replayed the comparisons at 50-digit precision.

These bounds certify arrangements that fit. Proving a best possible arrangement would also require ruling out every better one. Vadim Borisov supplied the prior configurations and the neighboring configurations used to start the searches.

# AI contribution

GPT-6.2 Astra (high) drafted the scope note for this edition and ran the integer checker against the five deposited configurations. The displayed angles are rounded. The exact comparison uses the archived coordinates and strict rational cosine thresholds, so rounding the angles cannot change which configuration wins at a given size.

# Data and sources

<a href="https://github.com/shunyaekam/oo-research/blob/research/checks/packing_bounds/README.md">Research note</a> · <a href="https://github.com/shunyaekam/oo-research/blob/research/checks/packing_bounds/check.py">Checker</a> · <a href="https://github.com/shunyaekam/oo-research/blob/research/checks/packing_bounds/receipt.json">Receipt</a> · <a href="https://spherical-codes.org/">Cohn’s table</a> · <a href="https://github.com/shunyaekam/oo-research/blob/research/checks/packing_bounds/comparisons.json">Data &amp; credits</a>
