---
title: Only Tint Primary Actions, Keep Secondary Un-tinted
impact: MEDIUM
tags: liquid-glass, tinting, visual-hierarchy, primary-action
---

## Only Tint Primary Actions, Keep Secondary Un-tinted

Tinted glass should only be used for the primary call-to-action (CTA). Secondary actions and navigation elements should remain un-tinted to maintain visual hierarchy.

**Incorrect:**

```swift
// ❌ WRONG: Tinting multiple actions dilutes hierarchy
struct ActionSheet: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            VStack(spacing: 20) {
                Button("Continue") {}
                    .glassEffect(.regular.tint(.blue))

                Button("Skip") {}
                    .glassEffect(.regular.tint(.green))  // ❌ Secondary tinted

                Button("Cancel") {}
                    .glassEffect(.regular.tint(.red))  // ❌ Too much tint
            }
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Only primary action is tinted
struct ActionSheet: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            VStack(spacing: 20) {
                Button("Continue") {}
                    .glassEffect(.regular.tint(.blue))  // ✅ Primary only

                Button("Skip") {}
                    .glassEffect(.regular)  // ✅ Un-tinted secondary

                Button("Cancel") {}
                    .glassEffect(.regular)  // ✅ Un-tinted secondary
            }
        }
    }
}
```

**Why it matters:** Tinting creates visual emphasis through color. When multiple elements are tinted, the hierarchy becomes unclear and users can't identify the primary action. Un-tinted glass provides sufficient affordance for secondary actions while keeping focus on the primary CTA.

Reference: [HIG - Glass Effect Tinting](https://developer.apple.com/design/human-interface-guidelines/liquid-glass#tinting)
