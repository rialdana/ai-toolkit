# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Identity

A marketplace of modular Claude Code plugins for LLM-assisted development. Provides layered architecture: generic platform rules + framework-specific patterns for frontend, backend, database, mobile, testing, and design.

## Tech Stack

- Plugin System: Vercel agent-skills pattern
- Documentation: Markdown with YAML frontmatter
- Standards: Reference material in `reference/standards/`
- Structure: Each plugin in `plugins/[name]/` with `.claude-plugin/plugin.json` manifest

## Tooling

- MUST use `fd` and `rg` for faster file operations (over `find` and `grep`)
- Use git for version control

## Plugin Architecture

Plugins follow a **layered hierarchy**:
1. **Universal** (`core`, `lang-typescript`) - apply to all code
2. **Platform Generic** (`platform-frontend`, `platform-backend`, `platform-database`, `platform-mobile`, `platform-testing`) - generic patterns
3. **Framework-Specific** (`tech-react`, `tech-trpc`, `tech-drizzle`, etc.) - extend platform plugins with framework APIs
4. **Design** (`design`, `design-frontend`, `design-mobile`, `design-accessibility`) - visual and UX patterns

### Plugin Structure

```
plugins/[name]/
├── .claude-plugin/
│   └── plugin.json              # Manifest (name, description, version, author)
└── skills/
    └── [skill-name]/
        ├── rules/
        │   ├── _sections.md     # Section definitions + impact levels
        │   ├── _template.md     # Template for new rules
        │   └── [prefix]-*.md    # Individual rules (kebab-case)
        ├── metadata.json        # Version, author, references
        └── SKILL.md             # Skill documentation
```

### Rule File Format

Every rule MUST have:
- YAML frontmatter: `title`, `impact` (CRITICAL/HIGH/MEDIUM/LOW), `tags`
- **Incorrect** code example with explanation
- **Correct** code example with explanation
- **Why it matters** section explaining consequences

### Rule Organization

- Rules grouped by section prefix (defined in `_sections.md`)
- Use kebab-case for all filenames
- Each section has impact level and ordering

## Guardrails

- MUST follow plugin structure conventions (Vercel pattern)
- MUST include impact levels in rule frontmatter
- MUST provide both correct and incorrect examples
- NEVER create duplicate rules across plugins
- ALWAYS check if a rule belongs in generic (platform) or specific (tech) plugin
- ALWAYS reference source material from `reference/standards/` when extracting rules

## More Information

- Architecture: See README.md for full plugin hierarchy and stack recipes
- Reference Standards: `reference/standards/README.md` - source material for rule extraction
- Plugin Marketplace: `.claude-plugin/marketplace.json` - registry of all plugins
- Static vs Dynamic Framework: `plugins/core/skills/agents-md/SKILL.md` - when to use CLAUDE.md vs skills vs docs
