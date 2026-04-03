# Expertise Template: {TECHNOLOGY_NAME}

Use this template to create new expertise files for custom tech stacks.
Place the completed file in `.claude/skills/debug-expert/expertise/`.

---

## Common Errors

| Error Pattern | Root Cause | Fix |
|--------------|-----------|-----|
| `ErrorMessage` | Why it happens | How to resolve |
| `ErrorMessage` | Why it happens | How to resolve |

## Debugging Tools

- **Tool 1** — what it does, when to use it
- **Tool 2** — what it does, when to use it
- **Key command:** `command --flag` — what it reveals

## Environment Issues

- **Setup pitfall:** description and workaround
- **Version conflict:** which versions clash and how to resolve
- **Config gotcha:** common misconfiguration and correct setting

## Framework-Specific

- **Pattern:** recommended way to do X in this framework
- **Anti-pattern:** what NOT to do and why
- **Migration note:** breaking changes between major versions

---

## Writing Guidelines

- Keep entries actionable: error -> cause -> fix (not theory)
- One line per issue, use tables for error catalogs
- Include exact error messages users will grep for
- Focus on non-obvious issues (skip what IDE/linter catches)
- Update when new patterns emerge from tasks/lessons.md
- Target: under 80 lines for the completed expertise file
