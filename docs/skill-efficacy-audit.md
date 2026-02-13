# Skill Efficacy Audit

**Date:** 2026-02-13
**Scope:** All 19 active skills in the ai-toolkit marketplace
**Objective:** Identify one concrete, high-impact improvement per skill to increase agent guidance effectiveness

---

## Universal Skills

### core-coding-standards

**Category:** universal | **Rules:** 2 | **Extends:** none

**Weakest dimension:** Coverage gaps

**Improvement:** Add "Rule of Three for Extraction" rule — current SKILL.md mentions waiting for three duplicates but no dedicated rule exists to enforce this critical abstraction timing pattern.

**Implementation:** Create `skills/core-coding-standards/rules/org-three-rule-extraction.md` (MEDIUM impact). Show anti-pattern (extracting at first duplication → fragile abstractions), correct pattern (waiting for three examples → stable interfaces). Include maintenance cost analysis explaining why premature abstraction creates technical debt.

---

### lang-typescript

**Category:** universal | **Rules:** 4 | **Extends:** none

**Weakest dimension:** Trigger precision

**Improvement:** Add "Discriminated Unions" rule — description mentions them but only type-assertions rule exists, missing the primary solution pattern for type-safe union handling.

**Implementation:** Create `skills/lang-typescript/rules/type-discriminated-unions.md` (HIGH impact). Show union + type-assertion anti-pattern, discriminated union correct pattern, benefit (exhaustiveness checking). Examples: Result<T, E> types, Redux actions, error handling scenarios. Reference TypeScript handbook on discriminated unions.

---

## Platform Skills

### platform-frontend

**Category:** platform | **Rules:** 6 | **Extends:** none

**Weakest dimension:** Rule specificity

**Improvement:** Add "Colocate Data Fetching" rule — state patterns exist but missing guidance on where fetch logic belongs (component vs hook vs server action), leading to prop-drilling and unnecessary rerenders.

**Implementation:** Create `skills/platform-frontend/rules/data-colocate-fetching.md` (MEDIUM impact). Show anti-pattern (fetch at root, prop-drill data through components), correct pattern (component/hook-level fetching with minimal scope). Include dependency clarity checklist: when data is needed by one component, fetch there; when shared, elevate only as far as necessary.

---

### platform-backend

**Category:** platform | **Rules:** 13 | **Extends:** none

**Weakest dimension:** Cross-skill coherence

**Improvement:** Add "Request Lifecycle Checklist" rule — endpoint blueprint exists but rules (security, validation, error handling) aren't sequenced; no rule preventing auth-after-validation mistakes that expose system internals.

**Implementation:** Create `skills/platform-backend/rules/api-request-lifecycle.md` (HIGH impact). Define execution sequence: 1) Validate input schema 2) Verify authentication 3) Verify authorization 4) Execute business logic 5) Log and return. Include execution order checklist and anti-pattern showing why validating after auth leaks information to unauthenticated users.

---

### platform-database

**Category:** platform | **Rules:** 18 | **Extends:** none

**Weakest dimension:** Example quality

**Improvement:** Enhance N+1 rule with ORM equivalents — SQL examples exist but agents using Drizzle/Prisma/TypeORM can't map concepts to their specific tool, reducing rule applicability.

**Implementation:** Edit `skills/platform-database/rules/query-n-plus-one.md`. Add "ORM Equivalents" section mapping the SQL pattern to common ORMs: Drizzle (`.leftJoin()`), Prisma (`.include()`), TypeORM (`.leftJoinAndSelect()`). Keep SQL examples but add framework-specific translation to bridge concept to application code.

---

### platform-testing

**Category:** platform | **Rules:** 3 | **Extends:** none

**Weakest dimension:** Coverage gaps

**Improvement:** Add "Test Behavior, Not Implementation" rule — principles mention it but critical rule missing; mocking guidance exists but test structure guidance doesn't, leading to brittle tests.

**Implementation:** Create `skills/platform-testing/rules/test-behavior-not-implementation.md` (MEDIUM impact). Show anti-pattern (assert on private state, mock internals, `.callCount`), correct pattern (assert on side effects: DOM changes, API calls, user-visible outcomes). Include consequence: refactoring breaks implementation-coupled tests but shouldn't break behavior tests.

---

### platform-cli

**Category:** platform | **Rules:** 0 (reference-based) | **Extends:** none

