# Prompt Patterns Reference

## 1. Role + Task + Constraints
The foundational pattern. Works for 80% of prompts.
```
You are a [role] specializing in [domain].
Task: [specific action with concrete output]
Constraints: Always [X]. Never [Y].
Output: [exact format]
```
**Use when:** Single, well-defined task with clear output.

## 2. Few-Shot Examples
Show Claude what you want. Two examples beat a paragraph of instructions.
```
Convert user stories to test cases.
Example 1:
Input: "User can reset password via email"
Output: "GIVEN registered user WHEN request reset THEN receive email within 60s"
Example 2:
Input: "Admin can ban users"
Output: "GIVEN admin WHEN ban user THEN user cannot log in AND gets notification"
Now convert: [actual input]
```
**Use when:** Output format is specific or hard to describe abstractly.

## 3. Chain-of-Thought
Force reasoning before answering. Reduces errors on complex problems.
```
Analyze this code for security vulnerabilities.
Think step by step:
1. Identify all user inputs
2. Trace each input through the code
3. Check if any reaches a dangerous sink unsanitized
4. Rate severity (Critical/High/Medium/Low)
Show reasoning, then the final list.
```
**Use when:** Analysis where reasoning quality matters more than speed.

## 4. Pipeline / Multi-Stage
Break complex work into stages where each output feeds the next.
```
Stage 1 — Research: List every endpoint in src/api/ with method, path, auth.
Stage 2 — Analyze: Compare endpoints against OpenAPI spec. Flag mismatches.
Stage 3 — Fix: Generate patches for each mismatch from Stage 2.
```
**Use when:** Task has distinct phases benefiting from focused attention per step.

## 5. Evaluation / Scoring
Grade output against specific criteria. Useful for QA and auditing.
```
Score this PR description (1-10 each):
- Clarity: Can a reviewer understand the change?
- Completeness: Are all changes described?
- Test plan: Are testing steps included?
- Risk: Are breaking changes called out?
Pass = all scores >= 7. Justify each score.
```
**Use when:** Quality gates, audits, review automation.

## 6. Constraint Sandwich
Put critical constraints before AND after the task to ensure compliance.
```
IMPORTANT: Output must be valid JSON only. No markdown.
Task: Extract name, date, amount from this text.
Remember: Return ONLY valid JSON. No other text.
```
**Use when:** Output format compliance is critical (API responses, structured data).
