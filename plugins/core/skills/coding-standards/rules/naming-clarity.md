---
title: Descriptive Names Over Abbreviations
impact: HIGH
tags: naming, readability, clarity
---

## Descriptive Names Over Abbreviations

Prefer full words over abbreviations. Code is read more than written. `getUserById` not `getUsrById`.

**Incorrect (cryptic abbreviations):**

```typescript
function calcTtlPrc(itms: Itm[]): number {
  return itms.reduce((acc, itm) => acc + itm.prc * itm.qty, 0);
}

const usrMgr = new UsrMgr();
const cfg = loadCfg();
```

**Correct (clear names):**

```typescript
function calculateTotalPrice(items: Item[]): number {
  return items.reduce((total, item) => total + item.price * item.quantity, 0);
}

const userManager = new UserManager();
const config = loadConfig();
```

**Acceptable abbreviations:**

- `ctx` (context)
- `db` (database)
- `id` (identifier)
- `props` (properties)
- `req`, `res` (request, response)
- `env` (environment)
- `config` (configuration)

**Why it matters:** Cryptic names force readers to decode intent repeatedly. This adds up to significant time waste across a team.
