const entries = [...document.querySelectorAll('article[data-pr]')];
const topics = [...document.querySelectorAll('.topics a')];
const checked = new Set();
async function review(entry) {
  if (checked.has(entry.id)) return;
  checked.add(entry.id);
  try {
    const response = await fetch('https://api.github.com/repos/GuillaumeBAUD-coder/open-math-agents/pulls/' + entry.dataset.pr, {signal: AbortSignal.timeout(6000)});
    if (!response.ok) return;
    const pr = await response.json();
    const kind = entry.dataset.kind;
    const labels = new Set(pr.labels.map(label => label.name));
    const status = pr.merged_at ? kind + ' merged' : pr.state === 'closed' ? 'Closed without merge · see review' :
      labels.has('needs-human-review') ? 'Checker passed · maintainer review' : 'Open · see checker and review';
    entry.querySelector('.status').textContent = status;
  } catch { /* The direct pull request link always carries the authoritative verdict. */ }
}
function select() {
  const entry = entries.find(item => item.id === location.hash.slice(1)) || entries[0];
  entries.forEach(item => { item.hidden = item !== entry; });
  topics.forEach(item => {
    if (item.hash === '#' + entry.id) item.setAttribute('aria-current','true');
    else item.removeAttribute('aria-current');
  });
  review(entry);
}
window.addEventListener('hashchange',select);
select();
