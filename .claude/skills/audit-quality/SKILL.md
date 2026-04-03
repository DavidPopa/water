---
name: audit-quality
description: Audit and score the quality of skills, agents, rules, and CLAUDE.md configuration. Use when user says 'audit quality', 'check quality', 'review skills', 'score skills', 'validate setup', 'quality check', 'audit'. For validating a single skill format, use validate-skill.sh instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
argument-hint: "[target: all|skills|agents|rules|claudemd]"
---

# Audit Quality

Audit and score the quality of all dragoon-setup artifacts with actionable recommendations.

Audit: $ARGUMENTS

## When to Use

- After creating or modifying skills, agents, or rules
- Periodic quality review (weekly/sprint end)
- Before releasing a new version
- After onboarding a new project
- When quality seems to have drifted

## When NOT to Use

- Validating a single skill's format -> run `scripts/validate-skill.sh` directly
- Creating new skills -> use `/create-skill`
- Fixing a specific bug -> use `/debug-expert`
- Planning work -> use `/plan-project`

## Audit Targets

| Target | What Gets Audited |
|--------|-------------------|
| `all` | Everything below (default if no argument) |
| `skills` | All `.claude/skills/` — format, quality, cross-refs |
| `agents` | All `.claude/agents/` — format, tools, model choice |
| `rules` | All `rules/` — conflicts, coverage, clarity |
| `claudemd` | `CLAUDE.md` — completeness, accuracy, consistency |

## Scoring Rubric (1-10)

### Skills Scoring

| Score | Criteria |
|-------|----------|
| 9-10 | Perfect: all sections present, clear numbered steps, 3+ anti-patterns, proper cross-refs, passes `validate-skill.sh` |
| 7-8 | Good: minor issues (missing cross-ref, vague step, only 1-2 anti-patterns) |
| 5-6 | Needs work: missing sections, unclear steps, no anti-patterns |
| 3-4 | Poor: missing frontmatter fields, no "When NOT to Use", over line limit |
| 1-2 | Broken: can't parse, missing SKILL.md, fundamentally wrong format |

### Rules Scoring

| Score | Criteria |
|-------|----------|
| 9-10 | Clear, specific, no conflicts, has "Why" and "How to apply" |
| 7-8 | Clear but missing "Why" or overlaps with another rule |
| 5-6 | Vague or overly broad |
| 3-4 | Conflicts with other rules |
| 1-2 | Unactionable or contradictory |

### CLAUDE.md Scoring

| Score | Criteria |
|-------|----------|
| 9-10 | All sections filled, commands work, accurate tech stack, QA gates defined |
| 7-8 | Mostly complete, minor gaps |
| 5-6 | Missing key sections (commands, QA gates, or architecture) |
| 3-4 | Placeholder text not filled in |
| 1-2 | Missing or fundamentally broken |

### Agents Scoring

| Score | Criteria |
|-------|----------|
| 9-10 | Valid config, well-scoped tools, appropriate model, clear system prompt |
| 7-8 | Valid but over-granted tools or vague system prompt |
| 5-6 | Missing fields, unclear purpose |
| 3-4 | Invalid config or broken references |
| 1-2 | Missing or non-functional |

## Basic Workflow (5 steps)

1. **Select Target** — Parse `$ARGUMENTS`. Default to `all` if empty. Count artifacts to audit.
2. **Run Format Validator** — Execute `bash scripts/validate-skill.sh .claude/skills/` to get format check results for all skills. Capture pass/fail/warning counts.
3. **Score Content Quality** — Read each artifact and apply the scoring rubric above. For each skill: check sections, step clarity, anti-pattern count, cross-refs. For rules: check specificity, conflicts, coverage. For CLAUDE.md: check completeness, accuracy.
4. **Generate Report** — Use the [audit-report.md](templates/audit-report.md) template. Fill in scores, issues, and recommendations. Write report to stdout (do not create a file unless user asks).
5. **Summary** — State overall health score (average of all categories), list top 3 issues to fix first, and suggest next actions.

## Advanced Workflow (8 steps)

