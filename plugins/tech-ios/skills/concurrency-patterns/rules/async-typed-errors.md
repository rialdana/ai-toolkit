---
title: Use Typed Errors for Precise API Contracts
impact: MEDIUM
tags: async-await, error-handling, swift-6
---

## Use Typed Errors for Precise API Contracts

Swift 6 supports typed throws to specify exact error types, making API contracts explicit and eliminating impossible error cases.

**Incorrect (generic Error):**

```swift
func fetchData() async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
}

// Caller doesn't know which errors to handle
do {
    let data = try await fetchData()
} catch {
    // What type is error? URLError? DecodingError? NetworkError?
}
```

**Correct (typed throws):**

```swift
enum NetworkError: Error {
    case invalidResponse
    case decodingFailed(DecodingError)
    case requestFailed(URLError)
}

func fetchData() async throws(NetworkError) -> Data {
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    } catch let error as URLError {
        throw .requestFailed(error)
    } catch {
        throw .invalidResponse
    }
}

// Caller knows exactly which errors to handle
do {
    let data = try await fetchData()
} catch .invalidResponse {
    // Handle invalid response
} catch .requestFailed(let urlError) {
    // Handle network error
}
```

**Why it matters:** Typed errors make API contracts explicit, enable exhaustive error handling, eliminate impossible catch cases, and improve code documentation. Callers know exactly which errors can occur without reading implementation details.

Reference: [Swift Evolution - Typed throws](https://github.com/apple/swift-evolution/blob/main/proposals/0413-typed-throws.md)
