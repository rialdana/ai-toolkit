---
title: Use --no- Prefix for Boolean Flag Negation
impact: MEDIUM
tags: flags, boolean, consistency
---

## Use --no- Prefix for Boolean Flag Negation

Boolean flags should support negation using the --no- prefix pattern. This makes the default behavior explicit and scriptable.

**Incorrect (can't override defaults or config file settings):**

```bash
# No way to disable color if config file enables it
mycli --color  # Enables color
# No --no-color flag exists

# Using separate flags creates confusion
mycli --color          # Enable color
mycli --disable-color  # Disable color (inconsistent naming)

# Using flag values is verbose
mycli --color=true
mycli --color=false
```

**Correct (--no- prefix for negation):**

```bash
# Standard pattern: flag enables, --no-flag disables
mycli --color          # Enable color
mycli --no-color       # Disable color

# More examples
mycli --interactive    # Enable prompts
mycli --no-interactive # Disable prompts (same as --no-input)

mycli --progress       # Show progress bars
mycli --no-progress    # Hide progress bars

# Respects precedence: flag > env var > config > default
# Can override config file setting:
mycli --no-color  # Disables color even if config.yaml has color: true
```

**Why it matters:** Configuration files and environment variables might enable features by default. Without negation flags, users can't override these defaults from the command line. The --no- prefix is a widely-recognized pattern that makes behavior explicit and predictable.

Reference: [clig.dev - Arguments and flags](https://clig.dev/#arguments-and-flags)
