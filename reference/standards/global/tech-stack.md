## Tech stack

### Monorepo & Tooling

- **Package Manager:** pnpm (`pnpm` for all package operations, never npm/yarn)
- **Monorepo Orchestration:** Turborepo
- **Linting/Formatting:** Biome (`pnpm check` for lint + format)
- **Language:** TypeScript (strict mode)

### Server (apps/server)

- **HTTP Framework:** Hono
- **API Layer:** tRPC v11
- **Background Jobs:** Trigger.dev
- **Email:** Resend + React Email

### Web (apps/web)

- **Meta-Framework:** TanStack Start
- **Routing:** TanStack Router
- **Data Fetching:** TanStack Query + tRPC
- **Forms:** TanStack Form
- **Build Tool:** Vite

### Mobile (apps/native)

- **Framework:** Expo SDK 54
- **Runtime:** React Native 0.81
- **Styling:** Tailwind (via uniwind)
- **UI Components:** HeroUI Native

### Frontend Shared

- **UI Framework:** React 19
- **CSS Framework:** Tailwind CSS v4
- **Component Library:** shadcn/ui (do not install Radix primitives directly)
- **State Management:** Zustand
- **Icons:** Lucide React

### Database & Storage

- **Database:** PostgreSQL (Neon serverless)
- **ORM:** Drizzle ORM
- **Migrations:** drizzle-kit

### Authentication

- **Auth Library:** Better-Auth
- **Mobile Auth:** @better-auth/expo

### Testing & Quality

- **Test Framework:** Vitest
- **E2E Testing:** (TBD)

### Deployment & Infrastructure

- **Hosting:** Railway
- **CI/CD:** GitHub Actions

### Third-Party Services

- **Email:** Resend
- **Payments:** Stripe
- **Monitoring:** Sentry
