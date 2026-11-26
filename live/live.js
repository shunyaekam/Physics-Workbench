'use strict';

const project = 'shunyaekam/oo-research';
const branch = 'https://github.com/' + project + '/blob/research/';
const raw = 'https://raw.githubusercontent.com/' + project + '/research/';
const interval = 60_000;
const byId = id => document.getElementById(id);
const sets = {rounds: [], questions: [], records: []};
const selection = {rounds: 0, questions: 0, records: 0};
const archive = new Map();
const accepted = new Set(['rounds', 'questions', 'records']);
let mode = accepted.has(location.hash.slice(1)) ? location.hash.slice(1) : 'rounds';
let snapshot, sourceState, pending = false;

const dates = new Intl.DateTimeFormat(undefined, {
  month:'short', day:'numeric', hour:'numeric', minute:'2-digit', timeZoneName:'short'
});
function dateText(value) {
  return Number.isFinite(Date.parse(value)) ? dates.format(new Date(value)) : '';
}
function jsonFrom(url) {
  return fetch(url, {cache:'no-store', signal:AbortSignal.timeout(9000)}).then(response => {
    if (!response.ok) throw Error('Source unavailable');
    return response.json();
  });
}
function announce() {
  const date = dateText(snapshot.updated_at);
  const age = Math.max(0, Date.now() - Date.parse(snapshot.updated_at));
  const recent = sourceState === 'remote' && age < 30 * 60_000;
  const status = byId('connection');
  status.dataset.state = recent ? 'recent' : 'quiet';
  const prefix = sourceState === 'remote' ? (recent ? 'Latest publication' : 'Last publication')
    : sourceState === 'snapshot' ? 'Saved snapshot' : 'Feed unavailable · last seen';
  status.textContent = prefix + ' · ' + date;
}
function draw() {
  const rows = sets[mode], index = selection[mode], row = rows[index];
  for (const button of byId('modes').querySelectorAll('button')) {
    button.setAttribute('aria-pressed', String(button.dataset.mode === mode));
  }
  byId('kind').textContent = row ? [row.status.replaceAll('_', ' '), dateText(row.updated_at)].filter(Boolean).join(' · ') : '';
  byId('title').textContent = row?.title || (snapshot ? 'No records in this view' : 'Research notebook');
  byId('detail').textContent = row?.detail || (snapshot ? '' : 'The lab publishes a record when a search round finishes.');
  const source = byId('source');
  source.textContent = mode === 'questions' ? 'Original question ↗' : 'Open record ↗';
  source.hidden = !row;
  if (row && /^https:\/\//.test(row.url)) source.href = row.url;
  else source.removeAttribute('href');
  byId('position').textContent = row ? (index + 1) + ' / ' + rows.length : '—';
  byId('previous').disabled = index === 0;
  byId('next').disabled = index + 1 >= rows.length;
  const trace = byId('trace');
  const focused = trace.contains(document.activeElement);
  trace.replaceChildren();
  const start = Math.floor(index / 8) * 8;
  for (const [offset, item] of rows.slice(start, start + 8).entries()) {
    const button = document.createElement('button');
    button.type = 'button';
    button.title = item.title;
    button.setAttribute('aria-label', item.title);
    button.setAttribute('aria-current', String(start + offset === index));
    button.addEventListener('click', () => select(start + offset));
    trace.append(button);
  }
  if (focused) trace.querySelector('[aria-current=true]')?.focus();
}
function select(index) {
  if (index < 0 || index >= sets[mode].length) return;
  selection[mode] = index;
  draw();
}
function installSet(key, rows) {
  // Stay on the newest record when following the head. Preserve an older selection on refresh.
  const old = selection[key] > 0 && sets[key][selection[key]]?.id;
  sets[key] = rows;
  selection[key] = old ? Math.max(0, rows.findIndex(row => row.id === old)) : 0;
}
function useFeed(feed) {
  if (feed.schema_version !== 1 || !Number.isFinite(Date.parse(feed.updated_at))
      || !Array.isArray(feed.problems) || !Array.isArray(feed.activity)) throw Error('Unknown feed');
  snapshot = feed;
  const activities = [...feed.activity].sort((a,b) => (Date.parse(b.updated_at)||0) - (Date.parse(a.updated_at)||0));
  installSet('records', activities);
  installSet('questions', feed.problems.filter(row => row.status === 'under_investigation')
    .map(row => ({...row, detail:row.question || row.detail})));
  const head = activities.find(row => /^round-\d+$/.test(row.id));
  if (!head) {
    installSet('rounds', []);
  } else {
    const number = Number(head.id.slice(6));
    installSet('rounds', [head, ...Array.from({length:7}, (_,i) => archive.get(number-i-1)).filter(Boolean)]);
  }
  announce();
  draw();
  return head;
}
async function fillHistory(head) {
  const latest = Number(head.id.slice(6));
  const numbers = Array.from({length:8}, (_,i) => latest-i).filter(value => value > 0);
  await Promise.allSettled(numbers.filter(number => !archive.has(number)).map(async number => {
    const path = 'campaign/rounds/' + String(number).padStart(8, '0') + '.json';
    const report = await jsonFrom(raw + path);
    if (report.round !== number || !Array.isArray(report.quantum) || !dateText(report.utc)) return;
    const evaluated = report.quantum.reduce((sum, record) => sum + record.evaluated, 0);
    if (!Number.isSafeInteger(evaluated) || evaluated < 0) return;
    const details = [evaluated.toLocaleString() + ' Werner vectors evaluated'];
    const optics = (report.wigner || []).reduce((sum, batch) => sum + batch.states, 0);
    if (Number.isSafeInteger(optics) && optics > 0) details.push(optics.toLocaleString() + ' optical states screened');
    archive.set(number, {
      id:'round-' + number, title:'Research round ' + number, status:'completed',
      detail:details.join(' · ') + '.', updated_at:report.utc, url:branch + path
    });
  }));
  installSet('rounds', numbers.map(number => archive.get(number) || (number === latest ? head : null)).filter(Boolean));
  for (const number of archive.keys()) if (number < latest-8) archive.delete(number);
  if (mode === 'rounds') draw();
}
async function poll() {
  if (pending || document.hidden) return;
  pending = true;
  try {
    const feed = await jsonFrom(raw + 'campaign/pipeline.json?poll=' + Math.floor(Date.now()/interval));
    sourceState = 'remote';
    const head = useFeed(feed);
    if (head) await fillHistory(head);
  } catch {
    if (snapshot) {
      if (sourceState === 'remote') sourceState = 'offline';
      announce();
    } else {
      try {
        sourceState = 'snapshot';
        useFeed(await jsonFrom('../pipeline/snapshot.json'));
      } catch {
        byId('connection').textContent = 'Feed unavailable. Open the public feed below.';
      }
    }
  } finally {
    pending = false;
  }
}
byId('modes').addEventListener('click', event => {
  const next = event.target.closest('[data-mode]')?.dataset.mode;
  if (accepted.has(next) && mode !== next) location.hash = next;
});
window.addEventListener('hashchange', () => {
  mode = accepted.has(location.hash.slice(1)) ? location.hash.slice(1) : 'rounds';
  draw();
});
byId('previous').addEventListener('click', () => select(selection[mode]-1));
byId('next').addEventListener('click', () => select(selection[mode]+1));
document.addEventListener('keydown', event => {
  if (event.altKey || event.ctrlKey || event.metaKey || event.shiftKey) return;
  if (event.key === 'ArrowRight' || event.key === 'ArrowLeft') {
    event.preventDefault();
    select(selection[mode] + (event.key === 'ArrowRight' ? 1 : -1));
  }
});
document.addEventListener('visibilitychange', () => { if (!document.hidden) poll(); });
poll();
setInterval(poll, interval);
