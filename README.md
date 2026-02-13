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
| Frontend | `platform-frontend` | `tech-react` |
| Backend | `platform-backend` | `tech-trpc` |
| Database | `platform-database` | `tech-drizzle` |
| Testing | `platform-testing` | `tech-vitest` |

---

## Skills

### Universal

| Skill | Description | Rules | Status |
|-------|-------------|-------|--------|
| `core-coding-standards` | KISS, DRY, clean code, code review | 2 | **Ready** |
| `lang-typescript` | Strict mode, no any, discriminated unions | 4 | **Ready** |

### Platform Layers (Generic)

| Skill | Description | Rules |
|-------|-------------|-------|
| `platform-frontend` | State management, components, data fetching | 6 |
| `platform-backend` | API design, services, error handling | 13 |
| `platform-database` | Queries, migrations, performance | 17 |
| `platform-testing` | Test philosophy, structure, mocking | 3 |
| `platform-cli` | CLI design, commands, flags, modern UX | — |

### Frameworks

| Skill | Extends | Description | Rules |
|-------|---------|-------------|-------|
| `tech-react` | `platform-frontend` | Components, hooks, state, performance | 8 |
| `tech-trpc` | `platform-backend` | Procedures, routers, Vertical Slice Architecture | 8 |
| `tech-drizzle` | `platform-database` | Relational queries, schema, migrations | 9 |
| `tech-vitest` | `platform-testing` | vi.mock, vi.fn, fake timers | 7 |
| `swift-concurrency` | — | async/await, actors, tasks, Sendable | — |

### Design & UX

| Skill | Description | Rules |
|-------|-------------|-------|
| `design-frontend` | Layouts, responsive, Tailwind tokens | 7 |
| `design-accessibility` | WCAG AA, screen readers, keyboard nav | 4 |
| `liquid-glass-ios` | Apple Liquid Glass for iOS 26+ | — |

### Agent Workflow

These skills configure the AI agent itself (CLAUDE.md, docs/agents/, skills). They are distributable via `npx add-skill` and dogfooded by this toolkit via symlinks.

| Skill | Description | Status |
|-------|-------------|--------|
| `agent-init-deep` | Initialize or migrate to progressive disclosure CLAUDE.md structure | **Ready** |
| `agent-add-rule` | Classify and place new rules in the right config location | **Ready** |
| `agent-skill-creator` | Guide for creating effective skills with scripts, references, and assets | **Ready** |

Scaffold skills (in development) are in `skills/_drafts/`. See `marketplace.json` for the full catalog including drafts.

---

## Stack Recipes

| Project Type | Skills |
|--------------|--------|
| React web app | `core-coding-standards`, `lang-typescript`, `platform-frontend`, `tech-react`, `design-accessibility` |
| TanStack Start + tRPC | `core-coding-standards`, `lang-typescript`, `platform-frontend`, `tech-react`, `tech-trpc`, `tech-drizzle` |
| Next.js | `core-coding-standards`, `lang-typescript`, `platform-frontend`, `tech-react` |
| iOS app | `core-coding-standards`, `swift-concurrency`, `liquid-glass-ios`, `design-accessibility` |
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
├── references/           # Long-form guidance loaded on demand (optional)
├── scripts/              # Executable helpers for deterministic tasks (optional)
└── assets/               # Templates/resources used in outputs (optional)
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

## Skill Quality Checks

```bash
ruby scripts/skills_audit.rb
ruby scripts/skills_harness.rb
```

These checks enforce schema, link integrity, trigger examples, troubleshooting structure, and size/performance guardrails.

---

## Contributing

1. Pick a skill from the tables above
2. Create or edit `skills/[name]/` following the Vercel pattern structure
3. Add rules following the rule file format above
4. Run `ruby scripts/skills_audit.rb` and `ruby scripts/skills_harness.rb`
5. Update status in this README
6. Submit PR
