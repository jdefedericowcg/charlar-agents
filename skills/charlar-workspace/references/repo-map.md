# Repo Map

## Root purpose

- `/home/jaime/personal/charlar` is the primary multi-repo Codex workspace for Charlar.
- Use the root for routing, exploration, dependency-impact analysis, multi-repo implementation, targeted testing, review, shared-skill maintenance, templates, and bootstrap/check automation.
- Move into an owning child repo when tighter focus, repo-local behavior, or simpler single-repo validation helps more than staying at the root.

## Repos

| Repo | Owns | Common commands | Notes |
| --- | --- | --- | --- |
| `app.charlarapp.com` | Learner SPA | `yarn dev`, `yarn build`, `yarn lint`, `yarn check:api-fetch` | Depends on `@charlar/shared`, `@charlar/shared-ui`, `@charlar/grading` |
| `admin.charlarapp.com` | Admin SPA | `yarn dev`, `yarn build`, `yarn lint`, `yarn check:api-fetch` | Depends on `@charlar/shared`, `@charlar/shared-ui` |
| `charlarapp.com` | Marketing/support/legal site | `yarn dev`, `yarn build`, `yarn lint`, `yarn sync:plan-pricing` | Depends on `@charlar/shared`, `@charlar/shared-ui` |
| `api.charlarapp.com` | Express API, workers, auth, billing, server domains | `yarn dev`, `yarn build`, `yarn lint`, `yarn test:conversation-facts` | Depends on `@charlar/shared`, `@charlar/grading` |
| `shared-charlarapp` | Shared schema, contracts, pricing snapshot, utilities | `yarn validate:plan-copy` | Consumed by app, admin, marketing, api, grading |
| `shared-ui-charlarapp` | Shared UI primitives and styles | `yarn lint`, `yarn typecheck` | Consumed by app, admin, marketing |
| `grading-charlarapp` | Reusable grading engines and local deterministic grading | No dedicated package script beyond repo-local TypeScript/tooling | Consumed by app and api; depends on `@charlar/shared` |
| `docs-charlarapp` | Architecture docs, runbooks, repo guides | Repo-local docs updates | Mirrors the independent-repo layout |

## Ownership heuristics

- Put learner-facing UX, route flow, and client state in `app.charlarapp.com`.
- Put internal operational tooling and `/admin` consumers in `admin.charlarapp.com`.
- Put public marketing copy, landing pages, and legal/support pages in `charlarapp.com`.
- Put server runtime behavior, auth/session logic, workers, billing, and provider integrations in `api.charlarapp.com`.
- Put types, DB schema, feature flags, plan metadata, generated pricing snapshot, and reusable non-UI utilities in `shared-charlarapp`.
- Put reusable primitives, shared styles, and stable component contracts in `shared-ui-charlarapp` only when at least two frontends benefit.
- Put grading algorithms and client-safe deterministic grading helpers in `grading-charlarapp`.
- Put documentation, runbooks, and repo maps in `docs-charlarapp`.

## Fast routing examples

- "Add a learner settings toggle" -> `app.charlarapp.com`
- "Add an admin analytics panel" -> `admin.charlarapp.com`
- "Update homepage pricing copy" -> `charlarapp.com`
- "Change email verification behavior" -> `api.charlarapp.com`, with likely `shared-charlarapp` or frontend follow-up if contracts move
- "Add a shared button variant used by app and marketing" -> `shared-ui-charlarapp`
- "Add a new shared plan field or schema column" -> `shared-charlarapp`
- "Change scoring logic used by app and api" -> `grading-charlarapp`
- "Document the new flow or command" -> `docs-charlarapp`
