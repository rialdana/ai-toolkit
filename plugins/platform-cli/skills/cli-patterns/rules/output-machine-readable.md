---
title: Provide Machine-Readable Output Format (--json or --plain)
impact: MEDIUM
tags: output, automation, scripting
---

## Provide Machine-Readable Output Format (--json or --plain)

Provide a stable, machine-readable output format via --json or --plain flags. Human-readable output can change freely, but machine formats must be stable.

**Incorrect (only human output, forces brittle parsing):**

```bash
# Only pretty human output available
mycli list-users
# Name          Email              Status
# ──────────────────────────────────────────
# Alice Smith   alice@example.com  active
# Bob Jones     bob@example.com    inactive

# Scripts forced to parse pretty output (fragile)
mycli list-users | awk '{print $3}'  # Breaks if column order changes
```

**Correct (provide machine-readable format):**

```bash
# Human output (default, can change between versions)
mycli list-users
# Name          Email              Status
# ──────────────────────────────────────────
# Alice Smith   alice@example.com  active
# Bob Jones     bob@example.com    inactive

# Machine output (stable, versioned schema)
mycli list-users --json
# [
#   {"name": "Alice Smith", "email": "alice@example.com", "status": "active"},
#   {"name": "Bob Jones", "email": "bob@example.com", "status": "inactive"}
# ]

# Scripts can reliably parse JSON
mycli list-users --json | jq '.[].email'

# Alternative: --plain for simple formats (TSV, CSV)
mycli list-users --plain
# Alice Smith\talice@example.com\tactive
# Bob Jones\tbob@example.com\tinactive
```

**Why it matters:** Human-readable output should evolve to improve UX, but every change breaks scripts that parse it. Providing a stable machine format lets you improve the human experience without breaking automation. Scripts become more reliable and maintainable.

Reference: [clig.dev - Output](https://clig.dev/#output)
