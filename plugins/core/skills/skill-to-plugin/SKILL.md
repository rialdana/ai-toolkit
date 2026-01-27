---
name: skill-to-plugin
description: Convert monolithic user skills into structured ai-toolkit plugin format with rules, sections, and metadata. Use when transforming standalone skill files into the modular plugin architecture.
---

# Skill-to-Plugin Converter

Transforms monolithic user skills into the ai-toolkit plugin format: organized rules with impact levels, sections, templates, and marketplace registration.

## When to Use This Skill

**Trigger phrases:**
- "Convert my [skill-name] skill to a plugin"
- "Transform [skill-name] into ai-toolkit format"
- "Create a plugin from my [skill-name] skill"
- "Port [skill-name] to the plugin architecture"
- "Add [skill-name] to the ai-toolkit as a plugin"

**Use when:**
- A user has a working skill in `~/.claude/skills/` they want to formalize
- Converting external skill files into ai-toolkit structure
- Migrating from monolithic to modular architecture
- Creating a new plugin from documented patterns/rules

## Three-Phase Workflow

### Phase 1: Analysis & Planning

**Goal:** Understand the source skill and design the target plugin structure.

**Steps:**

1. **Read the source skill file**
   - Location: `~/.claude/skills/[name]/SKILL.md` or user-provided path
   - Extract: title, purpose, rules/patterns, examples, references

2. **Determine plugin classification**

   Use this hierarchy to name the plugin:

   - **`core`** - Universal principles (KISS, DRY, code review)
   - **`lang-*`** - Language-specific (TypeScript, Python, Go)
   - **`platform-*`** - Generic platform patterns:
     - `platform-frontend` - Generic UI/UX patterns (not framework-specific)
     - `platform-backend` - Generic API/server patterns
     - `platform-database` - Generic data patterns
     - `platform-mobile` - Generic mobile patterns (cross-platform)
     - `platform-testing` - Generic testing patterns
     - `platform-cli` - CLI design patterns
   - **`tech-*`** - Framework/library-specific (React, tRPC, Drizzle, iOS, Android)
   - **`design-*`** - Visual/UX patterns (frontend-design, mobile-design, accessibility)

   **Examples:**
   - "React hooks best practices" → `tech-react`
   - "API error handling patterns" → `platform-backend`
   - "Database schema design" → `platform-database`
   - "iOS SwiftUI patterns" → `tech-ios`
   - "Accessible form design" → `design-accessibility`

3. **Identify discrete rules**

   Parse the skill content for:
   - Prescriptive statements ("Always...", "Never...", "Prefer...")
   - Anti-patterns with corrections
   - Before/after examples
   - Common mistakes
   - Best practices with rationale

   Each rule MUST have:
   - A clear "incorrect" example
   - A clear "correct" example
   - Explanation of consequences ("Why it matters")

4. **Group rules into sections**

   Organize rules by theme. For each section define:
   - **Section title** (e.g., "State Management", "Error Handling")
   - **Prefix** (kebab-case, e.g., `state-`, `error-`)
   - **Impact level** (CRITICAL, HIGH, MEDIUM-HIGH, MEDIUM, LOW)
   - **Description** (1-2 sentences on what this section covers)

   **Impact level guidelines:**
   - **CRITICAL**: Violating causes security issues, data loss, or system failure
   - **HIGH**: Causes bugs, poor performance, or significant tech debt
   - **MEDIUM-HIGH**: Reduces reliability or maintainability
   - **MEDIUM**: Affects code quality or developer experience
   - **LOW**: Stylistic preferences

5. **Determine skill name**

   Format: `[type]-patterns` (e.g., `react-patterns`, `backend-patterns`)

   Must match existing skill if plugin exists, otherwise create new.

6. **Present proposed structure to user**

   Show:
   ```
   Plugin: [plugin-name]
   Skill: [skill-name]

   Sections:
   1. [Section Title] (prefix: [prefix], impact: [LEVEL])
      - [Rule 1 title]
      - [Rule 2 title]
      ...
   2. [Section Title] (prefix: [prefix], impact: [LEVEL])
      ...

   Total: [N] rules across [M] sections
   ```

   **Ask user:** "Does this structure look correct? Any changes needed before I create the files?"

### Phase 2: File Creation

**Only proceed after user approval from Phase 1.**

**Steps:**

