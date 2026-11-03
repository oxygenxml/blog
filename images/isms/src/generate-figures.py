#!/usr/bin/env python3
"""Generates the schematic SVG figures of the ISMS blog post.

Usage (from the repo root):
    python3 images/isms/src/generate-figures.py <out-dir> [--color] [--variants] [--pick=assets:a,raci:b,...]

--variants writes every layout variant as <name>-a.svg / <name>-b.svg; otherwise the picked variant of each
figure is written as <name>.svg. The default palette is grayscale with one teal accent (the A/B test winner);
--color uses the Content Fusion feature colours instead. Logos always keep their brand colours.
The official product logos are read from the logos/ folder next to this script.
"""
import base64
import math
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
LOGOS = os.path.join(HERE, 'logos')
OUT = sys.argv[1]
GRAY = '--color' not in sys.argv
VARIANTS = '--variants' in sys.argv
PICK = {'assets': 'a', 'raci': 'b', 'ai': 'b', 'push': 'a', 'calendar': 'a', 'publish': 'b'}  # A/B test winners
for a in sys.argv:
    if a.startswith('--pick='):
        PICK.update(dict(p.split(':') for p in a[7:].split(',')))

# ---- palette (Content Fusion brochure / site colours) -------------------------------------------
INK = '#312e2f'
MUTED = '#5e6573'
LINE = '#c9c8c8'
TEXTBAR = '#dcdcdc'
KEYBAR = '#a7adb8'
WHITE = '#ffffff'
NAVY = '#253c5b'

GRAD = {  # top -> bottom, CF feature-badge style
    'doc': ('#f8a11b', '#ed8522'),     # documents (Structured Content Management)
    'git': ('#5e6573', '#434850'),     # Git repository, servers
    'app': ('#149aa6', '#01929e'),     # the ISMS Python app (automation)
    'ticket': ('#8f72b8', '#7e60a9'),  # ticketing system, review (collaboration)
    'ok': ('#689c4f', '#5f9247'),      # validation
    'risk': ('#db4a2e', '#ba2b25'),    # threats
    'ctl': ('#4e8abe', '#2c67b1'),     # security controls
    'people': ('#7d879d', '#6f7a93'),
    'mark': ('#149aa6', '#01929e'),    # calendar: SOP run
}
if GRAY:
    GRAD.update({
        'doc': ('#8e949e', '#767c86'),
        'app': ('#5e6573', '#434850'),
        'ticket': ('#a3a9b3', '#868c96'),
        'ok': ('#149aa6', '#01929e'),      # the one accent of the grayscale set
        'ctl': ('#9aa1ac', '#7d848f'),
    })
FLAT = {k: v[1] for k, v in GRAD.items()}
# text in the accent colour needs 4.5:1 on white: #01929e has 3.75, #017f8a has 4.77
ACCENT_TEXT = '#017f8a' if GRAY else FLAT['ok']

FONT = "'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif"


class Svg:
    def __init__(self, prefix, w, h, title, desc):
        self.p, self.w, self.h = prefix, w, h
        self.title, self.desc = title, desc
        self.parts = []
        self.used = set()

    def add(self, s):
        self.parts.append(s)

    def grad(self, key):
        self.used.add(key)
        return f'url(#{self.p}-{key})'

    def save(self, name):
        defs = ''.join(
            f'<linearGradient id="{self.p}-{k}" x1="0" y1="0" x2="0" y2="1">'
            f'<stop offset="0" stop-color="{GRAD[k][0]}"/><stop offset="1" stop-color="{GRAD[k][1]}"/>'
            f'</linearGradient>\n' for k in sorted(self.used))
        body = '\n'.join(self.parts)
        svg = (f'<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" '
               f'width="{self.w}" height="{self.h}" viewBox="0 0 {self.w} {self.h}" role="img" font-family="{FONT}">\n'
               f'<title>{self.title}</title>\n<desc>{self.desc}</desc>\n'
               f'<defs>\n{defs}</defs>\n{body}\n</svg>\n')
        with open(os.path.join(OUT, name), 'w', encoding='utf-8') as f:
            f.write(svg)


def r1(v):
    return f'{round(v, 1):g}'


def text(s, x, y, txt, size=13, weight=400, fill=INK, anchor='middle'):
    txt = txt.replace('&', '&amp;')
    s.add(f'<text x="{r1(x)}" y="{r1(y)}" font-size="{size}" font-weight="{weight}" fill="{fill}" '
          f'text-anchor="{anchor}">{txt}</text>')


def caption(s, x, y, title, sub=None, anchor='middle'):
    text(s, x, y, title, 14, 700, INK, anchor)
    if sub:
        text(s, x, y + 17, sub, 12, 400, MUTED, anchor)


def head(s, x2, y2, ang, color):
    L, Hw = 11, 6
    bx, by = x2 - L * math.cos(ang), y2 - L * math.sin(ang)
    px, py = -math.sin(ang), math.cos(ang)
    s.add(f'<polygon points="{r1(x2)},{r1(y2)} {r1(bx + px * Hw)},{r1(by + py * Hw)} '
          f'{r1(bx - px * Hw)},{r1(by - py * Hw)}" fill="{color}"/>')
    return bx, by


def arrow(s, pts, color=MUTED, width=2.5, dashed=False):
    """Polyline with a filled triangular head at the last point. pts: [(x,y), ...]"""
    (x1, y1), (x2, y2) = pts[-2], pts[-1]
    bx, by = head(s, x2, y2, math.atan2(y2 - y1, x2 - x1), color)
    dash = ' stroke-dasharray="6 5"' if dashed else ''
    s.add(f'<polyline points="{" ".join(f"{r1(x)},{r1(y)}" for x, y in pts[:-1] + [(bx, by)])}" fill="none" '
          f'stroke="{color}" stroke-width="{width}" stroke-linecap="round" stroke-linejoin="round"{dash}/>')


def curve(s, p0, c1, c2, p1, color=MUTED, width=2.5, with_head=True):
    s.add(f'<path d="M{r1(p0[0])} {r1(p0[1])} C{r1(c1[0])} {r1(c1[1])} {r1(c2[0])} {r1(c2[1])} '
          f'{r1(p1[0])} {r1(p1[1])}" fill="none" stroke="{color}" stroke-width="{width}" stroke-linecap="round"/>')
    if with_head:
        head(s, p1[0], p1[1], math.atan2(p1[1] - c2[1], p1[0] - c2[0]), color)


