---
name: blog-diagrams
description: Use when a blog topic needs schematic figures (placeholders like "[graphic showing ...]" in a DITA topic), or when changing the existing ones in images/<post>/. Covers the house style of the blog diagrams (grayscale + one teal accent, official Oxygen logos, document/repo/app/person primitives), colour schemes and where they come from (CF brochures, website CSS, product colours, text contrast), the Python generator to start from, wiring the SVGs into the topic, Chrome rendering and layout checks, and blind A/B tests with subagents to choose between layout variants. Screenshots are not covered.
---

# Schematic diagrams for blog posts

The blog is published as **Oxygen WebHelp**, so Chrome is the reference renderer. Batik compatibility is not
needed (Oxygen's Author mode may show some details differently; that's fine).

The reference set is the ISO 27001 ISMS post (`topics/iso-27001-isms-documentation-how-we-dit-it.dita`,
figures in `images/isms/`). Its generator, `images/isms/src/generate-figures.py`, holds every primitive
below; copy it to `images/<post>/src/` and replace the `fig_*` functions instead of starting from scratch.

## What the author wants

- **Very schematic.** One idea per figure, taken from the paragraph next to the placeholder. Group
  things: one "Attacks" arrow, not three; one card with two people, not a row of icons.
- **Few colours.** Grayscale, plus **one accent** (teal `#149aa6 → #01929e`, text `#017f8a`) for
  success and emphasis: Schematron checks, an "approved" arrow, the one calendar entry type that
  matters. Dark red (flat `#8c2f2a`) only for threats. Official logos keep their brand colours, and those plus
  the accent are the only colour on the page. A blind A/B test preferred this to the Content Fusion
  feature colours (five hues that meant nothing across figures and competed with the logos). The
  full scheme, the CF brochure, website CSS and product colours it comes from, the 4.5:1 text contrast
  rule and how to measure new references are in [palette.md](palette.md).
- **When the colour scheme is uncertain, ask before measuring.** A new post (another product, another
  audience) or a request like "use the CF colours" can mean several references. Ask the user where to
  take the scheme from: a **brochure** (which one: the CF 2026 PDF on CF-9386, a 2024 brochure from the
  website sources), or a **web page or image** (a product page, the site CSS, a screenshot they give).
  Don't pick one silently.
- **No background panel.** The figure sits on the white page. A dashed outline box with a product logo
  and name in its top-left corner shows that something happens *inside* a product (the OPE
  pipeline in Content Fusion, the AI review loop in Content Fusion). Use the same box everywhere.
- **Documents in normal (portrait) proportions** with the same folded corner (14 px) on every document,
  whatever its size. A small captioned table ("RACI") or a tag ("SOP", "POL", "SoA", "TXT") says what
  kind of document it is. No decorations inside (no arrows on table rows).
- **Label applications explicitly**: the window title bar names the app ("ISMS web app"), and a
  heading inside names the page ("Calendar").
- **Use the real products' logos** where a product is named (see Resources), never a generic drawing.
- Short text labels are fine (unlike the CF card artwork): a bold caption (14 px, 700) and an
  optional subcaption (12 px, `#5e6573`). Use weights 400/700 only.

## The kit (in the generator)

| Primitive | Function | Notes |
|---|---|---|
| Document | `page`, `file_icon`, `stack` | white, stroke `#a7adb8` 1.5, fold 14, gray text bars |
| Tag | `tag` | gradient tile, white bold 11 px text |
| Git repository | `repo` | slate cylinder with a white branch symbol |
| App window | `window(..., title=)` | rounded window, coloured title bar with three dots and the app name |
| Server | `server` | three slate units with a green LED |
| Person / AI agent | `person`, `robot` | gray people; the robot is the "AI agent" |
| Badge | `badge(..., sym_check)` | gradient circle, white ring and symbol |
| Arrows | `arrow`, `curve`, `arc_arrow`, `head` | stroke `#5e6573` 2.5, filled triangle head; dashed for lookups |
| Logo | `logo(s, 'cf' / 'ope' / 'positron', x, y, size)` | inlines the official logo, see below |

Canvas: `viewBox="0 0 800 H"`, H around 300–370. Keep every shape, stroke included, ≥ 10 px inside
the canvas: a border on the edge is half clipped and looks thinner than the others. Keep labels
≥ 6 px away from box borders and arrows.

The generator writes `<name>.svg` for the chosen layout of each figure, `--variants` writes
`<name>-a.svg` / `<name>-b.svg` for A/B tests, `--pick=fig:b,...` changes the choice and `--color`
switches to the Content Fusion feature colours (documents orange, app teal, ticketing purple...).

## Resources

