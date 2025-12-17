# Claude Code Plugins Marketplace

A plugin marketplace for Claude Code with plugins for workflow automation and enhanced functionality.

## Available Plugins

### ⚠️ check-skill-conflicts

Detect naming conflicts between local skills and plugin-provided skills to prevent inconsistent agent behavior

**[Full Documentation →](check-skill-conflicts/README.md)**

### 🚫 github-webfetch-blocker

Blocks WebFetch attempts on GitHub URLs and redirects to gh CLI for authenticated access

**[Full Documentation →](github-webfetch-blocker/README.md)**

### 🔨 hammerspoon

Automate macOS with Hammerspoon Lua scripting. Window management, hotkeys, Spoons, and CLI integration via hs command.

**[Full Documentation →](hammerspoon/README.md)**

### 🔍 kyverno-version-lookup

Query Kyverno Helm chart versions, release dates, and app version mappings from Artifact Hub

**[Full Documentation →](kyverno-version-lookup/README.md)**

### 📄 pandoc

Convert documents between formats (Markdown, DOCX, PDF, HTML, LaTeX) using pandoc. Use for format conversion, document generation, and preparing markdown for Google Docs.

**[Full Documentation →](pandoc/README.md)**

### 🛠️ plugin-creator

Tools for creating and validating Claude Code plugins and marketplaces with schema compliance checking

**[Full Documentation →](plugin-creator/README.md)**

### 🖥️ tmux

Work with tmux terminal multiplexer for session management, window navigation, pane control, and custom workflows like multi-file review.

**[Full Documentation →](tmux/README.md)**

### 🔒 trivy

Scan container images, filesystems, and repositories for vulnerabilities using Trivy. Use for CVE detection, security analysis, vulnerability comparison across image versions, and batch scanning.

**[Full Documentation →](trivy/skills/trivy/SKILL.md)**

## Installation

### Quick Start

Add this marketplace to Claude Code:

```bash
claude plugin marketplace add plinde/claude-plugins
```

Then install plugins:

```bash
# Browse available plugins
claude plugin

# Install a plugin
claude plugin install <plugin-name>@plinde-plugins
```

### Prerequisites

- Claude Code v0.1.0 or higher

### Managing Plugins

```bash
# List installed plugins
claude plugin list

# Disable a plugin (keeps it installed)
claude plugin disable <plugin>@plinde-plugins

# Enable a disabled plugin
claude plugin enable <plugin>@plinde-plugins

# Uninstall a plugin
claude plugin uninstall <plugin>@plinde-plugins

# Update marketplace catalog
claude plugin marketplace update plinde-plugins
```

## Marketplace Structure

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json
├── README.md
├── CLAUDE.md
├── Makefile
├── check-skill-conflicts/
��── .claude-plugin/
��   └── plugin.json
��── README.md
��── skills/check-skill-conflicts/
│       └── SKILL.md
├── github-webfetch-blocker/
��── .claude-plugin/
��   └── plugin.json
��── README.md
├── hammerspoon/
��── .claude-plugin/
��   └── plugin.json
��── README.md
��── skills/hammerspoon/
│       └── SKILL.md
├── kyverno-version-lookup/
��── .claude-plugin/
��   └── plugin.json
��── README.md
��── skills/kyverno-version-lookup/
│       └── SKILL.md
├── pandoc/
��── .claude-plugin/
��   └── plugin.json
��── README.md
��── skills/pandoc/
│       └── SKILL.md
├── plugin-creator/
��── .claude-plugin/
��   └── plugin.json
��── README.md
├── tmux/
��── .claude-plugin/
��   └── plugin.json
��── README.md
��── skills/tmux/
│       └── SKILL.md
└── trivy/
��── .claude-plugin/
��   └── plugin.json
��── skills/trivy/
        └── SKILL.md
```

## Development

### Creating New Plugins

1. Create plugin directory with required structure
2. Add `.claude-plugin/plugin.json` manifest
3. Add `skills/<name>/SKILL.md` or other components
4. **Update this README.md** (required!)
5. Commit and push

### Plugin Structure

```
<plugin-name>/
├── .claude-plugin/
│   └── plugin.json          # Required: Plugin manifest
├── README.md                 # Recommended: Plugin docs
├── skills/<plugin-name>/
│   └── SKILL.md             # Skill definition
├── hooks/
│   └── hooks.json           # Optional: Hook definitions
├── commands/                # Optional: Slash commands
└── scripts/                 # Optional: Helper scripts
```

## Contributing

Contributions welcome! Please:

1. Follow the plugin structure conventions
2. **Update README.md with new plugin entry**
3. Include comprehensive documentation
4. Test before submitting
5. Use semantic commit messages


## License

Each plugin may have its own license. See individual plugin directories for details.

- check-skill-conflicts: MIT License
- github-webfetch-blocker: MIT License
- hammerspoon: MIT License
- kyverno-version-lookup: MIT License
- pandoc: MIT License
- plugin-creator: MIT License
- tmux: MIT License
- trivy: MIT License

## Author

Peter Linde

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Claude Code Plugins Guide](https://docs.anthropic.com/en/docs/claude-code/plugins)
