# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability, please report it privately:

1. **Do not** open a public issue
2. Email security concerns to: hi@gvns.ca
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Response Timeline

- **Acknowledgment**: Within 48 hours
- **Initial assessment**: Within 1 week
- **Fix timeline**: Depends on severity
  - Critical: 1-2 weeks
  - High: 2-4 weeks
  - Medium/Low: Best effort

## Security Considerations

This tool runs via launchd with user privileges. Key security aspects:

- **No root access required**: Runs as the current user
- **No network exposure**: Only makes outbound connections to Homebrew servers
- **Transparent operation**: All actions logged to `~/Library/Logs/brew-upgrade.log`
- **No sensitive data**: Does not handle credentials or personal information
- **Open source**: All code is auditable

## Disclosure Policy

- Security issues will be disclosed after a fix is available
- Credit will be given to reporters (unless they prefer anonymity)
- A security advisory will be published in the GitHub repository

## Best Practices for Users

- Review the source code before installation
- Verify the plist configuration matches your expectations
- Monitor logs regularly: `tail ~/Library/Logs/brew-upgrade.log`
- Only install from trusted sources (official repo or your own fork)
