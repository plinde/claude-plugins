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
    # Try to parse the URL and provide specific gh command suggestions
    SUGGESTIONS=""

    # Check for pull request URLs
    if [[ "$URL" =~ github\.com/([^/]+)/([^/]+)/pull/([0-9]+) ]]; then
        OWNER="${BASH_REMATCH[1]}"
        REPO="${BASH_REMATCH[2]}"
        PR_NUM="${BASH_REMATCH[3]}"
        SUGGESTIONS="
Suggested commands for this PR:
   gh pr view $PR_NUM --repo $OWNER/$REPO --json title,body,state,author
   gh pr diff $PR_NUM --repo $OWNER/$REPO
   gh pr view $PR_NUM --repo $OWNER/$REPO --comments
   gh api repos/$OWNER/$REPO/pulls/$PR_NUM"

    # Check for issue URLs
    elif [[ "$URL" =~ github\.com/([^/]+)/([^/]+)/issues/([0-9]+) ]]; then
        OWNER="${BASH_REMATCH[1]}"
        REPO="${BASH_REMATCH[2]}"
        ISSUE_NUM="${BASH_REMATCH[3]}"
        SUGGESTIONS="
Suggested commands for this issue:
   gh issue view $ISSUE_NUM --repo $OWNER/$REPO --json title,body,state,author
   gh issue view $ISSUE_NUM --repo $OWNER/$REPO --comments
   gh api repos/$OWNER/$REPO/issues/$ISSUE_NUM"

    # Check for repo URLs
    elif [[ "$URL" =~ github\.com/([^/]+)/([^/]+)(/|$) ]]; then
        OWNER="${BASH_REMATCH[1]}"
        REPO="${BASH_REMATCH[2]}"
        SUGGESTIONS="
Suggested commands for this repository:
   gh repo view $OWNER/$REPO
   gh repo view $OWNER/$REPO --json description,url,defaultBranchRef
   gh api repos/$OWNER/$REPO"

    # Generic GitHub URL
    else
        SUGGESTIONS="
Generic gh CLI commands:
   gh api <endpoint>  # For direct API access
   gh repo view <owner>/<repo>
   gh pr view <number> --repo <owner>/<repo>
   gh issue view <number> --repo <owner>/<repo>"
    fi

    cat <<EOF
❌ BLOCKED: WebFetch on GitHub URLs

GitHub URLs require authentication and will return 404 errors for private repositories.

✅ Use gh CLI instead with authenticated access:
$SUGGESTIONS

Examples:
   # Get JSON output for parsing
   gh pr view 123 --repo owner/repo --json title,body,state,author,comments

   # Get diff for code review
   gh pr diff 123 --repo owner/repo

   # Direct API access for advanced queries
   gh api repos/owner/repo/pulls/123
   gh api repos/owner/repo/pulls/123/files
   gh api repos/owner/repo/pulls/123/comments
EOF
    exit 1
fi

# Allow all other WebFetch calls
exit 0
