---
name: cli-patterns
description: Design and implementation patterns for building command-line tools with modern UX conventions
---

# CLI Development Patterns

Modern CLI design patterns following established UX conventions for commands, flags, help text, output formats, error handling, signals, configuration, and distribution.

## When This Applies

Use this skill when you need to:
- Design a new CLI tool from scratch
- Review an existing CLI's UX and behavior
- Define command structures, flag schemas, or help text
- Make decisions about interactivity, output formats, or error handling
- Plan CLI distribution and packaging strategies
- Implement signal handling (Ctrl-C, cleanup)
- Configure environment variables and config files

## Philosophy

Modern CLI design is guided by these principles:

- **Human-first**: Design for humans using it daily, not just scripts (rich output by default, TTY detection, helpful errors)
- **Composability**: Be a well-behaved part of larger systems (respect stdin/stdout/stderr, exit codes, signals)
- **Consistency**: Follow established patterns users know (standard flag names, expected behaviors)
- **Discoverability**: Make features learnable without docs (help text, examples, suggestions)
- **Robustness**: Feel solid and reliable (validation, timeouts, idempotence, crash-only design)
- **Empathy**: Show you're on the user's side (helpful messages, anticipate mistakes, guide solutions)

## Rule Sections

All rules are organized in the `rules/` directory by section prefix:

| Section | Prefix | Impact | Key Rules |
|---------|--------|--------|-----------|
| **Design & Naming** | `design-` | HIGH | Command naming, subcommand structure, future-proofing, deprecation |
| **Flags & Arguments** | `flags-` | HIGH | Standard flags, short forms, boolean negation, consistency |
| **Output & Formatting** | `output-` | MEDIUM | stdout/stderr separation, machine-readable formats, TTY detection, color handling |
| **Error Handling** | `error-` | HIGH | Error message format, exit codes, signal-to-noise ratio |
| **Signals & Lifecycle** | `signal-` | HIGH | Ctrl-C handling, cleanup timeouts, crash-only design |
| **Environment & Config** | `env-` | MEDIUM | Naming conventions, precedence order, standard variables |
| **Distribution & Packaging** | `dist-` | MEDIUM | Single binary distribution, uninstall instructions |
| **Security & Privacy** | `security-` | CRITICAL | No secrets in env vars, telemetry consent |

## Quick Reference

### Standard Flags (Always Provide)
- `-h`, `--help` - Help text
- `-V`, `--version` - Show version
- `-v`, `--verbose` - More detailed output
- `-q`, `--quiet` - Suppress non-essential output
- `--json` - Machine-readable JSON output
- `--no-color` - Disable color output

### Exit Codes
- `0` - Success
- `1` - General error
- `2` - Invalid arguments/usage
- `130` - Terminated by Ctrl-C (SIGINT)

### Standard Environment Variables
- `NO_COLOR` - Disable color output
- `EDITOR` - User's preferred editor
- `HTTP_PROXY`, `HTTPS_PROXY` - Proxy settings
- `TMPDIR` - Temp directory

### Configuration Precedence
1. Command-line flags (highest priority)
2. Environment variables
3. Project config file (`.mycli.yaml` in current dir)
4. User config file (`~/.config/mycli/config.yaml`)
5. System config file (`/etc/mycli/config.yaml`)
6. Built-in defaults (lowest priority)

### Output Streams
- `stdout` - Primary command output (pipeable data)
- `stderr` - Logs, errors, progress, diagnostics

### Signal Handling
1. Ctrl-C → Immediate acknowledgment ("^C Stopping...")
2. Quick cleanup with 5-10 second timeout
3. Double Ctrl-C → Force exit, skip cleanup
4. Crash-only design: program works even if cleanup never ran

## Common Patterns

### Command Structure
```bash
# Simple commands (verb-based)
git commit
npm install

# Noun-verb pattern (for complex tools)
docker container start
kubectl get pods

# Multi-word commands use dashes
docker-compose up
```

