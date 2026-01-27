---
title: Use Meaningful Exit Codes with 0 for Success
impact: HIGH
tags: errors, exit-codes, scripting
---

## Use Meaningful Exit Codes with 0 for Success

Always exit with 0 for success and non-zero for failures. For complex tools, map exit codes to error categories and document them.

**Incorrect (wrong or meaningless exit codes):**

```bash
# Always exits 0, even on error
mycli deploy
# Error: deployment failed
echo $?
# 0  ← Wrong! Should be non-zero

# Random exit codes with no meaning
mycli build
echo $?
# 37  ← What does 37 mean? Undocumented
```

**Correct (meaningful, documented exit codes):**

```bash
# Standard exit codes (minimum)
mycli deploy           # Success
echo $?               # 0

mycli deploy --invalid # Invalid arguments
echo $?               # 2

# Extended exit codes for complex tools (document these)
mycli deploy
echo $?
# Exit codes:
#   0   - Success
#   1   - General error
#   2   - Invalid arguments
#   10  - Configuration error
#   20  - Network error
#   30  - Authentication error
#   40  - Validation error
#   50  - Resource not found
#   130 - Terminated by Ctrl-C (128 + 2)

# Use in scripts
mycli deploy
if [ $? -eq 0 ]; then
    echo "Success"
elif [ $? -eq 20 ]; then
    echo "Network error - retry later"
else
    echo "Failed with code $?"
fi

# Document in help text
mycli --help
# EXIT CODES
#   0   Success
#   1   General error
#   2   Invalid arguments/usage
#   10  Configuration error
#   20  Network error
```

**Why it matters:** Scripts and CI/CD pipelines rely on exit codes to determine success or failure. Exit code 0 means success across all Unix tools. Meaningful exit codes enable precise error handling in automation without parsing error messages.

Reference: [POSIX Exit Codes](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_08_02) and [clig.dev - Robustness](https://clig.dev/#robustness)
