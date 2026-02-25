---
title: Use Material Theme Tokens and Icons Correctly
impact: MEDIUM
tags: compose, theming, material, icons
---

## Use Material Theme Tokens and Icons Correctly

Reference `MaterialTheme` tokens for colors, typography, and shapes instead of hardcoding values. Use Material icon sets consistently and with proper imports.

**Incorrect (hardcoded styles, wrong icon usage):**

```kotlin
// Bad - hardcoded colors, ignores dark/light theme
@Composable
fun AppHeader(title: String) {
    Surface(color = Color(0xFF6200EE)) {  // Hardcoded purple
        Text(
            text = title,
            color = Color.White,               // Won't adapt to theme
            fontSize = 24.sp,                   // Hardcoded, not from typography
            fontWeight = FontWeight.Bold
        )
    }
}

// Bad - mixing icon sets, missing imports
@Composable
fun ActionBar() {
    // Uses filled and outlined inconsistently
    Icon(Icons.Default.Home, contentDescription = "Home")
    Icon(Icons.Outlined.Settings, contentDescription = "Settings")
    Icon(Icons.Rounded.Person, contentDescription = "Profile")
    // Three different icon styles in the same bar!
}

// Bad - custom color that doesn't respect theme
@Composable
fun ErrorBanner(message: String) {
    Box(
        modifier = Modifier
            .background(Color.Red)  // Clashes in dark theme
            .padding(16.dp)
    ) {
        Text(message, color = Color.White)
    }
}
```

**Correct (Material theme tokens and consistent icons):**

```kotlin
// Good - theme tokens adapt to light/dark/dynamic color
@Composable
fun AppHeader(title: String) {
    Surface(color = MaterialTheme.colorScheme.primary) {
        Text(
            text = title,
            color = MaterialTheme.colorScheme.onPrimary,
            style = MaterialTheme.typography.headlineSmall
        )
    }
}

// Good - consistent icon set throughout the app
@Composable
fun ActionBar() {
    // Pick ONE style: Default (Filled), Outlined, Rounded, Sharp, TwoTone
    Icon(Icons.Outlined.Home, contentDescription = "Home")
    Icon(Icons.Outlined.Settings, contentDescription = "Settings")
    Icon(Icons.Outlined.Person, contentDescription = "Profile")
}

// Good - semantic colors from the theme
@Composable
fun ErrorBanner(message: String) {
    Box(
        modifier = Modifier
            .background(MaterialTheme.colorScheme.errorContainer)
            .padding(16.dp)
    ) {
        Text(
            text = message,
            color = MaterialTheme.colorScheme.onErrorContainer
        )
    }
}

// Good - custom theme with overridable tokens
@Composable
fun AppTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    dynamicColor: Boolean = true,
    content: @Composable () -> Unit
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context)
            else dynamicLightColorScheme(context)
        }
        darkTheme -> darkColorScheme()
        else -> lightColorScheme()
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = AppTypography,
        shapes = AppShapes,
        content = content
    )
}
```

**Material 3 color role reference:**

| Role | Use for |
|------|---------|
| `primary` / `onPrimary` | Key actions, FAB, active states |
| `secondary` / `onSecondary` | Supporting elements, chips |
| `surface` / `onSurface` | Backgrounds, cards, text |
| `error` / `onError` | Error states, destructive actions |
| `errorContainer` / `onErrorContainer` | Error banners, validation messages |
| `outline` | Borders, dividers |

**Why it matters:**
- Hardcoded colors break dark theme, dynamic color, and high-contrast modes
- Mixed icon styles create visual inconsistency across the app
- Theme tokens are centrally updateable — one change propagates everywhere
- Dynamic color (Material You) only works when using `MaterialTheme` tokens

Reference: [Material Design 3 in Compose](https://developer.android.com/develop/ui/compose/designsystems/material3)
