# Colour schemes for the blog diagrams

Three layers: the scheme the diagrams actually use (start here), the Oxygen / Content Fusion colours it
comes from, and how to measure new references (website CSS, brochures).

## 1. The diagram scheme (default, grayscale + one accent)

The generator's defaults (`images/isms/src/generate-figures.py`, the `GRAD` / `FLAT` tables). Gradients go
top → bottom; outlines and text are flat.

| Role | Colour | Contrast on white | Notes |
|---|---|---|---|
| Text, captions | `#312e2f` | 13.4:1 | brochure body text |
| Subcaptions, arrows | `#5e6573` | 5.9:1 | was `#6f7a93` (4.3:1), too light for 12 px text |
| Outlines of documents/boxes | `#a7adb8` | 2.3:1 | lines only, never text |
| Text bars inside documents | `#dcdcdc`, key bars `#a7adb8` | | |
| Slate (Git, servers, window bars) | `#5e6573 → #434850` | | |
| Gray tags, document tags | `#8e949e → #767c86` | | |
| Light gray (a second system, the ticketing) | `#a3a9b3 → #868c96` | | keeps two systems apart |
| People | `#7d879d → #6f7a93` | | |
| **Accent**, teal: success, approval, the one item that matters | fill `#149aa6 → #01929e`, **text `#017f8a`** | fill 3.75:1, text 4.8:1 | the only hue apart from threats and logos |
| Threat (attacks) | `#8c2f2a` flat (dark brick red) | 8.2:1 | red is reserved for danger; the brighter `#ba2b25` looked too loud |
| Official logos | their own colours | | never recoloured |

Rules:

- **Neutrals plus one accent** per set; red only for threats. A blind A/B test chose this over the CF
  feature colours, which "meant nothing across figures and competed with the logos".
- The accent must not be a logo colour that appears in the same set: teal stays clear of Content Fusion
  red, OPE green and Positron blue. If a post is about a product, its own logo colour can become the
  accent, as long as no other logo in the set shares it.
- Text needs **4.5:1** on white (WCAG AA). Check with the snippet at the end. An accent that fails as text
  (teal `#01929e`) gets a darker text variant.
- Flat fills for big shapes. A strong gradient on a large shape (the first attack arrow) looks heavy and
  out of style.

The `--color` switch maps the same roles to the CF feature colours (documents orange, app teal, ticketing
purple, validation green, controls blue). Use it only when a post needs colour coding that the labels
can't carry.

## 2. Where the colours come from

### Content Fusion brochure 2026 (CF-9386)

Measured from `Brosura_Content_Fusion_2026_v3 3.pdf` (attached to CF-9386). The full table, with the
product logo colours and the per-product site palettes, is the content-fusion `vector-images` skill's
`palette.md` (`/d/projects/content-fusion/.agents/skills/vector-images/palette.md`). The essentials:

| Role | Hex |
|---|---|
| Ink | `#312e2f` |
| Light gray (device frames) | `#c9c8c8` |
| Sky panel / cloud | `#e8f6fe` / `#b8def6` |
| Warm paper (bands) | `#faf7f3` |
| CF red (logo tile) | `#db4a2e → #ba2b25` |
| Structured Content Management (orange) | `#f8a11b → #ed8522` |
| AI-Powered Editing (blue) | `#346eb6 → #2c67b1` |
| Collaborative Reviews (purple) | `#7e60a9` |
| Automated Publishing (teal) | `#149aa6 → #01929e` |
| AI Translations (green) | `#689c4f → #5f9247` |

### Brochures 2024 on the website

Full-size PNGs in the website sources (`/d/projects/oxygen-xml-website-sources/img/Brochure_*_2024.png`,
also on `https://www.oxygenxml.com/img/`). Each one is white, near-black text `#322f31`, and **one product
colour**, which is the same pattern as the diagrams:

| Brochure | Main colours (FlatColors, most used first, white omitted) |
|---|---|
| Content Fusion 2024 | `#e33f28` red, `#322f31` ink, `#b7d7f1` pale blue, `#939598` gray, `#eff9fe` sky |
| AI Positron 2024 | `#322f31` ink, `#0097d8` / `#086ba6` blues |
| DITA products 2024 | `#007daf` blue, `#322f31` ink, `#378fbb` / `#6ea3c9` / `#9cbcd9` blue tints, `#ee3124` red |

Others in the same folder: XML Editor flyer, Developer/Author, JSON Developer, Web Author, WebHelp,
Chemistry, Feedback, Author DITA Review.

### Website CSS

`/d/projects/oxygen-xml-website-sources/css/oxygen-main.css` (live: `https://www.oxygenxml.com/css/oxygen-main.css`)
defines the site's design tokens:

| Token | Value |
|---|---|
| `--cl-text` / `--cl-strong` / `--cl-muted` | `#333` / `#222` / `#555` |
| `--cl-border` / `--cl-panel` / `--cl-panel-border` | `#e2e2e2` / `#f6f6f6` / `#dadada` |
| `--cl-accent` | `rgb(84 128 176)` (`#5480b0`) |
| `--slate-50 … --slate-700` | `#f8fafc`, `#f1f5f9`, `#e2e8f0`, `#94a3b8`, `#64748b`, `#475569`, `#334155` |
| `--blue-600` | `#2563eb` |

Besides grays, the most used hues in that file are the link and header blues `#2766b8`, `#336699`,
`#1860a8`, `#2670bb`, the CF / Author product red `#a6402b`, and orange `#d9891f`.

## 3. Measuring a new reference

If it is not clear which reference the scheme should follow, **ask the user first**: a brochure (and
which one), or a web page / image. Then measure that one.

- **Website CSS:** `python3 .claude/skills/blog-diagrams/scripts/site-colors.py [--top N] <css file or URL>`
  lists the custom properties and the most used colours, with grays marked.
- **Brochure PNGs, screenshots:** the content-fusion `vector-images` skill's `FlatColors.java`:
  ```bash
  java -cp "/d/projects/oxygen/lib/*" /d/projects/content-fusion/.agents/skills/vector-images/scripts/FlatColors.java \
    --top 12 /d/projects/oxygen-xml-website-sources/img/Brochure_Content_Fusion_2024.png
  ```
- **Brochure PDFs:** turn the pages into PNGs with `PdfPages.java` (same folder), then FlatColors. PDFs
  attached to Jira come through the gateway's `jira_get_attachment_content` (base64). Direct `jira.sync.ro`
  downloads are blocked by the firewall.
- Measure, don't guess from how a colour looks; then check text contrast:
  ```bash
  python3 -c "
  def L(h):
      c = [int(h[i:i+2], 16) / 255 for i in (1, 3, 5)]
      c = [x / 12.92 if x <= 0.03928 else ((x + 0.055) / 1.055) ** 2.4 for x in c]
      return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2]
  import sys; [print(h, round(1.05 / (L(h) + 0.05), 2)) for h in sys.argv[1:]]" '#5e6573' '#017f8a'
  ```
