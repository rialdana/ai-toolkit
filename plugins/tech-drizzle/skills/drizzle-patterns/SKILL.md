---
name: drizzle-patterns
description: Drizzle ORM patterns for schemas, queries, and migrations. Use when working with Drizzle in TypeScript projects.
---

# Drizzle Patterns

Drizzle ORM-specific best practices. These rules build on the generic `platform-database` plugin with Drizzle-specific APIs and patterns.

## When This Applies

- Drizzle ORM in dependencies
- Writing schemas, queries, or migrations
- Using `drizzle-kit` for migrations

## Extends

This plugin extends **`platform-database`** (generic database patterns). Apply those rules first, then these Drizzle-specific ones.

## Quick Reference

| Section | Impact | Prefix |
|---------|--------|--------|
| Relational Queries | HIGH | `rqb-` |
| Query Builder | MEDIUM | `qb-` |
| Schema | MEDIUM | `schema-` |
| Migrations | HIGH | `migration-` |

## Rules

See `rules/` directory for individual rules organized by section prefix.
