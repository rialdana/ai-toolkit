---
title: No Cross-Slice Imports
impact: MEDIUM
tags: architecture, coupling, events
---

## No Cross-Slice Imports

Slices should not import from other slices. Use events or background jobs for cross-cutting behavior.

**Incorrect (cross-slice imports):**

```typescript
// features/invitations/accept/accept.procedure.ts
import { createMembership } from '@/features/members/create/create.repository';
import { sendWelcomeEmail } from '@/features/notifications/email';
import { trackEvent } from '@/features/analytics/track';

export const acceptInvitation = protectedProcedure
  .mutation(async ({ ctx, input }) => {
    const invitation = await findByToken(ctx.db, input.token);

    // Directly calling into other slices - tight coupling!
    await createMembership(ctx.db, { ... });
    await sendWelcomeEmail(invitation.email);
    await trackEvent('invitation_accepted', { ... });
  });
```

**Correct (events or shared services):**

```typescript
// features/invitations/accept/accept.procedure.ts
import { events } from '@/shared/events';

export const acceptInvitation = protectedProcedure
  .mutation(async ({ ctx, input }) => {
    const invitation = await findByToken(ctx.db, input.token);

    await ctx.db.transaction(async (tx) => {
      await markAccepted(tx, invitation.id);
      await insertMembership(tx, { ... }); // Same slice or shared
    });

    // Other slices react to the event
    await events.emit('invitation.accepted', {
      invitationId: invitation.id,
      userId: ctx.session.user.id,
    });
  });

// Or use background jobs for async work
await tasks.trigger('send-welcome-email', {
  email: invitation.email,
  userName: ctx.session.user.name,
});
```

**Why it matters:** Cross-slice imports create tight coupling. Changes to one slice break others. Events decouple slices - the invitation slice doesn't need to know about notifications or analytics.
