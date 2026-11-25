const form = document.querySelector('#filters');
const query = document.querySelector('#query');
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
      && (!method.value || method.value === paper.dataset.method)
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
window.addEventListener('hashchange', reveal);
restore(); reveal();
