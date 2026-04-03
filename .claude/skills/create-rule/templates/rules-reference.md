# Rules Reference — Common Rules by Project Type

> Claude's reference when generating rules. Real, battle-tested examples per category.

---

## General (any project)

### Guards
- **Never commit .env files** — secrets leak to git history permanently
- **Never modify generated files** — they get overwritten (lock files, compiled output, codegen)
- **Never hardcode URLs** — use environment variables for all external endpoints
- **Never skip error handling on external calls** — APIs, DB, filesystem can all fail

### Workflow
- **Always run the full test suite before marking done** — prevents regressions
- **Always create a new branch for each task** — never commit directly to main
- **Always check git diff before committing** — catch accidental changes

### Security
- **Never store passwords as plain text** — always hash with bcrypt/argon2
- **Never log sensitive data (tokens, passwords, PII)** — redact before logging
- **Validate all user input at the boundary** — never trust client data

---

## JavaScript / TypeScript

### Style
- **Use ES modules (`import/export`), not CommonJS (`require`)** — project standard
- **Use `const` by default, `let` only when reassignment is needed** — never `var`
- **Prefer named exports over default exports** — easier to refactor and search
- **Use strict TypeScript (`strict: true`)** — catches null/undefined errors at compile time

### Architecture
- **Keep components under 200 lines** — split if larger
- **Co-locate tests with source files** — `Component.test.tsx` next to `Component.tsx`
- **API routes handle HTTP only** — business logic goes in services/

### Testing
- **Every utility function needs a unit test** — no exceptions
- **Mock external dependencies, not internal modules** — test real behavior
- **Use `describe/it` blocks, not standalone `test()`** — consistent structure

---

## Python

### Style
- **Use type hints on all function signatures** — `def foo(x: int) -> str:`
- **Use `pathlib.Path`, not `os.path`** — modern, cross-platform
- **Use f-strings, not `.format()` or `%`** — cleaner, faster

### Architecture
- **One class per file for models** — keep model files focused
- **Use dependency injection, not global imports** — testable code
- **Keep `__init__.py` files minimal** — no business logic

### Testing
- **Use `pytest`, not `unittest`** — simpler syntax, better fixtures
- **Use fixtures for test data, not setUp/tearDown** — composable
- **Every bug fix needs a regression test** — proves the fix works

---

## React / Next.js

### Style
- **Functional components only** — no class components
- **Use hooks for state and effects** — `useState`, `useEffect`, custom hooks
- **Destructure props in function signature** — `function Card({ title, body })`

### Architecture
- **Feature-based folder structure** — `features/auth/`, `features/dashboard/`
- **Shared components in `components/ui/`** — reusable, no business logic
- **Server components by default, `'use client'` only when needed** — Next.js 14+

### Guards
- **Never use `dangerouslySetInnerHTML`** — XSS vulnerability
- **Never store sensitive data in localStorage** — use httpOnly cookies

---

## Database

### Guards
- **Never run migrations on production without backup** — data loss risk
- **Never use `DROP TABLE` or `DELETE` without `WHERE`** — catastrophic data loss

### Style
- **Use UUIDs for public-facing IDs** — sequential IDs leak information
- **Timestamps on every table** — `created_at`, `updated_at` minimum
- **Soft delete by default** — `deleted_at` column instead of actual deletion

---

## API Design

### Style
- **Use plural nouns for endpoints** — `/users`, not `/user`
- **Return consistent error format** — `{ error: { code, message, details } }`
- **Use HTTP status codes correctly** — 201 for created, 404 for not found, 422 for validation

### Guards
- **Every endpoint needs authentication** — except explicitly public ones (list them)
- **Rate limit all public endpoints** — prevent abuse

---

## Skills Rules

Rules about when and how to use Claude Code skills:

- **Use `/debug-expert` for bugs, not manual printf debugging** — structured approach finds root cause faster
- **Use `/plan-project` before any multi-session feature** — prevents rework from unclear scope
- **Use `/create-rule` after any user correction** — captures the lesson permanently
- **Never invoke `/execute-plan` without a verified plan file** — garbage in, garbage out

## Automation Rules

Rules about hooks, pre-commit checks, and automated triggers:

- **Pre-commit hook must run typecheck and lint** — catches errors before they enter git history
- **Never disable pre-commit hooks with --no-verify** — fix the issue, don't skip the gate
- **Post-tool hooks must not block for more than 5 seconds** — keeps the workflow responsive
- **All CI gates must pass before marking a task done** — no exceptions, no "fix later"

## Memory Rules

Rules about what to persist and what to forget across sessions:

- **Always update MEMORY_{dev}.md at session end** — next session starts with context
- **Never store secrets or tokens in memory files** — memory files are committed to git
- **Update tasks/lessons.md after any user correction** — pattern: mistake, root cause, fix
- **Keep MEMORY files under 100 lines** — summarize, don't append endlessly
