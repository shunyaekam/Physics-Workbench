const entries = [...document.querySelectorAll('article[id]')];
const topics = [...document.querySelectorAll('.topics a')];
const checked = new Set();
async function reviewStep(status) {
  try {
    const response = await fetch('https://api.github.com/repos/GuillaumeBAUD-coder/open-math-agents/pulls/' + status.dataset.stepStatus, {signal: AbortSignal.timeout(6000)});
    if (!response.ok) return;
    const pr = await response.json();
    status.textContent = pr.merged_at ? 'Step proof merged' : pr.state === 'closed' ? 'Closed · see review' : pr.labels.some(label => label.name === 'needs-human-review') ? 'Proof passed · maintainer review' : 'Open · see upstream checker';
  } catch { /* The submitted proof links directly to its review. */ }
}
async function reviewFollowup(entry) {
  const polarity = entry.dataset.followup;
  if (!polarity) return;
  const branch = 'shunyaekam:oo-' + polarity + '-' + entry.id;
  const query = new URLSearchParams({head: branch, state: 'all'});
  const response = await fetch('https://api.github.com/repos/GuillaumeBAUD-coder/open-math-agents/pulls?' + query, {signal: AbortSignal.timeout(6000)});
  if (!response.ok) return;
  const [proof] = await response.json();
  if (!proof) return;
  const link = document.createElement('a');
  link.href = 'https://github.com/GuillaumeBAUD-coder/open-math-agents/pull/' + proof.number;
  link.textContent = (proof.merged_at ? 'Proof merged' : 'Proof review') + ' · #' + proof.number;
  entry.querySelector('.record').append(link);
}
async function review(entry) {
  if (!entry.dataset.pr || checked.has(entry.id)) return;
  checked.add(entry.id);
  entry.querySelectorAll('[data-step-status]').forEach(reviewStep);
  try {
    const response = await fetch('https://api.github.com/repos/GuillaumeBAUD-coder/open-math-agents/pulls/' + entry.dataset.pr, {signal: AbortSignal.timeout(6000)});
    if (!response.ok) return;
    const pr = await response.json();
    const kind = entry.dataset.kind;
    const labels = new Set(pr.labels.map(label => label.name));
    const status = pr.merged_at ? kind + ' merged' : pr.state === 'closed' ? 'Closed without merge · see review' :
      labels.has('needs-human-review') ? 'Checker passed · maintainer review' : 'Open · see checker and review';
    entry.querySelector('.status').textContent = status;
    if (pr.merged_at) await reviewFollowup(entry);
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
async function showRecentAttempts() {
  const endpoint = 'https://raw.githubusercontent.com/shunyaekam/oo-research/research/campaign/left-to-solve/latest.json';
  try {
    const response = await fetch(endpoint, {signal: AbortSignal.timeout(6000)});
    if (!response.ok) return;
    const rows = await response.json();
    const panel = document.getElementById('recent-attempts');
    for (const row of rows.slice(0, 5)) {
      if (!/^[a-f0-9]{24}$/.test(row.key) || typeof row.title !== 'string') continue;
      const item = document.createElement('li');
      const link = document.createElement('a');
      link.href = 'https://github.com/shunyaekam/oo-research/blob/research/campaign/scouting/' + row.key + '.json';
      link.textContent = row.title;
      item.append(link);
      panel.querySelector('ul').append(item);
      panel.hidden = false;
    }
  } catch { /* Published contributions remain available if the live feed is offline. */ }
}
showRecentAttempts();