def arc_arrow(s, cx, cy, r, a0, a1, color=MUTED, width=2.5):
    """Clockwise arc from angle a0 to a1 (degrees, SVG orientation), head at a1."""
    t0, t1 = math.radians(a0), math.radians(a1)
    x0, y0 = cx + r * math.cos(t0), cy + r * math.sin(t0)
    x1, y1 = cx + r * math.cos(t1), cy + r * math.sin(t1)
    # stop the stroke a bit before the tip so the line does not poke through the head
    tb = t1 - 9 / r
    xb, yb = cx + r * math.cos(tb), cy + r * math.sin(tb)
    large = 1 if (a1 - a0) % 360 > 180 else 0
    s.add(f'<path d="M{r1(x0)} {r1(y0)}A{r1(r)} {r1(r)} 0 {large} 1 {r1(xb)} {r1(yb)}" fill="none" '
          f'stroke="{color}" stroke-width="{width}" stroke-linecap="round"/>')
    head(s, x1, y1, t1 + math.pi / 2, color)


def bars(s, x, y, widths, gap=14, h=7, fill=TEXTBAR):
    for i, w in enumerate(widths):
        s.add(f'<rect x="{r1(x)}" y="{r1(y + i * gap)}" width="{r1(w)}" height="{h}" rx="{h / 2:g}" fill="{fill}"/>')


def tag(s, x, y, label, key='doc', w=None, h=18):
    w = w or 10 + 7.5 * len(label)
    s.add(f'<rect x="{r1(x)}" y="{r1(y)}" width="{r1(w)}" height="{h}" rx="4" fill="{s.grad(key)}"/>')
    text(s, x + w / 2, y + h - 5, label, 11, 700, WHITE)
    return w


def page(s, x, y, w, h, fold=None):
    fold = fold or 14  # the same folded corner on every document, whatever its size
    s.add(f'<path d="M{r1(x)} {r1(y)}H{r1(x + w - fold)}L{r1(x + w)} {r1(y + fold)}V{r1(y + h)}H{r1(x)}Z" '
          f'fill="{WHITE}" stroke="{KEYBAR}" stroke-width="1.5" stroke-linejoin="round"/>')
    s.add(f'<path d="M{r1(x + w - fold)} {r1(y)}V{r1(y + fold)}H{r1(x + w)}" fill="#eeeeee" '
          f'stroke="{KEYBAR}" stroke-width="1.5" stroke-linejoin="round"/>')


