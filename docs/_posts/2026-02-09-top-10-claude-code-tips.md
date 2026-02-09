---
layout: post
title: "Top 10 Claude Code Tips for Newcomers"
date: 2026-02-09
excerpt: "The most impactful things you can do to turn Claude from a generic assistant into one that follows your coding standards, patterns, and preferences every single session."
---

**1. Set up CLAUDE.md files to shape Claude's behavior.** Drop a `CLAUDE.md` in `~/.claude/` for global instructions or in any project root for project-specific ones. This is the single most impactful thing you can do — it turns Claude from a generic assistant into one that follows your coding standards, patterns, and preferences every single session.

**2. Use the `~/.claude/rules/` directory to organize instructions by concern.** Instead of cramming everything into one file, split rules into focused files like `coding-style.md`, `security.md`, and `testing.md`. Claude loads them all automatically, and you can scope project-level rules to specific file paths using YAML frontmatter.

**3. Install skills to give Claude specialized knowledge.** Skills are reusable prompt packs you invoke with slash commands (like `/promptify` or `/commit`). Discover and install community skills from GitHub repos using `/find-skills` (from [vercel-labs/skills](https://github.com/vercel-labs/skills)), or create your own with `/agent-skill-creator`. Popular sources include [callstackincubator](https://github.com/callstackincubator/agent-skills), [intellectronica](https://github.com/intellectronica/agent-skills), and [vercel-labs](https://github.com/vercel-labs/agent-skills). Here at Ravn, we maintain our own shared skills — like `core-coding-standards`, `lang-typescript`, and `agent-skill-creator` — in our [ai-toolkit repo](https://github.com/ravnhq/ai-toolkit). Install them with `/install-skill ravnhq/ai-toolkit`.

**4. Configure hooks to enforce guardrails automatically.** Hooks are shell scripts that run before/after tool calls or on stop events. Use them to block unsafe patterns (like secret leaks in commits), sync with external tools, or trigger notifications — all without manual intervention.

**5. Lock down permissions with denied paths and allowed commands.** In your settings, explicitly deny access to sensitive paths (`.env`, `~/.ssh/`, `~/.aws/`) and whitelist only the bash commands you need. This lets you grant Claude more autonomy on safe operations while keeping secrets untouchable.

**6. Add MCP servers for extended capabilities.** MCP servers give Claude access to web search, documentation lookup, and other tools that run as background services. Start with `context7` for library docs and a web search server — they pay for themselves the first time Claude needs to check current API syntax.

**7. Learn the slash commands that save you time.** Claude Code has built-in commands that keep you in flow: `/compact` summarizes and shrinks your context when it gets long, `/clear` starts fresh, `/model` switches between Opus, Sonnet, and Haiku mid-session, and `/cost` shows you what you've spent. Skill-based commands like `/commit` and `/review-pr` turn multi-step workflows into a single invocation.

**8. Use Plan Mode for non-trivial tasks.** Before jumping into code, type your request and let Claude explore the codebase and propose a plan first. Review and approve it before any edits happen. This prevents wasted work and misaligned implementations, especially on multi-file changes.

**9. Customize your status line and spinner for better awareness.** A custom status line showing your model, git branch, and context window usage helps you stay oriented during long sessions. And yes, you can replace the default spinner verbs with whatever brings you joy.

**10. Build your `memory/` directory over time.** Claude has persistent memory at `~/.claude/projects/<project>/memory/`. As you work, it records patterns, mistakes, and project-specific knowledge that carries over between sessions. The more you use it, the less you repeat yourself.

---

Got a skill idea, a useful CLAUDE.md rule, or a hook that saved you time? Contribute it to our shared repo at [github.com/ravnhq/ai-toolkit](https://github.com/ravnhq/ai-toolkit). Any contribution is welcome — whether it's a full skill, a bug fix, or just a better prompt. The more we share, the better Claude works for all of us.

**P.S.** You don't have to set all of this up by hand — Claude itself can help. Ask it to create a CLAUDE.md, write a hook, scaffold a skill, or configure your rules directory. Most of the tips above are one prompt away.
