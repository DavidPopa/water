# Lessons Learned

> Claude updates this file after ANY user correction. Read at session start.
> Format: Mistake → Root Cause → Rule to prevent it.

<!--
Example:

## 2024-03-10: Changed files outside scope
- **Mistake**: Modified 5 files when only 2 needed changes
- **Root Cause**: Didn't check impact before editing
- **Rule**: Always check what files are affected BEFORE making changes. If more than 3 files, confirm with user first.
-->

## Sprint 1 Lessons

**Mistake**: Skills referenced `write-plan` which doesn't exist in the 2.0 plan
**Root cause**: Old references not cleaned up during upgrade
**Fix**: Always verify cross-references point to skills in the master plan. QA agent caught this.

**Mistake**: .gitignore missing 2.0 entries (MEMORY_*.md, .dragoon-backup-*)
**Root cause**: New file patterns introduced without updating .gitignore
**Fix**: When adding new file patterns, update .gitignore in the same task.

**Mistake**: MEMORY_[dev1].md was tracked by git despite being a template
**Root cause**: File was committed before .gitignore entry added
**Fix**: After adding .gitignore entries, check `git status` for already-tracked files.

## Sprint 2 Lessons

**Mistake**: expertise/ files in debug-expert not referenced from SKILL.md
**Root cause**: Supporting files created separately without updating the main SKILL.md references
**Fix**: When creating supporting files, immediately add references in SKILL.md. Validator catches orphan files.

**Mistake**: detect-project.sh didn't check requirements.txt for pytest
**Root cause**: Only checked pytest.ini and pyproject.toml, missed common pattern
**Fix**: Test detection scripts against ALL common project configurations, not just the happy path.

**Mistake**: Skills didn't have back-references to onboard-project
**Root cause**: New skill created without updating existing skills' cross-references
**Fix**: When adding a new skill, update ALL existing skills' Cross-References sections.

## Sprint 3 Lessons

**Mistake**: create-meta-prompt had duplicate "## Anti-Patterns" heading inside a code block example
**Root cause**: Code block examples can contain markdown headings that confuse parsers/validators
**Fix**: Never use real markdown headings (##) inside code block examples. Use different heading text or rename to avoid confusion.

**Mistake**: Creator skills (create-skill, create-hooks, create-mcp-server, create-command, create-meta-prompt) didn't all cross-reference each other
**Root cause**: Each skill was built independently without checking the full disambiguation matrix
**Fix**: After creating any new skill, check ALL existing skills' "When NOT to Use" sections for needed redirects. Build a disambiguation matrix.

**Mistake**: create-command was missing Bash in allowed-tools but needed it for testing
**Root cause**: Template didn't include Bash, but the workflow steps required running commands
**Fix**: When writing allowed-tools, trace through every workflow step and verify the tools listed can actually execute each step.

## Sprint 4 Lessons

**Mistake**: expertise-loader description lacked trigger phrases despite being user-invocable: false
**Root cause**: Validator still checks for trigger phrases even on background skills
**Fix**: Even background skills should have descriptive trigger phrases so Claude knows when to activate them. The validator doesn't distinguish user-invocable settings.

**Mistake**: autonomous-loop still had "(Sprint 4)" annotation on audit-quality reference
**Root cause**: Builder created the file with future annotations, not knowing other Sprint 4 skills were being built simultaneously
**Fix**: When building skills in the same sprint, don't add Sprint annotations for skills in the same sprint — they'll all exist by sprint end.

## Commands Lessons

**Mistake**: `.gitignore` pattern `research/` matched `.claude/commands/research/` too, silently preventing those files from being tracked
**Root cause**: Bare directory name in gitignore matches at any depth. Used `research/` instead of `/research/`
**Fix**: Always prefix gitignore patterns with `/` when they should only match at the repo root. After committing, verify all expected files appear in `git show --stat`.

## Sprint 5 Lessons

**Insight**: The 5-agent builder + 5-agent QA pattern worked extremely well for parallel execution
**Root cause**: Clear role separation prevents conflicts and ensures comprehensive coverage
**Apply**: Use this pattern for future large-scale changes — dedicated builders with QA agents for verification