def file_icon(s, x, y, w, h, label=None, key='doc', lines=True, dashed=False, fill=TEXTBAR):
    """A document with normal (portrait) proportions."""
    page(s, x, y, w, h)
    top = y + 14
    if label:
        tag(s, x + 10, y + 10, label, key)
        top = y + 38
    if lines:
        n = int((y + h - 12 - top) // 13)
        widths = [(w - 20) * f for f in (1, .8, .95, .6, .9, .75, .85, .5, .9, .7)][:n]
        if dashed:
            for i, lw in enumerate(widths):
                yy = top + 3 + i * 13
                s.add(f'<line x1="{r1(x + 10)}" y1="{r1(yy)}" x2="{r1(x + 10 + lw)}" y2="{r1(yy)}" '
                      f'stroke="{LINE}" stroke-width="2.5" stroke-dasharray="5 5" stroke-linecap="round"/>')
        else:
            bars(s, x + 10, top, widths, gap=13, h=6, fill=fill)


def stack(s, x, y, w, h, n=3, off=7, **kw):
    for k in range(n - 1, 0, -1):
        page(s, x + k * off, y - k * off, w, h)
    file_icon(s, x, y, w, h, **kw)


def badge(s, cx, cy, r, key, symbol, ring=True):
    s.add(f'<circle cx="{r1(cx)}" cy="{r1(cy)}" r="{r1(r)}" fill="{s.grad(key)}"'
          + (f' stroke="{WHITE}" stroke-width="{max(3, r / 9):.0f}"' if ring else '') + '/>')
    symbol(s, cx, cy, r * 0.5)


# ---- symbols, drawn inside a radius `u` ---------------------------------------------------------
def sym_check(s, cx, cy, u, color=WHITE, w=None):
    w = w or max(3, u / 3.2)
    s.add(f'<polyline points="{r1(cx - u * .62)},{r1(cy + u * .02)} {r1(cx - u * .15)},{r1(cy + u * .5)} '
          f'{r1(cx + u * .68)},{r1(cy - u * .45)}" fill="none" stroke="{color}" stroke-width="{r1(w)}" '
          f'stroke-linecap="round" stroke-linejoin="round"/>')


def sym_branch(s, cx, cy, u, color=WHITE):
    w = max(2.5, u / 4)
    x0, x1 = cx - u * .4, cx + u * .45
    s.add(f'<path d="M{r1(x0)} {r1(cy - u * .55)}V{r1(cy + u * .55)}M{r1(x1)} {r1(cy - u * .3)}'
          f'C{r1(x1)} {r1(cy + u * .2)} {r1(x0)} {r1(cy)} {r1(x0)} {r1(cy + u * .4)}" fill="none" '
          f'stroke="{color}" stroke-width="{r1(w)}" stroke-linecap="round"/>')
    for x, y in ((x0, cy - u * .7), (x0, cy + u * .7), (x1, cy - u * .45)):
        s.add(f'<circle cx="{r1(x)}" cy="{r1(y)}" r="{r1(u * .2)}" fill="{color}"/>')


def sym_envelope(s, cx, cy, u, color=WHITE, stroke=None):
    w, h = u * 1.7, u * 1.2
    x, y = cx - w / 2, cy - h / 2
    sw = max(2, u / 6)
    s.add(f'<rect x="{r1(x)}" y="{r1(y)}" width="{r1(w)}" height="{r1(h)}" rx="{r1(u * .15)}" fill="{color}"'
          + (f' stroke="{stroke}" stroke-width="{r1(sw)}"' if stroke else '') + '/>')
    s.add(f'<polyline points="{r1(x + sw)},{r1(y + sw)} {r1(cx)},{r1(cy + h * .12)} {r1(x + w - sw)},{r1(y + sw)}" '
          f'fill="none" stroke="{stroke or "#9aa3b5"}" stroke-width="{r1(sw)}" stroke-linejoin="round"/>')


def person(s, cx, cy, color=None, scale=1.0):
    """cy is the head centre; total height ~ 44*scale."""
    color = color or FLAT['people']
    hr = 9 * scale
    s.add(f'<circle cx="{r1(cx)}" cy="{r1(cy)}" r="{r1(hr)}" fill="{color}"/>')
    bw, bt = 17 * scale, cy + hr + 3 * scale
    s.add(f'<path d="M{r1(cx - bw)} {r1(bt + 22 * scale)}V{r1(bt + 12 * scale)}'
          f'Q{r1(cx - bw)} {r1(bt)} {r1(cx - bw + 10 * scale)} {r1(bt)}H{r1(cx + bw - 10 * scale)}'
          f'Q{r1(cx + bw)} {r1(bt)} {r1(cx + bw)} {r1(bt + 12 * scale)}V{r1(bt + 22 * scale)}Z" fill="{color}"/>')


def robot(s, cx, cy, scale=1.0):
    """An AI agent: a robot head. cy is the head centre."""
    w, h = 40 * scale, 32 * scale
    c = s.grad('git')
    s.add(f'<line x1="{r1(cx)}" y1="{r1(cy - h / 2)}" x2="{r1(cx)}" y2="{r1(cy - h / 2 - 9 * scale)}" '
          f'stroke="{FLAT["git"]}" stroke-width="{r1(3 * scale)}" stroke-linecap="round"/>')
    s.add(f'<circle cx="{r1(cx)}" cy="{r1(cy - h / 2 - 11 * scale)}" r="{r1(4 * scale)}" fill="{FLAT["git"]}"/>')
    s.add(f'<rect x="{r1(cx - w / 2 - 5 * scale)}" y="{r1(cy - 6 * scale)}" width="{r1(w + 10 * scale)}" '
          f'height="{r1(12 * scale)}" rx="{r1(4 * scale)}" fill="{FLAT["git"]}"/>')
    s.add(f'<rect x="{r1(cx - w / 2)}" y="{r1(cy - h / 2)}" width="{r1(w)}" height="{r1(h)}" rx="{r1(9 * scale)}" fill="{c}"/>')
    for dx in (-8, 8):
        s.add(f'<circle cx="{r1(cx + dx * scale)}" cy="{r1(cy - 2 * scale)}" r="{r1(4 * scale)}" fill="{WHITE}"/>')
    s.add(f'<rect x="{r1(cx - 7 * scale)}" y="{r1(cy + 7 * scale)}" width="{r1(14 * scale)}" height="{r1(3 * scale)}" '
          f'rx="{r1(1.5 * scale)}" fill="{WHITE}"/>')


def repo(s, cx, cy, w=96, h=100):
    """Git repository drawn as a database cylinder with a branch symbol."""
    x, top, ry = cx - w / 2, cy - h / 2, 12
    s.add(f'<path d="M{r1(x)} {r1(top + ry)}V{r1(top + h - ry)}A{r1(w / 2)} {ry} 0 0 0 {r1(x + w)} {r1(top + h - ry)}'
          f'V{r1(top + ry)}Z" fill="{s.grad("git")}"/>')
    s.add(f'<ellipse cx="{r1(cx)}" cy="{r1(top + ry)}" rx="{r1(w / 2)}" ry="{ry}" fill="#8995ab"/>')
    for k in (0.42, 0.7):
        yy = top + h * k
        s.add(f'<path d="M{r1(x)} {r1(yy)}A{r1(w / 2)} {ry} 0 0 0 {r1(x + w)} {r1(yy)}" fill="none" '
              f'stroke="#8995ab" stroke-width="2"/>')
    sym_branch(s, cx, top + h * .58, 15)


def server(s, cx, cy, w=76, n=3):
    h, g = 24, 6
    top = cy - (n * h + (n - 1) * g) / 2
    for k in range(n):
        y = top + k * (h + g)
        s.add(f'<rect x="{r1(cx - w / 2)}" y="{r1(y)}" width="{w}" height="{h}" rx="5" fill="{s.grad("git")}"/>')
        s.add(f'<circle cx="{r1(cx + w / 2 - 12)}" cy="{r1(y + h / 2)}" r="3" fill="#9fe08a"/>')
        bars(s, cx - w / 2 + 10, y + h / 2 - 3, [w * .45], h=6, fill='#8995ab')


def window(s, x, y, w, h, key='app', title=None):
    s.add(f'<rect x="{r1(x)}" y="{r1(y)}" width="{r1(w)}" height="{r1(h)}" rx="10" fill="{WHITE}" '
          f'stroke="{KEYBAR}" stroke-width="1.5"/>')
    s.add(f'<path d="M{r1(x)} {r1(y + 26)}V{r1(y + 10)}Q{r1(x)} {r1(y)} {r1(x + 10)} {r1(y)}H{r1(x + w - 10)}'
          f'Q{r1(x + w)} {r1(y)} {r1(x + w)} {r1(y + 10)}V{r1(y + 26)}Z" fill="{s.grad(key)}"/>')
    for i in range(3):
        s.add(f'<circle cx="{r1(x + 14 + i * 12)}" cy="{r1(y + 13)}" r="3.5" fill="{WHITE}" opacity="0.85"/>')
    if title:
        text(s, x + 54, y + 18, title, 12, 700, WHITE, 'start')


def asset_icons(s, pts, scale=1.0, label=True):
    """Data, code, systems, people at the given centres."""
    c = s.grad('doc')
    k = scale
    (x, y) = pts[0]
    s.add(f'<path d="M{r1(x - 13 * k)} {r1(y - 10 * k)}V{r1(y + 10 * k)}A{r1(13 * k)} {r1(5 * k)} 0 0 0 '
          f'{r1(x + 13 * k)} {r1(y + 10 * k)}V{r1(y - 10 * k)}Z" fill="{c}"/>'
          f'<ellipse cx="{r1(x)}" cy="{r1(y - 10 * k)}" rx="{r1(13 * k)}" ry="{r1(5 * k)}" fill="{GRAD["doc"][0]}" '
          f'stroke="{WHITE}" stroke-width="1.5"/>')
    (x, y) = pts[1]
    s.add(f'<rect x="{r1(x - 12 * k)}" y="{r1(y - 15 * k)}" width="{r1(24 * k)}" height="{r1(30 * k)}" rx="{r1(3 * k)}" fill="{c}"/>')
    s.add(f'<path d="M{r1(x - 3 * k)} {r1(y - 6 * k)}L{r1(x - 8 * k)} {r1(y)}L{r1(x - 3 * k)} {r1(y + 6 * k)}'
          f'M{r1(x + 3 * k)} {r1(y - 6 * k)}L{r1(x + 8 * k)} {r1(y)}L{r1(x + 3 * k)} {r1(y + 6 * k)}" fill="none" '
          f'stroke="{WHITE}" stroke-width="{r1(2.2 * k)}" stroke-linecap="round" stroke-linejoin="round"/>')
    (x, y) = pts[2]
    for j in range(2):
        yy = y - 14 * k + j * 15 * k
        s.add(f'<rect x="{r1(x - 15 * k)}" y="{r1(yy)}" width="{r1(30 * k)}" height="{r1(12 * k)}" rx="{r1(3 * k)}" fill="{c}"/>'
              f'<circle cx="{r1(x + 9 * k)}" cy="{r1(yy + 6 * k)}" r="{r1(2 * k)}" fill="{WHITE}"/>')
    (x, y) = pts[3]
    person(s, x, y - 9 * k, FLAT['doc'], 0.62 * k)
    if label:
        for (x, y), lab in zip(pts, ['Data', 'Code', 'Systems', 'People']):
            text(s, x, y + 22 + 12 * k, lab, 12, 400, MUTED)


# ---- official logos -----------------------------------------------------------------------------
def logo(s, name, x, y, size):
    """Inline an official product logo (oxygenxml.com/oxygen_logos.html) at (x, y), size x size."""
    if name == 'positron':  # only published as a PNG (oxygenxml.com/img/Ai_positron80.png)
        with open(os.path.join(LOGOS, 'Ai_positron80.png'), 'rb') as f:
            data = base64.b64encode(f.read()).decode()
        s.add(f'<image x="{r1(x)}" y="{r1(y)}" width="{size}" height="{size}" '
              f'xlink:href="data:image/png;base64,{data}"/>')
        return
    files = {'cf': 'OxygenContentFusion_icon_2019.svg', 'ope': 'OxygenOPE_icon_2020.svg'}
    src = open(os.path.join(LOGOS, files[name]), encoding='utf-8').read()
    rules = dict(re.findall(r'\.(st\d+)\{([^}]*)\}', src))
    body = src[src.index('</style>') + 8:src.rindex('</svg>')]
    pid = f'{s.p}-{name}'

    def attrs(css):
        out = []
        for decl in css.split(';'):
            if ':' not in decl:
                continue
            k, v = (t.strip() for t in decl.split(':', 1))
            if k in ('enable-background',):
                continue
            out.append(f'{k}="{v}"')
        return ' '.join(out)

    body = re.sub(r'class="(st\d+)"', lambda m: attrs(rules[m.group(1)]), body)
    body = re.sub(r'style="([^"]*)"', lambda m: attrs(m.group(1)), body)
    body = re.sub(r'id="([^"]+)"', lambda m: f'id="{pid}-{m.group(1)}"', body)
    body = re.sub(r'url\(#([^)]+)\)', lambda m: f'url(#{pid}-{m.group(1)})', body)
    body = re.sub(r'\s+', ' ', body).strip()
    s.add(f'<svg x="{r1(x)}" y="{r1(y)}" width="{size}" height="{size}" viewBox="0 0 50 50">{body}</svg>')


def out(s, fig, var, name):
    if VARIANTS:
        s.save(f'{name}-{var}.svg')
    elif PICK[fig] == var:
        s.save(f'{name}.svg')


# =================================================================================================
# 1. Attacks stopped by a wall of controls in front of the business assets
# =================================================================================================
ASSETS_DESC = ('Cyberattacks, AI-assisted attacks and supply-chain risk, drawn as one attack arrow, hit a wall of '
               'security controls that stands in front of the business assets: data, code, systems and people.')


THREAT = next((a[9:] for a in sys.argv if a.startswith('--threat=')), '#8c2f2a')  # dark brick red, calmer than #ba2b25
ARROW = next((a[8:] for a in sys.argv if a.startswith('--arrow=')), 'slim')  # block, outline, slim, line; slim won a blind ranking
RISK_TINT = '#fbe9e6'


def attack_arrow(s, x0, x1, cy, label_cx, style=None):
    """One arrow for all attacks. style: block (solid, label inside), outline (pale fill, red outline and
    label), slim (thin solid arrow, label above), line (a stroke with a head, label above)."""
    style = style or ARROW
    red = THREAT
    if style in ('block', 'outline'):
        sh, hh, hl = (22, 44, 52) if style == 'block' else (16, 32, 40)
        p = [(x0, cy - sh), (x1 - hl, cy - sh), (x1 - hl, cy - hh), (x1, cy), (x1 - hl, cy + hh), (x1 - hl, cy + sh),
             (x0, cy + sh)]
        pts = " ".join(f"{r1(a)},{r1(b)}" for a, b in p)
        if style == 'block':
            s.add(f'<polygon points="{pts}" fill="{s.grad("risk")}" stroke-linejoin="round"/>')
            text(s, (x0 + x1 - hl) / 2, cy + 6, 'Attacks', 16, 700, WHITE)
        else:
            s.add(f'<polygon points="{pts}" fill="{RISK_TINT}" stroke="{red}" stroke-width="2" stroke-linejoin="round"/>')
            text(s, (x0 + x1 - hl) / 2, cy + 5, 'Attacks', 14, 700, red)
        sub_y = cy + hh + 28
    else:
        if style == 'slim':
            sh, hh, hl = 11, 26, 36  # shaft and head half-heights, head length
            p = [(x0, cy - sh), (x1 - hl, cy - sh), (x1 - hl, cy - hh), (x1, cy), (x1 - hl, cy + hh), (x1 - hl, cy + sh),
                 (x0, cy + sh)]
            s.add(f'<polygon points="{" ".join(f"{r1(a)},{r1(b)}" for a, b in p)}" fill="{red}" '
                  f'stroke-linejoin="round"/>')
        else:
            s.add(f'<line x1="{x0}" y1="{cy}" x2="{x1 - 14}" y2="{cy}" stroke="{red}" stroke-width="3" stroke-linecap="round"/>')
            s.add(f'<polygon points="{x1},{cy} {x1 - 16},{cy - 9} {x1 - 16},{cy + 9}" fill="{red}"/>')
        text(s, label_cx, cy - 22, 'Attacks', 14, 700, red)
        sub_y = cy + 40
    text(s, label_cx, sub_y, 'Cyberattacks, AI-assisted', 12, 400, MUTED)
    text(s, label_cx, sub_y + 16, 'attacks, supply-chain risk', 12, 400, MUTED)


def fig_assets(var):
    s = Svg(f'isms-assets-{var}', 800, 300, 'Attacks stopped by a wall of security controls', ASSETS_DESC)
    cy = 150
    if var == 'a':
        # plain brick wall, assets behind it
        wx, ww, wy, wh, rows = 318, 64, 40, 220, 10
        attack_arrow(s, 30, wx - 1, cy, 150)
        s.add(f'<rect x="{wx}" y="{wy}" width="{ww}" height="{wh}" rx="4" fill="{s.grad("ctl")}"/>')
        rh = wh / rows
        for i in range(1, rows):
            y = wy + i * rh
            s.add(f'<line x1="{wx}" y1="{r1(y)}" x2="{wx + ww}" y2="{r1(y)}" stroke="{WHITE}" stroke-width="3"/>')
        for i in range(rows):
            y = wy + i * rh
            for jx in ([wx + ww / 2] if i % 2 == 0 else [wx + ww / 4, wx + ww * 3 / 4]):
                s.add(f'<line x1="{r1(jx)}" y1="{r1(y)}" x2="{r1(jx)}" y2="{r1(y + rh)}" stroke="{WHITE}" stroke-width="3"/>')
        caption(s, wx + ww / 2, 28, 'Security controls')
        bx, bw, by, bh = 440, 296, 72, 156
        s.add(f'<rect x="{bx}" y="{by}" width="{bw}" height="{bh}" rx="14" fill="{WHITE}" '
              f'stroke="{KEYBAR}" stroke-width="1.5"/>')
        text(s, bx + bw / 2, by + 30, 'Business assets', 14, 700)
        xs = [bx + 43 + i * 70 for i in range(4)]
        asset_icons(s, [(x, by + 82) for x in xs], 1.25)
    else:
        # the wall is built from the controls themselves
        wx, ww, wy, rh = 330, 196, 46, 52
        attack_arrow(s, 30, wx - 10, cy, 150)
        labels = ['Access control', 'Encryption', 'Backups', 'Monitoring']
        for i, lab in enumerate(labels):
            y = wy + i * rh
            split = 130 if i % 2 == 0 else 66
            segs = [(wx, wx + split - 3), (wx + split + 3, wx + ww)]
            for a, b in segs:
                s.add(f'<rect x="{a}" y="{r1(y + 3)}" width="{b - a}" height="{rh - 6}" rx="4" fill="{s.grad("ctl")}"/>')
            big = max(segs, key=lambda t: t[1] - t[0])
            text(s, (big[0] + big[1]) / 2, y + rh / 2 + 5, lab, 13, 700, WHITE)
        caption(s, wx + ww / 2, 30, 'Security controls')
        bx, bw, by, bh = 580, 190, 56, 196
        s.add(f'<rect x="{bx}" y="{by}" width="{bw}" height="{bh}" rx="14" fill="{WHITE}" '
              f'stroke="{KEYBAR}" stroke-width="1.5"/>')
        text(s, bx + bw / 2, by + 28, 'Business assets', 14, 700)
        pts = [(bx + 55, by + 72), (bx + 135, by + 72), (bx + 55, by + 140), (bx + 135, by + 140)]
        asset_icons(s, pts, 1.1)
    out(s, 'assets', var, 'isms-assets-controls')


# =================================================================================================
# 2. Schematron checks the metadata and the RACI names against the roles and groups tables
# =================================================================================================
RACI_DESC = ('Each SOP and policy file has a metadata header and a small RACI table. Schematron rules check the '
             'integrity of the metadata and look up every RACI name in the Roles and Groups tables of the wiki.')


def raci_file(s, x, y, w, h, label='SOP'):
    """A topic file: tag, metadata header, captioned RACI table. Returns (meta_y0, meta_y1, raci_y0, raci_y1)."""
    page(s, x, y, w, h)
    tag(s, x + 12, y + 12, label, 'doc')
    my = y + 40
    s.add(f'<rect x="{r1(x + 10)}" y="{r1(my)}" width="{r1(w - 20)}" height="46" rx="5" fill="#f2f3f5"/>')
    for i in range(3):
        yy = my + 9 + i * 12
        bars(s, x + 18, yy, [24], h=6, fill=KEYBAR)
        bars(s, x + 48, yy, [(w - 68) * (1, .7, .85)[i]], h=6)
    ry = my + 58
    text(s, x + 12, ry + 10, 'RACI', 11, 700, INK, 'start')
    ty, th, n = ry + 16, 15, 4
    tx, tw = x + 12, w - 24
    s.add(f'<rect x="{r1(tx)}" y="{r1(ty)}" width="{r1(tw)}" height="{th * n}" rx="3" fill="{WHITE}" '
          f'stroke="{KEYBAR}" stroke-width="1.2"/>')
    for i in range(1, n):
        s.add(f'<line x1="{r1(tx)}" y1="{r1(ty + i * th)}" x2="{r1(tx + tw)}" y2="{r1(ty + i * th)}" '
              f'stroke="{KEYBAR}" stroke-width="1"/>')
    s.add(f'<line x1="{r1(tx + 20)}" y1="{r1(ty)}" x2="{r1(tx + 20)}" y2="{r1(ty + th * n)}" stroke="{KEYBAR}" stroke-width="1"/>')
    for i, l in enumerate('RACI'):
        text(s, tx + 10, ty + i * th + 11, l, 9, 700, MUTED)
        bars(s, tx + 27, ty + i * th + 4.5, [(22, 30, 26, 18)[i]], h=6, fill=KEYBAR)
    return my, my + 46, ry, ty + th * n


def lookup_file(s, x, y, w, title, n):
    h = 40 + n * 20
    page(s, x, y, w, h)
    text(s, x + 12, y + 24, title, 13, 700, INK, 'start')
    for i in range(n):
        yy = y + 38 + i * 20
        s.add(f'<rect x="{r1(x + 12)}" y="{r1(yy)}" width="30" height="12" rx="6" fill="#e6e8ec" stroke="{KEYBAR}" stroke-width="1"/>')
        bars(s, x + 50, yy + 3, [(w - 66) * (1, .75, .9, .65)[i]], h=6)
    return h


def schematron(s, cx, cy, list_x=None):
    badge(s, cx, cy, 34, 'ok', sym_check)
    text(s, cx, cy + 56, 'Schematron', 14, 700)
    lx = list_x if list_x is not None else cx - 62
    for i, t in enumerate(['metadata integrity', 'RACI names exist']):
        y = cy + 78 + i * 19
        sym_check(s, lx + 6, y - 4, 7, FLAT['ok'], 2.4)
        text(s, lx + 18, y, t, 12, 400, MUTED, 'start')


def fig_raci(var):
    s = Svg(f'isms-raci-{var}', 800, 330, 'Schematron checks metadata and RACI names', RACI_DESC)
    fx, fw = 600, 160
    if var == 'a':
        # a set of files, the front one shows its structure
        for k in (2, 1):
            page(s, 40 + k * 18, 40 - k * 12, 150, 196)
        raci_file(s, 40, 64, 150, 196)
        caption(s, 115, 290, 'SOPs and policies')
        cx, cy = 390, 140
        arrow(s, [(206, 160), (cx - 44, cy + 6)], MUTED, 2.5)
        schematron(s, cx, cy)
    else:
        # one file, with its metadata and RACI table both feeding the check
        for k in (2, 1):
            page(s, 50 - k * 12, 40 - k * 10, 170, 236)
        my0, my1, ry0, ry1 = raci_file(s, 50, 40, 170, 236)
        caption(s, 117, 300, 'SOPs and policies')
        cx, cy = 400, 140
        for (y0, y1), lab in (((my0, my1), 'metadata'), ((ry0, ry1), 'RACI names')):
            ym = (y0 + y1) / 2
            s.add(f'<path d="M228 {r1(y0)}h7v{r1(y1 - y0)}h-7" fill="none" stroke="{MUTED}" stroke-width="2.8" '
                  f'stroke-linejoin="round"/>')
            curve(s, (240, ym), (300, ym), (300, cy), (cx - 42, cy), MUTED, 2.5)
            text(s, 282, ym - 8 if ym < cy else ym + 18, lab, 11, 700, MUTED)
        schematron(s, cx, cy)
    h1 = lookup_file(s, fx, 26, fw, 'Roles', 3)
    h2 = lookup_file(s, fx, 26 + h1 + 24, fw, 'Groups', 4)
    arrow(s, [(cx + 40, cy - 8), (fx - 8, 26 + h1 / 2)], MUTED, 2, dashed=True)
    arrow(s, [(cx + 40, cy + 8), (fx - 8, 50 + h1 + h2 / 2)], MUTED, 2, dashed=True)
    text(s, (cx + fx) / 2 + 12, 26 + h1 + 16, 'look up', 11, 700, MUTED)
    out(s, 'raci', var, 'isms-raci-validation')


# =================================================================================================
# 3. Policy stubs + current controls -> AI Positron <-> review -> policies -> SoA
# =================================================================================================
AI_DESC = ('Policy stubs and the current controls, collected from the CTO and the system administrators, go to '
           'AI Positron in Content Fusion, which drafts the policies. Drafts and reviews go round in a loop until the policies are '
           'approved; the resulting policy files are linked from the Statement of Applicability.')


def ai_inputs(s, cy_stub=96, cy_people=250):
    stack(s, 46, cy_stub - 56, 84, 110, n=3, label='POL', dashed=True)
    caption(s, 92, cy_stub + 78, 'Policy stubs')
    person(s, 72, cy_people - 16, None, .85)
    person(s, 112, cy_people - 16, None, .85)
    caption(s, 92, cy_people + 38, 'Current controls', 'CTO, system admins')


def ai_outputs(s, x, cy):
    stack(s, x, cy - 58, 80, 104, n=3, label='POL')
    badge(s, x + 74, cy + 40, 13, 'ok', sym_check)
    caption(s, x + 46, cy + 80, 'Policies')
    arrow(s, [(x + 100, cy - 4), (x + 124, cy - 4)], MUTED, 2.5)
    sx, sw, sh = x + 130, 88, 122  # keep a 12 px margin to the canvas edge
    sy = cy - sh / 2 - 4
    page(s, sx, sy, sw, sh)
    tag(s, sx + 10, sy + 10, 'SoA', 'ok')
    for j in range(5):
        ry = sy + 40 + j * 15
        bars(s, sx + 10, ry, [26], h=6, fill=KEYBAR)
        bars(s, sx + 42, ry, [(40, 30, 36, 26, 34)[j]], h=6)
    text(s, sx + sw / 2, cy + 80, 'Statement of', 14, 700)
    text(s, sx + sw / 2, cy + 97, 'Applicability', 14, 700)


def fig_ai(var):
    s = Svg(f'isms-ai-{var}', 800, 330, 'Policies drafted with AI Positron and reviewed in a loop', AI_DESC)
    ai_inputs(s)
    if var == 'a':
        # review cycle drawn as a circle: AI -> draft -> review -> AI
        cx, cy, r = 372, 160, 86
        nodes = {180: 'ai', 300: 'draft', 60: 'review'}
        px, py = cx + r * math.cos(math.pi), cy
        logo(s, 'positron', px - 30, py - 30, 60)
        text(s, px, py + 50, 'AI Positron', 13, 700)
        dx, dy = cx + r * math.cos(math.radians(300)), cy + r * math.sin(math.radians(300))
        file_icon(s, dx - 24, dy - 31, 48, 62)
        text(s, dx + 36, dy - 18, 'Draft', 13, 700, INK, 'start')
        rx_, ry_ = cx + r * math.cos(math.radians(60)), cy + r * math.sin(math.radians(60))
        person(s, rx_, ry_ - 12, FLAT['ticket'], .9)
        text(s, rx_ + 30, ry_ + 30, 'Review', 13, 700, INK, 'start')
        arc_arrow(s, cx, cy, r, 205, 270)
        arc_arrow(s, cx, cy, r, 330, 30)
        arc_arrow(s, cx, cy, r, 90, 154)
        # inputs into the loop
        curve(s, (148, 96), (220, 96), (230, cy), (px - 36, cy))
        curve(s, (148, 250), (220, 250), (230, cy), (px - 36, cy), with_head=False)
        # approved policies leave the loop
        arrow(s, [(cx + r + 14, cy), (548, cy)], MUTED, 2.5)
        text(s, cx + r + 46, cy - 10, 'approved', 11, 700, MUTED)
        ai_outputs(s, 558, cy)
    else:
        # linear, with the review feeding back to the AI, inside a Content Fusion box
        cy = 150
        px, dx, rx = 270, 354, 472  # AI Positron, draft, review
        bx, by, bw, bh = 212, 34, 290, 236
        s.add(f'<rect x="{bx}" y="{by}" width="{bw}" height="{bh}" rx="14" fill="none" stroke="{KEYBAR}" '
              f'stroke-width="1.5" stroke-dasharray="6 5"/>')
        logo(s, 'cf', bx + 14, by + 10, 36)
        text(s, bx + 58, by + 34, 'Content Fusion', 15, 700, INK, 'start')
        logo(s, 'positron', px - 30, cy - 30, 60)
        text(s, px, cy - 44, 'AI Positron', 13, 700)
        curve(s, (148, 96), (196, 96), (206, cy), (px - 38, cy))
        curve(s, (148, 250), (196, 250), (206, cy), (px - 38, cy), with_head=False)
        arrow(s, [(px + 38, cy), (dx - 6, cy)], MUTED, 2.5)
        file_icon(s, dx, cy - 35, 52, 70, fill=KEYBAR)
        text(s, dx + 26, cy - 48, 'Draft', 13, 700)
        arrow(s, [(dx + 58, cy), (rx - 24, cy)], MUTED, 2.5)
        person(s, rx, cy - 14, FLAT['ticket'], .9)
        text(s, rx, cy - 44, 'Review', 13, 700)
        s.add(f'<path d="M{rx} {cy + 34}V{cy + 66}Q{rx} {cy + 82} {rx - 16} {cy + 82}H{px + 16}Q{px} {cy + 82} '
              f'{px} {cy + 66}V{cy + 50}" fill="none" stroke="{MUTED}" stroke-width="2.5" stroke-linecap="round"/>')
        head(s, px, cy + 39, -math.pi / 2, MUTED)
        text(s, (px + rx) / 2, cy + 101, 'comments → next draft', 12, 700, MUTED)
        arrow(s, [(bx + bw + 6, cy), (562, cy)], FLAT['ok'], 2.5)  # starts outside the box
        text(s, bx + bw + 10, cy - 10, 'approved', 11, 700, ACCENT_TEXT, 'start')
        ai_outputs(s, 570, cy)
    out(s, 'ai', var, 'isms-ai-policy-drafting')


# =================================================================================================
# 4. Repository (edited in Content Fusion) -> ISMS web app -> ticketing system
# =================================================================================================
PUSH_DESC = ('SOPs are edited and reviewed in Content Fusion and stored in the Git wiki repository. The ISMS web '
             'app (Python) reads them and shows each person a catalog filtered by role; its Push button sends an '
             'SOP to the ticketing system as a work item that people carry out and close.')


def app_catalog(s, x, y, w, h):
    window(s, x, y, w, h, 'app')
    for j in range(3):
        ry = y + 42 + j * 32
        tag(s, x + 14, ry, 'SOP', 'doc', w=34)
        bars(s, x + 56, ry + 6, [w - 140 - j * 10])
        s.add(f'<rect x="{r1(x + w - 64)}" y="{r1(ry - 2)}" width="50" height="22" rx="11" fill="{s.grad("app")}"/>')
        text(s, x + w - 39, ry + 13, 'Push', 11, 700, WHITE)


def ticketing(s, x, y, w, h):
    s.add(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="12" fill="{s.grad("ticket")}"/>')
    for j, done in enumerate([True, True, False]):
        ry = y + 16 + j * 38
        s.add(f'<rect x="{x + 12}" y="{ry}" width="{w - 24}" height="28" rx="6" fill="{WHITE}"/>')
        s.add(f'<rect x="{x + 20}" y="{ry + 6}" width="16" height="16" rx="4" fill="{FLAT["ticket"] if done else WHITE}" '
              f'stroke="{FLAT["ticket"]}" stroke-width="2"/>')
        if done:
            sym_check(s, x + 28, ry + 14, 6, WHITE, 2.2)
        bars(s, x + 44, ry + 11, [w - 70 - j * 8])


def fig_push(var):
    s = Svg(f'isms-push-{var}', 800, 330, 'SOPs pushed from the wiki repository to the ticketing system', PUSH_DESC)
    if var == 'a':
        cy, top = 136, 72
        rx = 140
        repo(s, rx, cy, 96, 100)
        caption(s, rx, 30, 'Wiki repository', 'Git')
        logo(s, 'cf', rx - 30, 248, 60)
        arrow(s, [(rx, 242), (rx, 195)], MUTED, 2.5)
        caption(s, rx + 44, 274, 'Content Fusion', 'edit & review', anchor='start')
    else:
        cy, top = 105, 42
        rx = 140
        repo(s, rx, cy, 96, 96)
        caption(s, rx, 176, 'Wiki repository', 'Git')
        logo(s, 'cf', rx - 28, 228, 56)
        arrow(s, [(rx, 224), (rx, 200)], MUTED, 2.5)
        caption(s, rx, 304, 'Content Fusion', None)
        text(s, rx + 44, 260, 'edit & review', 12, 400, MUTED, 'start')
    ax, aw, ah = 290, 200, 136
    app_catalog(s, ax, top, aw, ah)
    tx, tw = 640, 128
    ticketing(s, tx, top, tw, ah)
    arrow(s, [(rx + 56, cy), (ax - 8, cy)], MUTED, 2.5)
    arrow(s, [(ax + aw + 8, cy), (tx - 8, cy)], FLAT['app'], 3)
    text(s, (ax + aw + tx) / 2, cy - 12, 'Push', 12, 700, FLAT['app'])
    if var == 'a':
        caption(s, ax + aw / 2, 30, 'ISMS web app (Python)', 'catalog by role')
        caption(s, tx + tw / 2, 30, 'Ticketing system', 'run, track, close')
    else:
        caption(s, ax + aw / 2, top + ah + 30, 'ISMS web app (Python)', 'catalog by role')
        caption(s, tx + tw / 2, top + ah + 30, 'Ticketing system', 'run, track, close')
    out(s, 'push', var, 'isms-sop-push-flow')


# =================================================================================================
# 5. Metadata in Git -> calendar in the ISMS web app -> email to the RACI people
# =================================================================================================
CAL_DESC = ('SOPs and policies in the Git repository carry scheduling metadata: start date, repeat interval and '
            'review period. The ISMS web app turns it into a calendar of SOP runs and document reviews, and emails '
            'the people named in each RACI table when an SOP is due or a document needs review.')


def fig_calendar(var):
    s = Svg(f'isms-calendar-{var}', 800, 340 if var == 'a' else 368, 'Scheduling driven by document metadata', CAL_DESC)
    # repository: a header and the files, no panel
    px, pw = 30, 256
    sym_branch(s, px + 8, 26, 9, FLAT['git'])
    text(s, px + 24, 31, 'Git repository', 14, 700, INK, 'start')
    docs = [('SOP', 'Replace UPS batteries', [('Start', '2024-11-04'), ('Repeats', '6 months')]),
            ('SOP', 'Rotate passwords', [('Start', '2025-01-15'), ('Repeats', '3 months')]),
            ('POL', 'Access control', [('Review period', '1 year')])]
    for i, (lab, title, meta) in enumerate(docs):
        y = 48 + i * 92
        page(s, px, y, pw, 80)
        tw = tag(s, px + 12, y + 12, lab, 'doc')
        text(s, px + 20 + tw, y + 26, title, 13, 700, INK, 'start')
        x = px + 14
        for k, v in meta:
            text(s, x, y + 52, k, 11, 400, MUTED, 'start')
            text(s, x, y + 68, v, 12, 700, INK, 'start')
            x += 112
    ax, ay, aw, ah = 350, 48, 214, 244
    arrow(s, [(px + pw + 8, 170), (ax - 8, 170)], MUTED, 2.5)
    text(s, (px + pw + ax) / 2, 158, 'metadata', 11, 700, MUTED)
    if var == 'a':
        window(s, ax, ay, aw, ah, 'app', 'ISMS web app')
        text(s, ax + 16, ay + 50, 'Calendar', 13, 700, INK, 'start')
        gy = ay + 64
    else:
        window(s, ax, ay, aw, ah, 'app', 'Calendar')
        gy = ay + 40
    gx, cs = ax + 16, 26.4
    marks = {(1, 1): 'mark', (3, 2): 'doc', (5, 3): 'mark', (2, 4): 'doc', (6, 0): 'mark', (4, 5): 'mark'}
    nrows = 6 if var == 'b' else 6
    rowh = 28 if var == 'a' else 31
    for r in range(nrows):
        for c in range(7):
            x, y = gx + c * cs, gy + r * rowh
            k = marks.get((c, r))
            fill = s.grad(k) if k else '#f1f2f4'
            s.add(f'<rect x="{r1(x)}" y="{r1(y)}" width="{r1(cs - 5)}" height="{rowh - 5}" rx="5" fill="{fill}"/>')
    if var == 'b':
        caption(s, ax + aw / 2, ay + ah + 26, 'ISMS web app')
        ly = ay + ah + 38
    else:
        ly = ay + ah + 16
    lx = ax + 30
    for key, label in (('mark', 'SOP run'), ('doc', 'Review due')):
        s.add(f'<rect x="{lx}" y="{ly}" width="14" height="14" rx="3" fill="{s.grad(key)}"/>')
        text(s, lx + 20, ly + 12, label, 12, 400, MUTED, 'start')
        lx += 96
    for i, role in enumerate(['Responsible', 'Accountable', 'Informed']):
        y = 84 + i * 90
        arrow(s, [(ax + aw + 8, 170), (674, y)], FLAT['app'], 2.2)
        sym_envelope(s, 694, y, 15, WHITE, FLAT['app'])
        person(s, 750, y - 16, None, 0.95)
        text(s, 750, y + 46, role, 12, 700, INK)
    out(s, 'calendar', var, 'isms-review-calendar')


# =================================================================================================
# 6. Publishing: Content Fusion -> OPE -> content delivery server -> HTML (people) + LLMS.txt (agents)
# =================================================================================================
PUB_DESC = ('Content Fusion runs a publishing pipeline with Oxygen Publishing Engine. The results go to a content '
            'delivery server, both as HTML pages for people and as an LLMS.txt file set for AI agents.')


def pub_outputs(s, x, cy_top, cy_bot, src):
    sx, sy = src
    arrow(s, [(sx, sy), (sx + 26, sy), (sx + 26, cy_top), (x - 8, cy_top)], MUTED, 2.5)
    arrow(s, [(sx + 26, sy), (sx + 26, cy_bot), (x - 8, cy_bot)], MUTED, 2.5)
    # HTML for people
    window(s, x, cy_top - 42, 120, 84, 'git')
    bars(s, x + 12, cy_top - 6, [80, 96, 64], gap=12, h=6)
    person(s, x + 168, cy_top - 14, None, 1)
    caption(s, x + 92, cy_top + 64, 'HTML for people')
    # LLMS.txt for agents
    file_icon(s, x + 28, cy_bot - 44, 66, 88, label='TXT', key='git')
    robot(s, x + 168, cy_bot + 2, 1)
    caption(s, x + 92, cy_bot + 66, 'LLMS.txt for agents')


def fig_publish(var):
    s = Svg(f'isms-publish-{var}', 800, 340, 'Publishing for people and for AI agents', PUB_DESC)
    if var == 'a':
        cy = 150
        logo(s, 'cf', 40, cy - 32, 64)
        caption(s, 72, cy + 58, 'Content Fusion')
        arrow(s, [(114, cy), (170, cy)], MUTED, 2.5)
        logo(s, 'ope', 180, cy - 32, 64)
        caption(s, 212, cy + 58, 'Publishing', None)
        text(s, 212, cy + 75, 'Engine (OPE)', 14, 700)
        arrow(s, [(254, cy), (316, cy)], MUTED, 2.5)
        server(s, 364, cy)
        caption(s, 364, cy + 72, 'Content delivery', None)
        text(s, 364, cy + 89, 'server', 14, 700)
        pub_outputs(s, 520, 70, 238, (412, cy))
    else:
        cy = 150
        s.add(f'<rect x="24" y="{cy - 92}" width="272" height="184" rx="14" fill="none" stroke="{KEYBAR}" '
              f'stroke-width="1.5" stroke-dasharray="6 5"/>')
        logo(s, 'cf', 38, cy - 82, 36)
        text(s, 82, cy - 58, 'Content Fusion', 15, 700, INK, 'start')
        repo(s, 92, cy + 18, 64, 70)
        text(s, 92, cy + 74, 'DITA project', 12, 700, INK)
        arrow(s, [(130, cy + 18), (180, cy + 18)], MUTED, 2.5)
        logo(s, 'ope', 190, cy - 12, 60)
        text(s, 220, cy + 74, 'OPE pipeline', 12, 700, INK)
        arrow(s, [(304, cy + 18), (360, cy + 18)], MUTED, 2.5)
        server(s, 408, cy + 18)
        caption(s, 408, cy + 90, 'Content delivery', None)
        text(s, 408, cy + 107, 'server', 14, 700)
        pub_outputs(s, 536, 78, 246, (456, cy + 18))
    out(s, 'publish', var, 'isms-publishing')


for v in ('a', 'b'):
    fig_assets(v)
    fig_raci(v)
    fig_ai(v)
    fig_push(v)
    fig_calendar(v)
    fig_publish(v)
print('ok')
