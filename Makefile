# Makefile for claude-plugins marketplace validation

# Path to validation scripts (from plugin-creator plugin)
VALIDATOR_DIR := plugin-creator/scripts
VALIDATE_PLUGIN := $(VALIDATOR_DIR)/validate-plugin.sh
VALIDATE_MARKETPLACE := $(VALIDATOR_DIR)/validate-marketplace.sh

# Marketplace and plugin paths
MARKETPLACE_JSON := .claude-plugin/marketplace.json
PLUGIN_DIRS := $(wildcard */.)
PLUGIN_MANIFESTS := $(wildcard */.claude-plugin/plugin.json)

.PHONY: all
all: validate ## Default target - run all validations

.PHONY: test
test: validate ## Alias for validate target

.PHONY: help
help: ## Show this help message
	@echo "Claude Plugins Marketplace - Available targets:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: validate
validate: validate-marketplace validate-plugins ## Run all validations (marketplace + plugins)
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "✅ All validations passed!"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

.PHONY: validate-marketplace
validate-marketplace: ## Validate marketplace.json
	@echo "Validating marketplace catalog..."
	@$(VALIDATE_MARKETPLACE) $(MARKETPLACE_JSON)

.PHONY: validate-plugins
validate-plugins: ## Validate all plugin.json files
	@echo "Validating plugin manifests..."
	@for manifest in $(PLUGIN_MANIFESTS); do \
		echo ""; \
		$(VALIDATE_PLUGIN) $$manifest || exit 1; \
	done

.PHONY: list-plugins
list-plugins: ## List all plugins in the marketplace
	@echo "Plugins in marketplace:"
	@jq -r '.plugins[] | "  - \(.name) (v\(.version // "unversioned")): \(.description)"' $(MARKETPLACE_JSON)

.PHONY: check-scripts
check-scripts: ## Check if validation scripts are installed
	@echo "Checking for validation scripts..."
	@if [ -x "$(VALIDATE_PLUGIN)" ]; then \
		echo "✅ validate-plugin.sh found"; \
	else \
		echo "❌ validate-plugin.sh not found or not executable"; \
		echo "   Expected at: $(VALIDATE_PLUGIN)"; \
		exit 1; \
	fi
	@if [ -x "$(VALIDATE_MARKETPLACE)" ]; then \
		echo "✅ validate-marketplace.sh found"; \
	else \
		echo "❌ validate-marketplace.sh not found or not executable"; \
		echo "   Expected at: $(VALIDATE_MARKETPLACE)"; \
		exit 1; \
	fi
	@echo "✅ All validation scripts found"

.PHONY: clean
clean: ## Clean temporary files (currently none)
	@echo "Nothing to clean"

.DEFAULT_GOAL := all
