---
name: agents-md
description: Audit and manage CLAUDE.md/AGENTS.md files. Use when asked to add rules, audit agent config, or decide where documentation belongs.
---

# CLAUDE.md / AGENTS.md Management

Manage static agent configuration using the static vs dynamic framework. Use this skill when:
- Adding new rules or conventions to agent config
- Auditing an existing CLAUDE.md for bloat
- Deciding where documentation belongs

## Core Principle: Instruction Budget

Models can reliably follow ~150-200 instructions. Every token in CLAUDE.md loads on every request. Therefore:
- CLAUDE.md MUST be minimal
- Everything else uses progressive disclosure or skills

## The Framework

```
STATIC (CLAUDE.md)           → Loaded every request
PROGRESSIVE DISCLOSURE       → Loaded when agent navigates to file
SKILLS                       → Loaded when task matches
```

## Decision Tree: Where Does This Belong?

When asked to add something to CLAUDE.md or documentation, use this decision tree:

```
Is this relevant to EVERY SINGLE task in the repo?
├── YES → Does it fit in one of these categories?
│   ├── Project identity (1 sentence) → CLAUDE.md
│   ├── Tech stack declaration → CLAUDE.md
│   ├── Package manager / tooling commands → CLAUDE.md
│   ├── Critical security/compliance guardrail → CLAUDE.md
│   └── None of the above → Probably not actually relevant to every task
│
└── NO → Is it a pattern or workflow that can be invoked on-demand?
    ├── YES → Create or update a SKILL
    └── NO → Is it domain-specific documentation?
        ├── YES → Progressive disclosure (docs/ or nested CLAUDE.md)
        └── NO → Probably doesn't need to be documented
```

## What Belongs in CLAUDE.md (Static)

ONLY these categories:

### 1. Project Identity
One sentence describing what the project is and who it's for.

```markdown
## Identity
A B2B SaaS platform for construction project management.
```

### 2. Tech Stack Declaration
So the model knows the domain before suggesting anything.

```markdown
## Tech Stack
- Frontend: TanStack Start, React 19
- Backend: tRPC, Node.js
- Database: PostgreSQL, Drizzle ORM
- Styling: Tailwind v4
```

### 3. Tooling & Commands
Package manager and non-standard commands. Use MUST/NEVER keywords.

```markdown
## Tooling
- MUST use pnpm (NEVER npm or yarn)
- MUST use biome for formatting

## Commands
- `pnpm dev` - start dev server
- `pnpm build` - production build
- `pnpm test` - run tests
```

### 4. Critical Guardrails
Security and compliance rules that can NEVER be missed. Use MUST/ALWAYS/NEVER.

```markdown
## Guardrails
- MUST filter all queries by `tenantId`
- NEVER commit `.env` files
- NEVER use `any` type
```

### 5. Progressive Disclosure Pointers
Tell the model where to find more information.

```markdown
## More Information
- Architecture decisions: `docs/architecture.md`
- API patterns: `docs/api.md`
- Available skills: run `/skills`
```

## What Does NOT Belong in CLAUDE.md

| Content | Why Not | Where Instead |
|---------|---------|---------------|
| File paths / directory structure | Goes stale quickly | Let agent explore or use docs/ |
| Framework-specific patterns | Only relevant when using that framework | Skill |
| Code style rules | Only relevant when writing code | Skill (invoked on file creation) |
| Testing conventions | Only relevant when writing tests | Skill |
| Git workflow | Only relevant when committing | Skill |
| Detailed examples | Bloats context | Progressive disclosure docs |
| Obvious instructions | Wastes tokens | Delete |
| Conflicting rules | Confuses model | Resolve and consolidate |

## Audit Workflow

When asked to audit a CLAUDE.md, follow these steps:

### Step 1: Find Contradictions
Identify instructions that conflict. Ask which version to keep.

### Step 2: Categorize Everything
For each instruction, determine:
- [ ] Project identity?
- [ ] Tech stack?
- [ ] Tooling/commands?
- [ ] Critical guardrail?
- [ ] Progressive disclosure pointer?
- [ ] None of the above?

### Step 3: Flag for Removal
Mark instructions that are:
- **Redundant**: Model already knows this
- **Vague**: Not actionable
- **Obvious**: "Write clean code"
- **Domain-specific**: Should be progressive disclosure
- **Pattern/workflow**: Should be a skill

### Step 4: Propose New Structure
Output:
1. Minimal CLAUDE.md with only essential items
2. List of items to move to docs/
3. List of items to convert to skills
4. List of items to delete

## Add Rule Workflow

When asked to add something to CLAUDE.md or documentation:

### Step 1: Apply Decision Tree
Ask: "Is this relevant to every single task?"

### Step 2: If Yes → Check Categories
Does it fit project identity, tech stack, tooling, or guardrails?
- If yes: Add to CLAUDE.md using MUST/ALWAYS/NEVER keywords
- If no: Challenge the assumption - probably not actually universal

### Step 3: If No → Determine Type
- Pattern/workflow → Suggest creating or updating a skill
- Domain documentation → Suggest adding to docs/
- Already covered → Point to existing documentation

### Step 4: Confirm Location
Always confirm with user before adding. State:
- Where you're adding it
- Why it belongs there
- What keywords you're using (if CLAUDE.md)

## Keywords Reference

Use these keywords in CLAUDE.md for unambiguous instructions:

| Keyword | Meaning | Example |
|---------|---------|---------|
| MUST | Required, no exceptions | "MUST use pnpm" |
| NEVER | Prohibited, no exceptions | "NEVER commit .env" |
| ALWAYS | Do this every time | "ALWAYS filter by tenantId" |
| PREFER | Default choice, exceptions allowed | "PREFER named exports" |
| AVOID | Generally don't do this | "AVOID barrel files" |
