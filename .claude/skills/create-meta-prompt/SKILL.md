---
name: create-meta-prompt
description: Design and refine system prompts, CLAUDE.md instructions, and Claude-to-Claude prompt pipelines. Use when user says 'create prompt', 'improve prompt', 'system prompt', 'meta prompt', 'prompt engineering', 'refine instructions', 'prompt pipeline'. For creating skills, use create-skill instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
argument-hint: "[prompt-or-description]"
---

# Create Meta-Prompt

Refine or create prompts and prompt pipelines: $ARGUMENTS

## When to Use

- Writing or improving CLAUDE.md instructions
- Designing system prompts for Claude API applications
- Creating prompt chains (Claude output feeds into Claude input)
- Refining vague instructions into precise, actionable prompts
- Writing skill/command content (the prompt inside SKILL.md)
- Building multi-stage pipelines (research -> plan -> implement)

## When NOT to Use

- Creating a reusable skill file -> use `/create-skill`
- Creating a slash command -> use `/create-command`
- Creating project rules -> use `/create-rule`
- Event-driven automation -> use `/create-hooks`
- Custom tool server for Claude -> use `/create-mcp-server`
- Writing code -> just write code directly
- Simple question -> just ask directly

## Prompt Quality Principles

1. **Specific over vague** -- "List 3 bugs in this function" not "review this code"
2. **Structured output** -- Tell Claude the exact format you expect
3. **Constraints are good** -- Limits prevent hallucination and scope creep
4. **Examples beat instructions** -- Show the output you want, don't just describe it
5. **Third person for skills** -- "Analyzes code for bugs" not "I analyze code"
6. **Imperative for instructions** -- "Always check types" not "You should check types"
7. **Shorter is more reliable** -- Every extra word is a chance for misinterpretation

## Basic Workflow

### Step 1: Understand Intent

Parse $ARGUMENTS to determine what the user needs:

| Type | Signal | Output |
|------|--------|--------|
| **System prompt** | "system prompt", "CLAUDE.md", "API prompt" | Structured system prompt |
| **Skill prompt** | "skill content", "SKILL.md" | Skill-format prompt |
| **Pipeline** | "chain", "pipeline", "multi-stage" | Connected prompt stages |
| **Refinement** | "improve", "refine", existing prompt provided | Improved version |

If $ARGUMENTS is empty, ask: "What should this prompt accomplish? What are the inputs and expected outputs?"

### Step 2: Draft the Prompt

Write first version focusing on clarity and specificity:

1. **Role** -- Who is Claude in this context?
2. **Context** -- What does Claude need to know?
3. **Task** -- What exactly should Claude do?
4. **Constraints** -- What must Claude avoid?
5. **Output format** -- What does the result look like?

### Step 3: Add Structure

Organize into clear sections. Every prompt needs at minimum:
- A task statement (what to do)
- Constraints (what to avoid)
- Output format (how to present results)

Add examples if the task is ambiguous. Two concrete input/output examples eliminate more ambiguity than a paragraph of instructions.

### Step 4: Refine

Run through the refinement checklist (see below). Remove every word that does not add precision. Replace vague verbs ("handle", "process", "manage") with specific ones ("parse", "validate", "transform").

### Step 5: Deliver

Present the prompt with:
- The complete prompt text
- Explanation of key design decisions
- Suggested test input to verify quality

## Advanced Workflow

### Step 1: Analyze Intent

Parse $ARGUMENTS. Determine prompt type (system, skill, pipeline, CLAUDE.md section). Identify the target audience (API app, Claude Code skill, team workflow).

### Step 2: Research Context

Read relevant code, docs, or existing prompts to ground the new prompt in reality. Never write a prompt about code you haven't read.

```
Glob: find related files
Read: understand current behavior
Grep: find patterns and conventions
```

### Step 3: Architecture

Decide: single prompt or pipeline?

- **Single prompt** -- One task, one output. Most common.
- **Two-stage pipeline** -- Research/analyze first, then act on findings.
- **Multi-stage pipeline** -- DAG of prompts with dependencies.

For pipelines, define the handoff format between stages. Each stage must produce structured output the next stage can parse.

### Step 4: Draft with Full Structure

Write each prompt stage with all sections:

