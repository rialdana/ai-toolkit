---
title: Start with Local State
impact: HIGH
tags: state, simplicity, components
---

## Start with Local State

Start with component-local state. Only lift state up or use global state when actually needed.

**Incorrect (premature global state):**

```typescript
// Bad - global store for simple toggle
const useUIStore = create((set) => ({
  isModalOpen: false,
  setModalOpen: (open) => set({ isModalOpen: open }),
}));

function Modal() {
  const { isModalOpen, setModalOpen } = useUIStore();
  // Overkill for component-local UI state
}
```

**Correct (local state first):**

```typescript
// Good - local state for component-specific UI
function Modal() {
  const [isOpen, setIsOpen] = useState(false);
  // Simple, self-contained, no external dependencies
}

// Lift when siblings need it
function ParentComponent() {
  const [selectedId, setSelectedId] = useState<string | null>(null);
  return (
    <>
      <ItemList onSelect={setSelectedId} />
      <ItemDetail id={selectedId} />
    </>
  );
}
```

**When to use each approach:**

| Scope | Solution |
|-------|----------|
| Single component | Local state (`useState`) |
| Parent + children | Props down, callbacks up |
| Siblings | Lift to common parent |
| Distant components | Context or global store |
| Server data | Query library (TanStack Query) |

**Why it matters:**
- Local state is simpler to understand and debug
- Global state creates hidden dependencies
- Over-architecting simple features wastes time
- Performance - local updates don't trigger global re-renders
