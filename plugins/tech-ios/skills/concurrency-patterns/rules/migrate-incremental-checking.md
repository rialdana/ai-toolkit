---
title: Migrate Strict Concurrency Incrementally
impact: HIGH
tags: migration, strict-concurrency, swift-6, build-settings
---

## Migrate Strict Concurrency Incrementally

Enable strict concurrency checking in stages (Minimal → Targeted → Complete) rather than jumping to Complete, which can overwhelm with hundreds of errors.

**Incorrect (enabling Complete immediately):**

```swift
// Build Settings → Strict Concurrency Checking = Complete
// Result: 500+ errors, overwhelming to fix
```

**Correct (incremental approach):**

```swift
// Stage 1: Minimal (only code with explicit concurrency annotations)
// Build Settings → Strict Concurrency Checking = Minimal
// Fix errors → commit

// Stage 2: Targeted (all Sendable conformances)
// Build Settings → Strict Concurrency Checking = Targeted
// Fix new errors → commit

// Stage 3: Complete (entire codebase, Swift 6 equivalent)
// Build Settings → Strict Concurrency Checking = Complete
// Fix remaining errors → commit
```

**Levels explained:**
- **Minimal**: Only checks code with `@Sendable`, `@MainActor`, `async`, etc.
- **Targeted**: Adds Sendable conformance verification
- **Complete**: Checks entire codebase (matches Swift 6 mode)

**Why it matters:** Jumping to Complete exposes all concurrency issues at once, creating hundreds of cascading errors. Incremental migration lets you fix errors in manageable batches, commit progress, and avoid the concurrency rabbit hole. Each stage builds on the previous, reducing surprise errors. Allow 30 minutes per day for gradual migration rather than attempting completion in one session.

Reference: [Migrating to Swift 6](https://www.swift.org/migration/documentation/swift-6-concurrency-migration-guide/)
