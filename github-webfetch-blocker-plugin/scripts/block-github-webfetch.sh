#!/usr/bin/env bash
# Hook: block-github-webfetch.sh
# Purpose: Prevent WebFetch on GitHub URLs; redirect to gh CLI instead
# Hook Type: PreToolUse
# Tool Target: WebFetch

set -euo pipefail

# Read tool input JSON from stdin
TOOL_INPUT=$(cat)

# Extract tool name
TOOL_NAME=$(echo "$TOOL_INPUT" | jq -r '.tool_name // empty')

# Only process WebFetch tool calls
if [[ "$TOOL_NAME" != "WebFetch" ]]; then
    exit 0
fi

# Extract URL from parameters
URL=$(echo "$TOOL_INPUT" | jq -r '.parameters.url // empty')

# Check if URL contains github.com
if [[ "$URL" =~ github\.com ]]; then
    cat <<EOF
❌ BLOCKED: WebFetch on GitHub URLs

GitHub URLs require authentication and will return 404 errors for private repositories.

✅ Use gh CLI instead:
   - For PR info: gh pr view <number>
   - For PR diff: gh pr diff <number>
   - For PR comments: gh pr view <number> --comments
   - For repo info: gh repo view <owner>/<repo>
   - For API access: gh api <endpoint>

📚 The github-cli skill provides comprehensive gh CLI patterns.

Use: Skill(skill: "github-cli") or direct gh commands.
EOF
    exit 1
fi

# Allow all other WebFetch calls
exit 0
