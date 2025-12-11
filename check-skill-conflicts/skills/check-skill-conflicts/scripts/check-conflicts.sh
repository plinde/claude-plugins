#!/opt/homebrew/bin/bash
# Check for naming conflicts between local skills and plugin skills
# Local: ~/.claude/skills/<name>/SKILL.md
# Plugin: ~/.claude/plugins/**/skills/<name>/SKILL.md

set -euo pipefail

SKILLS_DIR="$HOME/.claude/skills"
PLUGINS_DIR="$HOME/.claude/plugins"
VERBOSE=false
JSON_OUTPUT=false

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Check for naming conflicts between local skills and plugin-provided skills.

Options:
    --verbose       Show all skills found, not just conflicts
    --json          Output results as JSON
    --help          Show this help message

Examples:
    $(basename "$0")              # Check for conflicts
    $(basename "$0") --verbose    # Show all skills + conflicts
    $(basename "$0") --json       # JSON output
EOF
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --json)
            JSON_OUTPUT=true
            shift
            ;;
        --help|-h)
            usage
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage
            ;;
    esac
done

# Find local skills (directories with SKILL.md)
get_local_skills() {
    local skills=()
    if [[ -d "$SKILLS_DIR" ]]; then
        while IFS= read -r skill_file; do
            local skill_dir
            skill_dir=$(dirname "$skill_file")
            local skill_name
            skill_name=$(basename "$skill_dir")
            # Skip check-skill-conflicts itself
            [[ "$skill_name" == "check-skill-conflicts" ]] && continue
            skills+=("$skill_name|$skill_dir")
        done < <(find "$SKILLS_DIR" -maxdepth 2 -name "SKILL.md" 2>/dev/null)
    fi
    printf '%s\n' "${skills[@]}" 2>/dev/null || true
}

# Find plugin skills (search recursively in plugins dir)
get_plugin_skills() {
    local skills=()
    if [[ -d "$PLUGINS_DIR" ]]; then
        while IFS= read -r skill_file; do
            local skill_dir
            skill_dir=$(dirname "$skill_file")
            local skill_name
            skill_name=$(basename "$skill_dir")
            skills+=("$skill_name|$skill_dir")
        done < <(find -L "$PLUGINS_DIR" -path "*/skills/*/SKILL.md" 2>/dev/null)
    fi
    printf '%s\n' "${skills[@]}" 2>/dev/null || true
}

