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

echo ""
printf "\033[1;33m"
printf "   ┌─────────────────────────────────────────────────┐\n"
printf "   │  ⚠️  Before we start:                            │\n"
printf "   │                                                  │\n"
printf "   │  • You'll be asked for your Mac password         │\n"
printf "   │    (it won't show characters — that's normal!)   │\n"
printf "   │  • You may need to press ENTER at some point     │\n"
printf "   │  • Takes a couple of minutes — just let it run   │\n"
printf "   │  • You'll see a big green ✅ when it's done      │\n"
printf "   └─────────────────────────────────────────────────┘\n"
printf "\033[0m"
echo ""
sleep 1

read -rp "🔑 Enter your Glyphic API key: " API_KEY
if [ -z "$API_KEY" ]; then
  printf "\033[1;31m   ✖ No API key provided.\033[0m\n"
  exit 1
fi
echo ""
printf "\033[1;35m   ⏳ Setting up Glyphic AI MCP for Claude Desktop...\033[0m\n"
echo ""

# Homebrew
if ! command -v brew &>/dev/null; then
  printf "\033[1;34m   📦 [1/3] Installing some tools we need (this only happens once)...\033[0m\n"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
else
  printf "\033[1;34m   📦 [1/3] Checking core tools...\033[0m\n"
fi
printf "\033[1;32m   ✔  Core tools ready\033[0m\n"
echo ""

# Node
if ! command -v node &>/dev/null; then
  printf "\033[1;34m   ⚙️  [2/3] Installing one more thing...\033[0m\n"
  brew install node
else
  printf "\033[1;34m   ⚙️  [2/3] Checking dependencies...\033[0m\n"
fi
printf "\033[1;32m   ✔  All dependencies ready\033[0m\n"
echo ""

# Config
printf "\033[1;34m   🔧 [3/3] Configuring Glyphic connection...\033[0m\n"
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
    except json.JSONDecodeError:
        os.rename(config_path, config_path + ".backup")
        config = {}
else:
    config = {}
if "mcpServers" not in config: config["mcpServers"] = {}
config["mcpServers"]["Glyphic AI MCP"] = glyphic
with open(config_path, "w") as f: json.dump(config, f, indent=2)
PYEOF
printf "\033[1;32m   ✔  Glyphic connection configured\033[0m\n"
echo ""

# Claude Desktop check
if [ -d "/Applications/Claude.app" ]; then
  if pgrep -x "Claude" > /dev/null; then
    printf "\033[1;34m   🔄 Restarting Claude Desktop...\033[0m\n"
    osascript -e 'quit app "Claude"'
    sleep 2
    killall "Claude" 2>/dev/null || true
    sleep 1
    open -a "Claude"
    printf "\033[1;32m   ✔  Claude Desktop restarted\033[0m\n"
  else
    printf "\033[1;34m   🚀 Opening Claude Desktop...\033[0m\n"
    open -a "Claude"
    printf "\033[1;32m   ✔  Claude Desktop opened\033[0m\n"
  fi
  echo ""
  printf "\033[1;32m"
  printf "   ╔═══════════════════════════════════════╗\n"
  sleep 0.08
  printf "   ║                                       ║\n"
  sleep 0.08
  printf "   ║   ✅ All done! Glyphic MCP is ready.  ║\n"
  sleep 0.08
  printf "   ║   You can close this terminal window.  ║\n"
  sleep 0.08
  printf "   ║                                       ║\n"
  sleep 0.08
  printf "   ╚═══════════════════════════════════════╝\n"
  printf "\033[0m"
  echo ""
else
  echo ""
  printf "\033[1;33m   ⚠️  You haven't installed Claude Desktop yet!\033[0m\n"
  printf "\033[1;33m   I'll open the download page in...\033[0m\n"
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
  echo ""
  printf "\033[1;32m"
  printf "   ╔════════════════════════════════════════════════════╗\n"
  sleep 0.08
  printf "   ║                                                    ║\n"
  sleep 0.08
  printf "   ║   ✅ Config saved! Install Claude Desktop from     ║\n"
  sleep 0.08
  printf "   ║   the page that just opened, then you're all set.  ║\n"
  sleep 0.08
  printf "   ║   You can close this terminal window.              ║\n"
  sleep 0.08
  printf "   ║                                                    ║\n"
  sleep 0.08
  printf "   ╚════════════════════════════════════════════════════╝\n"
  printf "\033[0m"
  echo ""
fi
