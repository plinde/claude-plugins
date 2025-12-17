# Pandoc Plugin

Convert documents between formats using [pandoc](https://pandoc.org/), the universal document converter.

## Features

- **Markdown to Word (.docx)** - Perfect for uploading to Google Docs
- **Markdown to PDF** - Requires LaTeX
- **Markdown to HTML** - Standalone or with custom CSS
- **Word to Markdown** - Extract content from .docx files
- **Many more formats** - EPUB, LaTeX, RST, ODT, RTF, etc.

## Prerequisites

```bash
brew install pandoc
```

## Quick Start

```bash
# Markdown to Word (for Google Docs)
pandoc document.md -o document.docx

# With table of contents
pandoc document.md --toc -o document.docx

# Markdown to PDF (requires LaTeX)
pandoc document.md -o document.pdf
```

## Google Docs Workflow

1. Convert markdown to .docx: `pandoc doc.md -o doc.docx`
2. Upload .docx to Google Drive
3. Right-click → Open with → Google Docs

Google Docs imports .docx well and preserves headings, formatting, tables, and links.

## Installation

```bash
claude plugin install pandoc@plinde-plugins
```

## License

MIT