- Official logos: <https://www.oxygenxml.com/oxygen_logos.html> links SVGs under
  `https://www.oxygenxml.com/resellers/resources/` (`OxygenContentFusion_icon_2019.svg`,
  `OxygenOPE_icon_2020.svg`, `OxygenFeedback_icon_2019.svg`, `OxygenXMLWebhelp_icon_2019.svg`,
  `OxygenPDFChemistry_icon_2019.svg`, ...). **AI Positron is not on that page**; the site only has
  `https://www.oxygenxml.com/img/Ai_positron80.png`, embedded as a data URI (sharp up to ~70 px).
  Downloaded copies are in `images/isms/src/logos/`.
- The Illustrator SVGs use `<style>` classes (`.st0`) that clash between two logos inlined in one file.
  `logo()` turns the classes into attributes, prefixes the ids and wraps the logo in a nested
  `<svg viewBox="0 0 50 50">`.
- Colours: [palette.md](palette.md). The brochures are in the website sources
  (`/d/projects/oxygen-xml-website-sources/img/Brochure_*_2024.png`) and the CF 2026 brochure PDF is
  attached to CF-9386. The site's design tokens are in `css/oxygen-main.css` there; read them with
  `scripts/site-colors.py`.
- General SVG rules, `FlatColors.java` and `PdfPages.java`: the `vector-images` skill in the content-fusion
  repo (`/d/projects/content-fusion/.agents/skills/vector-images/`).

## Wiring into the topic

Replace each `<p>[graphic ...]</p>` placeholder with a figure (leave the `[screenshot ...]` ones):

```xml
<fig id="fig_isms_raci_validation">
    <title>Schematron checks metadata and RACI names</title>
    <image href="../images/isms/isms-raci-validation.svg" placement="break" id="image_isms_raci_validation">
        <alt>What the figure shows, in one sentence.</alt>
    </image>
</fig>
```

Each SVG also has its own `<title>` and `<desc>`. Keep them in sync with the figure title and alt text
when the content changes. The topic is often still an untracked draft that the author keeps editing (and
may rename): edit it in place, don't commit it.

## Check

Rendering needs Chrome and Playwright (`npm install -g playwright && npx playwright install --with-deps chrome`;
the FFmpeg download failure is harmless).

```bash
S=.claude/skills/blog-diagrams/scripts
node $S/render.cjs /tmp/set.png 720 images/<post>/*.svg       # as WebHelp shows them; also try 640
node $S/check-layout.cjs images/<post>/*.svg                     # edges, labels on borders, overlaps
```

Read the PNG and look at the whole set together: same fold, strokes, fonts and arrow style everywhere,
nothing faint (light-gray captions, pale draft pages), nothing cramped. `check-layout.cjs` finds the
defects that are easy to miss by eye. Both of these reached the author in the ISMS post: the SoA's
right border clipped by the canvas edge, and the "approved" label sitting on the dashed Content Fusion
border.

## Choosing a layout: blind A/B tests

When there are two reasonable layouts (a circular loop vs. a straight row with a loop back, labels
above vs. below, a wall of labelled bricks vs. a plain wall), build both and let fresh subagents choose:

1. `generate-figures.py <dir> --variants`, then copy each pair to `<fig>-X.svg` / `<fig>-Y.svg` with a
   random A/B → X/Y mapping, kept in a key file. Render each one alone with `render.cjs` and **without
   `--labels`**: file names and empty bands in the picture distract the reviewers.
2. Start one fresh subagent per figure, all at once. Give it the two PNG paths, the **paragraph of the
   post** the figure illustrates, and the **author's brief**. Don't give it your preference. Ask for:

   ```
   WINNER: X or Y
   CONFIDENCE: low / medium / high
   WHY: 2-3 sentences
   ISSUES X: bullet list of concrete defects (or "none")
   ISSUES Y: bullet list of concrete defects (or "none")
   ```

   Judging criteria: which one gets the idea across faster at ~720 px; legibility; balance and clutter;
   anything misleading, cramped, misaligned or broken.
3. Take the winner, then fix the issues listed for it, and any issues listed for the loser that also
   apply. When the winner contradicts the author's brief (they asked for a circular review, the
   rounded loop-back won), keep the brief's intent and tell the author.
4. For a set-wide choice (palette), render the whole set twice and give one subagent both sheets. Ask
   it also for **per-figure exceptions**: in the ISMS post this is where the single teal accent came
   from.

## Workflow notes

- Commit the SVGs and the generator (with its `logos/`) on a feature branch, never the author's draft
  topic. Follow the git rules in memory (local commits only; the author reviews in Eclipse and pushes).
- After each round of the author's feedback: regenerate, render, run `check-layout.cjs`, look, commit.
