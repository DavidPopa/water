---
description: Thorough investigation of a topic — gather evidence, map relationships, synthesize findings
argument-hint: "[topic-or-question]"
allowed-tools: Read, Grep, Glob, Bash
---

# Deep Dive Investigation: $ARGUMENTS

Conduct a thorough, structured investigation. Follow each phase sequentially.

## Phase 1: Define Scope
- State exactly what we are investigating about **$ARGUMENTS**
- Identify boundaries: what is in scope vs out of scope
- List specific questions this investigation should answer

## Phase 2: Gather Evidence
- Search the codebase for all files related to $ARGUMENTS using Glob and Grep
- Read key files to understand current implementation and documentation
- Check git history (`git log --oneline --all --grep="$ARGUMENTS"` and related commits)
- Note any configuration, environment variables, or external dependencies involved

## Phase 3: Map Relationships
- Identify what components, modules, or systems connect to $ARGUMENTS
- Trace data flow and dependency chains
- Document upstream and downstream impacts
- Create a relationship summary (component -> dependency -> effect)

## Phase 4: Identify Patterns
- What recurring themes emerge from the evidence?
- Are there inconsistencies, duplication, or anti-patterns?
- What conventions are followed or broken?

## Phase 5: Synthesize Report
Present findings in this structure:

| Section | Content |
|---------|---------|
| **Summary** | 2-3 sentence overview |
| **Key Findings** | Numbered list of discoveries |
| **Relationships** | How things connect |
| **Patterns** | Recurring themes |
| **Risks** | Anything concerning |

## Phase 6: Recommendations
- Provide 3-5 actionable next steps, prioritized by impact
- Flag anything that needs immediate attention
- Suggest follow-up investigations if needed
