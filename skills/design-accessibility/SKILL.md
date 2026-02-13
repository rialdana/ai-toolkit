---
name: design-accessibility
description: WCAG AA and ARIA best practices — screen readers, keyboard navigation,
  focus management. Use when building any user-facing interface or reviewing accessibility
  compliance.
metadata:
  category: design
  tags:
  - accessibility
  - wcag
  - aria
  - a11y
  status: ready
  version: 1
---

# Principles

- Use semantic HTML first — ARIA is a last resort, not a first tool
- Proper heading hierarchy — one h1 per page, never skip levels
- Alt text on all meaningful images
- Maintain 4.5:1 minimum color contrast ratio
- Use `<button>` for actions, `<a>` for navigation — never a styled `<div>`

# Rules

See [rules index](rules/_sections.md) for detailed patterns.

## Examples

### Positive Trigger

User: "Audit this form for WCAG AA issues and keyboard traps."

Expected behavior: Use `design-accessibility` guidance, follow its workflow, and return actionable output.

### Non-Trigger

User: "Optimize SQL indexes for this analytics query."

Expected behavior: Do not prioritize `design-accessibility`; choose a more relevant skill or proceed without it.

## Troubleshooting

### Skill Does Not Trigger

- Error: The skill is not selected when expected.
- Cause: Request wording does not clearly match the description trigger conditions.
- Solution: Rephrase with explicit domain/task keywords from the description and retry.

### Guidance Conflicts With Another Skill

- Error: Instructions from multiple skills conflict in one task.
- Cause: Overlapping scope across loaded skills.
- Solution: State which skill is authoritative for the current step and apply that workflow first.

### Output Is Too Generic

- Error: Result lacks concrete, actionable detail.
- Cause: Task input omitted context, constraints, or target format.
- Solution: Add specific constraints (environment, scope, format, success criteria) and rerun.

## Workflow

1. Identify whether the request clearly matches `design-accessibility` scope and triggers.
2. Apply the skill rules and referenced guidance to produce a concrete result.
3. Validate output quality against constraints; if gaps remain, refine once with explicit assumptions.

## Project Overrides

Before applying rules from this skill, check if `.claude/overrides/design-accessibility.md` exists.

- **If it does not exist**: Create it from the template below, then inform the user.
- **If it exists**: Read it and apply its instructions over the defaults in this skill.
  Override file instructions take priority over upstream rules.

### Override Template

When creating the override file, use this content:

    # Design Accessibility — Project Overrides
    #
    # This file customizes the upstream design-accessibility skill for this project.
    # Edit freely — this file is never overwritten by skill updates.
    #
    # ## How to use
    # - **Disable a rule**: "Ignore the <rule-name> rule"
    # - **Modify a rule**: "For <rule-name>, instead do <your preference>"
    # - **Add a rule**: Write your project-specific rule directly
    #
    # Leave sections empty or delete them if you have no overrides.

    ## Disabled Rules

    (none)

    ## Modified Rules

    (none)

    ## Additional Project Rules

    (none)
