'use strict';

// The graph is built from the same subject and feed data used by the inspector.
const inks = ['#347fa1','#3a9087','#6879a6','#628b6b','#8473a5','#508caa','#9a795e','#657c82'];
function researchGraph(fields, selected) {
  const nodes = [{key:'notebook', type:'core', label:'Research', tint:'#4f7387'}];
  fields.forEach((field,index) => {
    const key = field.dataset.field, tint = inks[index % inks.length];
    nodes.push({key:'q-'+key,type:'topic',parent:'notebook',tint,label:field.querySelector('h2').textContent,title:field.querySelector('h2').textContent,group:'field',id:key,branch:selected===key});
    const papers = [...field.querySelectorAll('.paper')];
    papers.forEach(p => nodes.push({key:'p-'+p.id,type:'record',parent:'q-'+key,tint,title:p.querySelector('.read').textContent,group:'paper',id:p.id,active:location.hash==='#note/'+p.id || location.hash==='#'+p.id}));
    const work = fieldRecords(key,'records');
    if (work.length) nodes.push({key:'live-'+key,type:'record',parent:'q-'+key,tint,title:work.length+' published notebook records',group:'records',id:key,active:selected===key && (location.hash.startsWith('#field/') || location.hash==='#records' || location.hash==='#rounds')});
  });
  return nodes;
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
      this.motion.textContent = paused ? 'Resume flow' : 'Pause flow';
      document.body.classList.toggle('paused',paused);
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
  update(fields,selected) {
    const nodes = researchGraph(fields,selected);
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
      el.className = ['vertex',n.type,n.group === 'paper' ? 'paper-node' : '',n.branch ? 'branch' : '',n.active ? 'active' : ''].join(' ');
      el.dataset.key = n.key;
      el.style.setProperty('--tint',n.tint);
      if (core) {
        el.href = '#rounds';
        const img = document.createElement('img');
        img.src = 'site/assets/torus.png';
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
      el.title = core ? 'Open research notebook' : n.title;
      el.setAttribute('aria-label',el.title);
      if (n.label || n.type === 'record') {
        const label = document.createElement('span');
        label.className = 'label';
        label.textContent = n.label || n.title;
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
      if (w < 550) {
        const rows = Math.ceil(topics.length / 2);
        const side = i < rows ? -1 : 1, row = i % rows;
        Object.assign(n,{angle:side < 0 ? Math.PI : 0,x:cx+side*.31*w,y:h*(row+.5)/rows,phase:i+1});
      } else Object.assign(n,{angle, x:cx + .32*w*Math.cos(angle), y:cy + .32*h*Math.sin(angle),phase:i+1});
    });
    for (const parent of [root,...topics]) {
      const children = this.nodes.filter(n => n.type === 'record' && n.parent === parent.key);
      children.forEach((n,i) => {
        const spacing = Math.min(.97, 2*Math.PI/children.length);
        const angle = (parent.angle ?? -.78) + (i-(children.length-1)/2)*spacing;
        const rx = parent === root ? .18*w : Math.min(.12*w,100);
        const ry = parent === root ? .17*h : Math.min(.10*h,75);
        n.x = Math.max(22,Math.min(w-22,parent.x + rx*Math.cos(angle)));
        n.y = Math.max(31,Math.min(h-20,parent.y + ry*Math.sin(angle)));
        n.el.dataset.tooltipX = n.x < 100 ? 'left' : n.x > w-100 ? 'right' : 'center';
        n.el.dataset.tooltipY = n.y < 90 ? 'below' : 'above';
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
