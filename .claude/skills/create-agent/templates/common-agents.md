# Common Agents — Reference

> Claude consults this when creating agents. Real examples, battle-tested.

---

## Read-Only Agents (haiku)

### code-reviewer
```yaml
model: haiku
description: Review code changes for bugs, security issues, missing error handling. Use after completing implementation to self-review before reporting done.
allowed_tools: [Read, Bash, Glob, Grep]
```
Process: git diff — read files — check issues — npx tsc --noEmit — report

### test-runner
```yaml
model: haiku
description: Run tests, type checks, and linting. Use after making changes to verify everything passes.
allowed_tools: [Read, Bash]
```
Process: run test command — capture output — report pass/fail

### dependency-checker
```yaml
model: haiku
description: Check for outdated, unused, or vulnerable dependencies. Use before major releases or monthly.
allowed_tools: [Read, Bash]
```
Process: npm audit — npm outdated — check unused — report

### log-analyzer
```yaml
model: haiku
description: Analyze error logs to find patterns and root causes. Use when debugging production issues.
allowed_tools: [Read, Bash, Grep]
```
Process: read logs — grep patterns — group by frequency — report root cause

---

## Research Agents (sonnet)

### explore-codebase
```yaml
model: sonnet
description: Explore and map codebase structure. Use when starting new project or unfamiliar area.
allowed_tools: [Read, Bash, Glob, Grep]
```
Process: ls structure — read key files — map dependencies — summarize architecture

### research
```yaml
model: sonnet
description: Research a topic by reading docs, code, and web. Use for technical decisions or unfamiliar tech.
allowed_tools: [Read, Bash, Glob, Grep, WebSearch, WebFetch]
```
Process: search — read sources — synthesize — present options with tradeoffs

---

## Write Agents (sonnet/opus)

### scaffolder
```yaml
model: sonnet
description: Generate boilerplate code from templates. Use when creating new components, routes, or modules.
allowed_tools: [Read, Write, Edit, Bash, Glob]
```
Process: detect project conventions — generate files — verify they compile

### migration-writer
```yaml
model: sonnet
description: Write database migration files. Use when schema changes are needed.
allowed_tools: [Read, Write, Bash, Glob]
```
Process: read current schema — generate migration — verify it runs — rollback test

---

## QA Agents (haiku/sonnet) — New in 2.0

### skill-auditor
```yaml
model: haiku
description: Audit a skill for 2.0 format compliance. Use after creating or modifying a skill to check frontmatter, triggers, anti-patterns, and line counts.
allowed_tools: [Read, Bash, Glob, Grep]
```
Process: read SKILL.md — validate frontmatter YAML — check required sections (When to Use, When NOT to Use, Anti-Patterns) — verify line count — report issues

### rule-auditor
```yaml
model: haiku
description: Audit rules/ directory for vague rules, contradictions, and gaps. Use periodically or after adding new rules.
allowed_tools: [Read, Glob, Grep]
```
Process: read all rules/*.md — check for vague language — find contradictions across files — identify missing categories — report findings

---

## Agent Selection Quick Reference

| Need | Agent | Model | Why |
|------|-------|-------|-----|
| Check code quality | code-reviewer | haiku | Fast, cheap, pattern matching |
| Run test suite | test-runner | haiku | Just executes commands |
| Check dependencies | dependency-checker | haiku | Simple command output |
| Analyze logs | log-analyzer | haiku | Pattern matching in text |
| Understand new codebase | explore-codebase | sonnet | Needs reasoning about structure |
| Research a technology | research | sonnet | Needs synthesis and judgment |
| Generate boilerplate | scaffolder | sonnet | Needs to follow conventions |
| Write migrations | migration-writer | sonnet | Needs schema understanding |
| Validate skill format | skill-auditor | haiku | Checklist-based validation |
| Audit project rules | rule-auditor | haiku | Pattern matching and comparison |
