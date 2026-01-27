---
title: Never Pass NSManagedObject Across Isolation Boundaries
impact: CRITICAL
tags: core-data, sendable, thread-safety, migration
---

## Never Pass NSManagedObject Across Isolation Boundaries

`NSManagedObject` cannot conform to `Sendable` due to mutable properties and thread-affinity requirements. Pass `NSManagedObjectID` instead, which is thread-safe.

**Incorrect (passing managed object):**

```swift
@MainActor
func displayArticle(_ article: Article) {  // ❌ Article is NSManagedObject
    titleLabel.text = article.title
}

func processInBackground(article: Article) async throws {  // ❌ Not Sendable
    try await backgroundContext.perform {
        article.title = "Updated"  // ❌ Wrong context!
        try backgroundContext.save()
    }
}
```

**Correct (pass NSManagedObjectID):**

```swift
@MainActor
func displayArticle(id: NSManagedObjectID) {
    guard let article = viewContext.object(with: id) as? Article else {
        return
    }
    titleLabel.text = article.title
}

func processInBackground(articleID: NSManagedObjectID) async throws {
    let backgroundContext = container.newBackgroundContext()
    try await backgroundContext.perform {
        guard let article = backgroundContext.object(with: articleID) as? Article else {
            return
        }
        article.title = "Updated"
        try backgroundContext.save()
    }
}
```

**Why it matters:** Core Data's thread-safety rules don't change with Swift Concurrency. Accessing managed objects from the wrong thread causes crashes, data corruption, and undefined behavior. `NSManagedObjectID` is explicitly Sendable and can be safely passed between contexts. Enable Core Data debugging (`-com.apple.CoreData.ConcurrencyDebug 1`) to catch violations.

Reference: [Swift Concurrency Course - Core Data](https://www.swiftconcurrencycourse.com)
