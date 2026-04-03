---
name: create-mcp-server
description: Create a Model Context Protocol (MCP) server to extend Claude with custom tools. Use when user says 'create mcp server', 'new mcp', 'build mcp', 'custom tool', 'extend claude tools', 'mcp server'. For simple automation, use create-hooks instead.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
argument-hint: "[server-name]"
---

# Create MCP Server

Create MCP server: $ARGUMENTS

## When to Use

- Need custom tools beyond Claude's built-in capabilities
- Want to integrate external APIs as Claude tools
- Need database access, file system operations, or service integrations
- Building reusable tool sets for the team

## When NOT to Use

- Simple shell commands -> use hooks or bash directly
- One-time data fetch -> just use WebFetch
- Behavioral rules -> use `/create-rule`
- Automation triggers -> use `/create-hooks`
- Reusable multi-step workflow -> use `/create-skill` instead
- Simple slash command shortcut -> use `/create-command` instead

## MCP Essentials

- MCP servers expose **tools** that Claude can call
- Servers run as separate processes, communicate via stdio or SSE
- Config lives in `.claude/settings.json` under `mcpServers`
- Use `claude mcp add`, `claude mcp list`, `claude mcp remove` to manage

## Key Rules

1. **Never hardcode secrets** — use environment variables, reference with `${VAR}` in config
2. **Use absolute paths** — find executables with `which node`, `which python3`
3. **One server per directory** — isolate dependencies
4. **Use `cwd` property** — prevents dependency conflicts
5. **Prefer `uv` for Python** — better dependency management than pip

## Invocation

```
/create-mcp-server                       # interactive — asks what server to build
/create-mcp-server weather-api           # direct — builds server named weather-api
```

## Basic Workflow

### Step 1: Define Purpose

If `$ARGUMENTS` is provided, parse as server name. Infer purpose from name.
If not provided, ask:

1. **What tools should this server provide?** — e.g., "fetch weather data", "query database"
2. **What external services does it need?** — APIs, databases, files
3. **Any secrets required?** — API keys, tokens, credentials

### Step 2: Choose Stack

| Stack | Template | When to use |
|-------|----------|-------------|
| TypeScript | `templates/mcp-typescript.md` | Most use cases, strong typing, best SDK support |
| Python | `templates/mcp-python.md` | Data/ML, scientific computing, quick prototyping |

Default to TypeScript unless the user specifies Python or the use case involves data/ML.

### Step 3: Scaffold

1. Create directory: `mcp-servers/{server-name}/`
2. Read the selected template
3. Generate `package.json` or `pyproject.toml` with MCP SDK dependency
4. Generate server file with tool definitions based on Step 1 answers

### Step 4: Implement Tools

For each tool, define:
- **name** — lowercase-with-dashes (e.g., `get-weather`)
- **description** — what the tool does (Claude reads this to decide when to use it)
- **inputSchema** — JSON Schema for parameters (use Zod for TS, Pydantic for Python)
- **handler** — function that executes the tool and returns results

Always include error handling in every handler. Never let exceptions crash the server.

### Step 5: Register

Add server to `.claude/settings.json`:

```json
{
  "mcpServers": {
    "server-name": {
      "command": "/absolute/path/to/node",
      "args": ["dist/server.js"],
      "cwd": "/absolute/path/to/mcp-servers/server-name",
      "env": {
        "API_KEY": "${MY_API_KEY}"
      }
    }
  }
}
```

Rules for registration:
- Get absolute path to executable: `which node` or `which python3`
- Set `cwd` to the server directory
- Reference secrets with `${ENV_VAR}` syntax — never paste actual values
- For Python with uv: use `"command": "/absolute/path/to/uv", "args": ["run", "server.py"]`

### Step 6: Test

1. Install dependencies: `npm install` or `uv sync`
2. Build if TypeScript: `npx tsc`
3. Run `claude mcp list` — verify server shows as "connected"
4. Test each tool by asking Claude to use it in conversation

## Advanced Workflow

### Step 1: Gather

