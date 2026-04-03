---
name: execute-plan
description: Execute an implementation plan step-by-step with verification checkpoints. Use when user says 'execute plan', 'run the plan', 'do it step by step', 'start implementing', 'follow the plan', 'execute', 'go', 'executa planul'. For creating plans, use plan-project instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
argument-hint: "[plan-file-path]"
---

# Execute Plan

Execute: $ARGUMENTS

## When to Use

- A plan exists in `plans/` directory (created by `/plan-project`)
- User has a task list or checklist to execute
- Multi-step implementation that needs tracking
- Resuming work from a previous session

## When NOT to Use

- No plan exists yet — use `/plan-project` first
- Single simple task — just do it directly
- Research/exploration phase — use subagents
- Plan needs major changes — re-plan first

## Step 1: Load Plan

Find and read the plan file:

1. If `$ARGUMENTS` is a file path — read that file
2. If `$ARGUMENTS` is a feature name — find matching `plans/*__{name}.md`
3. If no argument — find the most recently modified file in `plans/`
4. If no plan exists — STOP. Tell user to run `/plan-project` first.

Read the plan. Parse: sprints, tasks, done criteria, current status.

## Step 2: Assess Current State

1. Scan all sprints for status (`pending`, `in-progress`, `completed`)
2. Find the active sprint (first `in-progress` or first `pending`)
3. Within that sprint, find the first unchecked `- [ ]` task
4. Check for partial work: are there files mentioned in the task that already exist?
5. Report to user:

```
Plan: {plan name}
Sprint {N}: {sprint name} — {status}
Progress: {completed}/{total} tasks
Next task: {task description}
```

Ask: "Ready to start?" (unless user already said "go").

## Step 3: Environment Check

Before executing the first task, verify prerequisites:

1. Correct git branch? Create or switch if needed.
2. Dependencies installed? Run install command if `package.json`/`go.mod`/etc. changed.
3. Build passes? Quick check that the project is in a working state.
4. If anything fails — report and ask user before continuing.

## Step 4: Execute Task

For each task in the sprint:

1. **Read the task description** — understand scope, target files, expected outcome
2. **Implement** — write code, create files, modify configs
3. **Stay in scope** — do exactly what the task says, no more
4. **If blocked** — document the blocker in the plan file, mark task `(blocked: reason)`, move to next independent task or stop

## Step 5: Verify Task

After implementing, before marking complete:

1. **Does it work?** — run the relevant test, build, or manual check
2. **Run QA gates** from CLAUDE.md that apply:
   - Type check: `npx tsc --noEmit` (if TypeScript)
   - Lint: project linter
   - Build: project build command
   - Tests: relevant test suite
3. **Self-review** — would a staff engineer approve this change?
4. **If verification fails** — fix it now. Do not mark complete with known issues.

## Step 6: Mark Complete and Continue

1. In the plan file: change `- [ ]` to `- [x]` for the completed task
2. Add a one-line note if the implementation deviated from the plan
3. Update `tasks/todo.md` if it mirrors the plan
4. Move to next `- [ ]` task — repeat Steps 4-6

Do NOT batch-mark tasks. Mark each one immediately after verification.

## Step 7: Sprint Transition

When all tasks in a sprint are checked:

1. **Run done criteria** — execute every verification listed in the sprint's "Done Criteria"
2. **Update sprint status** — change `Status: in-progress` to `Status: completed`
3. **Summarize** — briefly list what was delivered in this sprint
4. **Check next sprint** — read its tasks, verify prerequisites are met
5. **Report to user:**

```
Sprint {N} complete: {sprint name}
Delivered: {1-3 bullet summary}
Next: Sprint {N+1}: {name} ({task count} tasks)
Continue?
```

Wait for user confirmation before starting next sprint.

## Step 8: Blocker Protocol

When something goes wrong:

1. **STOP** — do not push through blockers
2. **Document** — add `(blocked: reason)` to the task in the plan file
3. **Analyze** — is this a dependency issue, a missing requirement, or a bug?
4. **Suggest alternatives:**
   - Skip this task, do the next independent one
   - Modify the approach (describe how)
   - Re-plan this sprint
5. **Ask user** for decision. Do not guess.

## Resume Protocol

When resuming a plan mid-execution:

1. Read the plan file
2. Find the active sprint (first non-completed)
3. Find first unchecked `- [ ]` task in that sprint
4. Check if partial work exists (files created, code written but not verified)
5. If partial work found — verify it first, then mark complete or fix
6. Continue from where work stopped
7. Do NOT re-do completed tasks

## Checkpoint Rules

- **After every task**: verify before marking complete
- **After every sprint**: run all done criteria, summarize progress
- **On error**: stop, document, suggest fix or alternative
- **On ambiguity**: ask user, don't guess
- **Progress tracking**: update plan file in real-time (not at the end)

## Plan Complete

When all sprints are done:

1. Update plan status to `completed`
2. Add completion date
3. Add summary section:

```markdown
---
## Completed: {YYYY-MM-DD}
### Summary
- {What was built}
- {Key decisions made}
- {Lessons learned}
```

4. Update `MEMORY_{dev}.md` with completion note
5. Clean up `tasks/todo.md` — remove items from this plan

## Cross-References

- Plans created by: `/plan-project`
- Continuous autonomous execution: `/autonomous-loop` for hands-free coding cycles
- Quality checks: `/audit-quality`
- Bug fixes during execution: `/debug-expert`
- Load domain expertise: `/expertise-loader` for session-start context loading
- Lessons captured in: `tasks/lessons.md`

## Anti-Patterns

- **Skipping verification** — marking complete without testing. Every task must be verified.
- **Scope creep** — doing more than the task specifies. Stay in scope, file new tasks for extras.
- **Ignoring blockers** — pushing through instead of stopping and reporting. Blockers need decisions.
- **Batch marking** — doing 3 tasks then marking all complete. Mark one at a time, immediately.
- **Not updating the plan** — executing but leaving plan file stale. Update in real-time.
- **Re-planning during execution** — if the plan is wrong, stop and re-plan explicitly with user.
- **Starting without assessment** — jumping into code without reading the plan and checking state first.
- **Redoing completed work** — on resume, always check what's already done before starting.
