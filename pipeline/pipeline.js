'use strict';
const repo = 'https://github.com/shunyaekam/oo-research';
const research = repo + '/blob/research/';
const cinna = 'https://github.com/1337isnot1337/solved-conjectures';
const pub = cinna + '/blob/a51917c3fccb97c4a5c34537d5e2e4ad612f109e/';
const work = cinna + '/blob/31df82431bf2d04979544b6f5c249e2e0958c788/';
const bm = pub + 'results/brown-mol/';
const systems = {
  ours: [
    [['Scout','Find problems','The source index lists catalogue entries before screening. We trace each question to its authors, look for newer solutions, and rank the cheapest tests that could settle the question.','https://shunyaekam.github.io/oo-research/pipeline/indexed.html','Search the source index']],
    [['Solver','Build a witness','Hosted Codex can run mathematical experiments in a disposable workspace. Each witness goes to the registered checker. The next solver receives the measured outcome and an independent critique.',research+'ops/proof_flow.py','Solver and critic']],
    [['Math reviewer','Challenge the proof','A fresh-context critic challenges proposals. A separate mathematical review rederived our multimode result, including the constants and the mixed-state argument.',research+'checks/multimode-review.md','Math review'],['Priority reviewer','Check earlier work','Check alternate names and equivalent theorems. The weak multimode result follows from a classical Fourier inequality, so its derivation earns zero discovery credit.',research+'checks/multimode-priority.md','Priority decision']],
    [['Verifier','Replay evidence','For transport, the reviewer reconstructed the argument, then challenged the counting step on 125,664 directed cycles. Lean checks the lower bound for arbitrary chain lengths and a local step in the upper bound.',research+'checks/transport-review.md','Transport review']],
    [['Editor','Release solution','A fresh publication checkout reruns the exact checker. A decisive result with separate mathematical and prior-work reviews can publish automatically. The tracking issue closes after the public certificate is verified.',research+'ops/publish_checked.py','Release checks']]
  ],
  cinna: [
    [['Scout','Claim a problem','A research issue pins the exact conjecture and distinguishes nearby claims. Brown–Mol’s statement concerns roots for every tree.',cinna+'/issues/210','Assignment issue']],
    [['Combinatorics agent','Construct a tree','The solver built a family of trees with roots inside the proposed forbidden disk. One certified member suffices to refute the universal statement.',bm+'PROOF.md','Construction']],
    [['Analysis agent','Rederive the proof','The mathematical reviewer challenged the construction, estimates and finite witness. A coordinating review also compared the proof with the source.',bm+'ANALYSIS_REVIEW.md','Math review'],['Algebra agent','Audit priority','A separate reviewer checked previous results for the same claim. In the Kellner campaign this lane found an earlier solution by Matsuno and stopped the discovery claim.',work+'research/2026-11-21-combinatorics-kellner-excluded.md','Withdrawn claim']],
    [['Verifier','Check the witness','An exact checker certifies a root for a 1,001-vertex tree. We replayed the checker in the cloned repository and matched its recorded output.',bm+'check-output.json','Recorded certificate']],
    [['Coordinator','Publish and close','The reviewed package links proof, scope, independent checks and formalization status on main. The tracking issue records the handoff.',bm+'README.md','Result package']]
  ]
};
const boards = [
  ['certified','Certified solutions','Full answers replayed against the registered statement by the publication checker.'],
  ['kernel_steps','Checked lemmas','Lean-checked mathematical results with their precise scope.'],
  ['problems','Problems','The externally posed questions admitted to our solver queue.'],
  ['finite','Finite spin chains','Small chains are checked in full. Larger chains are checked within three flips of an arrangement from the paper. Each finished card links to exact energies and example arrangements.'],
  ['leads','Intake','Source leads awaiting admission. Several papers can mention the same problem.'],
  ['activity','Solving','Recent solver batches and AI handoffs. Each record links to the underlying calculation or transcript.'],
  ['candidates','Candidates','Search outputs flagged for a rigorous check.'],
  ['partial_results','Scoped results','Findings whose assumptions cover part of a parent question. Each record states what the evidence establishes.'],
  ['exclusions','Excluded','Correctness and originality are reviewed separately. These records explain why a claim earns zero discovery credit.'],
  ['solutions','Proposed solutions','The project records a proof covering the registered question after internal AI review. The linked audit states its scope and external review status.']
];
const empty = {
  certified:['No full machine-checked solution yet','The registered questions remain open or have written proposals under review. The Checked lemmas tab shows a narrower theorem you can replay today.'],
  candidates:['No candidate flagged','A positive numerical residual enters this queue for error-bounded verification.'],
  solutions:['No solutions in this feed','The manuscript catalogue and the scoped-results tab provide additional research records.']
};
const $ = id => document.getElementById(id);
function element(tag, text, cls) {
  const el = document.createElement(tag);
  if (text !== undefined) el.textContent = text;
  if (cls) el.className = cls;
  return el;
}
function link(label, url) {
  const a = element('a', label);
  if (typeof url === 'string' && url.startsWith('https://')) a.href = url.replace(
    /^https:\/\/shunyaekam\.github\.io\/oo-research\/papers\/([a-z0-9-]+)\.pdf$/, '../papers/$1/'
  );
  return a;
}
let system = 'ours', selected = [0,0], section = boards.some(([key])=>key===location.hash.slice(1)) ? location.hash.slice(1) : 'certified', feed;
function drawConnections() {
  const canvas = $('connections');
  const bounds = canvas.getBoundingClientRect();
  if (!bounds.width || !bounds.height) return;
  const scale = Math.min(window.devicePixelRatio || 1, 2);
  canvas.width = Math.round(bounds.width * scale);
  canvas.height = Math.round(bounds.height * scale);
  const ctx = canvas.getContext('2d');
  ctx.setTransform(scale, 0, 0, scale, 0, 0);
  ctx.strokeStyle = '#acacac';
  const vertical = matchMedia('(max-width:760px)').matches;
  const stations = [...$('tracks').children];
  for (let i = 1; i < stations.length; i++) {
    for (const from of stations[i - 1].children) {
      for (const to of stations[i].children) {
        const a = from.getBoundingClientRect(), b = to.getBoundingClientRect();
        const x = (vertical ? a.left + a.width / 2 : a.right) - bounds.left;
        const y = (vertical ? a.bottom : a.top + a.height / 2) - bounds.top;
        const u = (vertical ? b.left + b.width / 2 : b.left) - bounds.left;
        const v = (vertical ? b.top : b.top + b.height / 2) - bounds.top;
        ctx.beginPath();
        ctx.moveTo(x, y);
        if (vertical) ctx.bezierCurveTo(x, (y + v) / 2, u, (y + v) / 2, u, v);
        else ctx.bezierCurveTo((x + u) / 2, y, (x + u) / 2, v, u, v);
        ctx.stroke();
      }
    }
  }
}
new ResizeObserver(drawConnections).observe($('tracks'));