1. **Create directory structure**

   ```bash
   plugins/[plugin-name]/
   ├── .claude-plugin/
   │   └── plugin.json
   └── skills/
       └── [skill-name]/
           ├── rules/
           │   ├── _sections.md
           │   ├── _template.md
           │   └── [prefix]-[rule-name].md (for each rule)
           ├── metadata.json
           └── SKILL.md
   ```

   **If plugin exists:** Skip `.claude-plugin/plugin.json` and add to existing `skills/` directory.

2. **Create `plugin.json`** (if new plugin)

   ```json
   {
     "name": "[plugin-name]",
     "description": "[One-line description]",
     "version": "1.0.0",
     "author": { "name": "Ravn" }
   }
   ```

3. **Create `_sections.md`**

   Use heading-based format (NOT table format):

   ```markdown
   # Sections

   This file defines all sections, their ordering, impact levels, and descriptions.
   The section ID (in parentheses) is the filename prefix used to group rules.

   ---

   ## 1. [Section Title] ([prefix])

   **Impact:** [LEVEL]
   **Description:** [1-2 sentence description explaining what this covers and why it matters]

   ## 2. [Section Title] ([prefix])

   **Impact:** [LEVEL]
   **Description:** [Description]

   ...
   ```

4. **Create `_template.md`**

   ```markdown
   ---
   title: Rule Title Here
   impact: MEDIUM
   impactDescription: Optional quantified impact
   tags: tag1, tag2
   ---

   ## Rule Title Here

   Brief explanation of the rule and why it matters. Focus on the "why" - what problems does violating this cause?

   **Incorrect (description of what's wrong):**

   ```[language]
   // Bad code example
   ```

   **Correct (description of what's right):**

   ```[language]
   // Good code example
   ```

   **Why it matters:** Explain the consequences of the incorrect approach.

   Reference: [Link to documentation](https://example.com)
   ```

5. **Create individual rule files**

   For each rule identified in Phase 1:

   **Filename:** `rules/[prefix]-[kebab-case-title].md`

   **Example:** `rules/state-no-prop-drilling.md`

   **Content:**
   ```markdown
   ---
   title: [Rule Title]
   impact: [LEVEL]
   tags: [tag1, tag2, tag3]
   ---

   ## [Rule Title]

   [Brief explanation - why this rule exists]

   **Incorrect:**

   ```[language]
   // Example of what NOT to do
   // Include comments explaining why it's wrong
   ```

   **Correct:**

   ```[language]
   // Example of the RIGHT way
   // Include comments explaining why it's better
   ```

   **Why it matters:** [Consequences of incorrect approach - performance, bugs, maintainability, etc.]
   ```

   **Extraction guidelines:**
   - Copy examples verbatim from source skill (preserve comments, formatting)
   - If source lacks incorrect/correct examples, synthesize them from description
   - Use consistent code block language tags (`typescript`, `python`, `swift`, etc.)
   - Keep explanations concise (2-4 sentences per section)

6. **Create `metadata.json`**

   ```json
   {
     "version": "1.0.0",
     "author": "Ravn Engineering",
     "date": "2025-01",
     "abstract": "[2-3 sentence summary. Include: topic coverage, rule count, section count]",
     "references": [
       {
         "title": "[Reference title]",
         "url": "[URL]"
       }
     ]
   }
   ```

   Extract references from source skill. If none exist, omit the `references` array.

7. **Create index `SKILL.md`**

   Slim index file (NOT the full original content):

   ```markdown
   ---
   name: [skill-name]
   description: [One-line description. When this skill applies.]
   ---

   # [Skill Display Title]

   [One paragraph overview of what this skill covers]

   ## When This Applies

   - [Use case 1]
   - [Use case 2]
   - [Use case 3]
   - [Use case 4]

   ## Quick Reference

   | Section | Impact | Prefix |
   |---------|--------|--------|
   | [Section 1] | [LEVEL] | `[prefix]-` |
   | [Section 2] | [LEVEL] | `[prefix]-` |
   | ... | ... | ... |

   ## Rules

   See `rules/` directory for individual rules organized by section prefix.
   ```

8. **Register in marketplace**

   Add entry to `.claude-plugin/marketplace.json`:

   ```json
   {
     "name": "[plugin-name]",
     "source": "./plugins/[plugin-name]",
     "version": "1.0.0"
   }
   ```

   Insert alphabetically within the appropriate group (core, platform-*, tech-*, design-*).

### Phase 3: Validation

