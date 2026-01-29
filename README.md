# Ravn AI Toolkit

A la carte AI skills for LLM-assisted development across platforms.

## Installation

```bash
# Add a skill
npx skills add ravnhq/ai-toolkit -s core-coding-standards
npx skills add ravnhq/ai-toolkit -s tech-react

# Add multiple skills at once
npx skills add ravnhq/ai-toolkit -s core-coding-standards -s lang-typescript -s platform-frontend -s tech-react

# List available skills
npx skills add ravnhq/ai-toolkit -l
```

---

## Skill Hierarchy

Skills use a **layered architecture**: generic platform rules + specific framework rules. Install generic skills first, then framework-specific ones.

| Layer | Generic | Specific |
|-------|---------|----------|
| Frontend | `platform-frontend` | `tech-react`, `tech-tanstack-router`, `tech-tanstack-form` |
| Backend | `platform-backend` | `tech-trpc` |
| Database | `platform-database` | `tech-drizzle`, `tech-prisma` |
| Mobile | `platform-mobile` | `tech-ios`, `tech-android`, `tech-react-native` |
| Testing | `platform-testing` | `tech-vitest` |
| Design | `design` | `design-frontend`, `design-mobile` |

---

## Skills

### Universal

| Skill | Description | Rules | Status |
|-------|-------------|-------|--------|
| `core-coding-standards` | KISS, DRY, clean code, code review | 2 | **Ready** |
| `lang-typescript` | Strict mode, no any, discriminated unions | 4 | **Ready** |

### Platform Layers (Generic)

| Skill | Description | Rules | Status |
|-------|-------------|-------|--------|
| `platform-frontend` | State management, components, data fetching | 6 | **Ready** |
| `platform-backend` | API design, services, error handling | 13 | **Ready** |
| `platform-database` | Queries, migrations, performance | 19 | **Ready** |
| `platform-testing` | Test philosophy, structure, mocking | 3 | **Ready** |
| `platform-mobile` | Navigation, gestures, offline, performance | — | Scaffold |

### Frameworks (Web)

| Skill | Extends | Description | Rules | Status |
|-------|---------|-------------|-------|--------|
| `tech-react` | `platform-frontend` | Components, hooks, state, performance | 8 | **Ready** |
| `tech-tanstack-router` | `platform-frontend` | File-based routing, loaders, type-safe nav | — | Scaffold |
| `tech-tanstack-form` | `platform-frontend` | Form state, validation, field arrays | — | Scaffold |
| `tech-trpc` | `platform-backend` | Procedures, routers, Vertical Slice Architecture | 8 | **Ready** |
| `tech-drizzle` | `platform-database` | Relational queries, schema, migrations | 9 | **Ready** |
| `tech-prisma` | `platform-database` | Schema, queries, relations, migrations | — | Scaffold |
| `tech-vitest` | `platform-testing` | vi.mock, vi.fn, fake timers | 7 | **Ready** |

### Frameworks (Mobile)

| Skill | Extends | Description | Rules | Status |
|-------|---------|-------------|-------|--------|
| `tech-ios` | `platform-mobile` | Swift/SwiftUI, concurrency, App Store | — | Scaffold |
| `tech-android` | `platform-mobile` | Kotlin/Compose, architecture, Play Store | — | Scaffold |
| `tech-react-native` | `platform-mobile` | Expo, navigation, native modules | — | Scaffold |

### Design & UX

| Skill | Extends | Description | Rules | Status |
|-------|---------|-------------|-------|--------|
| `design` | — | Hierarchy, spacing, color, typography | — | Scaffold |
| `design-frontend` | `design` | Layouts, responsive, Tailwind tokens | 7 | **Ready** |
| `design-mobile` | `design` | Touch targets, gestures, platform conventions | — | Scaffold |
| `design-accessibility` | — | WCAG AA, screen readers, keyboard nav | 4 | **Ready** |

### Agent Workflow

These skills configure the AI agent itself (CLAUDE.md, docs/agents/, skills). They are distributable via `npx add-skill` and dogfooded by this toolkit via symlinks.

| Skill | Description | Status |
|-------|-------------|--------|
| `agent-init-deep` | Initialize or migrate to progressive disclosure CLAUDE.md structure | **Ready** |
| `agent-add-rule` | Classify and place new rules in the right config location | **Ready** |
| `agent-skill-creator` | Guide for creating effective skills with scripts, references, and assets | **Ready** |

**Status key:** Scaffold (sections defined) → In Progress → **Ready**

---

## Stack Recipes

| Project Type | Skills |
|--------------|--------|
| React web app | `core-coding-standards`, `lang-typescript`, `platform-frontend`, `tech-react`, `design-accessibility` |
| TanStack Start + tRPC | `core-coding-standards`, `lang-typescript`, `platform-frontend`, `tech-react`, `tech-tanstack-router`, `tech-tanstack-form`, `tech-trpc`, `tech-drizzle` |
| Next.js + Prisma | `core-coding-standards`, `lang-typescript`, `platform-frontend`, `tech-react`, `tech-prisma` |
| iOS app | `core-coding-standards`, `platform-mobile`, `tech-ios`, `design-mobile`, `design-accessibility` |
| Android app | `core-coding-standards`, `platform-mobile`, `tech-android`, `design-mobile`, `design-accessibility` |
| React Native (Expo) | `core-coding-standards`, `lang-typescript`, `platform-mobile`, `tech-react`, `tech-react-native`, `design-mobile` |
| Node.js API | `core-coding-standards`, `lang-typescript`, `platform-backend`, `tech-trpc`, `tech-drizzle` |

---

## Skill Structure (Vercel Pattern)

Each skill follows the [Vercel agent-skills](https://github.com/vercel-labs/agent-skills) pattern:

```
skills/[skill-name]/
├── SKILL.md              # Skill instructions + frontmatter metadata
├── rules/                # Rule files (optional)
│   ├── _sections.md      # Section definitions
│   └── [prefix]-*.md     # Individual rules
└── README.md             # Human-readable docs (optional)
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

## Contributing

1. Pick a skill from the tables above
2. Create or edit `skills/[name]/` following the Vercel pattern structure
3. Add rules following the rule file format above
4. Update status in this README
5. Submit PR
