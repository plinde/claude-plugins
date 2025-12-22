# Markdown Presentation Plugin

Create professional, presenter-friendly markdown and HTML presentations with timing guidance, expandable details, and clean visual hierarchy.

## Features

- **Markdown Presentations** - Slide-like structure using horizontal rules
- **HTML Presentations** - Full CSS control with dark theme templates
- **Timing Annotations** - Help presenters pace themselves
- **Expandable Details** - Hide dense content behind collapsible sections
- **ASCII & HTML Diagrams** - Architecture visualization patterns
- **Quick Reference Cards** - Takeaway summaries for audiences

## Use Cases

- Team onboarding presentations
- Technical architecture overviews
- Knowledge transfer sessions
- Sprint demos or retrospectives
- Any presentation viewed in markdown-capable viewers (GitHub, VS Code, Obsidian)

## Quick Start

### Markdown (for GitHub/GitLab)

```markdown
# My Presentation
## For Target Audience

**Duration:** 15 minutes
**Date:** 2025-12-22

---

## Agenda

1. Introduction (2 min)
2. Architecture (5 min)
3. Demo (5 min)
4. Q&A (3 min)

---

## 1. Introduction

Content here...

<details>
<summary><b>📋 More Details</b></summary>

Hidden details here...

</details>

---

## Questions?

*Created: 2025-12-22*
*Built with [markdown-presentation](https://github.com/plinde/claude-plugins/tree/main/markdown-presentation)*
```

### HTML (for browser viewing)

Use the Tokyo Night-inspired dark theme template:

```css
:root {
    --bg-primary: #1a1b26;
    --text-primary: #c0caf5;
    --accent-blue: #7aa2f7;
    --accent-teal: #73daca;
    --accent-purple: #bb9af7;
}
```

## HTML vs Markdown

| Use Case | Format | Reason |
|----------|--------|--------|
| GitHub/GitLab viewing | Markdown | Native rendering |
| Browser presentations | HTML | Full CSS control |
| Complex diagrams | HTML | Precise alignment |
| Slideshow mode | Markdown + Marp | Better tooling |

## Installation

```bash
claude plugin install markdown-presentation@plinde-plugins
```

## Related Tools

- [Marp](https://marp.app/) - Convert markdown to slides
- [Pandoc](https://pandoc.org/) - Universal document converter

## License

MIT
