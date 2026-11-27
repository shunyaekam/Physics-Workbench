// Phase-space coordinates and normalizations follow the individual manuscripts.
const ink = '#25323b', blue = '#486e8c', light = '#dce6ed', gray = '#5a6770', line = '#b6c4cd';
const ns = 'http://www.w3.org/2000/svg';

function mark(parent, tag, attributes, text) {
  const el = document.createElementNS(ns, tag);
  for (const [key, value] of Object.entries(attributes)) el.setAttribute(key, value);
  if (text !== undefined) el.textContent = text;
  parent.append(el);
  return el;
}
function scene(figure, description) {
  figure.replaceChildren();
  const svg = mark(figure, 'svg', {viewBox:'0 0 450 230', role:'img', 'aria-label':description});
  svg.style.cssText = 'display:block;width:100%;height:100%;max-height:250px';
  return svg;
}
function label(svg,x,y,text,size=15,color=ink,anchor='start') {
  return mark(svg,'text',{x,y,fill:color,'font-family':'Play, sans-serif','font-size':size,'text-anchor':anchor},text);
}
function rule(svg,x1,y1,x2,y2,stroke=line,width=1) {
  return mark(svg,'line',{x1,y1,x2,y2,stroke,'stroke-width':width});
}
function choices(controls, name, labels, initial, draw) {
  const group = document.createElement('span');
  group.setAttribute('role','group');
  group.setAttribute('aria-label',name);
  group.style.cssText = 'display:inline-flex;gap:.75em;align-items:center;flex-wrap:wrap';
  const buttons = labels.map((text,i) => {
    const button = document.createElement('button');
    button.type = 'button'; button.textContent = text;
    button.addEventListener('click',() => select(i));
    group.append(button);
    return button;
  });
  controls.append(group);
  function select(index) {
    buttons.forEach((button,i) => {
      button.setAttribute('aria-pressed',String(i===index));
      button.style.textDecoration = i===index ? 'underline' : 'none';
      button.style.textUnderlineOffset = '.25em';
    });
    draw(index);
  }
  select(initial);
}
function integrate(fn, high, steps) {
  const h=high/steps;
  let total=fn(0)+fn(high);
  for(let j=1;j<steps;j++) total+=(j%2?4:2)*fn(j*h);
  return total*h/3;
}

// For b=0 or 1, the rapidly converging Poisson/gamma representation in
// "One random radius" gives the displayed norms to the shown precision.
function qubitNorms(b) {
  if (b === Infinity) return [1,1];
  const t=b*b/2;
  let poisson=Math.exp(-t), gammaMean=Math.sqrt(Math.PI/2), factorial=1, mean=0, deficit=0;
  for (let k=0;k<20;k++) {
    mean+=poisson*gammaMean;
    deficit+=poisson*integrate(s=>(1-2*s)*Math.exp(-s)*s**k/factorial,.5,64);
    gammaMean*=(1.5+k)/(k+1);
    factorial*=k+1;
    poisson*=t/(k+1);
  }
  return [1+2*deficit/(1+b*b),mean*mean/(1+b*b)];
}

function qubit(figure,controls,caption) {
  choices(controls,'State',['Vacuum','Equal amplitudes','One photon'],1,i=>{
    const b=[Infinity,1,0][i], [wigner,husimi]=qubitNorms(b);
    const svg=scene(figure,'Wigner distribution in the coherent-amplitude plane. Blue marks negative values. Wigner norm '+wigner.toFixed(3)+', Husimi bound '+husimi.toFixed(3)+'.');
    const canvas=document.createElement('canvas'), N=230, extent=1.7;
    canvas.width=canvas.height=N;
    const ctx=canvas.getContext('2d'), raster=ctx.createImageData(N,N);
    for(let y=0;y<N;y++) for(let x=0;x<N;x++){
      const re=extent*(2*(x+.5)/N-1),im=extent*(1-2*(y+.5)/N);
      const value=Math.exp(-2*(re*re+im*im))*(i===0 ? 1 : ((b+2*re)**2+4*im*im-1)/(1+b*b));
      const pigment=value<0 ? [58,101,137] : [44,52,59], opacity=Math.sqrt(Math.abs(value));
      const pos=4*(y*N+x);
      for(let c=0;c<3;c++)raster.data[pos+c]=255-(255-pigment[c])*opacity;
      raster.data[pos+3]=255;
    }
    ctx.putImageData(raster,0,0);
    mark(svg,'image',{x:14,y:2,width:208,height:208,href:canvas.toDataURL()});
    if(i!==0) mark(svg,'circle',{cx:118-(b/2)*104/extent,cy:106,r:.5*104/extent,stroke:blue,'stroke-width':1.2,fill:'none'});
    label(svg,118,226,'Wigner distribution',15,gray,'middle');
    label(svg,250,56,'Wigner norm',15,gray); label(svg,250,87,wigner.toFixed(3),32,ink);
    label(svg,250,130,'Husimi bound',15,gray); label(svg,250,161,husimi.toFixed(3),32,blue);
    caption.textContent=['Vacuum has no negative region. Both quantities equal one.','Blue marks the negative region. With equal vacuum and one-photon amplitudes it shifts away from the origin.','One photon puts the negative region at the center. Its Wigner norm remains below the Husimi bound.'][i];
  });
}

