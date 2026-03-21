# Charlar Frontend Repo

Use this repo when you want a tighter frontend-focused context than the workspace root.

- Stack: React, Vite, TypeScript, Tailwind, `@charlar/shared-ui`, and `@charlar/shared`.
- Keep app-specific UI, copy, route flow, and data wiring in this repo.
- Move code into `shared-ui-charlarapp` only when a primitive, style, or contract is reused by at least two frontends.
- Check linked-package impact before changing `@charlar/shared`, `@charlar/shared-ui`, or plan/pricing data synced from the API.
- Prefer `$charlar-frontend-design` for frontend surface work and `$charlar-workspace` when ownership or downstream impact is unclear.
- When working from this repo, run its own commands such as `yarn lint`, `yarn build`, and any repo-specific checks that apply to the touched area. From the workspace root, target the same repo-local commands explicitly.
