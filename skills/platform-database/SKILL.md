---
name: platform-database
description: "SQL database design, query optimization, and migration safety. Use when writing queries, designing schemas, or planning database migrations."
category: platform
extends: core-coding-standards
tags: [database, sql, queries, migrations, performance]
status: ready
---

# Principles

- Prefer UNION ALL over UNION unless you specifically need deduplication

# Rules

See `rules/` for detailed patterns.
