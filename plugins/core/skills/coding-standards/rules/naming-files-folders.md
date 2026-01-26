---
title: Consistent File and Folder Naming
impact: HIGH
tags: naming, files, organization
---

## Consistent File and Folder Naming

Use a single, consistent naming convention for all files and folders. Pick one (kebab-case recommended for web projects) and enforce it everywhere.

**Incorrect (mixed conventions):**

```
src/
  UserProfile/
    UserProfile.tsx
    userProfile.test.ts
  signIn/
    SignInForm.tsx
  API_handlers/
    get_users.ts
```

**Correct (consistent kebab-case):**

```
src/
  user-profile/
    user-profile.tsx
    user-profile.test.ts
  sign-in/
    sign-in-form.tsx
  api-handlers/
    get-users.ts
```

**Why it matters:** Inconsistent naming forces developers to guess or look up conventions. It creates friction in imports and makes the codebase feel unprofessional.

**Note:** Different ecosystems have different conventions. iOS uses PascalCase, Python uses snake_case. The key is consistency within your project.