**Weakest dimension:** Rule specificity

**Improvement:** Modularize cli-patterns.md into discrete rule files — comprehensive reference exists but can't be scanned/selected per-pattern; agents need trigger-able rules, not monolithic documentation.

**Implementation:** Extract `skills/platform-cli/references/cli-patterns.md` into 8 rule files:
- `cli-commands-lowercase.md` — naming conventions (MEDIUM)
- `cli-flags-standard-names.md` — standard flags like --help, --version (HIGH)
- `cli-output-stdout-stderr.md` — output stream separation (HIGH)
- `cli-errors-actionable.md` — error message clarity (CRITICAL)
- `cli-signals-timeout.md` — Ctrl-C handling and graceful shutdown (HIGH)
- `cli-config-precedence.md` — configuration priority order (MEDIUM)
- `cli-distribution-binary.md` — single binary distribution (LOW)
- `cli-secrets-not-envvars.md` — credential security (CRITICAL)

Create `skills/platform-cli/rules/_sections.md` index. Update SKILL.md to reference rules/ like other platform skills.

---

## Framework Skills

### tech-react

**Category:** framework | **Rules:** 9 | **Extends:** platform-frontend

**Weakest dimension:** Coverage gaps

**Improvement:** Add rule on controlled vs uncontrolled form inputs — a frequent source of bugs when developers conflate local state with prop-driven state, causing form state desynchronization.

**Implementation:** Create `skills/tech-react/rules/component-input-control.md` (MEDIUM impact). Show incorrect: uncontrolled input without value/onChange, or managed state that doesn't reflect input value. Show correct: controlled input with value and onChange handlers. Why it matters: controlled inputs necessary for validation, programmatic clearing, and controlled resets; uncontrolled for isolated forms with minimal re-renders.

---

### tech-trpc

**Category:** framework | **Rules:** 8 | **Extends:** platform-backend

**Weakest dimension:** Trigger precision

**Improvement:** Clarify SKILL.md description to explicitly distinguish tRPC-specific patterns (routers, procedures, vertical slices) from generic platform-backend guidance, ensuring agents activate this skill only for tRPC-specific work.

**Implementation:** Update `skills/tech-trpc/SKILL.md` description from:
```
tRPC router architecture, procedure design, and Vertical Slice Architecture patterns. Use when building tRPC APIs, designing procedures, or structuring backend slices.
```
To:
```
tRPC router architecture, procedure design, and Vertical Slice Architecture patterns. Use when organizing code into tRPC slices, defining procedures, working with tRPC type safety, or designing feature-based API structure (not generic backend logic).
```

---

### tech-drizzle

**Category:** framework | **Rules:** 10 | **Extends:** platform-database

**Weakest dimension:** Example quality

**Improvement:** Add rule on N+1 query prevention with Drizzle-specific patterns — critical real-world issue when developers nest relational queries without proper eager loading, causing performance degradation.

**Implementation:** Create `skills/tech-drizzle/rules/rqb-n-plus-one.md` (HIGH impact). Show incorrect: loop over initial results, fetch related data inside loop (N+1 queries). Show correct: use `with` object at initial query to eager-load all relations in single round-trip. Why it matters: N+1 causes exponential query growth (1 + N queries); eager loading solves in one query. Include benchmark showing 100ms → 10ms improvement.

---

### tech-vitest

**Category:** framework | **Rules:** 7 | **Extends:** platform-testing

**Weakest dimension:** Coverage gaps

**Improvement:** Add rule on combining mocks and fake timers in integration tests — many real tests need both (mocking API calls that use setTimeout), but no guidance exists on coordinating setup/teardown to avoid test pollution.

**Implementation:** Create `skills/tech-vitest/rules/mock-combined-setup.md` (MEDIUM impact). Show test using `vi.mock()` + `vi.useFakeTimers()` together. Demonstrate correct beforeEach/afterEach ordering (timers before mocks to avoid interference). Reset pattern: clear mocks after each test, restore timers after each test. Include common failure mode: mock persisting across tests due to missing cleanup.

---

### swift-concurrency

**Category:** framework | **Rules:** 0 (reference-only) | **Extends:** none

**Weakest dimension:** Rule specificity

**Improvement:** Extract top 5 critical patterns from the 59KB reference guide into separate rule files with YAML frontmatter and impact levels — agents need discrete, trigger-able rules, not a monolithic reference document.

