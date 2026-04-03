---
description: Generate a handoff document with current context for the next session
allowed-tools: Bash, Read, Grep, Glob, Write
---

# Session Handoff Generator

Build a concise context handoff so the next session understands state in 30 seconds.

## Steps

1. **Git state**: Run `git status --short` and `git log --oneline -5`.

2. **Tasks**: Read `tasks/todo.md`. Extract recently completed items (`- [x]`) from the last active section and next unchecked items (`- [ ]`).

3. **Lessons**: Read `tasks/lessons.md`. Extract the last section of lessons (most recent sprint or date).

4. **Active plan**: Glob for `plans/*.md`. If any exist, read them and find the current sprint (first section with incomplete `- [ ]` items).

5. **Memory files**: Glob for `MEMORY_*.md`. If any exist, read them for current state context.

6. **Output the handoff to stdout** (do NOT create a file):

```
## Handoff — {YYYY-MM-DD}

### What Was Done
- {completed items from the last active section of todo.md}

### What's Next
- {first 3-5 unchecked items from todo.md}

### Current State
- Branch: {branch}, {N} uncommitted changes
- Active plan: {plan-file}, {current-sprint} (or "No active plan")

### Watch Out For
- {last 2-3 lessons from lessons.md}
- {any uncommitted work or failing state from git status}
```

7. Keep the output concise. No section should exceed 5 bullet points.
