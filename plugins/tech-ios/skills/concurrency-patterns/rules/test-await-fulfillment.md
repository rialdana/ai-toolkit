---
title: Use await fulfillment Not wait in Async Tests
impact: HIGH
tags: testing, xctest, expectations, async
---

## Use await fulfillment Not wait in Async Tests

In async test methods, use `await fulfillment(of:)` instead of `wait(for:)` to avoid deadlocks with expectations.

**Incorrect (wait causes deadlock):**

```swift
@MainActor
func testSearchTask() async {
    let searcher = ArticleSearcher()
    let expectation = expectation(description: "Search complete")

    searcher.startSearchTask("swift")

    _ = withObservationTracking {
        searcher.results
    } onChange: {
        expectation.fulfill()
    }

    wait(for: [expectation], timeout: 10)  // ❌ Deadlock!
    XCTAssertEqual(searcher.results.count, 1)
}
```

**Correct (await fulfillment):**

```swift
@MainActor
func testSearchTask() async {
    let searcher = ArticleSearcher()
    let expectation = expectation(description: "Search complete")

    _ = withObservationTracking {
        searcher.results
    } onChange: {
        expectation.fulfill()
    }

    searcher.startSearchTask("swift")

    await fulfillment(of: [expectation], timeout: 10)  // ✅ Non-blocking
    XCTAssertEqual(searcher.results.count, 1)
}
```

**Why it matters:** `wait(for:)` blocks the current thread, which causes deadlocks in async contexts where the expectation must be fulfilled on the same thread. `await fulfillment(of:)` suspends the async function without blocking, allowing the expectation to complete. Always use `await fulfillment` in async test methods. This applies to XCTest; Swift Testing uses `confirmation` instead.

Reference: [Swift Concurrency Course - Testing](https://www.swiftconcurrencycourse.com)
