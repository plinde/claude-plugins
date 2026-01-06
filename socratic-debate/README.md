# Socratic Debate Plugin

Conduct structured multi-perspective debates using 4 specialized AI subagents to stress-test ideas and reach well-reasoned conclusions.

## Overview

This plugin provides a deliberation framework inspired by Socratic dialogue, where multiple perspectives systematically examine an idea before reaching a verdict. It's particularly useful for:

- Evaluating PR review feedback
- Making architectural decisions
- Weighing technology tradeoffs
- Any situation where "it depends" is the initial answer

## Installation

```bash
claude plugin install socratic-debate@plinde-plugins
```

## Usage

### Command

```bash
/socratic-debate <topic or question>
```

### Examples

```bash
/socratic-debate Should we fix Copilot's suggested change before merging?
/socratic-debate Is it worth refactoring to use dependency injection?
/socratic-debate Should we adopt Kubernetes for this workload?
```

## How It Works

```
Phase 1 (parallel)              Phase 2 (sequential)
┌─────────────────┐
│  FOR Agent      │──┐
└─────────────────┘  │
┌─────────────────┐  │      ┌─────────────────────┐
│  AGAINST Agent  │──┼─────▶│  Scribe/Moderator   │───▶ Final Output
└─────────────────┘  │      └─────────────────────┘
┌─────────────────┐  │
│  NEUTRAL Agent  │──┘
└─────────────────┘
```

### The Four Perspectives

| Agent | Role | Output |
|-------|------|--------|
| **FOR** | Strongest case in favor | 250-400 word argument |
| **AGAINST** | Devil's advocate | 250-400 word counterargument |
| **NEUTRAL** | Objective analyst | Analysis + tradeoffs table |
| **Scribe** | Moderator | Synthesized summary + verdict |

## Output Format

The Scribe/Moderator produces a polished markdown summary:

```markdown
## Socratic Debate Summary

### Topic
[The question being debated]

### FOR (Proponent)
[Key arguments summarized]

### AGAINST (Devil's Advocate)
[Key counterarguments summarized]

### NEUTRAL (Analyst)
[Key tradeoffs identified]

### Points of Agreement
[What all perspectives agreed on]

### Moderator's Verdict
**Recommendation:** accept/reject/modify/defer
**Confidence:** low/medium/high
**Key Factor:** [The decisive consideration]
```

## Contents

```
socratic-debate/
├── plugin.json
├── README.md
├── commands/
│   └── socratic-debate.md    # The /socratic-debate command
└── skills/
    └── socratic-debate/
        └── SKILL.md          # Debate framework and guidelines
```

## Use Cases

### PR Review Deliberation

When evaluating whether to accept reviewer feedback:

```bash
/socratic-debate Should we address the reviewer's suggestion to add error handling?
```

Post the resulting debate summary as a PR comment to document the reasoning.

### Architecture Decision Records

Use the debate output as the "Considered Alternatives" section of an ADR:

```bash
/socratic-debate Should we use event sourcing for the order management system?
```

### Technology Evaluation

When choosing between options:

```bash
/socratic-debate Should we migrate from REST to GraphQL for our mobile API?
```

## License

MIT
