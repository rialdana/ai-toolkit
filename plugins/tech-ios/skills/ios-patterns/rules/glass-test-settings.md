---
title: Test With All Accessibility Settings Enabled
impact: CRITICAL
tags: liquid-glass, accessibility, testing, reduce-motion, a11y
---

## Test With All Accessibility Settings Enabled

Always test glass UIs with Reduce Transparency, Increase Contrast, and Reduce Motion enabled. Glass must remain fully functional and readable in all accessibility modes.

**Incorrect:**

```swift
// ❌ WRONG: No accessibility testing, assuming defaults
struct MediaPlayer: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            VideoPlayer(player)
                .overlay(alignment: .bottom) {
                    Controls()
                        .glassEffect(.clear)
                    // ❌ Did you test with Reduce Transparency?
                    // Controls might be invisible!
                }
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Tested with all settings, ensured visibility
struct MediaPlayer: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            VideoPlayer(player)
                .overlay(alignment: .bottom) {
                    Controls()
                        .glassEffect(.clear)
                        .accessibilityLabel("Playback controls")
                    // ✅ Tested:
                    // - Reduce Transparency: Controls become opaque ✓
                    // - Increase Contrast: Solid background + border ✓
                    // - Reduce Motion: No morphing animations ✓
                    // - VoiceOver: All controls reachable ✓
                }
        }
    }
}
```

**Why it matters:** Approximately 20% of iOS users have at least one accessibility setting enabled. Glass with `.clear` variant can become nearly invisible with Reduce Transparency off. Morphing animations can cause motion sickness if not disabled with Reduce Motion. Failing to test creates barriers for millions of users and violates App Store accessibility requirements.

**Test checklist:**
1. Settings → Accessibility → Display → Reduce Transparency: ON
2. Settings → Accessibility → Display → Increase Contrast: ON
3. Settings → Accessibility → Motion → Reduce Motion: ON
4. Enable VoiceOver and verify all elements are reachable

Reference: [Testing for Accessibility](https://developer.apple.com/documentation/accessibility/testing-for-accessibility)
