---
title: Keep It Simple (KISS)
impact: CRITICAL
tags: principles, simplicity, design
---

## Keep It Simple (KISS)

Prefer simple solutions over clever ones. The best code is code you don't have to write. Don't over-engineer.

**Incorrect (over-engineered):**

```typescript
// Abstract factory for something used once
class UserValidatorFactory {
  createValidator(type: string): Validator {
    switch (type) {
      case 'email': return new EmailValidator();
      case 'phone': return new PhoneValidator();
      default: return new DefaultValidator();
    }
  }
}

const validator = new UserValidatorFactory().createValidator('email');
validator.validate(input);
```

**Correct (simple and direct):**

```typescript
function validateEmail(email: string): boolean {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

const isValid = validateEmail(input);
```

**Why it matters:** Over-engineered code is harder to understand, modify, and debug. It increases cognitive load and maintenance burden without providing proportional value.
