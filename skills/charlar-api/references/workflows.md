# Common Workflows

## Pricing sync

- `api.charlarapp.com/scripts/sync-plan-pricing.mjs` is the cross-repo sync entrypoint.
- `app.charlarapp.com` runs that script as `prebuild`.
- `charlarapp.com` exposes the same behavior via `yarn sync:plan-pricing`.
- `shared-charlarapp` owns shared plan/pricing metadata and exposes `yarn validate:plan-copy`.
- Treat pricing changes as cross-repo work even if the initial edit lands in one repo.

## Verification commands

```bash
cd api.charlarapp.com && yarn lint && yarn build && yarn test:conversation-facts
cd shared-charlarapp && yarn validate:plan-copy
```

Verify `grading-charlarapp` changes through downstream consumers such as `app.charlarapp.com` or `api.charlarapp.com` when the grading package does not expose a dedicated script for the touched area.

## High-signal impact heuristics

- Auth/session/email verification change -> check app auth flows and docs.
- Shared schema or exported type change -> inspect app, admin, marketing, api, grading, and docs.
- Grading engine change -> inspect both app and api consumers.
- Billing or plan metadata change -> inspect api, shared, app, marketing, and docs.
