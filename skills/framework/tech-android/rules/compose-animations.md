---
title: Use Compose Animation APIs Correctly
impact: MEDIUM
tags: compose, animation, transitions
---

## Use Compose Animation APIs Correctly

Choose the right animation API for the job. Prefer declarative `animate*AsState` for simple value changes, `AnimatedVisibility` for enter/exit, and `Animatable` for imperative control.

**Incorrect (manual animation, wrong API level):**

```kotlin
// Bad - manual frame loop instead of Compose animation
@Composable
fun PulsatingCircle() {
    var radius by remember { mutableStateOf(20f) }
    var growing by remember { mutableStateOf(true) }

    // Bad — manual timer, not composable-aware, janky
    LaunchedEffect(Unit) {
        while (true) {
            delay(16)  // ~60fps manually
            radius += if (growing) 0.5f else -0.5f
            if (radius > 40f) growing = false
            if (radius < 20f) growing = true
        }
    }

    Canvas(modifier = Modifier.size(80.dp)) {
        drawCircle(Color.Blue, radius)
    }
}

// Bad - AnimatedVisibility with no animation spec
@Composable
fun Toast(message: String?, onDismiss: () -> Unit) {
    if (message != null) {  // Pops in/out abruptly, no transition
        Text(message)
    }
}
```

**Correct (appropriate animation APIs):**

```kotlin
// Good - animate*AsState for simple value changes
@Composable
fun ExpandableCard(expanded: Boolean, content: @Composable () -> Unit) {
    val elevation by animateDpAsState(
        targetValue = if (expanded) 8.dp else 2.dp,
        animationSpec = tween(durationMillis = 300),
        label = "cardElevation"
    )
    Card(elevation = CardDefaults.cardElevation(defaultElevation = elevation)) {
        content()
    }
}

// Good - AnimatedVisibility for enter/exit transitions
@Composable
fun Toast(message: String?, onDismiss: () -> Unit) {
    AnimatedVisibility(
        visible = message != null,
        enter = fadeIn() + slideInVertically(),
        exit = fadeOut() + slideOutVertically()
    ) {
        message?.let {
            Surface(
                color = MaterialTheme.colorScheme.inverseSurface,
                shape = RoundedCornerShape(8.dp)
            ) {
                Text(it, modifier = Modifier.padding(16.dp))
            }
        }
    }
}

// Good - InfiniteTransition for looping animations
@Composable
fun PulsatingCircle() {
    val infiniteTransition = rememberInfiniteTransition(label = "pulse")
    val radius by infiniteTransition.animateFloat(
        initialValue = 20f,
        targetValue = 40f,
        animationSpec = infiniteRepeatable(
            animation = tween(1000, easing = EaseInOut),
            repeatMode = RepeatMode.Reverse
        ),
        label = "radius"
    )

    Canvas(modifier = Modifier.size(80.dp)) {
        drawCircle(Color.Blue, radius)
    }
}

// Good - Animatable for imperative, coroutine-driven control
@Composable
fun ShakeOnError(isError: Boolean, content: @Composable () -> Unit) {
    val offsetX = remember { Animatable(0f) }

    LaunchedEffect(isError) {
        if (isError) {
            offsetX.animateTo(10f, spring(dampingRatio = 0.3f, stiffness = 600f))
            offsetX.animateTo(0f)
        }
    }

    Box(modifier = Modifier.offset(x = offsetX.value.dp)) {
        content()
    }
}

// Good - animateContentSize for layout changes
@Composable
fun ExpandableText(text: String) {
    var expanded by remember { mutableStateOf(false) }
    Text(
        text = text,
        maxLines = if (expanded) Int.MAX_VALUE else 3,
        overflow = TextOverflow.Ellipsis,
        modifier = Modifier
            .animateContentSize()
            .clickable { expanded = !expanded }
    )
}
```

**Animation API decision guide:**

| Scenario | API |
|----------|-----|
| Animate a single value (color, size, offset) | `animate*AsState` |
| Show/hide with enter/exit | `AnimatedVisibility` |
| Switch between composables | `AnimatedContent` / `Crossfade` |
| Looping animation | `rememberInfiniteTransition` |
| Imperative control, sequences | `Animatable` |
| Layout size change | `Modifier.animateContentSize()` |
| Lazy list item add/remove | `Modifier.animateItem()` |

**Why it matters:**
- Manual frame loops bypass Compose's render pipeline and cause jank
- Compose animations are interruptible — new target values transition smoothly mid-animation
- `label` parameter enables animation inspection in Layout Inspector
- Wrong API choice leads to unnecessarily complex code or poor performance

Reference: [Animation in Compose](https://developer.android.com/develop/ui/compose/animation/introduction)
