---
name: backend-patterns
description: Generic backend patterns for APIs, error handling, and security. Use when building any backend service.
---

# Backend Patterns

Framework-agnostic backend best practices. These rules apply regardless of your API framework (tRPC, Express, Hono, Fastify).

## When This Applies

- Building API endpoints
- Implementing error handling
- Security concerns
- Input validation

## Extends

This is a **generic platform plugin**. Framework-specific plugins extend these rules:
- `trpc` - tRPC procedure patterns

## Quick Reference

| Section | Impact | Prefix |
|---------|--------|--------|
| API Design | HIGH | `api-` |
| Error Handling | HIGH | `error-` |
| Security | CRITICAL | `security-` |
| Validation | HIGH | `validation-` |

## Rules

See `rules/` directory for individual rules organized by section prefix.
