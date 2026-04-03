---
name: create-command
description: Create a reusable Claude Code slash command for quick workflows. Use when user says 'create command', 'new command', 'slash command', 'add shortcut', 'quick command', 'comanda noua', 'creeaza comanda'. For complex multi-step workflows, use create-skill instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
argument-hint: "[command-name]"
---

# Create Command

Create a slash command: $ARGUMENTS

## When to Use

- Quick, single-purpose operation (commit, deploy, format, analyze)
- Shortcut for a frequently repeated prompt
- Simple parameterized command with `$ARGUMENTS`
- Team-wide consistent operations everyone should run the same way

## When NOT to Use

- Complex multi-step workflow with templates -> use `/create-skill` instead
- Behavioral rule or constraint -> use `/create-rule` instead
- Event-driven automation (pre-commit, post-save) -> use `/create-hooks` instead
- Custom tool server for Claude -> use `/create-mcp-server` instead
- One-time task -> just do it directly, no command needed

## Skills vs Commands

Commands are the SIMPLER option:

| Aspect | Command | Skill |
|--------|---------|-------|
| Files | Single `.md` file | Directory with `SKILL.md` + supporting files |
| Location | `.claude/commands/` | `.claude/skills/name/` |
| Complexity | Simple, single operation | Multi-step, with templates and validation |
| Arguments | `$ARGUMENTS`, `$1`, `$2` | `$ARGUMENTS` + full workflow logic |
| Best for | Quick shortcuts | Complex workflows with anti-patterns |

Both create `/slash-name` that works identically from the user's perspective. Skills are recommended for anything non-trivial.

## Command Format

A command is a single `.md` file with optional YAML frontmatter:

```markdown
---
description: What this command does
argument-hint: "[args]"
allowed-tools: Read, Write, Edit
---

Your prompt instructions here.
Use $ARGUMENTS for all user input.
Use $1, $2, $3 for positional arguments.
Use !`command` for dynamic context injection.
```

## Invocation

```
/create-command                        # interactive — asks what to create
/create-command deploy                 # creates a deploy command
/create-command review-pr              # creates a PR review command
```

## Basic Workflow

### Step 1: Gather Requirements

If `$ARGUMENTS` is provided, parse as command name and infer intent.
If not provided, ask:

1. **What operation?** — What does this command do? (1 sentence)
2. **Arguments?** — Does it take user input? What kind?
3. **Scope?** — Project-wide (`.claude/commands/`) or personal (`~/.claude/commands/`)?

### Step 2: Check for Conflicts

Search for existing commands with the same or similar name:

1. Glob `.claude/commands/*.md` for name matches
2. Glob `~/.claude/commands/*.md` for personal conflicts
3. Glob `.claude/skills/*/SKILL.md` for skill name conflicts
4. If conflict found: warn user and suggest rename or merge

### Step 3: Write the Command

Read the template from `${CLAUDE_SKILL_DIR}/templates/command-template.md` for reference.

Create the command file with:

- **YAML frontmatter** — `description` (required), `argument-hint` (if takes args), `allowed-tools` (if needs restrictions)
- **Instruction body** — Clear, numbered steps for Claude to follow
- **$ARGUMENTS** references — Use `$ARGUMENTS` for user input, never hardcode values

### Step 4: Save the Command

- **Project scope** (default): `.claude/commands/{command-name}.md`
- **Personal scope**: `~/.claude/commands/{command-name}.md`

Create the parent directory if it does not exist.

### Step 5: Confirm and Test

Show the result:

```
Command created: /command-name
Location: .claude/commands/command-name.md
Lines: X

Test with: /command-name [sample-args]
```

## Advanced Workflow

### Step 1: Parse $ARGUMENTS

Extract command name from `$ARGUMENTS`. If ambiguous, ask for clarification.

### Step 2: Check Existing Commands

Scan both `.claude/commands/` and `~/.claude/commands/` for conflicts. Also check `.claude/skills/` to avoid name collision with skills.

### Step 3: Design the Command

Plan the command structure:

- **Arguments** — `$ARGUMENTS` (all input), `$1`/`$2`/`$3` (positional)
- **Dynamic injection** — `!`git status`` or `!`cat package.json`` for runtime context
- **Tool restrictions** — `allowed-tools` for sensitive operations (git, deploy)
- **Preprocessing** — Validate arguments before executing

### Step 4: Write with Proper Structure

Create the command file. For commands that produce artifacts, include verification steps. For commands with arguments, include argument validation.

### Step 5: Scope Decision

| Scope | Location | When to use |
|-------|----------|-------------|
| Project | `.claude/commands/` | Team-shared, committed to git |
| Personal | `~/.claude/commands/` | Individual shortcuts, not in git |

### Step 6: Test the Command

Run `/command-name` with sample arguments. Verify:
- Command activates correctly
- Arguments are parsed properly
- Output matches expectations
- Error handling works for missing/invalid args

### Step 7: Document Usage

Add a comment block at the top of the command showing usage examples:

```markdown
<!-- Usage: /command-name [arg] -->
<!-- Example: /command-name fix-login-bug -->
```

## Dynamic Features Reference

| Feature | Syntax | Example |
|---------|--------|---------|
| All arguments | `$ARGUMENTS` | User passes "fix the login bug" |
| Positional args | `$1`, `$2`, `$3` | First, second, third word |
| Command injection | `` !`command` `` | `` !`git diff --staged` `` |
| Session ID | `${CLAUDE_SESSION_ID}` | Unique session identifier |

## Anti-Patterns

- **Over-engineering** — Command that needs templates, validation, multi-step logic should be a skill. Commands are for simple operations.
- **No description in frontmatter** — Claude cannot auto-suggest the command without a description. Always include one.
- **Hardcoded paths or values** — Use `$ARGUMENTS` instead of hardcoding repo names, file paths, or branch names.
- **Missing allowed-tools** — Command fails silently because it cannot access needed tools. List all tools the command requires.
- **Duplicate command names** — Not checking if a command or skill with the same name already exists. Always run conflict check.
- **No testing after creation** — Deploying a command without verifying it actually works. Always test with sample input.
- **Putting complex logic in commands** — If you need conditionals, loops, or error recovery, use a skill instead.

## Cross-References

- For complex workflows: `/create-skill`
- For event-driven automation: `/create-hooks`
- For behavioral rules: `/create-rule`
- For subagent definitions: `/create-agent`
- For prompt engineering: `/create-meta-prompt`
- For MCP tool servers: `/create-mcp-server`
- For project setup: `/onboard-project`
- For quality validation: `/audit-quality`
