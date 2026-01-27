---
title: Use Isolated Parameters to Reduce Suspension Points
impact: HIGH
tags: actors, isolated, suspension-points, performance
---

## Use Isolated Parameters to Reduce Suspension Points

Isolated parameters let you inherit the caller's actor isolation, eliminating await suspension points for multiple actor method calls.

**Incorrect (multiple suspension points):**

```swift
struct Charger {
    static func charge(amount: Double, from account: BankAccount) async throws {
        let balance = await account.getBalance()  // Suspension 1
        guard balance >= amount else { throw InsufficientFunds() }

        try await account.withdraw(amount: amount)  // Suspension 2
        return await account.getBalance()  // Suspension 3
    }
}
```

**Correct (isolated parameter, no suspensions):**

```swift
struct Charger {
    static func charge(
        amount: Double,
        from account: isolated BankAccount
    ) throws -> Double {
        // No await needed - we're isolated to account
        let balance = account.getBalance()  // ✅ No suspension
        guard balance >= amount else { throw InsufficientFunds() }

        try account.withdraw(amount: amount)  // ✅ No suspension
        return account.getBalance()  // ✅ No suspension
    }
}
```

**Why it matters:** Each `await` is a suspension point where actor state can change due to reentrancy. Isolated parameters eliminate suspensions by running the entire function within the caller's actor isolation. This reduces reentrancy bugs, improves performance by avoiding thread hops, and enables atomic multi-step actor operations. Use isolated parameters for helper functions and transaction-like operations.

Reference: [SE-0313: Improved control over actor isolation](https://github.com/apple/swift-evolution/blob/main/proposals/0313-actor-isolation-control.md)
