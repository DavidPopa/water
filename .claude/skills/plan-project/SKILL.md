---
name: plan-project
description: Create a project plan with sprints and tasks from a feature request. Use when user says 'plan project', 'plan feature', 'break this down', 'sprint', 'new feature', 'need to build'. For single-session tasks, write a checklist in tasks/todo.md instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
argument-hint: "[feature-description]"
---

# Plan Project

Plan the following feature: $ARGUMENTS

Takes a feature request and produces a full plan with sprints and tasks. Tracks progress across sessions.

## When to Use

- Feature that takes multiple sessions to complete
- User describes something big: "I need an auth system", "redesign the dashboard"
- Work that naturally breaks into phases/milestones

## When NOT to Use

- **Single-session task** — write a checklist directly in `tasks/todo.md` instead
- **Bug fix** — just fix it directly, no plan needed
- **User already has a detailed plan** — use `/execute-plan` instead
- **Tiny change** (under 30 min) — do it, don't plan it
- **Research/exploration** — use a research agent, not a plan

## Step 1: Understand

Before planning anything, gather context:

1. **What does the user want?** Restate it back in 2-3 sentences.
2. **Explore the codebase** — read relevant files, understand current state.
3. **Identify constraints** — tech stack, existing patterns, dependencies.
4. **Ask clarifying questions** if anything is ambiguous. Max 3 questions, grouped in one message.

Do NOT start planning until you understand the codebase. Read first.

## Step 2: Identify the Dev

Check who you're working with:

1. Look for existing `MEMORY_*.md` files in project root
2. If you know the dev name from memory/context, use it
3. If unknown, ask: "Cum te cheama? (pentru plan tracking)"

## Step 3: Create the Plan

### Decide sprint strategy

- **Simple feature** (clear scope, known patterns) — all sprints upfront
- **Complex feature** (unknown scope, research needed, new tech) — first sprint detailed, rest as outline. Add detail sprint by sprint as you go.

Ask yourself: "Can I reasonably predict all the work?" Yes — all upfront. No — sprint by sprint.

### Write the plan file

Create `plans/{dev}__{feature-name}.md` using the template at `templates/plan-template.md`.

For a real-world example of a well-structured plan, see `plans/dragoon-2.0-master-plan.md` in the project root.

### Plan Quality Rules

1. **Sprint = deliverable milestone** — something works at the end of each sprint
2. **Task = half day max** — if bigger, split it
3. **Tasks have file paths** — "add auth middleware to `src/middleware/auth.ts`", not "add auth"
4. **First sprint = foundation** — setup, core structure, basic happy path
5. **Last sprint = polish** — edge cases, error handling, tests, cleanup
6. **Max 7 tasks per sprint** — if more, split the sprint
7. **Max 5 sprints** — if more, the feature is too big. Split into separate plans.

## Step 4: Present and Confirm

Show the plan to the user. Ask:

```
Plan creat: plans/{dev}__{feature}.md

{Sprint count} sprints, {task count} tasks total.
Sprint 1: {name} ({task count} tasks)
Sprint 2: {name} ({task count} tasks)
...

Incepem cu Sprint 1 sau vrei modificari?
```

Wait for confirmation before any execution.

## Step 5: Execute (when user says go)

When user confirms, hand off to `/execute-plan` skill if available. Otherwise:

1. Update plan file: Sprint 1 status — `in-progress`
2. Update plan file: top-level status — `in-progress`
3. Copy Sprint 1 tasks to `tasks/todo.md` under "In Progress"
4. Start working on first task

### During execution

As you complete each task:

1. **In the plan file**: check the box `- [x]`
2. **In tasks/todo.md**: mark complete
3. **When sprint is done**: update sprint status — `completed`, add done date
4. **Next sprint**: update status — `in-progress`, copy tasks to todo.md

### Real-time updates

Update the plan file IMMEDIATELY when:
- A task is completed — check the box
- A task needs to change — edit it, add note why
- A new task is discovered — add it to current sprint with `(added)` tag
- A task is blocked — mark with `(blocked: reason)`

Do NOT wait for session end to update the plan.

## Step 6: Sprint Transitions

When all tasks in a sprint are done:

1. Verify done criteria for the sprint
2. Mark sprint `completed` with date
3. If next sprint is outline-only — flesh it out now (detail the tasks)
4. Ask user: "Sprint {N} done. Sprint {N+1}: {name}. Incepem?"
5. On confirmation — repeat Step 5

## Step 7: Plan Complete

When all sprints are done:

1. Update plan status — `completed`
2. Add completion date
3. Add summary section at the bottom:

```markdown
---

## Completed: {YYYY-MM-DD}

### Summary
- {What was built}
- {Key decisions made}
- {Lessons learned}
```

4. Update `MEMORY_{dev}.md` with: plan finished, what was built
5. Clean up `tasks/todo.md` — remove completed items from this plan

## Cross-References

- **Execution**: Use `/execute-plan` to autonomously run through a plan's sprints
- **Quality**: Use `/audit-quality` to validate plan structure and completeness
- **Autonomous execution**: Use `/autonomous-loop` for continuous hands-free plan execution
- **Debugging**: Use `/debug-expert` for bugs encountered during planning or execution
- **Domain expertise**: Use `/expertise-loader` for loading context before planning
- **Onboarding**: Use `/onboard-project` to set up a project before planning features
- **Single tasks**: For tasks that fit in one session, write a checklist in `tasks/todo.md` instead

## Anti-Patterns

- **Coding before confirmation** — always wait for user go-ahead before executing
- **Tasks without file paths** — "implement feature" is not a task; specify exact files
- **Sprints without done criteria** — if you can't verify it's done, it's not a sprint
- **Forgetting to update the plan file** — the plan is the source of truth, update in real-time
- **Sprint with 15 tasks** — max 7 per sprint, split if more
- **Planning 10 sprints** — max 5, split the feature into multiple plans
- **Not reading the codebase before planning** — plans based on assumptions fail
- **Vague acceptance criteria** — "it works" is not a criterion; be specific and testable
- **Over-planning simple features** — if it takes one session, write a checklist in `tasks/todo.md` instead

## Supporting Files

- **Plan template**: See [templates/plan-template.md](templates/plan-template.md) for the base plan structure
