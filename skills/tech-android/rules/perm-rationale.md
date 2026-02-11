---
title: Show Rationale Before Requesting Permissions
impact: HIGH
tags: permissions, ux, rationale
---

## Show Rationale Before Requesting Permissions

Always check `shouldShowRequestPermissionRationale` and show an explanation before re-requesting a denied permission. Users are more likely to grant permissions when they understand why.

**Incorrect (requesting without rationale):**

```kotlin
// Bad - immediately requests again after denial, no explanation
@Composable
fun MicrophoneButton(onRecord: () -> Unit) {
    val launcher = rememberLauncherForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { granted ->
        if (granted) onRecord()
        // Denied? Nothing happens, user is confused
    }

    Button(onClick = {
        // Fires system dialog every time — user sees "deny" repeatedly
        launcher.launch(Manifest.permission.RECORD_AUDIO)
    }) {
        Text("Record")
    }
}
```

**Correct (rationale-aware permission flow):**

```kotlin
// Good - check status, show rationale, then request
@Composable
fun MicrophoneButton(onRecord: () -> Unit) {
    val context = LocalContext.current
    val activity = context.findActivity()
    var showRationale by remember { mutableStateOf(false) }

    val launcher = rememberLauncherForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { granted ->
        if (granted) onRecord()
    }

    Button(onClick = {
        when {
            ContextCompat.checkSelfPermission(
                context, Manifest.permission.RECORD_AUDIO
            ) == PackageManager.PERMISSION_GRANTED -> {
                onRecord()  // Already granted
            }
            activity.shouldShowRequestPermissionRationale(
                Manifest.permission.RECORD_AUDIO
            ) -> {
                showRationale = true  // Show explanation first
            }
            else -> {
                launcher.launch(Manifest.permission.RECORD_AUDIO)
            }
        }
    }) {
        Text("Record")
    }

    if (showRationale) {
        RationaleDialog(
            title = "Microphone Access Needed",
            message = "Voice recording requires microphone access to capture audio notes.",
            onConfirm = {
                showRationale = false
                launcher.launch(Manifest.permission.RECORD_AUDIO)
            },
            onDismiss = { showRationale = false }
        )
    }
}

@Composable
fun RationaleDialog(
    title: String,
    message: String,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(title) },
        text = { Text(message) },
        confirmButton = {
            TextButton(onClick = onConfirm) { Text("Continue") }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text("Not Now") }
        }
    )
}
```

**Permission flow decision tree:**

1. `checkSelfPermission` → GRANTED → proceed
2. `shouldShowRequestPermissionRationale` → true → show rationale dialog → request
3. Otherwise → request directly (first time or "don't ask again" was set)

**When "don't ask again" is selected:**
- `shouldShowRequestPermissionRationale` returns false
- System dialog won't appear — guide user to Settings instead

```kotlin
// Good - handle permanently denied
if (!granted && !activity.shouldShowRequestPermissionRationale(permission)) {
    // Guide to app settings
    SettingsPrompt(
        message = "Permission was permanently denied. Please enable it in Settings.",
        onOpenSettings = {
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.fromParts("package", context.packageName, null)
            }
            context.startActivity(intent)
        }
    )
}
```

**Why it matters:**
- Unexplained permission requests get denied — users distrust apps that don't explain
- After "deny", the system may not show the dialog again without rationale
- A clear rationale increases grant rates significantly
- Google Play policy requires permission justification for sensitive permissions

Reference: [Explain why your app needs the permission](https://developer.android.com/training/permissions/requesting#explain)
