---
title: Use Lowercase, Short, Typeable Command Names
impact: HIGH
tags: naming, ux, discoverability
---

## Use Lowercase, Short, Typeable Command Names

Command names should be lowercase, short (4-8 characters ideal), easy to type with alternating hands, and memorable without being generic.

**Incorrect (hard to type, too long, or uses wrong case):**

```bash
# Too long
download-url-from-internet

# Wrong case (causes issues on case-insensitive systems)
DownloadURL
MyTool

# Hard to type (awkward one-hand typing)
plum

# Too generic (collides with existing commands)
convert
```

**Correct (lowercase, short, alternating-hand typing):**

```bash
# Good examples
curl    # 4 chars, alternating hands
git     # 3 chars, easy to type
docker  # 6 chars, memorable
kubectl # 7 chars, specific to Kubernetes
jq      # 2 chars, minimal but clear in context

# Multi-word commands use dashes
docker-compose
gh-cli
```

**Why it matters:** Users type your command name dozens or hundreds of times per day. Long or awkward names slow down workflows, mixed-case names cause confusion on case-insensitive filesystems, and generic names create conflicts with existing tools.

Reference: [clig.dev - Naming](https://clig.dev/#naming)
