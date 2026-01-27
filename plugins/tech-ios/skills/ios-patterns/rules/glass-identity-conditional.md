---
title: Use .identity Variant to Conditionally Disable Glass
impact: HIGH
tags: liquid-glass, variants, identity, conditional, debug
---

## Use .identity Variant to Conditionally Disable Glass

Use the `.identity` variant to temporarily disable glass effects based on conditions (debug mode, low power mode, user preferences) without removing the modifier.

**Incorrect:**

```swift
// ❌ WRONG: Conditional compilation removes the modifier
struct NavBar: View {
    var isDebugMode: Bool

    var body: some View {
        if #available(iOS 26.0, *) {
            Text("App Name")
                #if DEBUG
                // No glass effect - inconsistent code paths
                #else
                .glassEffect(.regular)
                #endif
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Use .identity to disable conditionally
struct NavBar: View {
    var isDebugMode: Bool

    var body: some View {
        if #available(iOS 26.0, *) {
            Text("App Name")
                .glassEffect(isDebugMode ? .identity : .regular)
        }
    }
}
```

**Why it matters:** Using `.identity` keeps the glass modifier structure intact while dynamically disabling the effect. This maintains consistent view hierarchy, simplifies testing, and allows runtime toggling without code branching. Removing modifiers conditionally creates different view hierarchies that can cause layout bugs.

Reference: [SwiftUI GlassEffect Variants API](https://developer.apple.com/documentation/swiftui/glasseffect/variants)
