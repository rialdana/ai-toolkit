---
title: Use Serial Executor to Eliminate Flaky Concurrency Tests
impact: MEDIUM
tags: testing, flaky-tests, serial-executor, race-conditions
---

## Use Serial Executor to Eliminate Flaky Concurrency Tests

Tests that check intermediate async state are flaky due to race conditions. Use `withMainSerialExecutor` from ConcurrencyExtras for deterministic task scheduling.

**Incorrect (flaky test):**

```swift
@Test
@MainActor
func isLoadingState() async throws {
    let fetcher = ImageFetcher()

    let task = Task { try await fetcher.fetch(url) }

    // ❌ Flaky - task may complete before we check
    #expect(fetcher.isLoading == true)

    try await task.value
    #expect(fetcher.isLoading == false)
}
```

**Correct (serial executor for determinism):**

```swift
import ConcurrencyExtras

@Test
@MainActor
func isLoadingState() async throws {
    try await withMainSerialExecutor {
        let fetcher = ImageFetcher { url in
            await Task.yield()  // Allow test to check state
            return Data()
        }

        let task = Task { try await fetcher.fetch(url) }

        await Task.yield()  // Switch to task

        #expect(fetcher.isLoading == true)  // ✅ Reliable

        try await task.value
        #expect(fetcher.isLoading == false)
    }
}
```

**Critical requirement:**

```swift
@Suite(.serialized)  // Tests must run serially
@MainActor
final class ImageFetcherTests {
    // Tests using withMainSerialExecutor
}
```

**Why it matters:** Default concurrency allows tasks to interleave unpredictably, causing flaky tests. Serial executor makes MainActor tasks execute sequentially and deterministically. `Task.yield()` becomes a predictable scheduling point. Add package: `https://github.com/pointfreeco/swift-concurrency-extras.git`. Mark suite with `.serialized` to prevent parallel execution conflicts.

Reference: [Swift Concurrency Extras](https://github.com/pointfreeco/swift-concurrency-extras)
