# Sections

This file defines all sections, their ordering, impact levels, and descriptions.
The section ID (in parentheses) is the filename prefix used to group rules.

---

## 1. State Management (state)

**Impact:** HIGH
**Description:** Proper state management is foundational. Local state first, lift when needed, separate server state from client state.

## 2. Components (component)

**Impact:** HIGH
**Description:** Well-designed components are reusable, testable, and maintainable. Composition over configuration, clear props, minimal complexity.

## 3. Data Fetching (data)

**Impact:** MEDIUM
**Description:** Efficient data fetching improves UX and performance. Handle loading, error, and empty states. Cache appropriately.

## 4. Performance (perf)

**Impact:** MEDIUM
**Description:** Measure before optimizing. Avoid premature optimization but be aware of common pitfalls like unnecessary re-renders.

## 5. Organization (org)

**Impact:** MEDIUM
**Description:** Code organization affects maintainability. Feature-based organization, clear imports, colocation of related code.