**Goal:** Programmatically verify the plugin structure is correct.

**Validation checklist** (use `fd` and `rg` for speed):

1. **Structure check**

   ```bash
   # Verify directories exist
   fd -t d -d 1 . plugins/[plugin-name]
   # Should show: .claude-plugin, skills

   fd -t d -d 1 . plugins/[plugin-name]/skills/[skill-name]
   # Should show: rules

   # Verify required files
   fd -t f . plugins/[plugin-name]/.claude-plugin
   # Should show: plugin.json

   fd -t f -d 1 . plugins/[plugin-name]/skills/[skill-name]/rules
   # Should show: _sections.md, _template.md, [rule files]

   fd -t f -d 1 . plugins/[plugin-name]/skills/[skill-name]
   # Should show: SKILL.md, metadata.json
   ```

2. **Frontmatter check**

   ```bash
   # Verify all rules have valid frontmatter
   rg "^---$" plugins/[plugin-name]/skills/[skill-name]/rules/*.md -c
   # Each rule file should have exactly 2 matches (opening/closing ---)

   # Verify required frontmatter fields
   rg "^title:" plugins/[plugin-name]/skills/[skill-name]/rules/*.md
   rg "^impact:" plugins/[plugin-name]/skills/[skill-name]/rules/*.md
   rg "^tags:" plugins/[plugin-name]/skills/[skill-name]/rules/*.md
   ```

3. **Example check**

   ```bash
   # Verify all rules have Incorrect and Correct sections
   rg "^\*\*Incorrect" plugins/[plugin-name]/skills/[skill-name]/rules/*.md -c
   rg "^\*\*Correct" plugins/[plugin-name]/skills/[skill-name]/rules/*.md -c
   # Should match rule count (excluding _template.md)

   # Verify code blocks exist
   rg "^```" plugins/[plugin-name]/skills/[skill-name]/rules/*.md -c
   # Should be at least 2x rule count (min 1 block per section)
   ```

4. **Naming check**

   ```bash
   # Verify all rule files use kebab-case with section prefix
   fd -e md . plugins/[plugin-name]/skills/[skill-name]/rules
   # All files should match pattern: [prefix]-[kebab-case].md
   ```

5. **Marketplace check**

   ```bash
   # Verify plugin registered
   rg '"name": "[plugin-name]"' .claude-plugin/marketplace.json
   ```

**Report results:**
```
✅ Directory structure: [PASS/FAIL]
✅ Required files: [PASS/FAIL]
✅ Frontmatter: [N/N rules have valid frontmatter]
✅ Examples: [N/N rules have Incorrect/Correct sections]
✅ Naming: [PASS/FAIL]
✅ Marketplace: [PASS/FAIL]

[If any failures, list specific issues]
```

## Embedded Templates

All templates are provided above in Phase 2. Reference them when creating files.

**Key formats:**
- **plugin.json**: JSON with name, description, version, author
- **_sections.md**: Heading-based (## N. Title (prefix)), NOT table format
- **_template.md**: YAML frontmatter + Markdown with Incorrect/Correct/Why sections
- **Rule file**: Same format as _template.md, filled with actual content
- **metadata.json**: JSON with version, author, date, abstract, references
- **SKILL.md**: YAML frontmatter + slim index with Quick Reference table
- **Marketplace entry**: JSON object with name, source, version

## Edge Cases

### 1. Source skill has no clear rules (workflow-only)

**Scenario:** Skill describes a process/workflow but lacks discrete rules with examples.

**Solution:**
- Ask user: "This skill is workflow-focused. Should I create a traditional skill (no rules/) or extract principles as rules?"
- If traditional skill: Skip rules/ directory, create standalone SKILL.md with full content
- If extract rules: Work with user to identify checkpoints/principles that can become rules

### 2. Plugin name already exists

**Scenario:** `plugins/[plugin-name]` already has a skill with different name.

**Solution:**
- Add to existing plugin under `skills/[new-skill-name]/`
- Skip plugin.json creation
- Update marketplace entry version (bump patch: 1.0.0 → 1.0.1)

### 3. Source skill has references/assets

**Scenario:** Original skill references external files, images, or documentation.

**Solution:**
- Copy assets to `plugins/[plugin-name]/skills/[skill-name]/assets/`
- Update references in rule files to relative paths
- Add asset files to git

### 4. Unclear section boundaries

**Scenario:** Rules don't naturally group into sections.

**Solution:**
- Propose flat structure with single section: "Core Patterns" (prefix: `core-`)
- Present to user with alternative groupings
- Let user decide on final structure

### 5. Too many rules (>50)

**Scenario:** Source skill would create 50+ rule files.

**Warning to user:**
```
This skill would generate [N] rules. Consider:
1. Splitting into multiple plugins (by sub-topic)
2. Combining related rules
3. Keeping only high-impact rules (CRITICAL/HIGH)

