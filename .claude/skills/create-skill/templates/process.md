---
name: {{SKILL_NAME}}
description: {{DOES_WHAT}}. Use when: '{{TRIGGER_EN_1}}', '{{TRIGGER_EN_2}}', '{{TRIGGER_EN_3}}', '{{TRIGGER_RO_1}}', '{{TRIGGER_RO_2}}'. For {{SIMILAR_USE_CASE}}, use {{ALTERNATIVE_SKILL}} instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
# argument-hint: "[{{ARG_HINT}}]"        # uncomment if skill takes arguments
# context: fork                           # uncomment for isolated execution
# agent: Explore                          # uncomment with context: fork
---

# {{TITLE}}

{{ONE_LINE_DESCRIPTION}}

## When to Use

- {{USE_CASE_1}}
- {{USE_CASE_2}}
- {{USE_CASE_3}}

## When NOT to Use

- {{SKIP_CASE_1}} — use {{ALTERNATIVE_1}} instead
- {{SKIP_CASE_2}} — use {{ALTERNATIVE_2}} instead

## Workflow

### 1. {{PHASE_1_NAME}}

{{PHASE_1_DESCRIPTION}}

1. {{CONCRETE_STEP_1}}
2. {{CONCRETE_STEP_2}}
3. {{CONCRETE_STEP_3}}

**Rules:**
- {{RULE_1}}
- {{RULE_2}}

### 2. {{PHASE_2_NAME}}

{{PHASE_2_DESCRIPTION}}

1. {{CONCRETE_STEP_1}}
2. {{CONCRETE_STEP_2}}
3. {{CONCRETE_STEP_3}}

**Rules:**
- {{RULE_1}}
- {{RULE_2}}

### 3. {{PHASE_3_NAME}}

{{PHASE_3_DESCRIPTION}}

1. {{CONCRETE_STEP_1}}
2. {{CONCRETE_STEP_2}}
3. {{CONCRETE_STEP_3}}

## Advanced Workflow

> Optional: for advanced tier, add context:fork and extended steps here.

### 4. {{ADVANCED_PHASE_NAME}}

{{ADVANCED_DESCRIPTION}}

## Verification

After completing all phases:
- [ ] {{VERIFY_1}}
- [ ] {{VERIFY_2}}
- [ ] {{VERIFY_3}}

## Anti-Patterns

- **{{ANTI_PATTERN_1}}** — {{WHY_BAD_1}}
- **{{ANTI_PATTERN_2}}** — {{WHY_BAD_2}}
- **{{ANTI_PATTERN_3}}** — {{WHY_BAD_3}}
