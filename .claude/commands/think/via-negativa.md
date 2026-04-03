---
description: Improve by removing rather than adding — subtract to solve
argument-hint: "[system, process, or problem to improve by subtraction]"
allowed-tools: Read, Grep
---

# Via Negativa

Improve **$ARGUMENTS** by removing, not adding.

The instinct is always to add: more features, more process, more tools. Instead, ask what to subtract.

## Process

1. **Inventory the current state**: What exists right now? List all components, steps, tools, dependencies, features, and processes.

2. **Categorize each item**:

| Item | Necessary? | Adds value? | Causes friction? | Verdict |
|------|-----------|-------------|------------------|---------|
| ... | Yes/No | Yes/No | Yes/No | Keep/Remove |

3. **Identify removal candidates**:
   - **Unnecessary**: exists for historical reasons, no current purpose
   - **Harmful**: actively creates problems, bugs, confusion
   - **Distracting**: draws attention from what matters
   - **Legacy**: was needed once, no longer is
   - **Redundant**: duplicated by something else

4. **Impact of removal**: For each candidate, what improves if it is removed?

5. **Risk of removal**: What breaks? Is the risk real or imagined?

## Output

- Concrete list of things to remove, ranked by impact
- Expected improvement from each removal
- Items that seem removable but are actually load-bearing (keep these, with explanation)
- The single most impactful subtraction to make first
