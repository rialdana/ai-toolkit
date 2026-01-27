---
title: Complete State Changes Before Suspension Points
impact: CRITICAL
tags: actors, reentrancy, state-safety
---

## Complete State Changes Before Suspension Points

Actors release their lock at `await` suspension points, allowing other tasks to interleave. State can change between suspension points within the same method.

**Incorrect (state changes after suspension):**

```swift
actor BankAccount {
    var balance: Double

    func deposit(amount: Double) async {
        balance += amount

        // ⚠️ Actor unlocked during await - balance may change!
        await logActivity("Deposited \(amount)")

        // ⚠️ Balance may be different now
        print("Balance: \(balance)")
    }
}

// Parallel deposits may all print same balance:
async let _ = account.deposit(50)
async let _ = account.deposit(50)
async let _ = account.deposit(50)
// Balance: 150
// Balance: 150
// Balance: 150
```

**Correct (complete state work before suspension):**

```swift
actor BankAccount {
    var balance: Double

    func deposit(amount: Double) async {
        balance += amount
        let newBalance = balance  // Capture state BEFORE suspension

        await logActivity("Deposited \(amount)")

        // Use captured value, not mutable state
        print("Balance: \(newBalance)")
    }
}
```

**Why it matters:** Actor reentrancy is a common source of subtle bugs. Assuming state is unchanged after `await` leads to race conditions, incorrect calculations, and data corruption. All critical state changes must complete before the first suspension point in an actor method.

Reference: [SE-0306: Actors](https://github.com/apple/swift-evolution/blob/main/proposals/0306-actors.md)
