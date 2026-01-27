---
title: Make Telemetry Opt-In with Clear Privacy Policy
impact: CRITICAL
tags: security, privacy, telemetry, analytics
---

## Make Telemetry Opt-In with Clear Privacy Policy

If collecting usage data, make it opt-in by default, show exactly what's collected, link to privacy policy, and provide easy opt-out.

**Incorrect (silent telemetry, unclear data collection):**

```bash
# Starts collecting data without asking
mycli init
# [Silently sends: commands used, file paths, error messages, IP address]

# No way to see what's collected
mycli status
# Is this sending data? What data?

# No way to opt out
mycli --no-telemetry
# Error: unknown flag

# Vague privacy policy
# "We may collect usage data to improve the product"
# What data? For how long? Can it identify me?
```

**Correct (opt-in, transparent, controllable):**

```bash
# First run: clear opt-in prompt
mycli init
# Would you like to help improve mycli by sending anonymous usage data?
# This helps us prioritize features. You can change this anytime.
#
# We collect:
#   - Commands used (not argument values)
#   - Success/error status (not error messages)
#   - OS and architecture
#   - Tool version
#
# We do NOT collect:
#   - File paths or names
#   - Error messages or stack traces
#   - Environment variables
#   - IP addresses (stored after geolocation)
#
# Privacy policy: https://example.com/privacy
# Data retention: 90 days
#
# Send anonymous usage data? [y/N]: _

# Easy opt-out anytime
mycli telemetry disable
# Telemetry disabled. No data will be sent.

# Check status
mycli telemetry status
# Telemetry: enabled
# Last sent: 2026-01-27 14:30:22
# Data: https://example.com/privacy

# Minimal data collection
# ✅ Safe to collect:
#   - Command names (not values)
#   - Flag names (not values)
#   - Success/error boolean
#   - OS, architecture, version
#   - Country (via IP, then discard IP)
#
# ❌ Never collect:
#   - Argument/flag values
#   - Error messages
#   - File paths
#   - Environment variables
#   - IP addresses (retain after geo)
```

**Why it matters:** Silent telemetry violates user trust and privacy. Developers deserve to know what's being collected and have control over it. Opt-in (not opt-out) respects privacy by default. Clear disclosure of exactly what's collected and retained builds trust.

Reference: [clig.dev - Analytics](https://clig.dev/#analytics) and [GDPR Principles](https://gdpr-info.eu/art-5-gdpr/)
