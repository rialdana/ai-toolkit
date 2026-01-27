---
title: Implement Cleanup with Timeout and Crash-Only Design
impact: HIGH
tags: signals, cleanup, reliability, crash-only
---

## Implement Cleanup with Timeout and Crash-Only Design

Cleanup operations must have timeouts (5-10 seconds max) and programs should work correctly even if cleanup never ran (crash-only design).

**Incorrect (unbounded cleanup, broken state if skipped):**

```bash
# Cleanup blocks indefinitely
mycli process-data
# User hits Ctrl-C
# [Cleanup tries to finish all in-flight operations]
# [User waits 60 seconds, gets frustrated, kills process]

# Program broken if cleanup doesn't run
mycli start-server
# Creates lock file: /tmp/mycli.lock
# User kills with Ctrl-C
# Lock file not cleaned up
# Next run:
mycli start-server
# Error: Lock file exists. Another instance running?
# (No instance running - previous cleanup failed)
```

**Correct (timeout + crash-only design):**

```bash
# Cleanup with timeout
mycli process-data
# User hits Ctrl-C
# ^C Stopping gracefully... (timeout: 5s)
# [Cleanup runs for max 5 seconds]
# [After 5s, exits regardless of completion]

# Crash-only design: program works even if cleanup didn't run
mycli start-server
# Creates lock file with PID: /tmp/mycli.lock (PID: 12345)
# User kills with Ctrl-C
# Lock file not cleaned up
# Next run:
mycli start-server
# Checks if PID 12345 is still running
# PID not found → removes stale lock file
# Starts normally

# Example: Cleanup with timeout
async function cleanup() {
    const timeout = 5000; // 5 seconds max

    try {
        await Promise.race([
            closeConnections(),
            new Promise((_, reject) =>
                setTimeout(() => reject(new Error('Cleanup timeout')), timeout)
            )
        ]);
    } catch (err) {
        console.error('Cleanup incomplete:', err.message);
        // Exit anyway - crash-only design
    }
}

# Example: Stale lock detection
function acquireLock() {
    if (fs.existsSync('/tmp/mycli.lock')) {
        const pid = fs.readFileSync('/tmp/mycli.lock', 'utf8');
        if (isProcessRunning(pid)) {
            throw new Error('Another instance is running');
        } else {
            // Stale lock - remove it
            fs.unlinkSync('/tmp/mycli.lock');
        }
    }
    fs.writeFileSync('/tmp/mycli.lock', process.pid.toString());
}
```

**Why it matters:** Users will eventually kill your process (Ctrl-C, kill -9, system crash). Unbounded cleanup blocks users and gets force-killed anyway. Crash-only design ensures your program recovers gracefully from unexpected termination.

Reference: [Crash-only software](https://www.usenix.org/legacy/events/hotos03/tech/full_papers/candea/candea.pdf) and [clig.dev - Robustness](https://clig.dev/#robustness)
