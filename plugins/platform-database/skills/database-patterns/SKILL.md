---
name: database-patterns
description: Generic database patterns for queries, migrations, and performance. Use when working with any database, ORM, or query builder.
---

# Database Patterns

Framework-agnostic database best practices. These rules apply regardless of your ORM (Drizzle, Prisma, TypeORM) or query builder.

## When This Applies

- Any SQL database work
- Writing queries or migrations
- Performance optimization
- Schema design

## Extends

This is a **generic platform plugin**. Framework-specific plugins extend these rules:
- `drizzle` - Drizzle ORM specifics
- `prisma` - Prisma Client specifics

## Quick Reference

| Section | Impact | Prefix |
|---------|--------|--------|
| Query Optimization | CRITICAL | `query-` |
| Migrations | HIGH | `migration-` |
| Indexing | HIGH | `index-` |
| Transactions | MEDIUM | `transaction-` |
| Schema Design | MEDIUM | `schema-` |

## Rules

See `rules/` directory for individual rules organized by section prefix.
