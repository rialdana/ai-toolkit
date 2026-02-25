---
title: Request Permissions with the Activity Result API
impact: HIGH
tags: permissions, compose, activity-result
---

## Request Permissions with the Activity Result API

Use `rememberLauncherForActivityResult` in Compose (or `registerForActivityResult` in Activities) to request runtime permissions. Never use the deprecated `requestPermissions()` / `onRequestPermissionsResult()` pattern.

**Incorrect (deprecated permission flow):**

```kotlin
// Bad - deprecated API, manual request code, error-prone
class CameraActivity : ComponentActivity() {
    private val REQUEST_CAMERA = 100

    fun takePicture() {
        // Deprecated since API 30
        requestPermissions(arrayOf(Manifest.permission.CAMERA), REQUEST_CAMERA)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        if (requestCode == REQUEST_CAMERA && grantResults[0] == PERMISSION_GRANTED) {
            openCamera()
        }
        // Easy to forget else branch, no rationale handling
    }
}
```

**Correct (Activity Result API in Compose):**

```kotlin
// Good - single permission in Compose
@Composable
fun CameraScreen() {
    val context = LocalContext.current
    var hasCameraPermission by remember {
        mutableStateOf(
            ContextCompat.checkSelfPermission(
                context, Manifest.permission.CAMERA
            ) == PackageManager.PERMISSION_GRANTED
        )
    }

    val permissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestPermission()
    ) { granted ->
        hasCameraPermission = granted
    }

    if (hasCameraPermission) {
        CameraPreview()
    } else {
        PermissionRequest(
            onRequestPermission = {
                permissionLauncher.launch(Manifest.permission.CAMERA)
            }
        )
    }
}

// Good - multiple permissions
@Composable
fun LocationScreen() {
    val permissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestMultiplePermissions()
    ) { permissions ->
        val fineGranted = permissions[Manifest.permission.ACCESS_FINE_LOCATION] ?: false
        val coarseGranted = permissions[Manifest.permission.ACCESS_COARSE_LOCATION] ?: false
        // Handle result
    }

    Button(onClick = {
        permissionLauncher.launch(
            arrayOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION
            )
        )
    }) {
        Text("Enable Location")
    }
}

// Good - using Accompanist permissions library for cleaner Compose API
@OptIn(ExperimentalPermissionsApi::class)
@Composable
fun CameraScreenWithAccompanist() {
    val cameraPermissionState = rememberPermissionState(Manifest.permission.CAMERA)

    when {
        cameraPermissionState.status.isGranted -> CameraPreview()
        cameraPermissionState.status.shouldShowRationale -> {
            RationaleDialog(onConfirm = { cameraPermissionState.launchPermissionRequest() })
        }
        else -> {
            Button(onClick = { cameraPermissionState.launchPermissionRequest() }) {
                Text("Grant Camera Permission")
            }
        }
    }
}
```

**Why it matters:**
- `requestPermissions()` / `onRequestPermissionsResult()` is deprecated and fragile
- Activity Result API is lifecycle-safe and handles configuration changes
- `rememberLauncherForActivityResult` integrates naturally with Compose state
- Accompanist wraps permission state as reactive Compose state

Reference: [Request runtime permissions](https://developer.android.com/training/permissions/requesting)
