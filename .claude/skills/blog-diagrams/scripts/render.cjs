#!/usr/bin/env node
// Usage: render.cjs <out.png> <width> [--labels] <svg>...
// Stacks the SVGs as <img> at the given display width (what WebHelp shows), on white, cropped to the content.
// No file names unless --labels: names in the picture reveal the variant in a blind A/B test.
const path = require('path');
const fs = require('fs');
const os = require('os');
const { chromium } = require(path.join(require('child_process').execSync('npm root -g').toString().trim(), 'playwright'));

const args = process.argv.slice(2);
const labels = args.includes('--labels');
const [out, width, ...svgs] = args.filter(a => a !== '--labels');
if (!out || !width || svgs.length === 0) {
  console.error('Usage: render.cjs <out.png> <width> [--labels] <svg>...');
  process.exit(1);
}
const html = '<!doctype html><body style="margin:0;padding:16px;background:#fff;font:12px sans-serif;display:inline-block">'
  + svgs.map(f => (labels ? `<div>${path.basename(f)}</div>` : '')
    + `<img style="width:${width}px;display:block;margin:4px 0 24px" src="file://${path.resolve(f)}">`).join('')
  + '</body>';
const tmp = path.join(fs.mkdtempSync(path.join(os.tmpdir(), 'render-')), 'sheet.html');
fs.writeFileSync(tmp, html);
(async () => {
  const browser = await chromium.launch({ channel: 'chrome' });
  const page = await browser.newPage({ viewport: { width: +width + 32, height: 100 } });
  await page.goto('file://' + tmp, { waitUntil: 'networkidle' });
  await page.screenshot({ path: path.resolve(out), fullPage: true });
  await browser.close();
})().catch(e => { console.error(e.message); process.exit(1); });