function laguerre(n,x) {
  if(n===0)return 1;
  let prev=1,cur=1-x;
  for(let k=1;k<n;k++){const next=((2*k+1-x)*cur-k*prev)/(k+1);prev=cur;cur=next;}
  return cur;
}
function numberNorms(n) {
  const norm = n===0 ? 1 : n===1 ? 4*Math.exp(-.5)-1 :
    integrate(u=>.5*Math.exp(-u/2)*Math.abs(laguerre(n,u)),120,36000);
  let bound=n%2===0 ? 1 : Math.PI/2;
  for(let k=n%2;k<n;k+=2)bound*=(k+2)/(k+1);
  return [norm,bound];
}
function numberState(figure,controls,caption) {
  const counts=[0,1,2,5];
  choices(controls,'Photon number',counts.map(n=>n+' photon'+(n===1?'':'s')),1,i=>{
    const n=counts[i], [norm,bound]=numberNorms(n);
    const svg=scene(figure,'Signed radial Wigner profile for '+n+' photons. Blue area below zero marks negative Wigner density.');
    const x=r=>44+86*r, y=v=>107-78*v, points=[];
    rule(svg,x(0),y(-1),x(0),y(1));rule(svg,x(0),y(0),x(4.5),y(0));
    for(const v of [-1,0,1])label(svg,34,y(v)+4,String(v),13,gray,'end');
    for(let r=0;r<=4;r++){rule(svg,x(r),y(0),x(r),y(0)+4);label(svg,x(r),203,String(r),14,gray,'middle');}
    for(let j=0;j<=400;j++){
      const r=4.5*j/400;
      const val=(-1)**n*Math.exp(-r*r)*laguerre(n,2*r*r);
      points.push([x(r),y(val)]);
    }
    const pt=([a,b])=>a.toFixed(2)+','+b.toFixed(2);
    const under=points.map(([a,b])=>[a,Math.max(y(0),b)]);
    mark(svg,'path',{d:'M'+pt([x(0),y(0)])+' L'+under.map(pt).join(' L')+' Z',fill:light});
    mark(svg,'path',{d:'M'+points.map(pt).join(' L'),fill:'none',stroke:ink,'stroke-width':2.5,'stroke-linejoin':'round'});
    label(svg,44,18,'π W(r)',15);label(svg,236,225,'Distance from the origin, r',15,gray,'middle');
    caption.textContent=n===0?'Vacuum stays positive at every radius. Its Wigner norm and Husimi bound both equal one.':
      n+' photon'+(n===1?'':'s')+' · Wigner norm ≈ '+norm.toFixed(3)+', Husimi bound ≈ '+bound.toFixed(3)+'. Shading marks negative density.';
  });
}

