# Claude Code Plugins Marketplace

A plugin marketplace for Claude Code with plugins for workflow automation and enhanced functionality.

## Available Plugins

### 🚫 github-webfetch-blocker

Prevents WebFetch attempts on GitHub URLs and redirects to authenticated gh CLI instead.

**Purpose:** Blocks WebFetch calls to github.com to prevent 404 errors on private repositories, providing guidance to use gh CLI with proper authentication.

**[Full Documentation →](github-webfetch-blocker/README.md)**

### 🛠️ plugin-creator

Tools for creating and validating Claude Code plugins and marketplaces.

**Purpose:** Provides validation scripts, templates, and tools for building Claude Code plugins with schema compliance checking. Includes validators for plugin.json and marketplace.json manifests.

**[Full Documentation →](plugin-creator/README.md)**

## Installation

### Quick Start

Add this marketplace to Claude Code:

```bash
/plugin marketplace add plinde/claude-plugins
```

Then install plugins:

```bash
# Browse available plugins
/plugin

# Install github-webfetch-blocker
/plugin install github-webfetch-blocker@plinde-plugins
```

### Prerequisites

- Claude Code v0.1.0 or higher

### Step-by-Step Installation

1. **Add the marketplace** (one-time setup):
   ```bash
   /plugin marketplace add plinde/claude-plugins
   ```

2. **Browse available plugins**:
   ```bash
   /plugin
   ```
   This opens an interactive browser to explore plugins.

3. **Install a plugin**:
   ```bash
   /plugin install github-webfetch-blocker@plinde-plugins
   ```

4. **The plugin is automatically enabled**. To verify:
   ```bash
   /plugin list
   ```

### Managing Plugins

```bash
# List installed plugins
/plugin list

# Disable a plugin (keeps it installed)
/plugin disable github-webfetch-blocker@plinde-plugins

# Enable a disabled plugin
/plugin enable github-webfetch-blocker@plinde-plugins

# Uninstall a plugin
/plugin uninstall github-webfetch-blocker@plinde-plugins

# Update marketplace catalog
/plugin marketplace update plinde-plugins

# Remove marketplace
/plugin marketplace remove plinde-plugins
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
│   └── marketplace.json                # Marketplace definition
├── README.md                           # This file
└── github-webfetch-blocker/
    ├── .claude-plugin/
    │   └── plugin.json                 # Plugin metadata
    ├── README.md                       # Plugin documentation
    ├── LICENSE                         # MIT License
    ├── hooks/
    │   └── hooks.json                  # Hook configuration
    └── scripts/
        └── block-github-webfetch.sh   # Hook implementation
```

## Development

### Testing Locally

Before publishing, test with a local marketplace:

```bash
# Clone the repository
git clone https://github.com/plinde/claude-plugins.git
cd claude-plugins

# Add as local marketplace
/plugin marketplace add .

# Install plugin locally
/plugin install github-webfetch-blocker@plinde-plugins
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
/plugin marketplace add .
/plugin install plugin-name@plinde-plugins
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

## Author

Peter Linde

## Resources

- [Claude Code Documentation](https://code.claude.com/docs/)
- [Claude Code Hooks Documentation](https://code.claude.com/docs/en/hooks.md)
- [GitHub CLI Manual](https://cli.github.com/manual/)
