---
title: Use UPPERCASE_WITH_UNDERSCORES and App Prefix for Environment Variables
impact: MEDIUM
tags: environment, naming, conventions
---

## Use UPPERCASE_WITH_UNDERSCORES and App Prefix for Environment Variables

Environment variable names should be UPPERCASE with underscores, prefixed with your app name to avoid collisions.

**Incorrect (wrong case, no prefix, potential collisions):**

```bash
# Wrong case (lowercase/mixed)
export debug=1              # Should be uppercase
export MyApp_Setting=value  # Mixed case

# No app prefix (collides with other tools)
export DEBUG=1              # Too generic
export HOST=api.example.com # Too generic
export PORT=3000            # Too generic

# Using dashes instead of underscores
export MY-APP-API-URL=...   # Invalid in some shells
```

**Correct (uppercase, underscores, prefixed):**

```bash
# Proper format: APPNAME_COMPONENT_SETTING
export MYCLI_DEBUG=1
export MYCLI_API_URL=https://api.example.com
export MYCLI_API_TOKEN=...
export MYCLI_NO_COLOR=1
export MYCLI_CONFIG_DIR=~/.config/mycli

# Multi-word apps use underscores
export DOCKER_COMPOSE_FILE=docker-compose.yml
export GIT_EDITOR=vim

# Examples from real tools
DOCKER_HOST=unix:///var/run/docker.sock
NPM_TOKEN=...
AWS_REGION=us-east-1
GITHUB_TOKEN=...
```

**Why it matters:** Environment variables are global and shared across all processes. Without prefixes, generic names like DEBUG or PORT collide with other tools. Lowercase names aren't valid in some shells. The APPNAME_SETTING pattern is a widely-recognized convention that prevents collisions.

Reference: [clig.dev - Environment variables](https://clig.dev/#environment-variables)
