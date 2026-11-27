// Shared lab navigation; each page keeps its own reading or diagram controls.
(() => {
  const header = document.querySelector('header.lab-header nav');
  if (!header || !window.HTMLDialogElement) return;
  const base = new URL('../',document.currentScript.src);
  const destinations = [
    ['Discoveries',''], ['Research map','catalogue.html'],
    ['Open problems','pipeline/indexed.html'], ['Pipeline','pipeline/'],
    ['GitHub','https://github.com/shunyaekam/oo-research']
  ];
  const button = document.createElement('button');
  button.id = 'menu-open';
  button.type = 'button';
  button.className = 'lab-menu-toggle';
  button.setAttribute('aria-label','Open lab menu');
  button.setAttribute('aria-haspopup','dialog');
  button.setAttribute('aria-controls','menu');
  button.innerHTML = '<span aria-hidden="true">☰</span>';
  header.append(button);

  const dialog = document.createElement('dialog');
  dialog.id = 'menu';
  dialog.className = 'lab-navigation';
  dialog.setAttribute('aria-label','Lab menu');
  dialog.innerHTML = '<div class="lab-navigation-body"><button type="button" id="menu-close" aria-label="Close lab menu" data-cue="cancel">×</button><nav aria-label="Lab pages"></nav><p>Project initiated and directed by <a href="https://www.researchgate.net/profile/Aryan-Singh-101">Aryan Singh</a>.</p><button type="button" id="sound" data-sound-switch>Sound on</button></div>';
  const nav = dialog.querySelector('nav');
  for (const [label,path] of destinations) {
    const a = document.createElement('a');
    a.href = new URL(path,base).href;
    a.textContent = label;
    if (new URL(a.href).pathname === location.pathname && new URL(a.href).origin === location.origin) a.setAttribute('aria-current','page');
    nav.append(a);
  }
  document.body.append(dialog);
  button.onclick = () => dialog.showModal();
  dialog.querySelector('#menu-close').onclick = () => dialog.close();
  dialog.addEventListener('click',e => { if (e.target === dialog || e.target === dialog.firstElementChild) dialog.close(); });
  dialog.addEventListener('close',() => button.focus({preventScroll:true}));
})();
