---
name: onboard-project
description: Analyze a codebase and set up dragoon-setup configuration automatically. Use when user says 'onboard project', 'setup project', 'configure claude', 'analyze codebase', 'init dragoon', 'new project setup'. For creating individual rules, use create-rule instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
argument-hint: "[project-path]"
---

# Onboard Project

Onboard: $ARGUMENTS

## When to Use

- Setting up dragoon-setup on a NEW project
- Configuring Claude Code for an EXISTING project
- New team member joining a project
- Migrating from vanilla Claude Code to dragoon workflow

## When NOT to Use

- Project already has dragoon configured — just update rules
- Want to add a single rule — use `/create-rule`
- Want to plan a feature — use `/plan-project`

## Basic Workflow

### Step 1: Detect Tech Stack

Run the detect-project script to identify the tech stack:

```bash
bash scripts/detect-project.sh "${ARGUMENTS:-$(pwd)}"
```

If the script is not at `scripts/detect-project.sh`, search for it:
```bash
find . -name detect-project.sh -maxdepth 3 2>/dev/null | head -1
```

If the script is not available, scan manually for these files:
- `package.json` — Node.js (parse for next, react, vue, angular, express)
- `tsconfig.json` — TypeScript
- `requirements.txt` / `pyproject.toml` / `setup.py` — Python
- `go.mod` — Go
- `Cargo.toml` — Rust
- `pom.xml` / `build.gradle` — Java
- `Gemfile` — Ruby
- `docker-compose.yml` — Docker
- `.github/workflows/` — GitHub Actions
- `Makefile` — parse targets

### Step 2: Analyze Structure

Map the project layout:
1. **Source directories** — `src/`, `app/`, `lib/`, `pkg/`, `cmd/`
2. **Test directories** — `tests/`, `test/`, `__tests__/`, `spec/`
3. **Config files** — linter configs, CI files, docker files
4. **Documentation** — `docs/`, `README.md`
5. **Architecture pattern** — monorepo (workspaces/packages), monolith, serverless

### Step 3: Check Existing Config

Look for existing dragoon or Claude Code setup:
1. Check for `.claude/` directory
2. Check for `CLAUDE.md` — if it has `dragoon:section:` markers, dragoon is already installed
3. Check for `rules/` directory with existing rules
4. Check for `tasks/`, `plans/` directories

If dragoon is already configured, report what exists and ask if user wants to update/enhance rather than overwrite.

### Step 4: Generate CLAUDE.md

Using the template at `templates/CLAUDE_base.md`, fill in detected values:

1. **About This Project** — Parse README.md first line or package.json description
2. **Tech Stack** — Language, framework, database, deployment from Step 1
3. **Commands** — Build, test, lint, deploy commands from package.json scripts, Makefile, or CI config
4. **Code Standards / Style** — Detected formatter (Prettier, Black, gofmt), linter config
5. **Code Standards / Testing** — Detected test framework and conventions
6. **Code Standards / Architecture** — Detected patterns (feature folders, clean arch, etc.)
7. **QA Gates** — Auto-fill based on detected tools:

| Detected Tool | Gate | Command |
|--------------|------|---------|
| TypeScript | Type check | `npx tsc --noEmit` |
| ESLint | Lint | `npx eslint src/` |
| Prettier | Format | `npx prettier --check .` |
| pytest | Test | `pytest` |
| Jest | Test | `npx jest` |
| Vitest | Test | `npx vitest run` |
| Go | Test | `go test ./...` |
| Cargo | Test | `cargo test` |
| ruff | Lint | `ruff check .` |
| mypy | Type check | `mypy .` |
| clippy | Lint | `cargo clippy` |

Present the generated CLAUDE.md to the user for review before writing.

### Step 5: Suggest Rules

Based on detected tech stack, suggest rules from common patterns:

| Stack | Suggested Rules |
|-------|----------------|
| Node.js/TypeScript | ES modules, strict TypeScript, async/await patterns |
| React/Next.js | Functional components, hooks patterns, SSR considerations |
| Python | Type hints, docstrings, virtual environment |
| Go | Error handling patterns, goroutine safety |
| Rust | Unsafe usage rules, error handling with Result |
| Docker | Environment variable management, build optimization |
| API projects | Auth middleware, input validation, error responses |

Ask user which rules to create. Write approved rules to `rules/` directory using the format from `/create-rule`.

### Step 6: Summary

Present a summary of everything configured:

```
## Onboarding Complete

### Detected
- Language: {language}
- Framework: {framework}
- Test runner: {test_framework}
- Linter: {linter}

### Created
- CLAUDE.md — filled with detected tech stack and commands
- rules/{category}.md — {N} rules created
- tasks/todo.md — starter task file
- tasks/lessons.md — lesson tracking

### Review These
- [ ] CLAUDE.md "About This Project" section — add project description
- [ ] CLAUDE.md "Commands" section — verify build/test/lint/deploy commands
- [ ] rules/ files — review and adjust rules to your preferences

### Next Steps
- Run `/create-rule` to add project-specific rules
- Run `/plan-project` to start planning your first feature
- Rename MEMORY_template.md to MEMORY_{your_name}.md
```

## Advanced Workflow

### Step 1: Project Scan

Deep analysis beyond basic detection:
- Parse ALL config files for dependencies and their versions
- Check for monorepo indicators: `workspaces` in package.json, `lerna.json`, `pnpm-workspace.yaml`, `nx.json`
- Scan for database config: `prisma/`, `migrations/`, `alembic/`, `ormconfig`
- Check deployment: `Dockerfile`, `serverless.yml`, `vercel.json`, `fly.toml`, `netlify.toml`

