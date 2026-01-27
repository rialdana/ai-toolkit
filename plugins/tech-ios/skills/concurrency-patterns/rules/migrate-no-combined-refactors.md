---
title: Do Not Combine Migration With Architecture Refactors
impact: HIGH
tags: migration, refactoring, focus, pull-requests
---

## Do Not Combine Migration With Architecture Refactors

Swift Concurrency migration should focus solely on concurrency changes. Don't combine with architecture refactors, API modernization, or code style improvements.

**Incorrect (mixing concerns):**

```swift
// PR: "Migrate UserManager to Swift 6 + refactor to MVVM"
// Changes:
// - Add @MainActor
// - Extract ViewModel
// - Rename methods
// - Add Sendable
// - Refactor dependencies
// - Update coding style
// ❌ Impossible to review, high risk
```

**Correct (focused migration):**

```swift
// PR 1: "Add Sendable to UserManager"
// Changes:
// - Make UserManager: Sendable
// - Add @MainActor where needed
// - Fix isolation issues
// ✅ Reviewable, low risk

// PR 2 (later): "Refactor UserManager to MVVM"
// Changes:
// - Extract ViewModel
// - Update architecture
// ✅ Separate concern, clear purpose
```

**Why it matters:** Combining migration with refactoring creates large, hard-to-review PRs, makes it difficult to isolate bugs, and increases risk of breaking changes. It's harder to revert if issues arise. Focus on minimal changes: one class/module at a time, small PRs that merge quickly, concurrency changes only. Create separate tickets for non-concurrency improvements and address them after migration stabilizes.

Reference: [Swift Concurrency Course - Migration Habits](https://www.swiftconcurrencycourse.com)
