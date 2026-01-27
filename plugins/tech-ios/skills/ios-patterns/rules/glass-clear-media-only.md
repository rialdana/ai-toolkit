---
title: Use .clear Variant Only Over Rich Media Content
impact: HIGH
tags: liquid-glass, variants, clear, media, video
---

## Use .clear Variant Only Over Rich Media Content

The `.clear` variant is designed exclusively for controls that overlay rich media content (video, photos, immersive experiences). Never use it for standard UI elements.

**Incorrect:**

```swift
// ❌ WRONG: .clear on standard UI with text background
struct SettingsView: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            List {
                Section("Preferences") {
                    // List content
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Done") {}
                        .glassEffect(.clear)  // ❌ No media background
                }
            }
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: .clear only over video/media
struct VideoPlayerView: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            VideoPlayer(player: player)
                .overlay(alignment: .bottom) {
                    PlaybackControls()
                        .glassEffect(.clear)  // ✅ Over video content
                }
        }
    }
}
```

**Why it matters:** The `.clear` variant has minimal optical distortion optimized for media-rich backgrounds where visual content needs to show through. On standard UI backgrounds (solid colors, subtle gradients), it reduces contrast to the point of illegibility and provides poor separation from content.

Reference: [HIG - Glass Variant Use Cases](https://developer.apple.com/design/human-interface-guidelines/liquid-glass#use-cases)
