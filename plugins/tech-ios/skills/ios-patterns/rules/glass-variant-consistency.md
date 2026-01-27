---
title: Never Mix Glass Variants in Same Container
impact: CRITICAL
tags: liquid-glass, variants, consistency, rendering
---

## Never Mix Glass Variants in Same Container

All glass elements within a single container must use the same variant (.regular, .clear, or .identity). Mixing variants causes rendering inconsistencies and visual discord.

**Incorrect:**

```swift
// ❌ WRONG: Mixing .regular and .clear variants
struct MediaControls: View {
    @Namespace private var glassNamespace

    var body: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer {
                PlayButton()
                    .glassEffectID("play", in: glassNamespace)
                    .glassEffect(.regular)  // Regular variant

                VolumeControl()
                    .glassEffectID("volume", in: glassNamespace)
                    .glassEffect(.clear)  // ❌ Different variant!
            }
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Consistent variant across container
struct MediaControls: View {
    @Namespace private var glassNamespace

    var body: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer {
                PlayButton()
                    .glassEffectID("play", in: glassNamespace)

                VolumeControl()
                    .glassEffectID("volume", in: glassNamespace)
            }
            .glassEffect(.clear)  // ✅ Single variant for entire container
        }
    }
}
```

**Why it matters:** Each variant has different optical properties (lensing strength, transparency, refraction). Mixing them creates visual inconsistency and breaks the unified material appearance that glass is designed to provide. Apply the variant to the container, not individual children.

Reference: [HIG - Liquid Glass Variants](https://developer.apple.com/design/human-interface-guidelines/liquid-glass#variants)
