---
name: {{SKILL_NAME}}
description: {{DOES_WHAT}}. Use when: '{{TRIGGER_EN_1}}', '{{TRIGGER_EN_2}}', '{{TRIGGER_EN_3}}', '{{TRIGGER_RO_1}}', '{{TRIGGER_RO_2}}'. For {{SIMILAR_USE_CASE}}, use {{ALTERNATIVE_SKILL}} instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
# argument-hint: "[{{ARG_HINT}}]"        # uncomment if skill takes arguments
---

# {{TITLE}}

{{ONE_LINE_DESCRIPTION}}

## When to Use

- {{USE_CASE_1}}
- {{USE_CASE_2}}
- {{USE_CASE_3}}

## When NOT to Use

- {{SKIP_1}} — use {{ALTERNATIVE_1}} instead
- {{SKIP_2}} — use {{ALTERNATIVE_2}} instead

## File Structure

This skill creates/manages these files:

```
{{TARGET_DIR}}/
├── {{FILE_1}}    # {{PURPOSE_1}}
├── {{FILE_2}}    # {{PURPOSE_2}}
└── {{FILE_3}}    # {{PURPOSE_3}}
```

## Initialization

On first use, create the file structure:

1. Check if `{{TARGET_DIR}}/` exists
2. If not, create from templates:
   - Copy `.claude/skills/{{SKILL_NAME}}/templates/{{TEMPLATE_1}}` to `{{TARGET_DIR}}/{{FILE_1}}`
   - Copy `.claude/skills/{{SKILL_NAME}}/templates/{{TEMPLATE_2}}` to `{{TARGET_DIR}}/{{FILE_2}}`
3. Inform user: "Created {{TARGET_DIR}}/ with initial files"

## Operations

### Create {{ENTITY}}

When user wants to add a new {{ENTITY}}:

1. Read current state from `{{FILE_1}}`
2. {{VALIDATION_STEP}}
3. Add new entry with format:
```markdown
{{ENTRY_FORMAT}}
```
4. Write updated file
5. Confirm: "Added {{ENTITY}}: {{name}}"

### Update {{ENTITY}}

When {{UPDATE_TRIGGER}}:

1. Read `{{FILE_1}}`
2. Find the entry to update
3. Modify: {{WHAT_CHANGES}}
4. Write back
5. Confirm change

### Read / List

When user asks about current state:

1. Read `{{FILE_1}}`
2. Present summary:
```
{{SUMMARY_FORMAT}}
```

### Delete / Archive

When {{DELETE_TRIGGER}}:

1. Read `{{FILE_1}}`
2. {{ARCHIVE_OR_DELETE_LOGIC}}
3. Write back
4. Confirm

## Update Rules

- **When to update**: {{UPDATE_TIMING}}
- **Who updates**: Claude (automatically / on request)
- **Conflict resolution**: {{CONFLICT_STRATEGY}}
- **Backup**: Before destructive changes, log previous state

## Anti-Patterns

- **{{ANTI_1}}** — {{WHY_1}}
- **{{ANTI_2}}** — {{WHY_2}}
- **{{ANTI_3}}** — {{WHY_3}}
