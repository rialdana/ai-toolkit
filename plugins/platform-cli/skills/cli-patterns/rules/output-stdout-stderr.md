---
title: Send Primary Output to stdout, Logs and Errors to stderr
impact: HIGH
tags: output, streams, composability
---

## Send Primary Output to stdout, Logs and Errors to stderr

Primary command output goes to stdout, while logs, progress, and errors go to stderr. This enables proper command composition and piping.

**Incorrect (mixes output and logs, breaks piping):**

```bash
# Everything to stdout - can't separate output from logs
mycli fetch-data > output.txt
# File contains mix of data and log messages:
# Connecting to API...
# {"user": "alice"}
# {"user": "bob"}
# Fetched 2 records
# Done

# Or everything to stderr - breaks piping
mycli fetch-data | jq '.user'
# Nothing in pipe because output went to stderr
```

**Correct (stdout for data, stderr for logs):**

```bash
# Primary output to stdout
mycli fetch-data > output.txt
# File contains only data:
# {"user": "alice"}
# {"user": "bob"}

# Logs and progress to stderr (visible on terminal, not in pipe)
mycli fetch-data | jq '.user'
# Terminal shows: Connecting to API... Fetched 2 records
# Pipe receives: {"user": "alice"}\n{"user": "bob"}
# jq output: "alice"\n"bob"

# Errors to stderr
mycli fetch-data 2> errors.txt
# errors.txt contains only error messages
```

**Why it matters:** Standard Unix philosophy relies on stdout carrying only primary output so commands can be chained. Mixing logs with output breaks pipes, grep, and other composition patterns. Users expect to redirect output (>) without capturing logs, and redirect errors (2>) without capturing data.

Reference: [clig.dev - Output](https://clig.dev/#output)
