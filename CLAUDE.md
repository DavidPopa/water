# Project Instructions

## About This Project
**AquaService** — Aplicatie POC pentru un furnizor de servicii de filtrare apa. Gestioneaza clienti, planifica mentenanta filtrelor si trimite notificari pentru programari.

## Tech Stack
- **Language:** TypeScript
- **Framework:** Next.js 15 (App Router)
- **Styling:** Tailwind CSS 4
- **Components:** shadcn/ui
- **State:** React state (dummy data, no backend/DB)
- **Package Manager:** npm

## Commands
```bash
# Dev
npm run dev

# Build
npm run build

# Lint
npm run lint

# Type check
npx tsc --noEmit
```

---

## Workflow

### Plan Mode Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately — don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

### Self-Improvement Loop
- After ANY correction from the user, update `tasks/lessons.md` with the pattern:
  - What rule you violated
  - Write a rule for yourself that prevents the same mistake
  - Ruthlessly iterate on these lessons until mistake rate drops
  - Review lessons at session start for the relevant project
- **4-layer system:**
  ```
  Capture (lessons.md) → Load (expertise-loader) → Apply → Audit (audit-quality) → Improve
  ```

### Verification Before Done
- NEVER mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes — don't over-engineer
- Challenge your own work before presenting it

### Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding.
- Point at logs, errors, failing tests — then resolve
- Zero context switching required from the user
- Go fix failing CI tests without being told to

---

## Available Skills

### Core
- `/plan-project` — Sprint planning from feature requests
- `/create-skill` — Create new skills (Skills 2.0 format)
- `/create-rule` — Create and manage project rules
- `/create-agent` — Create subagent definitions

### Workflow
- `/debug-expert` — Scientific debugging with hypothesis testing
- `/execute-plan` — Execute plans step-by-step with verification
- `/onboard-project` — Auto-setup for new/existing projects

### Creators
- `/create-hooks` — Event-driven automation (PreToolUse, PostToolUse)
- `/create-mcp-server` — Build MCP servers for custom tools
- `/create-command` — Create slash commands
- `/create-meta-prompt` — Design and refine prompts

### Advanced
- `/autonomous-loop` — Continuous coding with self-verification
- `expertise-loader` — Auto-loads domain knowledge (background)
- `/audit-quality` — Quality scoring for skills, rules, CLAUDE.md

### Quick Commands
- `/commit` — Smart commit with conventional message
- `/review` — Code review on current diff
- `/fix` — Quick bug fix from description
- `/test` — Generate tests with auto-detection
- `/todo` — Manage tasks/todo.md
- `/status` — Project health dashboard
- `/handoff` — Context handoff between sessions

### Thinking Frameworks (`/think/*`)
- `/think/pareto`, `/think/first-principles`, `/think/inversion`, `/think/five-whys`
- `/think/eisenhower`, `/think/swot`, `/think/occams-razor`, `/think/second-order`
- `/think/via-negativa`, `/think/opportunity-cost`, `/think/ten-ten-ten`, `/think/one-thing`

### Research Frameworks (`/research/*`)
- `/research/deep-dive`, `/research/feasibility`, `/research/competitive`, `/research/landscape`
- `/research/options`, `/research/technical`, `/research/history`, `/research/open-source`

---

## Task Management

### Plan First
- **Small task** (single session): write plan to `tasks/todo.md` with checkable items
- **Big feature** (multi-session): use `/plan-project` to create `plans/{dev}__{feature}.md` with sprints and tasks
- Verify plans — check before starting implementation
- When the task is big: break into sub-tasks of max 200 lines

### Track Progress
- Mark items complete as you go
- High-level summary at each step
- Update `tasks/todo.md` at the end of every session

### Document Results
- Add review section after completion
- What changed, why, what impact it has

### Capture Lessons
- Update `tasks/lessons.md` after corrections
- Format: **Mistake** → **Root cause** → **Fix**
- Review at session start

---

## Core Principles

### Simplicity First
Make every change as simple as possible. Impact minimal code.

### No Laziness
Find root causes. No temporary fixes. Senior developer standards.

### Minimal Impact
Changes should only touch what's necessary. Avoid introducing bugs.

---

## Persistent Files

| File | When to read | When to write |
|------|-------------|---------------|
| `tasks/todo.md` | Session start | Session end — mark completed, add new |
| `tasks/lessons.md` | Session start | After ANY user correction |
| `MEMORY_{dev}.md` | Session start | Session end — current state + session log |
| `plans/{dev}__{feature}.md` | Session start (if active plan exists) | Real-time — update as tasks complete |
| `rules/*.md` | Session start | When adding new rules via `/create-rule` |

### Order at session end:
1. `tasks/lessons.md` (if any corrections happened)
2. `tasks/todo.md` (mark completed, add new)
3. `MEMORY_{dev}.md` (update current state)
4. Report task as done

---

## Code Standards

### Style
- ES modules, functional components, arrow functions
- TypeScript strict mode
- Tailwind for all styling (no CSS files)
- shadcn/ui components as base building blocks

### Architecture
- Next.js App Router (`app/` directory)
- Feature-based folder organization
- Dummy data in `lib/data.ts`
- Types in `lib/types.ts`
- Reusable components in `components/`

---

## Project-Specific Rules

Read all `.md` files in `rules/` — each file is a set of rules for a specific domain.
Use `/create-rule` to add new rules.

---

## QA Gates

| Gate | Command | What it catches |
|------|---------|-----------------|
| Skill validation | `scripts/validate-skill.sh` | Format errors in skills |
| Quality audit | `/audit-quality` | Content quality, cross-refs |
| Type check | `npx tsc --noEmit` | Broken imports, type errors |
| Lint | `npm run lint` | Code quality, unused imports |
| Build | `npm run build` | Runtime errors, missing modules |

If a gate fails: fix it now. Don't carry errors forward.
