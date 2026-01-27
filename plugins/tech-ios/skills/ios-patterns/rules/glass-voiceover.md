---
title: Ensure VoiceOver Labels Work With Glass Elements
impact: CRITICAL
tags: liquid-glass, accessibility, voiceover, labels, a11y
---

## Ensure VoiceOver Labels Work With Glass Elements

Glass elements must have proper accessibility labels and hints. Visual glass effects don't automatically provide semantic meaning to screen readers.

**Incorrect:**

```swift
// ❌ WRONG: No accessibility labels
struct ToolBar: View {
    @Namespace private var glassNamespace

    var body: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer {
                Button {
                    share()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                    // ❌ VoiceOver reads: "Button"
                }
                .glassEffectID("share", in: glassNamespace)

                Button {
                    delete()
                } label: {
                    Image(systemName: "trash")
                    // ❌ VoiceOver reads: "Button"
                }
                .glassEffectID("delete", in: glassNamespace)
            }
            .glassEffect()
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Descriptive labels and hints
struct ToolBar: View {
    @Namespace private var glassNamespace

    var body: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer {
                Button {
                    share()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .glassEffectID("share", in: glassNamespace)
                .accessibilityLabel("Share")  // ✅ Clear label
                .accessibilityHint("Opens share sheet")

                Button {
                    delete()
                } label: {
                    Image(systemName: "trash")
                }
                .glassEffectID("delete", in: glassNamespace)
                .accessibilityLabel("Delete")  // ✅ Clear label
                .accessibilityHint("Deletes this item")
            }
            .glassEffect()
        }
    }
}
```

**Why it matters:** Glass is a visual effect that doesn't convey semantic information to screen readers. Without proper labels, VoiceOver users only hear "Button" with no context about what the button does. This makes the UI unusable for blind and low-vision users. All interactive glass elements must have descriptive labels and optional hints explaining their action.

Reference: [Accessibility Labels and Hints](https://developer.apple.com/documentation/swiftui/view/accessibilitylabel(_:)-4p4kv)
