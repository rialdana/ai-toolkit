---
title: Respect NO_COLOR, Support --no-color, Detect TERM=dumb
impact: MEDIUM
tags: output, color, accessibility, environment
---

## Respect NO_COLOR, Support --no-color, Detect TERM=dumb

Disable colors when NO_COLOR environment variable is set, when --no-color flag is used, when TERM=dumb, or when output is not a TTY.

**Incorrect (ignores color preferences, accessibility barriers):**

```bash
# Always shows colors regardless of environment
NO_COLOR=1 mycli status
# Still shows colors (ignores NO_COLOR)

# No way to disable colors
mycli status --no-color
# Error: unknown flag --no-color

# Shows colors in dumb terminals
TERM=dumb mycli status
# ANSI codes shown as garbage: ^[[32mOK^[[0m
```

**Correct (respects all color preferences):**

```bash
# Respects NO_COLOR environment variable
NO_COLOR=1 mycli status
# Plain output: Status: OK

# Supports --no-color flag
mycli status --no-color
# Plain output: Status: OK

# Detects dumb terminals
TERM=dumb mycli status
# Plain output: Status: OK

# Detects non-TTY
mycli status > log.txt
# log.txt contains plain text, no ANSI codes

# Color decision order (first match wins):
# 1. --no-color flag → disable
# 2. --color flag → enable
# 3. NO_COLOR env var → disable
# 4. TERM=dumb → disable
# 5. !isTTY → disable
# 6. Default → enable
```

**Why it matters:** Not everyone can perceive colors. Some terminals don't support ANSI codes. The NO_COLOR standard (no-color.org) is widely adopted. Ignoring these preferences creates accessibility barriers and broken output in certain environments.

Reference: [NO_COLOR standard](https://no-color.org/) and [clig.dev - Output](https://clig.dev/#output)
