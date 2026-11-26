'use strict';

const el = id => document.getElementById(id);
const fields = [...document.querySelectorAll('.field')];
const paperRows = [...document.querySelectorAll('.field .paper')];
const notes = el('paper-notes').content;
const feed = new AtlasFeed();
const labels = {questions:'Questions', records:'Work log', rounds:'Rounds'};
const notebookURL = 'https://github.com/shunyaekam/oo-research/blob/research/campaign/pipeline.json';
const ownerFields = new Map();
const displayDate = new Intl.DateTimeFormat(undefined,{month:'short',day:'numeric',hour:'numeric',minute:'2-digit',timeZoneName:'short'});
const dateText = date => Number.isFinite(Date.parse(date)) ? displayDate.format(new Date(date)) : '';
let pages = [], page = 0, frame = 0, chosenRow = null, activeView = '';
const dialog = el('drawer');
function make(tag, text, cls) {
  const item = document.createElement(tag);
  if (text) item.textContent = text;
  if (cls) item.className = cls;
  return item;
}
function link(label, url, cls) {
  const item = make('a',label,cls);
  item.href = url;
  return item;
}
function fieldName(field) { return field.querySelector('h2').textContent; }
function fieldByKey(key) { return fields.find(field => field.dataset.field===key); }
function fieldRecords(key,group) {
  if (!key) return feed.rows[group];
  return feed.rows[group].filter(r => {
    const owner = group==='questions' ? r.id : feed.owner(r);
    return (ownerFields.get(owner) || 'notebook')===key;
  });
}
function noteFor(paper) { return notes.querySelector('article[data-paper="'+CSS.escape(paper.id)+'"]'); }
function setPage(next) {
  page = Math.min(Math.max(0,next),Math.max(0,pages.length-1));
  fields.forEach(f => f.hidden = !pages[page]?.includes(f));
  el('back').disabled = page===0;
  el('forward').disabled = page+1>=pages.length;
  el('sheets').hidden = pages.length<=1;
  el('sheet-count').textContent = (page+1)+' / '+pages.length;
  el('mapboard').scrollTop = 0;
}
function layout() {
  cancelAnimationFrame(frame);
  frame = requestAnimationFrame(() => {
    const anchor = pages[page]?.[0], fixed = el('subject').value;
    const board = el('mapboard'), grid = el('fields');
    const width = board.clientWidth;
    const cols = fixed ? 1 : width>=1000 ? 4 : width>=720 ? 3 : width>=495 ? 2 : 1;
    const visible = fixed ? [fieldByKey(fixed)] : fields;
    grid.style.setProperty('--cols',cols);
    fields.forEach(f=> f.hidden=!visible.includes(f));
    const style = getComputedStyle(board);
    const available = board.clientHeight-parseFloat(style.paddingTop)-parseFloat(style.paddingBottom);
    const gap = parseFloat(getComputedStyle(grid).rowGap);
    pages = [];
    let batch = [], used = 0;
    for (let i=0;i<visible.length;i+=cols) {
      const row = visible.slice(i,i+cols);
      const height = Math.max(...row.map(f=>f.getBoundingClientRect().height));
      if (batch.length && used+gap+height>available+.5) {
        pages.push(batch); batch=[]; used=0;
      }
      used += (batch.length ? gap : 0)+height;
      batch.push(...row);
    }
    if (batch.length) pages.push(batch);
    const preferred = document.body.classList.contains('inspecting') ? document.querySelector('.field.selected') : null;
    setPage(Math.max(0,pages.findIndex(p=>p.includes(preferred || anchor))));
  });
}
function prepField(field,index) {
  const key=field.dataset.field;
  for(const id of field.dataset.questions.split(' ').filter(Boolean)) ownerFields.set(id,key);
  const opt = make('option',fieldName(field)); opt.value=key; el('subject').append(opt);
  field.style.setProperty('--delay',(-index*.37)+'s');
  const glyph=make('canvas');glyph.width=glyph.height=64;field.querySelector('.junction').append(glyph);
  const c=glyph.getContext('2d');if(!c)return;
  c.scale(2,2);c.strokeStyle=getComputedStyle(field).getPropertyValue('--accent').trim();c.lineWidth=1.2;c.lineCap='round';
  function path(points){c.beginPath();points.forEach(([x,y],i)=>i?c.lineTo(x,y):c.moveTo(x,y));c.stroke();}
  function oval(rx,ry,angle=0){c.beginPath();c.ellipse(16,16,rx,ry,angle,0,Math.PI*2);c.stroke();}
  switch(key){
    case 'codes': {
      const pts=[[7,8],[23,6],[26,21],[16,26],[6,20]];
      for(let i=0;i<5;i++)path([pts[i],pts[(i+2)%5]]);
      break;
    }
    case 'optics': for(let j=0;j<2;j++)path(Array.from({length:31},(_,i)=>[1+i,16+(j?-.65:1)*7*Math.sin(i*.35)]));break;
    case 'werner': oval(11,5,.62);oval(11,5,-.62);break;
    case 'packing': oval(11,11);oval(4.8,11,.3);oval(11,4,.3);break;
    case 'magic': path([[4,24],[4,9],[10,9],[10,12],[16,12],[16,16],[22,16],[22,21],[28,21]]);break;
    case 'transport': path([[4,24],[12,24],[12,18],[21,18],[21,9],[28,9]]);path([[5,18],[22,5]]);break;
    case 'trace': for(let i=0;i<3;i++)path([[7+i*8,25],[7+i*8,8+Math.abs(i-1)*6]]);break;
    case 'notebook': for(let i=0;i<3;i++)path([[6,9+i*7],[i===2?19:26,9+i*7]]);break;
  }
}
function dispatchFeed() {
  const status = el('connection'), stamp = dateText(feed.timestamp);
  const fresh = feed.state==='remote' && Date.now()-Date.parse(feed.timestamp)<30*60000;
  document.body.classList.toggle('fresh',fresh);
  document.body.classList.toggle('quiet',!fresh);
  const prefixes={loading:'Connecting…',remote:'Last publication',snapshot:'Saved snapshot',offline:'Feed unavailable · last seen',unavailable:'Feed unavailable'};
  status.textContent = prefixes[feed.state]+(stamp?' · '+stamp:'');
  const open = feed.rows.questions.filter(q=>q.status==='under_investigation').length;
  el('inventory').textContent=paperRows.length+' papers'+(feed.timestamp?' · '+open+' open questions':'');
  fields.forEach(field=>{
    const key=field.dataset.field, work=fieldRecords(key,'records'), questions=fieldRecords(key,'questions');
    const branch=field.querySelector('.feed-branch'), a=branch.querySelector('a');
    const counts=[];
    if(questions.length)counts.push(questions.length+' question'+(questions.length===1?'':'s'));
    if(work.length)counts.push(work.length+' record'+(work.length===1?'':'s'));
    branch.hidden=!counts.length;
    field.classList.toggle('has-publications',work.length>0);
    a.textContent=counts.join(' · ');a.href='#field/'+key+'/'+(questions.length?'questions':'records');
    a.setAttribute('aria-label',fieldName(field)+' notebook, '+counts.join(' and '));
  });
  layout();
  if(dialog.open && activeView==='feed') showRoute(false);
}
function panel(kind,title) {
  el('dialog-kind').textContent=kind;
  el('dialog-title').textContent=title;
  el('drawer-body').replaceChildren();
  if(!dialog.open)dialog.showModal();
  return el('drawer-body');
}
function closePanel() {
  if(dialog.open)dialog.close();
  activeView='';
  fields.forEach(f=>f.classList.remove('selected'));
  document.body.classList.remove('inspecting');
}
function notebookPanel(key,group) {
  const field=fieldByKey(key);
  const body=panel(field?'Subject notebook':'Live notebook',field?fieldName(field):'Research notebook');
  activeView='feed';
  const modes = field ? ['questions','records'] : ['rounds','questions','records'];
  const tabs=make('div',null,'feed-tabs');
  for(const m of modes){
    const btn=make('button',labels[m]);
    btn.type='button';btn.setAttribute('aria-pressed',String(m===group));
    btn.dataset.control=m;
    btn.onclick=()=>{location.hash=field?'field/'+key+'/'+m:m;};
    tabs.append(btn);
  }
  body.append(tabs);
  const rows=fieldRecords(key,group);
  let idx=chosenRow ? rows.findIndex(r=>r.id===chosenRow) : 0;
  if(idx<0){chosenRow=null;idx=0;}
  const row=rows[idx];
  const owner = row && (group==='questions' ? row.id : feed.owner(row));
  const selected = key || (row ? ownerFields.get(owner) || 'notebook' : null);
  fields.forEach(f=>f.classList.toggle('selected',f.dataset.field===selected));
  document.body.classList.add('inspecting');
  if (selected && el('subject').value && el('subject').value!==selected) el('subject').value='';
  layout();
  const readout=make('section');
  readout.setAttribute('aria-live','polite');
  if(row){
    readout.append(make('small',[String(row.status||'').replaceAll('_',' '),dateText(row.updated_at)].filter(Boolean).join(' · '),'row-meta'),
      make('h3',row.title),make('p',group==='questions' ? row.question || row.detail : row.detail));
    if(/^https:\/\//.test(row.url))readout.append(link(group==='questions'?'Original question':'Published record',row.url));
  }else readout.append(make('p',feed.timestamp?'No published entries in this view.':feed.state==='unavailable'?'The live feed is unavailable.':'Loading notebook…'));
  body.append(readout);
  const arrows=make('div',null,'arrows');
  function arrow(label,delta){
    const btn=make('button',delta<0?'←':'→');btn.type='button';btn.dataset.control=delta<0?'prev':'next';btn.setAttribute('aria-label',label);
    btn.disabled=delta<0?idx===0:idx+1>=rows.length;
    btn.onclick=()=>{chosenRow=rows[idx+delta].id;showRoute(false);};
    return btn;
  }
  arrows.append(arrow('Previous entry',-1),make('output',row?(idx+1)+' / '+rows.length:'—'),arrow('Next entry',1));body.append(arrows);
  if (field && field.querySelector('.read')){
    body.append(make('h3','Papers in this subject'));
    const list=make('ul',null,'field-papers');
    for(const a of field.querySelectorAll('.read')){
      const li=make('li');li.append(link(a.textContent,a.href));list.append(li);
    }
    body.append(list);
  }
  const links=make('div',null,'source-links');
  if(key)links.append(link('Full notebook','#rounds'));
  links.append(link('Public feed',notebookURL));
  body.append(links);
}
function showNote(paper) {
  activeView='paper';
  fields.forEach(f=>f.classList.toggle('selected',f===paper.closest('.field')));
  const source=paper.querySelector('.read');
  const body=panel(fieldName(paper.closest('.field')),source.textContent);
  body.append(link('Read paper',source.href,'paper-go'));
  const note=noteFor(paper).cloneNode(true);
  note.querySelectorAll('details').forEach(d=>d.open=true);
  note.querySelectorAll('a[href="#'+paper.id+'"]').forEach(a=>a.remove());
  body.append(note);
}
function findPanel() {
  activeView='find';
  const body=panel('Research map','Find a paper'), form=make('form',null,'search-controls');
  const params=new URLSearchParams(location.search);
  const query=make('input');query.type='search';query.value=params.get('q') || '';query.placeholder='Title, subject, or keyword';query.setAttribute('aria-label','Search papers');
  form.append(query);
  function choose(param,label,values){
    const select=make('select');select.setAttribute('aria-label',label);const all=make('option',label);all.value='';select.append(all);
    for(const v of values){const o=make('option',v);select.append(o);}select.value=params.get(param)||'';form.append(select);return select;
  }
  const area=choose('area','All fields',['Quantum information','Quantum optics','Mathematical physics']);
  const method=choose('method','All methods',['Partial Lean','Certificates','Analytic proof']);
  const results=make('ul',null,'find-results'),count=make('p',null,'find-count');
  count.setAttribute('role','status');body.append(form,count,results);
  function search(save){
    const fold=s=>s.normalize('NFD').replace(/[\u0300-\u036f]/g,'').toLowerCase();
    const words=fold(query.value.trim()).split(/\s+/).filter(Boolean);
    results.replaceChildren();
    for(const paper of paperRows){
      const note=noteFor(paper),name=fieldName(paper.closest('.field')),a=paper.querySelector('.read');
      const content=fold([name,a.textContent,note.textContent,paper.id].join(' '));
      if((area.value && note.dataset.area!==area.value) || (method.value && note.dataset.method!==method.value && !(method.value==='Partial Lean' && note.dataset.lean==='true')) || !words.every(w=>content.includes(w))) continue;
      const li=make('li');li.append(make('small',name),link(a.textContent,a.href,'result-title'));results.append(li);
    }
    count.textContent=results.children.length+' matching paper'+(results.children.length===1?'':'s');
    if(save){const url=new URL(location.href);for(const [k,v] of [['q',query.value],['area',area.value],['method',method.value]]){if(v)url.searchParams.set(k,v);else url.searchParams.delete(k);}url.hash='find';history.replaceState(null,'',url);}
  }
  form.addEventListener('input',()=>search(true));form.onsubmit=e=>e.preventDefault();
  search(false);query.focus();
}
function showRoute(reset=true) {
  const hash=location.hash.slice(1),parts=hash.split('/');
  const focused=document.activeElement?.dataset?.control;
  if(reset)chosenRow=null;
  document.body.classList.remove('inspecting');
  if(parts[0]==='field' && fieldByKey(parts[1]))notebookPanel(parts[1],parts[2]==='records'?'records':'questions');
  else if(Object.hasOwn(labels,hash))notebookPanel(null,hash);
  else if(hash==='find' || ((!hash||hash==='catalogue') && /[?&](q|area|method)=/.test(location.search)))findPanel();
  else if(hash==='verification'){
    activeView='verification';panel('Research map','Verification').append(el('verification-note').content.cloneNode(true));
  }else{
    const paper=paperRows.find(p=>p.id===(parts[0]==='note'?parts[1]:hash));
    if(paper)showNote(paper);else closePanel();
  }
  if(!reset && focused)dialog.querySelector('[data-control="'+CSS.escape(focused)+'"]:not(:disabled)')?.focus({preventScroll:true});
}
function dismiss() {
  const url=new URL(location.href);url.hash='';
  ['q','area','method'].forEach(k=>url.searchParams.delete(k));
  history.replaceState(null,'',url);closePanel();
}
document.body.classList.add('enhanced','quiet');
fields.forEach(prepField);
el('subject').onchange=()=>{page=0;layout();};
el('back').onclick=()=>setPage(page-1);
el('forward').onclick=()=>setPage(page+1);
el('close').onclick=dismiss;
dialog.addEventListener('cancel',event=>{event.preventDefault();dismiss();});
dialog.addEventListener('click',event=>{if(event.target===dialog){const r=dialog.getBoundingClientRect();if(event.clientX<r.left || event.clientX>r.right || event.clientY<r.top || event.clientY>r.bottom)dismiss();}});
document.addEventListener('keydown',e=>{
  if(e.altKey || e.ctrlKey || e.metaKey || e.shiftKey || !['ArrowLeft','ArrowRight'].includes(e.key) || /INPUT|SELECT|TEXTAREA/.test(document.activeElement.tagName))return;
  if(dialog.open && activeView==='feed'){e.preventDefault();dialog.querySelector('[data-control="'+(e.key==='ArrowLeft'?'prev':'next')+'"]')?.click();}
  else if(!dialog.open && !el('sheets').hidden){e.preventDefault();setPage(page+(e.key==='ArrowLeft'?-1:1));}
});
const motion=el('motion'), reduced=matchMedia('(prefers-reduced-motion: reduce)');
function pause(value){document.body.classList.toggle('paused',value);motion.textContent=value?'Resume flow':'Pause flow';motion.setAttribute('aria-pressed',String(value));}
motion.hidden=false;pause(reduced.matches);motion.onclick=()=>pause(!document.body.classList.contains('paused'));reduced.addEventListener('change',e=>pause(e.matches));
window.addEventListener('hashchange',()=>showRoute());
new ResizeObserver(layout).observe(el('mapboard'));
document.fonts.ready.then(layout);
showRoute();layout();feed.addEventListener('change',dispatchFeed);feed.start();
