# Rule Sections

This file defines the organizational structure for CLI development rules.

## Section Definitions

| # | Section | Prefix | Impact | Description |
|---|---------|--------|--------|-------------|
| 1 | Design & Naming | `design-` | HIGH | Command naming, structure, and future-proofing |
| 2 | Flags & Arguments | `flags-` | HIGH | Flag naming, behavior, and consistency |
| 3 | Output & Formatting | `output-` | MEDIUM | stdout/stderr, colors, TTY detection |
| 4 | Error Handling | `error-` | HIGH | Error messages, exit codes, actionability |
| 5 | Signals & Lifecycle | `signal-` | HIGH | Ctrl-C handling, cleanup, crash-only design |
| 6 | Environment & Config | `env-` | MEDIUM | Environment variables, config files, precedence |
| 7 | Distribution & Packaging | `dist-` | MEDIUM | Installation, uninstallation, versioning |
| 8 | Security & Privacy | `security-` | CRITICAL | Secrets handling, telemetry, privacy |

## Usage

Each rule file should be named using the pattern: `{prefix}-{descriptive-name}.md`

Examples:
- `design-naming-conventions.md`
- `flags-standard-flags.md`
- `error-exit-codes.md`
- `security-no-env-secrets.md`
