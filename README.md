# Homebrew launchd Updater

Automatically run `brew update && brew upgrade` daily on macOS using launchd, with smart checks for AC power, internet connectivity, and automatic retries on failure.

## Features

- **Scheduled daily runs** at 2 AM (configurable)
- **AC power detection** — Only runs when plugged in
- **Internet connectivity check** — Skips if offline
- **Automatic retries** — Up to 3 attempts with 5-minute delays
- **Timeout protection** — 30-minute hard timeout to prevent hanging processes
- **Clean logging** — All activity logged to `~/Library/Logs/brew-upgrade.log`
- **Silent background execution** — No notifications or interruptions
- **Prevents nested updates** — Sets `HOMEBREW_NO_AUTO_UPDATE=1`

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

Edit `com.local.brew-upgrade.plist` to change:
- **Run time**: Modify `StartCalendarInterval` (Hour and Minute keys)
- **Timeout**: Adjust `TimeOut` value (in seconds)

Edit `brew-upgrade-helper.sh` to change:
- `MAX_RETRIES`: Number of retry attempts (default: 3)
- `RETRY_DELAY`: Delay between retries in seconds (default: 300 = 5 minutes)
- `TIMEOUT`: Per-command timeout in seconds (default: 1800 = 30 minutes)

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

1. **launchd scheduler** triggers the job at the scheduled time (2 AM daily)
2. **Helper script** performs checks:
   - Verifies Mac is connected to AC power
   - Checks internet connectivity
   - Runs `brew update && brew upgrade` with automatic retries
3. **Timeout protection** ensures the process never hangs indefinitely
4. **All output** is logged to `~/Library/Logs/brew-upgrade.log`

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
- This is by design — the job only runs when plugged in to avoid draining battery

**Manual test run:**
```bash
~/Library/Application\ Support/brew-upgrade-helper.sh
```

**No shell profile needed:**
The script does not require `.zprofile` or `.zshrc` to be present—it detects brew's path dynamically using `which` and works in launchd's clean environment.

## License

MIT

## Contributing

Contributions welcome! Please open issues and PRs.

---

*Built with assistance from AI tooling.*
