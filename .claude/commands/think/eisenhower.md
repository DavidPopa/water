---
description: Sort tasks into the Eisenhower Matrix by urgency and importance
argument-hint: "[list of tasks, decisions, or priorities to categorize]"
allowed-tools: Read, Grep
---

# Eisenhower Matrix

Categorize tasks/items from **$ARGUMENTS** by urgency and importance.

## Process

1. **List all items**: Extract every task, decision, or action item.

2. **Score each item**:
   - Urgent? (time-sensitive, deadline-driven, consequences if delayed)
   - Important? (contributes to long-term goals, high impact, aligned with core mission)

3. **Sort into quadrants**:

```
                    URGENT                  NOT URGENT
            ┌──────────────────────┬──────────────────────┐
 IMPORTANT  │   Q1: DO NOW         │   Q2: SCHEDULE        │
            │                      │                       │
            │   - ...              │   - ...               │
            │   - ...              │   - ...               │
            ├──────────────────────┼──────────────────────┤
 NOT        │   Q3: DELEGATE       │   Q4: ELIMINATE       │
 IMPORTANT  │                      │                       │
            │   - ...              │   - ...               │
            │   - ...              │   - ...               │
            └──────────────────────┴──────────────────────┘
```

4. **Action plan**:
   - **Q1** (Do Now): Execute these immediately. Define next action for each.
   - **Q2** (Schedule): Block time for these. They drive long-term success.
   - **Q3** (Delegate): Hand off or automate. Who/what handles each?
   - **Q4** (Eliminate): Stop doing these. Remove from your list entirely.

## Output

- The filled 2x2 matrix with all items categorized
- Specific next action for each Q1 and Q2 item
- Warning: if Q2 is empty, you are being reactive instead of strategic
