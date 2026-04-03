---
description: Review current code changes for bugs, security issues, and best practices
argument-hint: "[file-or-branch]"
allowed-tools: Bash, Read, Grep, Glob
---

# Code Review

Review code changes and report issues by severity.

## Input

Target: $ARGUMENTS

## Steps

1. Determine what to review:
   - If `$ARGUMENTS` is a file path: review that file's contents
   - If `$ARGUMENTS` is a branch name: review `git diff $ARGUMENTS...HEAD`
   - If `$ARGUMENTS` is empty: review `git diff` (unstaged) and `git diff --cached` (staged)
2. If the diff is empty and no file specified, report "No changes to review." and stop.
3. Read the full diff or file content. For each change, check:
   - **Bugs**: logic errors, off-by-one, null/undefined access, race conditions, wrong variable usage
   - **Security**: injection (SQL/XSS/command), hardcoded secrets, missing auth checks, path traversal, insecure dependencies (OWASP top 10)
   - **Error handling**: uncaught exceptions, missing try/catch, swallowed errors, missing validation
   - **Performance**: N+1 queries, unnecessary loops, missing indexes, large memory allocations
   - **Style**: naming conventions, dead code, missing types, inconsistent patterns
4. For each issue found, report in this format:
   ```
   [SEVERITY] file:line — description
   Suggested fix: what to change
   ```
   Severity levels: `CRITICAL`, `WARNING`, `INFO`
5. End with a summary line: `Found X issues (Y critical, Z warnings, W info)`
6. If no issues found: "Code looks clean. No issues found."
