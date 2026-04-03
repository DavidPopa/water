#!/bin/bash

# SKILL 2.0 Validation Script
# Validates skill directories against the dragoon-setup Skills 2.0 Format Specification
#
# Usage:
#   ./scripts/validate-skill.sh .claude/skills/my-skill       # validate one skill
#   ./scripts/validate-skill.sh .claude/skills/                # validate all skills
#   ./scripts/validate-skill.sh --help                         # show help

# ---------------------------------------------------------------------------
# Colour helpers (auto-disable when piped)
# ---------------------------------------------------------------------------
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    BOLD='\033[1m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' BOLD='' NC=''
fi

# ---------------------------------------------------------------------------
# Counters (per-skill, reset between skills)
# ---------------------------------------------------------------------------
PASS=0
WARN=0
FAIL=0
TOTAL=0

# Global counters across all skills
G_PASS=0
G_WARN=0
G_FAIL=0
G_TOTAL=0
G_SKILLS=0

reset_counters() {
    PASS=0; WARN=0; FAIL=0; TOTAL=0
}

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
check_pass() {
    echo -e "  ${GREEN}✓${NC} $1"
    ((PASS++)); ((TOTAL++))
}

check_warn() {
    echo -e "  ${YELLOW}⚠${NC} $1"
    ((WARN++)); ((TOTAL++))
}

check_fail() {
    echo -e "  ${RED}✗${NC} $1"
    ((FAIL++)); ((TOTAL++))
}

section_header() {
    echo ""
    echo -e "${BOLD}  $1${NC}"
    echo "  ──────────────────────────────────────────────"
}

# ---------------------------------------------------------------------------
# Help
# ---------------------------------------------------------------------------
show_help() {
    cat <<'HELPTEXT'
SKILL 2.0 Format Validator
===========================

Validates skill directories against the dragoon-setup Skills 2.0 specification.

USAGE
  ./scripts/validate-skill.sh <path>          Validate one skill or all skills
  ./scripts/validate-skill.sh --help          Show this help

EXAMPLES
  ./scripts/validate-skill.sh .claude/skills/plan-project     Validate one skill
  ./scripts/validate-skill.sh .claude/skills/                  Validate all skills in directory

CHECKS PERFORMED (30+ validation points)
  Frontmatter   SKILL.md exists, valid YAML, name/description fields,
                kebab-case, length limits, reserved words, trigger keywords,
                third-person voice, allowed-tools, argument-hint format
  Content       Level-1 heading, When to Use, When NOT to Use, numbered steps,
                Anti-Patterns section, line count limits, no hardcoded paths
  Files         Directory-name match, nesting depth, template formats,
                script executability, file size limits
  Cross-refs    Referenced files exist, orphan file detection

EXIT CODES
  0   All checks passed (warnings are OK)
  1   One or more errors found

HELPTEXT
    exit 0
}

# ---------------------------------------------------------------------------
# Extract YAML frontmatter and body from SKILL.md
# ---------------------------------------------------------------------------
extract_frontmatter() {
    local file="$1"
    # Frontmatter = lines between first --- and second ---
    FRONTMATTER=""
    BODY=""
    local in_fm=0
    local fm_end=0
    local line_num=0

    while IFS= read -r line; do
        ((line_num++))
        if [ "$line" = "---" ]; then
            if [ $in_fm -eq 0 ] && [ $line_num -le 2 ]; then
                in_fm=1
                continue
            elif [ $in_fm -eq 1 ]; then
                fm_end=$line_num
                in_fm=2
                continue
            fi
        fi
        if [ $in_fm -eq 1 ]; then
            FRONTMATTER="${FRONTMATTER}${line}"$'\n'
        elif [ $in_fm -eq 2 ]; then
            BODY="${BODY}${line}"$'\n'
        fi
    done < "$file"

    FM_FOUND=$fm_end
}

# ---------------------------------------------------------------------------
# Get a frontmatter field value (single-line fields only)
# ---------------------------------------------------------------------------
fm_field() {
    local key="$1"
    echo "$FRONTMATTER" | grep "^${key}:" | sed "s/^${key}:[[:space:]]*//" | sed "s/^['\"]//;s/['\"]$//"
}

