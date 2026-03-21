---
name: charlar-workspace
description: Route work across the Charlar super-root, choose the owning repo set, estimate linked-package and cross-repo impact, and support multi-repo implementation from `/home/jaime/personal/charlar`. Use when working from `/home/jaime/personal/charlar`, when ownership is unclear, when a task may touch `app/admin/marketing/api/shared/shared-ui/grading/docs`, or when you need dependency-impact analysis before editing.
---

# Charlar Workspace

Use this skill from the workspace root or anytime the first question is "which repo owns this?" or "what else will this change break?" The workspace root is the default multi-repo working context. Drop into a child repo only when tighter focus or repo-local behavior helps.

## Workflow

1. Identify the likely affected repo set before editing anything.
2. Read [references/repo-map.md](references/repo-map.md) for ownership and repo-local command entrypoints.
3. For each touched repo, inspect its tracked `AGENTS.md` and `.codex/config.toml` before editing.
4. Capture the repo-specific commands, constraints, conventions, and validation requirements that matter.
5. Read [references/dependency-impact.md](references/dependency-impact.md) when changing linked packages, shared contracts, auth flows, or pricing.
6. State the repo plan explicitly: primary owner, additional touched repos, and why each is in scope.
7. Stay in the workspace root for multi-repo implementation, validation, and review when that keeps the work clearer; move into a narrowed child repo only when tighter focus or repo-local behavior helps.

## Root-First Loop

1. Inspect the task and name the affected repos up front.
2. Consult touched child repo guidance and record what matters by repo.
3. Group edits by repo instead of treating the workspace as a single codebase.
4. Run validation per touched repo using that repo's own commands.
5. Summarize results by repo, including untouched repos you considered but ruled out.

## Working Shape

- `Affected repos:` list repos in scope before editing.
- `Repo guidance:` note relevant commands, constraints, conventions, and validation per touched repo from that repo's tracked files.
- `Planned changes:` group planned edits by repo.
- `Validation:` group commands or justified skips by repo.
- `Final summary:` report results by repo.

## Ownership Rules

- Use `app.charlarapp.com` for learner-facing product flows and SPA behavior.
- Use `admin.charlarapp.com` for internal/admin tooling and `/admin` consumers.
- Use `charlarapp.com` for public marketing, support, and legal surfaces.
- Use `api.charlarapp.com` for routes, workers, auth/session flows, billing/runtime orchestration, and server-only domain logic.
- Use `shared-charlarapp` for shared schema, contracts, feature flags, pricing snapshots, and cross-project utilities.
- Use `shared-ui-charlarapp` for reusable UI primitives and shared styles consumed by at least two frontends.
- Use `grading-charlarapp` for grading engines and browser-safe deterministic grading helpers.
- Use `docs-charlarapp` for architecture notes, runbooks, repo maps, and operational documentation.

## Guardrails

- Do not assume root `git status` reflects child repo changes.
- Do not edit until you can name the affected repo set, even if some entries are only provisional.
- Do not start editing a touched repo from root until you have read that repo's tracked guidance.
- Treat child repo `AGENTS.md` and `.codex/config.toml` as reference guidance in root sessions, not automatically active instructions.
- Prefer the workspace root for multi-repo work; narrow into a child repo when a single owner and repo-local context make the task simpler.
- Prefer a single owning repo; only spread work when a real shared contract or linked package requires it.
- Hand off plans with exact repo paths and concrete validation commands grouped by repo.
- Use the root-exposed skills for multi-repo work and repo-local `AGENTS.md`, `.codex/config.toml`, and exposed repo skills when you narrow into a child repo.

## Per-Repo Validation

- For each touched repo, run at least one repo-local command that covers the changed surface when a relevant command exists.
- Prefer commands called out in the touched repo's `AGENTS.md` first, then fall back to [references/repo-map.md](references/repo-map.md).
- Prefer the commands listed in [references/repo-map.md](references/repo-map.md) before inventing ad hoc checks.
- If you skip validation for a touched repo, say so explicitly and give the reason.
- Keep validation reporting grouped by repo instead of one blended workspace summary.

## Final Reporting

- `Touched repos:` list each repo changed.
- `Repo guidance used:` summarize the repo-specific guidance that actually shaped the work.
- `Validation:` list commands or skipped checks per touched repo.
- `Notes:` call out downstream repos considered, follow-up risk, or why you narrowed into a child repo if you did.
