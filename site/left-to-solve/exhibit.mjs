const body = document.body;
const spec = JSON.parse(document.getElementById('result-instrument').textContent);
const NS = 'http://www.w3.org/2000/svg';
const node = (name,attrs={}) => {
  const el = document.createElementNS(NS,name);
  for (const [key,value] of Object.entries(attrs)) el.setAttribute(key,value);
  return el;
};
function drawing(caption) {
  const svg = node('svg',{viewBox:'0 0 360 210',role:'img','aria-label':caption});
  return {
    svg,
    dot([cx,cy],type='point',r=4.2) {svg.append(node('circle',{cx,cy,r,class:type}));},
    line([x1,y1],[x2,y2],type='edge') {svg.append(node('line',{x1,y1,x2,y2,class:type}));}
  };
}
function drawGrid(d, frame) {
  const [w,h] = frame.grid;
  const scale = Math.min(58,260/Math.max(1,w-1),155/Math.max(1,h-1));
  const xy = (x,y) => [180+(x-(w-1)/2)*scale,105+(y-(h-1)/2)*scale];
  const start = frame.start || [0,0];
  for (let i=0;i<w;i++) for(let j=0;j<h;j++) {
    if(i+1<w)d.line(xy(i,j),xy(i+1,j));
    if(j+1<h)d.line(xy(i,j),xy(i,j+1));
  }
  const steps={L:[-1,0],R:[1,0],U:[0,-1],D:[0,1]};
  let [x,y]=start;
  for(const move of frame.trail) {
    const [dx,dy]=steps[move];d.line(xy(x,y),xy(x+dx,y+dy),'selected');
    x+=dx;y+=dy;
  }
  for(let i=0;i<w;i++)for(let j=0;j<h;j++)d.dot(xy(i,j));
  d.dot(xy(...start),'active');d.dot(xy(x,y),'active');
}
function drawDisk(d, mode) {
  const witness=[[-1,0],[-1,1],[-1,2],[0,1],[0,2],[1,1],[1,0],[2,0],[2,-1],[1,-1],[0,-1],[0,0]];
  const center=mode==='witness' ? [1/3,1/3] : [0,0];
  const norm=(x,y)=>x*x+x*y+y*y;
  const xy=([x,y])=>[180+45*((x-center[0])+(y-center[1])/2),105-45*(y-center[1])*Math.sqrt(3)/2];
  const r=mode==='nineteen'?2:mode==='witness'?Math.sqrt(7/3):Math.sqrt(3);
  const points=[];
  for(let x=-3;x<4;x++)for(let y=-3;y<4;y++)if(norm(x-center[0],y-center[1])<=r*r+1e-8)points.push([x,y]);
  d.svg.append(node('circle',{cx:180,cy:105,r:45*r,class:'boundary'}));
  for(let i=0;i<points.length;i++)for(const b of points.slice(i+1)){
    const a=points[i];
    if(norm(a[0]-b[0],a[1]-b[1])===1){
      const traced=mode==='forced'&&(norm(...a)===3||norm(...b)===3);
      d.line(xy(a),xy(b),traced?'selected':'edge');
    }
  }
  if(mode==='witness')witness.forEach((p,i)=>d.line(xy(p),xy(witness[(i+1)%12]),'selected'));
  points.forEach(p=>d.dot(xy(p),mode==='forced'&&!norm(...p)?'unvisited':'point'));
}
function display(area,frame){
  area.replaceChildren();
  if(frame.value || frame.pair){
    if(frame.value){const el=document.createElement('strong');el.className='equation';el.textContent=frame.value;area.append(el);}
    else for(const [label,value] of frame.pair){
      const item=document.createElement('div'),k=document.createElement('small'),v=document.createElement('strong');
      k.textContent=label;v.textContent=value;item.append(k,v);area.append(item);
    }
    return;
  }
  const d=drawing(frame.caption);
  if(frame.grid)drawGrid(d,frame);
  else if(frame.disk)drawDisk(d,frame.disk);
  else if(frame.matching){
    const p=Array.from({length:6},(_,i)=>[180+82*Math.cos(i*Math.PI/3),105+82*Math.sin(i*Math.PI/3)]);
    frame.matching.forEach(([i,j])=>d.line(p[i],p[j],'selected'));p.forEach(v=>d.dot(v,'point',6));
  }else if(frame.parity!==undefined){
    for(let i=-3;i<=3;i++)for(let j=-3;j<=3;j++){
      const selected=(i&1)===frame.parity&&(j&1)===frame.parity;
      d.dot([180+25*i,105+25*j],selected?'active':'faint',selected?5:3);
    }
  }else if(frame.pile){
    d.line([105,105],[255,105]);d.svg.append(node('circle',{cx:105,cy:105,r:22,class:'boundary'}));
    d.svg.append(node('circle',{cx:255,cy:105,r:31,class:'boundary'}));
    const spots=[[245,95],[265,95],[245,115],[265,115]];spots.slice(0,frame.pile).forEach(p=>d.dot(p,'active',6));
    for(const [x,label] of [[105,'sink'],[255,'active site']]){const t=node('text',{x,y:160,'text-anchor':'middle'});t.textContent=label;d.svg.append(t);}
  }
  area.append(d.svg);
}
function mount(area,controls,caption){
  const frames=spec.frames || [];
  if(!frames.length){
    const a=document.createElement('a');a.href='#evidence';a.textContent='View evidence ↗';controls.append(a);
    return;
  }
  const buttons=frames.map(frame=>{
    const b=document.createElement('button');b.type='button';b.textContent=frame.label;controls.append(b);return b;
  });
  function show(i){
    display(area,frames[i]);caption.textContent=frames[i].caption;
    buttons.forEach((b,j)=>b.setAttribute('aria-pressed',String(j===i)));
  }
  buttons.forEach((b,i)=>b.addEventListener('click',()=>show(i)));
  show(0);
}
const story=document.querySelector('.story');
export const exhibits={[body.dataset.paper]:{title:spec.headline||story.querySelector('h1').textContent,lead:spec.summary,scope:spec.scope||'',mount}};
async function refreshReviews() {
  for(const record of document.querySelectorAll('[data-review]')){
    try{
      const base='https://api.github.com/repos/GuillaumeBAUD-coder/open-math-agents/pulls';
      const response=await fetch(base+'/'+record.dataset.review,{signal:AbortSignal.timeout(5000)});
      if(!response.ok)continue;
      const pr=await response.json(),kind=record.dataset.kind;
      record.querySelector('span').textContent=pr.merged_at?(kind==='step'?'Step proof':kind)+' merged':pr.state==='closed'?'Closed · see upstream review':(pr.head.sha===record.dataset.head||pr.labels.some(l=>l.name==='needs-human-review'))?'Checker passed · maintainer review':'Open · see upstream checker';
      if(pr.merged_at&&kind==='Statement'&&body.dataset.followup){
        const head='shunyaekam:oo-'+body.dataset.followup+'-'+body.dataset.contribution;
        const candidate=await fetch(base+'?'+new URLSearchParams({head,state:'all'}),{signal:AbortSignal.timeout(5000)});
        if(!candidate.ok)continue;
        const [proof]=await candidate.json();if(!proof)continue;
        const link=document.createElement('a');link.href='https://github.com/GuillaumeBAUD-coder/open-math-agents/pull/'+proof.number;link.textContent=(proof.merged_at?'Proof merged':'Proof review')+' · #'+proof.number;record.append(' ',link);
      }
    }catch{/* Static records and source links remain available offline. */}
  }
}
refreshReviews();
