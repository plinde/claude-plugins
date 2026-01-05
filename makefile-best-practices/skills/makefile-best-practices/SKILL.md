---
name: makefile-best-practices
description: Best practices for creating self-documenting Makefiles with auto-generated help. Use when creating or modifying Makefiles to ensure they follow conventions for discoverability and maintainability.
license: MIT
---

When creating or modifying Makefiles, follow these principles to ensure they are self-documenting and user-friendly.

## 1. Default Target Must Be `help`

Always set `help` as the default target so users can discover available commands:

```makefile
.DEFAULT_GOAL := help
```

This ensures running `make` without arguments shows available targets instead of executing an arbitrary first target.

## 2. Self-Documenting Help Target

The `help` target should automatically build itself from comments in the Makefile. Use the `##` comment pattern:

```makefile
target-name: ## Description of what this target does
	@command here

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
```

### Pattern Explanation

- `target: ## Description` - The `##` marks the description for that target
- `##@ Section` - Creates optional section headers in the help output
- The `awk` command parses these patterns and formats the output

### Benefits

- Documentation stays with the code
- Adding new targets automatically updates help
- No manual maintenance of help text
- Consistent format across all Makefiles
