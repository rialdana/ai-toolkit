---
title: Prefer Swift Testing Over XCTest for New Tests
impact: MEDIUM
tags: testing, swift-testing, xctest, best-practices
---

## Prefer Swift Testing Over XCTest for New Tests

Swift Testing provides better concurrency support, modern Swift syntax with macros, and cleaner test structure compared to XCTest.

**Incorrect (XCTest for new tests):**

```swift
final class ArticleSearcherTests: XCTestCase {
    @MainActor
    func testEmptyQuery() async {
        let searcher = ArticleSearcher()
        await searcher.search("")
        XCTAssertEqual(searcher.results, ArticleSearcher.allArticles)
    }
}
```

**Correct (Swift Testing):**

```swift
@Test
@MainActor
func emptyQuery() async {
    let searcher = ArticleSearcher()
    await searcher.search("")
    #expect(searcher.results == ArticleSearcher.allArticles)
}
```

**Benefits:**
- `@Test` macro instead of `XCTestCase` subclass
- `#expect` with cleaner syntax than `XCTAssert`
- Structs preferred over classes
- No `test` prefix required
- Better async/await integration
- More flexible test organization

**Why it matters:** Swift Testing is the modern, recommended testing framework for Swift. It's designed from the ground up with concurrency in mind. XCTest has legacy async support but wasn't built for Swift Concurrency. Use Swift Testing for new tests; maintain XCTest tests in legacy codebases until migration is practical.

Reference: [Swift Testing Documentation](https://developer.apple.com/documentation/testing)
