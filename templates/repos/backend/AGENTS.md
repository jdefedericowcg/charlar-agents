# Charlar Backend Or Shared Repo

Use this repo when you want a tighter backend, shared-contract, or grading-layer context than the workspace root.

- `api.charlarapp.com` owns routes, workers, auth/session flows, billing/runtime orchestration, and server-only domain logic.
- `shared-charlarapp` owns shared schema, feature flags, plan/pricing metadata, generated pricing data, and cross-project utilities.
- `grading-charlarapp` owns reusable grading engines and browser-safe deterministic grading helpers.
- Keep route handlers thin and preserve clear domain boundaries.
- Auth, pricing, plan copy, consent, and shared contract changes often affect multiple repos. Call out downstream impact before editing and use `$charlar-workspace` when ownership is unclear.
- Prefer `$charlar-api` for backend or shared-contract work.
- When working from this repo, run the commands that exist here, such as `yarn lint`, `yarn build`, `yarn test:conversation-facts`, `yarn validate:plan-copy`, or downstream consumer checks when shared packages do not expose a dedicated script. From the workspace root, target the same repo-local commands explicitly.
