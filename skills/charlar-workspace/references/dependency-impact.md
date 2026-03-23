# Dependency Impact

## Linked package map

| Producer | Direct consumers | Common impact |
| --- | --- | --- |
| `shared-charlarapp` | `app`, `admin`, `charlarapp.com`, `api`, `grading` | Shared types, schema, pricing snapshot, feature flags, utilities |
| `shared-ui-charlarapp` | `app`, `admin`, `charlarapp.com` | Shared component contracts, styles, accessibility, Tailwind usage |
| `grading-charlarapp` | `app`, `api` | Grading engines, normalization, browser-safe local grading |
| `api.charlarapp.com/api/meta/plan-pricing.ts` | `app`, `charlarapp.com` runtime pricing UIs | Live pricing payload for learner and marketing surfaces |

## High-signal heuristics

- Changing a public export in `shared-charlarapp` usually requires checking every app plus docs.
- Changing a public export or visual primitive in `shared-ui-charlarapp` usually requires checking `app`, `admin`, and `charlarapp.com`.
- Changing `grading-charlarapp` often affects both learner UX and API/server grading behavior.
- Changing auth, billing, consent, or verification flows in `api.charlarapp.com` often affects `app.charlarapp.com`, sometimes `admin.charlarapp.com`, and usually `docs-charlarapp`.
- Changing plan pricing or plan copy typically touches `api.charlarapp.com`, `shared-charlarapp`, `app.charlarapp.com`, `charlarapp.com`, and docs.
- Changing docs alone has no runtime impact, but runtime or workflow changes should usually update docs.

## Multi-repo planning checklist

1. Name the owning repo first.
2. List linked packages or downstream repos that consume the changed surface.
3. Call out whether the change is contract-only, runtime-only, or both.
4. Decide which repo should hold implementation versus documentation.
5. Read each touched repo's tracked `AGENTS.md` and `.codex/config.toml`, then decide whether to stay at the root or narrow into a child repo for execution.

## Common cross-repo commands

```bash
cd app.charlarapp.com && yarn lint && yarn build
cd admin.charlarapp.com && yarn lint && yarn build
cd charlarapp.com && yarn lint && yarn build
cd api.charlarapp.com && yarn lint && yarn build && yarn test:conversation-facts
cd shared-ui-charlarapp && yarn lint && yarn typecheck
cd shared-charlarapp && yarn validate:plan-copy
```

## Pricing and contract change notes

- `app.charlarapp.com` and `charlarapp.com` fetch runtime pricing from `/meta/plan-pricing`.
- Treat shared pricing data as a cross-repo change even if the initial edit lands in one repo, because the API contract and both frontends move together.
