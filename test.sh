#!/bin/bash

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Running tests for homebrew-launchd-updater${NC}\n"

FAILED=0

# Test 1: Check shellcheck is available
echo "Checking for shellcheck..."
if command -v shellcheck &> /dev/null; then
    echo -e "${GREEN}✓ shellcheck found${NC}"
else
    echo -e "${RED}✗ shellcheck not found (install with: brew install shellcheck)${NC}"
    FAILED=1
fi

# Test 2: Validate shell scripts with shellcheck
if command -v shellcheck &> /dev/null; then
    echo -e "\nValidating shell scripts..."
    # Skip brew-upgrade-helper.sh since shellcheck doesn't support zsh
    for script in install.sh uninstall.sh test.sh; do
        if shellcheck "$script" 2>/dev/null; then
            echo -e "${GREEN}✓ $script passes shellcheck${NC}"
        else
            echo -e "${RED}✗ $script has shellcheck issues${NC}"
            FAILED=1
        fi
    done
    echo -e "${BLUE}ℹ brew-upgrade-helper.sh skipped (zsh not supported by shellcheck)${NC}"
fi

# Test 3: Validate plist syntax
echo -e "\nValidating plist..."
if plutil -lint com.local.brew-upgrade.plist &> /dev/null; then
    echo -e "${GREEN}✓ com.local.brew-upgrade.plist is valid${NC}"
else
    echo -e "${RED}✗ com.local.brew-upgrade.plist is invalid${NC}"
    FAILED=1
fi

# Test 4: Check scripts are executable
echo -e "\nChecking file permissions..."
for script in brew-upgrade-helper.sh install.sh uninstall.sh test.sh; do
    if [[ -x "$script" ]]; then
        echo -e "${GREEN}✓ $script is executable${NC}"
    else
        echo -e "${RED}✗ $script is not executable${NC}"
        FAILED=1
    fi
done

# Test 5: Check required files exist
echo -e "\nChecking required files..."
for file in README.md LICENSE .gitignore; do
    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✓ $file exists${NC}"
    else
        echo -e "${RED}✗ $file missing${NC}"
        FAILED=1
    fi
done

# Summary
echo ""
if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed${NC}"
    exit 1
fi
