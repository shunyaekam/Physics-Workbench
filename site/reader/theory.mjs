const NS = "http://www.w3.org/2000/svg";
const blue = "#597a94",
  dark = "#303d47",
  pale = "#d8e2e9";
function svg(figure) {
  const s = document.createElementNS(NS, "svg");
  s.setAttribute("viewBox", "0 0 450 250");
  s.setAttribute("role", "img");
  s.style.width = "100%";
  s.style.maxWidth = "450px";
  s.style.display = "block";
  figure.replaceChildren(s);
  return s;
}
function shape(s, tag, attrs, text) {
  const e = document.createElementNS(NS, tag);
  for (const [k, v] of Object.entries(attrs)) e.setAttribute(k, v);
  if (text !== undefined) e.textContent = text;
  s.append(e);
  return e;
}
function label(s, x, y, text, size = 13, anchor = "start") {
  shape(
    s,
    "text",
    {
      x,
      y,
      fill: dark,
      "font-size": size,
      "font-family": "Play, sans-serif",
      "text-anchor": anchor,
    },
    text,
  );
}
function selector(controls, labelText, options, change) {
  const l = document.createElement("label");
  l.textContent = labelText + " ";
  const sel = document.createElement("select");
  for (const [v, t] of options) {
    const o = document.createElement("option");
    o.value = v;
    o.textContent = t;
    sel.append(o);
  }
  l.append(sel);
  controls.replaceChildren(l);
  sel.addEventListener("change", () => change(sel.value));
  return sel;
}
function range(controls, labelText, min, max, value, change, step = 1) {
  const l = document.createElement("label");
  const out = document.createElement("output");
  const input = document.createElement("input");
  input.type = "range";
  input.min = min;
  input.max = max;
  input.step = step;
  input.value = value;
  l.append(labelText + " ", input, " ", out);
  controls.replaceChildren(l);
  input.addEventListener("input", () => {
    out.textContent = input.value;
    change(+input.value);
  });
  out.textContent = value;
  return input;
}
function announce(c, text) {
  c.textContent = text;
  c.setAttribute("aria-live", "polite");
}

