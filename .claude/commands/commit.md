---
description: Create a git commit with an auto-generated conventional message
allowed-tools: Bash, Read, Grep
argument-hint: ""
---

# Smart Commit

Generate a conventional commit message from staged changes and commit.

## Steps

1. Run `git diff --cached` to check for staged changes.
2. If nothing is staged, run `git diff` and `git status` to show unstaged changes. Ask the user what to stage. Stop until they respond.
3. Analyze the staged diff to determine:
   - What files changed and what the changes do
   - The commit type: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `style`, `ci`, `build`
   - An optional scope (module or area affected)
4. Generate a commit message in conventional commits format: `type(scope): description`
   - Description must be lowercase, imperative mood, under 72 characters
   - Add a body paragraph if the change is non-trivial (what and why, not how)
5. Show the proposed message to the user. Wait for approval or edits.
6. On approval, commit with the message. Append a blank line and `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>` to the commit body.
7. Run `git log --oneline -1` and show the resulting commit hash and message.
