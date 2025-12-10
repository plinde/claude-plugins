# Plugin Creator

Tools for creating and validating Claude Code plugins and marketplaces with schema compliance checking.

## Features

- ✅ **Validate plugin.json** - Ensures plugin manifests comply with Claude Code schema
- ✅ **Validate marketplace.json** - Ensures marketplace catalogs are well-formed
- ✅ **Detect common errors** - Catches mistakes like author as string, invalid fields
- ✅ **Fix suggestions** - Provides specific remediation guidance
- 📋 **Templates** - Ready-to-use minimal and full manifest examples
- 🎨 **Color-coded output** - Green for valid, red for errors, yellow for warnings

## Installation

### Via Marketplace (Recommended)

```bash
/plugin marketplace add plinde/claude-plugins
/plugin install plugin-creator@plinde-plugins
```

## Usage

### Validation Scripts

After installation, validation scripts are available in the plugin directory:

```bash
# Find plugin installation path
PLUGIN_DIR=$(find ~/.claude/plugins -name "plugin-creator*" -type d | head -n 1)

# Validate a plugin manifest
$PLUGIN_DIR/scripts/validate-plugin.sh path/to/plugin.json

# Validate a marketplace catalog
$PLUGIN_DIR/scripts/validate-marketplace.sh path/to/marketplace.json
```

### Templates

Example templates are in `$PLUGIN_DIR/examples/`:

- `plugin.json.minimal` - Minimal valid plugin manifest
- `plugin.json.full` - Full-featured plugin manifest
- `marketplace.json.minimal` - Minimal marketplace catalog
- `marketplace.json.full` - Full marketplace with multiple plugins

## Validation Rules

### plugin.json Schema

**Required Fields:**
- `name` (string) - Plugin identifier, kebab-case

**Valid Optional Fields:**
- `version` (string) - Semantic version
- `description` (string) - Brief plugin description
- `author` (object) - Must be object with `name`, optionally `email`, `url`
- `homepage` (string) - Plugin homepage URL
- `repository` (string) - Git repository URL
- `license` (string) - License identifier (e.g., "MIT")
- `keywords` (array) - Search keywords

**Invalid Fields (Will Cause Errors):**
- ❌ `claudeCode` - Not recognized
- ❌ `tags` - Use `keywords` instead
- ❌ `readme` - Not needed in manifest
- ❌ `author` as string - Must be object

### Common Errors Fixed

```json
// ❌ WRONG - author as string
{
  "author": "Peter Linde"
}

// ✅ CORRECT - author as object
{
  "author": {
    "name": "Peter Linde",
    "email": "plinde@users.noreply.github.com"
  }
}

// ❌ WRONG - invalid fields
{
  "tags": ["github", "security"],
  "readme": "README.md"
}

// ✅ CORRECT - use keywords
{
  "keywords": ["github", "security"]
}
```

## Creating a New Plugin

### 1. Create directory structure

```bash
mkdir -p my-plugin/.claude-plugin
```

### 2. Create minimal plugin.json

Use the minimal template:

```bash
cat $PLUGIN_DIR/examples/plugin.json.minimal > my-plugin/.claude-plugin/plugin.json
```

Or create from scratch:

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "My plugin description",
  "author": {
    "name": "Your Name"
  },
  "license": "MIT"
}
```

### 3. Add plugin content

Add commands, hooks, agents, etc. as needed:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
├── commands/       # Optional: slash commands
├── hooks/          # Optional: event hooks
├── agents/         # Optional: custom agents
└── scripts/        # Optional: helper scripts
```

### 4. Validate

```bash
$PLUGIN_DIR/scripts/validate-plugin.sh my-plugin/.claude-plugin/plugin.json
```

### 5. Test locally

```bash
/plugin marketplace add ./my-plugin
/plugin install my-plugin@local
```

## Creating a Marketplace

### 1. Create directory structure

```bash
mkdir -p my-marketplace/.claude-plugin
```

### 2. Create marketplace.json

Use the minimal template:

```bash
cat $PLUGIN_DIR/examples/marketplace.json.minimal > my-marketplace/.claude-plugin/marketplace.json
```

### 3. Add plugins

Edit the `plugins` array to include your plugins:

```json
{
  "name": "my-marketplace",
  "owner": {
    "name": "Your Name"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./my-plugin",
      "description": "Plugin description",
      "version": "1.0.0"
    }
  ]
}
```

### 4. Validate

```bash
$PLUGIN_DIR/scripts/validate-marketplace.sh my-marketplace/.claude-plugin/marketplace.json
```

### 5. Test locally

```bash
/plugin marketplace add ./my-marketplace
```

## Validation Output

### Successful Validation

```
Validating: plugin.json

✅ name: my-plugin
✅ author.name: Your Name
✅ version: 1.0.0
✅ description: My plugin description
✅ license: MIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Validation passed!
```

### Failed Validation

```
Validating: plugin.json

✅ name: my-plugin
❌ Invalid author format: must be object, not string
   Current: "author": "Your Name"
   Fix: "author": {"name": "Your Name"}
❌ Invalid fields found:
   - tags
     Fix: Use 'keywords' instead of 'tags'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❌ Validation failed with 2 error(s)
```

## Files Included

```
plugin-creator/
├── .claude-plugin/
│   └── plugin.json
├── scripts/
│   ├── validate-plugin.sh
│   └── validate-marketplace.sh
├── examples/
│   ├── plugin.json.minimal
│   ├── plugin.json.full
│   ├── marketplace.json.minimal
│   └── marketplace.json.full
└── README.md
```

## Requirements

- Claude Code v0.1.0 or higher
- `jq` for JSON parsing

## License

MIT License

## Author

Peter Linde

## Related Resources

- [Claude Code Plugins Documentation](https://code.claude.com/docs/en/plugins.md)
- [Plugin Marketplaces Documentation](https://code.claude.com/docs/en/plugin-marketplaces.md)
- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference.md)
