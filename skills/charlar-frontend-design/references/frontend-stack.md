# Frontend Stack

## Repos in scope

- `app.charlarapp.com`: learner SPA with `wouter`, React Query, shared-ui, shared contracts, and grading helpers
- `admin.charlarapp.com`: admin SPA with lazy route loading, React Query, shared-ui, and shared contracts
- `charlarapp.com`: marketing/support/legal site with a simple pathname switch instead of a router
- `shared-ui-charlarapp`: reusable Radix/Tailwind primitives, utilities, and shared CSS entrypoints

## Common stack

- React 18
- Vite 6
- TypeScript 5.6
- Tailwind CSS 3.4
- Local linked packages to `../shared-charlarapp` and `../shared-ui-charlarapp`

## Shared package usage

- Use `@charlar/shared-ui` for primitives and shared styles that appear in more than one frontend.
- Use `@charlar/shared` for shared types, plan/pricing metadata, feature flags, and utilities.
- Use `@charlar/grading` only where learner app flows need grading behavior.

## Repo-specific notes

- `app.charlarapp.com` bootstraps CSRF-aware fetch and optional Sentry in `src/main.tsx`, and its route shell lives in `src/App.tsx`.
- `admin.charlarapp.com` keeps route structure in `src/App.tsx` and sidebar metadata in `src/constants/nav-items.ts`.
- `charlarapp.com` routes in `src/main.tsx` without a dedicated router package.
- `shared-ui-charlarapp` exports component primitives from `ui/`, helpers from `utils/`, and styles from `styles/`.

## Default validation

```bash
cd app.charlarapp.com && yarn lint && yarn build
cd admin.charlarapp.com && yarn lint && yarn build
cd charlarapp.com && yarn lint && yarn build
cd shared-ui-charlarapp && yarn lint && yarn typecheck
```
