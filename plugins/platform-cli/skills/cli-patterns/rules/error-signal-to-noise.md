---
title: Reduce Error Noise by Grouping and Limiting Output
impact: MEDIUM
tags: errors, ux, debugging
---

## Reduce Error Noise by Grouping and Limiting Output

Group similar errors, limit repeated messages, and write debug logs to files instead of the terminal. Avoid overwhelming users with verbose error output.

**Incorrect (error spam overwhelms the user):**

```bash
# Prints the same error 1000 times
mycli validate-files **/*.json
# Error: Invalid JSON in file1.json: Unexpected token
# Error: Invalid JSON in file2.json: Unexpected token
# Error: Invalid JSON in file3.json: Unexpected token
# ... (997 more identical lines)
#
# Stack trace:
#     at JSON.parse (native)
#     at validate (/app/validator.js:45:18)
#     ... (50 more stack trace lines)
```

**Correct (grouped, summarized errors):**

```bash
# Group and summarize similar errors
mycli validate-files **/*.json
# Found 1000 files with invalid JSON:
#
#   file1.json:12 - Unexpected token
#   file2.json:8  - Unexpected token
#   file3.json:15 - Unexpected token
#   ... (7 more shown)
#
# 990 more files with similar errors (use --verbose to see all)
#
# To see detailed error information:
#   mycli validate-files --verbose
#
# Debug log written to: /tmp/mycli-debug-20260127.log

# Highlighting strategy
# ✅ Use color sparingly (only for key error line)
# ❌ Don't make everything red
# ✅ Keep total error output under one screen when possible
# ❌ Don't dump entire stack traces to terminal

# Write verbose logs to file
mycli deploy --debug
# Debug log written to: ~/.mycli/logs/deploy-20260127-143022.log
# Run 'tail -f ~/.mycli/logs/deploy-20260127-143022.log' to follow
```

**Why it matters:** Verbose errors create cognitive overload and hide important information. Users scan for actionable info, not stack traces. Grouping similar errors and writing debug output to files keeps the terminal clean while preserving detail for debugging.

Reference: [clig.dev - Errors](https://clig.dev/#errors)
