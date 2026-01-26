---
title: Measure Before Optimizing
impact: MEDIUM
tags: performance, optimization, profiling
---

## Measure Before Optimizing

Don't optimize based on intuition. Profile first, identify actual bottlenecks, then optimize.

**Incorrect (premature optimization):**

```typescript
// "This might be slow, better memoize everything"
const MemoizedComponent = React.memo(SimpleText);
const memoizedValue = useMemo(() => a + b, [a, b]);
const memoizedCallback = useCallback(() => onClick(), [onClick]);

// "Object pooling will definitely help"
class ExpensiveObjectPool {
  // 100 lines of complexity for something that runs once
}
```

**Correct (measure, then optimize):**

```typescript
// 1. Write simple code first
function calculateStats(data: DataPoint[]) {
  return {
    mean: data.reduce((s, d) => s + d.value, 0) / data.length,
    max: Math.max(...data.map(d => d.value)),
  };
}

// 2. If slow, profile to find actual bottleneck
// Chrome DevTools → Performance tab
// Node.js: node --prof, clinic.js

// 3. Optimize only the measured bottleneck
function calculateStats(data: DataPoint[]) {
  let sum = 0;
  let max = -Infinity;
  for (const d of data) {
    sum += d.value;
    if (d.value > max) max = d.value;
  }
  return { mean: sum / data.length, max };
}
```

**Why it matters:** Intuition about performance is often wrong. Premature optimization adds complexity without measurable benefit, and can sometimes make performance worse.

Reference: "Premature optimization is the root of all evil" - Donald Knuth
