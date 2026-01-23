# Pitboss Development Standards

Coding standards and conventions for the Pitboss SaaS platform. These apply to all code in the monorepo.

## Quick Reference

**Key Principles:**

- kebab-case everything (files, folders, no exceptions)
- Named exports only, no default exports
- No barrel files (import directly from source)
- Vertical Slice Architecture for features
- DRY, KISS, Single Responsibility

## Standards Index

### Global

| File                                          | Purpose                                         |
| --------------------------------------------- | ----------------------------------------------- |
| [tech-stack.md](global/tech-stack.md)         | Technology choices and versions                 |
| [conventions.md](global/conventions.md)       | pnpm, git, TypeScript, imports, common commands |
| [coding-style.md](global/coding-style.md)     | Naming, formatting (Biome), function design     |
| [commenting.md](global/commenting.md)         | Self-documenting code, when to comment          |
| [error-handling.md](global/error-handling.md) | TRPCError patterns, error classes               |
| [validation.md](global/validation.md)         | Zod schemas, input validation                   |
| [security.md](global/security.md)             | Auth, multi-tenancy, secrets                    |
| [logging.md](global/logging.md)               | Structured logging, what to log                 |
| [performance.md](global/performance.md)       | Measure first, optimization patterns            |

### Backend

| File                                   | Purpose                             |
| -------------------------------------- | ----------------------------------- |
| [api.md](backend/api.md)               | tRPC + Vertical Slice Architecture  |
| [models.md](backend/models.md)         | Drizzle schema patterns             |
| [queries.md](backend/queries.md)       | Drizzle queries, SQL best practices |
| [migrations.md](backend/migrations.md) | db:push vs db:generate workflow     |

### Frontend

| File                                          | Purpose                      |
| --------------------------------------------- | ---------------------------- |
| [components.md](frontend/components.md)       | React components, VSA, hooks |
| [css.md](frontend/css.md)                     | Tailwind v4, cn() utility    |
| [responsive.md](frontend/responsive.md)       | Mobile-first, breakpoints    |
| [accessibility.md](frontend/accessibility.md) | WCAG AA, semantic HTML       |

### Testing

| File                                       | Purpose                           |
| ------------------------------------------ | --------------------------------- |
| [test-writing.md](testing/test-writing.md) | Testing Trophy, integration tests |
