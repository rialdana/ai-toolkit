---
title: Include Uninstall Instructions in README Immediately After Install
impact: MEDIUM
tags: distribution, documentation, ux
---

## Include Uninstall Instructions in README Immediately After Install

Always provide clear uninstall instructions in your README, placed immediately after installation instructions. Include config file cleanup steps.

**Incorrect (no uninstall instructions):**

```markdown
# Installation

## Homebrew
brew install mycli

## npm
npm install -g mycli

## Manual
curl -L https://example.com/mycli -o /usr/local/bin/mycli

# Usage
...
```

**Correct (uninstall instructions right after install):**

```markdown
# Installation

## Homebrew
```bash
brew install mycli
```

## npm
```bash
npm install -g mycli
```

## Manual
```bash
curl -L https://example.com/mycli -o /usr/local/bin/mycli
chmod +x /usr/local/bin/mycli
```

# Uninstallation

## If installed via Homebrew
```bash
brew uninstall mycli
```

## If installed via npm
```bash
npm uninstall -g mycli
```

## If installed manually
```bash
sudo rm /usr/local/bin/mycli
```

## Clean up configuration files (optional)
```bash
# Remove user config
rm -rf ~/.config/mycli

# Remove cache
rm -rf ~/.cache/mycli

# List all mycli files
find ~ -name "*mycli*" 2>/dev/null
```

# Usage
...
```

**Why it matters:** Users evaluate tools by how easy they are to remove. Hidden or missing uninstall instructions create friction and reduce trust. Placing uninstall steps near install steps makes them discoverable when users need them most.

Reference: [clig.dev - Distribution](https://clig.dev/#distribution)
