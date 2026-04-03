---
name: create-skill
description: Create a new Claude Code skill from templates following the Skills 2.0 format. Use when user says 'create skill', 'new skill', 'make skill', 'build skill', 'fa skill', 'skill nou', 'genereaza skill'. Generates SKILL.md with proper frontmatter, triggers, anti-patterns, and supporting files. For creating agents, use create-agent instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
argument-hint: "[skill-name]"
---

# Create Skill

Generates production-ready Claude Code skills in Skills 2.0 format from templates.

## Invocation

```
/create-skill                     # interactive — asks questions
/create-skill deployment checker  # with name hint
```

## When to Use

- User wants to create a new reusable workflow
- User says "create skill", "new skill", "make skill", "build skill"
- User says "fa skill", "skill nou", "genereaza skill"
- A repeated workflow should be automated as a skill

## When NOT to Use

- Creating a subagent definition — use `/create-agent` instead
- Creating a one-time script — just write the script directly
- Creating a rule — use `/create-rule` instead
- Creating a hook — use `/create-hooks` instead
- Creating a simple slash command shortcut — use `/create-command` instead
- Creating an MCP tool server — use `/create-mcp-server` instead
- Writing or refining prompt content — use `/create-meta-prompt` instead

## Skills 2.0 Format Reference

Every generated skill MUST follow this format.

### Required Frontmatter Fields

```yaml
---
name: kebab-case-name          # lowercase, hyphens, max 64 chars
description: Does X. Use when: trigger1, trigger2, trigger3. For Y, use Z instead.
allowed-tools:                  # only tools the skill needs
  - Read
  - Write
---
```

### Optional Frontmatter Fields

```yaml
argument-hint: "[arg-name]"            # shown in autocomplete
user-invocable: true                   # false = background skill
disable-model-invocation: true         # true = manual-only (side effects)
context: fork                          # isolated subagent execution
agent: Explore                         # subagent type (with context: fork)
model: claude-3-5-haiku-latest         # model override
hooks:                                 # lifecycle hooks
  PreToolUse:
    - command: script
      matchers:
        tool: Bash
```

### Required Content Sections

1. Title + one-line description
2. "When to Use" (bullet list)
3. "When NOT to Use" (bullet list with alternatives)
4. Numbered workflow steps (concrete, actionable)
5. "Anti-Patterns" (minimum 3 items, format: **Pattern** -- why bad)

### Line Limits

- Basic tier: SKILL.md only, under 200 lines
- Advanced tier: SKILL.md + supporting files, SKILL.md under 300 lines

## Step 1: Gather Requirements

Ask the user these questions (skip what is obvious from context):

1. **What problem does the skill solve?** (1-2 sentences)
2. **When does it activate?** (trigger words in EN + RO, minimum 3 EN + 2 RO)
3. **What type?** Offer options:
   - **process** — step-by-step workflow (deploy, code review, TDD)
   - **diagnostic** — debugging with checklists (debug API, debug DB)
   - **crud** — creates/updates files on disk (planning, scaffolding)
   - **auto** — activates automatically on Claude actions (background)
   - **creator** — generates other things (hooks, servers, commands)
   - **meta** — analyzes/audits/loads knowledge (quality, expertise)
4. **What tier?**
   - **Basic** — SKILL.md only, under 200 lines, no fork context
   - **Advanced** — SKILL.md + supporting files, may use context:fork
5. **What tools does it need?** Suggest based on type:
   - process: `Read, Write, Edit, Bash`
   - diagnostic: `Bash, Read, Grep`
   - crud: `Read, Write, Edit, Bash, Glob`
   - auto: depends on context
   - creator: `Read, Write, Edit, Bash, Glob, Grep`
   - meta: `Read, Glob, Grep`
6. **Where to save?** Default: `.claude/skills/{name}/`

## Step 2: Select Template

Read the template matching the type from `${CLAUDE_SKILL_DIR}/templates/`:

| Type | Template File |
|------|--------------|
| process | `templates/process.md` |
| diagnostic | `templates/diagnostic.md` |
| crud | `templates/crud.md` |
| auto | `templates/auto.md` |
| creator | `templates/creator.md` |
| meta | `templates/meta.md` |