# ---------------------------------------------------------------------------
# Validate a single skill directory
# ---------------------------------------------------------------------------
validate_skill() {
    local skill_dir="$1"
    local skill_md="${skill_dir}/SKILL.md"
    local dir_name
    dir_name=$(basename "$skill_dir")

    reset_counters

    echo ""
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  Validating: ${BLUE}${dir_name}${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    # =======================================================================
    # CHECK 1: SKILL.md exists
    # =======================================================================
    section_header "Frontmatter Checks"

    if [ ! -f "$skill_md" ]; then
        check_fail "SKILL.md not found in ${skill_dir}"
        print_skill_summary "$dir_name"
        return
    fi
    check_pass "SKILL.md exists"

    # Parse frontmatter and body
    extract_frontmatter "$skill_md"

    # =======================================================================
    # CHECK 2: Has YAML frontmatter
    # =======================================================================
    if [ "$FM_FOUND" -gt 0 ]; then
        check_pass "YAML frontmatter present (--- delimiters)"
    else
        check_fail "YAML frontmatter missing or invalid (no --- delimiters)"
        print_skill_summary "$dir_name"
        return
    fi

    # =======================================================================
    # CHECK 3: Has name field
    # =======================================================================
    local name
    name=$(fm_field "name")
    if [ -n "$name" ]; then
        check_pass "name field present: '${name}'"
    else
        check_fail "name field is missing (required)"
    fi

    # =======================================================================
    # CHECK 4: name is kebab-case
    # =======================================================================
    if [ -n "$name" ]; then
        if [[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
            check_pass "name is valid kebab-case"
        else
            check_fail "name must be kebab-case (lowercase, hyphens, numbers): '${name}'"
        fi
    fi

    # =======================================================================
    # CHECK 5: name max 64 characters
    # =======================================================================
    if [ -n "$name" ]; then
        if [ ${#name} -le 64 ]; then
            check_pass "name length OK (${#name}/64 chars)"
        else
            check_fail "name exceeds 64 characters (${#name} chars)"
        fi
    fi

    # =======================================================================
    # CHECK 6: name no reserved words
    # =======================================================================
    if [ -n "$name" ]; then
        local name_lower
        name_lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')
        if echo "$name_lower" | grep -qE "(^|-)anthropic(-|$)|(^|-)claude(-|$)"; then
            check_fail "name contains reserved word (anthropic/claude): '${name}'"
        else
            check_pass "name has no reserved words"
        fi
    fi

    # =======================================================================
    # CHECK 7: Has description field
    # =======================================================================
    local desc
    desc=$(fm_field "description")
    if [ -n "$desc" ]; then
        check_pass "description field present"
    else
        check_fail "description field is missing (required)"
    fi

    # =======================================================================
    # CHECK 8: description non-empty, max 1024
    # =======================================================================
    if [ -n "$desc" ]; then
        local desc_len=${#desc}
        if [ $desc_len -le 1024 ]; then
            check_pass "description length OK (${desc_len}/1024 chars)"
        else
            check_fail "description exceeds 1024 characters (${desc_len} chars)"
        fi
        if [ $desc_len -lt 20 ]; then
            check_warn "description very short (${desc_len} chars) -- likely too vague"
        fi
    fi

    # =======================================================================
    # CHECK 9: description third-person (no I can, you can, we)
    # =======================================================================
    if [ -n "$desc" ]; then
        if echo "$desc" | grep -qiE "^I can |^You can |^We |\bI will\b|\byou will\b|\bwe will\b"; then
            check_fail "description must be third-person (found I/you/we phrasing)"
        else
            check_pass "description uses third-person voice"
        fi
    fi

    # =======================================================================
    # CHECK 10: description contains trigger keywords (at least 2 phrases)
    # =======================================================================
    if [ -n "$desc" ]; then
        # Count quoted trigger phrases (single-quoted words/phrases)
        local trigger_count=0
        trigger_count=$(echo "$desc" | grep -o "'" | wc -l | tr -d ' ')
        trigger_count=$((trigger_count / 2))

        if [ $trigger_count -ge 2 ]; then
            check_pass "description has ${trigger_count} trigger phrases (min 2)"
        elif echo "$desc" | grep -qiE "use when|activates when|trigger"; then
            check_warn "description has trigger language but fewer than 2 quoted phrases (found ${trigger_count})"
        else
            check_fail "description lacks trigger keywords (need at least 2 quoted phrases)"
        fi
    fi

    # =======================================================================
    # CHECK 11: allowed-tools values valid
    # =======================================================================
    if echo "$FRONTMATTER" | grep -q "^allowed-tools:"; then
        local valid_tools="Read Write Edit Bash Glob Grep"
        local bad_tools=0
        while IFS= read -r tool_line; do
            local tool
            tool=$(echo "$tool_line" | sed 's/^[[:space:]]*-[[:space:]]*//')
            # Allow Bash(...) restricted patterns
            local tool_base
            tool_base=$(echo "$tool" | sed 's/(.*//')
            if echo "$valid_tools" | grep -qw "$tool_base"; then
                :
            else
                check_fail "allowed-tools: unknown tool '${tool}'"
                ((bad_tools++))
            fi
        done <<< "$(echo "$FRONTMATTER" | grep "^  - ")"
        if [ $bad_tools -eq 0 ]; then
            local tool_count
            tool_count=$(echo "$FRONTMATTER" | grep -c "^  - " || true)
            check_pass "allowed-tools: ${tool_count} valid tool(s)"
        fi
    fi

    # =======================================================================
    # CHECK 12: argument-hint in brackets format
    # =======================================================================
    if echo "$FRONTMATTER" | grep -q "^argument-hint:"; then
        local hint
        hint=$(fm_field "argument-hint")
        if echo "$hint" | grep -qE '^\[.*\]$'; then
            check_pass "argument-hint in brackets format: ${hint}"
        else
            check_warn "argument-hint should use brackets format, e.g. \"[arg]\": '${hint}'"
        fi
    fi

    # =======================================================================
    # Content Checks
    # =======================================================================
    section_header "Content Checks"

    # =======================================================================
    # CHECK 13: Has level-1 heading
    # =======================================================================
    if echo "$BODY" | grep -qE "^# "; then
        local h1
        h1=$(echo "$BODY" | grep -m1 "^# " | sed 's/^# //')
        check_pass "Level-1 heading found: '${h1}'"
    else
        check_fail "No level-1 heading (# Title) found in content"
    fi

    # =======================================================================
    # CHECK 14: Has "When to Use" section
    # =======================================================================
    if echo "$BODY" | grep -qiE "^## When [Tt]o [Uu]se"; then
        check_pass "\"When to Use\" section present"
    else
        check_fail "Missing \"## When to Use\" section"
    fi

    # =======================================================================
    # CHECK 15: Has "When NOT to Use" section
    # =======================================================================
    if echo "$BODY" | grep -qiE "^## When NOT [Tt]o [Uu]se|^## When Not [Tt]o [Uu]se"; then
        check_pass "\"When NOT to Use\" section present"
    else
        check_fail "Missing \"## When NOT to Use\" section"
    fi

    # =======================================================================
    # CHECK 16: Has numbered steps (at least 3)
    # =======================================================================
    local step_count
    step_count=$(echo "$BODY" | grep -cE "^[0-9]+\. " || true)
    if [ "$step_count" -ge 3 ]; then
        check_pass "Numbered steps found (${step_count} steps, min 3)"
    elif [ "$step_count" -gt 0 ]; then
        check_warn "Only ${step_count} numbered step(s) found (recommend 3+)"
    else
        check_fail "No numbered steps found (need at least 3)"
    fi

    # =======================================================================
    # CHECK 17: Has Anti-Patterns section with at least 3 items
    # =======================================================================
    if echo "$BODY" | grep -qiE "^## Anti-[Pp]atterns?"; then
        # Count list items after Anti-Patterns heading until next heading
        local ap_items
        ap_items=$(echo "$BODY" | awk '
            tolower($0) ~ /^## anti-?patterns?/ { found=1; next }
            found && /^## / { exit }
            found && /^- / { count++ }
            END { print count+0 }
        ')

        if [ $ap_items -ge 3 ]; then
            check_pass "Anti-Patterns section has ${ap_items} items (min 3)"
        else
            check_warn "Anti-Patterns section has only ${ap_items} items (recommend 3+)"
        fi
    else
        check_fail "Missing \"## Anti-Patterns\" section"
    fi

    # =======================================================================
    # CHECK 18: Line count limits
    # =======================================================================
    local total_lines
    total_lines=$(wc -l < "$skill_md" | tr -d ' ')
    if [ "$total_lines" -gt 500 ]; then
        check_fail "SKILL.md is ${total_lines} lines (max 500)"
    elif [ "$total_lines" -gt 300 ]; then
        check_warn "SKILL.md is ${total_lines} lines (basic tier max is 300)"
    else
        check_pass "SKILL.md is ${total_lines} lines (within limits)"
    fi

    # =======================================================================
    # CHECK 19: No hardcoded absolute paths (except in examples/code blocks)
    # =======================================================================
    local hardcoded_paths
    hardcoded_paths=$(echo "$BODY" | awk '
        /^[[:space:]]*```/ { code=!code; next }
        !code && (/\/Users\// || /\/home\/[a-z]/ || /C:\\/) { count++ }
        END { print count+0 }
    ')

    if [ "$hardcoded_paths" -gt 0 ]; then
        check_warn "Found ${hardcoded_paths} hardcoded absolute path(s) outside code blocks"
    else
        check_pass "No hardcoded absolute paths detected"
    fi

    # =======================================================================
    # File Organization Checks
    # =======================================================================
    section_header "File Organization Checks"

    # =======================================================================
    # CHECK 20: Directory name matches name field
    # =======================================================================
    if [ -n "$name" ]; then
        if [ "$dir_name" = "$name" ]; then
            check_pass "Directory name matches name field: '${dir_name}'"
        else
            check_fail "Directory name '${dir_name}' does not match name field '${name}'"
        fi
    fi

    # =======================================================================
    # CHECK 21: No nested subdirectories deeper than 1 level
    # =======================================================================
    local deep_dirs=0
    while IFS= read -r d; do
        [ -z "$d" ] && continue
        # Get depth relative to skill_dir
        local rel="${d#${skill_dir}/}"
        local depth
        depth=$(echo "$rel" | tr '/' '\n' | wc -l | tr -d ' ')
        if [ "$depth" -gt 2 ]; then
            ((deep_dirs++))
        fi
    done <<< "$(find "$skill_dir" -mindepth 1 -type d 2>/dev/null)"

    if [ $deep_dirs -eq 0 ]; then
        check_pass "No deeply nested subdirectories"
    else
        check_fail "Found ${deep_dirs} subdirectory(ies) nested deeper than 1 level"
    fi

    # =======================================================================
    # CHECK 22: templates/ files are .md or common template formats
    # =======================================================================
    if [ -d "${skill_dir}/templates" ]; then
        local bad_template=0
        while IFS= read -r tf; do
            [ -z "$tf" ] && continue
            local ext="${tf##*.}"
            case "$ext" in
                md|txt|json|yaml|yml|html|xml|sh|py|js|ts|toml) ;;
                *) check_warn "Unusual template format: $(basename "$tf")"; ((bad_template++)) ;;
            esac
        done <<< "$(find "${skill_dir}/templates" -type f 2>/dev/null)"
        if [ $bad_template -eq 0 ]; then
            local tc
            tc=$(find "${skill_dir}/templates" -type f 2>/dev/null | wc -l | tr -d ' ')
            check_pass "templates/ contains ${tc} file(s) in valid formats"
        fi
    fi

    # =======================================================================
    # CHECK 23: scripts/ files are executable
    # =======================================================================
    if [ -d "${skill_dir}/scripts" ]; then
        local non_exec=0
        while IFS= read -r sf; do
            [ -z "$sf" ] && continue
            if [ ! -x "$sf" ]; then
                check_warn "Script not executable: $(basename "$sf")"
                ((non_exec++))
            fi
        done <<< "$(find "${skill_dir}/scripts" -type f 2>/dev/null)"
        if [ $non_exec -eq 0 ]; then
            local sc
            sc=$(find "${skill_dir}/scripts" -type f 2>/dev/null | wc -l | tr -d ' ')
            check_pass "scripts/ files are executable (${sc} file(s))"
        fi
    fi

    # =======================================================================
    # CHECK 24: No files larger than 50KB
    # =======================================================================
    local big_files=0
    while IFS= read -r f; do
        [ -z "$f" ] && continue
        local fsize
        if [ "$(uname)" = "Darwin" ]; then
            fsize=$(stat -f%z "$f" 2>/dev/null || echo 0)
        else
            fsize=$(stat -c%s "$f" 2>/dev/null || echo 0)
        fi
        if [ "$fsize" -gt 51200 ]; then
            check_fail "File exceeds 50KB: $(basename "$f") ($(( fsize / 1024 ))KB)"
            ((big_files++))
        fi
    done <<< "$(find "$skill_dir" -type f 2>/dev/null)"
    if [ $big_files -eq 0 ]; then
        check_pass "All files under 50KB"
    fi

    # =======================================================================
    # Cross-Reference Checks
    # =======================================================================
    section_header "Cross-Reference Checks"

    # =======================================================================
    # CHECK 25: Files referenced in SKILL.md actually exist
    # =======================================================================
    local missing_refs=0
    local ref_count=0
    # Extract markdown links: [text](path)
    while IFS= read -r ref; do
        [ -z "$ref" ] && continue
        # Skip URLs
        if echo "$ref" | grep -qE "^https?://|^#"; then
            continue
        fi
        ((ref_count++))
        local ref_path="${skill_dir}/${ref}"
        if [ ! -e "$ref_path" ]; then
            check_fail "Referenced file not found: ${ref}"
            ((missing_refs++))
        fi
    done <<< "$(grep -oE '\]\(([^)]+)\)' "$skill_md" 2>/dev/null | sed 's/\](//' | sed 's/)//' || true)"

    if [ $ref_count -eq 0 ]; then
        check_pass "No file references to check"
    elif [ $missing_refs -eq 0 ]; then
        check_pass "All ${ref_count} referenced file(s) exist"
    fi

    # =======================================================================
    # CHECK 26: No orphan files (files not referenced from SKILL.md)
    # =======================================================================
    local orphans=0
    local skill_content
    skill_content=$(cat "$skill_md")
    while IFS= read -r f; do
        [ -z "$f" ] && continue
        local rel="${f#${skill_dir}/}"
        # Skip SKILL.md itself
        [ "$rel" = "SKILL.md" ] && continue
        # Check if the filename or relative path appears anywhere in SKILL.md
        local bname
        bname=$(basename "$f")
        if ! echo "$skill_content" | grep -qF "$bname" && ! echo "$skill_content" | grep -qF "$rel"; then
            check_warn "Orphan file (not referenced in SKILL.md): ${rel}"
            ((orphans++))
        fi
    done <<< "$(find "$skill_dir" -type f 2>/dev/null)"

    if [ $orphans -eq 0 ]; then
        check_pass "No orphan files detected"
    fi

    # =======================================================================
    # Print per-skill summary
    # =======================================================================
    print_skill_summary "$dir_name"
}

# ---------------------------------------------------------------------------
# Print summary for a single skill
# ---------------------------------------------------------------------------
print_skill_summary() {
    local skill_name="$1"
    local score=0
    if [ $TOTAL -gt 0 ]; then
        score=$(( (PASS * 100) / TOTAL ))
    fi

    echo ""
    echo -e "  ──────────────────────────────────────────────"
    echo -e "  ${BOLD}Result: ${skill_name}${NC}"
    echo -e "  ${GREEN}${PASS} passed${NC}  ${YELLOW}${WARN} warnings${NC}  ${RED}${FAIL} errors${NC}"
    echo -e "  Score: ${PASS}/${TOTAL} (${score}%)"

    if [ $FAIL -eq 0 ] && [ $WARN -eq 0 ]; then
        echo -e "  ${GREEN}PASSED${NC}"
    elif [ $FAIL -eq 0 ]; then
        echo -e "  ${YELLOW}PASSED with warnings${NC}"
    else
        echo -e "  ${RED}FAILED${NC}"
    fi

    # Accumulate global counters
    ((G_PASS += PASS))
    ((G_WARN += WARN))
    ((G_FAIL += FAIL))
    ((G_TOTAL += TOTAL))
    ((G_SKILLS++))
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
    if [ $# -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_help
    fi

    local target="$1"

    echo -e "${BOLD}SKILL 2.0 Format Validator${NC}"
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Determine if target is a single skill dir or a parent with multiple skills
    if [ -f "${target}/SKILL.md" ]; then
        # Single skill
        validate_skill "$target"
    elif [ -d "$target" ]; then
        # Directory of skills -- validate each subdirectory that has SKILL.md
        local found=0
        for skill_dir in "$target"/*/; do
            [ ! -d "$skill_dir" ] && continue
            if [ -f "${skill_dir}/SKILL.md" ]; then
                validate_skill "${skill_dir%/}"
                ((found++))
            fi
        done
        if [ $found -eq 0 ]; then
            echo ""
            echo -e "  ${RED}No skills found in ${target}${NC}"
            echo "  (Looking for subdirectories containing SKILL.md)"
            exit 1
        fi
    else
        echo -e "${RED}Path not found: ${target}${NC}"
        exit 1
    fi

    # Global summary (only if more than one skill)
    if [ $G_SKILLS -gt 1 ]; then
        local g_score=0
        if [ $G_TOTAL -gt 0 ]; then
            g_score=$(( (G_PASS * 100) / G_TOTAL ))
        fi
        echo ""
        echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BOLD}  OVERALL SUMMARY (${G_SKILLS} skills)${NC}"
        echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "  ${GREEN}${G_PASS} passed${NC}  ${YELLOW}${G_WARN} warnings${NC}  ${RED}${G_FAIL} errors${NC}"
        echo -e "  Score: ${G_PASS}/${G_TOTAL} (${g_score}%)"
        echo ""
    fi

    if [ $G_FAIL -gt 0 ]; then
        exit 1
    fi
    exit 0
}

main "$@"