Recommendation: Plugins with >30 rules become hard to navigate.
```

### 6. No examples in source

**Scenario:** Source skill is purely descriptive, no code examples.

**Solution:**
- Ask user: "Should I synthesize examples from descriptions, or skip this rule?"
- If synthesize: Create minimal examples based on rule description
- If skip: Note in validation report which rules lack examples

## Example Conversion

**Before (monolithic skill):**

```markdown
---
name: react-hooks
description: Best practices for React hooks
---

# React Hooks Best Practices

...

**Always use dependency arrays in useEffect**

Forgetting dependencies causes stale closures.

Bad:
```tsx
useEffect(() => { console.log(count) }); // Missing deps
```

Good:
```tsx
useEffect(() => { console.log(count) }, [count]);
```

**Never call hooks conditionally**
...
```

**After (plugin structure):**

```
plugins/tech-react/skills/react-patterns/
├── rules/
│   ├── _sections.md
│   ├── _template.md
│   ├── hooks-dependency-array.md
│   ├── hooks-no-conditional.md
│   └── ...
├── metadata.json
└── SKILL.md
```

**`rules/hooks-dependency-array.md`:**
```markdown
---
title: Always Specify useEffect Dependencies
impact: HIGH
tags: hooks, useEffect, dependencies, stale-closure
---

## Always Specify useEffect Dependencies

Missing dependency arrays cause stale closures and subtle bugs.

**Incorrect:**

```tsx
useEffect(() => {
  console.log(count); // Will always log initial count
}); // ❌ Missing dependency array
```

**Correct:**

```tsx
useEffect(() => {
  console.log(count); // Logs current count
}, [count]); // ✅ Dependencies specified
```

**Why it matters:** Omitting the dependency array causes the effect to run on every render. Omitting dependencies from the array causes stale closures where the effect references old values.
```

## Usage Example

**User:** "Convert my swift-concurrency skill to a plugin"

**Claude:**
1. Reads `~/.claude/skills/swift-concurrency/SKILL.md`
2. Identifies 15 rules across 3 sections (async/await, actors, tasks)
3. Determines classification: `tech-ios` (Swift-specific)
4. Presents structure:
   ```
   Plugin: tech-ios
   Skill: ios-patterns (existing, will add section)

   New section: Swift Concurrency (prefix: concurrency-)
   Rules:
   - concurrency-async-await-naming.md
   - concurrency-actor-isolation.md
   - concurrency-task-cancellation.md
   ...

   Total: 15 rules
   ```
5. User approves
6. Creates files under `plugins/tech-ios/skills/ios-patterns/rules/concurrency-*.md`
7. Updates `_sections.md` to add "Swift Concurrency" section
8. Validates structure
9. Reports success

**User:** "Transform my database-schema skill into ai-toolkit format"

**Claude:**
1. Reads skill
2. Classifies as `platform-database` (generic patterns, not DB-specific)
3. Extracts 8 rules (normalization, indexing, constraints, naming)
4. Creates new plugin with single skill: `database-patterns`
5. Validates
6. Registers in marketplace

## Final Checklist

Before marking conversion complete, verify:

- [ ] All rule files have valid frontmatter (title, impact, tags)
- [ ] All rules have Incorrect and Correct examples
- [ ] All rules have "Why it matters" section
- [ ] Section prefixes match rule filenames
- [ ] `_sections.md` uses heading format (not table)
- [ ] `metadata.json` has accurate abstract and rule count
- [ ] `SKILL.md` is slim index (not full content)
- [ ] Plugin registered in `marketplace.json`
- [ ] All validation checks pass

**Success message:**
```
✅ Plugin created: plugins/[plugin-name]
✅ Skill: [skill-name]
✅ Rules: [N] rules across [M] sections
✅ Validation: All checks passed

Next steps:
1. Review generated rules for accuracy
2. Add references to metadata.json if needed
3. Test by loading the plugin in a project
```
