---
name: create-agent
description: Create a new Claude Code subagent definition. Use when user says 'create agent', 'new agent', 'make agent', 'build agent'. For creating skills, use create-skill instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
argument-hint: "[agent-name]"
---

# Create Agent

Create an agent named: $ARGUMENTS

Generates Claude Code subagent definitions (.md files in `.claude/agents/`).

## When to Use

- You need to delegate a specific job to an isolated Claude instance
- A task is repetitive and can be standardized (review, test, lint)
- You want a cheaper/faster model for a focused task

## When NOT to Use

- **You need reusable instructions** — use `/create-skill` instead (skills = instructions, agents = delegation)
- **The task needs conversation context** — agents run isolated, they cannot see your chat
- **A one-off task** — just do it in the main conversation, no need for an agent
- **You need to create quality checks** — use `/audit-quality` instead

## Quick Recap: What's an Agent

An agent is a separate Claude instance that:
- Runs in its own context window (isolated from main conversation)
- Can use a different model (haiku = cheap/fast, sonnet = balanced, opus = powerful)
- Has restricted tools (only what it needs)
- Does ONE job and reports back

## Step 1: Gather Info

Ask (skip what's obvious from $ARGUMENTS or context):

1. **What does the agent do?** (1 sentence)
2. **When does it activate?** (after implementation? on request? on bug report?)
3. **What model?** — suggest based on task:
   - `haiku` — fast, cheap. Best for: lint, test run, simple checks, formatting, log analysis
   - `sonnet` — balanced. Best for: code review, refactoring analysis, research, scaffolding
   - `opus` — powerful reasoning. Best for: architectural decisions, complex debugging, planning, multi-file analysis
4. **What tools does it need?**
   - Read-only (review, analyze): `Read, Bash, Glob, Grep`
   - Write (fix, generate): `Read, Write, Edit, Bash, Glob, Grep`
   - Run-only (test, lint): `Read, Bash`
5. **Where to save?**
   - `.claude/agents/` — per project (in git, whole team)
   - `~/.claude/agents/` — personal (just you)

### Context Fork Pattern (Advanced)

For agents that need full isolation with their own tool permissions:

```yaml
context: fork
```

Use `context: fork` when the agent:
- Needs to run a long task without blocking the main conversation
- Should not have access to the parent conversation's state
- Runs expensive operations (research, full codebase analysis)

## Step 2: Generate Agent File

Agent files are simple. Max 30 lines of content. Format:

```markdown
---
name: {agent-name}
model: {haiku|sonnet|opus}
description: {what it does}. {when to use it}.
allowed_tools:
  - {Tool1}
  - {Tool2}
---

# {Agent Title}

{One line: what you do.}

## Process
1. {Step 1}
2. {Step 2}
3. {Step 3}

## Rules
- {Rule 1}
- {Rule 2}
- {Rule 3}
```

### Writing Rules

1. **name**: kebab-case, max 2-3 words
2. **description**: Two parts — WHAT it does + WHEN to use it (this is the trigger)
3. **model**: default `haiku` unless the task needs reasoning
4. **Process**: max 5 steps, concrete, numbered
5. **Rules**: max 5 rules, start with the most critical
6. **Total file**: under 30 lines of content (agents are lightweight, not skills)
7. **First rule**: "NEVER modify code" (read-only agents) or "ALWAYS verify before writing" (write agents)

### Model Selection Guide

| Task Complexity | Model | Cost | Examples |
|----------------|-------|------|----------|
| Simple checks, formatting | haiku | Low | lint, test-runner, log-analyzer |
| Analysis, code generation | sonnet | Medium | code-reviewer, scaffolder, research |
| Complex reasoning, architecture | opus | High | planner, debugger, migration-writer |

**Default to haiku** unless you have a specific reason for a more expensive model.

## Step 3: Write File

Write to `{target}/{agent-name}.md`

Confirm:
```
Agent creat: {agent-name}
Model: {model}
Locatie: .claude/agents/{agent-name}.md
Tools: {list}

Se activeaza cand: {trigger description}
```

## Step 4: Validate

- [ ] Frontmatter has all 4 fields (name, model, description, allowed_tools)
- [ ] name is kebab-case
- [ ] description has WHAT + WHEN
- [ ] model matches task complexity (don't use opus for lint)
- [ ] allowed_tools is minimal (no tools it doesn't need)
- [ ] Process is under 5 steps
- [ ] Rules are under 5
- [ ] Total content under 30 lines
- [ ] No overlap with existing agents (check `.claude/agents/` and `~/.claude/agents/`)

## Cross-References

- **Creating skills**: Use `/create-skill` for reusable instructions (not delegation)
- **Creating rules**: Use `/create-rule` for adding project rules and constraints
- **Creating commands**: Use `/create-command` for simple slash command shortcuts
- **Creating hooks**: Use `/create-hooks` for event-driven automation
- **Creating MCP servers**: Use `/create-mcp-server` for custom tool servers
- **Creating prompts**: Use `/create-meta-prompt` for writing and refining prompt content
- **Quality checks**: Use `/audit-quality` to validate agent definitions
- **Project setup**: Use `/onboard-project` for full project onboarding (recommends agents)
- **Common agent patterns**: See [templates/common-agents.md](templates/common-agents.md) for battle-tested examples

## Anti-Patterns

- **Fat agents (50+ lines)** — that's a skill, not an agent. Agents are lightweight delegators.
- **Using opus for simple tasks** — haiku runs tests just fine, don't waste tokens
- **Giving write tools to read-only agents** — principle of least privilege, always
- **Vague description** — "helps with code" won't trigger correctly; be specific about WHAT and WHEN
- **Duplicating existing agents** — always check what exists first before creating
- **Agents that need conversation context** — agents run isolated, they don't see your chat history
- **Skipping validation** — always run the checklist before reporting done

## Supporting Files

- **Common agents**: See [templates/common-agents.md](templates/common-agents.md) for ready-to-use agent definitions