function map() {
  const stations = systems[system];
  $('ours').setAttribute('aria-pressed',system === 'ours');
  $('cinna').setAttribute('aria-pressed',system === 'cinna');
  $('tracks').replaceChildren();
  stations.forEach((stages,i) => {
    const station = element('div',undefined,'station');
    stages.forEach(([role,title],j) => {
      const button = element('button',undefined,'node');
      button.append(element('small',role),document.createTextNode(title));
      button.setAttribute('aria-pressed',i === selected[0] && j === selected[1]);
      button.onclick = () => {
        selected = [i,j];
        for (const other of $('tracks').querySelectorAll('button')) other.setAttribute('aria-pressed',other === button);
        inspect();
      };
      station.append(button);
    });
    $('tracks').append(station);
  });
  drawConnections();
  inspect();
  const branch = $('branch');
  branch.replaceChildren(element('span','If an earlier theorem settles the claim'));
  if (system === 'ours') {
    const button = element('button','View excluded claims');
    button.onclick = () => {
      if (!feed) return;
      section='exclusions'; updateRecords();
      $('board').scrollIntoView({block:'start'});
      $('filters').querySelector('[aria-pressed="true"]').focus({preventScroll:true});
    };
    button.disabled = !feed;
    branch.append(button);
  } else branch.append(link('Kellner exclusion record',work+'research/2026-11-21-combinatorics-kellner-excluded.md'));
}
function inspect() {
  const [,title,description,url,label] = systems[system][selected[0]][selected[1]];
  const box = element('div',undefined,'insinner');
  box.append(element('h3',title),element('p',description),link(label,url));
  $('inspector').replaceChildren(box);
}
for (const id of ['ours','cinna']) $(id).onclick = () => {system=id; selected=[0,0]; map();};
function record(item) {
  const card = element('article',undefined,'record');
  card.append(element('span',item.status === 'reviewed_resolution' ? 'Internally reviewed proof proposal' : item.status.replaceAll('_',' '),'status'),element('h3',item.title));
  card.append(element('p',item.question || item.detail));
  if (item.decisive_test) {
    const details = element('details');
    details.append(element('summary','What would settle it?'),element('p',item.decisive_test));
    card.append(details);
  }
  card.append(link(section === 'problems' || section === 'leads' || item.status === 'queued' ? 'Primary source' : 'Open evidence',item.url));
  if (item.receipt) card.append(link('Intake record',item.receipt));
  if (item.review_url) card.append(link('Math review',item.review_url));
  if (item.priority_url && item.priority_url !== item.url) card.append(link('Priority audit',item.priority_url));
  if (item.decision_url) card.append(link('Publication decision',item.decision_url));
  const shown = new Set([...card.querySelectorAll('a')].map(a => a.href));
  for (const [key,url] of Object.entries(item.evidence || {})) {
    if (!shown.has(url)) { card.append(link(key.replaceAll('_',' '),url)); shown.add(url); }
  }
  return card;
}
function updateRecords() {
  for (const button of $('filters').children) button.setAttribute('aria-pressed',button.dataset.key === section);
  const board = $('records');
  board.replaceChildren(element('p',boards.find(b=>b[0]===section)[2],'boardnote'));
  if (section==='finite') {
    const finished=feed.finite.filter(item=>item.status!=='queued').length;
    board.append(element('p',finished+' of '+feed.finite.length+' finite calculations finished.','boardnote'));
  }
  if (section==='activity') board.append(element('p','Each search reports its own unit. A circuit edit, a matrix pair, and a candidate optical state answer different questions.','boardnote'));
  if (feed[section].length) {
    const grid=element('div',undefined,'recordgrid');
    feed[section].forEach(item=>grid.append(record(item)));
    board.append(grid);
  } else {
    const box=element('div',undefined,'empty');
    const [title,desc]= empty[section] || ['No records yet','New evidence appears here when the worker records it.'];
    box.append(element('h3',title),element('p',desc));
    board.append(box);
  }
}
function render(data) {
  data={certified:[],kernel_steps:[],...data};
  if (!Array.isArray(data.finite)) data = {...data,finite:[]};
  if(data.schema_version !== 1 || !data.counts || !boards.every(([key])=>Array.isArray(data[key]))) throw new Error('Unsupported feed');
  feed=data;
  const branchButton = $('branch').querySelector('button');
  if(branchButton) branchButton.disabled=false;
  $('openCount').textContent=data.problems.filter(item => item.status === 'under_investigation').length;
  $('certifiedCount').textContent=data.certified.length;
  $('solvedCount').textContent=data.solutions.length;

  $('filters').replaceChildren();
  for(const [key,label] of boards) {
    const button=element('button',label);
    button.dataset.key=key;
    button.append(element('span',String(data[key].length),'num'));
    button.onclick=()=>{section=key;updateRecords();};
    $('filters').append(button);
  }
  updateRecords();
}
async function getFeed(url) {
  const controller=new AbortController();
  const timer=setTimeout(()=>controller.abort(),6000);
  try {
    const response=await fetch(url,{cache:'no-store',signal:controller.signal});
    if(!response.ok) throw new Error('Feed unavailable');
    return await response.json();
  } finally {clearTimeout(timer);}
}
const liveUrl='https://raw.githubusercontent.com/shunyaekam/oo-research/research/campaign/pipeline.json';
const pollMillis=60_000;
let loading=false;
function showFreshness(origin) {
  const time = new Date(feed.updated_at);
  const stale = Date.now() - time.getTime() > 30 * pollMillis;
  const checked = new Date().toLocaleTimeString([], {hour:'2-digit',minute:'2-digit'});
  $('fresh').textContent = origin+' · last batch '+time.toLocaleString()+
    (stale ? ' · over 30 minutes old' : '')+' · checked '+checked;
}
async function refresh() {
  if (loading) return;
  loading=true;
  $('refresh').disabled=true;
  try {
    if (!feed) {
      try {render(await getFeed('snapshot.json')); showFreshness('Saved snapshot');} catch { /* Try the live feed. */ }
    }
    const data = await getFeed(liveUrl+'?minute='+Math.floor(Date.now()/pollMillis));
    if (!Number.isFinite(Date.parse(data.updated_at))) throw new Error('Missing batch time');
    if (!feed || Date.parse(data.updated_at)>Date.parse(feed.updated_at)) render(data);
    if (data.updated_at===feed.updated_at) showFreshness('Connected');
    else showFreshness('Showing newer saved data');
  } catch {
    if (feed) showFreshness('Feed unavailable · showing saved data');
    else $('fresh').textContent='Campaign records unavailable. Retrying automatically.';
  } finally {loading=false; $('refresh').disabled=false;}
}
$('refresh').onclick=refresh;
$('viewFinite').onclick=()=>{section='finite'; if(feed) updateRecords();};
document.addEventListener('visibilitychange',()=>{if(!document.hidden) refresh();});
setInterval(()=>{if(!document.hidden) refresh();},pollMillis);
map();refresh();
