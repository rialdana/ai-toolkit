---
name: concurrency-patterns
description: Swift Concurrency patterns for async/await, actors, tasks, and Sendable. Use when working with Swift concurrency.
---

# Swift Concurrency Patterns

Best practices for Swift Concurrency including async/await, actors, structured concurrency, Sendable, and migration.

## When This Applies

- Using async/await in Swift
- Working with actors or @MainActor
- Implementing structured concurrency with tasks and task groups
- Ensuring Sendable conformance and data race safety
- Migrating to strict concurrency checking
- Testing async code
- Managing memory in concurrent contexts

## Quick Reference

| Section | Impact | Prefix | Rules |
|---------|--------|--------|-------|
| Async/Await Fundamentals | HIGH | `async-` | 4 |
| Tasks & Structured Concurrency | HIGH | `task-` | 6 |
| Actors & Isolation | CRITICAL | `actor-` | 6 |
| Sendable & Data Safety | CRITICAL | `send-` | 5 |
| Threading & Execution | HIGH | `thread-` | 4 |
| Memory Management | HIGH | `mem-` | 3 |
| Testing Concurrency | MEDIUM | `test-` | 4 |
| Migration & Interop | MEDIUM | `migrate-` | 6 |

## Rules

See `rules/` directory for individual rules organized by section prefix.
