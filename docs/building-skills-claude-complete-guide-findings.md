# Findings: Building Skills for Claude - Complete Guide

Source analyzed: `/Users/pedro/Documents/Obsidian/knowledge/Building Skills for Claude - Complete Guide.md`  
Source note: Anthropic PDF guide converted on 2026-02-13.

## Thematic Digest (All Findings)

### 1) Skill Fundamentals and Architecture
- A skill is a folderized instruction set for repeatable workflows.
- Skills are meant to encode reusable workflows once, then apply repeatedly with consistent results.
- A skill folder contains:
  - Required: `SKILL.md`
  - Optional: `scripts/`, `references/`, `assets/`
- Progressive disclosure is a 3-layer design:
  - YAML frontmatter (always loaded) for activation conditions.
  - `SKILL.md` body (loaded when relevant) for core workflow.
  - Linked files for deep/optional detail.
- Skills should be composable: multiple skills can load together, so instructions should not conflict.
- Skills should be portable across Claude.ai, Claude Code, and API.

### 2) Skills + MCP Positioning
- MCP provides capability/connectivity (what can be done).
- Skills provide workflow knowledge (how to do it well).
- Without skills: weak next-step guidance, inconsistent behavior, scratch-start conversations.
- With skills: automatic workflow activation, consistent tool usage, embedded best practices, lower learning curve.

### 3) Planning and Use-Case Design
- Define 2-3 concrete use cases before implementation.
- Good use-case specs include:
  - Trigger phrases/users intents
  - Ordered execution steps
  - Explicit end result
- Three common use-case categories:
  - Document/asset creation
  - Workflow automation
  - MCP enhancement

### 4) Success Criteria and Measurement
- Quantitative:
  - ~90% triggering success on 10-20 relevant prompts
  - Reduced/optimized tool-call count versus baseline
  - Zero failed API calls per workflow
- Qualitative:
  - User does not need to ask for next steps
  - Workflow completes without user correction
  - Consistent outputs across sessions

### 5) Technical Requirements and Hard Constraints
- `SKILL.md` filename must be exact and case-sensitive.
- Skill folder naming must be kebab-case.
- No `README.md` inside the skill folder.
- Minimum frontmatter includes:
  - `name`
  - `description`
- `name` rules:
  - kebab-case
  - no spaces/capitals
  - should match folder name
- `description` rules:
  - must state WHAT the skill does + WHEN to use it
  - include trigger conditions/phrases
  - <= 1024 chars
  - no XML tags / angle brackets
- Security restrictions:
  - No `<`/`>` in frontmatter
  - Names with `claude` or `anthropic` are reserved
- Optional frontmatter fields include `license`, `compatibility`, `metadata`, `allowed-tools`.

### 6) Description and Instruction Authoring
- Description template: `[What it does] + [When to use] + [Key capabilities]`.
- Good descriptions are specific and include concrete triggers.
- Bad descriptions are vague, triggerless, or overly technical.
- Recommended `SKILL.md` shape:
  - Frontmatter
  - Instructions in major numbered/stepped phases
  - Examples section
  - Troubleshooting section (`Error`, `Cause`, `Solution`)
- Writing best practices:
  - Be specific/actionable (exact commands/validations)
  - Keep critical instructions near top
  - Use progressive disclosure (`references/` for depth)
  - Include explicit error handling

### 7) Testing and Iteration
- Testing approaches:
  - Manual in Claude.ai
  - Scripted in Claude Code
  - Programmatic via skills API/evals
- Iteration recommendation:
  - Solve one challenging task first
  - Distill successful pattern into skill instructions
- Three test areas:
  - Triggering tests (positive and negative prompts)
  - Functional tests (valid output, API success, edge/error handling)
  - Performance comparison (tokens, messages, failure rate)
- `skill-creator` can help generate/format skills, suggest triggers, detect issues, and propose tests.
- Iteration diagnostics:
  - Undertriggering: add detail/keywords
  - Overtriggering: add negative triggers/scope limits
  - Execution issues: improve instructions and error handling

### 8) Distribution, Sharing, and API
- Distribution model (stated as of January 2026):
  - Individual flow: download folder -> zip -> upload in Claude.ai Skills, or place in Claude Code skills directory.
  - Organization flow: workspace-wide deployment with centralized updates.
- Organization-wide availability was noted as shipped on December 18, 2025.
- API capabilities:
  - `/v1/skills` endpoint for listing/managing skills
  - `container.skills` for attaching skills in Messages API
  - Versioning via Claude Console
  - Works with Claude Agent SDK
- Constraint: API skills require Code Execution Tool beta.
- Platform fit guidance:
  - Claude.ai / Claude Code for direct user interactions and manual test loops
  - API for programmatic apps, production scale, and automation pipelines

