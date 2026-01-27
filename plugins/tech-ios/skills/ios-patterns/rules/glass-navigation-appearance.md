---
title: Use configureWithGlassEffect() for UIKit Navigation Bars
impact: MEDIUM-HIGH
tags: liquid-glass, uikit, navigation-bar, appearance, integration
---

## Use configureWithGlassEffect() for UIKit Navigation Bars

For UIKit navigation bars, use the `configureWithGlassEffect()` method on `UINavigationBarAppearance` instead of manually applying glass views. This ensures correct system integration.

**Incorrect:**

```swift
// ❌ WRONG: Manually adding glass view to navigation bar
class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 26.0, *) {
            let glassEffect = UIGlassEffect()
            let effectView = UIVisualEffectView(effect: glassEffect)
            effectView.frame = navigationController?.navigationBar.bounds ?? .zero
            navigationController?.navigationBar.addSubview(effectView)
            // ❌ Breaks navigation bar layout, touch handling, and animations
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Use appearance API
class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 26.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithGlassEffect()  // ✅ System integration

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
```

**Why it matters:** `configureWithGlassEffect()` properly integrates glass with the navigation bar's layout system, touch handling, and scroll edge behaviors. Manually adding glass views breaks system animations, interferes with navigation bar buttons, and doesn't adapt to scroll position. The appearance API is the correct integration point.

Reference: [UINavigationBarAppearance Glass Configuration](https://developer.apple.com/documentation/uikit/uinavigationbarappearance/configurewithglasseffect)
