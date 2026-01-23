---
name: frontend-patterns
description: Generic frontend patterns for components, state, and data fetching. Use when building any frontend application.
---

# Frontend Patterns

Framework-agnostic frontend best practices. These rules apply regardless of your framework (React, Vue, Svelte, Solid).

## When This Applies

- Building UI components
- Managing application state
- Fetching and displaying data
- Form handling

## Extends

This is a **generic platform plugin**. Framework-specific plugins extend these rules:
- `react` - React hooks and component patterns
- `tanstack-router` - TanStack Router specifics
- `tanstack-form` - TanStack Form specifics

## Quick Reference

| Section | Impact | Prefix |
|---------|--------|--------|
| State Management | HIGH | `state-` |
| Components | HIGH | `component-` |
| Data Fetching | MEDIUM | `data-` |
| Performance | MEDIUM | `perf-` |
| Organization | MEDIUM | `org-` |

## Rules

See `rules/` directory for individual rules organized by section prefix.
