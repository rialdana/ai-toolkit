---
title: Organize by Feature, Not by Type
impact: MEDIUM
tags: organization, architecture, maintainability
---

## Organize by Feature, Not by Type

Group related code by feature/domain rather than by file type.

**Incorrect (organized by type):**

```
src/
  components/
    UserCard.tsx
    UserList.tsx
    EventCard.tsx
    EventList.tsx
  hooks/
    useUser.ts
    useEvents.ts
  services/
    userService.ts
    eventService.ts
  types/
    user.ts
    event.ts
```

**Correct (organized by feature):**

```
src/
  features/
    users/
      user-card.tsx
      user-list.tsx
      use-user.ts
      user.types.ts
    events/
      event-card.tsx
      event-list.tsx
      use-events.ts
      event.types.ts
  shared/
    components/
      button.tsx
      card.tsx
    hooks/
      use-debounce.ts
```

**Benefits of feature-based:**

- Related code is colocated
- Easy to find everything for a feature
- Features can be moved/deleted as a unit
- Clear boundaries between features

**shared/ contains:**

- UI primitives (Button, Input, Card)
- Utility hooks (useDebounce, useLocalStorage)
- Common types and utilities
- Anything used by 2+ features

**Why it matters:**
- "Where's the code for users?" → look in users/
- Changes to a feature touch one folder
- New developers find code faster
- Easier to see feature complexity at a glance
