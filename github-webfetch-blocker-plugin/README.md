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

### Via Marketplace (Recommended)

1. Add the marketplace to Claude Code:
   ```bash
   /plugin marketplace add plinde/claude-plugins
   ```

2. Install the plugin:
   ```bash
   /plugin install github-webfetch-blocker@plinde-plugins
   ```

3. The plugin is automatically enabled. Verify with:
   ```bash
   /plugin list
   ```

### Manual Installation (Development/Testing)

For local development or testing:

1. Clone the marketplace repository:
   ```bash
   git clone https://github.com/plinde/claude-plugins.git
   ```

2. Add as a local marketplace:
   ```bash
   cd claude-plugins
   /plugin marketplace add .
   ```

3. Install the plugin:
   ```bash
   /plugin install github-webfetch-blocker@plinde-plugins
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

1. Check plugin is installed and enabled:
   ```bash
   /plugin list
   ```

2. Verify the plugin in settings:
   ```bash
   cat ~/.claude/settings.json | jq '.enabledPlugins'
   ```

3. Reinstall if needed:
   ```bash
   /plugin uninstall github-webfetch-blocker@plinde-plugins
   /plugin install github-webfetch-blocker@plinde-plugins
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
├── .claude-plugin/
│   └── plugin.json                     # Plugin metadata
├── README.md                           # This file
├── LICENSE                             # MIT License
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
