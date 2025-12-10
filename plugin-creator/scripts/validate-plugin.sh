#!/usr/bin/env bash
# validate-plugin.sh - Validate plugin.json against Claude Code schema

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PLUGIN_JSON="${1:-}"

if [[ -z "$PLUGIN_JSON" ]]; then
    echo "Usage: $0 <path-to-plugin.json>"
    exit 1
fi

if [[ ! -f "$PLUGIN_JSON" ]]; then
    echo -e "${RED}❌ File not found: $PLUGIN_JSON${NC}"
    exit 1
fi

echo "Validating: $PLUGIN_JSON"
echo ""

ERRORS=0
WARNINGS=0

# Check if file is valid JSON
if ! jq empty "$PLUGIN_JSON" 2>/dev/null; then
    echo -e "${RED}❌ Invalid JSON syntax${NC}"
    exit 1
fi

# Extract fields
NAME=$(jq -r '.name // empty' "$PLUGIN_JSON")
AUTHOR=$(jq -r '.author // empty' "$PLUGIN_JSON")
AUTHOR_TYPE=$(jq -r '.author | type' "$PLUGIN_JSON" 2>/dev/null || echo "null")
VERSION=$(jq -r '.version // empty' "$PLUGIN_JSON")

# Check required fields
if [[ -z "$NAME" ]]; then
    echo -e "${RED}❌ Missing required field: name${NC}"
    ((ERRORS++))
else
    echo -e "${GREEN}✅ name: $NAME${NC}"
fi

# Check author format
if [[ -n "$AUTHOR" ]]; then
    if [[ "$AUTHOR_TYPE" == "string" ]]; then
        echo -e "${RED}❌ Invalid author format: must be object, not string${NC}"
        echo -e "   Current: \"author\": \"$AUTHOR\""
        echo -e "   Fix: \"author\": {\"name\": \"$AUTHOR\"}"
        ((ERRORS++))
    elif [[ "$AUTHOR_TYPE" == "object" ]]; then
        AUTHOR_NAME=$(jq -r '.author.name // empty' "$PLUGIN_JSON")
        AUTHOR_EMAIL=$(jq -r '.author.email // empty' "$PLUGIN_JSON")
        if [[ -z "$AUTHOR_NAME" ]]; then
            echo -e "${RED}❌ author object missing required 'name' field${NC}"
            ((ERRORS++))
        else
            echo -e "${GREEN}✅ author.name: $AUTHOR_NAME${NC}"
            if [[ -n "$AUTHOR_EMAIL" ]]; then
                echo -e "${GREEN}✅ author.email: $AUTHOR_EMAIL${NC}"
            fi
        fi
    fi
fi

# Check for invalid fields
INVALID_FIELDS=$(jq -r 'keys[] | select(. as $k | ["claudeCode", "tags", "readme"] | index($k))' "$PLUGIN_JSON" 2>/dev/null || true)

if [[ -n "$INVALID_FIELDS" ]]; then
    echo -e "${RED}❌ Invalid fields found:${NC}"
    while IFS= read -r field; do
        echo -e "   - $field"
        case "$field" in
            "tags")
                echo -e "     ${YELLOW}Fix: Use 'keywords' instead of 'tags'${NC}"
                ;;
            "readme")
                echo -e "     ${YELLOW}Fix: Remove 'readme' field (not needed in manifest)${NC}"
                ;;
            "claudeCode")
                echo -e "     ${YELLOW}Fix: Remove 'claudeCode' field (not recognized)${NC}"
                ;;
        esac
        ((ERRORS++))
    done <<< "$INVALID_FIELDS"
fi

# Check valid optional fields
DESCRIPTION=$(jq -r '.description // empty' "$PLUGIN_JSON")
HOMEPAGE=$(jq -r '.homepage // empty' "$PLUGIN_JSON")
REPOSITORY=$(jq -r '.repository // empty' "$PLUGIN_JSON")
LICENSE=$(jq -r '.license // empty' "$PLUGIN_JSON")
KEYWORDS=$(jq -r '.keywords // empty' "$PLUGIN_JSON")

[[ -n "$VERSION" ]] && echo -e "${GREEN}✅ version: $VERSION${NC}"
[[ -n "$DESCRIPTION" ]] && echo -e "${GREEN}✅ description: ${DESCRIPTION:0:60}...${NC}"
[[ -n "$HOMEPAGE" ]] && echo -e "${GREEN}✅ homepage: $HOMEPAGE${NC}"
[[ -n "$REPOSITORY" ]] && echo -e "${GREEN}✅ repository: $REPOSITORY${NC}"
[[ -n "$LICENSE" ]] && echo -e "${GREEN}✅ license: $LICENSE${NC}"

if [[ "$KEYWORDS" != "empty" ]] && [[ -n "$KEYWORDS" ]]; then
    KEYWORD_COUNT=$(jq '.keywords | length' "$PLUGIN_JSON")
    echo -e "${GREEN}✅ keywords: $KEYWORD_COUNT keyword(s)${NC}"
fi

# Warnings
if [[ -z "$VERSION" ]]; then
    echo -e "${YELLOW}⚠️  Warning: Missing 'version' field (recommended)${NC}"
    ((WARNINGS++))
fi

if [[ -z "$DESCRIPTION" ]]; then
    echo -e "${YELLOW}⚠️  Warning: Missing 'description' field (recommended)${NC}"
    ((WARNINGS++))
fi

if [[ -z "$LICENSE" ]]; then
    echo -e "${YELLOW}⚠️  Warning: Missing 'license' field (recommended)${NC}"
    ((WARNINGS++))
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
