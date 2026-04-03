---
description: Research the history and evolution — origins, decisions, lessons, trajectory
argument-hint: "[feature-or-system]"
allowed-tools: Read, Grep, Glob, Bash
---

# Historical Context: $ARGUMENTS

Research the history and evolution of **$ARGUMENTS**. Use git history and documentation as primary sources.

## 1. Origin
- When was $ARGUMENTS first introduced? (`git log --oneline --diff-filter=A -- <relevant paths>`)
- Why was it created? Check commit messages, PR descriptions, docs
- Who initiated it? (git blame, commit authors)
- What problem was it solving at the time?

## 2. Evolution
- Trace key changes over time (`git log --oneline --all -- <relevant paths>`)
- Group changes into phases or milestones
- What was added, removed, or refactored?
- How has the scope changed from original intent?

## 3. Key Decisions

| Decision | When | Why | Impact |
|----------|------|-----|--------|
| (decision 1) | Date/commit | Rationale | What it caused |
| (decision 2) | ... | ... | ... |

- Check for design documents, comments, or TODOs that explain choices
- Look for reverted commits or significant rewrites

## 4. Lessons Learned
- What worked well in the evolution of $ARGUMENTS?
- What caused problems or had to be redone?
- What patterns should we repeat or avoid?

## 5. Current State
- Where is $ARGUMENTS today? Read the latest implementation.
- How far has it drifted from original design?
- Outstanding issues, TODOs, or known limitations?

## 6. Future Trajectory
- Based on the historical arc, where should $ARGUMENTS go next?
- What is the natural next evolution?
- Recommend 2-3 concrete next steps with justification
