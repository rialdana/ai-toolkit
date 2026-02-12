---
name: lang-typescript
description: "TypeScript language patterns and type safety rules — strict mode, no any, discriminated unions. Use when writing TypeScript code, reviewing types, or enforcing type safety."
category: universal
extends: core-coding-standards
tags: [typescript, type-safety, language]
status: ready
---

# Principles

- Enable strict mode — no implicit any, strict null checks
- Prefer discriminated unions over type assertions
- Use `unknown` over `any` — narrow with type guards

# Rules

See `rules/` for detailed patterns.
