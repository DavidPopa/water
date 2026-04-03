---
name: debug-expert
description: Systematic debugging with scientific method and hypothesis testing. Use when user says 'debug', 'diagnose', 'root cause', 'why is this broken', 'fix bug', 'investigate'. For simple syntax errors, use your editor/linter instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
argument-hint: "[bug-description]"
---

# Debug Expert

Debug: $ARGUMENTS

## When to Use

- Bug with no obvious cause
- Flaky tests or race conditions
- Integration failures across systems
- Performance regressions
- Production-like failures hard to reproduce locally

## When NOT to Use

- Simple syntax errors or typos -> use linter
- Known error with clear fix -> just fix it
- Single-line obvious bug -> don't over-engineer
- Configuration issues -> check docs first

## Basic Workflow (6 steps)

Use this for straightforward bugs where you have a clear error message and a single suspect.

### Step 1: Reproduce

Run the failing command or test. Capture the exact error message, stack trace, and environment details. If the user provided reproduction steps, follow them exactly. If not, ask.

Write down:
- **Command:** what was run
- **Expected:** what should happen
- **Actual:** what happened instead
- **Error:** full error text

### Step 2: Search

Look for the root cause in recent changes and related code:
1. Run `git log --oneline -20` to check recent commits
2. Run `git diff HEAD~5` if the bug appeared recently
3. Grep the codebase for the error message or key terms
4. Check related test files for clues

### Step 3: Isolate

Find the minimal failing case:
1. Narrow down to the smallest input/config that triggers the bug
2. Comment out unrelated code to confirm the scope
3. Identify the exact file, function, and line where behavior diverges

### Step 4: Hypothesize

Form ONE testable theory: "I think [component] is broken because [reason], which would explain [symptom]."

State what you expect to see if the hypothesis is true vs. false.

### Step 5: Test

Make the smallest possible change to prove or disprove your hypothesis:
- If confirmed: proceed to fix
- If rejected: return to Step 2 with new information

Do NOT change multiple things at once.

### Step 6: Verify

1. Run the original reproduction steps — confirm the bug is gone
2. Run the full test suite — confirm no regressions
3. Run lint and type checks if available
4. Describe the root cause in one sentence

**Output:** Root cause + minimal fix + verification results.

## Advanced Workflow (10 steps)

Use this for complex bugs: flaky tests, race conditions, multi-system integration failures, or anything that resisted the basic workflow.

### Step 1: Intake

Parse the bug report. Extract and document:
- Reproduction steps (exact commands)
- Frequency (always, intermittent, specific conditions)
- When it started (commit, deploy, config change)
- Scope (single file, module, system-wide)

If any of these are missing, ask the user before proceeding.

### Step 2: Context Detection

Detect the tech stack automatically:
1. Check for `package.json`, `go.mod`, `requirements.txt`, `Cargo.toml`, `Gemfile`
2. Read `CLAUDE.md` for project-specific commands and architecture notes
3. Identify the test runner, build system, and linter in use
4. Note the relevant framework (React, Express, Django, etc.)

### Step 3: Evidence Gathering

Collect all available evidence before forming theories:
1. Run the failing test or reproduction steps — capture full output
2. Search git log for recent changes to the affected files: `git log --oneline -20 -- <path>`
3. Grep for the error message across the codebase
4. Check if the same test passes on main: `git stash && <test-command> && git stash pop`
5. Look for related open issues or TODO comments

Record findings using the [evidence log template](templates/evidence-log.md).

### Step 4: Hypothesis Matrix

Create a table with 3 or more theories. For each theory, list supporting evidence and conflicting evidence. Use the [hypothesis matrix template](templates/hypothesis-matrix.md).

```
| # | Hypothesis | Supporting Evidence | Conflicting Evidence | Test | Status |
|---|-----------|-------------------|---------------------|------|--------|
| 1 | [theory]  | [what supports it] | [what contradicts]  | [how to test] | untested |
| 2 | [theory]  | [what supports it] | [what contradicts]  | [how to test] | untested |
| 3 | [theory]  | [what supports it] | [what contradicts]  | [how to test] | untested |
```

