(async () => {
  const reading = document.getElementById('method-reading');
  const select = document.getElementById('method-problem');
  try {
    const url = 'https://raw.githubusercontent.com/shunyaekam/oo-research/research/campaign/method-summary.json';
    const response = await fetch(url, {cache: 'no-cache'});
    if (!response.ok) throw new Error('Feed unavailable');
    const {problems, comparison} = await response.json();
    if (comparison) {
      document.getElementById('method-experiment').textContent =
        'Golay encoder · ' + comparison.week + '. Best of ' + comparison.circuits + ' checked circuits: ' +
        comparison.best + ' CNOTs. Target: ' + comparison.target + '. ' +
        (comparison.changed ? 'Challenger advanced.' : 'Existing method retained.');
    }
    if (!problems.length) {
      reading.textContent = 'Awaiting the first instrumented worker run.';
      return;
    }
    for (const row of problems) select.add(new Option(row.problem, row.problem));
    document.getElementById('method-picker').hidden = false;
    const render = () => {
      const row = problems[select.selectedIndex];
      const usage = row.coverage === '—' ? 'No hosted calls recorded.' :
        'Input / output tokens: ' + row.tokens + '. Complete usage for ' + row.coverage + ' hosted calls.';
      reading.textContent = row.runs + (row.runs === 1 ? ' run' : ' runs') + ' · ' + row.seconds +
        ' measured seconds. ' + usage + ' Latest: ' + [row.stage, row.outcome].join(' · ').replaceAll('_', ' ') + '.';
    };
    select.addEventListener('change', render);
    render();
  } catch {
    reading.textContent = 'Live measurements are unavailable. The linked ledger contains the last published results.';
  }
})();
