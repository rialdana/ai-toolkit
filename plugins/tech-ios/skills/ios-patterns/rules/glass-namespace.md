---
title: Declare @Namespace for Glass Morphing
impact: MEDIUM
tags: liquid-glass, morphing, namespace, animation, state
---

## Declare @Namespace for Glass Morphing

Always declare a `@Namespace` property when using glass morphing transitions. The namespace provides the coordination space for matching glass IDs across view states.

**Incorrect:**

```swift
// ❌ WRONG: No namespace for morphing IDs
struct MorphingView: View {
    @State private var isExpanded = false

    var body: some View {
        if #available(iOS 26.0, *) {
            if isExpanded {
                ExpandedView()
                    .glassEffectID("view", in: ???)  // ❌ No namespace declared
            } else {
                CompactView()
                    .glassEffectID("view", in: ???)  // ❌ Can't compile
            }
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: @Namespace declared for coordination
struct MorphingView: View {
    @Namespace private var glassNamespace  // ✅ Namespace property
    @State private var isExpanded = false

    var body: some View {
        if #available(iOS 26.0, *) {
            if isExpanded {
                ExpandedView()
                    .glassEffectID("view", in: glassNamespace)
            } else {
                CompactView()
                    .glassEffectID("view", in: glassNamespace)
            }
        }
    }
}
```

**Why it matters:** The `@Namespace` creates a unique identifier space that SwiftUI uses to match views across state changes. Without it, `glassEffectID` cannot function. The namespace must be declared in the same view that contains both source and destination states - passing namespaces across view boundaries breaks the morphing system.

Reference: [SwiftUI Namespace API](https://developer.apple.com/documentation/swiftui/namespace)
