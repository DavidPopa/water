#!/usr/bin/env bash
# Dragoon 2.0 — Ultimate Status Line for Claude Code CLI
# Reads JSON from stdin, outputs 3-line ANSI status bar.
# Requires: jq, bash 4+
set -euo pipefail

# ── ANSI colors ──────────────────────────────────────────────────────────────
RST=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
CYAN=$'\033[36m'
WHITE=$'\033[97m'
MAGENTA=$'\033[35m'
GREEN=$'\033[32m'
RED=$'\033[31m'
YELLOW=$'\033[33m'
BLUE=$'\033[34m'

# ── Read JSON from stdin once ────────────────────────────────────────────────
JSON=$(cat)

# ── Parse all fields via jq (single read) ────────────────────────────────────
model_id=$(echo "$JSON"       | jq -r '.model.id // ""')
model_display=$(echo "$JSON"  | jq -r '.model.display_name // "Unknown"')
ctx_pct=$(echo "$JSON"        | jq -r '.context_window.used_percentage // 0')
ctx_in=$(echo "$JSON"         | jq -r '.context_window.total_input_tokens // 0')
ctx_out=$(echo "$JSON"        | jq -r '.context_window.total_output_tokens // 0')
ctx_size=$(echo "$JSON"       | jq -r '.context_window.context_window_size // 200000')
cost_usd=$(echo "$JSON"       | jq -r '.cost.total_cost_usd // 0')
duration_ms=$(echo "$JSON"    | jq -r '.cost.total_duration_ms // 0')
api_ms=$(echo "$JSON"         | jq -r '.cost.total_api_duration_ms // 0')
lines_add=$(echo "$JSON"      | jq -r '.cost.total_lines_added // 0')
lines_rm=$(echo "$JSON"       | jq -r '.cost.total_lines_removed // 0')
cc_version=$(echo "$JSON"     | jq -r '.version // ""')
vim_mode=$(echo "$JSON"       | jq -r '.vim.mode // ""')
agent_name=$(echo "$JSON"     | jq -r '.agent.name // ""')
wt_name=$(echo "$JSON"        | jq -r '.worktree.name // ""')
cache_read=$(echo "$JSON"     | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
cache_create=$(echo "$JSON"   | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')

# ── Model version ────────────────────────────────────────────────────────────
if [[ -n "$model_id" ]]; then
    raw=$(echo "$model_id" \
        | sed -E 's/^claude-//' \
        | sed -E 's/^([a-z]+)-([0-9]+)-([0-9]+)$/\1 \2.\3/')
    model_version="$(echo "${raw:0:1}" | tr '[:lower:]' '[:upper:]')${raw:1}"
else
    model_version="$model_display"
fi

# ── Dev name ─────────────────────────────────────────────────────────────────
dev_name=$(git config user.name 2>/dev/null || echo "${USER:-dev}")

# ── Git branch ───────────────────────────────────────────────────────────────
git_branch=$(git branch --show-current 2>/dev/null || echo "")

# ── Context tokens ───────────────────────────────────────────────────────────
ctx_total=$((ctx_in + ctx_out))
ctx_k=$(awk "BEGIN { printf \"%.1f\", ${ctx_total} / 1000 }")
ctx_size_k=$((ctx_size / 1000))
ctx_used_k=$(awk "BEGIN { printf \"%d\", ${ctx_total} / 1000 + 0.5 }")
ctx_pct_int=$(awk "BEGIN { printf \"%d\", ${ctx_pct} + 0.5 }")
ctx_remaining=$((100 - ctx_pct_int))

# ── Progress bar (20 chars) ──────────────────────────────────────────────────
bar_width=20
filled=$(awk "BEGIN { printf \"%d\", ${bar_width} * ${ctx_pct} / 100 + 0.5 }")
empty=$((bar_width - filled))

bar_fill=""
bar_empty=""
for ((i = 0; i < filled; i++)); do bar_fill+=$'\xe2\x96\x88'; done
for ((i = 0; i < empty; i++));  do bar_empty+=$'\xe2\x96\x91'; done

if   (( ctx_pct_int >= 90 )); then BAR_COLOR="$RED"
elif (( ctx_pct_int >= 70 )); then BAR_COLOR="$YELLOW"
else                                BAR_COLOR="$GREEN"
fi

# ── Session duration ─────────────────────────────────────────────────────────
total_sec=$((duration_ms / 1000))
hrs=$((total_sec / 3600))
mins=$(( (total_sec % 3600) / 60 ))
if (( hrs > 0 )); then
    session="${hrs}hr ${mins}m"
else
    session="${mins}m"
fi

# ── Cost ─────────────────────────────────────────────────────────────────────
cost_fmt=$(awk "BEGIN { printf \"%.2f\", ${cost_usd} }")

# ── Token speed ──────────────────────────────────────────────────────────────
tok_speed=""
if (( duration_ms > 1000 && ctx_out > 0 )); then
    speed_val=$(awk "BEGIN { printf \"%.0f\", ${ctx_out} / (${duration_ms} / 1000) }")
    (( speed_val > 0 )) && tok_speed="$speed_val"
fi

# ── Cache efficiency ─────────────────────────────────────────────────────────
cache_pct=""
cache_total=$((cache_read + cache_create))
if (( cache_total > 0 )); then
    cache_pct=$(awk "BEGIN { printf \"%d\", ${cache_read} * 100 / ${cache_total} }")
fi

# ── Skills & Commands count ──────────────────────────────────────────────────
skills_count=0
cmds_count=0
if [ -d ".claude/skills" ]; then
    skills_count=$(find .claude/skills -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
fi
if [ -d ".claude/commands" ]; then
    cmds_count=$(find .claude/commands -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
fi

# ── Todo count ───────────────────────────────────────────────────────────────
todo_count=0
if [ -f "tasks/todo.md" ]; then
    todo_count=$(grep -c '^\- \[ \]' tasks/todo.md 2>/dev/null || true)
    todo_count=${todo_count:-0}
    todo_count=$(echo "$todo_count" | tr -d '[:space:]')
fi

# ── Context warning ──────────────────────────────────────────────────────────
ctx_warn=""
if (( ctx_pct_int >= 90 )); then
    ctx_warn=" ${RED}${BOLD}!! LOW CONTEXT${RST}"
elif (( ctx_pct_int >= 80 )); then
    ctx_warn=" ${YELLOW}! ctx${RST}"
fi

# ── MCP server count ─────────────────────────────────────────────────────────
mcp_count=0
for settings_file in .claude/settings.json .claude/settings.local.json; do
    if [ -f "$settings_file" ]; then
        n=$(jq '.mcpServers // {} | length' "$settings_file" 2>/dev/null || echo 0)
        mcp_count=$((mcp_count + n))
    fi
done

# ── Active plan progress ─────────────────────────────────────────────────────
plan_seg=""
if [ -d "plans" ]; then
    for plan_file in plans/*.md; do
        [ ! -f "$plan_file" ] && continue
        plan_done=$(grep -c '^\- \[x\]' "$plan_file" 2>/dev/null || true)
        plan_total=$(grep -c '^\- \[' "$plan_file" 2>/dev/null || true)
        plan_done=${plan_done:-0}; plan_total=${plan_total:-0}
        plan_done=$(echo "$plan_done" | tr -d '[:space:]')
        plan_total=$(echo "$plan_total" | tr -d '[:space:]')
        if (( plan_total > 0 )); then
            plan_name=$(basename "$plan_file" .md)
            plan_seg=" | ${BLUE}${plan_name}: ${plan_done}/${plan_total}${RST}"
            break  # show first active plan only
        fi
    done
fi

# ── Project name ─────────────────────────────────────────────────────────────
project_name=$(basename "$PWD")

# ══════════════════════════════════════════════════════════════════════════════
# OUTPUT — 3 lines
# ══════════════════════════════════════════════════════════════════════════════

# ── Line 1: Project | Model | Branch | Dev | Agent/Vim | Changes ─────────────
branch_seg=""
[[ -n "$git_branch" ]] && branch_seg=" ${DIM}on${RST} ${WHITE}${git_branch}${RST}"

agent_seg=""
[[ -n "$agent_name" ]] && agent_seg=" | ${BLUE}agent:${agent_name}${RST}"

vim_seg=""
[[ -n "$vim_mode" ]] && vim_seg=" | ${CYAN}${vim_mode}${RST}"

wt_seg=""
[[ -n "$wt_name" ]] && wt_seg=" | ${MAGENTA}wt:${wt_name}${RST}"

printf '%s%s%s %s%s%s%s | %s%s%s%s%s%s | (%s+%s%s,%s-%s%s)\n' \
    "${WHITE}${BOLD}" "${project_name}" "${RST}" \
    "${CYAN}" "${model_version}" "${RST}" \
    "${branch_seg}" \
    "${MAGENTA}" "${dev_name}" "${RST}" \
    "${agent_seg}" "${vim_seg}" "${wt_seg}" \
    "${GREEN}" "${lines_add}" "${RST}" \
    "${RED}" "${lines_rm}" "${RST}"

# ── Line 2: Context bar | Cost | Session | Speed ─────────────────────────────
speed_seg=""
[[ -n "$tok_speed" ]] && speed_seg=" | ${CYAN}${tok_speed} tok/s${RST}"

cache_seg=""
[[ -n "$cache_pct" ]] && cache_seg=" | ${DIM}cache ${cache_pct}%${RST}"

printf '%s[%s%s%s%s] %sk/%sk (%s%%)%s%s | %s$%s%s | %s%s%s%s%s\n' \
    "" \
    "${BAR_COLOR}" "${bar_fill}" "${RST}" "${bar_empty}" \
    "${ctx_used_k}" "${ctx_size_k}" "${ctx_pct_int}" \
    "${ctx_warn}" \
    "" \
    "${YELLOW}" "${cost_fmt}" "${RST}" \
    "${GREEN}" "${session}" "${RST}" \
    "${speed_seg}" "${cache_seg}"

# ── Line 3: Skills | Cmds | MCP | Todos | Plan | Version ─────────────────────
todo_seg=""
if (( todo_count > 0 )); then
    todo_seg=" | ${YELLOW}${todo_count} todo${RST}"
fi

mcp_seg=""
if (( mcp_count > 0 )); then
    mcp_seg=" | ${BLUE}${mcp_count} mcp${RST}"
fi

ver_seg=""
[[ -n "$cc_version" ]] && ver_seg=" | ${DIM}CC v${cc_version}${RST}"

printf '%s%d skills%s %s%d cmds%s%s%s%s%s%s\n' \
    "${WHITE}" "${skills_count}" "${RST}" \
    "${WHITE}" "${cmds_count}" "${RST}" \
    "${mcp_seg}" "${todo_seg}" "${plan_seg}" "${ver_seg}"
