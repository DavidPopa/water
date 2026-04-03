---
name: create-rule
description: Create or manage project rules in CLAUDE.md and rules/ directory. Use when user says 'add rule', 'new rule', 'create rule', 'coding rule', 'never do X', 'always do Y'. For creating skills, use create-skill instead. For creating agents, use create-agent instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
argument-hint: "[rule-description]"
---

# Create Rule

Add well-structured rules to the `rules/` directory with conflict detection and audit support.

## When to Use

- User wants to add a project rule or constraint
- User says "never do X" or "always do Y"
- User wants to codify a coding standard
- After a correction — capture the lesson as a rule
- User wants to see or audit existing rules

## When NOT to Use

- User wants to create a reusable workflow -> use `/create-skill` instead
- User wants to create a subagent -> use `/create-agent` instead
- User wants to configure linter rules -> edit linter config directly
- Rule is about a single file or one-time fix -> just fix it, no rule needed

## Invocation

```
/create-rule                              # interactive — asks what rule
/create-rule never modify vendor files    # direct — parses $ARGUMENTS as rule
/create-rule --list                       # show all current rules by file
/create-rule --audit                      # check rules for conflicts/gaps
```

## Workflow

### Step 1: Parse the Request

If `$ARGUMENTS` is `--list`, jump to [Special: --list](#create-rule---list).
If `$ARGUMENTS` is `--audit`, jump to [Special: --audit](#create-rule---audit).

If `$ARGUMENTS` is provided, parse intent directly as the rule description.
If not provided, ask:

1. **What rule?** — describe the behavior or constraint
2. **Why?** — what went wrong without this rule?

Then classify the rule:

| Type | Examples | Target file |
|------|----------|-------------|
| **guard** | "never modify X", "don't delete Y" | `rules/guards.md` |
| **style** | "use snake_case", "functional components" | `rules/style.md` |
| **arch** | "API routes need auth middleware" | `rules/architecture.md` |
| **test** | "every endpoint needs integration test" | `rules/testing.md` |
| **workflow** | "always run lint before commit" | `rules/workflow.md` |
| **domain** | "prices are always in cents" | `rules/domain.md` |
| **security** | "never store secrets in code" | `rules/security.md` |
| **skills** | "use debug-expert for bugs, not manual debugging" | `rules/skills.md` |
| **automation** | "pre-commit hook must run typecheck" | `rules/automation.md` |
| **memory** | "always update MEMORY.md at session end" | `rules/memory.md` |

### Step 2: Check for Conflicts

Before adding, search existing rules for conflicts:

1. **Grep `rules/` for keywords** from the new rule. Check each match.
2. **Duplicate?** — Similar rule exists? Suggest merging instead of adding.
3. **Contradiction?** — Conflicts with existing rule? Warn user, ask which wins.
4. **Too vague?** — If the rule isn't actionable and verifiable, rewrite it.

This step is mandatory. Never skip conflict detection.

### Step 3: Determine Location

- Rules go in `rules/{category}.md`, never directly in CLAUDE.md
- CLAUDE.md references `rules/` via the line: `Read all .md files in rules/`
- If the target file doesn't exist, create it with a header

### Step 4: Write the Rule

**Format:** `**[VERB] [WHAT]** — [WHY/CONTEXT]`

Good examples:
```markdown
- **Never modify files in /vendor** — third-party, changes get overwritten on update
- **All API routes must have auth middleware** — no public endpoints except /health
- **Use CSS modules, not Tailwind** — project convention, keeps styles co-located
- **Run `npm run typecheck` before marking done** — catches type errors early
```

**Quality checklist** (every rule must pass all):
- [ ] Starts with a verb (Never/Always/Use/Run/Add/Keep)
- [ ] Specific — mentions exact files, commands, or patterns
- [ ] Has context — explains WHY after the dash
- [ ] Actionable — Claude can follow it without ambiguity
- [ ] Verifiable — you can check if it was followed

If a rule fails any check, rewrite it until it passes.

### Step 5: Verify No Conflicts

After writing, re-read the target file and confirm:
- The new rule doesn't contradict any rule in the same file
- The new rule doesn't duplicate any rule in the same file
- The file isn't exceeding 15 rules (if so, suggest splitting)

### Step 6: Confirm with User

Show the result:
```
Rule added: rules/guards.md

  Never modify files in /vendor — third-party, changes get overwritten

Current rules in this file (3):
1. Never modify files in /vendor
2. All API routes must have auth middleware
3. Prices stored in cents (integer)
```

## Special Commands

### /create-rule --list

Read all `.md` files in `rules/` and display:

```
## rules/guards.md (3 rules)
- Never modify files in /vendor
- All API routes must have auth middleware
- Prices stored in cents (integer)

## rules/style.md (2 rules)
- Use ES modules, not CommonJS
- Functional components with hooks

Total: 5 rules across 2 files
```

If no `rules/` directory or no files, say "No rules found. Use `/create-rule` to add the first one."

### /create-rule --audit

Read all `.md` files in `rules/` and check for:

1. **Vague rules** — flag any that aren't actionable or verifiable
2. **Contradictions** — rules that conflict within or across files
3. **Gaps** — common categories missing (security? testing? guards?)
4. **Staleness** — rules referencing files or commands that don't exist in the project

Output format:
```
## Audit Report

### Issues Found
- VAGUE: rules/style.md line 3 — "write clean code" is not actionable
- CONFLICT: rules/guards.md#2 vs rules/workflow.md#1 — contradictory
- GAP: No security rules found — consider adding rules/security.md
- STALE: rules/testing.md#2 references `npm run jest` but no jest in package.json

### Summary
- 12 rules across 4 files
- 2 issues found, 1 gap identified
- Suggested fixes provided above
```

## Anti-Patterns

- **Overly broad rules** — "always write tests" without specifying what kind, when, or for what. Be specific: "every API endpoint needs an integration test"
- **Conflicting rules** — adding a new rule that contradicts an existing one without resolving the conflict first. Always run Step 2 before writing.
- **Implementation rules as domain rules** — mixing concerns like putting "use useState for forms" in domain.md. Match rule type to the correct category file.
- **Vague rules without context** — "be careful with the database" is not a rule. Rules must have a verb, a specific target, and a reason.
- **Putting rules directly in CLAUDE.md** — rules go in `rules/` folder. CLAUDE.md only references the folder.
- **Too many rules in one file** — if a file has 15+ rules, split into sub-categories
- **Rules that duplicate linter config** — use actual linters for formatting; rules files are for project-specific constraints Claude needs to follow

## Cross-References

- For rule quality validation, see `/audit-quality`
- For creating reusable workflows instead of rules, see `/create-skill`
- For creating subagent definitions, see `/create-agent`
- For creating slash commands, see `/create-command`
- For event-driven automation, see `/create-hooks`
- For MCP tool servers, see `/create-mcp-server`
- For prompt engineering, see `/create-meta-prompt`
- For full project setup including bulk rule generation, see `/onboard-project`
- CLAUDE.md is the primary config — it references `rules/` via "Read all .md files in rules/"
- See [rules-reference.md](templates/rules-reference.md) for example rules by project type
