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
el('mapboard').after(dialog);
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
let map;
function layout() { if (map) map.update(fields,el('subject').value); }
function prepField(field) {
  const key=field.dataset.field;
  for(const id of field.dataset.questions.split(' ').filter(Boolean)) ownerFields.set(id,key);
  const opt=make('option',fieldName(field)); opt.value=key; el('subject').append(opt);
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
function panel(kind,title,spatial=false) {
  el('dialog-kind').textContent=kind;
  el('dialog-title').textContent=title;
  el('drawer-body').replaceChildren();
  if(dialog.open && dialog.classList.contains('spatial') !== spatial) dialog.close();
  dialog.classList.toggle('spatial',spatial);
  if(!dialog.open) { if(spatial) dialog.show(); else dialog.showModal(); }
  return el('drawer-body');
}
function closePanel() {
  if(dialog.open)dialog.close();
  activeView='';
  fields.forEach(f=>f.classList.remove('selected'));
  el('subject').value=''; layout();
  document.body.classList.remove('inspecting');
}
function notebookPanel(key,group) {
  const field=fieldByKey(key);
  const body=panel(field?'Subject notebook':'Live notebook',field?fieldName(field):'Research notebook',true);
  activeView='feed';
  const modes = field ? ['questions','records'] : ['rounds','questions','records'];
  if(field && group==='questions' && !fieldRecords(key,'questions').length) group='records';
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
  if(selected) el('subject').value=selected;
  document.body.classList.add('inspecting');
  layout();
  const readout=make('section');
  readout.setAttribute('aria-live','polite');
  if(row){
    readout.append(make('small',[String(row.status||'').replaceAll('_',' '),dateText(row.updated_at)].filter(Boolean).join(' · '),'row-meta'),
      make('h3',row.title),make('p',group==='questions' ? row.question || row.detail : row.detail));
    if(/^https:\/\//.test(row.url))readout.append(link(group==='questions'?'Original question':'Published record',row.url));
  }else if (!field || !field.querySelector('.read')) readout.append(make('p',feed.timestamp?'No published entries in this view.':feed.state==='unavailable'?'The live feed is unavailable.':'Loading notebook…'));
  if(row || !field?.querySelector('.read')) body.append(readout);
  if (field && field.querySelector('.read')) {
    body.append(make('h3','Papers in this subject'));
    const list=make('ul',null,'field-papers');
    for(const a of field.querySelectorAll('.read')) {
      const li=make('li');li.append(link(a.textContent,a.href));
      li.append(' ',link('Evidence','#note/'+a.closest('.paper').id));list.append(li);
    }
    body.append(list);
  }
  const arrows=make('div',null,'arrows');
  function arrow(label,delta){
    const btn=make('button',delta<0?'←':'→');btn.type='button';btn.dataset.control=delta<0?'prev':'next';btn.setAttribute('aria-label',label);
    btn.disabled=delta<0?idx===0:idx+1>=rows.length;
    btn.onclick=()=>{chosenRow=rows[idx+delta].id;showRoute(false);};
    return btn;
  }
  arrows.append(arrow('Previous entry',-1),make('output',row?(idx+1)+' / '+rows.length:'—'),arrow('Next entry',1));if(row) body.append(arrows);
  const links=make('div',null,'source-links');
  if(key)links.append(link('Full notebook','#rounds'));
  links.append(link('Public feed',notebookURL));
  body.append(links);
}
function showNote(paper) {
  activeView='paper';
  fields.forEach(f=>f.classList.toggle('selected',f===paper.closest('.field')));
  const source=paper.querySelector('.read');
  el('subject').value=paper.closest('.field').dataset.field;
  document.body.classList.add('inspecting'); layout();
  const body=panel(fieldName(paper.closest('.field')),source.textContent,true);
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
map = new ResearchMap(el('mapboard'),(group,id)=>{
  if(group==='field') { el('subject').value=id; location.hash='field/'+id+'/questions'; layout(); }
  else if(group==='records') { el('subject').value=id; location.hash='field/'+id+'/records'; layout(); }
  else location.hash='note/'+id;
});
el('subject').onchange=()=>{const subject=el('subject').value; if(subject) location.hash='field/'+subject+'/questions'; else dismiss();};
el('close').onclick=dismiss;
dialog.addEventListener('cancel',event=>{event.preventDefault();dismiss();});
dialog.addEventListener('click',event=>{if(event.target===dialog){const r=dialog.getBoundingClientRect();if(event.clientX<r.left || event.clientX>r.right || event.clientY<r.top || event.clientY>r.bottom)dismiss();}});
document.addEventListener('keydown',e=>{
  if (document.querySelector('dialog.lab-navigation[open]')) return;
  if (e.key==='Escape' && dialog.open && dialog.classList.contains('spatial')) {
    e.preventDefault(); dismiss(); return;
  }
  if(e.altKey || e.ctrlKey || e.metaKey || e.shiftKey || !['ArrowLeft','ArrowRight'].includes(e.key) || /INPUT|SELECT|TEXTAREA/.test(document.activeElement.tagName))return;
  if(dialog.open && activeView==='feed'){e.preventDefault();dialog.querySelector('[data-control="'+(e.key==='ArrowLeft'?'prev':'next')+'"]')?.click();}
});
el('motion').hidden=false;
window.addEventListener('hashchange',()=>showRoute());
new ResizeObserver(layout).observe(el('mapboard'));
document.fonts.ready.then(layout);
showRoute();layout();feed.addEventListener('change',dispatchFeed);feed.start();
