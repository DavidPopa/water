# Hook Patterns Reference

Copy-paste patterns for common Claude Code hooks. Add to `.claude/settings.json`.

## Safety Hooks

### Block Force Push
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash(git push.*--force)",
      "command": "echo '{\"decision\": \"block\", \"reason\": \"Force push blocked. Use --force-with-lease or remove --force.\"}'",
      "timeout": 3000
    }]
  }
}
```

### Block Recursive Delete
```json
"PreToolUse": [{
  "matcher": "Bash(rm -rf *)",
  "command": "echo '{\"decision\": \"block\", \"reason\": \"Recursive delete blocked. Be more specific with the path.\"}'",
  "timeout": 3000
}]
```

### Block Hard Reset
```json
"PreToolUse": [{
  "matcher": "Bash(git reset --hard*)",
  "command": "echo '{\"decision\": \"block\", \"reason\": \"Hard reset blocked. Use git stash or create a backup branch first.\"}'",
  "timeout": 3000
}]
```

## Formatting Hooks

### Auto-Format with Prettier (JS/TS)
```json
"PostToolUse": [{
  "matcher": "Write|Edit",
  "command": "npx prettier --write \"$CLAUDE_TOOL_ARG_FILE_PATH\" 2>/dev/null; exit 0",
  "timeout": 10000
}]
```

### Auto-Format with Black (Python)
```json
"PostToolUse": [{
  "matcher": "Write|Edit",
  "command": "black \"$CLAUDE_TOOL_ARG_FILE_PATH\" 2>/dev/null; exit 0",
  "timeout": 10000
}]
```

### Auto-Format with gofmt (Go)
```json
"PostToolUse": [{
  "matcher": "Write|Edit",
  "command": "gofmt -w \"$CLAUDE_TOOL_ARG_FILE_PATH\" 2>/dev/null; exit 0",
  "timeout": 10000
}]
```

## Logging Hooks

### Audit Trail — Log All Tool Uses
```json
"PostToolUse": [{
  "command": "echo \"$(date -u +%Y-%m-%dT%H:%M:%SZ) $CLAUDE_TOOL_NAME $CLAUDE_TOOL_ARG_FILE_PATH\" >> .claude/hook-audit.log; exit 0",
  "timeout": 3000
}]
```

## Validation Hooks

### Commit Message Convention (Conventional Commits)
```json
"PreToolUse": [{
  "matcher": "Bash(git commit*)",
  "command": ".claude/hooks/validate-commit-msg.sh",
  "timeout": 5000
}]
```

Script `.claude/hooks/validate-commit-msg.sh`:
```bash
#!/bin/bash
# Reads the git commit command from stdin, checks for conventional commit format
MSG=$(echo "$@" | grep -oP '(?<=-m \")[^\"]+')
if echo "$MSG" | grep -qE '^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+'; then
  echo '{"decision": "allow"}'
else
  echo '{"decision": "block", "reason": "Commit must follow Conventional Commits: type(scope): message"}'
fi
```

### Block Large File Commits
```json
"PreToolUse": [{
  "matcher": "Bash(git add*)",
  "command": ".claude/hooks/check-file-size.sh",
  "timeout": 5000
}]
```

Script `.claude/hooks/check-file-size.sh`:
```bash
#!/bin/bash
# Block staging files larger than 5MB
for file in $(git diff --cached --name-only 2>/dev/null); do
  size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
  if [ "${size:-0}" -gt 5242880 ]; then
    echo "{\"decision\": \"block\", \"reason\": \"File $file is larger than 5MB\"}"
    exit 0
  fi
done
echo '{"decision": "allow"}'
```
