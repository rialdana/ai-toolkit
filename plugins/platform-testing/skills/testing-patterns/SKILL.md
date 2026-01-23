---
name: testing-patterns
description: Generic testing patterns for writing effective tests. Use when writing tests in any framework.
---

# Testing Patterns

Framework-agnostic testing best practices. These rules apply regardless of your test framework (Vitest, Jest, XCTest, pytest).

## When This Applies

- Writing any kind of tests
- Deciding what to test
- Structuring test suites
- Choosing mocking strategies

## Extends

This is a **generic platform plugin**. Framework-specific plugins extend these rules:
- `vitest` - Vitest-specific patterns
- `jest` - Jest-specific patterns
- `xctest` - XCTest/Swift patterns

## Quick Reference

| Section | Impact | Prefix |
|---------|--------|--------|
| Philosophy | HIGH | `philosophy-` |
| Structure | HIGH | `test-` |
| Mocking | MEDIUM | `mock-` |
| Coverage | LOW | `coverage-` |

## The Testing Trophy

```
    ┌─────────────┐
    │   E2E       │  ← Few, slow, high confidence
    ├─────────────┤
    │ Integration │  ← Most tests here
    ├─────────────┤
    │    Unit     │  ← Some, for complex logic
    ├─────────────┤
    │   Static    │  ← TypeScript + linting (free)
    └─────────────┘
```

## Rules

See `rules/` directory for individual rules organized by section prefix.
