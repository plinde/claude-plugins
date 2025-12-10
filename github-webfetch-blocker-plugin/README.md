# GitHub WebFetch Blocker Plugin

A Claude Code plugin that prevents WebFetch attempts on GitHub URLs and redirects to the authenticated gh CLI instead.

## Problem

When Claude Code tries to fetch GitHub URLs using the WebFetch tool, it fails with 404 errors for private repositories because:
- GitHub requires authentication for private repos
- WebFetch doesn't have access to GitHub credentials
- This results in failed attempts and wasted time

## Solution

This plugin intercepts WebFetch calls to GitHub URLs and blocks them before execution, providing helpful guidance to use the gh CLI instead.

## Features

- 🚫 **Blocks WebFetch on GitHub URLs** - Prevents 404 errors on private repos
- ✅ **Provides helpful guidance** - Suggests appropriate gh CLI commands
- 🔒 **Uses authenticated access** - Leverages your existing gh CLI authentication
- 📚 **References github-cli skill** - Points to comprehensive gh CLI patterns

## Installation

### Option 1: Manual Installation (Local Plugin)

1. Clone or download this plugin:
   ```bash
   git clone https://github.com/YOUR_USERNAME/github-webfetch-blocker-plugin.git
   ```

2. Install as a local plugin by symlinking or copying to your Claude Code plugins directory:
   ```bash
   # Create a plugins directory if it doesn't exist
   mkdir -p ~/.claude/plugins

   # Symlink the plugin
   ln -s /path/to/github-webfetch-blocker-plugin ~/.claude/plugins/github-webfetch-blocker
   ```

3. Enable the plugin in your `~/.claude/settings.json`:
   ```json
   {
     "enabledPlugins": {
       "github-webfetch-blocker": true
     }
   }
   ```

### Option 2: Plugin Marketplace (Future)

Once published to a Claude Code plugin marketplace, you can install via:
```bash
claude plugins install github-webfetch-blocker
```

## Usage

Once installed and enabled, the plugin automatically intercepts WebFetch calls to GitHub URLs.

### Example

**Before (fails with 404):**
```
⏺ Fetch(https://github.com/mycompany/myrepo/pull/123/)
  ⎿  Error: Request failed with status code 404
```

**After (blocked with helpful message):**
```
⏺ Fetch(https://github.com/mycompany/myrepo/pull/123/)
  ⎿  ❌ BLOCKED: WebFetch on GitHub URLs

  GitHub URLs require authentication and will return 404 errors for private repositories.

  ✅ Use gh CLI instead:
     - For PR info: gh pr view 123
     - For PR diff: gh pr diff 123
     - For PR comments: gh pr view 123 --comments
     - For repo info: gh repo view mycompany/myrepo
     - For API access: gh api repos/mycompany/myrepo/pulls/123
```

## How It Works

The plugin registers a PreToolUse hook that:
1. Intercepts WebFetch tool calls before execution
2. Checks if the URL contains `github.com`
3. If yes: blocks with exit code 1 and shows helpful message
4. If no: allows WebFetch to proceed normally

## Requirements

- Claude Code v0.1.0 or higher
- `gh` CLI installed and authenticated (for the suggested alternatives)
- `jq` for JSON parsing (used by the hook script)

## Configuration

No additional configuration needed. The plugin works out of the box once enabled.

## Troubleshooting

### Plugin not blocking GitHub URLs

1. Check plugin is enabled in settings:
   ```bash
   cat ~/.claude/settings.json | jq '.enabledPlugins'
   ```

2. Verify hook script is executable:
   ```bash
   ls -l ~/.claude/plugins/github-webfetch-blocker/scripts/block-github-webfetch.sh
   ```

3. Test the hook manually:
   ```bash
   echo '{"tool_name": "WebFetch", "parameters": {"url": "https://github.com/org/repo"}}' | \
     ~/.claude/plugins/github-webfetch-blocker/scripts/block-github-webfetch.sh
   ```

### gh CLI commands not working

Ensure gh CLI is installed and authenticated:
```bash
gh auth status
```

If not authenticated:
```bash
gh auth login
```

## Plugin Structure

```
github-webfetch-blocker-plugin/
├── README.md                           # This file
├── plugin.json                         # Plugin metadata
├── hooks/
│   └── hooks.json                      # Hook configuration
└── scripts/
    └── block-github-webfetch.sh       # Hook script
```

## Contributing

Contributions welcome! Please submit issues and pull requests to the repository.

## License

MIT License - see LICENSE file for details

## Author

Peter Linde

## Related Resources

- [Claude Code Hooks Documentation](https://code.claude.com/docs/en/hooks.md)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Claude Code Plugins](https://code.claude.com/docs/en/plugins.md)
