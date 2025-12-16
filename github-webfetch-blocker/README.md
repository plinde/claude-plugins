# GitHub WebFetch Blocker Plugin

A Claude Code plugin that prevents WebFetch attempts on GitHub URLs and guides `gh api` usage toward proper CLI subcommands.

## Problem

When Claude Code interacts with GitHub:
1. **WebFetch fails on private repos** - GitHub requires authentication, and WebFetch doesn't have access to credentials
2. **`gh api` bypasses better tools** - Using `gh api repos/owner/repo/pulls/123` when `gh pr view 123` exists wastes the rich subcommand features

## Solution

This plugin intercepts both:
- **WebFetch calls** to GitHub URLs → blocks with `gh` CLI alternatives
- **`gh api repos/...`** calls → suggests proper `gh` subcommands (pr, issue, release, etc.)

## Features

- 🚫 **Blocks WebFetch on GitHub URLs** - Prevents 404 errors on private repos
- 🔄 **Guides gh api → subcommands** - Redirects `gh api repos/...` to proper `gh pr`, `gh issue`, etc.
- ✅ **Smart command suggestions** - Parses URLs/paths and suggests specific gh CLI commands
- 🔒 **Uses authenticated access** - Leverages your existing gh CLI authentication
- 🎯 **Context-aware help** - Different suggestions for PRs, issues, releases, contents, and repos

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

Once installed and enabled, the plugin automatically intercepts:
1. WebFetch calls to GitHub URLs
2. `gh api repos/...` calls that have better subcommand alternatives

### Example: WebFetch Blocking

**Before (fails with 404):**
```
⏺ Fetch(https://github.com/mycompany/myrepo/pull/123/)
  ⎿  Error: Request failed with status code 404
```

**After (blocked with smart suggestions):**
```
⏺ Fetch(https://github.com/mycompany/myrepo/pull/123/)
  ⎿  ❌ BLOCKED: WebFetch on GitHub URLs

  GitHub URLs require authentication and will return 404 errors for private repositories.

  ✅ Use gh CLI instead with authenticated access:

  Suggested commands for this PR:
     gh pr view 123 --repo mycompany/myrepo --json title,body,state,author
     gh pr diff 123 --repo mycompany/myrepo
     gh pr view 123 --repo mycompany/myrepo --comments
```

### Example: gh api → Subcommand Guidance

**Before (works but misses better tooling):**
```
⏺ Bash(gh api repos/mycompany/myrepo/pulls/123)
```

**After (guided to proper subcommand):**
```
⏺ Bash(gh api repos/mycompany/myrepo/pulls/123)
  ⎿  ⚠️  GUIDANCE: Prefer gh CLI subcommands over gh api

  Detected: gh api repos/mycompany/myrepo/pulls/123

  ✅ Use gh pr subcommand instead:

     # View PR details
     gh pr view 123 --repo mycompany/myrepo

     # Get structured JSON output
     gh pr view 123 --repo mycompany/myrepo --json title,body,state,author,comments

     # View PR diff
     gh pr diff 123 --repo mycompany/myrepo

  Why prefer subcommands?
     • Better error handling and user-friendly output
     • Automatic pagination where applicable
     • Structured --json output with --jq filtering
```

### Supported gh api Redirects

| gh api endpoint | Suggested subcommand |
|-----------------|---------------------|
| `repos/O/R/pulls/N` | `gh pr view N --repo O/R` |
| `repos/O/R/pulls` | `gh pr list --repo O/R` |
| `repos/O/R/issues/N` | `gh issue view N --repo O/R` |
| `repos/O/R/issues` | `gh issue list --repo O/R` |
| `repos/O/R/releases` | `gh release list --repo O/R` |
| `repos/O/R/releases/latest` | `gh release view --repo O/R` |
| `repos/O/R/contents/...` | Clone repo + Read tool |
| `repos/O/R/actions/runs` | `gh run list --repo O/R` |
| `repos/O/R/actions/workflows` | `gh workflow list --repo O/R` |
| `repos/O/R` | `gh repo view O/R` |

## How It Works

The plugin registers two PreToolUse hooks:

### WebFetch Hook
1. Intercepts WebFetch tool calls before execution
2. Checks if the URL contains `github.com`
3. If yes:
   - Parses the URL to identify the type (PR, issue, repo, or generic)
   - Extracts owner, repo name, and resource number if applicable
   - Generates specific `gh` CLI commands tailored to that URL
   - Blocks with exit code 1 and shows context-aware suggestions
4. If no: allows WebFetch to proceed normally

### Bash Hook (gh api guidance)
1. Intercepts Bash tool calls before execution
2. Checks if the command contains `gh api repos/...`
3. If yes:
   - Parses the API path to identify the resource type
   - Checks if a proper `gh` subcommand exists for that endpoint
   - If better alternative exists: blocks with suggested subcommand
   - If no better alternative: allows `gh api` to proceed
4. If no: allows Bash command to proceed normally

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
github-webfetch-blocker/
├── .claude-plugin/
│   └── plugin.json                      # Plugin metadata
├── README.md                            # This file
├── LICENSE                              # MIT License
├── hooks/
│   └── hooks.json                       # Hook configuration
└── scripts/
    ├── block-github-webfetch.sh         # WebFetch blocker hook
    └── suggest-gh-subcommands.sh        # gh api → subcommand guidance
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
