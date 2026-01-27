---
title: Use @preconcurrency Only With Documentation
impact: MEDIUM
tags: migration, preconcurrency, imports, documentation
---

## Use @preconcurrency Only With Documentation

`@preconcurrency` suppresses Sendable warnings for imported modules. Use only when the module will be updated later, and document why and when it will be removed.

**Incorrect (@preconcurrency without context):**

```swift
@preconcurrency import ThirdPartySDK  // ❌ No explanation

class MyManager {
    let sdk = ThirdPartySDK()
}
```

**Correct (@preconcurrency with documentation):**

```swift
// TODO: Remove @preconcurrency when ThirdPartySDK adds Sendable conformance
// Issue: SDK v2.5 doesn't conform to Sendable
// Tracked: https://github.com/vendor/sdk/issues/123
@preconcurrency import ThirdPartySDK

class MyManager {
    let sdk = ThirdPartySDK()
}
```

**Or with ticket:**

```swift
// JIRA-1234: Migrate to ThirdPartySDK 3.0 with Sendable support
@preconcurrency import ThirdPartySDK
```

**Why it matters:** `@preconcurrency` hides concurrency warnings, which can mask real safety issues. Without documentation, it's unclear why it's there, when it can be removed, or who's responsible for cleanup. Document: the reason for using `@preconcurrency`, the ticket/issue tracking removal, and the expected timeline. Remove `@preconcurrency` as soon as the dependency adds Sendable support.

Reference: [SE-0337: @preconcurrency](https://github.com/apple/swift-evolution/blob/main/proposals/0337-support-incremental-migration-to-concurrency-checking.md)
