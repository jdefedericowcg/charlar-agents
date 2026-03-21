# Domain Boundaries

## Repo ownership

| Repo | Primary ownership | Keep out |
| --- | --- | --- |
| `api.charlarapp.com` | HTTP routes, workers, auth/session flows, email verification, billing/runtime orchestration, provider integrations, server-only domain logic | Shared UI, browser-only rendering concerns, generic shared contracts that belong in `shared-charlarapp` |
| `shared-charlarapp` | DB schema, shared contracts, feature flags, plan metadata, generated pricing snapshot, cross-project utilities | Server-only runtime logic, page-specific UI, grading-specific engines |
| `grading-charlarapp` | Grading engines, feedback builders, normalization helpers, browser-safe deterministic grading via local-safe exports | API routing, auth/session orchestration, generic non-grading shared contracts |

## API structure

- `app/index.ts`: runtime entrypoint
- `app/routes.ts`: route registration
- `api/`: route modules grouped by feature
- `domains/`: business logic and domain services
- `utils/`: reusable runtime helpers
- `scripts/`: maintenance and sync scripts

## Auth and verification expectations

- Auth/session behavior lives in `api.charlarapp.com/domains/auth`.
- Email verification is a server-side flow; related status and persistence changes can affect shared schema/contracts and learner app auth flows.
- Changes here commonly affect app routes like `/login`, `/signup`, `/verify-email`, and `/parent-consent`, plus docs.

## Shared contract expectations

- Put shared payloads, schema changes, plan metadata, and feature flags in `shared-charlarapp`.
- Assume exported changes in `shared-charlarapp` can affect app, admin, marketing, api, grading, and docs.
- Keep server-only secrets, provider SDK usage, and DB/runtime orchestration out of `shared-charlarapp`.
