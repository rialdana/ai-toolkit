---
title: Prefer UNION ALL Over UNION
impact: LOW
tags: query, performance, union
---

## Prefer UNION ALL Over UNION

UNION removes duplicates (expensive); UNION ALL keeps all rows (fast).

**Incorrect (unnecessary deduplication):**

```sql
-- UNION sorts and deduplicates - expensive
SELECT id, message FROM email_notifications WHERE user_id = 123
UNION
SELECT id, message FROM sms_notifications WHERE user_id = 123;
```

**Correct (no deduplication overhead):**

```sql
-- UNION ALL is faster when duplicates don't matter
SELECT id, message, 'email' as type
FROM email_notifications WHERE user_id = 123
UNION ALL
SELECT id, message, 'sms' as type
FROM sms_notifications WHERE user_id = 123
ORDER BY created_at DESC;
```

**Why it matters:** UNION must sort the entire result set to find and remove duplicates. UNION ALL simply concatenates results. When you know results won't have duplicates (different tables, different ID spaces), UNION ALL avoids unnecessary work.

Reference: [UNION vs UNION ALL](https://www.sqlshack.com/sql-union-vs-union-all-in-sql-server/)
