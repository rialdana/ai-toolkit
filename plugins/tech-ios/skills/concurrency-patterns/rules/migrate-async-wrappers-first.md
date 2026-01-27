---
title: Wrap Closure APIs With Async Alternatives First
impact: MEDIUM
tags: migration, async-await, continuations, deprecation
---

## Wrap Closure APIs With Async Alternatives First

Before migrating closure-based implementations, add async wrappers using continuations. This lets callers migrate first while keeping old code working.

**Incorrect (removing closure API immediately):**

```swift
// ❌ Breaking change - forces all callers to migrate at once
func fetchImage(urlRequest: URLRequest) async throws -> UIImage {
    // New implementation
}
// Old closure-based API removed - breaks existing callers
```

**Correct (async wrapper alongside closure API):**

```swift
// Keep existing API, mark deprecated
@available(*, deprecated, renamed: "fetchImage(urlRequest:)",
           message: "Consider using the async/await alternative.")
func fetchImage(urlRequest: URLRequest,
                completion: @escaping @Sendable (Result<UIImage, Error>) -> Void) {
    // ... existing implementation
}

// Add async wrapper
func fetchImage(urlRequest: URLRequest) async throws -> UIImage {
    return try await withCheckedThrowingContinuation { continuation in
        fetchImage(urlRequest: urlRequest) { result in
            continuation.resume(with: result)
        }
    }
}
```

**Xcode shortcut:** Refactor → Add Async Wrapper

**Why it matters:** Adding async wrappers first allows gradual migration of callers, maintains backward compatibility, enables testing with async/await before rewriting internals, and lets colleagues start using modern APIs immediately. Callers can migrate on their own schedule. Once all callers are migrated, you can rewrite or remove the closure-based implementation.

Reference: [Swift Concurrency Course - Migration](https://www.swiftconcurrencycourse.com)
