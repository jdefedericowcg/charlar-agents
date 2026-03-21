# Charlar Shared UI Repo

Use this repo when you want a tighter shared-UI context than the workspace root.

- Keep product-specific flows, page logic, and API state in the consuming app, admin, or marketing repo.
- Prefer stable exports, accessible defaults, and additive changes.
- Treat public props, CSS entrypoints, and shared style tokens as contracts.
- Call out expected downstream impact on `app.charlarapp.com`, `admin.charlarapp.com`, and `charlarapp.com` before changing shared primitives.
- Prefer `$charlar-frontend-design` for component/design work and `$charlar-workspace` for routing or downstream impact checks.
- When working from this repo, run validation here, especially `yarn lint`, and verify downstream consumers when public behavior changes. From the workspace root, target the same repo-local checks explicitly.