```markdown
## Role
You are a [specific role] that [specific capability].

## Context
[Grounded in actual code/data from Step 2]

## Task
[Numbered steps, each producing a concrete artifact]

## Constraints
- Always: [requirement 1], [requirement 2]
- Never: [anti-pattern 1], [anti-pattern 2]
- Budget: [max tokens, max steps, max time]

## Output Format
[Exact structure with field names and types]

## Examples
Input: [concrete example]
Output: [concrete example matching format above]
```

### Step 5: Add Few-Shot Examples

Include 2-3 input/output examples that demonstrate:
- The happy path (normal input, expected output)
- An edge case (unusual input, correct handling)
- A failure case (bad input, graceful error)

### Step 6: Pipeline Wiring (if multi-stage)

For each stage transition, define:
- **Output schema** -- What Stage N produces
- **Input mapping** -- How Stage N+1 consumes it
- **Error handling** -- What happens if Stage N fails
- **Parallelism** -- Which stages can run concurrently

### Step 7: Refinement Loop

Test the prompt mentally or against real input. Iterate max 3 times:
1. Run prompt (or simulate) with test input
2. Evaluate: Does output match expected format and quality?
3. Fix: Tighten constraints, add examples, remove ambiguity

### Step 8: Integration

Place the finished prompt in the correct location:
- **CLAUDE.md section** -- Edit CLAUDE.md directly
- **Skill content** -- Write to `.claude/skills/{name}/SKILL.md`
- **API prompt** -- Save to project's prompt directory
- **Pipeline** -- Save stages to `.prompts/{number}-{topic}-{purpose}/`

## Prompt Type Templates

### System Prompt (CLAUDE.md / API)

```
You are a [role] that [capability].

Always: [constraint 1], [constraint 2]
Never: [anti-pattern 1], [anti-pattern 2]

Output format: [specific format]
```

### Skill Prompt (SKILL.md content)

```
# Skill Name

[One-line description]

## When to Use
- [condition 1]
- [condition 2]

## Workflow
1. [Concrete step]
2. [Concrete step]
3. [Concrete step]

## Common Pitfalls
- [what to avoid] -- [why]
```

### Pipeline Prompt (Claude -> Claude)

```
Stage 1 [Research]: Input: [raw data] -> Output: [structured findings]
Stage 2 [Plan]:     Input: Stage 1 output -> Output: [action plan]
Stage 3 [Execute]:  Input: Stage 2 output -> Output: [final artifact]

Handoff format: Markdown with ## headers per section
Error handling: If any stage fails, stop and report which stage and why
```

## Refinement Checklist

Run this on every prompt before delivering:

- [ ] Every instruction is actionable (no "consider" or "you might")
- [ ] Constraints are explicit (not implied or assumed)
- [ ] Output format is specified (not "return the result")
- [ ] Edge cases are handled (empty input, errors, ambiguity)
- [ ] A different Claude session would produce same-quality output
- [ ] Token budget is reasonable (shorter prompts are more reliable)
- [ ] Examples are included for any ambiguous instruction
- [ ] No contradictions between different sections

## Anti-Patterns

- **Vague instructions** -- "do a good job" gives Claude zero guidance. Replace with specific success criteria.
- **Too many escape hatches** -- "if you want" or "optionally" weakens the prompt. Decide and commit.
- **No output format** -- Claude guesses format differently each run. Always specify structure.
- **Over-prompting** -- 2000-word prompt for a simple task hits diminishing returns. Match prompt length to task complexity.
- **No examples** -- Abstract instructions without concrete examples cause inconsistent output.
- **Ignoring context** -- Prompts that don't reference actual code/data produce generic results.
- **Contradictory constraints** -- "Be thorough" and "Keep it under 100 words" fight each other. Resolve conflicts before shipping.

## Cross-References

- For reusable skills: `/create-skill`
- For slash commands: `/create-command`
- For CLAUDE.md rules: `/create-rule`
- For event-driven automation: `/create-hooks`
- For MCP tool servers: `/create-mcp-server`
- For subagent definitions: `/create-agent`
- For project setup: `/onboard-project`
- For quality validation: `/audit-quality`
- Prompt patterns reference: `templates/prompt-patterns.md`
