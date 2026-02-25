---
title: Always Check Permission State Before Using Protected APIs
impact: CRITICAL
tags: permissions, runtime, security
---

## Always Check Permission State Before Using Protected APIs

Never assume a permission is granted. Always verify permission status immediately before accessing protected APIs — permissions can be revoked at any time via Settings.

**Incorrect (assuming permission is granted):**

```kotlin
// Bad - no check before accessing location
class LocationRepository @Inject constructor(
    private val fusedLocationClient: FusedLocationProviderClient
) {
    suspend fun getCurrentLocation(): Location {
        // SecurityException if permission was revoked since last check!
        return fusedLocationClient.lastLocation.await()
    }
}

// Bad - checking once at startup, caching the result
class CameraViewModel : ViewModel() {
    var hasPermission = false  // Stale — user can revoke in Settings anytime

    fun init(context: Context) {
        hasPermission = ContextCompat.checkSelfPermission(
            context, Manifest.permission.CAMERA
        ) == PackageManager.PERMISSION_GRANTED
    }

    fun takePicture() {
        if (hasPermission) {  // May be stale!
            openCamera()
        }
    }
}
```

**Correct (check at point of use):**

```kotlin
// Good - check permission at the point of use
class LocationRepository @Inject constructor(
    private val fusedLocationClient: FusedLocationProviderClient,
    @ApplicationContext private val context: Context
) {
    suspend fun getCurrentLocation(): Result<Location> {
        if (ContextCompat.checkSelfPermission(
                context, Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return Result.failure(PermissionDeniedException("Location permission required"))
        }
        return runCatching { fusedLocationClient.lastLocation.await() }
    }
}

// Good - reactive permission state in Compose
@Composable
fun CameraScreen() {
    val context = LocalContext.current

    // Re-checked on every recomposition (e.g., returning from Settings)
    val hasPermission = remember {
        derivedStateOf {
            ContextCompat.checkSelfPermission(
                context, Manifest.permission.CAMERA
            ) == PackageManager.PERMISSION_GRANTED
        }
    }

    // Or use lifecycle observer to re-check on resume
    val lifecycleOwner = LocalLifecycleOwner.current
    var permissionGranted by remember { mutableStateOf(false) }

    DisposableEffect(lifecycleOwner) {
        val observer = LifecycleEventObserver { _, event ->
            if (event == Lifecycle.Event.ON_RESUME) {
                permissionGranted = ContextCompat.checkSelfPermission(
                    context, Manifest.permission.CAMERA
                ) == PackageManager.PERMISSION_GRANTED
            }
        }
        lifecycleOwner.lifecycle.addObserver(observer)
        onDispose { lifecycleOwner.lifecycle.removeObserver(observer) }
    }

    if (permissionGranted) {
        CameraPreview()
    } else {
        PermissionRequest()
    }
}

// Good - typed exception for permission failures
class PermissionDeniedException(
    val permission: String
) : Exception("Permission denied: $permission")
```

**Why it matters:**
- Users can revoke permissions at any time via Settings — cached checks go stale
- Accessing a protected API without permission throws `SecurityException` and crashes the app
- `ON_RESUME` is the right time to re-check — the user may return from Settings with changed permissions
- Defensive checks at the call site prevent crashes in repositories and services

Reference: [Check for permissions](https://developer.android.com/training/permissions/requesting#already-granted)
