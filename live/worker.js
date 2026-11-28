'use strict';

(() => {
  const url = 'https://raw.githubusercontent.com/shunyaekam/oo-research/worker-status/worker.json';
  const status = document.getElementById('worker-now');
  const stamp = document.getElementById('worker-stamp');
  const nodes = document.getElementById('nodes');
  const fields = new Set(Array.from(document.querySelectorAll('[data-field]'), e => e.dataset.field));
  let sample, field, pending = false, offline = false;

  function mark() {
    for (const node of nodes.querySelectorAll('.topic')) {
      node.classList.toggle('worker-active', Boolean(field) && node.dataset.key === 'q-' + field);
    }
  }

  function render() {
    const when = Date.parse(sample?.observed_at);
    const age = Date.now() - when;
    const valid = Number.isFinite(age) && age >= -15000;
    const running = valid && !offline && age < 75000 && sample.state === 'running';
    field = running && fields.has(sample.field) ? sample.field : null;
    let label = 'Worker status unavailable';
    if (valid) {
      if (offline) label = 'Worker feed offline';
      else if (running) label = 'Working · ' + sample.task;
      else if (sample.state === 'idle' && age < 15*60000) label = 'Between runs · worker checks every 10 min';
      else if (sample.state === 'failed') label = 'Last run stopped early';
      else label = 'No recent worker update';
      stamp.textContent = new Date(when).toLocaleTimeString([], {hour:'2-digit', minute:'2-digit', second:'2-digit'});
      stamp.dateTime = sample.observed_at;
      stamp.title = 'Last worker report · ' + new Date(when).toLocaleString();
    }
    status.href = field && field !== 'notebook' ? '#field/'+field+'/records' : '#rounds';
    status.textContent = label;
    mark();
  }

  async function poll() {
    if (pending || document.hidden) return;
    pending = true;
    try {
      const response = await fetch(url+'?t='+Math.floor(Date.now()/15000),
        {cache:'no-store',signal:AbortSignal.timeout(7000)});
      if (!response.ok) throw Error('Unavailable');
      const data = await response.json();
      if (!['running','idle','failed'].includes(data.state) || typeof data.task !== 'string' ||
          !Number.isFinite(Date.parse(data.observed_at))) throw Error('Invalid report');
      if (!sample || Date.parse(data.observed_at) >= Date.parse(sample.observed_at)) sample = data;
      offline = false;
    } catch { offline = true; } finally { pending = false; render(); }
  }
  new MutationObserver(mark).observe(nodes,{childList:true});
  document.addEventListener('visibilitychange',poll);
  setInterval(poll,15000);
  poll();
})();
