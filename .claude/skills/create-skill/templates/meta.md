---
name: {{SKILL_NAME}}
description: {{DOES_WHAT}}. Use when: '{{TRIGGER_EN_1}}', '{{TRIGGER_EN_2}}', '{{TRIGGER_EN_3}}', '{{TRIGGER_RO_1}}', '{{TRIGGER_RO_2}}'. For {{SIMILAR_USE_CASE}}, use {{ALTERNATIVE_SKILL}} instead.
allowed-tools:
  - Read
  - Glob
  - Grep
# context: fork                           # uncomment for isolated analysis
# agent: Explore                          # uncomment with context: fork
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

## Analysis Workflow

### 1. Gather Context

Collect information before analysis:

1. {{GATHER_STEP_1}}
2. {{GATHER_STEP_2}}
3. {{GATHER_STEP_3}}

### 2. Analyze

Apply analysis criteria:

| Criterion | What to check | Pass condition |
|-----------|--------------|----------------|
| {{CRITERION_1}} | {{CHECK_1}} | {{PASS_1}} |
| {{CRITERION_2}} | {{CHECK_2}} | {{PASS_2}} |
| {{CRITERION_3}} | {{CHECK_3}} | {{PASS_3}} |

### 3. Generate Output

Present findings in this format:

```markdown
## {{OUTPUT_TITLE}}

### Summary
{{SUMMARY_FORMAT}}

### Findings
- {{FINDING_FORMAT}}

### Recommendations
- {{RECOMMENDATION_FORMAT}}

### Score: {{SCORE_FORMAT}}
```

## Integration with Other Skills

This skill works with:
- {{RELATED_SKILL_1}} — {{HOW_RELATED_1}}
- {{RELATED_SKILL_2}} — {{HOW_RELATED_2}}
- {{RELATED_SKILL_3}} — {{HOW_RELATED_3}}

## Anti-Patterns

- **{{ANTI_1}}** — {{WHY_1}}
- **{{ANTI_2}}** — {{WHY_2}}
- **{{ANTI_3}}** — {{WHY_3}}
- **Analyzing without context** — always gather full context before judging
- **Reporting without recommendations** — findings must include actionable next steps
