---
description: Find open-source solutions — evaluate packages, assess quality, recommend adoption
argument-hint: "[problem-or-need]"
allowed-tools: Read, Grep, Glob, Bash
---

# Open Source Research: $ARGUMENTS

Find and evaluate open-source solutions for **$ARGUMENTS**. Prioritize actively maintained, well-licensed options.

## 1. Discovery
- Search for relevant packages, libraries, and tools that solve $ARGUMENTS
- Check the current codebase for existing dependencies that partially address this (search package.json, requirements.txt, etc.)
- Identify at least 3-5 candidates

## 2. Candidate Evaluation

For each candidate, assess:

| Criteria | Package A | Package B | Package C |
|----------|-----------|-----------|-----------|
| GitHub stars | | | |
| Last commit | | | |
| License | | | |
| Weekly downloads | | | |
| Open issues | | | |
| Contributors | | | |
| Documentation quality | Poor/OK/Good | Poor/OK/Good | Poor/OK/Good |
| Maintenance status | Active/Slow/Stale | Active/Slow/Stale | Active/Slow/Stale |

## 3. Fit Assessment
For each candidate:
- Does it solve our specific problem? Fully or partially?
- Compatibility with our stack? Check existing dependencies for conflicts.
- Any red flags? (breaking changes often, abandoned forks, security advisories)
- Bundle size or performance concerns?

## 4. Integration Effort

| Package | Effort | Changes Required | Migration Risk |
|---------|--------|-----------------|----------------|
| Package A | Low/Med/High | What needs to change | Low/Med/High |
| Package B | ... | ... | ... |

## 5. Recommendation
- **Best option**: Package X — why it wins
- **Runner-up**: Package Y — when to prefer it instead
- **Avoid**: Package Z — why it was rejected

## 6. Build vs Adopt
If no package is ideal, assess the build-it-ourselves option:
- Estimated effort to build from scratch
- Maintenance burden over time
- When building makes more sense than adopting
