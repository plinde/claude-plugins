---
name: pdf
description: Generate nicely formatted PDFs from markdown files or conversation context. Uses pandoc for markdown-to-HTML conversion and headless Chrome for HTML-to-PDF rendering. Produces styled, print-quality output.
triggers:
  - pdf
  - generate pdf
  - export pdf
  - markdown to pdf
  - create pdf
  - save as pdf
---

# PDF Generator

Convert markdown files or conversation context into styled, print-quality PDFs using pandoc + headless Chrome.

## Prerequisites

```bash
# Required
pandoc --version    # brew install pandoc
# Chrome must be installed at the standard macOS path
ls "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
```

## Accepted Inputs

| Input | Example | Behavior |
|-------|---------|----------|
| Markdown file path | `/pdf report.md` | Convert the file to PDF |
| No argument | `/pdf` | Generate PDF from current conversation summary |
| Topic description | `/pdf "EKS ownership findings"` | Summarize that topic from conversation into a PDF |

## Workflow

### Step 1: Prepare Markdown

If a markdown file is provided, use it directly. Otherwise, generate markdown content from the conversation context.

**Content rules:**
- Remove all `<details><summary>` wrappers — they render collapsed and unclickable in PDF. Replace with `####` headings.
- Ensure blank lines before lists (pandoc requirement).
- Use GFM tables, fenced code blocks.
- Add YAML frontmatter for title/date if not present.

### Step 2: Convert Markdown to Styled HTML

```bash
pandoc -f gfm -s -H <(cat << 'STYLE'
<style>
body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;max-width:800px;margin:0 auto;padding:2em;line-height:1.6;color:#333}
h1{border-bottom:2px solid #333;padding-bottom:0.3em}
h2{border-bottom:1px solid #ccc;padding-bottom:0.2em;margin-top:1.5em}
h3{margin-top:1.2em}
h4{margin-top:1em;color:#555}
ul,ol{margin:0.5em 0 0.5em 1.5em;padding-left:1em}
ul{list-style-type:disc}ol{list-style-type:decimal}
li{margin:0.3em 0}ul ul,ol ul{list-style-type:circle;margin:0.2em 0 0.2em 1em}
table{border-collapse:collapse;width:100%;margin:1em 0}
th,td{border:1px solid #ddd;padding:8px;text-align:left}
th{background-color:#f5f5f5;font-weight:600}
tr:nth-child(even){background-color:#fafafa}
code{background-color:#f4f4f4;padding:2px 6px;border-radius:3px;font-size:0.9em}
pre{background-color:#f4f4f4;padding:1em;overflow-x:auto;border-radius:5px}
pre code{background:none;padding:0}
blockquote{border-left:4px solid #ddd;margin:1em 0;padding-left:1em;color:#666}
a{color:#0366d6;text-decoration:none}
a:hover{text-decoration:underline}
hr{border:none;border-top:1px solid #ddd;margin:2em 0}
@media print{body{max-width:none;padding:1em}a{color:#333}a[href]:after{content:none}}
</style>
STYLE
) --metadata title="TITLE_HERE" input.md -o /tmp/pdf-output.html
```

### Step 3: Convert HTML to PDF via Headless Chrome

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless --disable-gpu --no-sandbox \
  --print-to-pdf=/tmp/pdf-output.pdf \
  --print-to-pdf-no-header \
  /tmp/pdf-output.html
```

### Step 4: Deliver

Copy the PDF to `~/Downloads/` (or user-specified location) and report the path + file size.

```bash
cp /tmp/pdf-output.pdf ~/Downloads/output.pdf
ls -lh ~/Downloads/output.pdf
```

## Output Location

Default: `~/Downloads/<filename>.pdf`

If the user specifies a path, use that instead. The HTML intermediate file is kept at `/tmp/` for debugging.

## Naming Convention

| Input | Output Filename |
|-------|----------------|
| `report.md` | `report.pdf` |
| Conversation summary about "EKS clusters" | `eks-clusters.pdf` |
| No clear topic | `claude-output-YYYYMMDD.pdf` |

## Common Options

These can be requested by the user:

| Option | How to Apply |
|--------|-------------|
| Table of contents | Add `--toc --toc-depth=2` to the pandoc command |
| Custom title | Set `--metadata title="..."` |
| Landscape | Add `@page{size:landscape}` to the CSS `@media print` block |
| Narrow margins | Adjust `padding` in body CSS or add `--margin-top=10 --margin-bottom=10` to Chrome flags |
| Both HTML and PDF | Keep both files, copy both to destination |

## Troubleshooting

### Tables clipped on right edge
Add `table{font-size:0.85em}` to the CSS or reduce `max-width` on body.

### Code blocks overflow
The CSS includes `overflow-x:auto` on `pre`. For print, long lines will wrap. If critical, add `pre{white-space:pre-wrap;word-break:break-all}` to the print media query.

### Chrome not found
Fall back to the manual browser approach:
```bash
open /tmp/pdf-output.html
# Then Cmd+P > Save as PDF in browser
```

### Blank PDF
Check that the HTML file has content: `wc -l /tmp/pdf-output.html`. If empty, the pandoc conversion failed — check for markdown syntax issues.

## Why Not LaTeX?

LaTeX-based PDF (`pandoc input.md -o output.pdf`) strips all CSS styling, produces plain academic-looking output, and struggles with complex tables and Unicode. Headless Chrome preserves the exact browser rendering — styled tables, colors, code highlighting, fonts.

Use LaTeX only when Chrome is unavailable or when you need LaTeX-specific features (math equations, academic citation formatting).

## Related Skills

| Skill | Relationship |
|-------|-------------|
| `/pandoc` | Parent skill — full pandoc reference including DOCX, HTML, LaTeX conversions |
| `/marp` | Slide deck generation from markdown (presentation format, not document format) |
