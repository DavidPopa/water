---
description: Evaluate multiple approaches — pros, cons, effort, risk, and weighted decision matrix
argument-hint: "[decision-or-problem]"
allowed-tools: Read, Grep, Glob, Bash
---

# Options Evaluation: $ARGUMENTS

Evaluate all viable approaches for **$ARGUMENTS**. Present evidence, score objectively, recommend.

## 1. List Options
Identify at least 3 viable approaches. Search the codebase for existing patterns and constraints that inform the options.

## 2. Evaluate Each Option

### Option A: [Name]
- **Description**: What this approach entails
- **Pros**: Key advantages
- **Cons**: Key disadvantages
- **Effort**: Low / Medium / High (with rough estimate)
- **Risk**: Low / Medium / High (with explanation)
- **Timeline**: Days / Weeks / Months

### Option B: [Name]
(same structure)

### Option C: [Name]
(same structure)

## 3. Decision Matrix

Weight each criterion (1-5) based on importance for this specific decision.

| Criterion | Weight | Option A | Option B | Option C |
|-----------|--------|----------|----------|----------|
| Technical fit | /5 | /5 | /5 | /5 |
| Effort | /5 | /5 | /5 | /5 |
| Risk | /5 | /5 | /5 | /5 |
| Maintainability | /5 | /5 | /5 | /5 |
| Future-proofing | /5 | /5 | /5 | /5 |
| **Weighted Total** | | **X** | **X** | **X** |

## 4. Recommendation
- **Top choice**: Option X — justify with 2-3 sentences
- **Runner-up**: Option Y — note when this would be preferred instead
- **What would change the recommendation**: List specific conditions or new information that would shift the decision
