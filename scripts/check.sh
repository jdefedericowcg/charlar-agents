#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAILURES=0

FRONTEND_REPOS=(
  "admin.charlarapp.com"
  "app.charlarapp.com"
  "charlarapp.com"
)

SHARED_UI_REPOS=(
  "shared-ui-charlarapp"
)

BACKEND_REPOS=(
  "api.charlarapp.com"
  "shared-charlarapp"
  "grading-charlarapp"
)

DOCS_REPOS=(
  "docs-charlarapp"
)

KNOWN_SKILLS=(
  "charlar-workspace"
  "charlar-frontend-design"
  "charlar-api"
)

ROOT_IGNORE_ENTRIES=(
  "admin.charlarapp.com/"
  "api.charlarapp.com/"
  "app.charlarapp.com/"
  "charlarapp.com/"
  "docs-charlarapp/"
  "grading-charlarapp/"
  "shared-charlarapp/"
  "shared-ui-charlarapp/"
  ".DS_Store"
  ".idea/"
  ".vscode/"
  "*.log"
)

ok() {
  printf '[check] OK   %s\n' "$*"
}

fail() {
  printf '[check] FAIL %s\n' "$*"
  FAILURES=$((FAILURES + 1))
}

check_git_root() {
  local repo_dir="$1"
  local label="$2"
  local actual_root=""

  if ! actual_root="$(git -C "$repo_dir" rev-parse --show-toplevel 2>/dev/null)"; then
    fail "$label could not resolve git toplevel"
    return
  fi

  if [[ "$actual_root" == "$repo_dir" ]]; then
    ok "$label git toplevel is $repo_dir"
  else
    fail "$label git toplevel is $actual_root, expected $repo_dir"
  fi
}

check_git_tracked() {
  local repo_dir="$1"
  local path="$2"
  local label="$3"

  if git -C "$repo_dir" ls-files --error-unmatch -- "$path" >/dev/null 2>&1; then
    ok "$label tracked"
  else
    fail "$label is not tracked in git"
  fi
}

check_tree_tracked() {
  local repo_dir="$1"
  local tree_path="$2"
  local label="$3"
  local rel_path=""
  local missing=0

  while IFS= read -r path; do
    rel_path="${path#$repo_dir/}"
    if git -C "$repo_dir" ls-files --error-unmatch -- "$rel_path" >/dev/null 2>&1; then
      continue
    fi

    fail "$label file is not tracked: $rel_path"
    missing=1
  done < <(find "$tree_path" \( -type f -o -type l \) | sort)

  if [[ "$missing" -eq 0 ]]; then
    ok "$label tracked"
  fi
}

check_file_exists() {
  local path="$1"
  local label="$2"

  if [[ -f "$path" ]]; then
    ok "$label exists"
  else
    fail "$label missing at $path"
  fi
}

check_executable() {
  local path="$1"
  local label="$2"

  if [[ -x "$path" ]]; then
    ok "$label executable"
  else
    fail "$label is not executable at $path"
  fi
}

check_file_matches() {
  local expected="$1"
  local actual="$2"
  local label="$3"

  if [[ ! -f "$actual" ]]; then
    fail "$label missing at $actual"
    return
  fi

  if cmp -s "$expected" "$actual"; then
    ok "$label matches template"
    return
  fi

  fail "$label drifted from $expected"
  diff -u "$expected" "$actual" || true
}

check_symlink() {
  local path="$1"
  local target="$2"
  local label="$3"

  if [[ ! -L "$path" ]]; then
    fail "$label missing symlink at $path"
    return
  fi

  if [[ "$(readlink "$path")" != "$target" ]]; then
    fail "$label points to $(readlink "$path"), expected $target"
    return
  fi

  if [[ ! -e "$path" ]]; then
    fail "$label is broken at $path"
    return
  fi

  ok "$label -> $target"
}

check_absent() {
  local path="$1"
  local label="$2"

  if [[ -L "$path" || -e "$path" ]]; then
    fail "$label should not exist at $path"
  else
    ok "$label not exposed"
  fi
}

check_contains_line() {
  local file="$1"
  local line="$2"
  local label="$3"

  if [[ ! -f "$file" ]]; then
    fail "$label missing because $file does not exist"
    return
  fi

  if grep -Fxq -- "$line" "$file"; then
    ok "$label"
  else
    fail "$label missing from $file"
  fi
}

check_root_ignore_entries() {
  check_file_exists "$ROOT_DIR/.gitignore" "root .gitignore"
  for entry in "${ROOT_IGNORE_ENTRIES[@]}"; do
    check_contains_line "$ROOT_DIR/.gitignore" "$entry" "root .gitignore contains $entry"
  done
}

