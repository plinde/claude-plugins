# Claude Code Plugins

A collection of Claude Code plugins for enhancing functionality and workflow automation.

## Available Plugins

### 🚫 github-webfetch-blocker

Prevents WebFetch attempts on GitHub URLs and redirects to authenticated gh CLI instead.

**Location:** `github-webfetch-blocker-plugin/`

**Purpose:** Blocks WebFetch calls to github.com to prevent 404 errors on private repositories, providing guidance to use gh CLI with proper authentication.

**[Full Documentation →](github-webfetch-blocker-plugin/README.md)**

## Installation

### Prerequisites

- Claude Code v0.1.0 or higher
- Plugin directory: `~/.claude/plugins/`

### Installing Plugins

Each plugin can be installed by symlinking or copying to your Claude Code plugins directory:

```bash
# Create plugins directory if needed
mkdir -p ~/.claude/plugins

# Install github-webfetch-blocker
ln -s /Users/plinde/workspace/github.com/plinde/claude-plugins/github-webfetch-blocker-plugin ~/.claude/plugins/github-webfetch-blocker
```

### Enabling Plugins

Add the plugin to your `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "github-webfetch-blocker": true
  }
}
```

Or use jq to enable programmatically:

```bash
# Enable github-webfetch-blocker
jq '.enabledPlugins["github-webfetch-blocker"] = true' ~/.claude/settings.json > /tmp/settings.json && mv /tmp/settings.json ~/.claude/settings.json
```

### Verifying Installation

```bash
# Check enabled plugins
cat ~/.claude/settings.json | jq '.enabledPlugins'

# Verify symlink
ls -l ~/.claude/plugins/

# Test github-webfetch-blocker hook manually
echo '{"tool_name": "WebFetch", "parameters": {"url": "https://github.com/org/repo"}}' | \
  ~/.claude/plugins/github-webfetch-blocker/scripts/block-github-webfetch.sh
```

## Plugin Structure

```
claude-plugins/
├── README.md                           # This file
└── github-webfetch-blocker-plugin/
    ├── README.md                       # Plugin documentation
    ├── LICENSE                         # MIT License
    ├── plugin.json                     # Plugin metadata
    ├── hooks/
    │   └── hooks.json                  # Hook configuration
    └── scripts/
        └── block-github-webfetch.sh   # Hook implementation
```

## Development

### Creating New Plugins

1. Create a new directory: `<plugin-name>-plugin/`
2. Add required files:
   - `plugin.json` - Plugin metadata
   - `README.md` - Plugin documentation
   - `LICENSE` - License file
   - `hooks/hooks.json` - Hook configuration (if applicable)
   - `scripts/` - Hook scripts or utilities

3. Follow naming conventions:
   - Plugin directories: `<name>-plugin/`
   - Plugin IDs in settings: `<name>` (without -plugin suffix)

### Testing Hooks

Test hook scripts manually before enabling:

```bash
# Example: Test PreToolUse hook
echo '{"tool_name": "ToolName", "parameters": {...}}' | \
  ./plugin-name-plugin/scripts/hook-script.sh

# Check exit code
echo $?
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
