---
layout: post
title: "Making Claude Code Yours"
date: 2026-02-11
author: "Pedro Guimarães"
author_github: "0x7067"
excerpt: "Claude Code is surprisingly personal. Here are 7 ways to make it feel like your own — from what it says while thinking to how it writes code."
---

Most people install Claude Code and start using it as-is. That's fine — it works well out of the box. But there's a whole layer of personalization that most people never touch, and it makes a real difference in how the tool feels day to day. Here's what you can change.

**1. The status line.** That bar at the bottom of your terminal? It's fully customizable. You can make it show your current model, git branch, context window usage, session cost, lines added/removed — whatever matters to you. The fastest way to set it up is with the `/statusline` command. Run it without arguments to see the default, or describe what you want:
```
/statusline show model name, git branch, and context percentage
```

Claude generates a shell script and wires it into your settings automatically. If you want full control, point it at your own script in `settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

Here's [mine](https://gist.github.com/0x7067/dde056c2ee56353a4c889a4ab3d111e2):

![Custom statusline showing model, project, branch, context usage, and file changes]({{ site.baseurl }}/assets/images/posts/statusline.png)

If you want something more complex, you can check projects such as [CCometixLine](https://github.com/Haleclipse/CCometixLine) and [ccstatusline](https://github.com/sirmalloc/ccstatusline).

**2. Spinner verbs.** While Claude is working, you see little verbs cycling in the terminal — "Thinking", "Working", and so on. You can replace them. Add this to your `settings.json`:

```json
{
  "spinnerVerbs": {
    "mode": "replace",
    "verbs": ["Pondering", "Brewing", "Conjuring", "Manifesting"]
  }
}
```

Use `"mode": "append"` to add yours to the defaults, or `"replace"` to use only yours. Give it a personal touch by adding your own verbs.

Example prompt: "I want my spinner verbs to be Star Wars related"

**3. Language.** One line in `settings.json`:

```json
{
  "language": "spanish"
}
```

Claude responds in that language. That's it. Works with any language — Japanese, Portuguese, French, whatever you think in.

**4. Output style.** This controls how Claude structures its responses. Run `/output-style` to pick from the built-ins: **Default** (standard engineering assistant), **Explanatory** (adds educational insights between tasks), and **Learning** (collaborative mode with `TODO(human)` markers for you to implement yourself).

You can also have custom styles. Drop a markdown file in `~/.claude/output-styles/` and it shows up in the picker:

```markdown
---
name: No yapping
description: Minimal output, no fluff
keep-coding-instructions: true
---

Sacrifice grammar for the sake of conciseness. No preambles, no summaries, no "let me help you with that".
```

**5. Ctrl+G to edit in your editor.** When your prompt is getting long or you want to think more carefully about what you're asking, press `Ctrl+G`. It opens your current input in your `$EDITOR` — Vim, VS Code, whatever you have set. Write your prompt there, save and close, and it lands back in the chat input. It's pretty useful for saving a prompt or editing a long prompt in a more comfortable environment.

**6. Notifications.** When Claude finishes a long task, you probably want to know about it without staring at the terminal. If you're on iTerm2, enable alerts under Preferences → Profiles → Terminal. It works with Ghostty also. For something more custom, you can set up a notification hook that runs any shell command when Claude needs your attention — a macOS alert, a sound, a Slack ping, whatever fits your workflow.

You can also set `"showTurnDuration": true` in settings to see how long each response took — useful for staying aware of cost and complexity.

**7. CLAUDE.md and rules files.** This is the deepest form of personalization. While the other items change how Claude looks and feels, this one changes how it thinks.

`CLAUDE.md` is a markdown file that Claude reads at the start of every session. You can place it in different locations depending on scope:

- `~/.claude/CLAUDE.md` — your global preferences, applied to every project
- `./CLAUDE.md` or `.claude/CLAUDE.md` — project-level instructions, shared with your team via git
- `./CLAUDE.local.md` — project-level but personal, not committed

For anything beyond a handful of rules, use the `rules/` directory instead. Create focused files by concern:

```
~/.claude/rules/
├── coding-style.md
├── git-workflow.md
├── security.md
└── testing.md
```

Claude loads them all automatically. You can also scope rules to specific file paths using frontmatter:

```markdown
---
paths:
  - "src/api/**/*.ts"
---

# API Rules
- All endpoints must validate input with Zod
- Return consistent error shapes
```

Rules without `paths` apply everywhere. Rules with `paths` only activate when Claude is working on matching files.

Between global CLAUDE.md, project CLAUDE.md, rules files, and local overrides, you can build a layered system where Claude understands your coding standards, your team's conventions, and your personal preferences.

---

None of this takes long to set up, and most of it you only do once. Start with a small thing that either annoys you or will bring you joy.

As always, you can ask Claude to help you out if you need it.
