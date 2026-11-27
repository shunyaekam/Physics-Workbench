const slug = document.body.dataset.paper;
const files = {
  'sphere-packing':'packing', 'distance-four':'codes-transport', 'eleven-five':'codes-transport', 'transport-polygon':'codes-transport',
  'coordinate-supports':'theory', 'finite-maxima':'theory', 'schmidt-rank-seven':'theory', 'bmv-trace-12-3':'theory',
  'single-rail-wigner':'optics', 'phase-invariant-wigner':'optics', 'sparse-fock-coherence':'optics', 'renyi-obstructions':'optics'
};
const id = key => document.getElementById(key);
const article = id('full-text');
const exploration = id('explore');
const toggle = id('view-link');

for (const element of article.querySelectorAll('table,math[display="block"]')) {
  const box = document.createElement('div');
  box.className = 'wide';
  element.before(box);
  box.append(element);
}

function chooseView() {
  let anchor;
  try { anchor = id(decodeURIComponent(location.hash.slice(1))); } catch {}
  const reading = !!anchor && article.contains(anchor);
  document.body.classList.toggle('reading',reading);
  exploration.hidden = reading;
  article.hidden = !reading;
  toggle.textContent = reading ? 'Explore' : 'Full text';
  toggle.href = reading ? '#explore' : '#full-text';
  if (reading) requestAnimationFrame(() => anchor.scrollIntoView({block:'start'}));
  else window.scrollTo(0,0);
}

async function startExploration() {
  const module = document.body.hasAttribute('data-contribution') ? '../left-to-solve/exhibit.mjs' : './' + files[slug] + '.mjs';
  const {exhibits} = await import(module);
  const exhibit = exhibits[slug];
  id('exhibit-title').textContent = exhibit.title;
  id('lead').textContent = exhibit.lead;
  id('scope').textContent = exhibit.scope;
  // Give canvas-based experiments a visible layout before they measure the figure.
  exploration.hidden = false;
  exhibit.mount(id('visual'),id('controls'),id('caption'));
  const more = id('more');
  const credit = document.querySelector('.paper-credit small');
  const compact = matchMedia('(max-width:700px) and (max-height:680px)');
  function fitDetails() {
    more.hidden = !compact.matches;
    if (compact.matches) more.append(id('scope'),...(credit ? [credit] : []));
    else {
      id('lead').after(id('scope'));
      if (credit) more.before(credit);
      more.open = false;
    }
  }
  compact.addEventListener('change',fitDetails);
  fitDetails();
  toggle.hidden = false;
  window.addEventListener('hashchange',chooseView);
  chooseView();
}
if (document.body.hasAttribute('data-article-only')) {
  document.body.classList.add('reading');
} else startExploration().catch(error => {
  console.error('Could not open the interactive edition:',error);
  exploration.hidden = true;
  article.hidden = false;
});
