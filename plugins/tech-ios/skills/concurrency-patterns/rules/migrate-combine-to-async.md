---
title: Replace Combine Pipelines With AsyncAlgorithms
impact: MEDIUM
tags: migration, combine, async-sequences, async-algorithms
---

## Replace Combine Pipelines With AsyncAlgorithms

Combine doesn't integrate well with Swift Concurrency. Replace Combine publishers with AsyncSequence and swift-async-algorithms for better integration.

**Incorrect (mixing Combine and async/await):**

```swift
import Combine

class DataManager {
    var cancellables = Set<AnyCancellable>()

    func observeUpdates() async {
        NotificationCenter.default
            .publisher(for: .dataUpdated)
            .sink { [weak self] _ in
                // ❌ Awkward bridging between Combine and async
                Task { await self?.handleUpdate() }
            }
            .store(in: &cancellables)
    }
}
```

**Correct (AsyncSequence with async algorithms):**

```swift
import AsyncAlgorithms

class DataManager {
    func observeUpdates() async {
        for await notification in NotificationCenter.default.notifications(
            named: .dataUpdated
        ) {
            await handleUpdate()  // ✅ Natural async/await flow
        }
    }
}

// With debounce, throttle, etc.
func observeSearchQuery() async {
    for await query in searchQueryStream.debounce(for: .milliseconds(300)) {
        await performSearch(query)
    }
}
```

**Add package:**
```swift
dependencies: [
    .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0")
]
```

**Why it matters:** Combine and async/await don't compose well - bridging requires awkward `Task { }` wrappers. `AsyncSequence` is the native concurrency primitive for streams. Swift Async Algorithms provides familiar operators (debounce, throttle, merge, combineLatest) for `AsyncSequence`. The integration is seamless, type-safe, and easier to reason about than mixing paradigms.

Reference: [Swift Async Algorithms](https://github.com/apple/swift-async-algorithms)
