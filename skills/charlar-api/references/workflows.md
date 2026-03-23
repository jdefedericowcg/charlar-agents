# Common Workflows

## Pricing sync

- `api.charlarapp.com/api/meta/plan-pricing.ts` is the runtime source for public pricing payloads.
- `app.charlarapp.com` and `charlarapp.com` fetch live pricing from `/meta/plan-pricing` at runtime.
- `shared-charlarapp` owns shared plan/pricing types, formatting helpers, and schema metadata.
- Treat pricing changes as cross-repo work even if the initial edit lands in one repo, because public UI surfaces now depend on the runtime API contract.

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
