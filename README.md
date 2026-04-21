# Glyphic AI MCP Setup

One-command installer that configures the [Glyphic AI MCP](https://glyphic.ai) server for Claude Desktop on macOS.

## What it does

- Installs Homebrew (if missing) and Node.js (if missing)
- Prompts you for your Glyphic API key
- Writes/merges the Glyphic MCP entry into `~/Library/Application Support/Claude/claude_desktop_config.json`, preserving any other MCP servers you already have configured
- Restarts Claude Desktop if it is running

## Run it

```bash
curl -fsSL https://raw.githubusercontent.com/BashamL/GlyphicMCP/main/setup.sh -o /tmp/glyphic-setup.sh && bash /tmp/glyphic-setup.sh; rm -f /tmp/glyphic-setup.sh
```

The script is downloaded to a file (not piped via stdin) because it uses `read -rp` to prompt for your API key interactively.

## Requirements

- macOS
- Claude Desktop installed
- A Glyphic API key
