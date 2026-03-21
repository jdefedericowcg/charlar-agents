# Design Guardrails

## Scope

- Use this skill for frontend surfaces only.
- Keep backend contracts and domain rules in repo-local backend guidance.

## Visual direction

- Preserve the established Charlar look unless the task explicitly asks for a new direction.
- Prefer intentional layouts, clear hierarchy, and purposeful motion over generic dashboard or landing-page boilerplate.
- Introduce new tokens or abstractions only when the pattern repeats and belongs in shared-ui.

## Component ownership

- Keep page-specific composition, data loading, and product copy in the consuming frontend repo.
- Move primitives, shared field patterns, and common layout helpers into `shared-ui-charlarapp` only when at least two frontends benefit.
- Treat public props, exported styles, and shared CSS entrypoints as contracts.

## Accessibility and quality

- Preserve keyboard support and visible focus states.
- Ensure touch-friendly targets and responsive layouts.
- Prefer semantic HTML and predictable state flows.
- Check downstream consumers after shared-ui changes.

## Useful heuristics

- New one-off feature surface in learner app -> stay in `app.charlarapp.com`
- Admin-only workflow -> stay in `admin.charlarapp.com`
- Public landing/support/legal surface -> stay in `charlarapp.com`
- Reusable primitive or shared style contract -> consider `shared-ui-charlarapp`
