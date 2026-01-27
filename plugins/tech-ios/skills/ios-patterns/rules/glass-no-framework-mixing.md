---
title: Don't Wrap UIKit Glass in SwiftUI or Vice Versa
impact: MEDIUM-HIGH
tags: liquid-glass, uikit, swiftui, interop, framework-mixing
---

## Don't Wrap UIKit Glass in SwiftUI or Vice Versa

Never wrap a UIKit glass view in SwiftUI's `UIViewRepresentable`, or apply SwiftUI `.glassEffect()` to a `UIViewControllerRepresentable`. Use native glass APIs for each framework.

**Incorrect:**

```swift
// ❌ WRONG: Wrapping UIKit glass in SwiftUI
struct GlassView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        if #available(iOS 26.0, *) {
            let glassEffect = UIGlassEffect()
            return UIVisualEffectView(effect: glassEffect)
        } else {
            return UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        }
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct ContentView: View {
    var body: some View {
        GlassView()
            .glassEffect()  // ❌ Double glass effect!
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Use native SwiftUI glass
struct ContentView: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            Text("Content")
                .glassEffect()  // ✅ Native SwiftUI glass
        }
    }
}

// ✅ CORRECT: Use native UIKit glass
class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 26.0, *) {
            let glassEffect = UIGlassEffect()
            let effectView = UIVisualEffectView(effect: glassEffect)
            // Add to view hierarchy
        }
    }
}
```

**Why it matters:** Wrapping framework-specific glass implementations creates double-layering (glass-on-glass), breaks automatic accessibility adaptation, and causes rendering artifacts. Each framework has optimized glass implementations that work with their respective rendering engines. Mixing them prevents proper optimization and breaks system behaviors.

Reference: [SwiftUI and UIKit Interoperability](https://developer.apple.com/documentation/swiftui/uikit-integration)