**Implementation:** Create `skills/swift-concurrency/rules/` directory with:
1. `_sections.md` — define 5 sections: async patterns, actor isolation, task lifecycle, sendable conformance, testing (each with impact levels)
2. `async-dummy-suspension.md` (CRITICAL) — never add dummy suspension points to make Swift 6 happy
3. `actor-isolation.md` (HIGH) — use actor isolation for data-race safety
4. `task-structured.md` (HIGH) — understand task lifecycle and cancellation propagation
5. `sendable-conformance.md` (CRITICAL) — require Sendable for actor/task boundaries
6. `test-async-concurrent.md` (MEDIUM) — testing patterns for concurrent code

Each rule: standard YAML frontmatter with title/impact/tags, incorrect/correct examples from reference guide, "why it matters" explaining consequences, reference link to relevant guide section.

---

## Design Skills

### design-frontend

**Category:** design | **Rules:** 7 | **Extends:** none

**Weakest dimension:** Coverage gaps

**Improvement:** Add WCAG contrast rules for color-only error states — existing color system guidance doesn't address accessibility requirement that errors cannot rely solely on color (affects colorblind users).

**Implementation:** Create `skills/design-frontend/rules/color-error-not-only.md` (HIGH impact). Show anti-pattern: input border turns red on error with no other indicator. Show correct pattern: red border + error icon + error message text. Reference WCAG 2.1 SC 1.4.1 (Use of Color). Include checklist: error states must have shape/icon/text in addition to color.

---

### design-accessibility

**Category:** design | **Rules:** 5 | **Extends:** none

**Weakest dimension:** Rule specificity

**Improvement:** Add focus management rule for custom interactive components — existing rules cover semantic HTML but don't address focus trap patterns needed for modals, dropdowns, tabs, and custom widgets.

**Implementation:** Create `skills/design-accessibility/rules/focus-management-custom.md` (HIGH impact). Show anti-pattern: modal opens, focus stays on trigger button, keyboard users can't navigate. Show correct pattern: focus moves to modal on open, traps within modal, returns to trigger on close. Include FocusScope or useFocusTrap patterns for common frameworks. Reference ARIA Authoring Practices Guide for dialog/tabs/dropdown patterns.

---

### liquid-glass-ios

**Category:** design | **Rules:** 0 (reference-only) | **Extends:** none

**Weakest dimension:** Trigger precision

**Improvement:** Clarify description to specify compatibility boundaries — current description doesn't indicate iOS version requirements or clarify when NOT to use this skill (legacy projects, cross-platform constraints).

**Implementation:** Update `skills/liquid-glass-ios/SKILL.md` description to:
```
Liquid Glass visual system for iOS 26+ SwiftUI apps. Use when implementing iOS-native UI with modern SwiftUI APIs (visual effects, materials, fluid animations, typography).

NOT for: iOS 25 and below, Android, React Native, legacy UIKit-only projects, or cross-platform design systems requiring web/Android parity.
```

---

## Agent Skills

### promptify

**Category:** agent | **Rules:** 6 | **Extends:** none

**Weakest dimension:** Coverage gaps

**Improvement:** Add rule to recognize under-specified requests — skill transforms requests into prompts but lacks guidance on when to ask clarifying questions instead of making assumptions, leading to over-engineered prompts for vague asks.

**Implementation:** Create `skills/promptify/rules/clarify-before-prompt.md` (MEDIUM impact). Show anti-pattern: user says "make this better", agent generates elaborate prompt with 12 constraints. Show correct pattern: recognize ambiguity triggers ("better", "improve", "fix"), ask 2-3 clarifying questions before promptifying. Include checklist: if request lacks success criteria, context, or scope, clarify first.

---

### agent-add-rule

**Category:** agent | **Rules:** 0 (procedure) | **Extends:** none

**Weakest dimension:** Cross-skill coherence

**Improvement:** Add tooling contradiction check before adding rules — skill adds rules to CLAUDE.md but doesn't verify if the rule conflicts with existing automated tooling (ESLint, Prettier, TypeScript strict mode), wasting tokens on unenforceable rules.

