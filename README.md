# Ravn AI Toolkit

A la carte Claude Code plugins for LLM-assisted development across platforms.

## Installation

```bash
# Add marketplace
claude /plugin install github:ravnhq/ai-toolkit

# Install specific plugins
claude /plugin install github:ravnhq/ai-toolkit/plugins/core
claude /plugin install github:ravnhq/ai-toolkit/plugins/tech-react
```

---

## Plugin Hierarchy

Plugins use a **layered architecture**: generic platform rules + specific framework rules. Install generic plugins first, then framework-specific ones.

| Layer | Generic | Specific |
|-------|---------|----------|
| Frontend | `platform-frontend` | `tech-react`, `tech-tanstack-router`, `tech-tanstack-form` |
| Backend | `platform-backend` | `tech-trpc` |
| Database | `platform-database` | `tech-drizzle`, `tech-prisma` |
| Mobile | `platform-mobile` | `tech-ios`, `tech-android`, `tech-react-native` |
| Testing | `platform-testing` | `tech-vitest`, `jest`, `xctest` |
| Design | `design` | `design-frontend`, `design-mobile` |

---

## Plugins

### Universal

| Plugin | Description | Rules | Status |
|--------|-------------|-------|--------|
| `core` | KISS, DRY, clean code, code review | 12 | **Ready** |
| `lang-typescript` | Strict mode, no any, discriminated unions | — | Scaffold |

### Platform Layers (Generic)

| Plugin | Extends | Description | Rules | Status |
|--------|---------|-------------|-------|--------|
| `platform-frontend` | — | State management, components, data fetching | 10 | **Ready** |
| `platform-backend` | — | API design, services, error handling | 14 | **Ready** |
| `platform-database` | — | Queries, migrations, performance | 16 | **Ready** |
| `platform-testing` | — | Test philosophy, structure, mocking | 10 | **Ready** |
| `platform-mobile` | — | Navigation, gestures, offline, performance | — | Scaffold |

### Frameworks (Web)

| Plugin | Extends | Description | Rules | Status |
|--------|---------|-------------|-------|--------|
| `tech-react` | `platform-frontend` | Components, hooks, state, performance | 8 | **Ready** |
| `tech-tanstack-router` | `platform-frontend` | File-based routing, loaders, type-safe nav | — | Scaffold |
| `tech-tanstack-form` | `platform-frontend` | Form state, validation, field arrays | — | Scaffold |
| `tech-trpc` | `platform-backend` | Procedures, routers, Vertical Slice Architecture | 8 | **Ready** |
| `tech-drizzle` | `platform-database` | Relational queries, schema, migrations | 9 | **Ready** |
| `tech-prisma` | `platform-database` | Schema, queries, relations, migrations | — | Scaffold |
| `tech-vitest` | `platform-testing` | vi.mock, vi.fn, fake timers | 6 | **Ready** |

### Frameworks (Mobile)

| Plugin | Extends | Description | Rules | Status |
|--------|---------|-------------|-------|--------|
| `tech-ios` | `platform-mobile` | Swift/SwiftUI, concurrency, App Store | — | Scaffold |
| `tech-android` | `platform-mobile` | Kotlin/Compose, architecture, Play Store | — | Scaffold |
| `tech-react-native` | `platform-mobile` | Expo, navigation, native modules | — | Scaffold |

### Design & UX

| Plugin | Extends | Description | Rules | Status |
|--------|---------|-------------|-------|--------|
| `design` | — | Hierarchy, spacing, color, typography | — | Scaffold |
| `design-frontend` | `design` | Layouts, responsive, Tailwind tokens | 7 | **Ready** |
| `design-mobile` | `design` | Touch targets, gestures, platform conventions | — | Scaffold |
| `design-accessibility` | — | WCAG AA, screen readers, keyboard nav | 9 | **Ready** |

**Status key:** Scaffold (sections defined) → In Progress → **Ready**

---

## Stack Recipes

