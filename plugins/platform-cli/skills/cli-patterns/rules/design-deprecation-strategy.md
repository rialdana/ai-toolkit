---
title: Deprecate Features with Clear Migration Path
impact: HIGH
tags: breaking-changes, versioning, ux
---

## Deprecate Features with Clear Migration Path

When changing or removing features, announce deprecation at least 6 months before removal, show warnings on every use, provide exact replacement commands, and support both old and new simultaneously.

**Incorrect (breaks users without warning):**

```bash
# Version 1.0: Has --target flag
mycmd deploy --target prod

# Version 2.0: Removes flag with no warning
mycmd deploy --target prod
# Error: Unknown flag --target
# No guidance on what to use instead
```

**Correct (gradual deprecation with migration path):**

```bash
# Version 1.0: Original behavior
mycmd deploy --target prod

# Version 2.0: Deprecation warning (6+ months before removal)
mycmd deploy --target prod
# ⚠️  Warning: --target is deprecated. Use --environment instead.
#    The --target flag will be removed in v3.0.
#    Update your command to: mycmd deploy --environment prod

# Version 2.x: Support both (no warning if new flag used)
mycmd deploy --environment prod  # ✅ No warning

# Version 3.0: Remove old flag with helpful error
mycmd deploy --target prod
# ❌ Error: Flag --target was removed in v3.0.
#    Use --environment instead: mycmd deploy --environment prod
```

**Why it matters:** Breaking changes without migration paths destroy user trust and create emergency firefighting for teams using your tool. Gradual deprecation with clear warnings gives users time to update scripts and automation at their own pace. Providing exact replacement commands reduces friction and support burden.

Reference: [clig.dev - Robustness](https://clig.dev/#robustness)
