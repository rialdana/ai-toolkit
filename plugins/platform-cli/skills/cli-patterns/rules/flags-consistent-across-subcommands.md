---
title: Keep Flag Names Consistent Across All Subcommands
impact: HIGH
tags: flags, consistency, ux
---

## Keep Flag Names Consistent Across All Subcommands

The same flag should mean the same thing across all subcommands. Reusing flag names with different meanings breaks user expectations.

**Incorrect (same flag means different things):**

```bash
# -f means different things in different subcommands
mycli deploy -f           # -f means --force (skip confirmation)
mycli build -f Dockerfile # -f means --file (specify file)
mycli logs -f             # -f means --follow (tail logs)

# Users can't build muscle memory - have to check help for each subcommand
```

**Correct (consistent flag meanings across subcommands):**

```bash
# -f always means --force
mycli deploy -f              # --force: skip confirmation
mycli delete -f              # --force: skip confirmation
mycli update -f              # --force: skip confirmation

# Use different flags for different meanings
mycli build --file Dockerfile    # -f not used, avoiding confusion
mycli logs --follow              # -f not used, avoiding confusion

# Or use -f consistently for one meaning if that's the primary use
git commit -f        # --force
git push -f          # --force
git clean -f         # --force
# Git never reuses -f for --file or --follow
```

**Why it matters:** Users learn your CLI by building muscle memory. When the same flag means different things in different contexts, users must constantly check help text and make more mistakes. Consistency enables users to work faster and with more confidence.

Reference: [clig.dev - Consistency](https://clig.dev/#consistency)
