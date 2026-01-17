#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPER_SCRIPT="$SCRIPT_DIR/brew-upgrade-helper.sh"
PLIST_FILE="$SCRIPT_DIR/com.local.brew-upgrade.plist"
SUPPORT_DIR="$HOME/Library/Application Support"
AGENTS_DIR="$HOME/Library/LaunchAgents"
LOG_DIR="$HOME/Library/Logs"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Installing Homebrew launchd Updater${NC}"

# Create directories
echo "Creating directories..."
mkdir -p "$SUPPORT_DIR"
mkdir -p "$AGENTS_DIR"
mkdir -p "$LOG_DIR"

# Copy helper script
echo "Copying helper script..."
cp "$HELPER_SCRIPT" "$SUPPORT_DIR/"
chmod +x "$SUPPORT_DIR/brew-upgrade-helper.sh"

# Copy plist with path substitution for current user
echo "Setting up launchd configuration..."
sed "s|/Users/gvns|$HOME|g" "$PLIST_FILE" > "$AGENTS_DIR/com.local.brew-upgrade.plist"

# Load the launchd job
echo "Loading launchd job..."
launchctl load "$AGENTS_DIR/com.local.brew-upgrade.plist" || {
    echo "Note: Job might already be loaded"
}

# Verify installation
if launchctl list | grep -q "com.local.brew-upgrade"; then
    echo -e "${GREEN}Installation successful!${NC}"
    echo ""
    echo "Next scheduled run: Daily at 2:00 AM"
    echo "View logs: tail -f ~/Library/Logs/brew-upgrade.log"
    echo "To uninstall: ./uninstall.sh"
else
    echo "Installation complete but job may need to be loaded manually"
    exit 1
fi