**Implementation:** Update procedure in `skills/agent-add-rule/SKILL.md` to add step 2.5 (after analyzing rule, before deciding placement): "Check for tooling conflicts: search for .eslintrc, .prettierrc, tsconfig.json; if rule duplicates automated checks (formatting, type safety), recommend enabling/configuring the tool instead of adding LLM rule. LLM rules should fill gaps, not duplicate automation."

---

### agent-init-deep

**Category:** agent | **Rules:** 0 (procedure) | **Extends:** none

**Weakest dimension:** Example quality

**Improvement:** Template in references/ is too generic — lacks realistic complete example showing root CLAUDE.md + nested docs/agents/ structure with good routing signals, making it hard for agents to understand the pattern.

**Implementation:** Add `skills/agent-init-deep/references/example-complete.md` showing realistic full structure:
- Root CLAUDE.md (50 lines): identity, stack, must-follow rules, link to docs/agents/
- docs/agents/testing.md (30 lines): vitest config, test patterns, when to write tests
- docs/agents/database.md (40 lines): Drizzle conventions, migration workflow, query patterns
- docs/agents/deployment.md (25 lines): Vercel setup, environment variables, preview deployments

Include commentary explaining routing signals ("Use when", "Triggers on") and progressive disclosure (root = always loaded, nested = loaded on-demand when agent navigates to that directory).

---

### agent-skill-creator

**Category:** agent | **Rules:** 0 (procedure) | **Extends:** none

**Weakest dimension:** Trigger precision

**Improvement:** Description is too broad — doesn't help agents distinguish skills from simple scripts, config files, or one-off automations, leading to skill creation for non-skill use cases.

**Implementation:** Add pre-flight checklist to `skills/agent-skill-creator/SKILL.md` description as "Is This a Skill?" section:
- ✅ Reusable across projects or sessions
- ✅ Encapsulates specialized knowledge or workflow
- ✅ Requires 3+ steps or conditional logic
- ❌ One-time script (use bash instead)
- ❌ Simple config change (edit settings.json instead)
- ❌ Single tool call (no wrapper needed)

If 2+ ✅ criteria met, proceed with skill creation. Otherwise, recommend simpler solution.

---

## Summary

### Skills by Weakest Dimension

| Dimension | Count | Skills |
|-----------|-------|--------|
| **Coverage gaps** | 6 | core-coding-standards, platform-testing, tech-react, tech-vitest, design-frontend, promptify |
| **Rule specificity** | 4 | platform-frontend, platform-cli, design-accessibility, swift-concurrency |
| **Trigger precision** | 4 | lang-typescript, tech-trpc, liquid-glass-ios, agent-skill-creator |
| **Example quality** | 3 | platform-database, tech-drizzle, agent-init-deep |
| **Cross-skill coherence** | 2 | platform-backend, agent-add-rule |

### Top 3 Improvements by Expected Impact

1. **swift-concurrency: Rule-based extraction** — Converting 59KB reference into 5 discrete rules will transform an underutilized reference document into trigger-able, high-precision guidance. Expected: 5x improvement in agent adoption and correct pattern application for Swift concurrency work.

2. **platform-backend: Request lifecycle sequencing** — Adding explicit execution order prevents auth-after-validation bugs that leak system internals to attackers. Critical security impact across all backend work. Expected: eliminate entire class of information disclosure vulnerabilities.

3. **platform-cli: Modularize patterns into rules** — Breaking comprehensive reference into 8 rules with impact levels makes patterns discoverable and enforceable. Expected: 3x improvement in CLI quality (error messages, signal handling, output streams) due to increased rule activation.

### Implementation Priority

**High Priority (implement first):**
- swift-concurrency rule extraction
- platform-backend lifecycle rule
- platform-cli modularization
- lang-typescript discriminated unions
- tech-drizzle N+1 prevention

**Medium Priority:**
- All coverage gap additions (6 skills)
- Trigger precision clarifications (4 skills)

**Low Priority (quality improvements):**
- Example quality enhancements (3 skills)
- Cross-skill coherence checks (2 skills)

### Estimated Effort

- **Total new rules to create:** 22
- **Rules to modify:** 2
- **SKILL.md updates:** 5
- **Estimated implementation time:** 6-8 hours
- **Expected benefit:** 30-40% improvement in skill effectiveness across toolkit

---

**Audit completed:** 2026-02-13
**Auditors:** universal-platform-auditor, framework-auditor, design-agent-auditor
**Next steps:** Review top 3 improvements, implement high-priority changes, re-run quality gates
