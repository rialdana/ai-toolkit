---
title: Detect TTY and Adjust Output for Interactive vs Scripted Usage
impact: HIGH
tags: output, tty, ux, scripting
---

## Detect TTY and Adjust Output for Interactive vs Scripted Usage

Check if stdout is a TTY to determine whether to use colors, progress bars, and interactive features. Non-TTY output should be plain and script-friendly.

**Incorrect (always shows rich output, breaks pipes and redirects):**

```bash
# Always shows colors and progress, even when piped
mycli deploy | tee log.txt
# log.txt contains ANSI color codes: \x1b[32mSuccess\x1b[0m

# Always shows progress bars, even when not TTY
mycli sync > output.txt
# output.txt contains: [████████░░] 80%\r[█████████░] 90%\r...
```

**Correct (adapts to TTY vs non-TTY):**

```bash
# Interactive TTY: rich output
mycli deploy
# Terminal shows: 🚀 Deploying... [████████████████] 100% ✅ Success

# Piped or redirected: plain output
mycli deploy | tee log.txt
# Terminal shows: Deploying... Deployed successfully
# log.txt contains: Deploying... Deployed successfully

# Detection in code (Node.js example)
if (process.stdout.isTTY) {
    // Use colors, spinners, progress bars
    showProgressBar();
} else {
    // Plain text output
    console.log('Deploying...');
}

# Can override with flags
mycli deploy --no-color     # Force plain even in TTY
mycli deploy --color        # Force color even in non-TTY (for CI logs)
```

**Why it matters:** ANSI color codes and progress bars create garbage in log files and piped output. Users redirect output to files or pipe to other commands frequently. Detecting TTY makes your CLI well-behaved in both interactive and automated contexts.

Reference: [clig.dev - Output](https://clig.dev/#output)