### 9) Positioning and Go-to-Market Guidance
- Prefer outcome-based positioning (time/value/result) over implementation details.
- Recommended sharing motion:
  - Host on GitHub
  - Document in MCP repo
  - Publish installation guide

### 10) Reusable Workflow Patterns
- Pattern 1: Sequential workflow orchestration
  - strict ordering, dependencies, validation, rollback paths
- Pattern 2: Multi-MCP coordination
  - phased flow, inter-service data passing, gate checks before next phase
- Pattern 3: Iterative refinement
  - draft -> quality check -> refinement loop -> finalization, with stop criteria
- Pattern 4: Context-aware tool selection
  - explicit decision criteria, fallbacks, transparent rationale
- Pattern 5: Domain-specific intelligence
  - embed domain/compliance knowledge beyond raw tool calls

### 11) Troubleshooting Playbook
- Upload fails:
  - verify exact `SKILL.md`
  - verify YAML `---` delimiters
  - verify kebab-case naming
- No trigger:
  - add specific trigger phrases
  - use debugging prompt: "When would you use the [skill name] skill?"
- Too many triggers:
  - add negative triggers
  - tighten scope language
- Instructions ignored:
  - reduce verbosity
  - move details to references
  - place critical instructions at top
  - replace ambiguity with explicit checks
  - use scripts for critical validation instead of pure language
- Context overload:
  - keep `SKILL.md` under 5,000 words
  - move long docs to `references/`
  - too many enabled skills (20-50+) can degrade behavior

### 12) Reference Artifacts
- Quick lifecycle checklist exists for:
  - before development
  - during development
  - before upload
  - after upload
- YAML reference defines optional fields and forbidden elements.
- Example/support pointers include partner directories, public repo, issues, and Discord.

## Atomic Checklist/Table

