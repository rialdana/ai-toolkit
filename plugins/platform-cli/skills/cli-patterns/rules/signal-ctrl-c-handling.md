---
title: Handle Ctrl-C Gracefully with Immediate Acknowledgment
impact: CRITICAL
tags: signals, ctrl-c, ux, reliability
---

## Handle Ctrl-C Gracefully with Immediate Acknowledgment

Always respond to Ctrl-C (SIGINT) immediately, perform quick cleanup with timeout, and support double Ctrl-C to force exit. Never block Ctrl-C for "safety".

**Incorrect (blocks Ctrl-C or ignores it):**

```bash
# Ignores Ctrl-C completely
mycli long-running-task
# User hits Ctrl-C → nothing happens
# User hits Ctrl-C again → still nothing
# User forced to kill -9 (causes worse state corruption)

# Blocks Ctrl-C with long cleanup
mycli sync-data
# User hits Ctrl-C
# [30 seconds of silence while cleanup runs]
# User has no idea if it worked, hits Ctrl-C again
# Still waiting... eventually kills process
```

**Correct (immediate acknowledgment, quick cleanup, force option):**

```bash
# Immediate acknowledgment
mycli long-running-task
# User hits Ctrl-C
# ^C Stopping gracefully... (Ctrl-C again to force)
#
# [Cleanup runs with 5-10 second timeout]
# Cleanup complete. Safe to exit.

# Double Ctrl-C skips cleanup
mycli sync-data
# User hits Ctrl-C
# ^C Stopping gracefully... (Ctrl-C again to force)
# User hits Ctrl-C again
# ^C Forcing exit. Skipping cleanup.
# [Exits immediately]

# Example implementation pattern
process.on('SIGINT', async () => {
    console.error('\n^C Stopping gracefully... (Ctrl-C again to force)');

    const forceExit = false;
    process.on('SIGINT', () => {
        console.error('^C Forcing exit.');
        process.exit(130); // 128 + 2 (SIGINT)
    });

    // Cleanup with timeout
    await Promise.race([
        cleanup(),
        new Promise(resolve => setTimeout(resolve, 5000))
    ]);

    process.exit(130);
});
```

**Why it matters:** Users expect Ctrl-C to work immediately. Blocking it causes frustration and forces users to kill -9, which causes worse state corruption than graceful cleanup. Double Ctrl-C provides an escape hatch for stuck cleanup.

Reference: [clig.dev - Signals](https://clig.dev/#signals-and-control-characters)