Parse `$ARGUMENTS`. Determine scope:
- **1-2 tools** = flat architecture (each tool registered directly)
- **3+ tools** = consider meta-discovery pattern (discover, get_schema, execute)

### Step 2: Architecture Decision

| Pattern | When | Example |
|---------|------|---------|
| **Flat** | 1-2 tools, simple I/O | Weather API, single-purpose tool |
| **Multi-tool** | 3-5 related tools | GitHub integration (issues, PRs, repos) |
| **Meta-discovery** | 6+ tools or dynamic | Internal API gateway with many endpoints |

For meta-discovery: implement `list_tools`, `get_tool_schema`, `execute_tool` as the 3 registered tools, with an `operations.json` file describing all available operations.

### Step 3: Security Review

For each secret identified:
1. Choose env var name: `SCREAMING_SNAKE_CASE` (e.g., `GITHUB_TOKEN`)
2. Add validation at server startup — fail fast if required env vars are missing
3. Never log secret values, even in debug mode
4. Document required env vars in server README

### Step 4: Scaffold

Same as Basic Step 3, but also:
- Add `tsconfig.json` (TypeScript) or configure `uv` (Python)
- Set up project structure for multiple tool files if needed

### Step 5: Implement

For each tool:
1. Define input schema with strict validation (Zod/Pydantic)
2. Implement handler with try/catch wrapping
3. Return structured responses (not raw strings)
4. Add timeout handling for external calls (30s default)
5. Include retry logic for transient failures (max 3 retries)

### Step 6: Error Handling

Ensure every tool handler:
- Catches all exceptions and returns helpful error messages
- Handles network timeouts gracefully
- Validates all inputs before processing
- Returns structured error objects, not stack traces

### Step 7: Register

Same as Basic Step 5.

### Step 8: Test

Same as Basic Step 6, plus:
- Test each tool with valid and invalid inputs
- Test with missing env vars (should fail gracefully)
- Test timeout behavior

### Step 9: Document

Create README.md in server directory:
- Server purpose and available tools
- Required environment variables
- Setup instructions
- Usage examples for each tool

## Server Config Format

```json
{
  "mcpServers": {
    "my-server": {
      "command": "/absolute/path/to/node",
      "args": ["dist/server.js"],
      "cwd": "/path/to/server/directory",
      "env": {
        "API_KEY": "${MY_API_KEY}"
      }
    }
  }
}
```

## Validation Checklist

Before declaring done, verify:
- [ ] Server directory exists with all required files
- [ ] Dependencies installed without errors
- [ ] Server builds/compiles without errors
- [ ] `claude mcp list` shows server as connected
- [ ] No hardcoded secrets in any file
- [ ] All paths are absolute
- [ ] `cwd` is set in config
- [ ] Error handling exists in every tool handler
- [ ] Required env vars are documented

## Anti-Patterns

- **Hardcoded secrets** — API keys in code or config files. Always use `${ENV_VAR}` syntax in settings and `process.env` / `os.environ` in code
- **Relative paths** — `node server.js` breaks when CWD changes. Always resolve with `which node` and use absolute paths
- **Missing cwd** — dependencies not found because server runs from wrong directory. Always set `cwd` in config
- **Giant monolith** — one server with 20+ tools becomes unmaintainable. Split into focused servers (max 5-6 tools each)
- **No error handling** — unhandled errors crash the server silently. Wrap every handler in try/catch
- **No input validation** — trusting all input without schema validation. Always validate with Zod or Pydantic
- **Logging secrets** — printing env vars or tokens in debug output. Never log sensitive values
- **Skipping the test step** — registering a server without verifying it connects. Always run `claude mcp list`

## Cross-References

- For automation triggers: `/create-hooks`
- For slash commands: `/create-command`
- For reusable workflows: `/create-skill`
- For behavioral rules: `/create-rule`
- For subagent definitions: `/create-agent`
- For prompt engineering: `/create-meta-prompt`
- Project setup: `/onboard-project`
- Quality check: `/audit-quality`
