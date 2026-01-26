---
name: vitest-patterns
description: Vitest-specific patterns for mocking, hooks, and configuration. Use when writing tests with Vitest.
---

# Vitest Patterns

Vitest-specific best practices. These rules build on the generic `platform-testing` plugin with Vitest-specific APIs.

## When This Applies

- Vitest in devDependencies
- Writing tests with Vitest
- Configuring test environments

## Extends

This plugin extends **`platform-testing`** (generic testing patterns). Apply those rules first, then these Vitest-specific ones.

## Quick Reference

| Section | Impact | Prefix |
|---------|--------|--------|
| Mocking | HIGH | `mock-` |
| Hooks | MEDIUM | `hooks-` |
| Assertions | LOW | `assert-` |

## Rules

See `rules/` directory for individual rules organized by section prefix.
