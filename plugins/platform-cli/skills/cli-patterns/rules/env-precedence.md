---
title: Follow Precedence Order - Flags > Env Vars > Config Files > Defaults
impact: HIGH
tags: environment, config, precedence
---

## Follow Precedence Order: Flags > Env Vars > Config Files > Defaults

Configuration should follow a clear precedence order: command-line flags override environment variables, which override config files, which override built-in defaults.

**Incorrect (unclear or inconsistent precedence):**

```bash
# Config file overrides flag (backwards!)
mycli deploy --environment staging
# Uses 'production' from config file, ignoring flag

# No way to override config file
# Config: api_url: https://prod.example.com
mycli deploy --api-url https://dev.example.com
# Error: --api-url not supported (must edit config file)

# Environment variable ignored
MYCLI_TIMEOUT=30 mycli run
# Uses 10s from config, ignoring env var
```

**Correct (clear precedence order):**

```bash
# Precedence order (highest to lowest):
# 1. Command-line flags
# 2. Environment variables
# 3. Project config file (.mycli.yaml in current dir)
# 4. User config file (~/.config/mycli/config.yaml)
# 5. System config file (/etc/mycli/config.yaml)
# 6. Built-in defaults

# Example: Flag overrides everything
mycli deploy --environment staging
# Uses 'staging' (from flag)
# Ignores MYCLI_ENVIRONMENT env var
# Ignores environment: production in config

# Example: Env var overrides config
MYCLI_ENVIRONMENT=staging mycli deploy
# Uses 'staging' (from env var)
# Ignores environment: production in config

# Example: Config overrides defaults
# Config: timeout: 30
mycli run
# Uses 30s (from config)
# Ignores built-in default of 10s

# Example: Show effective configuration
mycli config show
# environment: staging (from flag --environment)
# timeout: 30 (from config file ~/.config/mycli/config.yaml)
# verbose: false (default)
```

**Why it matters:** Users need predictable configuration resolution. Flags should always win (for quick overrides), env vars enable per-session config (CI/CD), and config files provide stable defaults. Unclear precedence causes confusion and makes debugging difficult.

Reference: [clig.dev - Configuration](https://clig.dev/#configuration)
