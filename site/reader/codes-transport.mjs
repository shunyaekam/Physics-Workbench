// Pauli strings are in the site order and row order of the two manuscripts.
const twelve = {
  3: ['ZIIYIYIXYIIZ','IIYIYXIIXYXI','ZIIZIXIZIIXY','XXYIZIIYYIII','XIIXIZZYIXII','IYYIIZIZIYYI','IIIIZXIZXXIY','XZZIIXYIIIZI','IYZZZXZIIIII'],
  4: ['IIIIIIYYZZXX','ZZZZZZIIIIII','ZXXXIXXIXIII','XIXIYXIZZIIY','IIYXXXZZIIXI','XXIZXXIIIIYZ','IYIIIXZYXIYY','XZXXXIIXIXII']
};
const eleven = ['YYZIZIIYZIX','IXYIIXXIYYY','YIYXYIZIYIZ','YZIIZIIZYXY','ZXZXZZXIIII','ZIZZIIYYIZZ'];
const blue = '#335f79', ink = '#28333b', gray = '#52616a', line = '#b6c5cd';
const ns = 'http://www.w3.org/2000/svg';

function mark(svg, tag, attrs, text) {
  const node = document.createElementNS(ns, tag);
  for (const [key,value] of Object.entries(attrs)) node.setAttribute(key, value);
  if (text!==undefined) node.textContent=text;
  svg.append(node);
  return node;
}
function scene(figure, description) {
  const svg = document.createElementNS(ns,'svg');
  svg.setAttribute('viewBox','0 0 430 209');
  svg.setAttribute('role','img');
  svg.setAttribute('aria-label',description);
  svg.style.cssText='display:block;width:100%;height:100%;max-height:250px';
  figure.replaceChildren(svg);
  return svg;
}
function label(svg, x, y, text, size=16, align='middle', fill=ink) {
  return mark(svg,'text',{x,y,'font-family':'Play, sans-serif','font-size':size,'text-anchor':align,fill},text);
}
function wire(svg, x1, y1, x2, y2, color=line) {
  mark(svg,'line',{x1,y1,x2,y2,stroke:color,'stroke-width':1.3});
}
function select(controls, name, values, initial) {
  const wrapper=document.createElement('label');
  wrapper.append(document.createTextNode(name+' '));
  const input=document.createElement('select');
  for(const [value,text] of values)input.add(new Option(text,String(value)));
  input.value=String(initial);
  wrapper.append(input); controls.append(wrapper);
  return input;
}
function fraction(a,b) {
  let x=a,y=b;
  while(y){const r=x%y;x=y;y=r;}
  return b/x===1 ? String(a/x) : (a/x)+'/'+(b/x);
}
const weight = row => [...row].filter(p=>p!=='I').length;

