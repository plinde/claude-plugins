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

## Audit Mode

When asked to audit a Makefile, check for the following issues and report findings:

### Required
- [ ] `.DEFAULT_GOAL := help` is set
- [ ] `help` target exists
- [ ] `help` target uses the self-documenting awk pattern
- [ ] All targets have `## Description` comments

### Warnings
- [ ] Targets without descriptions (missing `##`)
- [ ] Missing `.PHONY` declarations for non-file targets
- [ ] `help` target is not using `$(MAKEFILE_LIST)` (won't work with includes)

### Report Format

```
Makefile Audit: <path>

PASS: .DEFAULT_GOAL set to help
PASS: help target exists
FAIL: 3 targets missing ## descriptions: build, test, deploy
WARN: Missing .PHONY for: build, test, clean

Summary: 2 passed, 1 failed, 1 warning
```

Provide specific line numbers and suggested fixes for each issue found.
