// Flowly plays a distinct cue for approaching, selecting and leaving a control.
(() => {
  const directory = new URL('assets/sounds/', document.currentScript.src);
  const players = new Map();
  let enabled = true;
  try { enabled = localStorage.getItem('oo-sound') !== 'off'; } catch {}
  function play(cue) {
    if (!enabled || (navigator.userActivation && !navigator.userActivation.hasBeenActive)) return;
    let audio = players.get(cue);
    if (!audio) {
      audio = new Audio(new URL(cue + '.mp3', directory));
      audio.volume = 0.3;
      players.set(cue, audio);
    }
    audio.currentTime = 0;
    audio.play().catch(() => {});
  }
  function update() {
    document.querySelectorAll('[data-sound-switch]').forEach(button => {
      button.textContent = enabled ? 'Sound on' : 'Sound off';
      button.setAttribute('aria-pressed', String(enabled));
    });
  }
  document.addEventListener('click', event => {
    const button = event.target.closest('a, button, summary');
    if (!button || button.disabled) return;
    if (button.matches('[data-sound-switch]')) {
      enabled = !enabled;
      try { localStorage.setItem('oo-sound', enabled ? 'on' : 'off'); } catch {}
      update(); play('confirm'); return;
    }
    play(button.dataset.cue || (button.getAttribute('aria-haspopup') === 'dialog' ? 'open' : button.hasAttribute('aria-pressed') ? 'option' : 'decide'));
  }, true);
  document.addEventListener('pointerover', event => {
    if (event.pointerType !== 'mouse') return;
    const control = event.target.closest('a,button,summary');
    if (control && !control.contains(event.relatedTarget) && !control.disabled) play('cursor');
  });
  document.addEventListener('cancel', () => play('cancel'), true);
  update();
})();
