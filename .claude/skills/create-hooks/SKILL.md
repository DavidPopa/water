---
name: create-hooks
description: Create Claude Code hooks for event-driven automation. Use when user says 'create hook', 'add hook', 'setup automation', 'pre-commit hook', 'auto-format', 'block dangerous commands'. For git hooks, use standard git hooks. For rules, use create-rule instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
argument-hint: "[hook-description]"
---

# Create Hooks

Create event-driven automation hooks for Claude Code workflows.

Create hook: $ARGUMENTS

## When to Use

- Auto-run commands before/after tool use (PreToolUse, PostToolUse)
- Block dangerous operations (rm -rf, force push, destructive commands)
- Auto-format code after edits (prettier, black, gofmt)
- Validate commits match conventions before they run
- Log operations for audit trail
- Session setup/teardown automation

## When NOT to Use

- Simple behavioral rules -> use `/create-rule` instead
- Git-specific hooks (pre-commit, pre-push) -> use standard git hooks in `.git/hooks/`
- One-time automation -> just run the command directly
- Skill-level workflows -> use `/create-skill` instead
- Custom tool server for Claude -> use `/create-mcp-server` instead
- Simple slash command shortcut -> use `/create-command` instead

## Hook Types

| Type | Triggers | Blocking? | Use For |
|------|----------|-----------|---------|
| PreToolUse | Before a tool runs | Yes (can block) | Validation, safety gates |
| PostToolUse | After a tool runs | No | Logging, formatting, notifications |
| Stop | Before Claude stops | Yes | Cleanup, summary generation |
| UserPromptSubmit | Before prompt sent | Yes | Input validation, context injection |

## Hook Format

Hooks live in `.claude/settings.json` or `.claude/settings.local.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "command": "/path/to/check-script.sh",
        "timeout": 5000
      }
    ]
  }
}
```

**Two hook types:**

1. **Command hooks** — Run a shell command. For blocking hooks (PreToolUse), return JSON:
   ```json
   {"decision": "block", "reason": "Operation not allowed"}
   ```
   Return empty or `{"decision": "allow"}` to permit.

2. **Prompt hooks** — LLM evaluates a prompt, decides allow/block. Use `"prompt"` key instead of `"command"`.

**Matcher patterns:**
- `"Bash"` — all Bash commands
- `"Write"` — all file writes
- `"Write|Edit"` — writes and edits
- `"Bash(git commit*)"` — only git commit commands
- `"Bash(rm *)"` — only rm commands
- No matcher — fires for all tools of that event type

## Invocation

```
/create-hooks                                # interactive — asks what to automate
/create-hooks block force push               # direct — parses intent from args
/create-hooks auto-format after edits        # direct — creates formatting hook
/create-hooks --list                         # show all current hooks
/create-hooks --audit                        # check hooks for conflicts and loops
```

## Workflow

### Step 1: Parse the Request

