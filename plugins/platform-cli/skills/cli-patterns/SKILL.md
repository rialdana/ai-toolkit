---
name: cli-patterns
description: Design and implementation patterns for building command-line tools with modern UX conventions
---

# CLI Development Patterns

Modern CLI design patterns following established UX conventions for commands, flags, help text, output formats, error handling, signals, configuration, and distribution.

## When This Applies

- Design a new CLI tool from scratch
- Review an existing CLI's UX and behavior
- Define command structures, flag schemas, or help text
- Make decisions about interactivity, output formats, or error handling
- Plan CLI distribution and packaging strategies
- Implement signal handling (Ctrl-C, cleanup)
- Configure environment variables and config files

## Quick Reference

| Section | Prefix | Impact | Rules |
|---------|--------|--------|-------|
| Design & Naming | `design-` | HIGH | 4 |
| Flags & Arguments | `flags-` | HIGH | 5 |
| Output & Formatting | `output-` | MEDIUM | 4 |
| Error Handling | `error-` | HIGH | 4 |
| Signals & Lifecycle | `signal-` | HIGH | 4 |
| Environment & Config | `env-` | MEDIUM | 4 |
| Distribution & Packaging | `dist-` | MEDIUM | 3 |
| Security & Privacy | `security-` | CRITICAL | 2 |

## Rules

See `rules/` directory for individual rules organized by section prefix.
