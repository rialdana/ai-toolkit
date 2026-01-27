---
title: Check Standard Environment Variables Before Defining Custom Ones
impact: MEDIUM
tags: environment, standards, interoperability
---

## Check Standard Environment Variables Before Defining Custom Ones

Always check for standard environment variables (NO_COLOR, EDITOR, HTTP_PROXY, etc.) before creating custom equivalents.

**Incorrect (ignores standard env vars, defines custom ones):**

```bash
# Ignores NO_COLOR, defines custom var
export MYCLI_DISABLE_COLOR=1  # Should use NO_COLOR
mycli status

# Ignores EDITOR, defines custom var
export MYCLI_EDITOR=vim       # Should use EDITOR
mycli edit-config

# Ignores HTTP_PROXY
# User has export HTTP_PROXY=http://proxy:8080
mycli fetch-data              # Doesn't use proxy, request fails
```

**Correct (respects standard env vars):**

```bash
# Check NO_COLOR before showing colors
NO_COLOR=1 mycli status       # Disables colors (standard)
# Also support custom flag for override
mycli status --color          # Enables colors even with NO_COLOR

# Use EDITOR for interactive editing
EDITOR=nano mycli edit-config # Opens nano (standard)
# Fallback: MYCLI_EDITOR, then vim

# Respect proxy settings
HTTP_PROXY=http://proxy:8080 mycli fetch-data
HTTPS_PROXY=http://proxy:8080 mycli fetch-data
NO_PROXY=localhost,127.0.0.1 mycli fetch-data

# Standard environment variables to check
NO_COLOR          # Disable color output
FORCE_COLOR       # Force color (override detection)
DEBUG             # Verbose debug output
EDITOR            # User's preferred editor
VISUAL            # Alternative to EDITOR (check both)
PAGER             # User's pager (less, more, etc.)
SHELL             # User's shell
HOME              # User home directory
TMPDIR            # Temp directory
TERM              # Terminal type
HTTP_PROXY        # HTTP proxy server
HTTPS_PROXY       # HTTPS proxy server
NO_PROXY          # Bypass proxy for these hosts

# Example implementation
function shouldUseColor() {
    // Check in precedence order
    if (flags.color !== undefined) return flags.color;
    if (flags.noColor) return false;
    if (process.env.NO_COLOR) return false;
    if (process.env.TERM === 'dumb') return false;
    if (!process.stdout.isTTY) return false;
    return true; // Default: use color
}
```

**Why it matters:** Standard environment variables work across all tools. Defining custom equivalents fragments the ecosystem and increases cognitive load. Users expect NO_COLOR to disable colors everywhere, EDITOR to work with all tools, and proxy settings to be respected.

Reference: [NO_COLOR](https://no-color.org/), [EDITOR](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html), and [clig.dev - Environment variables](https://clig.dev/#environment-variables)
