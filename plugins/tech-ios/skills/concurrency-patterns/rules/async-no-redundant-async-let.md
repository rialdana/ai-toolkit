---
title: Avoid Redundant try/await in async let
impact: MEDIUM
tags: async-await, async-let, syntax
---

## Avoid Redundant try/await in async let

`async let` starts execution immediately. Don't use `try await` in the `async let` line - handle errors at the await point where you access the value.

**Incorrect (redundant keywords):**

```swift
async let data = try await fetchData()  // ❌ Redundant try/await
let result = await data
```

**Correct (errors handled at await point):**

```swift
async let data = fetchData()  // ✅ Starts immediately
let result = try await data   // Errors handled here
```

**Why it matters:** The redundant keywords don't add safety and create confusion about when execution starts. `async let` starts the operation immediately without waiting. Errors are naturally handled when you `await` the result.

Reference: [Swift Concurrency Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)
