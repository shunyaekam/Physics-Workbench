const form = document.querySelector('#filters');
const query = document.querySelector('#query');
const entry = document.querySelector('#entry-form');
const entryQuery = document.querySelector('#entry-query');
const entryAction = entry.querySelector('button');
function updateEntryAction() {
  entryAction.textContent = entryQuery.value.trim() ? 'search papers' : 'browse papers';
}
const area = document.querySelector('#area');
const method = document.querySelector('#method');
const papers = [...document.querySelectorAll('#papers article')];
const clean = text => text.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
const searchable = papers.map(paper => clean(paper.textContent + ' ' + paper.id));
function filter(save) {
  const words = clean(query.value.trim()).split(/\s+/).filter(Boolean);
  let count = 0;
  papers.forEach((paper, i) => {
    const match = (!area.value || area.value === paper.dataset.area)
      && (!method.value || method.value === paper.dataset.method || (method.value === 'Partial Lean' && paper.dataset.lean === 'true'))
      && words.every(word => searchable[i].includes(word));
    paper.hidden = !match;
    if (match) count++;
  });
  document.querySelector('#count').textContent = count + (count === 1 ? ' manuscript' : ' manuscripts');
  document.querySelector('#empty').hidden = count !== 0;
  if (save) {
    const url = new URL(location.href);
    for (const [key, value] of [['q', query.value], ['area', area.value], ['method', method.value]]) {
      if (value) url.searchParams.set(key, value);
      else url.searchParams.delete(key);
    }
    history.replaceState(null, '', url);
  }
}
function restore() {
  const params = new URLSearchParams(location.search);
  query.value = params.get('q') || '';
  entryQuery.value = query.value;
  updateEntryAction();
  area.value = params.get('area') || '';
  method.value = params.get('method') || '';
  filter(false);
}
function reveal() {
  const paper = papers.find(item => '#' + item.id === location.hash);
  if (paper) paper.querySelector('details').open = true;
}
entry.hidden = false;
entryQuery.addEventListener('input', updateEntryAction);
entry.addEventListener('submit', event => {
  event.preventDefault();
  const url = new URL(location.href);
  for (const key of ['q', 'area', 'method']) url.searchParams.delete(key);
  if (entryQuery.value.trim()) url.searchParams.set('q', entryQuery.value.trim());
  url.hash = 'catalogue';
  history.pushState(null, '', url);
  restore();
  const catalogue = document.querySelector('#catalogue');
  catalogue.focus({preventScroll:true});
  catalogue.scrollIntoView();
});
form.hidden = false;
form.addEventListener('input', () => { entryQuery.value = query.value; updateEntryAction(); filter(true); });
form.addEventListener('submit', event => { event.preventDefault(); filter(true); });
document.querySelector('#reset').addEventListener('click', () => {
  form.reset(); entryQuery.value = ''; updateEntryAction(); filter(true); query.focus();
});
window.addEventListener('popstate', restore);
window.addEventListener('hashchange', reveal);
restore(); reveal();

fetch("certificates/index.json", {cache:"no-cache"}).then(r=>{if (!r.ok) throw Error(); return r.json();}).then(index=>{document.querySelector("#certTotal").textContent=' (' + Object.keys(index).length + ')';}).catch(()=>{});
