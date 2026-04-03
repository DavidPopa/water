---
name: {{SKILL_NAME}}
description: {{DOES_WHAT}}. Use when: '{{TRIGGER_EN_1}}', '{{TRIGGER_EN_2}}', '{{TRIGGER_EN_3}}', '{{TRIGGER_RO_1}}', '{{TRIGGER_RO_2}}'. For {{SIMILAR_USE_CASE}}, use {{ALTERNATIVE_SKILL}} instead.
allowed-tools:
  - Bash
  - Read
  - Grep
# argument-hint: "[{{ARG_HINT}}]"        # uncomment if skill takes arguments
---

# {{TITLE}}

{{ONE_LINE_DESCRIPTION}}

## When to Use (Symptoms)

- {{SYMPTOM_1}}
- {{SYMPTOM_2}}
- {{SYMPTOM_3}}

## When NOT to Use

- {{NOT_THIS_1}} — use {{ALTERNATIVE_1}} instead
- {{NOT_THIS_2}} — use {{ALTERNATIVE_2}} instead

## Debugging Workflow

### 1. Check {{SYSTEM_1}}

First, verify {{WHAT_TO_VERIFY}}:

```bash
{{COMMAND_1}}
{{COMMAND_2}}
```

**What to look for:**
- {{INDICATOR_OK}} = working correctly
- {{INDICATOR_BAD}} = problem found

### 2. Check {{SYSTEM_2}}

```bash
{{COMMAND_3}}
{{COMMAND_4}}
```

**Common issues:**
- {{ISSUE_1}} = {{CAUSE_1}}
- {{ISSUE_2}} = {{CAUSE_2}}

### 3. Check {{SYSTEM_3}}

```bash
{{COMMAND_5}}
{{COMMAND_6}}
```

## Common Scenarios

### Scenario: {{SCENARIO_1_NAME}}

**Symptoms:** {{SYMPTOMS_1}}

**Debug steps:**
1. {{STEP_1}}
2. {{STEP_2}}
3. {{STEP_3}}

**Solution:**
```bash
{{FIX_COMMAND_1}}
```

### Scenario: {{SCENARIO_2_NAME}}

**Symptoms:** {{SYMPTOMS_2}}

**Debug steps:**
1. {{STEP_1}}
2. {{STEP_2}}

**Solution:** {{SOLUTION_DESCRIPTION}}

## Quick Commands Reference

```bash
# {{CATEGORY_1}}
{{CMD_1}}
{{CMD_2}}

# {{CATEGORY_2}}
{{CMD_3}}
{{CMD_4}}
```

## Output Format

After debugging, provide:
1. **Status**: What is working, what is not
2. **Root Cause**: Why it happened
3. **Fix**: Concrete steps to resolve
4. **Prevention**: How to avoid next time

## Anti-Patterns

- **{{ANTI_1}}** — {{WHY_1}}
- **{{ANTI_2}}** — {{WHY_2}}
- **{{ANTI_3}}** — {{WHY_3}}
