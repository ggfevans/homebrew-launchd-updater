# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-01-17

### Added
- Initial release
- Daily automated brew updates via launchd at 2 AM
- AC power detection (only runs when plugged in)
- Internet connectivity check
- Automatic retries (up to 3 attempts with 5-minute delays)
- 30-minute timeout protection
- Clean logging to `~/Library/Logs/brew-upgrade.log`
- Install and uninstall scripts
- Test suite with shellcheck validation
- Dynamic brew path detection (supports both Intel and Apple Silicon Macs)
