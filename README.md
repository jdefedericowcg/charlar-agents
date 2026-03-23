# Charlar Codex Workspace

This repo is the primary Codex working context for the Charlar workspace.

- Work from `/home/jaime/personal/charlar` by default for multi-repo implementation, testing, review, routing, and audit work.
- Treat the child directories as independent git repositories with their own tracked `AGENTS.md` and `.codex/config.toml`.
- Narrow into a child repo only when you want tighter focus, repo-local behavior, or simpler single-repo validation.

## What This Setup Does

- Keeps the root workspace writable and root-first.
- Exposes the shared root skills:
  - `$charlar-workspace`
  - `$charlar-api`
  - `$charlar-frontend-design`
- Keeps child repo Codex behavior explicit with tracked `AGENTS.md` and `.codex/config.toml`.
- Keeps child `.agents/skills/` symlinks local-only and ignored.
- Keeps optional home Codex templates available as reference examples.

## Workspace Layout

- Root repo: Codex workspace setup, shared skills, templates, and helper scripts.
- Child repos:
  - `app.charlarapp.com`
  - `admin.charlarapp.com`
  - `charlarapp.com`
  - `api.charlarapp.com`
  - `shared-charlarapp`
  - `shared-ui-charlarapp`
  - `grading-charlarapp`
  - `docs-charlarapp`

For repo ownership and common commands, see [skills/charlar-workspace/references/repo-map.md](./skills/charlar-workspace/references/repo-map.md).

## Tracked Vs Local-Only

Tracked in this root repo:

- `AGENTS.md`
- `.codex/config.toml`
- `.agents/skills/` root skill links
- `scripts/`
- `skills/`
- `templates/`
- `.gitignore`
- `README.md`

Tracked in each child repo:

- `AGENTS.md`
- `.codex/config.toml`
- `.gitignore` rule for `.agents/`

Local-only in each child repo:

- `.agents/skills/` symlinks back to the root `skills/` directory

Local-only on the machine:

- `~/.codex/config.toml`
- `~/.codex/AGENTS.md`

Those home files are no longer synced or validated by this repo.
If you want examples for a machine-local setup, use `templates/home/`.

## Setup

From `/home/jaime/personal/charlar`:

```bash
./scripts/bootstrap.sh
./scripts/check.sh
```

`./scripts/bootstrap.sh`:

- syncs tracked child repo `AGENTS.md` and `.codex/config.toml`
- ensures child `.gitignore` ignores `.agents/`
- creates or refreshes root and child skill symlinks

`./scripts/check.sh` verifies the tracked-vs-local policy, key root config, root skill exposure, child repo setup, and helper scripts.

## Daily Root-First Workflow

1. Start in `/home/jaime/personal/charlar`.
2. Run the git dashboard when you need accurate workspace state:

   ```bash
   ./scripts/status-by-repo.sh
   ./scripts/status-by-repo.sh workspace-root api.charlarapp.com app.charlarapp.com
   ```

3. Identify the affected repo set before editing.
4. Read each touched repo's tracked `AGENTS.md` and `.codex/config.toml` from root.
5. Use `$charlar-workspace` first to scope ownership and downstream impact.
6. Use `$charlar-api` or `$charlar-frontend-design` after the repo set is clear.
7. Group edits by repo.
8. Run repo-local commands per touched repo.
9. Summarize work and validation by repo.

## Important Root Rules

- Root `git status` is not authoritative for child repo changes. Use `./scripts/status-by-repo.sh`.
- Child repo `AGENTS.md` and `.codex/config.toml` do not become automatically active just because you are touching that repo from root.
- In a root session, you must deliberately consult the touched child repos' tracked guidance before editing and validation.
- Validation should use repo-local commands for each touched repo, even when you never leave the root directory.

## When To Narrow Into A Child Repo

Drop into a child repo when:

- the task is single-repo and you want less noise
- repo-local behavior or skills are more useful than the shared root context
- validation is simpler if you run from that repo directly

The child repos remain valid narrowed contexts. The root workspace remains the default.

## Root Scripts

- `./scripts/bootstrap.sh`
  - sync and refresh the workspace setup
- `./scripts/check.sh`
  - verify workspace consistency
- `./scripts/status-by-repo.sh`
  - show a smarter git dashboard across the root and child repos

The status dashboard separates `setup` changes from other `work` changes and supports optional repo arguments.

## Root Skills

- `$charlar-workspace`
  - identify affected repos, consult touched child repo guidance, plan multi-repo work, and report by repo
- `$charlar-api`
  - backend/shared-contract/grading work
- `$charlar-frontend-design`
  - frontend and shared-UI work

For workflow details, see [skills/charlar-workspace/SKILL.md](./skills/charlar-workspace/SKILL.md).

## Common Footguns

- The root repo is not a monorepo git root for application code.
- Child repo git history, status, and validation remain repo-specific.
- Setup changes and product changes can coexist in the same child repo working tree; the status dashboard helps distinguish them, but you still need judgment when committing.