# Check if two names are similar (differ by common suffixes/prefixes)
is_similar() {
    local name1="$1"
    local name2="$2"

    # Exact match handled separately
    [[ "$name1" == "$name2" ]] && return 1

    # Case-insensitive match
    if [[ "${name1,,}" == "${name2,,}" ]]; then
        return 0
    fi

    # Common suffixes/prefixes to strip for comparison
    local stripped1 stripped2
    stripped1=$(echo "$name1" | sed -E 's/(-skill|-plugin|-tool|skill-|plugin-|tool-)//g')
    stripped2=$(echo "$name2" | sed -E 's/(-skill|-plugin|-tool|skill-|plugin-|tool-)//g')

    if [[ "$stripped1" == "$stripped2" ]] && [[ -n "$stripped1" ]]; then
        return 0
    fi

    # Check if one contains the other (minimum 5 chars to avoid false positives)
    if [[ ${#name1} -ge 5 ]] && [[ ${#name2} -ge 5 ]]; then
        if [[ "$name1" == *"$name2"* ]] || [[ "$name2" == *"$name1"* ]]; then
            return 0
        fi
    fi

    return 1
}

# Main logic
declare -A local_skills=()
declare -A plugin_skills=()
declare -a exact_matches=()
declare -a similar_matches=()

# Load local skills
while IFS='|' read -r name path; do
    [[ -z "$name" ]] && continue
    local_skills["$name"]="$path"
done < <(get_local_skills)

# Load plugin skills
while IFS='|' read -r name path; do
    [[ -z "$name" ]] && continue
    plugin_skills["$name"]="$path"
done < <(get_plugin_skills)

# Find exact matches
for name in "${!local_skills[@]}"; do
    if [[ -v plugin_skills["$name"] ]]; then
        exact_matches+=("$name|${local_skills[$name]}|${plugin_skills[$name]}")
    fi
done

# Find similar names
for local_name in "${!local_skills[@]}"; do
    for plugin_name in "${!plugin_skills[@]}"; do
        # Skip if already an exact match
        [[ "$local_name" == "$plugin_name" ]] && continue

        if is_similar "$local_name" "$plugin_name"; then
            similar_matches+=("$local_name|$plugin_name|${local_skills[$local_name]}|${plugin_skills[$plugin_name]}")
        fi
    done
done

# Output
if [[ "$JSON_OUTPUT" == "true" ]]; then
    # JSON output
    exact_json="[]"
    similar_json="[]"

    if [[ ${#exact_matches[@]} -gt 0 ]]; then
        exact_json=$(printf '%s\n' "${exact_matches[@]}" | jq -R -s '
            split("\n") | map(select(length > 0)) | map(
                split("|") | {
                    name: .[0],
                    local_path: .[1],
                    plugin_path: .[2]
                }
            )
        ')
    fi

    if [[ ${#similar_matches[@]} -gt 0 ]]; then
        similar_json=$(printf '%s\n' "${similar_matches[@]}" | jq -R -s '
            split("\n") | map(select(length > 0)) | map(
                split("|") | {
                    local_name: .[0],
                    plugin_name: .[1],
                    local_path: .[2],
                    plugin_path: .[3]
                }
            )
        ')
    fi

    jq -n \
        --argjson local_count "${#local_skills[@]}" \
        --argjson plugin_count "${#plugin_skills[@]}" \
        --argjson exact "$exact_json" \
        --argjson similar "$similar_json" \
        '{
            local_count: $local_count,
            plugin_count: $plugin_count,
            exact_matches: $exact,
            similar_matches: $similar,
            has_conflicts: (($exact | length) > 0 or ($similar | length) > 0)
        }'
else
    # Human-readable output
    echo "SKILL CONFLICT CHECK"
    echo "===================="
    echo ""
    echo "Local Skills:     ${#local_skills[@]} found in ~/.claude/skills/"
    echo "Plugin Skills:    ${#plugin_skills[@]} found in ~/.claude/plugins/"
    echo ""

    if [[ "$VERBOSE" == "true" ]]; then
        echo "LOCAL SKILLS:"
        for name in "${!local_skills[@]}"; do
            echo "  - $name"
        done | sort
        echo ""
        echo "PLUGIN SKILLS:"
        for name in "${!plugin_skills[@]}"; do
            echo "  - $name"
        done | sort
        echo ""
    fi

    if [[ ${#exact_matches[@]} -gt 0 ]]; then
        echo "EXACT MATCHES (High Priority):"
        for match in "${exact_matches[@]}"; do
            IFS='|' read -r name local_path plugin_path <<< "$match"
            echo "  ⚠️  $name"
            echo "      Local:  $local_path"
            echo "      Plugin: $plugin_path"
            echo ""
        done
    fi

    if [[ ${#similar_matches[@]} -gt 0 ]]; then
        echo "SIMILAR NAMES (Review Recommended):"
        for match in "${similar_matches[@]}"; do
            IFS='|' read -r local_name plugin_name local_path plugin_path <<< "$match"
            echo "  ⚡ $local_name ~ $plugin_name"
            echo "      Local:  $local_path"
            echo "      Plugin: $plugin_path"
            echo ""
        done
    fi

    if [[ ${#exact_matches[@]} -eq 0 ]] && [[ ${#similar_matches[@]} -eq 0 ]]; then
        echo "✅ No conflicts found!"
    else
        echo "---"
        echo "Total: ${#exact_matches[@]} exact match(es), ${#similar_matches[@]} similar name(s)"
    fi
fi
