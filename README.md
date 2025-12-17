# Claude Code Plugins Marketplace

A plugin marketplace for Claude Code with plugins for workflow automation and enhanced functionality.

## Available Plugins

### 🚫 github-webfetch-blocker

Prevents WebFetch attempts on GitHub URLs and guides `gh api` usage toward proper CLI subcommands.

**Purpose:** Blocks WebFetch calls to github.com (which fail on private repos) and intercepts `gh api repos/...` calls to suggest better alternatives like `gh pr view`, `gh issue list`, etc.

**[Full Documentation →](github-webfetch-blocker/README.md)**

### 🛠️ plugin-creator

Tools for creating and validating Claude Code plugins and marketplaces.

**Purpose:** Provides validation scripts, templates, and tools for building Claude Code plugins with schema compliance checking. Includes validators for plugin.json and marketplace.json manifests.

**[Full Documentation →](plugin-creator/README.md)**

### 🔍 kyverno-version-lookup

Query Kyverno Helm chart versions and release information from Artifact Hub.

**Purpose:** Look up Kyverno Helm chart versions, release dates, and app version mappings without leaving Claude Code. Useful for Kubernetes policy management and version planning.

**[Full Documentation →](kyverno-version-lookup/README.md)**

### ⚠️ check-skill-conflicts

Detect naming conflicts between local skills and plugin-provided skills.

**Purpose:** Scans `~/.claude/skills/` and `~/.claude/plugins/` to identify duplicate skill names that could cause inconsistent agent behavior. Helps maintain a clean skills configuration.

**[Full Documentation →](check-skill-conflicts/README.md)**

### 🔒 trivy

Scan container images, filesystems, and repositories for vulnerabilities using Trivy.

**Purpose:** CVE detection, security analysis, vulnerability comparison across image versions, and batch scanning multiple images. Includes helper scripts for version comparison and parallel scanning.

**[Full Documentation →](trivy/skills/trivy/SKILL.md)**

### 🔨 hammerspoon

Automate macOS with Hammerspoon Lua scripting.

**Purpose:** Window management, hotkeys, Spoons (plugins), and CLI integration via `hs` command. Includes configuration patterns for ShiftIt window tiling and IPC setup.

**[Full Documentation →](hammerspoon/skills/hammerspoon/SKILL.md)**

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

# Install github-webfetch-blocker
claude plugin install github-webfetch-blocker@plinde-plugins
```

### Prerequisites

- Claude Code v0.1.0 or higher

### Step-by-Step Installation

1. **Add the marketplace** (one-time setup):
   ```bash
   claude plugin marketplace add plinde/claude-plugins
   ```

2. **Browse available plugins**:
   ```bash
   claude plugin
   ```
   This opens an interactive browser to explore plugins.

3. **Install a plugin**:
   ```bash
   claude plugin install github-webfetch-blocker@plinde-plugins
   ```

4. **The plugin is automatically enabled**. To verify:
   ```bash
   claude plugin list
   ```

### Managing Plugins

```bash
# List installed plugins
claude plugin list

# Disable a plugin (keeps it installed)
claude plugin disable github-webfetch-blocker@plinde-plugins

# Enable a disabled plugin
claude plugin enable github-webfetch-blocker@plinde-plugins

# Uninstall a plugin
claude plugin uninstall github-webfetch-blocker@plinde-plugins

# Update marketplace catalog
claude plugin marketplace update plinde-plugins

# Remove marketplace
claude plugin marketplace remove plinde-plugins
```

### Team Distribution

For team-wide plugin distribution, add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "plinde-plugins": {
      "source": {
        "source": "github",
        "repo": "plinde/claude-plugins"
      }
    }
  },
  "enabledPlugins": {
    "github-webfetch-blocker@plinde-plugins": true
  }
}
```

When team members trust the repository, Claude Code will automatically:
- Add the marketplace
- Install and enable specified plugins

## Marketplace Structure

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json                 # Marketplace definition
├── README.md                            # This file
├── CLAUDE.md                            # Project instructions
├── Makefile                             # Development helpers
├── github-webfetch-blocker/
│   ├── .claude-plugin/
│   │   └── plugin.json                  # Plugin metadata
│   ├── README.md
│   ├── hooks/
│   │   └── hooks.json
│   └── scripts/
│       ├── block-github-webfetch.sh     # WebFetch blocker
│       └── suggest-gh-subcommands.sh    # gh api guidance
├── plugin-creator/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── README.md
│   └── skills/plugin-creator/
│       └── SKILL.md
├── kyverno-version-lookup/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── README.md
│   └── skills/kyverno-version-lookup/
│       └── SKILL.md
├── check-skill-conflicts/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── README.md
│   └── skills/check-skill-conflicts/
│       ├── SKILL.md
│       └── scripts/
│           └── check-conflicts.sh
├── trivy/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   └── skills/trivy/
│       ├── SKILL.md
│       ├── scripts/
│       │   ├── batch_scan.sh
│       │   └── compare_versions.sh
│       └── references/
│           └── output_interpretation.md
└── hammerspoon/
    ├── .claude-plugin/
    │   └── plugin.json
    ├── README.md
    └── skills/hammerspoon/
        └── SKILL.md
```

## Development

### Testing Locally

Before publishing, test with a local marketplace:

```bash
# Clone the repository
git clone https://github.com/plinde/claude-plugins.git
cd claude-plugins

# Add as local marketplace
claude plugin marketplace add .

# Install plugin locally
claude plugin install github-webfetch-blocker@plinde-plugins
```

### Creating New Plugins

1. Create a new directory: `<plugin-name>-plugin/`

2. Create plugin manifest at `.claude-plugin/plugin.json`:
   ```json
   {
     "name": "plugin-name",
     "version": "1.0.0",
     "description": "Plugin description",
     "author": "Your Name",
     "license": "MIT"
   }
   ```

3. Add plugin components:
   - `README.md` - Plugin documentation
   - `LICENSE` - License file
   - `hooks/hooks.json` - Hook configuration (optional)
   - `commands/` - Slash commands (optional)
   - `agents/` - Custom agents (optional)
   - `scripts/` - Supporting scripts

4. Add to marketplace catalog (`.claude-plugin/marketplace.json`):
   ```json
   {
     "plugins": [
       {
         "name": "plugin-name",
         "source": "./plugin-name-plugin",
         "description": "Plugin description",
         "version": "1.0.0"
       }
     ]
   }
   ```

### Testing Plugins

Test hook scripts manually:

```bash
# Test PreToolUse hook
echo '{"tool_name": "ToolName", "parameters": {...}}' | \
  ./plugin-name-plugin/scripts/hook-script.sh

# Check exit code (0 = allow, 1 = block)
echo $?
```

Test via local marketplace:

```bash
claude plugin marketplace add .
claude plugin install plugin-name@plinde-plugins
```

## Contributing

Contributions welcome! Please:

1. Follow the plugin structure conventions
2. Include comprehensive README documentation
3. Test hooks before submitting
4. Use semantic commit messages

## License

Each plugin may have its own license. See individual plugin directories for details.

- github-webfetch-blocker: MIT License
- plugin-creator: MIT License
- kyverno-version-lookup: MIT License
- check-skill-conflicts: MIT License
- trivy: MIT License
- hammerspoon: MIT License

## Author

Peter Linde

## Resources

- [Claude Code Documentation](https://code.claude.com/docs/)
- [Claude Code Hooks Documentation](https://code.claude.com/docs/en/hooks.md)
- [GitHub CLI Manual](https://cli.github.com/manual/)