function mountTwelve(figure, controls, caption) {
  const stored=select(controls,'Logical qubits',[[3,'3'],[4,'4']],4);
  const index=select(controls,'Check',[],0);
  function draw(){
    const rows=twelve[stored.value], selected=Number(index.value), row=rows[selected], w=weight(row);
    const svg=scene(figure,'Check '+(selected+1)+', '+row+', touches '+w+' of twelve qubits.');
    label(svg,16,28,'Physical qubit',16,'start',gray);
    for(const [i,p] of [...row].entries()){
      const x=27+i*34;
      label(svg,x,58,i+1,14);
      mark(svg,'rect',{x:x-14,y:69,width:28,height:33,rx:4,stroke:p==='I'?line:blue,fill:p==='I'?'white':blue});
      label(svg,x,92,p==='I'?'·':p,21,'middle',p==='I'?gray:'white');
    }
    label(svg,16,142,'Qubits touched by each check',16,'start',gray);
    for(const [i,r] of rows.entries()){
      const x=29+i*41,active=i===selected;
      mark(svg,'circle',{cx:x,cy:169,r:13,stroke:active?blue:line,fill:active?blue:'white'});
      label(svg,x,175,weight(r),17,'middle',active?'white':ink);
    }
    caption.textContent='Check '+(selected+1)+' touches '+w+' qubits. Letters give the measured Pauli operators. A dot means that qubit sits out.';
  }
  function chooseCode(){
    const rows=twelve[stored.value],weights=rows.map(weight);
    index.replaceChildren(...rows.map((_,i)=>new Option(String(i+1),String(i))));
    index.value=String(weights.indexOf(Math.max(...weights)));draw();
  }
  stored.onchange=chooseCode;index.onchange=draw;chooseCode();
}
function mountEleven(figure, controls, caption) {
  const site=select(controls,'Qubit',Array.from({length:11},(_,i)=>[i+1,i+1]),1);
  const error=select(controls,'Error',['X','Y','Z'].map(p=>[p,p]),'X');
  function draw(){
    const pos=Number(site.value)-1,p=error.value;
    const local=eleven.map(row=>row[pos]),flips=local.map(q=>q!=='I' && q!==p);
    const svg=scene(figure,p+' error on qubit '+(pos+1)+'. Check outcomes from one through six: '+flips.map(b=>b?'flipped':'unchanged').join(', ')+'.');
    label(svg,16,25,'One error on eleven qubits',16,'start',gray);
    wire(svg,27,55,397,55);
    for(let i=0;i<11;i++){
      const x=27+37*i,active=i===pos;
      mark(svg,'circle',{cx:x,cy:55,r:active?13:6,stroke:active?blue:line,fill:active?blue:'white'});
      if(active)label(svg,x,61,p,16,'middle','white');
      label(svg,x,87,i+1,14);
    }
    label(svg,16,120,'Which checks flip?',16,'start',gray);
    for(const [i,flip] of flips.entries()){
      const x=42+i*69;
      mark(svg,'rect',{x:x-22,y:132,width:44,height:33,rx:4,stroke:flip?blue:line,fill:flip?blue:'white'});
      label(svg,x,155,flip?'−':'+',23,'middle',flip?'white':ink);
      label(svg,x,189,'C'+(i+1),15);
    }
    const count=flips.filter(Boolean).length;
    caption.textContent='A '+p+' error on qubit '+(pos+1)+' flips '+count+' of six checks. The pattern of pluses and minuses identifies this error.';
  }
  site.onchange=draw;error.onchange=draw;draw();
}
function mountTransport(figure, controls, caption) {
  // Every increasing chain on these five levels with both endpoints present.
  const chains=Array.from({length:8},(_,mask)=>[0,...[1,2,3].filter(x=>mask & (1<<(x-1))),4]);
  const menu=select(controls,'Route',chains.map((chain,i)=>[i,chain.join(' → ')]),2);
  function draw(){
    const chain=chains[Number(menu.value)], costs=chain.slice(1).map((b,i)=>(b-chain[i])**2);
    const via=costs.reduce((total,x)=>total+x,0), bound=fraction(16-via,chain.length);
    const svg=scene(figure,'Levels zero through four. Direct squared cost sixteen. Via '+chain.join(', ')+', cost '+via+' and chain error bound '+bound+'.');
    const x = v=>37+v*89;
    label(svg,16,27,'Squared energy gaps',16,'start',gray);
    mark(svg,'path',{d:'M37 110 Q215 -13 393 110',fill:'none',stroke:line,'stroke-width':2});
    label(svg,215,44,'Direct cost 16',16,'middle',gray);
    wire(svg,x(0),111,x(4),111);
    for(const [i,cost] of costs.entries()){
      const a=x(chain[i]),b=x(chain[i+1]);
      mark(svg,'path',{d:'M'+a+' 111 Q'+(a+b)/2+' 181 '+b+' 111',fill:'none',stroke:blue,'stroke-width':2.6});
      label(svg,(a+b)/2,166,cost,16,'middle',blue);
    }
    for(let level=0;level<=4;level++){
      const used=chain.includes(level);
      mark(svg,'circle',{cx:x(level),cy:111,r:used?7:4,stroke:used?blue:line,fill:used?blue:'white'});
      label(svg,x(level),96,level,16);
    }
    label(svg,215,199,'Route cost '+via+'   ·   Error bound '+bound,18);
    caption.textContent=bound==='8/3'?'This route gives the largest bound, (16 − 8) / 3 = 8/3. The paper constructs labels that attain this error.':'Compare the direct cost with the sum along this route. The gap, divided by the '+chain.length+' visited levels, gives '+bound+'.';
  }
  menu.onchange=draw;draw();
}
export const exhibits = {
  'distance-four':{
    title:'How many qubits must a check touch?',
    lead:'Twelve physical qubits can store three logical qubits with checks touching at most six sites. Storing a fourth at the same distance raises that minimum to seven.',
    scope:'The paper proves both optima for binary stabilizer codes of distance four and settles the ten-qubit, two-logical-qubit case at six.',
    mount:mountTwelve
  },
  'eleven-five':{
    title:'Six checks identify a single error',
    lead:'Eleven physical qubits can protect five logical qubits from a single error. Even the best choice of checks needs at least one measurement spanning seven sites.',
    scope:'This is a counting proof of an optimum previously established by Jing and Tu for binary stabilizer codes.',
    mount:mountEleven
  },
  'transport-polygon':{
    title:'One route sets the error floor',
    lead:'With squared energy gaps, going straight from level 0 to level 4 costs 16, while going through level 2 costs 8. That mismatch forces a minimum error when fitting costs to distances on a line.',
    scope:'For a finite energy spectrum, source powers q ≥ 1 and target powers 0 < p ≤ 1, the strongest chain bound equals the best possible uniform error.',
    mount:mountTransport
  }
};
