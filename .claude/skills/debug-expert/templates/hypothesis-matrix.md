# Hypothesis Matrix Template

Use this template to track competing theories during debugging. Fill in at least 3 hypotheses before testing any of them. This prevents confirmation bias and ensures you consider alternatives.

## How to Fill In

1. **Hypothesis** — State the theory as: "[Component] fails because [reason], causing [symptom]"
2. **Supporting Evidence** — What you have observed that is consistent with this theory
3. **Conflicting Evidence** — What you have observed that contradicts or weakens this theory
4. **Test** — The single smallest action that would prove or disprove this theory
5. **Status** — `untested` | `confirmed` | `rejected`

## Template

| # | Hypothesis | Supporting Evidence | Conflicting Evidence | Test | Status |
|---|-----------|-------------------|---------------------|------|--------|
| 1 |           |                   |                     |      | untested |
| 2 |           |                   |                     |      | untested |
| 3 |           |                   |                     |      | untested |

## Rules

- Test the hypothesis with the most supporting evidence and least conflicting evidence first
- Update the Status column immediately after each test
- If all hypotheses are rejected, gather more evidence and add new rows
- Never delete a rejected hypothesis — it documents what you ruled out

## Example: API returning 500 intermittently

**Bug:** `POST /api/orders` returns 500 roughly 1 in 10 requests. No pattern in request body. Started after last deploy.

| # | Hypothesis | Supporting Evidence | Conflicting Evidence | Test | Status |
|---|-----------|-------------------|---------------------|------|--------|
| 1 | Database connection pool exhausted under load | Errors spike during peak traffic; logs show "connection timeout" | Error also occurs at low traffic (2 AM) | Check pool size config + add connection pool metrics logging | rejected |
| 2 | Race condition in inventory check — two concurrent requests read stale stock count | Intermittent (timing-dependent); last deploy added parallel order processing | Error rate doesn't correlate with concurrent request count | Add mutex/transaction lock around inventory read-write, run 100 concurrent requests | confirmed |
| 3 | Malformed request body passes validation but breaks downstream serializer | Some 500s have "serialization error" in stack trace | Most 500s have a clean request body in access logs | Log raw request body on every 500, check for edge cases | rejected |

**Outcome:** Hypothesis 2 confirmed. Root cause was a missing database transaction around the inventory check, allowing two concurrent orders to read the same stock count. Fix: wrapped read-check-decrement in a serializable transaction.
