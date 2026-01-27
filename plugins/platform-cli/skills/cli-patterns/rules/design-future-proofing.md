---
title: Avoid Catch-All Subcommands and Abbreviation Inference
impact: CRITICAL
tags: future-proofing, api-stability, breaking-changes
---

## Avoid Catch-All Subcommands and Abbreviation Inference

Never implement catch-all subcommand matching or automatic abbreviation inference. These patterns prevent adding new subcommands in the future without breaking existing usage.

**Incorrect (blocks future subcommands):**

```bash
# Catch-all: "mycmd echo" works if no 'echo' subcommand exists
# Problem: Can't add 'echo' subcommand later without breaking scripts
mycmd echo "hello"  # Falls through to generic handler

# Abbreviation inference: guesses subcommand from prefix
# Problem: "mycmd i" means "install" now, but adding "init" breaks it
mycmd i package-name  # Infers "install"
# Later add "init" subcommand → "mycmd i" becomes ambiguous
```

**Correct (explicit subcommands and aliases only):**

```bash
# Require explicit subcommands always
mycmd install package-name  # Full name required
mycmd init                  # Full name required

# If abbreviations needed, define explicit aliases
mycmd i package-name  # 'i' is explicit alias for 'install', never inferred
# Can still add 'init' later because 'i' is hardcoded to 'install'

# Show helpful error for unknown subcommands
mycmd ech "hello"
# Error: Unknown subcommand 'ech'. Did you mean 'echo'?
```

**Why it matters:** Your CLI interface is a contract. Once released, changing how commands are resolved breaks user scripts and automation. Catch-all patterns and inference make it impossible to add new subcommands without potentially breaking existing usage. Explicit aliases provide convenience without blocking evolution.

Reference: [clig.dev - Future-proofing](https://clig.dev/#future-proofing)
