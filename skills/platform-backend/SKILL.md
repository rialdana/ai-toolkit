---
name: platform-backend
description: "Server-side architecture and security — API design, error handling, validation, logging. Use when building APIs, server logic, or reviewing backend security."
category: platform
extends: core-coding-standards
tags: [backend, api, security, server]
status: ready
---

# Principles

- Throw early with guard clauses — fail fast at the top of functions
- Never swallow errors silently — log or propagate every failure

# Rules

See `rules/` for detailed patterns.
