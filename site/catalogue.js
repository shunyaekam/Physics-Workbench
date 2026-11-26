const form = document.querySelector('#filters');
const query = document.querySelector('#query');
const area = document.querySelector('#area');
const method = document.querySelector('#method');
const papers = [...document.querySelectorAll('#papers article')];
const clean = text => text.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
const searchable = papers.map(paper => clean(paper.textContent + ' ' + paper.id));
let matches = papers;
let current = 0;
const previous = document.querySelector('#prev-paper');
const next = document.querySelector('#next-paper');
function displayCurrent() {
  const verifying = location.hash === '#verification';
  document.querySelector('#verification').hidden = !verifying;
  document.querySelector('#catalogue').hidden = verifying;
  papers.forEach(paper => { paper.hidden = paper !== matches[current]; });
  previous.disabled = current === 0;
  next.disabled = current + 1 >= matches.length;
  document.querySelector('#pager').hidden = !matches.length;
  document.querySelector('#position').textContent = matches.length ? (current+1) + ' of ' + matches.length : '';
}
function step(delta) {
  current += delta;
  const url = new URL(location.href);
  url.hash = matches[current].id;
  history.pushState(null, '', url);
  displayCurrent();
}
previous.onclick = () => step(-1);
next.onclick = () => step(1);
function filter(save) {
  const words = clean(query.value.trim()).split(/\s+/).filter(Boolean);
  matches = papers.filter((paper, i) => {
    return (!area.value || area.value === paper.dataset.area)
      && (!method.value || method.value === paper.dataset.method || (method.value === 'Partial Lean' && paper.dataset.lean === 'true'))
      && words.every(word => searchable[i].includes(word));
  });
  current = save ? 0 : Math.max(0, matches.findIndex(paper => '#'+paper.id === location.hash));
  const count = matches.length;
  displayCurrent();
  document.querySelector('#count').textContent = count + (count === 1 ? ' manuscript' : ' manuscripts');
  document.querySelector('#empty').hidden = count !== 0;
  if (save) {
    const url = new URL(location.href);
    for (const [key, value] of [['q', query.value], ['area', area.value], ['method', method.value]]) {
      if (value) url.searchParams.set(key, value);
      else url.searchParams.delete(key);
    }
    url.hash = 'catalogue';
    history.replaceState(null, '', url);
  }
}
function restore() {
  const params = new URLSearchParams(location.search);
  query.value = params.get('q') || '';
  area.value = params.get('area') || '';
  method.value = params.get('method') || '';
  filter(false);
}
function reveal() {
  const paper = papers.find(item => '#' + item.id === location.hash);
  if (paper) paper.querySelector('details').open = true;
}
form.hidden = false;
form.addEventListener('input', () => filter(true));
form.addEventListener('submit', event => { event.preventDefault(); filter(true); });
document.querySelector('#reset').addEventListener('click', () => {
  form.reset(); filter(true); query.focus();
});
window.addEventListener('popstate', restore);
window.addEventListener('hashchange', () => { restore(); reveal(); });
document.body.classList.add('enhanced');
restore(); reveal();

fetch("certificates/index.json", {cache:"no-cache"}).then(r=>{if (!r.ok) throw Error(); return r.json();}).then(index=>{document.querySelector("#certTotal").textContent=' (' + Object.keys(index).length + ')';}).catch(()=>{});
