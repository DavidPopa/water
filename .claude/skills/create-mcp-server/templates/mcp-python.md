# Python MCP Server Template

## pyproject.toml

```toml
[project]
name = "{{SERVER_NAME}}"
version = "1.0.0"
requires-python = ">=3.11"
dependencies = [
    "mcp[cli]>=1.0.0",
    "pydantic>=2.0.0",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
```

## server.py

```python
import os
from mcp.server.fastmcp import FastMCP

server = FastMCP("{{SERVER_NAME}}")


@server.tool()
async def {{TOOL_NAME}}(query: str) -> str:
    """{{TOOL_DESCRIPTION}}

    Args:
        query: {{PARAM_DESCRIPTION}}
    """
    try:
        # TODO: Implement tool logic here
        return f"Processed: {query}"
    except Exception as e:
        return f"Error: {e}"


if __name__ == "__main__":
    server.run()
```

## Registration (uv)

```json
{
  "mcpServers": {
    "{{SERVER_NAME}}": {
      "command": "/absolute/path/to/uv",
      "args": ["run", "server.py"],
      "cwd": "/absolute/path/to/mcp-servers/{{SERVER_NAME}}",
      "env": {
        "API_KEY": "${MY_API_KEY}"
      }
    }
  }
}
```

## Setup Commands

```bash
# Initialize project
uv init {{SERVER_NAME}} && cd {{SERVER_NAME}}
uv add "mcp[cli]" pydantic

# Test server
uv run server.py

# Register with Claude
claude mcp add {{SERVER_NAME}} -- uv run server.py
```
