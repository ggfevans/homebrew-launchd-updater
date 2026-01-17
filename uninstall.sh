#!/bin/bash

set -e

SUPPORT_DIR="$HOME/Library/Application Support"
AGENTS_DIR="$HOME/Library/LaunchAgents"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Uninstalling Homebrew launchd Updater${NC}"

# Unload the launchd job
echo "Unloading launchd job..."
if launchctl list | grep -q "com.local.brew-upgrade"; then
    launchctl unload "$AGENTS_DIR/com.local.brew-upgrade.plist"
fi

# Remove files
echo "Removing files..."
rm -f "$SUPPORT_DIR/brew-upgrade-helper.sh"
rm -f "$AGENTS_DIR/com.local.brew-upgrade.plist"

# Ask about logs
echo -e "${YELLOW}Keep logs?${NC} (logs will be preserved by default)"
echo "To remove logs: rm ~/Library/Logs/brew-upgrade.log"

echo -e "${GREEN}Uninstall complete!${NC}"
