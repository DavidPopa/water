---
description: Assess whether something is viable — technical, resource, integration, and risk analysis
argument-hint: "[idea-or-feature]"
allowed-tools: Read, Grep, Glob, Bash
---

# Feasibility Analysis: $ARGUMENTS

Determine whether **$ARGUMENTS** is viable. Evaluate all four dimensions before scoring.

## 1. Technical Feasibility
- Can we build this with our current stack? Search the codebase for existing patterns.
- What technologies, libraries, or APIs are required?
- Are there hard technical blockers? (platform limits, missing capabilities)
- Prototype complexity: trivial / moderate / significant / extreme

## 2. Resource Feasibility
- Estimated effort: hours / days / weeks / months
- Skills required — do we have them in-house?
- Dependencies on external teams, services, or vendors
- Opportunity cost: what do we NOT build if we build this?

## 3. Integration Feasibility
- How does $ARGUMENTS fit with the existing architecture? Check current code structure.
- What existing systems need modification?
- Data migration or schema changes required?
- Backward compatibility concerns?

## 4. Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| (identify risk 1) | Low/Med/High | Low/Med/High | Strategy |
| (identify risk 2) | Low/Med/High | Low/Med/High | Strategy |
| (identify risk 3) | Low/Med/High | Low/Med/High | Strategy |

## Verdict

**Score**: Feasible / Feasible with caveats / Not feasible

**Recommendation**: Go / No-go / Conditional go

**Justification**: Explain the score in 2-3 sentences. If conditional, state exactly what conditions must be met. If no-go, suggest alternatives.
