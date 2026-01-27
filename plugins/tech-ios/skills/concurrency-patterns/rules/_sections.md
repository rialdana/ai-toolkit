# Rule Sections

Rules are organized by section prefix in the following order:

## 1. Async/Await Fundamentals (`async-`)
**Impact:** HIGH
**Focus:** Core async/await patterns, error handling, parallel execution

## 2. Tasks & Structured Concurrency (`task-`)
**Impact:** HIGH
**Focus:** Task lifecycle, cancellation, structured concurrency patterns, task groups

## 3. Actors & Isolation (`actor-`)
**Impact:** CRITICAL
**Focus:** Actor isolation domains, suspension points, state safety, synchronization primitives

## 4. Sendable & Data Safety (`send-`)
**Impact:** CRITICAL
**Focus:** Sendable conformance, data races, safe captures, global state

## 5. Threading & Execution (`thread-`)
**Impact:** HIGH
**Focus:** Execution contexts, isolation domains, executor selection

## 6. Memory Management (`mem-`)
**Impact:** HIGH
**Focus:** Retain cycles, weak references, task lifecycle and cancellation

## 7. Testing Concurrency (`test-`)
**Impact:** MEDIUM
**Focus:** Async test patterns, serial executor, Swift Testing integration

## 8. Migration & Interop (`migrate-`)
**Impact:** MEDIUM
**Focus:** Strict concurrency migration, legacy interop, incremental adoption