| # | Finding | Type | Source | Actionability |
|---|---|---|---|---|
| 1 | Skill is a folderized instruction set for repeatable tasks | Definition | Intro | Do |
| 2 | Choose path: standalone vs MCP enhancement | Strategy | Intro | Do |
| 3 | `SKILL.md` is required | Rule | Ch1 | Validate |
| 4 | `scripts/` is optional executable support | Structure | Ch1 | Do |
| 5 | `references/` is optional long-form docs | Structure | Ch1 | Do |
| 6 | `assets/` is optional templates/media | Structure | Ch1 | Do |
| 7 | Frontmatter should only contain trigger-relevance info | Best Practice | Ch1 | Do |
| 8 | Keep deep instructions in body/linked files (progressive disclosure) | Best Practice | Ch1 | Do |
| 9 | Design for multi-skill coexistence (composability) | Constraint | Ch1 | Do |
| 10 | Keep skill portable across Claude.ai/Code/API | Constraint | Ch1 | Do |
| 11 | Treat MCP as capability and skill as workflow layer | Model | Ch1 | Do |
| 12 | Start from 2-3 concrete use cases before coding | Rule | Ch2 | Do |
| 13 | Use case must include trigger, steps, and result | Rule | Ch2 | Validate |
| 14 | Document/asset skills rely on style guides/templates/checklists | Pattern | Ch2 | Do |
| 15 | Workflow automation should use validation gates/refinement loops | Pattern | Ch2 | Do |
| 16 | MCP enhancement should sequence calls with domain/error logic | Pattern | Ch2 | Do |
| 17 | Target ~90% trigger hit rate over 10-20 prompts | Metric | Ch2 | Measure |
| 18 | Measure tool-call efficiency vs no-skill baseline | Metric | Ch2 | Measure |
| 19 | Target zero failed API calls per workflow | Metric | Ch2 | Measure |
| 20 | Users should not need next-step prompting | Success | Ch2 | Validate |
| 21 | Workflows should complete without user correction | Success | Ch2 | Validate |
| 22 | Results should be consistent across sessions | Success | Ch2 | Validate |
| 23 | `SKILL.md` filename must be exact/case-sensitive | Rule | Ch2 | Validate |
| 24 | Skill folder name must be kebab-case | Rule | Ch2 | Validate |
| 25 | No `README.md` in skill folder | Rule | Ch2 | Validate |
| 26 | Frontmatter minimum is `name` + `description` | Rule | Ch2 | Validate |
| 27 | `name` must be kebab-case without spaces/caps | Rule | Ch2 | Validate |
| 28 | `description` must state what + when, with triggers | Rule | Ch2 | Validate |
| 29 | `description` must be <=1024 characters | Constraint | Ch2/RefB | Validate |
| 30 | No XML tags/angle brackets in frontmatter | Security | Ch2/RefB | Avoid |
| 31 | Names with `claude` or `anthropic` are reserved | Security | Ch2/RefB | Avoid |
| 32 | Optional frontmatter: `license`, `compatibility`, `metadata`, `allowed-tools` | Interface | Ch2/RefB | Do |
| 33 | Description formula: what + when + key capabilities | Best Practice | Ch2 | Do |
| 34 | Include concrete trigger phrases in description | Best Practice | Ch2 | Do |
| 35 | Avoid vague/missing-trigger/too-technical descriptions | Anti-pattern | Ch2 | Avoid |
| 36 | Structure instructions by explicit major steps | Best Practice | Ch2 | Do |
| 37 | Include examples section | Best Practice | Ch2 | Do |
| 38 | Include troubleshooting with error/cause/solution | Best Practice | Ch2 | Do |
| 39 | Reference bundled files explicitly | Best Practice | Ch2 | Do |
| 40 | Prefer exact commands/validations over vague wording | Best Practice | Ch2 | Do |
| 41 | Include explicit error handling paths | Best Practice | Ch2 | Do |
| 42 | Use manual, scripted, and programmatic testing as needed | Test Strategy | Ch3 | Do |
| 43 | Distill a proven single hard-task prompt flow into the skill | Iteration | Ch3 | Do |
| 44 | Run trigger tests for positive and negative prompts | Test Case | Ch3 | Validate |
| 45 | Run functional tests for output/API/error/edge coverage | Test Case | Ch3 | Validate |
| 46 | Compare token/message/failure performance vs baseline | Test Case | Ch3 | Measure |
| 47 | Use `skill-creator` for generation/formatting/triggers/tests | Tooling | Ch3 | Do |
| 48 | Undertriggering fix: add detail and keywords | Troubleshooting | Ch3 | Do |
| 49 | Overtriggering fix: add negative triggers and tighter scope | Troubleshooting | Ch3 | Do |
| 50 | Execution issues fix: improve instructions + error handling | Troubleshooting | Ch3 | Do |
| 51 | Individual distribution: zip folder and upload to Claude.ai Skills or Claude Code directory | Distribution | Ch4 | Do |
| 52 | Org-wide deployment available; centralized management/update model | Distribution | Ch4 | Do |
| 53 | Org rollout date noted as Dec 18, 2025 | Temporal Fact | Ch4 | Record |
| 54 | API supports `/v1/skills` management | API | Ch4 | Do |
| 55 | Messages API uses `container.skills` | API | Ch4 | Do |
| 56 | Version skills via Claude Console | API Ops | Ch4 | Do |
| 57 | Agent SDK supports skills workflows | API | Ch4 | Do |
| 58 | API skills require Code Execution Tool beta | Constraint | Ch4 | Validate |
| 59 | Use Claude.ai/Code for interactive/manual testing workloads | Platform Fit | Ch4 | Do |
| 60 | Use API for app integration, scale, and pipelines | Platform Fit | Ch4 | Do |
| 61 | Share via GitHub repo + MCP repo docs + install guide | Distribution | Ch4 | Do |
| 62 | Position skill by outcome/time saved, not implementation details | Messaging | Ch4 | Do |
| 63 | Sequential orchestration: step dependencies + per-step validation + rollback | Pattern | Ch5 | Do |
| 64 | Multi-MCP: phase boundaries + data handoff + pre-phase validation | Pattern | Ch5 | Do |
| 65 | Iterative refinement: draft->QA->refine->final with stop criteria | Pattern | Ch5 | Do |
| 66 | Context-aware tooling: explicit decision rules + fallback + transparency | Pattern | Ch5 | Do |
| 67 | Domain intelligence: embed compliance/domain rules before actions | Pattern | Ch5 | Do |
| 68 | Upload failure triage: filename/frontmatter delimiter/kebab-case checks | Troubleshooting | Ch5 | Validate |
| 69 | Non-trigger triage: add trigger phrases; ask Claude trigger-debug question | Troubleshooting | Ch5 | Do |
| 70 | Over-trigger triage: add negative triggers and scope constraints | Troubleshooting | Ch5 | Do |
| 71 | Ignored instruction triage: shorten, prioritize top rules, de-ambiguate, script critical checks | Troubleshooting | Ch5 | Do |
| 72 | Keep `SKILL.md` under 5,000 words | Constraint | Ch5 | Validate |
| 73 | Move long material into `references/` | Context Mgmt | Ch5 | Do |
| 74 | Too many enabled skills (20-50+) may degrade performance | Risk | Ch5 | Avoid |
| 75 | Pre-build checklist: use cases/tools/examples/folder plan | Checklist | RefA | Validate |
| 76 | Dev checklist: naming/frontmatter/description/errors/examples/references | Checklist | RefA | Validate |
| 77 | Pre-upload checklist: trigger + paraphrase + negative + functional + tool tests + zip | Checklist | RefA | Validate |
| 78 | Post-upload checklist: real-use test, trigger tuning, feedback, iteration | Checklist | RefA | Validate |
| 79 | YAML supports standard types and custom metadata | Interface | RefB | Do |
| 80 | Support/resources include `anthropics/skills`, issues tracker, Discord | Reference | RefC | Use |
