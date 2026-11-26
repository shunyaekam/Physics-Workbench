// Topic membership is declared on the map. Unassigned rows remain in the general notebook.
class AtlasFeed extends EventTarget {
  constructor() {
    super();
    this.roundArchive = new Map();
    this.rows = {questions:[], records:[], rounds:[]};
    this.state = 'loading';
    this.raw = 'https://raw.githubusercontent.com/shunyaekam/oo-research/research/';
  }
  async json(url) {
    const response = await fetch(url,{cache:'no-store',signal:AbortSignal.timeout(8000)});
    if (!response.ok) throw Error('Feed unavailable');
    return response.json();
  }
  notify() { this.dispatchEvent(new Event('change')); }
  set(feed,state) {
    if (feed.schema_version !== 1 || !Number.isFinite(Date.parse(feed.updated_at)) ||
        !Array.isArray(feed.problems) || !Array.isArray(feed.activity)) throw Error('Unrecognized notebook');
    this.state = state;
    this.timestamp = feed.updated_at;
    this.rows.questions = feed.problems;
    this.ids = new Set(feed.problems.map(q => q.id));
    this.rows.records = [...feed.activity].sort((a,b) => (Date.parse(b.updated_at)||0)-(Date.parse(a.updated_at)||0));
    const head = this.rows.records.find(r => /^round-\d+$/.test(r.id));
    this.rows.rounds = head ? [head,...this.history(head)] : [];
    this.notify();
    return head;
  }
  history(head) {
    const latest = Number(head.id.slice(6));
    return Array.from({length:7},(_,i)=>this.roundArchive.get(latest-i-1)).filter(Boolean);
  }
  owner(row) {
    if (this.ids?.has(row.problem_id)) return row.problem_id;
    if (row.id.startsWith('flow-') && this.ids?.has(row.id.slice(5))) return row.id.slice(5);
    return null;
  }
  async loadHistory(head) {
    const latest = Number(head.id.slice(6));
    const numbers = Array.from({length:8},(_,i)=>latest-i).filter(n=>n>0 && !this.roundArchive.has(n));
    await Promise.allSettled(numbers.map(async number=>{
      const path = 'campaign/rounds/' + String(number).padStart(8,'0') + '.json';
      const r = await this.json(this.raw+path);
      if (r.round !== number || !Array.isArray(r.quantum) || !Number.isFinite(Date.parse(r.utc))) return;
      const tested = r.quantum.reduce((sum,b) => sum + b.evaluated,0);
      if (!Number.isSafeInteger(tested) || tested < 0) return;
      const optics = (r.wigner || []).reduce((sum,b) => sum+b.states,0);
      const detail = tested.toLocaleString()+' Werner vectors evaluated' + (Number.isSafeInteger(optics) && optics>0 ? ' · '+optics.toLocaleString()+' optical states screened.' : '.');
      this.roundArchive.set(number,{id:'round-'+number,title:'Research round '+number,status:'completed',detail,updated_at:r.utc,url:'https://github.com/shunyaekam/oo-research/blob/research/'+path});
    }));
    this.rows.rounds = [{...head,...this.roundArchive.get(latest)},...this.history(head)];
    for (const n of this.roundArchive.keys()) if (n < latest-7) this.roundArchive.delete(n);
    this.notify();
  }
  async poll() {
    if (this.pending || document.hidden) return;
    this.pending = true;
    try {
      const head = this.set(await this.json(this.raw+'campaign/pipeline.json?poll='+Math.floor(Date.now()/60000)),'remote');
      if(head) await this.loadHistory(head);
    } catch {
      this.state = this.timestamp ? (this.state==='snapshot' ? 'snapshot':'offline') : 'unavailable';
      this.notify();
    } finally { this.pending = false; }
  }
  start() {
    this.json('pipeline/snapshot.json').then(feed=>{
      if (!this.timestamp) this.set(feed,'snapshot');
    }).catch(()=>{});
    this.poll();
    document.addEventListener('visibilitychange',()=>{if(!document.hidden)this.poll()});
    setInterval(()=>this.poll(),60000);
  }
}
