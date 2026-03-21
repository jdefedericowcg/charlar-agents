---
name: charlar-api
description: Plan and implement Charlar backend, shared-contract, and grading changes across `api.charlarapp.com`, `shared-charlarapp`, and `grading-charlarapp`. Use for API/domain work, auth/session/email-verification flows, shared schema or contract updates, grading-engine changes, pricing-sync changes, and backend impact analysis that may affect frontend consumers.
---

# Charlar API

Use this skill for backend and shared-runtime work after repo ownership is clear. If the first question is routing across repos, use `$charlar-workspace` first and then continue in the correct child repo.

## Workflow

1. Choose the owner repo with [references/domain-boundaries.md](references/domain-boundaries.md).
2. Read [references/workflows.md](references/workflows.md) when the task touches auth, pricing, shared contracts, or downstream verification.
3. Keep server-only runtime logic in `api.charlarapp.com`.
4. Keep shared schema, plan metadata, and reusable contracts in `shared-charlarapp`.
5. Keep reusable grading logic in `grading-charlarapp`, and keep browser-safe deterministic helpers in its local-safe exports.
6. Call out downstream repo impact before editing when contracts or shared packages move.

## Guardrails

- Keep route modules thin and prefer reusable domain/store/service code over route-level business logic.
- Keep auth, session, verification, billing, and provider-side orchestration in the API repo unless the change is purely a shared contract.
- Keep browser-safe/shared types out of server-only modules.
- Treat plan pricing, feature flags, legal/consent helpers, and auth payloads as cross-repo contracts.

## Verification

- Run repo-local checks from the owning repo.
- Use `yarn lint` as the default first pass.
- Use `cd api.charlarapp.com && yarn build && yarn test:conversation-facts` for API changes.
- Use `cd shared-charlarapp && yarn validate:plan-copy` when shared pricing or plan copy changes.
- Verify downstream consumers when public contracts or shared package exports change.
