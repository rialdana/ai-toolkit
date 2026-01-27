---
title: Use Standard Flag Names for Common Operations
impact: HIGH
tags: flags, consistency, ux
---

## Use Standard Flag Names for Common Operations

Use conventional flag names for common operations so users can transfer knowledge between tools. Always provide both short and long forms for frequently-used flags.

**Incorrect (non-standard flag names confuse users):**

```bash
# Non-standard names
mycli --showhelp        # Should be --help
mycli --show-version    # Should be --version
mycli --loud            # Should be --verbose
mycli --silent          # Should be --quiet
mycli --no-confirm      # Should be --force
mycli --simulate        # Should be --dry-run

# Missing short forms for common flags
mycli --verbose --debug --force
```

**Correct (standard flag names with short forms):**

```bash
# Universal flags (provide in every CLI)
mycli -h, --help        # Help text
mycli -V, --version     # Show version (capital V, not -v)

# Common operation flags
mycli -v, --verbose     # More detailed output
mycli -q, --quiet       # Suppress non-essential output
mycli -d, --debug       # Debug-level output
mycli -f, --force       # Skip confirmations, override safety
mycli -n, --dry-run     # Simulate without changes
mycli -a, --all         # Include all items
mycli -o, --output FILE # Output file path

# Modern flags (no short form needed)
mycli --json            # JSON output format
mycli --plain           # Plain text (script-friendly)
mycli --no-color        # Disable color output
mycli --no-input        # Non-interactive mode
```

**Why it matters:** Users expect `-h` for help and `-v` for verbose across all tools. Non-standard names increase cognitive load and slow down adoption. Providing both short and long forms serves both interactive users (who prefer brevity) and scripts (which prefer clarity).

Reference: [clig.dev - Arguments and flags](https://clig.dev/#arguments-and-flags)