| Project Type | Plugins |
|--------------|---------|
| React web app | `core`, `lang-typescript`, `platform-frontend`, `tech-react`, `design-accessibility` |
| TanStack Start + tRPC | `core`, `lang-typescript`, `platform-frontend`, `tech-react`, `tech-tanstack-router`, `tech-tanstack-form`, `tech-trpc`, `tech-drizzle` |
| Next.js + Prisma | `core`, `lang-typescript`, `platform-frontend`, `tech-react`, `tech-prisma` |
| iOS app | `core`, `platform-mobile`, `tech-ios`, `design-mobile`, `design-accessibility` |
| Android app | `core`, `platform-mobile`, `tech-android`, `design-mobile`, `design-accessibility` |
| React Native (Expo) | `core`, `lang-typescript`, `platform-mobile`, `tech-react`, `tech-react-native`, `design-mobile` |
| Node.js API | `core`, `lang-typescript`, `platform-backend`, `tech-trpc`, `tech-drizzle` |

---

## Plugin Structure (Vercel Pattern)

Each plugin follows the [Vercel agent-skills](https://github.com/vercel-labs/agent-skills) pattern:

```
plugins/[name]/
├── .claude-plugin/
│   └── plugin.json              # Manifest (required)
└── skills/
    └── [skill-name]/
        ├── rules/
        │   ├── _sections.md     # Section definitions + impact levels
        │   ├── _template.md     # Template for new rules
        │   └── [prefix]-*.md    # Individual rules by section
        ├── metadata.json        # Version, author, references
        └── SKILL.md             # Skill documentation
```

### Rule File Format

```markdown
---
title: Rule Title
impact: CRITICAL | HIGH | MEDIUM | LOW
impactDescription: Optional (e.g., "2-10× improvement")
tags: tag1, tag2
---

## Rule Title

Brief explanation of why this matters.

**Incorrect (description):**
\`\`\`typescript
// Bad code
\`\`\`

**Correct (description):**
\`\`\`typescript
// Good code
\`\`\`

**Why it matters:** Consequences of the incorrect approach.
```

---

## Reference Standards

Project-specific standards used as source material for plugins.

| Standard | Target Plugin(s) | Status |
|----------|------------------|--------|
| [coding-style.md](reference/standards/global/coding-style.md) | `core` | ✅ Extracted |
| [conventions.md](reference/standards/global/conventions.md) | `core` | ✅ Extracted |
| [error-handling.md](reference/standards/global/error-handling.md) | `platform-backend`, `tech-trpc` | ✅ Extracted |
| [validation.md](reference/standards/global/validation.md) | `platform-backend` | ✅ Extracted |
| [security.md](reference/standards/global/security.md) | `platform-backend` | ✅ Extracted |
| [logging.md](reference/standards/global/logging.md) | `platform-backend` | Needs extraction |
| [performance.md](reference/standards/global/performance.md) | `core` | ✅ Extracted |
| [api.md](reference/standards/backend/api.md) | `platform-backend`, `tech-trpc` | ✅ Extracted |
| [models.md](reference/standards/backend/models.md) | `platform-database`, `tech-drizzle` | ✅ Extracted |
| [queries.md](reference/standards/backend/queries.md) | `platform-database`, `tech-drizzle` | ✅ Extracted |
| [migrations.md](reference/standards/backend/migrations.md) | `platform-database`, `tech-drizzle` | ✅ Extracted |
| [components.md](reference/standards/frontend/components.md) | `platform-frontend`, `tech-react` | ✅ Extracted |
| [styles.md](reference/standards/frontend/styles.md) | `design-frontend` | ✅ Extracted |
| [responsive.md](reference/standards/frontend/responsive.md) | `design-frontend` | ✅ Extracted |
| [accessibility.md](reference/standards/frontend/accessibility.md) | `design-accessibility` | ✅ Extracted |
| [test-writing.md](reference/standards/testing/test-writing.md) | `platform-testing`, `tech-vitest` | ✅ Extracted |

---

## Contributing

1. Pick a plugin from the tables above
2. Create `skills/[name]/` with the Vercel pattern structure
3. Add rules following `_template.md`
4. Update status in this README
5. Submit PR