1. **Select and Scope** — Parse target, count all artifacts to audit. List what will be checked.
2. **Format Validation** — Run `bash scripts/validate-skill.sh .claude/skills/` for skills. Check agent JSON validity. Check rule file structure.
3. **Content Quality Audit** — Read each skill SKILL.md: evaluate clarity, completeness, usefulness of instructions. Read each rule file: evaluate actionability and specificity. Score each artifact individually using the rubric.
4. **Cross-Reference Check** — For each skill, verify: (a) files referenced in SKILL.md exist, (b) other skills mentioned exist, (c) cross-reference section points to real skills/tools. For rules, verify referenced commands and files exist.
5. **Conflict Detection** — Read all rule files. Flag: (a) contradictions between rules, (b) duplicate rules across files, (c) rules that reference non-existent files or commands.
6. **CLAUDE.md Audit** — Verify: (a) all sections have real content (not placeholders), (b) commands in the Commands section actually work, (c) tech stack matches actual project files, (d) QA gates reference valid commands, (e) referenced skills and rules exist.
7. **Self-Improvement Check** — Check if `tasks/lessons.md` exists and is being updated. Look for recurring patterns in lessons that should become rules. Flag if lessons file is empty or stale.
8. **Generate Full Report** — Use the report template. Include per-artifact scores, categorized issues by severity (critical/warning/info), fix priority order, and specific actionable recommendations. Calculate overall health as weighted average.

## Report Format

Use this structure for audit output:

```
# Quality Audit Report
Date: YYYY-MM-DD
Target: [all|skills|agents|rules|claudemd]

## Overall Health: X/10

## Skills (X/10 avg)
| Skill | Format | Quality | Cross-refs | Score |
|-------|--------|---------|------------|-------|
| name  | PASS/FAIL | X/10 | PASS/FAIL | X/10 |

## Rules (X/10 avg)
| File | Count | Clarity | Conflicts | Score |
|------|-------|---------|-----------|-------|
| name | N     | X/10    | NONE/YES  | X/10  |

## CLAUDE.md: X/10
- Sections: [filled/total]
- Commands: [valid/total]
- QA Gates: [defined/missing]

## Top Issues
1. [Most critical issue + specific fix recommendation]
2. [Second issue + fix]
3. [Third issue + fix]

## Recommendations
- [Actionable next step with specific file/skill to fix]
```

## Scoring Guidelines

When scoring, follow these principles:

- **Be honest, not generous** — a score of 7 means genuinely good, 10 means flawless
- **Deduct for missing sections** — each missing required section costs 1-2 points
- **Weight clarity heavily** — a skill with clear steps but missing cross-refs (8) beats one with all sections but vague steps (6)
- **Format pass is table stakes** — passing `validate-skill.sh` is necessary but not sufficient for a high score
- **Cross-refs matter** — skills that reference each other correctly show a well-integrated system
- **Rules must be actionable** — "write good code" scores 1, "use functional components with hooks for all new React code" scores 9

## Anti-Patterns

- **Auditing without fixing** — an audit should lead to action. After generating the report, suggest specific fixes or offer to fix simple issues directly
- **Scoring too generously** — be honest, not kind. If a skill has unclear steps, score it 5-6 even if the format is correct. A 7 is genuinely good. A 10 is rare and earned
- **Ignoring cross-references** — format validation can pass but cross-references between skills can be completely broken. Always check that referenced skills and files exist
- **Skipping CLAUDE.md** — it is the foundation of the entire system. Always audit it, even when the target is just "skills"... mention it in recommendations
- **Not checking the self-improvement loop** — the lessons file (`tasks/lessons.md`) is what makes the system learn. Flag if it is empty, stale, or not being used
- **One-time audit mentality** — quality audits should be periodic. Recommend a schedule (weekly, per-sprint, pre-release) in every report

## Cross-References

- Format validation: `scripts/validate-skill.sh` (run this for structural checks)
- Skill creation: `/create-skill` (recommend when audit finds missing skills)
- Agent creation: `/create-agent` (recommend when audit finds missing agents)
- Rule creation: `/create-rule` (recommend when audit finds gaps in rules)
- Rule audit: `/create-rule --audit` (focused rule-only audit)
- Command creation: `/create-command` (recommend for missing shortcuts)
- Hook creation: `/create-hooks` (recommend for missing automation)
- MCP server creation: `/create-mcp-server` (recommend for missing tool integrations)
- Prompt refinement: `/create-meta-prompt` (recommend for improving skill/agent prompts)
- Project setup: `/onboard-project` (recommend for incomplete project configs)
- Debugging: `/debug-expert` (for fixing issues found during audit)
- Self-improvement: `tasks/lessons.md` (check this file in every audit)
- Report template: [audit-report.md](templates/audit-report.md)
