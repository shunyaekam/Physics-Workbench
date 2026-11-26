'use strict';
const $ = id => document.getElementById(id);
const files = ['catalogues', 'other'];
const prefix = 'https://raw.githubusercontent.com/shunyaekam/oo-research/research/campaign/catalogue-index/';
let rows = [], filtered = [], shown = 0;
const pageSize = 50;
function label(...values) {
  return values.flat().filter(v=>typeof v==='string' && v.trim()).join(' · ');
}
function safeUrl(url) {
  try { const u=new URL(url); return ['https:', 'http:'].includes(u.protocol) ? u.href : null; }
  catch { return null; }
}
function appendPage() {
  const batch = document.createDocumentFragment();
  for (const row of filtered.slice(shown, shown + pageSize)) {
    const item = document.createElement('article');
    item.className = 'item';
    const anchor = document.createElement('a');
    const url = safeUrl(row.url);
    if (url) anchor.href = url;
    anchor.textContent = row.title;
    const meta = document.createElement('p');
    meta.className = 'meta';
    meta.textContent = label(row.source, row.id, row.status, row.kind);
    item.append(anchor,meta);
    batch.append(item);
  }
  $('rows').append(batch);
  shown = Math.min(shown + pageSize, filtered.length);
  $('more').hidden = shown === filtered.length;
}
function physicsQuestion(row) {
  const scope=row.physics || ['IQOQI Vienna','QIQCOP Zoo'].includes(row.source) ||
                    (row.topics || []).includes('mathematical physics');
  return scope && ['problem','catalogue'].includes(row.kind) &&
    ['open','unsolved','active','improved','partially resolved','partially solved','partial','partially open'].includes(row.status);
}
function filter() {
  const words = $('query').value.toLowerCase().trim().split(/\s+/).filter(Boolean);
  filtered = rows.filter(r=>($('scope').value!=='physics' || physicsQuestion(r)) && (!$('source').value || $('source').value===r.source) &&
                                words.every(w=>r.search.includes(w)));
  $('rows').replaceChildren(); shown=0;
  $('matches').textContent = filtered.length.toLocaleString()+' matching source entries of '+rows.length.toLocaleString()+' indexed.';
  appendPage();
}
async function read(url) {
  const res = await fetch(url, {signal:AbortSignal.timeout(10000)});
  if (!res.ok) throw Error('Unavailable index');
  const data = await res.json();
  if (!Array.isArray(data.rows)||!Array.isArray(data.sources)) throw Error('Invalid index');
  return data;
}
async function loadFile(name) {
  try {return {data:await read(prefix+name+'.json?t='+Math.floor(Date.now()/60000)),live:true};}
  catch {return {data:await read('index-data/'+name+'.json'),live:false};}
}
async function start() {
  const parts = await Promise.allSettled(files.map(loadFile));
  const coverage = $('coverage');
  const states = [];
  for (const [i,part] of parts.entries()) {
    if(part.status!=='fulfilled') {states.push(files[i]+' unavailable');continue;}
    const {data,live} = part.value;
    states.push(files[i]+(live ? ' from the research branch' : ' from the saved snapshot'));
    for(const src of data.sources) {
      const option=document.createElement('option');
      option.textContent=src.name+' ('+src.count+')'; option.value=src.name;
      $('source').append(option);
      const li=document.createElement('li');
      const a=document.createElement('a');
      a.textContent=src.name;
      const url=safeUrl(src.url);
      if(url) a.href=url;
      const kinds=Object.entries(src.kinds||{}).map(([k,v])=>v+' '+k).join(', ');
      li.append(a,document.createTextNode(' · '+label(String(src.count)+' entries',src.scope,kinds)));
      coverage.append(li);
    }
    rows.push(...data.rows.map(r=>({...r, search:label(r.id,r.title,r.source,r.status,r.topic,r.topics,r.kind,r.category).toLowerCase()})));
  }
  $('freshness').textContent=states.join(' · ')+'.';
  if(!rows.length) {$('matches').textContent='Index unavailable. Reload to retry.';return;}
  rows.sort((a,b)=>a.title.localeCompare(b.title)||a.source.localeCompare(b.source));
  filter();
  if(parts.some(p=>p.status==='rejected')) $('freshness').textContent+=' Coverage is incomplete.';
}
$('more').onclick=appendPage;
$('query').oninput=filter;
$('source').onchange=filter;
$('scope').onchange=filter;
start();
