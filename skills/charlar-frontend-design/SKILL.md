---
name: charlar-frontend-design
description: Design and implement Charlar frontend surfaces in `app.charlarapp.com`, `admin.charlarapp.com`, `charlarapp.com`, and `shared-ui-charlarapp` using the existing React, Vite, TypeScript, Tailwind, and shared-ui stack. Use for page/component implementation, UI polish, responsive behavior, accessibility, shared-ui extraction decisions, and frontend-specific design work. Do not use for backend ownership questions except to flag API dependencies and hand off with `charlar-workspace`.
---

# Charlar Frontend Design

Use this skill only for frontend surface work. If the first question is repo ownership or linked-package impact, route with `$charlar-workspace` first and then continue in the owning child repo.

## Workflow

1. Identify whether the change belongs in `app`, `admin`, `charlarapp.com`, or `shared-ui`.
2. Read [references/frontend-stack.md](references/frontend-stack.md) for concrete stack and repo differences.
3. Read [references/design-guardrails.md](references/design-guardrails.md) before changing visual direction, tokens, or shared components.
4. Keep product-specific flows local to the owning frontend repo.
5. Extract code to `shared-ui-charlarapp` only when at least two frontends will share the primitive, style, or contract.
6. Run repo-local validation before finishing.

## Implementation Rules

- Preserve the repo's existing visual language unless the task explicitly asks for a redesign.
- Prefer `@charlar/shared-ui` primitives and styles over one-off reinventions when the existing contract fits.
- Keep API calls, auth state, and business logic out of `shared-ui-charlarapp`.
- Design for keyboard access, visible focus, touch targets, and mobile/desktop layouts.
- Favor intentional, polished interfaces over generic placeholder UI, but stay compatible with the existing Charlar stack and patterns.

## Verification

- Run the owning repo's validation from that repo, not from the workspace root.
- Use `yarn lint` and `yarn build` as the default frontend checks.
- Run `yarn check:api-fetch` in `app.charlarapp.com` or `admin.charlarapp.com` when touching API fetch usage.
- Check downstream apps after any public `shared-ui` change.
