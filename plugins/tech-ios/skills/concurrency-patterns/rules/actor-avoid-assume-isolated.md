---
title: Avoid assumeIsolated in Favor of Explicit Isolation
impact: MEDIUM
tags: actors, mainactor, isolation, safety
---

## Avoid assumeIsolated in Favor of Explicit Isolation

`assumeIsolated` bypasses compiler checks and crashes at runtime if the assumption is wrong. Prefer explicit `@MainActor` or `await MainActor.run`.

**Incorrect (assumeIsolated with hidden assumptions):**

```swift
@MainActor
func updateUI() {
    // Implementation
}

func methodB() {
    // ❌ Assumes main thread, crashes if wrong
    MainActor.assumeIsolated {
        updateUI()
    }
}
```

**Correct (explicit isolation with compile-time safety):**

```swift
@MainActor
func updateUI() {
    // Implementation
}

@MainActor  // ✅ Compiler verifies isolation
func methodB() {
    updateUI()
}

// Or if can't mark @MainActor
func methodC() async {
    await MainActor.run {  // ✅ Explicit hop, no crash risk
        updateUI()
    }
}
```

**Valid use case (proven invariant):**

```swift
func setup() {
    assert(Thread.isMainThread, "Must be called on main thread")

    MainActor.assumeIsolated {
        // OK - documented precondition, asserted
        updateUI()
    }
}
```

**Why it matters:** `assumeIsolated` crashes at runtime if the assumption is wrong, bypasses compiler safety checks, and hides isolation requirements from callers. Explicit `@MainActor` or `await MainActor.run` provides compile-time verification, clearer API contracts, and no crash risk. Only use `assumeIsolated` when you have a proven invariant (e.g., legacy callback known to run on main thread), and always document and assert the assumption.

Reference: [Swift Concurrency Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)
