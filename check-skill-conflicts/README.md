# Check Skill Conflicts Plugin

Detect naming conflicts between local Claude Code skills and plugin-provided skills to prevent inconsistent agent behavior.

## Installation

```bash
/plugin install check-skill-conflicts@plinde
```

## Features

- Detect exact name matches between local and plugin skills
- Identify similar names (suffix/prefix variations like `foo` vs `foo-skill`)
- Case-insensitive matching
- JSON output for programmatic use
- Verbose mode to list all skills

## Usage

After installation, the `check-skill-conflicts` skill will be available.

### Quick Check

```bash
# Run conflict check
~/.claude/plugins/marketplaces/plinde-plugins/check-skill-conflicts/skills/check-skill-conflicts/scripts/check-conflicts.sh

# Verbose output (shows all skills found)
~/.claude/plugins/marketplaces/plinde-plugins/check-skill-conflicts/skills/check-skill-conflicts/scripts/check-conflicts.sh --verbose

# JSON output
~/.claude/plugins/marketplaces/plinde-plugins/check-skill-conflicts/skills/check-skill-conflicts/scripts/check-conflicts.sh --json
```

### Sample Output

```
SKILL CONFLICT CHECK
====================

Local Skills:     45 found in ~/.claude/skills/
Plugin Skills:    12 found in ~/.claude/plugins/

EXACT MATCHES (High Priority):
  ⚠️  kyverno-version-lookup
      Local:  ~/.claude/skills/kyverno-version-lookup/
      Plugin: ~/.claude/plugins/marketplaces/plinde-plugins/kyverno-version-lookup/

✅ No conflicts found!  (if none)
```

## Why This Matters

When a skill exists in both `~/.claude/skills/` (local) and `~/.claude/plugins/` (plugin-provided):
- Agents may load the wrong skill version
- Results can be inconsistent between sessions
- Behavior becomes unpredictable when skill names are similar

## Resolution Options

When conflicts are found:

1. **Remove local skill** - If plugin version is preferred
2. **Uninstall plugin** - If local version is preferred
3. **Rename local skill** - If both are needed but different

## Requirements

- Bash 5+ (uses associative arrays)
- `jq` for JSON output mode

## License

MIT
