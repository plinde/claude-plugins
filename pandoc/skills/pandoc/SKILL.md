---
name: pandoc
description: This skill should be used when converting documents between formats (Markdown, DOCX, PDF, HTML, LaTeX, etc.) using pandoc. Use for format conversion, document generation, and preparing markdown for Google Docs or other word processors.
---

# Pandoc Document Conversion Skill

Convert documents between formats using pandoc, the universal document converter.

## Prerequisites

```bash
# Check if pandoc is installed
pandoc --version

# Install via Homebrew if needed
brew install pandoc
```

## Common Conversions

### Markdown to Word (.docx)

```bash
# Basic conversion
pandoc input.md -o output.docx

# With table of contents
pandoc input.md --toc -o output.docx

# With custom reference doc (for styling)
pandoc input.md --reference-doc=template.docx -o output.docx

# Standalone with metadata
pandoc input.md -s --metadata title="Document Title" -o output.docx
```

### Markdown to PDF

```bash
# Requires LaTeX (brew install --cask mactex-no-gui)
pandoc input.md -o output.pdf

# With custom margins
pandoc input.md -V geometry:margin=1in -o output.pdf

# Using a different PDF engine
pandoc input.md --pdf-engine=xelatex -o output.pdf
```

### Markdown to HTML

```bash
# Basic HTML
pandoc input.md -o output.html

# Standalone HTML with CSS
pandoc input.md -s -c style.css -o output.html

# Self-contained (embeds images/CSS)
pandoc input.md -s --self-contained -o output.html
```

### Word to Markdown

```bash
# Extract markdown from docx
pandoc input.docx -o output.md

# With ATX-style headers
pandoc input.docx --atx-headers -o output.md
```

## Useful Options

| Option | Description |
|--------|-------------|
| `-s` / `--standalone` | Produce standalone document with header/footer |
| `--toc` | Generate table of contents |
| `--toc-depth=N` | TOC depth (default: 3) |
| `-V key=value` | Set template variable |
| `--metadata key=value` | Set metadata field |
| `--reference-doc=FILE` | Use FILE for styling (docx/odt) |
| `--template=FILE` | Use custom template |
| `--highlight-style=STYLE` | Syntax highlighting (pygments, tango, etc.) |
| `--number-sections` | Number section headings |
| `-f FORMAT` | Input format (if not auto-detected) |
| `-t FORMAT` | Output format (if not auto-detected) |

## Format Identifiers

| Format | Identifier |
|--------|------------|
| Markdown | `markdown`, `gfm` (GitHub), `commonmark` |
| Word | `docx` |
| PDF | `pdf` |
| HTML | `html`, `html5` |
| LaTeX | `latex` |
| RST | `rst` |
| EPUB | `epub` |
| ODT | `odt` |
| RTF | `rtf` |

## Google Docs Workflow

To get markdown into Google Docs with formatting preserved:

```bash
# 1. Convert to docx
pandoc document.md -o document.docx

# 2. Upload to Google Drive
# 3. Right-click > Open with > Google Docs
```

Google Docs imports .docx files well and preserves:
- Headings
- Bold/italic
- Lists (bulleted and numbered)
- Tables
- Links
- Code blocks (as monospace)

## PSI Document Conversion

For PSI documents with tables and complex formatting:

```bash
# Convert PSI markdown to Word
pandoc PSI-document.md \
  --standalone \
  --toc \
  --toc-depth=2 \
  -o PSI-document.docx

# Open for review
open PSI-document.docx
```

## Troubleshooting

### Tables Not Rendering

Pandoc requires proper markdown table syntax:
```markdown
| Header 1 | Header 2 |
|----------|----------|
| Cell 1   | Cell 2   |
```

### Code Blocks Missing Highlighting

Use fenced code blocks with language identifier:
```markdown
```python
def example():
    pass
```
```

### PDF Generation Fails

PDF requires LaTeX. Install with:
```bash
brew install --cask mactex-no-gui
```

Or use HTML as intermediate:
```bash
pandoc input.md -o output.html
# Then print to PDF from browser
```

## Self-Test

```bash
# Verify pandoc installation
pandoc --version | head -1

# Test basic conversion
echo "# Test\n\nHello **world**" | pandoc -f markdown -t html
```
