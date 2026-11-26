'use strict';

// The feed attaches work to questions with problem_id, or an exact flow-<question id> record.
const topicNames = {
  'werner-endpoint':'Werner states', 'e27-schmidt':'Nonlocal magic', golay43:'Golay circuits',
  'gagatsos-2026-c1':'Wigner–Husimi', 'refined-bmv':'Trace bounds', 'transport-polygon':'Quantum transport'
};
const inks = ['#347fa1','#5878a9','#3a9087','#8473a5','#657c9a','#508caa'];
function researchGraph(feed, sets, mode, current) {
  const nodes = [{key:'notebook', type:'core', label:'Notebook', tint:'#4f7387'}];
  if (!feed) return nodes;
  const topics = new Map(feed.problems.map(q => [q.id,q]));
  function owner(row) {
    if (topics.has(row?.problem_id)) return row.problem_id;
    if (row?.id.startsWith('flow-') && topics.has(row.id.slice(5))) return row.id.slice(5);
    return null;
  }
  const selected = sets.records.find(row => row.id === current?.id) || current;
  const branch = mode === 'questions' ? current?.id : owner(selected);
  const questions = sets.questions.filter(q => q.status === 'under_investigation').sort((a,b) => a.id.localeCompare(b.id));
  if (branch && !questions.some(q => q.id === branch)) questions.push(topics.get(branch));
  for (const [index,q] of questions.entries()) {
    const key = 'q-' + q.id, tint = inks[index % inks.length];
    const group = sets.records.filter(r => owner(r) === q.id);
    nodes.push({key, type:'topic', parent:'notebook', tint, label:topicNames[q.id] || q.title,
      title:q.title, group:'questions', id:q.id, branch:branch === q.id, active:mode === 'questions' && current?.id === q.id});
    const visible = group.slice(0,3);
    if (mode !== 'questions' && branch === q.id && selected && !visible.some(r => r.id === selected.id)) {
      if (visible.length === 3) visible.pop();
      visible.push(selected);
    }
    for (const r of visible) record(r,key,tint);
  }
  if (selected && mode !== 'questions' && !branch) record(selected,'notebook','#597f8e');
  return nodes;
  function record(r,parent,tint) {
    const active = mode !== 'questions' && current?.id === r.id;
    nodes.push({key:'r-' + r.id, type:'record', parent, tint, title:r.title, id:r.id,
      group:active ? mode : 'records', active, label:active ? (/^round-\d+$/.test(r.id) ? r.id.replace('round-','Round ') : 'Selected record') : ''});
  }
}

