# Makefile for claude-plugins marketplace validation

# Path to validation scripts (from plugin-creator plugin)
VALIDATOR_DIR := $(HOME)/.claude/plugins/marketplaces/plinde-plugins/plugin-creator/scripts
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

.PHONY: status
status: _status-marketplace _status-other-marketplaces _status-our-plugins _status-other-plugins ## Show marketplace and plugin installation status

.PHONY: _status-marketplace
_status-marketplace:
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "This Marketplace (plinde-plugins)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@if claude plugin marketplace list 2>/dev/null | grep -q "plinde-plugins"; then \
		echo "✅ Status: Installed"; \
		claude plugin marketplace list | grep -A1 "plinde-plugins" | tail -1; \
	else \
		echo "❌ Status: Not installed"; \
		echo "   Run 'make install-marketplace' to install"; \
	fi
	@echo ""

.PHONY: _status-other-marketplaces
_status-other-marketplaces:
	@OTHER_MPS=$$(claude plugin marketplace list 2>/dev/null | grep -E '^\s+❯' | awk '{print $$2}' | grep -v '^plinde-plugins$$'); \
	if [ -n "$$OTHER_MPS" ]; then \
		echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
		echo "Other Installed Marketplaces"; \
		echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
		echo "$$OTHER_MPS" | while read mp; do \
			echo "  • $$mp"; \
			claude plugin marketplace list | grep -A1 "$$mp" | tail -1 | sed 's/^/  /'; \
		done; \
		echo ""; \
	fi

.PHONY: _status-our-plugins
_status-our-plugins:
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "Installed Plugins from plinde-plugins"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@PLUGINS=$$(jq -r '.plugins | keys[] | select(endswith("@plinde-plugins"))' ~/.claude/plugins/installed_plugins_v2.json 2>/dev/null); \
	if [ -z "$$PLUGINS" ]; then \
		echo "  (none installed)"; \
	else \
		echo "$$PLUGINS" | while read plugin; do \
			VERSION=$$(jq -r --arg p "$$plugin" '.plugins[$$p][0].version // "unknown"' ~/.claude/plugins/installed_plugins_v2.json 2>/dev/null); \
			PLUGIN_NAME=$$(echo "$$plugin" | sed 's/@plinde-plugins$$//'); \
			echo "  ✅ $$PLUGIN_NAME (v$$VERSION)"; \
		done; \
	fi
	@echo ""

.PHONY: _status-other-plugins
_status-other-plugins:
	@OTHER_PLUGINS=$$(jq -r '.plugins | keys[] | select(endswith("@plinde-plugins") | not)' ~/.claude/plugins/installed_plugins_v2.json 2>/dev/null); \
	if [ -n "$$OTHER_PLUGINS" ]; then \
		echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
		echo "Plugins from Other Marketplaces"; \
		echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
		echo "$$OTHER_PLUGINS" | while read plugin; do \
			VERSION=$$(jq -r --arg p "$$plugin" '.plugins[$$p][0].version // "unknown"' ~/.claude/plugins/installed_plugins_v2.json 2>/dev/null); \
			echo "  • $$plugin (v$$VERSION)"; \
		done; \
		echo ""; \
	fi

.PHONY: install-marketplace
install-marketplace: ## Install this marketplace to Claude Code
	@echo "Installing plinde-plugins marketplace..."
	@claude plugin marketplace add $(CURDIR)
	@echo "✅ Marketplace installed"

.PHONY: install-plugin
install-plugin: ## Install a specific plugin (usage: make install-plugin PLUGIN=plugin-name)
ifndef PLUGIN
	@echo "❌ Error: PLUGIN variable not set"
	@echo "Usage: make install-plugin PLUGIN=plugin-name"
	@echo ""
	@echo "Available plugins:"
	@jq -r '.plugins[] | "  - \(.name)"' $(MARKETPLACE_JSON)
	@exit 1
endif
	@echo "Installing plugin: $(PLUGIN)..."
	@claude plugin install $(PLUGIN)@plinde-plugins
	@echo "✅ Plugin $(PLUGIN) installed"

.PHONY: install-all
install-all: ## Install all plugins from this marketplace
	@echo "Installing all plugins from plinde-plugins marketplace..."
	@jq -r '.plugins[] | .name' $(MARKETPLACE_JSON) | while read plugin; do \
		echo "Installing $$plugin..."; \
		claude plugin install $$plugin@plinde-plugins || exit 1; \
	done
	@echo "✅ All plugins installed"

.PHONY: uninstall-plugin
uninstall-plugin: ## Uninstall a specific plugin (usage: make uninstall-plugin PLUGIN=plugin-name)
ifndef PLUGIN
	@echo "❌ Error: PLUGIN variable not set"
	@echo "Usage: make uninstall-plugin PLUGIN=plugin-name"
	@echo ""
	@echo "Installed plugins from this marketplace:"
	@jq -r '.plugins | keys[] | select(endswith("@plinde-plugins")) | sub("@plinde-plugins$$"; "")' ~/.claude/plugins/installed_plugins_v2.json 2>/dev/null || echo "  (none)"
	@exit 1
endif
	@echo "Uninstalling plugin: $(PLUGIN)..."
	@claude plugin uninstall $(PLUGIN)@plinde-plugins
	@echo "✅ Plugin $(PLUGIN) uninstalled"

.PHONY: uninstall-all-plugins
uninstall-all-plugins: ## Uninstall all plugins from plinde-plugins marketplace
	@echo "Uninstalling all plugins from plinde-plugins marketplace..."
	@PLUGINS=$$(jq -r '.plugins | keys[] | select(endswith("@plinde-plugins"))' ~/.claude/plugins/installed_plugins_v2.json 2>/dev/null); \
	if [ -z "$$PLUGINS" ]; then \
		echo "ℹ️  No plugins installed from this marketplace"; \
	else \
		echo "$$PLUGINS" | while read plugin; do \
			echo "Uninstalling $$plugin..."; \
			claude plugin uninstall $$plugin || exit 1; \
		done; \
		echo "✅ All plugins uninstalled"; \
	fi

.PHONY: uninstall-marketplace
uninstall-marketplace: ## Uninstall this marketplace (only if no plugins installed)
	@PLUGIN_COUNT=$$(jq -r '.plugins | keys[] | select(endswith("@plinde-plugins"))' ~/.claude/plugins/installed_plugins_v2.json 2>/dev/null | wc -l | tr -d ' '); \
	if [ "$$PLUGIN_COUNT" -gt 0 ]; then \
		echo "❌ Cannot remove marketplace: $$PLUGIN_COUNT plugin(s) still installed"; \
		echo ""; \
		echo "Installed plugins:"; \
		jq -r '.plugins | keys[] | select(endswith("@plinde-plugins"))' ~/.claude/plugins/installed_plugins_v2.json 2>/dev/null | sed 's/^/  - /'; \
		echo ""; \
		echo "Run 'make uninstall-all-plugins' first to remove all plugins"; \
		exit 1; \
	else \
		echo "Removing plinde-plugins marketplace..."; \
		claude plugin marketplace remove plinde-plugins; \
		echo "✅ Marketplace removed"; \
	fi

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

.PHONY: lint
lint: ## Run checkmake on this Makefile
	@echo "Running checkmake on Makefile..."
	@checkmake Makefile

.DEFAULT_GOAL := help
