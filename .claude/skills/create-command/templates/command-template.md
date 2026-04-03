---
description: [What this command does — one sentence]
argument-hint: "[argument-description]"
allowed-tools: Read, Write, Edit, Bash
---

# [Command Name]

[One-line description of what this command does.]

## Input

Command: $ARGUMENTS

## Steps

1. [First action — be specific]
2. [Second action — reference $ARGUMENTS if needed]
3. [Third action — verify the result]

## Output

[What the user should see when done]

---

<!-- EXAMPLES — delete this section after creating your command -->

<!-- Example 1: Simple commit command -->
<!--
---
description: Stage all changes and create a conventional commit
argument-hint: "[commit-message]"
allowed-tools: Bash
---
Create a conventional commit with message: $ARGUMENTS
1. Run `git status` to see changes
2. Stage relevant files (not .env or credentials)
3. Create commit with message: $ARGUMENTS
4. Show the commit hash and summary
-->

<!-- Example 2: Deploy command -->
<!--
---
description: Deploy current branch to specified environment
argument-hint: "[environment]"
allowed-tools: Bash, Read
---
Deploy to environment: $ARGUMENTS
1. Verify current branch is clean (`git status`)
2. Run tests (`npm test`)
3. If tests pass, deploy to $ARGUMENTS environment
4. Verify deployment health check
5. Report success or failure with details
-->

<!-- Example 3: Format command (no arguments) -->
<!--
---
description: Format all source files and fix lint errors
allowed-tools: Bash
---
1. Run `npm run format` to format all files
2. Run `npm run lint -- --fix` to auto-fix lint issues
3. Show summary of files changed
-->