class ResearchMap {
  constructor(section, choose) {
    this.section = section;
    this.canvas = section.querySelector('canvas');
    this.ctx = this.canvas.getContext('2d');
    this.layer = section.querySelector('#nodes');
    this.choose = choose;
    this.nodes = [];
    this.time = 0;
    this.motion = document.getElementById('motion');
    const reduced = matchMedia('(prefers-reduced-motion: reduce)');
    this.paused = reduced.matches;
    this.setMotion = paused => {
      this.paused = paused;
      this.motion.setAttribute('aria-pressed',String(paused));
      this.motion.setAttribute('aria-label',paused ? 'Resume diagram motion' : 'Pause diagram motion');
      this.motion.title = this.motion.getAttribute('aria-label');
      this.motion.textContent = paused ? '▷' : 'Ⅱ';
      this.restart();
    };
    this.motion.addEventListener('click',() => this.setMotion(!this.paused));
    reduced.addEventListener('change',e => this.setMotion(e.matches));
    document.addEventListener('visibilitychange',() => this.restart());
    this.resize = new ResizeObserver(() => {
      this.width = section.clientWidth;
      this.height = section.clientHeight;
      const dpr = Math.min(window.devicePixelRatio || 1,2);
      this.canvas.width = Math.round(this.width * dpr);
      this.canvas.height = Math.round(this.height * dpr);
      this.ctx?.setTransform(dpr,0,0,dpr,0,0);
      this.layout();
      this.restart();
    });
    this.resize.observe(section);
    this.setMotion(this.paused);
  }
  update(feed,sets,mode,row) {
    const nodes = researchGraph(feed,sets,mode,row);
    const signature = JSON.stringify(nodes);
    if (signature === this.signature) return;
    this.signature = signature;
    const focused = this.layer.contains(document.activeElement) && document.activeElement.dataset.key;
    this.nodes = nodes;
    this.layer.replaceChildren();
    for (const n of nodes) {
      const core = n.type === 'core';
      const el = document.createElement(core ? 'a' : 'button');
      n.el = el;
      el.className = ['vertex',n.type,n.branch ? 'branch' : '',n.active ? 'active' : ''].join(' ');
      el.dataset.key = n.key;
      el.style.setProperty('--tint',n.tint);
      if (core) {
        el.href = 'https://github.com/shunyaekam/oo-research/tree/research/campaign';
        const img = document.createElement('img');
        img.src = '../site/assets/torus.png';
        img.alt = '';
        el.append(img);
      } else {
        el.type = 'button';
        el.setAttribute('aria-pressed',String(!!n.active));
        const dot = document.createElement('span');
        dot.className = 'dot';
        el.append(dot);
        el.addEventListener('click',() => this.choose(n.group,n.id));
      }
      el.title = core ? 'Open public research notebook' : n.title;
      el.setAttribute('aria-label',el.title);
      if (n.label) {
        const label = document.createElement('span');
        label.className = 'label';
        label.textContent = n.label;
        el.append(label);
      }
      this.layer.append(el);
    }
    this.layout();
    if (focused) this.nodes.find(n => n.key === focused)?.el.focus({preventScroll:true});
    this.restart();
  }
  layout() {
    if (!this.width || !this.height || !this.nodes.length) return;
    const w = this.width, h = this.height, cx = w * .5, cy = h * .49;
    const root = this.nodes[0], topics = this.nodes.filter(n => n.type === 'topic');
    Object.assign(root,{x:cx,y:cy,phase:0});
    topics.forEach((n,i) => {
      const angle = -Math.PI / 2 + .17 + i * 2*Math.PI/topics.length;
      Object.assign(n,{angle, x:cx + .293*w*Math.cos(angle), y:cy + .275*h*Math.sin(angle),phase:i+1});
    });
    for (const parent of [root,...topics]) {
      const children = this.nodes.filter(n => n.type === 'record' && n.parent === parent.key);
      children.forEach((n,i) => {
        const angle = (parent.angle ?? -.78) + (i-(children.length-1)/2)*.97;
        const rx = parent === root ? .18*w : Math.min(.145*w,110);
        const ry = parent === root ? .17*h : Math.min(.14*h,87);
        n.x = Math.max(22,Math.min(w-22,parent.x + rx*Math.cos(angle)));
        n.y = Math.max(31,Math.min(h-20,parent.y + ry*Math.sin(angle)));
        n.phase = parent.phase*4+i+1;
      });
    }
    const byKey = new Map(this.nodes.map(n => [n.key,n]));
    this.edges = this.nodes.slice(1).map(n => [byKey.get(n.parent),n]);
  }
  restart() {
    cancelAnimationFrame(this.frame);
    this.last = 0;
    if (document.hidden || !this.edges) return;
    this.paint();
    if (!this.paused) this.frame = requestAnimationFrame(t => this.tick(t));
  }
  tick(now) {
    if (!this.last || now-this.last >= 32) {
      this.time += this.last ? Math.min(now-this.last,100)/1000 : 0;
      this.last = now;
      this.paint();
    }
    this.frame = requestAnimationFrame(t => this.tick(t));
  }
  paint() {
    const ctx = this.ctx, t = this.time;
    for (const n of this.nodes) {
      const drift = n.type === 'core' ? 0 : n.type === 'topic' ? 2 : 3.2;
      n.px = n.x + drift*Math.sin(t*.46+n.phase);
      n.py = n.y + drift*Math.cos(t*.39+2*n.phase);
      n.el.style.left = n.px + 'px';
      n.el.style.top = n.py + 'px';
    }
    if (!ctx) return;
    ctx.clearRect(0,0,this.width,this.height);
    for (const [a,b] of this.edges) {
      const dx = b.px-a.px, dy = b.py-a.py;
      const bend = b.type === 'topic' ? .23 : -.18;
      const kx = (a.px+b.px)/2-dy*bend, ky = (a.py+b.py)/2+dx*bend;
      const lit = b.branch || b.active;
      ctx.beginPath();
      ctx.moveTo(a.px,a.py);
      ctx.quadraticCurveTo(kx,ky,b.px,b.py);
      ctx.strokeStyle = b.tint;
      ctx.lineWidth = lit ? 1.95 : b.type === 'topic' ? 1.25 : .95;
      ctx.globalAlpha = lit ? .88 : .48;
      ctx.stroke();
      const progress = (t*(lit ? .15 : .085) + b.phase*.287)%1;
      const point = p => [(1-p)**2*a.px+2*(1-p)*p*kx+p*p*b.px,(1-p)**2*a.py+2*(1-p)*p*ky+p*p*b.py];
      if (!this.paused) {
        for (let i=4;i>=0;i--) {
          const p = progress-i*.012;
          if (p < 0) continue;
          const [x,y] = point(p);
          ctx.beginPath();
          ctx.arc(x,y,lit ? 2.75-i*.28 : 1.65-i*.16,0,2*Math.PI);
          ctx.fillStyle = b.tint;
          ctx.globalAlpha = (lit ? .95 : .62)*(1-i/5);
          ctx.fill();
        }
      }
    }
    ctx.globalAlpha = 1;
  }
}