// The only zero-level pairs included here are 0–1 from the single-rail paper
// and 0–2 through 0–5 from this paper. Other marks follow sparse-certified.tex.
const coveredMax = [0,0,1,2,3,4,5,6,3];
function pairGrid(figure,controls,caption) {
  const labels=['All pairs','Vacuum pairs','Excited pairs'];
  choices(controls,'Show certified level pairs',labels,0,i=>{
    const svg=scene(figure,'Certified two-level subspaces. Rows show the smaller photon count, columns the larger one. '+labels[i]+'.');
    label(svg,250,19,'Larger photon count',16,gray,'middle');
    label(svg,13,57,'Smaller',14,gray);label(svg,13,74,'count',14,gray);
    for(let n=1;n<=8;n++)label(svg,103+40*(n-1),43,String(n),14,gray,'middle');
    for(let m=0;m<=7;m++){
      const y=61+21*m;
      label(svg,77,y+5,String(m),14,gray,'end');
      for(let n=m+1;n<=8;n++){
        const x=103+40*(n-1);
        const covered=m===0 ? n<=5 : m<=coveredMax[n];
        const shown=covered && (i===0 || (i===1 ? m===0 : m>0));
        mark(svg,'circle',{cx:x,cy:y,r:shown?6.7:3.1,fill:shown?blue:'white',stroke:shown?blue:line,'stroke-width':1.2});
      }
    }
    caption.textContent=['Filled dots show certified pairs: five with vacuum and 24 with two excited levels.','Vacuum paired with one through five photons is covered, including the separate single-rail result for one photon.','Both amplitude orderings are certified for 24 pairs of excited levels. The highest displayed pair is three and eight.'][i];
  });
}
function orders(figure,controls,caption) {
  const cutoff=.288703;
  const markers=[.2,.4,.75], cuts=[0,cutoff,.5,1], x=a=>23+393*a;
  choices(controls,'Explore an entropy order',['Order 0.20','Order 0.40','Order 0.75'],1,i=>{
    const a=markers[i],svg=scene(figure,'Entropy-order axis. A single photon rules out orders below about 0.288703 and dilute superpositions rule out every fixed order above one half.');
    label(svg,23,29,'Husimi entropy order',16,gray);
    for(let j=0;j<3;j++)rule(svg,x(cuts[j]),115,x(cuts[j+1]),115,j===1?blue:'#aab7bf',j===1?7:2);
    mark(svg,'path',{d:'M415 111l8 4-8 4',stroke:gray,fill:'none','stroke-width':1.5});
    for(const [v,t] of [[0,'0'],[cutoff,'0.288703…'],[.5,'½'],[1,'1']]){
      rule(svg,x(v),110,x(v),122,gray);label(svg,x(v),142,t,14,gray,'middle');
    }
    rule(svg,x(a),68,x(a),106,blue,1.5);
    mark(svg,'circle',{cx:x(a),cy:115,r:5.5,fill:ink});label(svg,x(a),61,a.toFixed(2),25,ink,'middle');
    const regions=[['One photon','rules it out'],['Open'],['Dilute states','rule it out']];
    for(let j=0;j<3;j++){
      const cx=x((cuts[j]+cuts[j+1])/2);
      regions[j].forEach((word,k)=>label(svg,cx,171+18*k,word,14,i===j?ink:gray,'middle'));
    }
    caption.textContent=['A single photon already breaks the proposed entropy bound at this order.','This order works for optical qubits and for number-diagonal mixtures through 144 photons. Other states remain open.','At every fixed order above one half, a sufficiently dilute superposition violates the bound, even with arbitrarily little mean energy.'][i];
  });
}

export const exhibits={
  'single-rail-wigner':{title:'How negative can one optical qubit be?',lead:'In a superposition of vacuum and one photon, the Wigner distribution can dip below zero. A heterodyne measurement bounds the total negative volume.',scope:'The bound holds for all mixtures and superpositions of zero and one photon. Only vacuum reaches equality in this subspace.',mount:qubit},
  'phase-invariant-wigner':{title:'A bound at every photon count',lead:'A light field with no preferred phase can have rings of negative Wigner density. Its heterodyne distribution bounds their total negative volume.',scope:'This holds for every mixture of photon-number states, with no upper photon cutoff. Finite equality occurs only for vacuum.',mount:numberState},
  'sparse-fock-coherence':{title:'Which photon pairs are covered?',lead:'Pick any two photon counts from zero through five. Even a coherent superposition of that pair obeys the proposed bound on Wigner negativity.',scope:'The same holds for mixtures of these pairs. A violation within levels zero through five would require coherence across at least three levels.',mount:pairGrid},
  'renyi-obstructions':{title:'Where can the entropy bound survive?',lead:'Changing the entropy order changes which features of light count most. A single photon rules out low orders. Light close to vacuum rules out high orders.',scope:'The surviving interval runs from about 0.288703 to ½. A proof for unrestricted light inside it remains open.',mount:orders}
};