check_repo_render() {
  local template_group="$1"
  local repo="$2"
  local repo_dir="$ROOT_DIR/$repo"

  check_git_root "$repo_dir" "$repo"
  check_file_matches "$ROOT_DIR/templates/repos/$template_group/AGENTS.md" "$repo_dir/AGENTS.md" "$repo AGENTS.md"
  check_file_matches "$ROOT_DIR/templates/repos/$template_group/.codex/config.toml" "$repo_dir/.codex/config.toml" "$repo .codex/config.toml"
  check_git_tracked "$repo_dir" "AGENTS.md" "$repo AGENTS.md"
  check_git_tracked "$repo_dir" ".codex/config.toml" "$repo .codex/config.toml"
  check_git_tracked "$repo_dir" ".gitignore" "$repo .gitignore"
  check_contains_line "$repo_dir/.gitignore" ".agents/" "$repo .gitignore contains .agents/"
}

check_skill_set() {
  local repo_dir="$1"
  shift
  local allowed=("$@")
  local skill
  local allowed_skill
  local should_exist

  for skill in "${KNOWN_SKILLS[@]}"; do
    should_exist=0
    for allowed_skill in "${allowed[@]}"; do
      if [[ "$skill" == "$allowed_skill" ]]; then
        should_exist=1
        break
      fi
    done

    if [[ "$should_exist" -eq 1 ]]; then
      if [[ "$repo_dir" == "$ROOT_DIR" ]]; then
        check_symlink "$repo_dir/.agents/skills/$skill" "../../skills/$skill" "$repo_dir $skill"
      else
        check_symlink "$repo_dir/.agents/skills/$skill" "../../../skills/$skill" "$repo_dir $skill"
      fi
    else
      check_absent "$repo_dir/.agents/skills/$skill" "$repo_dir $skill"
    fi
  done
}

main() {
  if [[ -d "$ROOT_DIR/.git" ]]; then
    ok "root git repo initialized"
  else
    fail "root git repo missing at $ROOT_DIR/.git"
  fi

  check_git_root "$ROOT_DIR" "root repo"
  check_root_ignore_entries

  check_file_exists "$ROOT_DIR/AGENTS.md" "root AGENTS.md"
  check_file_exists "$ROOT_DIR/.codex/config.toml" "root .codex/config.toml"
  check_git_tracked "$ROOT_DIR" ".gitignore" "root .gitignore"
  check_git_tracked "$ROOT_DIR" "AGENTS.md" "root AGENTS.md"
  check_git_tracked "$ROOT_DIR" ".codex/config.toml" "root .codex/config.toml"
  check_git_tracked "$ROOT_DIR" ".agents/skills/charlar-workspace" "root workspace skill link"
  check_git_tracked "$ROOT_DIR" ".agents/skills/charlar-frontend-design" "root frontend skill link"
  check_git_tracked "$ROOT_DIR" ".agents/skills/charlar-api" "root api skill link"
  check_tree_tracked "$ROOT_DIR" "$ROOT_DIR/scripts" "root scripts"
  check_tree_tracked "$ROOT_DIR" "$ROOT_DIR/skills" "root skills"
  check_tree_tracked "$ROOT_DIR" "$ROOT_DIR/templates" "root templates"
  check_executable "$ROOT_DIR/scripts/bootstrap.sh" "bootstrap script"
  check_executable "$ROOT_DIR/scripts/check.sh" "check script"
  check_executable "$ROOT_DIR/scripts/status-by-repo.sh" "status-by-repo script"
  check_contains_line "$ROOT_DIR/.codex/config.toml" 'sandbox_mode = "workspace-write"' "root config enables multi-repo workspace writes"
  check_contains_line "$ROOT_DIR/.codex/config.toml" 'approval_policy = "on-request"' "root config keeps on-request approvals"

  check_skill_set "$ROOT_DIR" "${KNOWN_SKILLS[@]}"

  for repo in "${FRONTEND_REPOS[@]}"; do
    check_repo_render "frontend" "$repo"
    check_skill_set "$ROOT_DIR/$repo" "charlar-workspace" "charlar-frontend-design"
  done

  for repo in "${SHARED_UI_REPOS[@]}"; do
    check_repo_render "shared-ui" "$repo"
    check_skill_set "$ROOT_DIR/$repo" "charlar-workspace" "charlar-frontend-design"
  done

  for repo in "${BACKEND_REPOS[@]}"; do
    check_repo_render "backend" "$repo"
    check_skill_set "$ROOT_DIR/$repo" "charlar-workspace" "charlar-api"
  done

  for repo in "${DOCS_REPOS[@]}"; do
    check_repo_render "docs" "$repo"
    check_skill_set "$ROOT_DIR/$repo" "charlar-workspace"
  done

  if [[ "$FAILURES" -gt 0 ]]; then
    printf '[check] %s failure(s) detected\n' "$FAILURES" >&2
    exit 1
  fi

  ok "workspace setup looks consistent"
}

main "$@"
