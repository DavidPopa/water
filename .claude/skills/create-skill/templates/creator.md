---
name: {{SKILL_NAME}}
description: {{DOES_WHAT}}. Use when: '{{TRIGGER_EN_1}}', '{{TRIGGER_EN_2}}', '{{TRIGGER_EN_3}}', '{{TRIGGER_RO_1}}', '{{TRIGGER_RO_2}}'. For {{SIMILAR_USE_CASE}}, use {{ALTERNATIVE_SKILL}} instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
argument-hint: "[{{ARG_HINT}}]"
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

## Generation Workflow

### 1. Gather Requirements

Ask the user (skip what is obvious from context):

1. {{QUESTION_1}}
2. {{QUESTION_2}}
3. {{QUESTION_3}}
4. {{QUESTION_4}}

### 2. Select Template

Based on answers, choose from:

| Type | Template | When to use |
|------|----------|-------------|
| {{TYPE_1}} | `templates/{{TEMPLATE_1}}.md` | {{WHEN_1}} |
| {{TYPE_2}} | `templates/{{TEMPLATE_2}}.md` | {{WHEN_2}} |
| {{TYPE_3}} | `templates/{{TEMPLATE_3}}.md` | {{WHEN_3}} |

### 3. Generate Output

Fill template with user answers:

1. {{GENERATION_STEP_1}}
2. {{GENERATION_STEP_2}}
3. {{GENERATION_STEP_3}}

### 4. Validate

Check the generated output:
- [ ] {{VALIDATION_1}}
- [ ] {{VALIDATION_2}}
- [ ] {{VALIDATION_3}}
- [ ] {{VALIDATION_4}}

If validation fails, fix automatically and inform user.

### 5. Write Files

Output structure:

```
{{OUTPUT_DIR}}/
├── {{OUTPUT_FILE_1}}    # {{PURPOSE_1}}
├── {{OUTPUT_FILE_2}}    # {{PURPOSE_2}}
└── {{OUTPUT_FILE_3}}    # {{PURPOSE_3}}
```

### 6. Confirm

Report to user:
```
Created: {{WHAT_WAS_CREATED}}
Location: {{WHERE}}
Files: {{FILE_LIST}}

Test with: {{TEST_COMMAND}}
```

## Anti-Patterns

- **{{ANTI_1}}** — {{WHY_1}}
- **{{ANTI_2}}** — {{WHY_2}}
- **{{ANTI_3}}** — {{WHY_3}}
- **Skipping validation** — always validate before declaring done
- **Over-generating files** — only create what is needed
