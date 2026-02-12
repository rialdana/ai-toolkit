---
name: platform-testing
description: "Framework-agnostic testing principles — test philosophy, structure, mocking boundaries. Use when writing, reviewing, or debugging tests."
category: platform
extends: core-coding-standards
tags: [testing, mocking, test-design]
status: ready
---

# Principles

- Test behavior, not implementation details
- Prefer integration tests over unit tests (Testing Trophy)
- Arrange-Act-Assert (AAA) pattern in every test
- Tests must be independent — no shared mutable state
- Keep tests small and focused — one behavior per test
- Name tests to describe the behavior being verified
- Optimize for confidence, not coverage percentage
- Don't chase 100% coverage — test what matters

# Rules

See `rules/` for detailed patterns.
