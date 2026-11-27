const entries = [...document.querySelectorAll('article[id]')];
const topics = [...document.querySelectorAll('.topics a')];
const checked = new Set();
async function reviewStep(entry) {
  const status = entry.querySelector('[data-step-status]');
  if (!status) return;
  try {
    const response = await fetch('https://api.github.com/repos/GuillaumeBAUD-coder/open-math-agents/pulls/1167', {signal: AbortSignal.timeout(6000)});
    if (!response.ok) return;
    const pr = await response.json();
    status.textContent = pr.merged_at ? 'Step proof merged' : pr.state === 'closed' ? 'Closed · see review' : pr.labels.some(label => label.name === 'needs-human-review') ? 'Proof passed · maintainer review' : 'Open · see upstream checker';
  } catch { /* The submitted proof links directly to its review. */ }
}
async function review(entry) {
  if (!entry.dataset.pr || checked.has(entry.id)) return;
  checked.add(entry.id);
  reviewStep(entry);
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
const diskButton = document.getElementById('disk-toggle');
diskButton.addEventListener('click', () => {
  const traced = diskButton.closest('figure').classList.toggle('is-traced');
  diskButton.setAttribute('aria-pressed', String(traced));
  document.getElementById('disk-caption').textContent = traced
    ? 'The twelve forced edges close around the center. A cycle through all thirteen sites is impossible.'
    : 'Each outer tip has only two neighbors.';
});
