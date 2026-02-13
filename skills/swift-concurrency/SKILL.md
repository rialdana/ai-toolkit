---
name: swift-concurrency
description: Swift Concurrency patterns — async/await, actors, tasks, Sendable conformance.
  Use when writing async/await code, implementing actors, working with structured
  concurrency, or ensuring data race safety.
metadata:
  category: framework
  tags:
  - swift
  - concurrency
  - async
  - actors
  - ios
  status: ready
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

## Examples

### Positive Trigger

User: "Refactor callback-based network code to async/await with actor isolation."

Expected behavior: Use `swift-concurrency` guidance, follow its workflow, and return actionable output.

### Non-Trigger

User: "Refactor CSS grid layout for mobile breakpoints."

Expected behavior: Do not prioritize `swift-concurrency`; choose a more relevant skill or proceed without it.

## Troubleshooting

### Skill Does Not Trigger

- Error: The skill is not selected when expected.
- Cause: Request wording does not clearly match the description trigger conditions.
- Solution: Rephrase with explicit domain/task keywords from the description and retry.

### Guidance Conflicts With Another Skill

- Error: Instructions from multiple skills conflict in one task.
- Cause: Overlapping scope across loaded skills.
- Solution: State which skill is authoritative for the current step and apply that workflow first.

### Output Is Too Generic

- Error: Result lacks concrete, actionable detail.
- Cause: Task input omitted context, constraints, or target format.
- Solution: Add specific constraints (environment, scope, format, success criteria) and rerun.

## Workflow

1. Identify whether the request clearly matches `swift-concurrency` scope and triggers.
2. Apply the skill rules and referenced guidance to produce a concrete result.
3. Validate output quality against constraints; if gaps remain, refine once with explicit assumptions.