If template file not found, use the Skills 2.0 format reference above.

## Step 3: Generate SKILL.md

Fill the template with user answers. Follow these rules:

### Frontmatter Rules

- `name`: kebab-case, max 3 words (e.g., `deploy-checker`, `api-debug`)
- `description`: MUST include:
  - What it does (first sentence, third person)
  - Trigger words in EN AND RO (minimum 3 EN, 2 RO)
  - When NOT to use if there is a similar skill
- `allowed-tools`: only tools the skill actually needs
- `user-invocable: true` unless it is an auto-trigger skill
- `argument-hint`: add if skill takes arguments
- `context: fork` + `agent`: only for advanced tier skills needing isolation
- `disable-model-invocation: true`: only for skills with side effects

### Content Rules

1. Start with one-liner describing what the skill does
2. Always include "When to Use" and "When NOT to Use"
3. Steps must be numbered and concrete — no vague instructions
4. Include examples with real commands, file paths, output
5. Anti-patterns section with minimum 3 items
6. Max 200 lines (basic) or 300 lines (advanced) for SKILL.md
7. No emojis unless user explicitly wants them

### Trigger Quality Check

Before writing, verify the description:
- Contains at least 3 EN trigger words
- Contains at least 2 RO trigger words
- Explains when NOT to use (avoids false activation)
- First sentence clearly describes the action

## Step 4: Generate Supporting Files (if Advanced tier)

Based on type:
- **process**: optional `examples.md` for complex workflows
- **diagnostic**: `helpers.md` with quick-reference commands
- **crud**: `templates/` folder with skeleton files the skill creates
- **auto**: no extra files usually needed
- **creator**: `templates/` with generation templates
- **meta**: optional `reference.md` for domain knowledge

## Step 5: Write Files

```
{target}/
├── {skill-name}/
│   ├── SKILL.md              # main skill file (required)
│   ├── helpers.md            # if diagnostic type
│   ├── reference.md          # if meta type
│   └── templates/            # if crud or creator type
│       └── {template}.md
```

Write all files, then confirm to user:

```
Skill created: /skill-name
Location: .claude/skills/skill-name/
Files: SKILL.md (X lines), [supporting files]

Test with: /skill-name
```

## Step 6: Validate

Run validation if `scripts/validate-skill.sh` exists:

```bash
bash scripts/validate-skill.sh .claude/skills/{skill-name}/
```

Otherwise check manually:
- [ ] SKILL.md has valid YAML frontmatter (--- delimiters)
- [ ] `name` is kebab-case, no reserved words
- [ ] `description` has 3+ EN triggers and 2+ RO triggers
- [ ] Has "When to Use" section
- [ ] Has "When NOT to Use" section
- [ ] Has "Anti-Patterns" section (3+ items)
- [ ] Under line limit (200 basic, 300 advanced)
- [ ] `allowed-tools` matches what the skill actually uses
- [ ] No hardcoded secrets or absolute paths
- [ ] All referenced supporting files exist

If validation fails, fix automatically and inform user what was corrected.

## Cross-References

- `/create-agent` — for creating subagent definitions
- `/create-rule` — for adding rules to CLAUDE.md / rules/
- `/create-hooks` — for event-driven automation
- `/create-command` — for simple slash command shortcuts
- `/create-mcp-server` — for MCP tool servers
- `/create-meta-prompt` — for writing and refining prompt content
- `/plan-project` — for multi-sprint project planning
- `/onboard-project` — for full project setup including skill recommendations
- `/audit-quality` — for validating skill quality after creation

## Anti-Patterns

- **Generating skills over 300 lines** — break into SKILL.md + supporting files
- **Missing RO triggers** — team works bilingually, triggers must cover both languages
- **No "When NOT to Use"** — causes false activation on similar requests
- **Vague steps ("configure the thing")** — every step must be actionable with specifics
- **Generating skills for one-time tasks** — skills are for repeated workflows only
- **Skipping validation** — always run Step 6 before declaring done
- **Putting secrets in SKILL.md** — never hardcode API keys, tokens, passwords
- **Over-granting tools** — only list tools the skill actually uses
- **Missing frontmatter fields** — every skill needs name, description, allowed-tools at minimum
