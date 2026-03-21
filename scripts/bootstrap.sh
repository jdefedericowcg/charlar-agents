#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"

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

ALL_REPOS=(
  "${FRONTEND_REPOS[@]}"
  "${SHARED_UI_REPOS[@]}"
  "${BACKEND_REPOS[@]}"
  "${DOCS_REPOS[@]}"
)

CHARLAR_SKILLS=(
  "charlar-workspace"
  "charlar-frontend-design"
  "charlar-api"
)

ROOT_SKILLS=(
  "charlar-workspace"
  "charlar-frontend-design"
  "charlar-api"
)

log() {
  printf '[bootstrap] %s\n' "$*"
}

ensure_line() {
  local file="$1"
  local line="$2"

  mkdir -p "$(dirname "$file")"

  if [[ -f "$file" ]] && grep -Fxq "$line" "$file"; then
    log "ok $file contains $line"
    return
  fi

  if [[ -s "$file" ]]; then
    printf '\n%s\n' "$line" >> "$file"
  else
    printf '%s\n' "$line" > "$file"
  fi

  log "updated $file with $line"
}

sync_file() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [[ -f "$target" ]] && cmp -s "$source" "$target"; then
    log "ok $target"
    return
  fi

  install -m 0644 "$source" "$target"
  log "wrote $target"
}

sync_symlink() {
  local target="$1"
  local link_path="$2"
  local current=""

  mkdir -p "$(dirname "$link_path")"

  if [[ -L "$link_path" ]]; then
    current="$(readlink "$link_path")"
  fi

  if [[ "$current" == "$target" ]]; then
    log "ok $link_path -> $target"
    return
  fi

  rm -rf "$link_path"
  ln -s "$target" "$link_path"
  log "linked $link_path -> $target"
}

remove_if_present() {
  local path="$1"

  if [[ -L "$path" || -e "$path" ]]; then
    rm -rf "$path"
    log "removed $path"
  fi
}

prune_charlar_skill_set() {
  local skills_dir="$1"
  shift
  local allowed=("$@")
  local keep
  local skill

  mkdir -p "$skills_dir"

  for skill in "${CHARLAR_SKILLS[@]}"; do
    keep=0
    for allowed_skill in "${allowed[@]}"; do
      if [[ "$skill" == "$allowed_skill" ]]; then
        keep=1
        break
      fi
    done
    if [[ "$keep" -eq 0 ]]; then
      remove_if_present "$skills_dir/$skill"
    fi
  done
}

render_repo() {
  local template_group="$1"
  local repo="$2"
  local repo_dir="$ROOT_DIR/$repo"

  if [[ ! -d "$repo_dir" ]]; then
    printf '[bootstrap] missing repo: %s\n' "$repo_dir" >&2
    exit 1
  fi

  sync_file "$ROOT_DIR/templates/repos/$template_group/AGENTS.md" "$repo_dir/AGENTS.md"
  sync_file "$ROOT_DIR/templates/repos/$template_group/.codex/config.toml" "$repo_dir/.codex/config.toml"
  ensure_line "$repo_dir/.gitignore" ".agents/"
}

expose_repo_skills() {
  local repo="$1"
  shift
  local repo_dir="$ROOT_DIR/$repo"
  local skills_dir="$repo_dir/.agents/skills"
  local allowed=("$@")

  prune_charlar_skill_set "$skills_dir" "${allowed[@]}"

  for skill in "${allowed[@]}"; do
    sync_symlink "../../../skills/$skill" "$skills_dir/$skill"
  done
}

main() {
  sync_file "$ROOT_DIR/templates/home/config.toml" "$CODEX_HOME_DIR/config.toml"
  sync_file "$ROOT_DIR/templates/home/AGENTS.md" "$CODEX_HOME_DIR/AGENTS.md"

  prune_charlar_skill_set "$ROOT_DIR/.agents/skills" "${ROOT_SKILLS[@]}"
  for skill in "${ROOT_SKILLS[@]}"; do
    sync_symlink "../../skills/$skill" "$ROOT_DIR/.agents/skills/$skill"
  done

  for repo in "${FRONTEND_REPOS[@]}"; do
    render_repo "frontend" "$repo"
    expose_repo_skills "$repo" "charlar-workspace" "charlar-frontend-design"
  done

  for repo in "${SHARED_UI_REPOS[@]}"; do
    render_repo "shared-ui" "$repo"
    expose_repo_skills "$repo" "charlar-workspace" "charlar-frontend-design"
  done

  for repo in "${BACKEND_REPOS[@]}"; do
    render_repo "backend" "$repo"
    expose_repo_skills "$repo" "charlar-workspace" "charlar-api"
  done

  for repo in "${DOCS_REPOS[@]}"; do
    render_repo "docs" "$repo"
    expose_repo_skills "$repo" "charlar-workspace"
  done

  log "bootstrap complete"
}

main "$@"
