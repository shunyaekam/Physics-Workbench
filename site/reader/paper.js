(() => {
  const reader = document.getElementById('reader');
  const article = document.getElementById('text');
  const previous = document.getElementById('previous');
  const next = document.getElementById('next');
  const menu = document.getElementById('sections');
  let current = 0, pages = 1, stride = 1;

  for (const element of article.querySelectorAll('math[display=block], table')) {
    const box = document.createElement(element.matches('table') ? 'div' : 'span');
    box.className = element.matches('table') ? 'table-box' : 'math-box';
    box.style.display = 'block';
    element.replaceWith(box);
    box.append(element);
  }
  const tables = [...article.querySelectorAll('.table-box')].map(box => ({
    box, table: box.firstElementChild, pieces: []
  }));
  const inlineMath = [...article.querySelectorAll('math[display=inline]')];
  function fitWideContent() {
    for (const formula of inlineMath) {
      if (formula.getBoundingClientRect().width <= reader.clientWidth || formula.parentNode.classList.contains('wide-inline')) continue;
      const box = document.createElement('span');
      box.className = 'wide-inline';
      formula.replaceWith(box);
      box.append(formula);
    }
    for (const entry of tables) {
      const {box, table, pieces} = entry;
      pieces.splice(0).forEach(piece => piece.remove());
      box.replaceChildren(table);
      if (table.getBoundingClientRect().height <= reader.clientHeight) continue;
      const rows = [...table.tBodies].flatMap(body => [...body.rows]);
      let part, body, lastBox = box;
      for (const row of rows) {
        if (!part) {
          part = table.cloneNode(false);
          if (table.tHead) part.append(table.tHead.cloneNode(true));
          body = part.createTBody();
          lastBox.replaceChildren(part);
        }
        const copy = row.cloneNode(true);
        body.append(copy);
        if (body.rows.length > 1 && part.getBoundingClientRect().height > reader.clientHeight - 20) {
          copy.remove();
          const following = box.cloneNode(false);
          lastBox.after(following); lastBox = following;
          pieces.push(following);
          part = part.cloneNode(false);
          if (table.tHead) part.append(table.tHead.cloneNode(true));
          body = part.createTBody(); body.append(copy); following.append(part);
        }
      }
    }
  }
  document.body.classList.add('paged');
  document.querySelector('.reader-foot').hidden = false;
  document.getElementById('contents').hidden = false;
  reader.tabIndex = 0;
  function go(index) {
    current = Math.min(Math.max(index, 0), pages - 1);
    reader.scrollLeft = current * stride;
    previous.disabled = current === 0;
    next.disabled = current === pages - 1;
    document.getElementById('page').textContent = (current + 1) + ' / ' + pages;
  }
  function measure() {
    fitWideContent();
    stride = article.clientWidth + parseFloat(getComputedStyle(article).columnGap);
    pages = Math.max(1, Math.ceil((article.scrollWidth - 1 + parseFloat(getComputedStyle(article).columnGap)) / stride));
    go(current);
  }
  function goToElement(element) {
    const left = element.getClientRects()[0]?.left;
    if (left === undefined) return;
    go(Math.floor((left - reader.getBoundingClientRect().left + reader.scrollLeft + 1) / stride));
  }
  function followHash() {
    let target;
    try { target = document.getElementById(decodeURIComponent(location.hash.slice(1))); } catch {}
    if (target && article.contains(target)) goToElement(target);
  }
  for (const heading of article.querySelectorAll('h2[id],h3[id],h4[id],h5[id]')) {
    const link = document.createElement('a');
    link.href = '#' + encodeURIComponent(heading.id);
    link.textContent = heading.innerText;
    menu.querySelector('nav').append(link);
  }
  document.getElementById('contents').onclick = () => menu.showModal();
  menu.addEventListener('click', e => {
    const link = e.target.closest('a');
    if (link) {menu.close(); goToElement(document.getElementById(decodeURIComponent(link.hash.slice(1))));}
  });
  previous.onclick = () => go(current - 1);
  next.onclick = () => go(current + 1);
  document.addEventListener('keydown', e => {
    if (e.defaultPrevented || document.querySelector('dialog[open]') || e.altKey || e.ctrlKey || e.metaKey || e.shiftKey || e.target.closest('.table-box,.math-box')) return;
    if (['ArrowRight','PageDown','ArrowLeft','PageUp'].includes(e.key)) {
      e.preventDefault(); go(current + (['ArrowRight','PageDown'].includes(e.key) ? 1 : -1));
    }
  });
  reader.addEventListener('focusin', e => { if (e.target !== reader) goToElement(e.target); });
  window.addEventListener('hashchange', followHash);
  new ResizeObserver(measure).observe(reader);
  measure();
  document.fonts.ready.then(() => { measure();followHash(); });
})();
