---
title: Provide Short Flags Only for Top 3-5 Most Common Operations
impact: MEDIUM
tags: flags, ux, consistency
---

## Provide Short Flags Only for Top 3-5 Most Common Operations

Reserve short flags (-f, -v, -d) for the most frequently used operations. Too many short flags create confusion and naming conflicts.

**Incorrect (too many short flags, causing conflicts):**

```bash
# Every flag has a short form, creating a confusing alphabet soup
mycli -h --help
mycli -v --version
mycli -V --verbose      # Conflict: -V already used for --version
mycli -d --debug
mycli -o --output
mycli -i --input
mycli -f --format
mycli -F --force        # Conflict: case-sensitive flags are error-prone
mycli -t --timeout
mycli -r --retry
mycli -c --config
mycli -p --port
# ... users can't remember what each short flag means
```

**Correct (short flags for top operations only):**

```bash
# Universal short flags
-h, --help           # Always provide
-V, --version        # Always provide

# Top 3-5 most used flags get short forms
-v, --verbose        # Used frequently for debugging
-q, --quiet          # Used frequently in scripts
-f, --force          # Used frequently for automation
-o, --output FILE    # Used frequently for saving results

# Less common flags: long form only
--json               # Used occasionally
--no-color           # Used occasionally
--timeout SECONDS    # Used occasionally
--retry COUNT        # Used occasionally
--config FILE        # Used occasionally
```

**Why it matters:** Short flags are harder to remember and easier to confuse. Limiting them to frequently-used operations makes CLIs more learnable. Users will remember -v for verbose, but won't remember if -t means --timeout or --target. Long-only flags are self-documenting and shell completion makes them easy to use.

Reference: [clig.dev - Arguments and flags](https://clig.dev/#arguments-and-flags)
