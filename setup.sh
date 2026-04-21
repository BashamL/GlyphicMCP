#!/bin/bash
set -e

echo ""
printf "\033[1;36m"
printf "   ╔════════════════════════════════════╗\n"
sleep 0.08
printf "   ║ 🔮 Glyphic MCP Setup for Claude 🔮 ║\n"
sleep 0.08
printf "   ╚════════════════════════════════════╝\n"
printf "\033[0m"
sleep 0.3

read -rp "Enter your Glyphic API key: " API_KEY
if [ -z "$API_KEY" ]; then echo "No API key provided."; exit 1; fi
echo ""
echo "Setting up Glyphic AI MCP for Claude Desktop..."
echo ""
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi
echo "Homebrew: OK"
if ! command -v node &>/dev/null; then
  echo "Installing Node.js..."
  brew install node
fi
echo "Node.js: OK ($(node -v))"
CONFIG_DIR="$HOME/Library/Application Support/Claude"
CONFIG_FILE="$CONFIG_DIR/claude_desktop_config.json"
mkdir -p "$CONFIG_DIR"
python3 << PYEOF
import json, os
config_path = "$CONFIG_FILE"
api_key = "$API_KEY"
glyphic = {
    "command": "npx",
    "args": ["mcp-remote@latest","https://api.glyphic.ai/mcp","--header","X-API-Key:\${API_KEY}","--transport","http-only"],
    "env": {"API_KEY": api_key}
}
if os.path.exists(config_path):
    try:
        with open(config_path) as f: config = json.load(f)
        print("Existing config found - merging...")
    except json.JSONDecodeError:
        os.rename(config_path, config_path + ".backup")
        config = {}
else:
    print("No existing config - creating...")
    config = {}
if "mcpServers" not in config: config["mcpServers"] = {}
config["mcpServers"]["Glyphic AI MCP"] = glyphic
with open(config_path, "w") as f: json.dump(config, f, indent=2)
others = [k for k in config["mcpServers"] if k != "Glyphic AI MCP"]
if others: print(f"Other MCP servers preserved: {', '.join(others)}")
print("Config saved.")
PYEOF
echo ""
if [ -d "/Applications/Claude.app" ]; then
  if pgrep -x "Claude" > /dev/null; then
    echo "Restarting Claude Desktop..."
    pkill -x "Claude" && sleep 2 && open -a "Claude"
    echo "Claude Desktop restarted."
  else
    echo "Claude Desktop not running - start it manually to pick up the new config."
  fi
  echo ""
  echo "Done! Glyphic AI MCP is ready to use."
else
  echo ""
  echo "⚠️  You haven't installed Claude Desktop yet!"
  echo "   I'll open the download page in..."
  echo ""
  sleep 0.5
  printf "   ████████╗██╗  ██╗██████╗ ███████╗███████╗\n"
  printf "   ╚══██╔══╝██║  ██║██╔══██╗██╔════╝██╔════╝\n"
  printf "      ██║   ████████║██████╔╝█████╗  █████╗  \n"
  printf "      ██║   ██╔══██║██╔══██╗██╔══╝  ██╔══╝  \n"
  printf "      ██║   ██║  ██║██║  ██║███████╗███████╗\n"
  printf "      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝\n"
  sleep 1
  printf "\033[6A"
  printf "   ████████╗██╗    ██╗ ██████╗ \n"
  printf "   ╚══██╔══╝██║    ██║██╔═══██╗\n"
  printf "      ██║   ██║ █╗ ██║██║   ██║\n"
  printf "      ██║   ██║███╗██║██║   ██║\n"
  printf "      ██║   ╚███╔███╔╝╚██████╔╝\n"
  printf "      ╚═╝    ╚══╝╚══╝  ╚═════╝ \n"
  sleep 1
  printf "\033[6A"
  printf "    ██████╗ ███╗   ██╗███████╗\n"
  printf "   ██╔═══██╗████╗  ██║██╔════╝\n"
  printf "   ██║   ██║██╔██╗ ██║█████╗  \n"
  printf "   ██║   ██║██║╚██╗██║██╔══╝  \n"
  printf "   ╚██████╔╝██║ ╚████║███████╗\n"
  printf "    ╚═════╝ ╚═╝  ╚═══╝╚══════╝\n"
  sleep 1
  printf "\033[6A"
  printf "\033[1;32m    ██████╗  ██████╗ ██╗\033[0m\n"
  printf "\033[1;32m   ██╔════╝ ██╔═══██╗██║\033[0m\n"
  printf "\033[1;32m   ██║  ███╗██║   ██║██║\033[0m\n"
  printf "\033[1;32m   ██║   ██║██║   ██║╚═╝\033[0m\n"
  printf "\033[1;32m   ╚██████╔╝╚██████╔╝██╗\033[0m\n"
  printf "\033[1;32m    ╚═════╝  ╚═════╝ ╚═╝\033[0m\n"
  echo ""
  sleep 0.5
  open "https://claude.ai/download"
  echo "   Download page opened. Once installed, open Claude Desktop — Glyphic is already configured and ready to go."
fi
