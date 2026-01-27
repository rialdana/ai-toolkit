---
title: Distribute as Single Binary When Possible
impact: MEDIUM
tags: distribution, installation, ux
---

## Distribute as Single Binary When Possible

Compile to a single binary when the language supports it (Go, Rust). This simplifies installation, updates, and uninstallation.

**Incorrect (scattered files, complex installation):**

```bash
# Multiple files scattered across system
mycli install
# Installing to:
#   /usr/local/bin/mycli
#   /usr/local/lib/mycli/core.so
#   /usr/local/lib/mycli/plugins/
#   /usr/local/share/mycli/templates/
#   /etc/mycli/config.yaml
#   ~/.mycli/cache/
# Installation complete

# Uninstall is manual and error-prone
# Which files do I remove? Easy to leave behind debris
```

**Correct (single binary, clean installation):**

```bash
# Single binary (Go, Rust)
curl -L https://github.com/user/mycli/releases/latest/download/mycli-linux-amd64 -o mycli
chmod +x mycli
sudo mv mycli /usr/local/bin/
# Done - one file

# Uninstall is trivial
sudo rm /usr/local/bin/mycli
# Config cleanup (optional)
rm -rf ~/.config/mycli

# Distribution by language
# Go: Single binary (best option)
go build -o mycli main.go

# Rust: Single binary (best option)
cargo build --release

# Python: pipx (isolated environment)
pipx install mycli
# Or single file with PyInstaller
pyinstaller --onefile mycli.py

# Node.js: npm global install
npm install -g mycli
# Or npx (no install)
npx mycli

# Ruby: gem install
gem install mycli
```

**Why it matters:** Single binaries eliminate dependency hell, version conflicts, and incomplete installations. Users can download and run immediately. Uninstallation is one command. Updates are atomic (replace file). This reduces support burden significantly.

Reference: [clig.dev - Distribution](https://clig.dev/#distribution)
