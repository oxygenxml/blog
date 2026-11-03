#!/usr/bin/env node
// Usage: check-layout.cjs [--margin=10] <svg>...
// Measures each figure in Chrome and reports what is easy to miss by eye:
//  - shapes or text closer than --margin px (stroke included) to the canvas edge (a stroke on the edge gets half clipped),
//  - text sitting on, or within 6 px of, the border of an outline box (fill="none", e.g. a dashed product box),
//  - text overlapping other text.
// Exit code 1 when something is found.
const path = require('path');
const { chromium } = require(path.join(require('child_process').execSync('npm root -g').toString().trim(), 'playwright'));

const args = process.argv.slice(2);
const margin = +((args.find(a => a.startsWith('--margin=')) || '--margin=10').split('=')[1]);
const files = args.filter(a => !a.startsWith('--'));
if (files.length === 0) {
  console.error('Usage: check-layout.cjs [--margin=10] <svg>...');
  process.exit(2);
}

(async () => {
  const browser = await chromium.launch({ channel: 'chrome' });
  const page = await browser.newPage();
  let problems = 0;
  for (const f of files) {
    await page.goto('file://' + path.resolve(f));
    const found = await page.evaluate((margin) => {
      const root = document.documentElement;
      const vb = root.viewBox.baseVal;
      const out = [];
      const box = (e) => {
        const b = e.getBBox();
        const m = e.getCTM();
        const sw = e.tagName === 'text' ? 0 : (parseFloat(e.getAttribute('stroke-width')) || 0) / 2;
        return { x1: b.x * m.a + m.e - sw, y1: b.y * m.d + m.f - sw,
                 x2: (b.x + b.width) * m.a + m.e + sw, y2: (b.y + b.height) * m.d + m.f + sw };
      };
      // direct children of the root; an inlined logo (nested <svg>) counts as one shape
      const kinds = ['path', 'rect', 'circle', 'ellipse', 'polygon', 'polyline', 'line', 'text', 'image', 'svg'];
      const shapes = [...root.children].flatMap(c => (c.tagName === 'g' ? [...c.querySelectorAll('*')] : [c]))
        .filter(e => kinds.includes(e.tagName));
      const name = (e) => (e.tagName === 'text' ? `text "${e.textContent}"` : e.tagName);
      for (const e of shapes) {
        const b = box(e);
        if (b.x1 < margin || b.x2 > vb.width - margin || b.y1 < margin / 2 || b.y2 > vb.height - margin / 2) {
          out.push(`${name(e)} reaches the canvas edge: x ${b.x1.toFixed(0)}..${b.x2.toFixed(0)} of ${vb.width}, `
            + `y ${b.y1.toFixed(0)}..${b.y2.toFixed(0)} of ${vb.height}`);
        }
      }
      const texts = shapes.filter(e => e.tagName === 'text').map(e => ({ e, b: box(e) }));
      const hit = (a, b) => a.x1 < b.x2 && b.x1 < a.x2 && a.y1 < b.y2 && b.y1 < a.y2;
      for (let i = 0; i < texts.length; i++) {
        for (let j = i + 1; j < texts.length; j++) {
          if (hit(texts[i].b, texts[j].b)) out.push(`${name(texts[i].e)} overlaps ${name(texts[j].e)}`);
        }
      }
      const outlines = shapes.filter(e => e.tagName === 'rect' && e.getAttribute('stroke') && e.getAttribute('fill') === 'none');
      for (const o of outlines) {
        const r = box(o);
        for (const { e, b } of texts) {
          const insideY = b.y2 > r.y1 && b.y1 < r.y2;
          const insideX = b.x2 > r.x1 && b.x1 < r.x2;
          const crossesX = (b.x1 < r.x1 && b.x2 > r.x1) || (b.x1 < r.x2 && b.x2 > r.x2);
          const crossesY = (b.y1 < r.y1 && b.y2 > r.y1) || (b.y1 < r.y2 && b.y2 > r.y2);
          if ((crossesX && insideY) || (crossesY && insideX)) {
            out.push(`${name(e)} sits on the border of a box`);
          } else if (insideY && ((b.x1 >= r.x2 && b.x1 - r.x2 < 6) || (b.x2 <= r.x1 && r.x1 - b.x2 < 6))) {
            out.push(`${name(e)} is less than 6 px from the border of a box`);
          }
        }
      }
      return out;
    }, margin);
    console.log(`${path.basename(f)}: ${found.length ? '' : 'ok'}`);
    found.forEach(p => console.log('  - ' + p));
    problems += found.length;
  }
  await browser.close();
  process.exit(problems ? 1 : 0);
})().catch(e => { console.error(e.message); process.exit(2); });
