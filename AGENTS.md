# Charlar Workspace Root

This workspace root is the primary Codex working context for Charlar.
All child directories here are independent git repositories.
Use this root for multi-repo implementation, testing, review, routing, and audit work.
Root `git status` is not authoritative for child repo changes because each child repo manages its own history.
Use `./scripts/status-by-repo.sh` from the root when you need an accurate workspace-wide git view.
Before editing, identify the affected repo set and state which repos are in scope.
For each touched repo, consult its tracked `AGENTS.md` and note the repo-specific commands, constraints, conventions, and validation requirements that matter.
Treat child repo guidance as reference material in root sessions; it is not automatically active unless you narrow into that repo.
Group edits, validation, and summaries by repo, even when working entirely from the root.
Run repo-local commands for each touched repo and report touched repos clearly in final summaries.
Use `$charlar-workspace` first to scope ownership and downstream impact, then use `$charlar-api` or `$charlar-frontend-design` once the repo set is clear.
Move into a child repo only when tighter focus, repo-local behavior, or simpler single-repo validation helps.