### Flag Patterns
```bash
# Boolean flags with negation
--color / --no-color
--interactive / --no-interactive

# File input (avoid secrets in flags)
--config-file path/to/config.yaml
--token-file ~/.mycli/token
--token-stdin < token.txt

# Output formats
--json    # Machine-readable
--plain   # Script-friendly
```

### Error Message Structure
```
[What went wrong - one line, specific]

[Why it happened - if not obvious]

[How to fix it - exact command or action]

[Where to get help - if complex]
```

### TTY Detection
```javascript
if (process.stdout.isTTY) {
    // Interactive: use colors, spinners, progress bars
} else {
    // Scripted: plain text, no ANSI codes
}
```

## Workflow

### Phase 1: Design
1. Clarify context (users, platforms, primary usage)
2. Draft command model (name, subcommands, flags)
3. Define help and documentation strategy

### Phase 2: Specify Behavior
4. Specify I/O (stdout vs stderr, formats)
5. Define interactivity (prompts, confirmations)
6. Specify robustness (progress, timeouts, signals)
7. Specify configuration (files, env vars, precedence)

### Phase 3: Package & Distribute
8. Plan distribution (single binary, package managers)
9. Produce deliverables (help text, error messages, docs)

## Review Checklist

When reviewing CLI implementations, check:

**Command Structure**
- [ ] Command name is lowercase, short, easy to type
- [ ] Subcommands follow consistent pattern (noun-verb or verb-noun)
- [ ] No catch-all subcommands or abbreviation inference

**Flags & Arguments**
- [ ] Common flags use standard names (`-h`, `--help`, `-v`, `--verbose`)
- [ ] Both short and long forms for top 3-5 flags
- [ ] Boolean flags support `--no-` negation
- [ ] Flags consistent across all subcommands
- [ ] Secrets never passed via flags or env vars

**Output**
- [ ] Primary output goes to stdout
- [ ] Logs and errors go to stderr
- [ ] `--json` provided for machine-readable output
- [ ] TTY detection adjusts output (colors, progress)
- [ ] Respects `NO_COLOR`, supports `--no-color`

**Errors**
- [ ] Error messages are human-friendly and actionable
- [ ] Exit code 0 for success, non-zero for errors
- [ ] Similar errors grouped, not spammed
- [ ] Debug logs written to file, not terminal

**Signals**
- [ ] Ctrl-C exits quickly (<1 second acknowledgment)
- [ ] Cleanup has timeout (5-10 seconds max)
- [ ] Double Ctrl-C skips cleanup
- [ ] Crash-only design (works if cleanup didn't run)

**Environment & Config**
- [ ] Env vars follow `APPNAME_SETTING` naming
- [ ] Standard env vars checked (`NO_COLOR`, `EDITOR`, etc.)
- [ ] No secrets in env vars
- [ ] Precedence: flags > env > config > defaults

**Distribution**
- [ ] Single binary if possible
- [ ] Uninstall instructions in README (after install)
- [ ] `--version` flag provided
- [ ] Semantic versioning

**Security & Privacy**
- [ ] Secrets from files/stdin, not env vars or flags
- [ ] Telemetry is opt-in (if present)
- [ ] Privacy policy linked and clear
- [ ] Minimal data collection

## Related Documentation

See `metadata.json` for references to:
- Command Line Interface Guidelines (clig.dev)
- POSIX Utility Conventions
- 12 Factor CLI Apps

## Individual Rules

All detailed rules with incorrect/correct examples are in `rules/`:
- `design-*.md` - Design and naming conventions
- `flags-*.md` - Flag patterns and behavior
- `output-*.md` - Output formatting and streams
- `error-*.md` - Error handling patterns
- `signal-*.md` - Signal handling and lifecycle
- `env-*.md` - Environment variables and config
- `dist-*.md` - Distribution and packaging
- `security-*.md` - Security and privacy
