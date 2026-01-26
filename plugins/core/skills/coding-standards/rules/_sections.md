# Sections

This file defines all sections, their ordering, impact levels, and descriptions.
The section ID (in parentheses) is the filename prefix used to group rules.

---

## 1. Core Principles (principle)

**Impact:** CRITICAL
**Description:** Foundational principles that guide all code decisions. KISS, DRY, Single Responsibility. Violating these creates compounding technical debt.

## 2. Naming & Style (naming)

**Impact:** HIGH
**Description:** Consistent naming improves readability and reduces cognitive load. Bad names force readers to decode intent repeatedly.

## 3. Functions & Modules (function)

**Impact:** HIGH
**Description:** Well-structured functions are the building blocks of maintainable code. Clear inputs, outputs, and minimal side effects.

## 4. Type Safety (type)

**Impact:** HIGH
**Description:** Strong typing catches errors at compile time rather than runtime. Never circumvent the type system.

## 5. Error Handling (error)

**Impact:** MEDIUM-HIGH
**Description:** Proper error handling prevents silent failures and improves debuggability.

## 6. Code Organization (org)

**Impact:** MEDIUM
**Description:** Logical organization makes code discoverable and reduces time spent navigating.

## 7. Performance Mindset (perf)

**Impact:** MEDIUM
**Description:** Write efficient code by default, but measure before optimizing. Premature optimization is the root of all evil.
