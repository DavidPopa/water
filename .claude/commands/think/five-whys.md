---
description: Ask "why?" repeatedly to drill down to the root cause of a problem
argument-hint: "[problem or symptom to investigate]"
allowed-tools: Read, Grep
---

# 5 Whys Root Cause Analysis

Drill to the root cause of: **$ARGUMENTS**

## Process

1. **State the problem clearly**: What is the observable symptom?

2. **Why 1**: Why does this problem occur?
   - Answer: ...

3. **Why 2**: Why does [answer 1] happen?
   - Answer: ...

4. **Why 3**: Why does [answer 2] happen?
   - Answer: ...

5. **Why 4**: Why does [answer 3] happen?
   - Answer: ...

6. **Why 5**: Why does [answer 4] happen?
   - Answer: ...

Stop when you reach a cause that is either: (a) directly actionable, or (b) a fundamental constraint you cannot change. This is usually 3-5 levels deep.

## Root Cause Identification

- **Symptom** (level 0): the original problem
- **Root cause** (deepest level reached): the real issue
- **Why fixing the symptom fails**: it will recur because the root cause remains

## Output

- The full why-chain from symptom to root cause
- A fix targeted at the ROOT level, not the symptom level
- Expected impact: what resolves when the root cause is addressed
