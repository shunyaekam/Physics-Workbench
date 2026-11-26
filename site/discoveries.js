const results = [...document.querySelectorAll('[data-result]')];
const selector = document.getElementById('selector');
const menu = document.getElementById('menu');
const sound = document.getElementById('sound');
let soundEnabled = false;
try { soundEnabled = localStorage.getItem('oo-sound') === 'on'; } catch {}
let audio;
function tone(frequency) {
  if (!soundEnabled) return;
  try {
    audio ||= new AudioContext();
    audio.resume().catch(() => {});
    const oscillator = audio.createOscillator();
    const volume = audio.createGain();
    oscillator.frequency.value = frequency;
    volume.gain.setValueAtTime(0.025, audio.currentTime);
    volume.gain.exponentialRampToValueAtTime(0.001, audio.currentTime + 0.055);
    oscillator.connect(volume).connect(audio.destination);
    oscillator.start();
    oscillator.stop(audio.currentTime + 0.06);
  } catch {}
}
function soundLabel() {
  sound.textContent = soundEnabled ? 'Sound on' : 'Sound off';
  sound.setAttribute('aria-pressed', String(soundEnabled));
}
soundLabel();
sound.onclick = () => {
  soundEnabled = !soundEnabled;
  try { localStorage.setItem('oo-sound', soundEnabled ? 'on' : 'off'); } catch {}
  soundLabel();
  tone(560);
};
const openMenu = document.getElementById('menu-open');
openMenu.onclick = () => { menu.showModal(); tone(430); };
document.getElementById('menu-close').onclick = () => menu.close();
menu.addEventListener('click', e => { if (e.target === menu || e.target.className === 'menu-body') menu.close(); });
menu.addEventListener('close', () => { tone(285); openMenu.focus(); });
menu.querySelector('nav').addEventListener('pointerover', e => { if (e.target.closest('a')) tone(330); });
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
  button.onclick = () => { tone(400); showCode(button.dataset.k); };
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
selector.addEventListener('click', () => tone(460));
document.addEventListener('keydown', e => {
  if (e.defaultPrevented || menu.open || e.altKey || e.metaKey || e.ctrlKey || !['ArrowLeft','ArrowRight'].includes(e.key)) return;
  const current = results.findIndex(section => !section.hidden);
  const step = e.key === 'ArrowRight' ? 1 : -1;
  e.preventDefault();
  location.hash = results[(current + step + results.length) % results.length].dataset.result;
  tone(460);
});
window.addEventListener('hashchange', selectResult);
selectResult();
