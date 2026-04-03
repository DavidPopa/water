---
name: {{SKILL_NAME}}
description: {{DOES_WHAT}}. Activates automatically when: {{AUTO_TRIGGER_CONDITION}}. Use when: '{{TRIGGER_EN_1}}', '{{TRIGGER_EN_2}}', '{{TRIGGER_RO_1}}'. Not user-invoked directly.
user-invocable: false
allowed-tools:
  - {{TOOL_1}}
  - {{TOOL_2}}
# context: fork                           # uncomment for isolated execution
# model: claude-3-5-haiku-latest          # uncomment for cost-efficient auto-runs
---

# {{TITLE}}

AUTOMATIC BEHAVIOR — this skill activates without user command.

{{ONE_LINE_DESCRIPTION}}

## Trigger Conditions

This skill activates EVERY TIME:
- {{TRIGGER_1}} (e.g., "Every time the Read tool is used")
- {{TRIGGER_2}} (e.g., "Every time user gives an instruction")

This skill does NOT activate when:
- {{SKIP_1}}
- {{SKIP_2}}

## When NOT to Use

- {{NOT_THIS_1}} — use {{ALTERNATIVE_1}} instead
- {{NOT_THIS_2}}

## Automatic Workflow

When trigger condition is met, IMMEDIATELY:

### 1. {{AUTO_STEP_1}}

```bash
{{COMMAND_OR_ACTION}}
```

### 2. {{AUTO_STEP_2}}

{{WHAT_TO_DO_WITH_RESULT}}

### 3. {{AUTO_STEP_3}}

{{HOW_TO_INTEGRATE_INTO_RESPONSE}}

## Integration Guidelines

After automatic execution:
- If results are relevant: incorporate into response naturally
- If results are empty: proceed without mentioning the skill ran
- If results show a problem: warn the user immediately

## DO NOT

- Wait for user to ask — this is automatic
- Skip the check — this runs EVERY time the trigger fires
- Mention the skill by name in responses unless user asks
- Run on trivial queries where trigger clearly does not match

## Anti-Patterns

- **{{ANTI_1}}** — {{WHY_1}}
- **{{ANTI_2}}** — {{WHY_2}}
- **{{ANTI_3}}** — {{WHY_3}}
- **Running when not triggered** — only activate on matching conditions
