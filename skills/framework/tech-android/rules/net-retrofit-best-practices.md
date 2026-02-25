---
title: Configure Retrofit with Proper Error Handling and Cancellation
impact: HIGH
tags: networking, retrofit, error-handling
---

## Configure Retrofit with Proper Error Handling and Cancellation

Retrofit calls should use `suspend` functions, handle errors with `Result` or sealed types, and leverage OkHttp interceptors for cross-cutting concerns.

**Incorrect (blocking calls, no error handling):**

```kotlin
// Bad - not suspend, blocks the calling thread
interface UserApi {
    @GET("users/{id}")
    fun getUser(@Path("id") id: String): Call<UserDto>  // Blocking Call
}

// Bad - raw try-catch with no structured error type
class UserRepository(private val api: UserApi) {
    suspend fun getUser(id: String): UserDto? {
        return try {
            api.getUser(id).execute().body()  // Blocks! No cancellation!
        } catch (e: Exception) {
            null  // Swallows all errors — network? 404? Parse failure?
        }
    }
}
```

**Correct (suspend, structured errors, interceptors):**

```kotlin
// Good - suspend functions with Response wrapper
interface UserApi {
    @GET("users/{id}")
    suspend fun getUser(@Path("id") id: String): UserDto

    @GET("users")
    suspend fun getUsers(@Query("page") page: Int): List<UserDto>
}

// Good - repository with structured error handling
class UserRepository(private val api: UserApi) {
    suspend fun getUser(id: String): Result<User> {
        return runCatching { api.getUser(id).toDomain() }
    }
}

// Good - OkHttp interceptor for auth and logging
val okHttpClient = OkHttpClient.Builder()
    .addInterceptor(AuthInterceptor(tokenProvider))
    .addInterceptor(HttpLoggingInterceptor().apply {
        level = if (BuildConfig.DEBUG)
            HttpLoggingInterceptor.Level.BODY
        else
            HttpLoggingInterceptor.Level.NONE
    })
    .connectTimeout(30, TimeUnit.SECONDS)
    .readTimeout(30, TimeUnit.SECONDS)
    .build()

val retrofit = Retrofit.Builder()
    .baseUrl("https://api.example.com/")
    .client(okHttpClient)
    .addConverterFactory(Json.asConverterFactory("application/json".toMediaType()))
    .build()
```

**Why it matters:**
- `Call<T>` blocks threads and doesn't support coroutine cancellation
- Swallowing exceptions hides network, auth, and parsing failures
- Interceptors centralize auth, logging, and retry logic
- `suspend` functions integrate with `viewModelScope` cancellation

Reference: [Retrofit](https://square.github.io/retrofit/)
