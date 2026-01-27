---
title: Use @concurrent to Force Background Execution
impact: MEDIUM
tags: threading, concurrent, background, execution
---

## Use @concurrent to Force Background Execution

The `@concurrent` attribute ensures a function runs on the global concurrent executor (background threads), not inheriting the caller's isolation.

**Incorrect (inherits MainActor, blocks UI):**

```swift
func processLargeFile(_ data: Data) async -> Result {
    // ❌ If called from @MainActor, runs on main thread
    return await heavyProcessing(data)
}

@MainActor
func loadAndProcess() async {
    let result = await processLargeFile(data)  // Blocks UI!
}
```

**Correct (@concurrent forces background):**

```swift
@concurrent
func processLargeFile(_ data: Data) async -> Result {
    // ✅ Always runs on background thread
    return await heavyProcessing(data)
}

@MainActor
func loadAndProcess() async {
    let result = await processLargeFile(data)  // ✅ Runs in background
}
```

**Why it matters:** By default, async functions inherit the caller's actor isolation. If a `@MainActor` function calls an async function without explicit isolation, that function also runs on the main thread, potentially blocking UI. `@concurrent` breaks inheritance and forces background execution on the global concurrent executor. Use for CPU-intensive work, large file processing, and operations that should never block the main thread.

Reference: [Swift Concurrency Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)
