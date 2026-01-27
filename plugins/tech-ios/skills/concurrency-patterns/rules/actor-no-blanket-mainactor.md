---
title: Do Not Use @MainActor as Blanket Fix
impact: HIGH
tags: actors, mainactor, isolation, performance
---

## Do Not Use @MainActor as Blanket Fix

Adding `@MainActor` to silence concurrency warnings without understanding isolation needs forces unnecessary main-thread execution and harms performance.

**Incorrect (@MainActor on non-UI code):**

```swift
@MainActor  // ❌ Forces background work onto main thread
class DataProcessor {
    func processLargeDataset(_ data: [Item]) async -> [Result] {
        // Heavy computation on main thread - blocks UI!
        return data.map { processItem($0) }
    }
}
```

**Correct (isolated only where needed):**

```swift
class DataProcessor {
    func processLargeDataset(_ data: [Item]) async -> [Result] {
        // ✅ Runs on background thread
        return data.map { processItem($0) }
    }

    @MainActor
    func updateUI(with results: [Result]) {
        // Only UI updates on main thread
        self.displayResults(results)
    }
}
```

**Why it matters:** `@MainActor` forces all method calls to serialize on the main thread, blocking UI and degrading performance. Only use `@MainActor` for code that genuinely accesses UI or must run on the main thread. Background operations, networking, parsing, and computation should run concurrently on background threads. Indiscriminate use of `@MainActor` eliminates the benefits of async/await concurrency.

Reference: [SE-0316: Global Actors](https://github.com/apple/swift-evolution/blob/main/proposals/0316-global-actors.md)
