#!/usr/bin/env python3
"""List the colours a stylesheet uses: its CSS custom properties (the design tokens) and the most frequent
hex colours. Sources are local files or URLs.

Usage:
    python3 site-colors.py [--top 25] <css-file-or-url>...

Examples:
    python3 site-colors.py /d/projects/oxygen-xml-website-sources/css/oxygen-main.css
    python3 site-colors.py https://www.oxygenxml.com/css/oxygen-main.css

Grays and pure black/white are listed but marked, so the hues stand out.
"""
import collections
import re
import sys
import urllib.request

args = sys.argv[1:]
top = 25
if '--top' in args:
    i = args.index('--top')
    top = int(args[i + 1])
    del args[i:i + 2]
if not args:
    sys.exit(__doc__)


def read(src):
    if re.match(r'https?://', src):
        req = urllib.request.Request(src, headers={'User-Agent': 'site-colors/1.0'})
        with urllib.request.urlopen(req, timeout=30) as r:
            return r.read().decode('utf-8', 'replace')
    with open(src, encoding='utf-8', errors='replace') as f:
        return f.read()


def norm(h):
    h = h.lower()
    if len(h) == 4:
        h = '#' + ''.join(c * 2 for c in h[1:])
    return h


def is_gray(h):
    r, g, b = (int(h[i:i + 2], 16) for i in (1, 3, 5))
    return max(r, g, b) - min(r, g, b) < 12


for src in args:
    css = read(src)
    print(f'== {src}')
    tokens = re.findall(r'(--[\w-]+)\s*:\s*([^;}{]+)', css)
    if tokens:
        print('design tokens (CSS custom properties):')
        for name, value in dict(tokens).items():
            print(f'  {name}: {value.strip()}')
    counts = collections.Counter(norm(h) for h in re.findall(r'#[0-9a-fA-F]{6}\b|#[0-9a-fA-F]{3}\b', css))
    print(f'most used colours (of {len(counts)}):')
    for h, n in counts.most_common(top):
        print(f'  {h} {n:5d}{"  gray" if is_gray(h) else ""}')
