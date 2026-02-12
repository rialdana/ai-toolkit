---
name: platform-frontend
description: "Framework-agnostic frontend architecture — state management, components, data fetching. Use when building any web frontend, choosing state patterns, or structuring UI code."
category: platform
extends: core-coding-standards
tags: [frontend, ui, components, state]
status: ready
---

# Principles

- Start with local state — lift only when shared
- Organize code by feature, not by type
- Use named exports for better refactoring and searchability
- Never use barrel files (index.ts re-exports) — they break tree-shaking and slow builds
- Measure before memoizing — don't optimize what isn't slow

# Rules

See `rules/` for detailed patterns.
