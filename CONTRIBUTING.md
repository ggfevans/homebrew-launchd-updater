# Contributing

Thanks for your interest in contributing to homebrew-launchd-updater.

## Reporting Bugs

Open an issue with:
- Your macOS version
- Homebrew version (`brew --version`)
- Relevant log output from `~/Library/Logs/brew-upgrade.log`
- Steps to reproduce

## Submitting Changes

1. Fork the repo
2. Create a branch (`git checkout -b fix-something`)
3. Make your changes
4. Run tests: `./test.sh`
5. Commit with clear message
6. Push and open a PR

## Code Style

- Keep it simple
- Follow existing patterns in the codebase
- Shell scripts should pass `shellcheck` (bash scripts only)

## Testing

Run the test suite before submitting:
```bash
./test.sh
```

Requires `shellcheck` (install with `brew install shellcheck`).

## Questions

Open an issue if you're unsure about anything.
