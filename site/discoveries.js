const results = [...document.querySelectorAll('[data-result]')];
const selector = document.getElementById('selector');
const certificates = new Map();
let logicalQubits = '4';
async function showCode(k) {
  logicalQubits = k;
  const url = 'certificates/wei-12-' + k + '-4.json';
  const grid = document.getElementById('code-grid');
  document.getElementById('certificate').href = url;
  document.querySelectorAll('[data-k]').forEach(button => button.setAttribute('aria-pressed', String(button.dataset.k === k)));
  grid.replaceChildren();
  document.getElementById('optimum').textContent = k === '4' ? '7 qubits' : '6 qubits';
  try {
    if (!certificates.has(k)) {
      const response = await fetch(url);
      if (!response.ok) throw Error();
      certificates.set(k, await response.json());
    }
    if (logicalQubits !== k) return;
    const certificate = certificates.get(k);
    for (const generator of certificate.witness.generators) {
      const row = document.createElement('div');
      row.className = 'pauli';
      row.setAttribute('role', 'img');
      row.setAttribute('aria-label', 'Check ' + generator);
      for (const letter of generator) {
        const dot = document.createElement('span');
        dot.textContent = letter === 'I' ? '·' : letter;
        if (letter === 'I') dot.className = 'identity';
        row.append(dot);
      }
      grid.append(row);
    }
  } catch {
    if (logicalQubits === k) grid.textContent = 'The generator diagram is unavailable. The certificate is linked below.';
  }
}
document.querySelectorAll('[data-k]').forEach(button => {
  button.onclick = () => { showCode(button.dataset.k); };
});
function selectResult() {
  const hash = location.hash.slice(1);
  const active = results.find(section => section.dataset.result === hash);
  // Keep previously shared paper, verification and filtered catalogue links.
  if ((hash && !active) || (!hash && location.search && ['q','area','method'].some(key => new URLSearchParams(location.search).has(key)))) {
    location.replace('catalogue.html' + location.search + location.hash);
    return;
  }
  const selected = active || results[0];
  results.forEach(section => { section.hidden = section !== selected; });
  for (const link of selector.querySelectorAll('a')) {
    if (link.hash === '#' + selected.dataset.result) link.setAttribute('aria-current','true');
    else link.removeAttribute('aria-current');
  }
  if (selected.dataset.result === 'code') showCode(logicalQubits);
}
document.addEventListener('keydown', e => {
  if (e.defaultPrevented || document.querySelector("dialog[open]") || e.altKey || e.metaKey || e.ctrlKey || !['ArrowLeft','ArrowRight'].includes(e.key)) return;
  const current = results.findIndex(section => !section.hidden);
  const step = e.key === 'ArrowRight' ? 1 : -1;
  e.preventDefault();
  location.hash = results[(current + step + results.length) % results.length].dataset.result;
});
window.addEventListener('hashchange', selectResult);
selectResult();
