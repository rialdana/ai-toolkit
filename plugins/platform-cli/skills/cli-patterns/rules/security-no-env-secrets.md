---
title: Never Read Secrets from Environment Variables
impact: CRITICAL
tags: security, secrets, environment
---

## Never Read Secrets from Environment Variables

Never read passwords, tokens, or other secrets from environment variables. Use files, stdin, or secret managers instead.

**Incorrect (secrets in env vars - visible to all processes):**

```bash
# Secrets visible in ps output
export MYCLI_API_TOKEN=super-secret-token-12345
mycli deploy

# User runs ps
ps auxe | grep mycli
# Shows: MYCLI_API_TOKEN=super-secret-token-12345

# Secrets inherited by all child processes
export DATABASE_PASSWORD=hunter2
mycli run-script
# script.sh and all its children can see DATABASE_PASSWORD

# Secrets in shell history
export API_KEY=abc123
# Now in ~/.bash_history forever
```

**Correct (secrets from files, stdin, or secret managers):**

```bash
# Read from file
echo "super-secret-token" > ~/.mycli/token
chmod 600 ~/.mycli/token
mycli deploy --token-file ~/.mycli/token

# Read from stdin
echo "super-secret-token" | mycli deploy --token-stdin
# Or
mycli deploy --token-stdin < ~/.mycli/token

# Read from secret manager
mycli deploy --token-from-vault secret/mycli/token

# Prompt interactively (hidden input)
mycli deploy
# Enter API token: ••••••••••••

# Implementation example
if (flags.tokenFile) {
    token = fs.readFileSync(flags.tokenFile, 'utf8').trim();
    fs.chmodSync(flags.tokenFile, 0o600); // Warn if too permissive
} else if (flags.tokenStdin) {
    token = fs.readFileSync(0, 'utf8').trim(); // fd 0 = stdin
} else {
    // Prompt with hidden input
    token = await promptSecret('Enter API token:');
}
```

**Why it matters:** Environment variables are visible in `ps` output to all users, inherited by all child processes, appear in error logs and crash dumps, and often get exported globally in shell profiles. This makes them unsuitable for secrets. Files with proper permissions (600) or secret managers provide actual security.

Reference: [OWASP - Secrets in Environment Variables](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html) and [clig.dev - Environment variables](https://clig.dev/#environment-variables)