export const exhibits = {
  "bmv-trace-12-3": {
    title: "What changes when you reorder a product?",
    lead: "With matrices, AABB and ABAB can give different traces. Two distinct eigenvalues for A are enough to bound the average over all word orders between two known values.",
    scope:
      "Try two copies each of A and B. The paper proves the bounds for any positive counts and finite matrix size when A has at most two eigenvalues.",
    mount(figure, controls, caption) {
      // A = diag(1,b), B = [[1,1/2],[1/2,1]]. Cyclic permutations have equal trace.
      function draw(b) {
        const alternating = 1 + b * b + 0.5 * b,
          adjacent = 1.25 * (1 + b * b);
        const values = [
          alternating,
          (2 * alternating + 4 * adjacent) / 6,
          adjacent,
        ];
        const s = svg(figure),
          names = ["ABAB", "All six orders", "AABB"];
        s.setAttribute("aria-label", "Two traces and their weighted mean");
        label(s, 12, 32, "A = diag(1, b)     B = [[1, ½], [½, 1]]", 15);
        values.forEach((value, i) => {
          const y = 71 + i * 57,
            width = (245 * value) / 6.25;
          label(s, 12, y + 12, names[i], 14);
          shape(s, "rect", {
            x: 130,
            y,
            width,
            height: 16,
            fill: i === 1 ? dark : blue,
          });
          label(s, 139 + width, y + 13, value.toFixed(3), 13);
        });
        announce(
          caption,
          b === 1
            ? "At equal eigenvalues, all six orders give the same trace."
            : "Four orders share the AABB trace; two share the ABAB trace. Their average is marked in charcoal.",
        );
      }
      range(controls, "Second eigenvalue of A", 0, 2, 0.3, draw, 0.1);
      draw(0.3);
    },
  },
  "coordinate-supports": {
    title: "Three words can reveal a negative direction",
    lead: "Read the three words column by column. Count the columns with three different symbols. If that count is odd, the corresponding part of the Werner matrix has a negative direction.",
    scope:
      "Positivity of a whole support requires an even count for every triple; the negative direction here has Schmidt rank three.",
    mount(figure, controls, caption) {
      const draw = (v) => {
        const words = v === "one" ? ["00", "10", "20"] : ["00", "11", "22"],
          count = v === "one" ? 1 : 2,
          s = svg(figure);
        s.setAttribute(
          "aria-label",
          `Three words with ${count} all-distinct coordinates`,
        );
        label(s, 15, 25, "Three basis words", 14);
        words.forEach((w, i) => {
          label(s, 20, 70 + i * 53, `Word ${i + 1}`, 13);
          [...w].forEach((digit, j) => {
            shape(s, "circle", {
              cx: 180 + j * 110,
              cy: 65 + i * 53,
              r: 20,
              fill: "white",
              stroke: blue,
              "stroke-width": 2,
            });
            label(s, 180 + j * 110, 70 + i * 53, digit, 16, "middle");
          });
        });
        label(s, 180, 238, "Position 1", 12, "middle");
        label(s, 290, 238, "Position 2", 12, "middle");
        announce(
          caption,
          `${count} position${count === 1 ? "" : "s"} contain three distinct symbols: ${count % 2 ? "odd, so this triple gives a negative direction" : "even, so this triple passes the parity test"}.`,
        );
      };
      selector(
        controls,
        "Example",
        [
          ["one", "One distinct position"],
          ["two", "Two distinct positions"],
        ],
        draw,
      );
      draw("one");
    },
  },
  "finite-maxima": {
    title: "Eight words, or twice the alphabet?",
    lead: "Build words of length three while keeping the restricted Werner matrix positive. Two constructions compete: one always fits eight words, and the other fits two for each symbol in the alphabet.",
    scope:
      "For three copies and every local dimension at least two, the paper proves the maximum is max(8, 2d); distillability remains open.",
    mount(figure, controls, caption) {
      const draw = (d) => {
        const s = svg(figure);
        s.setAttribute(
          "aria-label",
          `Binary box has 8 words; repeated-symbol construction has ${2 * d} words`,
        );
        const rows = [
          ["Binary box", 8],
          ["Repeated symbol", 2 * d],
        ];
        rows.forEach(([name, n], i) => {
          const y = 45 + i * 95;
          label(s, 0, y, name, 14);
          for (let j = 0; j < n; j++)
            shape(s, "rect", {
              x: 145 + (j % 8) * 30,
              y: y - 15 + Math.floor(j / 8) * 30,
              width: 19,
              height: 19,
              fill: i === 0 ? blue : dark,
            });
          label(s, 145, y + 55, `${n} basis words`, 12);
        });
        announce(
          caption,
          `At dimension ${d}, the constructions give 8 and ${2 * d} words. The proven maximum is ${Math.max(8, 2 * d)}.`,
        );
      };
      range(controls, "Local dimension", 2, 8, 5, draw);
      draw(5);
    },
  },
  "schmidt-rank-seven": {
    title: "When sorting seven weights is enough",
    lead: "Keep the seven shared weights of an entangled state fixed and change the local bases. On two three-qubit registers, sorting the amplitudes into matching binary labels gives the smallest nonlocal stabilizer entropy.",
    scope:
      "The exhibit evaluates the paper’s exact purity formula for two spectra; unrestricted higher-rank optimality remains open.",
    mount(figure, controls, caption) {
      const draw = (v) => {
        const raw =
            v === "flat" ? [1, 1, 1, 1, 1, 1, 1] : [7, 6, 5, 4, 3, 2, 1],
          sum = raw.reduce((a, b) => a + b * b, 0),
          t = raw.map((x) => (x * x) / sum);
        let plane = 0;
        for (let a = 0; a < 7; a++)
          for (let b = a + 1; b < 7; b++)
            for (let c = b + 1; c < 7; c++)
              for (let d = c + 1; d < 7; d++)
                if ((a ^ b ^ c ^ d) === 0) plane += t[a] * t[b] * t[c] * t[d];
        const purity =
            7 * t.reduce((a, x) => a + x * x, 0) ** 2 -
            6 * t.reduce((a, x) => a + x ** 4, 0) +
            168 * plane,
          s = svg(figure);
        s.setAttribute("aria-label", "Seven sorted Schmidt probabilities");
        const max = Math.max(...t);
        t.forEach((x, i) => {
          const h = (150 * x) / max;
          shape(s, "rect", {
            x: 35 + i * 57,
            y: 195 - h,
            width: 34,
            height: h,
            fill: i === 0 ? dark : blue,
          });
          label(s, 52 + i * 57, 216, String(i + 1), 12, "middle");
        });
        label(s, 225, 240, "Sorted Schmidt weight", 12, "middle");
        announce(
          caption,
          `The ${v === "flat" ? "flat" : "unequal"} spectrum has optimal purity ${purity.toFixed(4)} in this three-qubit setting.`,
        );
      };
      selector(
        controls,
        "Spectrum",
        [
          ["flat", "Equal amplitudes"],
          ["unequal", "Amplitudes 7 to 1"],
        ],
        draw,
      );
      draw("flat");
    },
  },
};
