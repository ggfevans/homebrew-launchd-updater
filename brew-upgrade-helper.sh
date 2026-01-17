#!/bin/zsh

# Exit on error
set -e

# Configuration
MAX_RETRIES=3
RETRY_DELAY=300  # 5 minutes
TIMEOUT=1800     # 30 minutes

# Detect brew path (works for both Apple Silicon and Intel Macs)
BREW_PATH=$(/usr/bin/which brew)
if [[ -z "$BREW_PATH" ]]; then
    echo "Error: Homebrew is not installed or not in PATH"
    exit 1
fi

# Check if connected to AC power
check_ac_power() {
    local power_status=$(pmset -g batt | grep -o "AC Power")
    if [[ -z "$power_status" ]]; then
        echo "Not plugged in - skipping brew upgrade"
        exit 0
    fi
}

# Check internet connectivity
check_connectivity() {
    if ! ping -c 1 8.8.8.8 &> /dev/null; then
        echo "No internet connectivity - skipping brew upgrade"
        exit 0
    fi
}

# Run brew upgrade with retries
brew_upgrade_with_retry() {
    local attempt=1
    
    while [[ $attempt -le $MAX_RETRIES ]]; do
        echo "[$(date)] Attempt $attempt/$MAX_RETRIES: Running brew update && brew upgrade"
        
        if timeout $TIMEOUT "$BREW_PATH" update && timeout $TIMEOUT "$BREW_PATH" upgrade; then
            echo "[$(date)] Successfully completed brew update and upgrade"
            return 0
        fi
        
        local exit_code=$?
        if [[ $exit_code -eq 124 ]]; then
            echo "[$(date)] Attempt $attempt timed out"
        else
            echo "[$(date)] Attempt $attempt failed with exit code $exit_code"
        fi
        
        if [[ $attempt -lt $MAX_RETRIES ]]; then
            echo "[$(date)] Waiting $RETRY_DELAY seconds before retry..."
            sleep $RETRY_DELAY
        fi
        
        ((attempt++))
    done
    
    echo "[$(date)] All $MAX_RETRIES attempts failed"
    return 1
}

# Main execution
echo "[$(date)] Starting brew upgrade automation"
check_ac_power
check_connectivity
brew_upgrade_with_retry
echo "[$(date)] Brew upgrade process completed"