If `$ARGUMENTS` is `--list`, jump to [Special: --list](#create-hooks---list).
If `$ARGUMENTS` is `--audit`, jump to [Special: --audit](#create-hooks---audit).

If `$ARGUMENTS` is provided, parse intent:
- **What event?** — What triggers this? (tool use, session event, prompt)
- **What action?** — Block, format, log, validate, or custom?
- **What tools?** — Which tools should trigger? (Bash, Write, Edit, all)

If not provided, ask:
1. What should the hook do?
2. When should it fire? (before/after which tool or event)
3. Should it block operations or just observe?

### Step 2: Audit Existing Hooks

Read `.claude/settings.json` and `.claude/settings.local.json`:
- Check for existing hooks on the same event+matcher
- Detect potential conflicts (two PreToolUse hooks on same matcher)
- Warn if adding a blocking hook where one already exists

### Step 3: Select Hook Type and Design

Match need to hook type:

| Need | Event | Blocking | Hook Type |
|------|-------|----------|-----------|
| Block dangerous command | PreToolUse | Yes | Command |
| Auto-format after edit | PostToolUse | No | Command |
| Validate commit message | PreToolUse | Yes | Command |
| Log all tool usage | PostToolUse | No | Command |
| Inject context into prompt | UserPromptSubmit | Yes | Prompt |
| Cleanup before stop | Stop | Yes | Command |

### Step 4: Write Hook Logic

For **command hooks**, create a shell script:
- Place scripts in `.claude/hooks/` directory
- Script receives tool input via stdin as JSON
- For blocking hooks: output JSON with `decision` and `reason`
- Make script executable (`chmod +x`)
- Use `$CLAUDE_PROJECT_DIR` for project-relative paths

For **prompt hooks**, write the evaluation prompt:
- Clear instruction on what to allow/block
- Reference `$ARGUMENTS` for dynamic content

### Step 5: Loop Prevention Check

Before saving, verify the hook won't cause infinite loops:
- A PostToolUse hook on `Write` that writes a file triggers itself
- A PostToolUse hook on `Bash` that runs a bash command triggers itself
- A PreToolUse hook on `Edit` that edits settings triggers itself

**Fix:** Use specific matchers to exclude hook's own files, or use file-path filters in the script.

### Step 6: Configure

Add the hook to the appropriate settings file:
- **Project-wide hooks** -> `.claude/settings.json` (committed, shared)
- **Personal hooks** -> `.claude/settings.local.json` (gitignored, local only)

Read existing file, merge the new hook entry, write back valid JSON.

### Step 7: Test

Instruct user to verify:
```
claude --debug
```
Then trigger the hook's event and confirm it fires correctly.

### Step 8: Confirm

Report to user:
```
Hook created: [description]
Event: PreToolUse | Matcher: Bash(git push*)
File: .claude/settings.json
Script: .claude/hooks/block-force-push.sh

Test: Run `claude --debug`, then try the triggering command.
```

## Special Commands

### /create-hooks --list

Read `.claude/settings.json` and `.claude/settings.local.json`, display all hooks:

```
## Project Hooks (.claude/settings.json)
  PreToolUse | Bash(git push*) | block-force-push.sh | timeout: 5000
  PostToolUse | Write|Edit | auto-format.sh | timeout: 10000

## Local Hooks (.claude/settings.local.json)
  PostToolUse | Bash | audit-log.sh | timeout: 3000

Total: 3 hooks (2 project, 1 local)
```

If no hooks found, say "No hooks configured. Use `/create-hooks` to add the first one."

### /create-hooks --audit

Analyze all configured hooks for issues:

1. **Loop risk** — PostToolUse hooks that could trigger themselves
2. **Timeout issues** — hooks without timeout or with excessive timeout (>30s)
3. **Missing scripts** — hooks referencing scripts that don't exist
4. **Conflicting matchers** — multiple blocking hooks on same event+matcher
5. **Dead hooks** — hooks for tools/patterns no longer used in the project

Output:
```
## Hook Audit Report

### Issues Found
- LOOP RISK: PostToolUse on Write runs format.sh which writes files
- MISSING: PreToolUse references .claude/hooks/old-check.sh (file not found)
- NO TIMEOUT: PostToolUse audit-log.sh has no timeout set

### Summary
- 4 hooks across 2 files
- 2 issues found
- Suggested fixes provided above
```

## Anti-Patterns

- **Infinite loops** — PostToolUse on Write that triggers another Write. Always check if your hook's action would re-trigger itself. Use specific matchers or file-path exclusions.
- **Over-blocking** — PreToolUse that blocks too many legitimate operations. Be precise with matchers: `Bash(rm -rf *)` not just `Bash`.
- **No timeout** — Hooks without timeout can hang Claude indefinitely. Always set timeout (3000-10000ms for most hooks).
- **Side effects in PreToolUse** — Blocking hooks should only validate, not modify files or state. Save modifications for PostToolUse.
- **Hardcoded paths** — Use `$CLAUDE_PROJECT_DIR` or `$PWD` instead of absolute paths. Hooks must work across machines.
- **No error handling** — Hook script that crashes blocks the whole workflow. Always handle failures gracefully with a default allow/deny.
- **Putting logic in settings.json** — Inline commands get messy. Use separate scripts in `.claude/hooks/` for anything beyond a one-liner.

## Cross-References

- For behavioral rules: `/create-rule`
- For skill workflows: `/create-skill`
- For slash commands: `/create-command`
- For subagent definitions: `/create-agent`
- For prompt engineering: `/create-meta-prompt`
- For MCP tool servers: `/create-mcp-server`
- For project setup including hook recommendations: `/onboard-project`
- For quality validation of hooks: `/audit-quality`
- See [hook-patterns.md](templates/hook-patterns.md) for copy-paste hook patterns
