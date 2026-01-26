---
title: Don't Chase 100% Coverage
impact: LOW
tags: coverage, priorities, pragmatism
---

## Don't Chase 100% Coverage

Coverage is a tool to find untested code, not a goal in itself. Diminishing returns kick in around 70-80%.

**Incorrect (coverage-driven testing):**

```typescript
// Bad - testing trivial code just for coverage
test('User constructor sets name', () => {
  const user = new User({ name: 'Test' });
  expect(user.name).toBe('Test');
});

test('formatDate returns formatted string', () => {
  expect(formatDate(new Date('2024-01-01'))).toBe('Jan 1, 2024');
});

// These add coverage but minimal confidence
```

**Correct (risk-driven testing):**

```typescript
// Good - test risky, complex, or critical code

// Payment calculations - high risk
test('calculates pro-rated refund correctly', () => { ... });
test('handles currency conversion edge cases', () => { ... });

// Permission checks - critical security
test('non-admins cannot delete organizations', () => { ... });
test('users can only access their own data', () => { ... });

// Complex logic - easy to get wrong
test('scheduling handles timezone changes', () => { ... });
test('conflict detection finds overlapping events', () => { ... });
```

**Use coverage to find gaps:**

```bash
# Generate coverage report
npm run test -- --coverage

# Review uncovered lines in critical files:
# - payment processing
# - authentication
# - data validation
```

**Coverage targets:**

| Type | Realistic Target |
|------|------------------|
| Critical paths | 90%+ |
| Business logic | 80%+ |
| Overall codebase | 70%+ |
| UI components | 50%+ |

**Why it matters:**
- Time spent on low-value tests is time not spent on high-value tests
- 100% coverage is expensive to maintain
- Coverage doesn't measure test quality
- False sense of security from high numbers
