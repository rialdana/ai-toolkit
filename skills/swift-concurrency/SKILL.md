---
name: swift-concurrency
description: "Swift Concurrency best practices and patterns for async/await, actors, tasks, and Sendable conformance. Use when: (1) writing async/await code, (2) implementing actors or isolation domains, (3) working with structured concurrency or task groups, (4) ensuring Sendable conformance and data race safety, (5) migrating to strict concurrency checking, (6) debugging or testing async code, (7) managing memory in async contexts."
---

# Swift Concurrency Patterns

Expert guidance on Swift Concurrency best practices covering async/await, actors, tasks, Sendable, threading, memory management, testing, and migration strategies.

## References

See [references/swift-concurrency.md](references/swift-concurrency.md) for comprehensive guidance organized by:

- **Async/Await Fundamentals** - Core patterns, error handling, parallel execution
- **Tasks & Structured Concurrency** - Task lifecycle, cancellation, task groups
- **Actors & Isolation** - Actor isolation, suspension points, state safety
- **Sendable & Data Safety** - Sendable conformance, data races, safe captures
- **Threading & Execution** - Execution contexts, isolation domains
- **Memory Management** - Retain cycles, weak references, task lifecycle
- **Testing Concurrency** - Async test patterns, Swift Testing integration
- **Migration & Interop** - Strict concurrency migration, legacy interop
