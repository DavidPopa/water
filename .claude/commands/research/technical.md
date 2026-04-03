---
description: Deep technical analysis — architecture, performance, security, tech debt, improvements
argument-hint: "[system-or-component]"
allowed-tools: Read, Grep, Glob, Bash
---

# Technical Investigation: $ARGUMENTS

Perform a deep technical analysis of **$ARGUMENTS**. Examine the codebase directly — no guessing.

## 1. Current Implementation
- Search for all files related to $ARGUMENTS using Glob and Grep
- Read the core implementation files
- Document: what does it do and how does it work?
- Entry points, public API, key functions

## 2. Architecture
- Components involved and their responsibilities
- Data flow: input -> processing -> output
- Dependencies: internal modules and external packages
- Configuration and environment requirements
- Draw the dependency chain (A -> B -> C)

## 3. Performance
- Identify potential bottlenecks (check for N+1 queries, unbounded loops, large payloads)
- Scaling concerns: what breaks at 10x, 100x, 1000x load?
- Resource usage: memory, CPU, network, disk
- Caching strategy (if any)

## 4. Security
- Input validation and sanitization
- Authentication and authorization boundaries
- Sensitive data handling (secrets, PII, tokens)
- Known vulnerability patterns in the dependencies

## 5. Technical Debt

| Debt Item | Severity | Effort to Fix | Impact if Ignored |
|-----------|----------|---------------|-------------------|
| (item 1) | Low/Med/High | Low/Med/High | Description |
| (item 2) | ... | ... | ... |

## 6. Recommendations
Prioritized list of improvements:
1. **Critical** — Must fix: security or correctness issues
2. **High** — Should fix: performance or maintainability
3. **Medium** — Nice to fix: code quality and cleanup
4. **Low** — Future consideration: optimizations and enhancements