Do NOT skip this step. Writing out competing theories prevents confirmation bias.

### Step 5: Rank

Order hypotheses by likelihood based on evidence weight. Consider:
- How much supporting evidence vs. conflicting evidence
- Occam's razor — simpler explanations rank higher
- Recent changes — bugs from recent commits rank higher

Test the highest-ranked hypothesis first.

### Step 6: Test Design

For the top hypothesis, design a minimal test:
- What single change would prove it true?
- What single change would prove it false?
- What is the expected output in each case?

Write the test before making any fix.

### Step 7: Isolated Test

Protect the working tree while testing:
1. Create a branch: `git checkout -b debug/<short-name>`
2. Apply only the minimal test change
3. Run the test
4. Record result: confirmed or rejected

If rejected, update the hypothesis matrix status and move to the next hypothesis. Return to Step 5.

### Step 8: Implement Fix

Once a hypothesis is confirmed, implement the smallest possible fix:
- Change only the lines necessary to resolve the root cause
- Do not refactor unrelated code in the same change
- Add a regression test that would have caught this bug

### Step 9: Backpressure Check

Run the full verification suite for the project:
1. **Tests:** Run the full test suite (not just the failing test)
2. **Lint:** Run the project linter
3. **Type check:** Run type checker if available (tsc, mypy, etc.)
4. **Build:** Run the build command to confirm nothing is broken

If any gate fails, fix it before proceeding. Do not carry errors forward.

### Step 10: Document

Record the debugging outcome:
1. **Root cause:** One sentence explaining why the bug occurred
2. **Fix:** What was changed and why
3. **Regression test:** What test was added to prevent recurrence
4. **Lesson:** Add an entry to `tasks/lessons.md` with the pattern:
   - What went wrong
   - Why it was hard to find
   - How to catch it faster next time

## Hypothesis Matrix Format

Use this template when debugging complex issues:

```
| # | Hypothesis | Supporting Evidence | Conflicting Evidence | Test | Status |
|---|-----------|-------------------|---------------------|------|--------|
| 1 | [theory]  | [what supports it] | [what contradicts]  | [how to test] | untested/confirmed/rejected |
```

Fill in at least 3 rows before testing any hypothesis. Update the Status column as you work through them.

## Anti-Patterns

- **Shotgun debugging** — changing multiple things at once hoping something works. Change one thing at a time, measure, then decide.
- **Skipping reproduction** — jumping to fix without confirming the bug exists in your environment. Always reproduce first.
- **Confirmation bias** — only looking for evidence that supports your first theory. The hypothesis matrix forces you to consider alternatives.
- **Drive-by fixes** — fixing symptoms without understanding root cause. If you can't explain WHY it broke, you haven't found the real bug.
- **Not verifying** — declaring "fixed" without running the original reproduction steps plus the full test suite.
- **Ignoring flakiness** — treating intermittent failures as one-offs. Flaky tests indicate race conditions, timing issues, or shared state — they deserve the advanced workflow.

## Language-Specific Expertise

Load the relevant guide from `expertise/` based on the detected tech stack:

- `expertise/general.md` — language-agnostic debugging (git bisect, Docker, APIs, CI/CD, race conditions)
- `expertise/javascript.md` — Node.js, async/await, event loop, React, bundler issues
- `expertise/python.md` — import errors, virtualenv, async, Django/FastAPI
- `expertise/go.md` — nil pointers, goroutine leaks, interface errors, module issues
- `expertise/rust.md` — borrow checker, lifetime errors, unsafe, async runtime

Read the matching file before starting Step 2 (Search) in the basic workflow or Step 3 (Evidence Gathering) in the advanced workflow.

## Cross-References

- After fixing: record lesson in `tasks/lessons.md`
- For project-wide quality: use `/audit-quality`
- For loading domain expertise: use `/expertise-loader` to load language-specific debugging knowledge
- For systematic plan execution: use `/execute-plan`
- For continuous autonomous fix cycles: use `/autonomous-loop`
- For creating a regression test rule: use `/create-rule`
