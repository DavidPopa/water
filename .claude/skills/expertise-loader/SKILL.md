---
name: expertise-loader
description: "Load domain-specific knowledge and project context at session start. Automatically detects tech stack and loads relevant expertise files, lessons, and project rules. Activates when 'session start', 'load context', 'switch context', or 'domain knowledge' is needed."
user-invocable: false
allowed-tools:
  - Read
  - Bash
  - Glob
  - Grep
---

# Expertise Loader

Automatically load relevant context for the current session.

## Purpose

This skill runs in the background to ensure Claude has the right domain knowledge loaded. It:
- Detects the project's tech stack
- Loads relevant expertise files (debugging guides, patterns)
- Loads lessons from tasks/lessons.md
- Loads active plans from plans/ directory
- Checks rules/ for project-specific rules

## When to Use

- Session start
- When Claude detects it's working on an unfamiliar part of the codebase
- When the user switches between frontend/backend/infra work
- When debugging (loads debug expertise automatically)

## When NOT to Use

- Mid-task (don't interrupt active work to reload context)
- When user explicitly says they don't need context
- When working on non-code tasks (documentation, planning)

## Loading Workflow

### Step 1: Detect Tech Stack

Run `scripts/detect-project.sh` from the project root. If the script is not available, scan manually for:
- `package.json` / `tsconfig.json` -> JavaScript/TypeScript
- `requirements.txt` / `pyproject.toml` -> Python
- `go.mod` -> Go
- `Cargo.toml` -> Rust

Record the LANGUAGE, FRAMEWORK, and other detected values.

### Step 2: Load Expertise

Based on detected language, load from `.claude/skills/debug-expert/expertise/`:

| Detected Stack | Files to Load |
|---------------|--------------|
| JavaScript/TypeScript | javascript.md, general.md |
| Python | python.md, general.md |
| Go | go.md, general.md |
| Rust | rust.md, general.md |
| Unknown/Other | general.md only |

If the project uses a known framework (React, Next.js, Django, FastAPI, etc.), note framework-specific patterns from the expertise files. Always load general.md regardless of stack.

### Step 3: Load Lessons

Read `tasks/lessons.md` for recurring mistake patterns. These are corrections from previous sessions formatted as:
- **Mistake** -> **Root cause** -> **Fix**

Apply these lessons to avoid repeating the same errors.

### Step 4: Load Active Plan

Search `plans/` for the most recent file with status "IN PROGRESS" or "in-progress". Load only active plans — skip completed or archived ones. If no active plan exists, skip this step.

### Step 5: Load Rules

Read all `.md` files in the `rules/` directory. Each file contains domain-specific rules that override default behavior. Apply these rules for the duration of the session.

## Tech Stack to Expertise Map

| Detected Stack | Expertise Files | Additional Context |
|---------------|----------------|-------------------|
| JavaScript/TypeScript | javascript.md, general.md | Check for React/Next.js/Node patterns |
| Python | python.md, general.md | Check for Django/Flask/FastAPI patterns |
| Go | go.md, general.md | Check for goroutine/channel patterns |
| Rust | rust.md, general.md | Check for borrow checker/async patterns |
| Unknown/Other | general.md only | Load lessons and rules regardless |

## Integration with Self-Improvement Loop

```
tasks/lessons.md (corrections captured)
       |
expertise-loader (loads at session start)
       |
Claude applies lessons to current work
       |
audit-quality (checks for pattern violations)
       |
New lessons captured if issues found
```

This skill is the **Load** layer in the 4-layer self-improvement architecture:
1. **Capture** — User corrects, lesson saved to tasks/lessons.md
2. **Load** — expertise-loader reads lessons at session start (THIS SKILL)
3. **Audit** — audit-quality checks for recurring patterns
4. **Improve** — autonomous-loop improves skills based on audit findings

## What NOT to Load

- Full codebase files (use Grep/Read on demand)
- Old or completed plans (only active plans)
- Generated files (node_modules, build output, dist, .next, __pycache__)
- Other developers' MEMORY files (only load your own MEMORY_{dev}.md)
- Expertise for unrelated stacks (don't load python.md for a Go project)

## Anti-Patterns

- **Loading everything** — flooding context with irrelevant files wastes tokens and dilutes focus. Load only what matches the detected stack.
- **Ignoring lessons** — skipping tasks/lessons.md defeats the self-improvement loop. Always check for lessons even if the file is short.
- **Wrong expertise** — loading Python expertise for a Go project causes confusion. Always verify detected stack before loading.
- **Stale context** — loading completed plans or outdated rules leads to incorrect assumptions. Check plan status before loading.
- **Interrupting work** — reloading context mid-task breaks flow and wastes tokens. Only load at session boundaries.
- **Skipping detection** — assuming the stack without running detection. Always detect first; projects evolve.

## Cross-References

- Expertise files: `.claude/skills/debug-expert/expertise/`
- Debugging skill: `/debug-expert` (uses loaded expertise for diagnosis)
- Plan execution: `/execute-plan` (loads context before execution)
- Autonomous coding: `/autonomous-loop` (benefits from loaded expertise)
- Project onboarding: `/onboard-project` (sets up files this skill loads)
- Lessons: `tasks/lessons.md`
- Plans: `plans/` directory
- Rules: `rules/` directory
- Tech detection: `scripts/detect-project.sh`
- Quality audit: `/audit-quality`
- New expertise template: `templates/expertise-template.md`
