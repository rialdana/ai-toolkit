---
title: Capture Immutably in @Sendable Closures
impact: HIGH
tags: sendable, closures, captures, immutability
---

## Capture Immutably in @Sendable Closures

`@Sendable` closures can only capture immutable values. Use capture lists to create immutable snapshots of mutable variables.

**Incorrect (capturing mutable variable):**

```swift
var query = "search"

store.filter { contact in  // ❌ Error: mutable capture in @Sendable closure
    contact.name.contains(query)
}

query = "new search"  // Mutation visible to closure
```

**Correct (immutable capture list):**

```swift
var query = "search"

store.filter { [query] contact in  // ✅ Captures immutable snapshot
    contact.name.contains(query)
}

query = "new search"  // Mutation NOT visible to closure
```

**Or use let binding:**

```swift
let query = "search"  // ✅ Immutable from the start

store.filter { contact in
    contact.name.contains(query)
}
```

**Why it matters:** Mutable variables captured by `@Sendable` closures create data races when the closure runs on a different thread. The compiler prevents mutable captures to eliminate this entire class of bugs. Capture lists create an immutable snapshot at capture time, ensuring thread-safety. Use `[value]` syntax to capture immutably, or declare variables with `let` when possible.

Reference: [SE-0302: Sendable and @Sendable closures](https://github.com/apple/swift-evolution/blob/main/proposals/0302-concurrent-value-and-concurrent-closures.md)
