# Homebrew launchd Updater

[![Tests](https://github.com/ggfevans/homebrew-launchd-updater/workflows/Tests/badge.svg)](https://github.com/ggfevans/homebrew-launchd-updater/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Automatically run `brew update && brew upgrade` daily on macOS using launchd. Checks for AC power and internet connectivity before running.

## Features

- Runs at 2 AM daily (configurable)
- Only runs when plugged into AC power
- Skips if offline
- Retries up to 3 times with 5-minute delays
- 30-minute timeout to prevent hanging
- Logs to `~/Library/Logs/brew-upgrade.log`
- Runs silently in background
- Sets `HOMEBREW_NO_AUTO_UPDATE=1` to prevent nested updates

## Installation

### Quick Install

```bash
git clone https://github.com/ggfevans/homebrew-launchd-updater.git
cd homebrew-launchd-updater
./install.sh
```

### Manual Install

1. Copy the helper script:
```bash
mkdir -p ~/Library/Application\ Support
cp brew-upgrade-helper.sh ~/Library/Application\ Support/
chmod +x ~/Library/Application\ Support/brew-upgrade-helper.sh
```

2. Copy the launchd plist:
```bash
mkdir -p ~/Library/LaunchAgents
cp com.local.brew-upgrade.plist ~/Library/LaunchAgents/
```

3. Load the job:
```bash
launchctl load ~/Library/LaunchAgents/com.local.brew-upgrade.plist
```

## Configuration

Edit `com.local.brew-upgrade.plist`:
- Run time: Modify `StartCalendarInterval` (Hour and Minute keys)
- Timeout: Adjust `TimeOut` value (in seconds)

Edit `brew-upgrade-helper.sh`:
- `MAX_RETRIES`: Number of retry attempts (default: 3)
- `RETRY_DELAY`: Delay between retries in seconds (default: 300)
- `TIMEOUT`: Per-command timeout in seconds (default: 1800)

## Monitoring

View the logs:
```bash
tail -f ~/Library/Logs/brew-upgrade.log
```

Check if the job is loaded:
```bash
launchctl list | grep brew-upgrade
```

Get next scheduled run:
```bash
launchctl list com.local.brew-upgrade
```

## Uninstall

```bash
launchctl unload ~/Library/LaunchAgents/com.local.brew-upgrade.plist
rm ~/Library/LaunchAgents/com.local.brew-upgrade.plist
rm ~/Library/Application\ Support/brew-upgrade-helper.sh
rm ~/Library/Logs/brew-upgrade.log
```

Or use the provided uninstall script:
```bash
./uninstall.sh
```

## How It Works

1. launchd triggers the job at 2 AM daily
2. Helper script checks:
   - AC power connection
   - Internet connectivity
   - Runs `brew update && brew upgrade` with retries
3. Timeout kills the process after 30 minutes
4. Output logged to `~/Library/Logs/brew-upgrade.log`

## Requirements

- macOS (10.12+)
- Homebrew installed
- zsh or bash

## Troubleshooting

**Job not running?**
- Check logs: `tail ~/Library/Logs/brew-upgrade.log`
- Verify it's loaded: `launchctl list | grep brew-upgrade`
- Reload: `launchctl unload ~/Library/LaunchAgents/com.local.brew-upgrade.plist && launchctl load ~/Library/LaunchAgents/com.local.brew-upgrade.plist`

**Permission denied errors?**
- Make sure helper script is executable: `chmod +x ~/Library/Application\ Support/brew-upgrade-helper.sh`

**Running on battery?**
- By design. The job only runs when plugged in.

**Manual test run:**
```bash
~/Library/Application\ Support/brew-upgrade-helper.sh
```

**No shell profile needed:**
Script doesn't need `.zprofile` or `.zshrc`. Detects brew path with `which`.

## License

MIT

## Testing

Run the test suite to validate all scripts and configuration:
```bash
./test.sh
```

Requires `shellcheck` (install with `brew install shellcheck`).

## Contributing

Contributions welcome! Please open issues and PRs.

---

*Built with assistance from AI tooling.*