### Step 2: Architecture Detection

Identify the project architecture:
- **Monorepo** — multiple packages/apps in one repo
- **Microservices** — separate services with independent deployment
- **Monolith** — single deployable unit
- **Serverless** — function-based (Lambda, Cloud Functions)
- **Fullstack** — frontend + backend in same repo (Next.js, Remix)

### Step 3: Command Discovery

Parse build/test/lint/deploy commands from multiple sources:
1. `package.json` scripts — `build`, `test`, `lint`, `dev`, `start`, `deploy`
2. `Makefile` targets — parse for common targets
3. CI config — `.github/workflows/*.yml`, `.gitlab-ci.yml`, `Jenkinsfile`
4. `pyproject.toml` — `[tool.pytest]`, `[tool.ruff]`, `[tool.mypy]` sections
5. Docker commands — `docker-compose up`, build commands

### Step 4: Dependency Analysis

Identify major libraries that affect workflow:
- **ORMs** — Prisma, SQLAlchemy, GORM, Diesel (affect DB migration rules)
- **Test frameworks** — Jest, Vitest, pytest, Go testing (affect test rules)
- **Linters** — ESLint, ruff, golangci-lint, clippy (affect QA gates)
- **State management** — Redux, Zustand, Pinia (affect architecture rules)
- **API patterns** — REST, GraphQL, gRPC, tRPC (affect API rules)

### Step 5: Existing Config Audit

If `.claude/` exists, analyze quality and find gaps:
1. Is CLAUDE.md complete? Check each `dragoon:section:` marker has content
2. Are rules specific and actionable? Flag vague rules
3. Are QA gates configured? Check they match actual tools
4. Are skills installed? List missing skills
5. Suggest improvements for each gap found

### Step 6: CLAUDE.md Generation

Create or enhance CLAUDE.md with ALL detected information (same as Basic Step 4 but more thorough).

### Step 7: Rules Generation

Create stack-specific rules files:
- `rules/style.md` — from detected formatter and linter
- `rules/testing.md` — from detected test framework
- `rules/architecture.md` — from detected patterns
- `rules/security.md` — baseline security rules for the stack
- `rules/guards.md` — files/dirs that should not be modified

### Step 8: Skills Recommendation

Suggest which dragoon skills are most relevant:
- **All projects** — `/plan-project`, `/create-rule`, `/debug-expert`
- **Large projects** — `/execute-plan`, `/autonomous-loop`
- **Team projects** — `/create-agent`, `/audit-quality`
- **API projects** — `/create-mcp-server`
- **Complex workflows** — `/create-hooks`, `/create-command`

### Step 9: Team Setup

If team project (user confirms):
1. Create MEMORY templates for each developer
2. Suggest subagent structure based on project type
3. Set up task tracking in `tasks/todo.md`
4. Create onboarding notes for new members

### Step 10: Verification

Validate everything created:
1. Run `scripts/validate-skill.sh` on any created skills
2. Check CLAUDE.md has no empty sections
3. Verify commands in QA gates actually exist (e.g., `npx tsc --noEmit` only if TypeScript)
4. Confirm rules are specific and actionable (no vague rules)
5. Report any issues found

## Tech Stack Detection Table

| File | Stack | Suggested Rules |
|------|-------|----------------|
| `package.json` | Node.js | JS/TS style, npm scripts, test framework |
| `tsconfig.json` | TypeScript | Type checking, strict mode |
| `requirements.txt` / `pyproject.toml` | Python | Type hints, pytest, virtual env |
| `go.mod` | Go | Go conventions, error handling, testing |
| `Cargo.toml` | Rust | Clippy, testing, unsafe rules |
| `docker-compose.yml` | Docker | Container rules, env vars |
| `.github/workflows/` | GitHub Actions | CI/CD rules |
| `next.config.*` | Next.js | React rules, SSR, app router |
| `prisma/schema.prisma` | Prisma | DB migration rules |
| `pom.xml` / `build.gradle` | Java | Maven/Gradle conventions |
| `Gemfile` | Ruby | Bundler, RSpec patterns |
| `.gitlab-ci.yml` | GitLab CI | CI/CD rules |

## Anti-Patterns

- **Over-configuring** — adding rules for tech not in the project. Only add rules for detected stack.
- **Ignoring existing setup** — overwriting custom CLAUDE.md or rules without checking. Always check first, merge second.
- **Generic rules** — adding vague rules like "write clean code" instead of stack-specific ones. Be concrete.
- **Skipping verification** — not checking if generated CLAUDE.md commands actually work. Always verify.
- **Assuming structure** — hardcoding paths like `src/` without checking they exist. Scan first.
- **One-size-fits-all** — same config for monorepo and single-app. Architecture matters.

## Cross-References

- Rule creation: `/create-rule`
- Skill creation: `/create-skill`
- Agent creation: `/create-agent`
- Command creation: `/create-command`
- Hook creation: `/create-hooks`
- MCP server creation: `/create-mcp-server`
- Prompt engineering: `/create-meta-prompt`
- Installation: `install.sh --extend` for the mechanical setup
- Validation: `scripts/validate-skill.sh`
- Quality audit: `/audit-quality` for validating onboarding output quality
- Expertise loading: `/expertise-loader` for loading domain knowledge after onboarding
- Debugging: `/debug-expert` for fixing issues found during onboarding
- Planning: `/plan-project` for feature planning after onboarding
