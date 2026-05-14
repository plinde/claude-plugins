# pdf

Generate styled PDFs from markdown files or conversation context using pandoc + headless Chrome.

## Requirements

- `pandoc` (`brew install pandoc`)
- Google Chrome (standard macOS install path)

## Usage

```
/pdf                          # PDF from current conversation summary
/pdf report.md                # Convert a specific markdown file
/pdf "topic description"      # Summarize a topic from conversation into PDF
```

Output goes to `~/Downloads/` by default.
