---
description: Fix a bug based on description, error message, or failing test
argument-hint: "[bug-description-or-error]"
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
---

# Quick Bug Fix

Find the root cause of a bug and apply a minimal fix.

## Input

Bug report: $ARGUMENTS

## Steps

1. Parse `$ARGUMENTS` to classify the input:
   - **Error message**: extract the error text, file path, and line number if present
   - **Failing test**: extract the test name or file path
   - **Description**: extract keywords describing the broken behavior
2. Locate the source:
   - For error messages: search the codebase with `Grep` for the error string, trace to the origin
   - For failing tests: run the test command, read the failure output, find the tested code
   - For descriptions: search for relevant functions, variables, and files matching the keywords
3. Read the relevant source files. Understand the intended behavior vs actual behavior.
4. Identify the root cause. Do not patch symptoms — fix the underlying problem.
5. Apply the minimal fix using `Edit`. Change only what is necessary.
6. Verify the fix:
   - If a test runner is configured (check `package.json`, `Makefile`, `pyproject.toml`), run the relevant tests
   - If a linter is configured, run it on changed files
   - If neither exists, re-read the changed code to confirm correctness
7. Report what was changed:
   ```
   Root cause: [one sentence]
   Fix: [what was changed and why]
   Files modified: [list]
   Verification: [test/lint results or manual confirmation]
   ```
