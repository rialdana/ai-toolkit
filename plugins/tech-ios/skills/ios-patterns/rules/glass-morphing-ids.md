---
title: Use Same glassEffectID for Morphing Animations
impact: MEDIUM
tags: liquid-glass, morphing, transitions, animation, id
---

## Use Same glassEffectID for Morphing Animations

When animating between two glass states, use the same `glassEffectID` in both views to trigger automatic morphing transitions. Different IDs result in fade transitions instead of fluid morphing.

**Incorrect:**

```swift
// ❌ WRONG: Different IDs cause fade instead of morph
struct CardView: View {
    @Namespace private var glassNamespace
    @State private var isExpanded = false

    var body: some View {
        if #available(iOS 26.0, *) {
            if isExpanded {
                ExpandedCard()
                    .glassEffectID("expanded", in: glassNamespace)  // ❌ Different ID
            } else {
                CompactCard()
                    .glassEffectID("compact", in: glassNamespace)  // ❌ Different ID
            }
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Same ID enables morphing
struct CardView: View {
    @Namespace private var glassNamespace
    @State private var isExpanded = false

    var body: some View {
        if #available(iOS 26.0, *) {
            if isExpanded {
                ExpandedCard()
                    .glassEffectID("card", in: glassNamespace)  // ✅ Same ID
            } else {
                CompactCard()
                    .glassEffectID("card", in: glassNamespace)  // ✅ Same ID
            }
        }
    }
}
```

**Why it matters:** SwiftUI's glass morphing system uses the ID to match source and destination views. When IDs match, the system creates a fluid morphing animation that distorts the glass shape/size between states. Different IDs cause the system to treat them as unrelated views, resulting in a cross-fade transition that breaks the glass material illusion.

Reference: [WWDC 2025 Session 323 - Build with Liquid Glass](https://developer.apple.com/videos/wwdc2025/)
