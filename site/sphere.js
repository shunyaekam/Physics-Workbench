(async () => {
 const canvasElement = document.getElementById('sphere');
 const response = await fetch(canvasElement.dataset.coordinates);
 if (!response.ok) throw new Error('coordinates unavailable');
 const data = await response.json();



const canvas=document.getElementById('sphere'), ctx=canvas.getContext('2d');
let selected='ours',lon=0,lat=0,drag=null;
function focusPair(){
 const conf=data[selected],a=conf.points[conf.pair[0]],b=conf.points[conf.pair[1]];
 lon=Math.atan2(a[1]+b[1],a[0]+b[0]);lat=Math.atan2(a[2]+b[2],Math.hypot(a[0]+b[0],a[1]+b[1]));draw();
}
function draw(){
 const width=canvas.clientWidth||400,px=Math.min(2,window.devicePixelRatio||1);
 if (!canvas.clientWidth) return;
 const size=Math.round(width*px);if(canvas.width!==size||canvas.height!==size){canvas.width=size;canvas.height=size;}
 ctx.setTransform(px,0,0,px,0,0);ctx.clearRect(0,0,width,width);
 const r=width*.44,c=width*.5,co=Math.cos(lon),si=Math.sin(lon),up=Math.sin(lat),flat=Math.cos(lat);
 const conf=data[selected],ap=conf.angle*Math.PI/360,rs=r*Math.sin(ap),ac=Math.cos(ap);
 const point=([x,y,z])=>[-si*x+co*y,-up*(co*x+si*y)+flat*z,flat*(co*x+si*y)+up*z];
 const dots=conf.points.map((v,i)=>({v:point(v),i})).sort((a,b)=>a.v[2]-b.v[2]);
 const shade=ctx.createRadialGradient(c-r*.36,c-r*.42,0,c,c,r);shade.addColorStop(0,'#fafafa');shade.addColorStop(.74,'#e8e8e8');shade.addColorStop(1,'#ababab');
 ctx.save();ctx.beginPath();ctx.arc(c,c,r,0,2*Math.PI);ctx.fillStyle=shade;ctx.fill();ctx.clip();
 for(const {v:[x,y,z],i} of dots){
  if(z<0)continue;
  const special=conf.pair.includes(i),trans=.13+.3*z;
  ctx.beginPath();ctx.ellipse(c+r*x*ac,c-r*y*ac,rs,Math.max(.03,rs*z),Math.atan2(x,y),0,2*Math.PI);
  ctx.fillStyle=special?'#5594e8':'rgba(62,62,62,'+trans+')';ctx.fill();
  ctx.lineWidth=Math.max(.5,width/760);ctx.strokeStyle=special?'#215194':'rgba(80,80,80,.4)';ctx.stroke();
  ctx.beginPath();ctx.arc(c+r*x,c-r*y,special?3.2:Math.max(.75,width/450),0,2*Math.PI);
  ctx.fillStyle=special?'#143963':'#606060';ctx.fill();
 }
 const [a,b]=conf.pair.map(i=>point(conf.points[i]));
 if(a[2]>0&&b[2]>0){ctx.beginPath();ctx.moveTo(c+r*a[0],c-r*a[1]);ctx.lineTo(c+r*b[0],c-r*b[1]);ctx.strokeStyle='#153f80';ctx.lineWidth=2;ctx.stroke();}
 ctx.restore();ctx.beginPath();ctx.arc(c,c,r,0,2*Math.PI);ctx.strokeStyle='#858585';ctx.lineWidth=1;ctx.stroke();
}
function choose(which){
 selected=which;const cfg=data[which];for(const id of ['ours','prior'])document.getElementById(id).setAttribute('aria-pressed',String(id===which));
 document.getElementById('angle').textContent=cfg.angle.toFixed(7)+'°';document.getElementById('pair').textContent='Centers '+(cfg.pair[0]+1)+' and '+(cfg.pair[1]+1);draw();
}
function turn(dx,dy){lon-=dx;lat=Math.max(-Math.PI/2+.001,Math.min(Math.PI/2-.001,lat+dy));draw();}
canvas.addEventListener('pointerdown',e=>{drag=[e.clientX,e.clientY];canvas.setPointerCapture(e.pointerId);});
canvas.addEventListener('pointermove',e=>{if(!drag)return;turn((e.clientX-drag[0])*.012,(e.clientY-drag[1])*.012);drag=[e.clientX,e.clientY];});
canvas.addEventListener('lostpointercapture',()=>drag=null);
canvas.addEventListener('keydown',e=>{const dirs={ArrowLeft:[-.13,0],ArrowRight:[.13,0],ArrowUp:[0,-.13],ArrowDown:[0,.13]};if(dirs[e.key]){e.preventDefault();turn(...dirs[e.key]);}});
document.getElementById('ours').onclick=()=>choose('ours');document.getElementById('prior').onclick=()=>choose('prior');document.getElementById('center').onclick=focusPair;
new ResizeObserver(draw).observe(canvas);choose('ours');focusPair();

})().catch(() => {
 const label = document.getElementById('pair');
 label.textContent = 'The coordinates could not be loaded.';
 for (const id of ['ours','prior','center']) document.getElementById(id).disabled = true;
});
