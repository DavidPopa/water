---
description: Show, add, or complete items in tasks/todo.md
argument-hint: "[add|done|show] [task-description]"
allowed-tools: Read, Write, Edit
---

# Todo Manager

Manage tasks/todo.md. Parse $ARGUMENTS to determine action.

## Input

Command: $ARGUMENTS

## Steps

1. Parse the first word of $ARGUMENTS:
   - Empty or `show` → **Show** action
   - `add` → **Add** action (rest of $ARGUMENTS is the task description)
   - `done` → **Done** action (rest of $ARGUMENTS is the task to complete)

2. **Show**: Read `tasks/todo.md`. Count all `- [x]` (complete) and `- [ ]` (incomplete) items. Display the file contents followed by a progress summary: `Progress: X/Y complete (Z%)`.

3. **Add**: Read `tasks/todo.md`. Find the last section (last `##` heading). Append `- [ ] {task-description}` to that section. If `tasks/todo.md` doesn't exist, create it with:
   ```
   # Todo

   ## Current
   - [ ] {task-description}
   ```

4. **Done**: Read `tasks/todo.md`. Find the item whose text best matches the task description. Change its `- [ ]` to `- [x]`. If no match found, report which items exist.

5. After any change, display the updated progress summary: `Progress: X/Y complete (Z%)`.
