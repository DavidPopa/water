---
description: Show project status — git state, plan progress, recent activity
allowed-tools: Bash, Read, Grep, Glob
argument-hint: ""
---

# Project Status Dashboard

Gather project health metrics and display a clean dashboard.

## Steps

1. **Git state**: Run `git branch --show-current`, `git status --short | wc -l` (uncommitted changes count), and `git log --oneline -1 --format="%s (%ar)"` (last commit).

2. **Tasks**: Read `tasks/todo.md`. Count `- [x]` (complete) and `- [ ]` (incomplete) items. Calculate percentage.

3. **Plans**: Glob for `plans/*.md`. For each file, check if it contains `status: in-progress` or an incomplete sprint (section with `- [ ]` items). Report the active plan name and current sprint.

4. **Lessons**: Read `tasks/lessons.md`. Count entries starting with `**Mistake**:` or `**Insight**:`.

5. **Skills**: Count directories in `.claude/skills/` using `ls -d .claude/skills/*/`.

6. **Commands**: Count `.md` files in `.claude/commands/`.

## Output

Display a formatted dashboard:

```
## Project Status

Branch: {branch} ({N} uncommitted changes)
Last commit: "{message}" ({time ago})

Tasks: {done}/{total} complete ({percent}%)
Active plan: {plan-file} — {current-sprint} (or "None")
Lessons: {count} captured
Skills: {count} installed
Commands: {count} available
```
