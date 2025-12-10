#!/usr/bin/env bash
# validate-marketplace.sh - Validate marketplace.json against Claude Code schema

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

MARKETPLACE_JSON="${1:-}"

if [[ -z "$MARKETPLACE_JSON" ]]; then
    echo "Usage: $0 <path-to-marketplace.json>"
    exit 1
fi

if [[ ! -f "$MARKETPLACE_JSON" ]]; then
    echo -e "${RED}❌ File not found: $MARKETPLACE_JSON${NC}"
    exit 1
fi

echo "Validating: $MARKETPLACE_JSON"
echo ""

ERRORS=0
WARNINGS=0

# Check if file is valid JSON
if ! jq empty "$MARKETPLACE_JSON" 2>/dev/null; then
    echo -e "${RED}❌ Invalid JSON syntax${NC}"
    exit 1
fi

# Extract required fields
NAME=$(jq -r '.name // empty' "$MARKETPLACE_JSON")
OWNER=$(jq -r '.owner // empty' "$MARKETPLACE_JSON")
OWNER_TYPE=$(jq -r '.owner | type' "$MARKETPLACE_JSON" 2>/dev/null || echo "null")
PLUGINS=$(jq -r '.plugins // empty' "$MARKETPLACE_JSON")

# Check required fields
if [[ -z "$NAME" ]]; then
    echo -e "${RED}❌ Missing required field: name${NC}"
    ((ERRORS++))
else
    echo -e "${GREEN}✅ name: $NAME${NC}"
fi

# Check owner format
if [[ -z "$OWNER" ]]; then
    echo -e "${RED}❌ Missing required field: owner${NC}"
    ((ERRORS++))
elif [[ "$OWNER_TYPE" != "object" ]]; then
    echo -e "${RED}❌ Invalid owner format: must be object${NC}"
    ((ERRORS++))
else
    OWNER_NAME=$(jq -r '.owner.name // empty' "$MARKETPLACE_JSON")
    OWNER_EMAIL=$(jq -r '.owner.email // empty' "$MARKETPLACE_JSON")
    if [[ -z "$OWNER_NAME" ]]; then
        echo -e "${RED}❌ owner object missing required 'name' field${NC}"
        ((ERRORS++))
    else
        echo -e "${GREEN}✅ owner.name: $OWNER_NAME${NC}"
        if [[ -n "$OWNER_EMAIL" ]]; then
            echo -e "${GREEN}✅ owner.email: $OWNER_EMAIL${NC}"
        fi
    fi
fi

# Check plugins array
if [[ -z "$PLUGINS" ]]; then
    echo -e "${RED}❌ Missing required field: plugins (must be an array)${NC}"
    ((ERRORS++))
else
    PLUGIN_COUNT=$(jq '.plugins | length' "$MARKETPLACE_JSON")
    echo -e "${GREEN}✅ plugins: $PLUGIN_COUNT plugin(s)${NC}"

    # Validate each plugin entry
    for i in $(seq 0 $((PLUGIN_COUNT - 1))); do
        PLUGIN_NAME=$(jq -r ".plugins[$i].name // empty" "$MARKETPLACE_JSON")
        PLUGIN_SOURCE=$(jq -r ".plugins[$i].source // empty" "$MARKETPLACE_JSON")

        echo ""
        echo "Plugin $((i + 1)): $PLUGIN_NAME"

        if [[ -z "$PLUGIN_NAME" ]]; then
            echo -e "${RED}  ❌ Missing required field: name${NC}"
            ((ERRORS++))
        else
            echo -e "${GREEN}  ✅ name: $PLUGIN_NAME${NC}"
        fi

        if [[ -z "$PLUGIN_SOURCE" ]]; then
            echo -e "${RED}  ❌ Missing required field: source${NC}"
            ((ERRORS++))
        else
            SOURCE_TYPE=$(jq -r ".plugins[$i].source | type" "$MARKETPLACE_JSON")
            if [[ "$SOURCE_TYPE" == "string" ]]; then
                echo -e "${GREEN}  ✅ source (path): $PLUGIN_SOURCE${NC}"
            elif [[ "$SOURCE_TYPE" == "object" ]]; then
                SOURCE_KIND=$(jq -r ".plugins[$i].source.source // empty" "$MARKETPLACE_JSON")
                case "$SOURCE_KIND" in
                    "github")
                        REPO=$(jq -r ".plugins[$i].source.repo // empty" "$MARKETPLACE_JSON")
                        echo -e "${GREEN}  ✅ source (github): $REPO${NC}"
                        ;;
                    "url")
                        URL=$(jq -r ".plugins[$i].source.url // empty" "$MARKETPLACE_JSON")
                        echo -e "${GREEN}  ✅ source (git url): $URL${NC}"
                        ;;
                    *)
                        echo -e "${RED}  ❌ Invalid source.source: $SOURCE_KIND${NC}"
                        ((ERRORS++))
                        ;;
                esac
            fi
        fi

        # Check optional fields
        PLUGIN_DESC=$(jq -r ".plugins[$i].description // empty" "$MARKETPLACE_JSON")
        PLUGIN_VERSION=$(jq -r ".plugins[$i].version // empty" "$MARKETPLACE_JSON")

        [[ -n "$PLUGIN_DESC" ]] && echo -e "${GREEN}  ✅ description: ${PLUGIN_DESC:0:50}...${NC}"
        [[ -n "$PLUGIN_VERSION" ]] && echo -e "${GREEN}  ✅ version: $PLUGIN_VERSION${NC}"

        if [[ -z "$PLUGIN_VERSION" ]]; then
            echo -e "${YELLOW}  ⚠️  Warning: Missing 'version' (recommended)${NC}"
            ((WARNINGS++))
        fi
    done
fi

# Check optional metadata
METADATA=$(jq -r '.metadata // empty' "$MARKETPLACE_JSON")
if [[ -n "$METADATA" ]]; then
    echo ""
    echo "Metadata:"
    jq -r '.metadata | to_entries[] | "  ✅ \(.key): \(.value)"' "$MARKETPLACE_JSON"
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $ERRORS -eq 0 ]]; then
    echo -e "${GREEN}✅ Validation passed!${NC}"
    if [[ $WARNINGS -gt 0 ]]; then
        echo -e "${YELLOW}⚠️  $WARNINGS warning(s)${NC}"
    fi
    exit 0
else
    echo -e "${RED}❌ Validation failed with $ERRORS error(s)${NC}"
    if [[ $WARNINGS -gt 0 ]]; then
        echo -e "${YELLOW}⚠️  $WARNINGS warning(s)${NC}"
    fi
    exit 1
fi
