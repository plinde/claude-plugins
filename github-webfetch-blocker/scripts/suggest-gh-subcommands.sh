#!/usr/bin/env bash
# Hook: suggest-gh-subcommands.sh
# Purpose: Redirect gh api calls to proper gh CLI subcommands
# Hook Type: PreToolUse
# Tool Target: Bash

set -euo pipefail

# Read tool input JSON from stdin
TOOL_INPUT=$(cat)

# Extract tool name
TOOL_NAME=$(echo "$TOOL_INPUT" | jq -r '.tool_name // empty')

# Only process Bash tool calls
if [[ "$TOOL_NAME" != "Bash" ]]; then
    exit 0
fi

# Extract command from parameters
COMMAND=$(echo "$TOOL_INPUT" | jq -r '.parameters.command // empty')

# Check if command contains 'gh api repos/'
if [[ ! "$COMMAND" =~ gh[[:space:]]+api[[:space:]]+(\")?repos/ ]]; then
    exit 0
fi

# Extract the API path - handle both quoted and unquoted
API_PATH=""
if [[ "$COMMAND" =~ gh[[:space:]]+api[[:space:]]+\"([^\"]+)\" ]]; then
    API_PATH="${BASH_REMATCH[1]}"
elif [[ "$COMMAND" =~ gh[[:space:]]+api[[:space:]]+([^[:space:]|]+) ]]; then
    API_PATH="${BASH_REMATCH[1]}"
fi

# If we couldn't extract the path, allow it through
if [[ -z "$API_PATH" ]]; then
    exit 0
fi

# Parse the API path to identify what's being accessed
# Pattern: repos/OWNER/REPO/RESOURCE[/ID][/SUBRESOURCE]

SUGGESTIONS=""
SHOULD_BLOCK=false

# Check for /contents/ - files should be read from local clone
if [[ "$API_PATH" =~ repos/([^/]+)/([^/]+)/contents(/|$) ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    SHOULD_BLOCK=true
    SUGGESTIONS="
🔍 For repository file contents, prefer:

   # Clone the repo locally (if not already cloned)
   gh repo clone $OWNER/$REPO

   # Or view a specific file directly
   gh repo view $OWNER/$REPO --json url

   # For reading files, use Read tool after cloning

   # If you must use API, consider:
   gh api repos/$OWNER/$REPO/contents/PATH --jq '.content' | base64 -d"

# Check for /pulls/NUM - use gh pr view
elif [[ "$API_PATH" =~ repos/([^/]+)/([^/]+)/pulls/([0-9]+)(/|$) ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    PR_NUM="${BASH_REMATCH[3]}"
    SHOULD_BLOCK=true
    SUGGESTIONS="
✅ Use gh pr subcommand instead:

   # View PR details
   gh pr view $PR_NUM --repo $OWNER/$REPO

   # Get structured JSON output
   gh pr view $PR_NUM --repo $OWNER/$REPO --json title,body,state,author,comments

   # View PR diff
   gh pr diff $PR_NUM --repo $OWNER/$REPO

   # List PR files
   gh pr diff $PR_NUM --repo $OWNER/$REPO --name-only"

# Check for /pulls - list PRs
elif [[ "$API_PATH" =~ repos/([^/]+)/([^/]+)/pulls(/)?$ ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    SHOULD_BLOCK=true
    SUGGESTIONS="
✅ Use gh pr subcommand instead:

   # List open PRs
   gh pr list --repo $OWNER/$REPO

   # List with filters
   gh pr list --repo $OWNER/$REPO --state all
   gh pr list --repo $OWNER/$REPO --author @me
   gh pr list --repo $OWNER/$REPO --json number,title,state"

# Check for /issues/NUM - use gh issue view
elif [[ "$API_PATH" =~ repos/([^/]+)/([^/]+)/issues/([0-9]+)(/|$) ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    ISSUE_NUM="${BASH_REMATCH[3]}"
    SHOULD_BLOCK=true
    SUGGESTIONS="
✅ Use gh issue subcommand instead:

   # View issue details
   gh issue view $ISSUE_NUM --repo $OWNER/$REPO

   # Get structured JSON output
   gh issue view $ISSUE_NUM --repo $OWNER/$REPO --json title,body,state,author,comments

   # View issue comments
   gh issue view $ISSUE_NUM --repo $OWNER/$REPO --comments"

# Check for /issues - list issues
elif [[ "$API_PATH" =~ repos/([^/]+)/([^/]+)/issues(/)?$ ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    SHOULD_BLOCK=true
    SUGGESTIONS="
✅ Use gh issue subcommand instead:

   # List open issues
   gh issue list --repo $OWNER/$REPO

   # List with filters
   gh issue list --repo $OWNER/$REPO --state all
   gh issue list --repo $OWNER/$REPO --assignee @me
   gh issue list --repo $OWNER/$REPO --json number,title,state"

# Check for /releases/latest or /releases/NUM
elif [[ "$API_PATH" =~ repos/([^/]+)/([^/]+)/releases/(latest|[0-9]+) ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    SHOULD_BLOCK=true
    SUGGESTIONS="
✅ Use gh release subcommand instead:

   # View latest release
   gh release view --repo $OWNER/$REPO

   # View specific release by tag
   gh release view TAG --repo $OWNER/$REPO

   # Get JSON output
   gh release view --repo $OWNER/$REPO --json tagName,name,body,assets"

# Check for /releases - list releases
elif [[ "$API_PATH" =~ repos/([^/]+)/([^/]+)/releases(/)?$ ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    SHOULD_BLOCK=true
    SUGGESTIONS="
✅ Use gh release subcommand instead:

   # List releases
   gh release list --repo $OWNER/$REPO

   # Limit results
   gh release list --repo $OWNER/$REPO --limit 10"

# Check for /actions/runs - workflow runs
elif [[ "$API_PATH" =~ repos/([^/]+)/([^/]+)/actions/runs ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    SHOULD_BLOCK=true
    SUGGESTIONS="
✅ Use gh run subcommand instead:

   # List workflow runs
   gh run list --repo $OWNER/$REPO

   # View specific run
   gh run view RUN_ID --repo $OWNER/$REPO

   # Watch a run
   gh run watch RUN_ID --repo $OWNER/$REPO"

# Check for /actions/workflows - workflows
elif [[ "$API_PATH" =~ repos/([^/]+)/([^/]+)/actions/workflows ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    SHOULD_BLOCK=true
    SUGGESTIONS="
✅ Use gh workflow subcommand instead:

   # List workflows
   gh workflow list --repo $OWNER/$REPO

   # View workflow
   gh workflow view WORKFLOW --repo $OWNER/$REPO"

# Check for bare repo endpoint
elif [[ "$API_PATH" =~ repos/([^/]+)/([^/]+)$ ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    SHOULD_BLOCK=true
    SUGGESTIONS="
✅ Use gh repo subcommand instead:

   # View repo details
   gh repo view $OWNER/$REPO

   # Get JSON output
   gh repo view $OWNER/$REPO --json description,url,defaultBranchRef,stargazerCount"
fi

# Block if we found a better alternative
if [[ "$SHOULD_BLOCK" == "true" ]]; then
    cat <<EOF
⚠️  GUIDANCE: Prefer gh CLI subcommands over gh api

Detected: gh api $API_PATH

$SUGGESTIONS

Why prefer subcommands?
   • Better error handling and user-friendly output
   • Automatic pagination where applicable
   • Structured --json output with --jq filtering
   • Consistent interface across GitHub resources

If you need raw API access for an endpoint without a subcommand,
gh api is appropriate. Retry with the suggested command instead.
EOF
    exit 1
fi

# Allow through if no better alternative found
exit 0
