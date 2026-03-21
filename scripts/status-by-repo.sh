#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT_LABEL="workspace-root"

REPOS=(
  "admin.charlarapp.com"
  "api.charlarapp.com"
  "app.charlarapp.com"
  "charlarapp.com"
  "docs-charlarapp"
  "grading-charlarapp"
  "shared-charlarapp"
  "shared-ui-charlarapp"
)

REQUESTED_REPOS=()
SUMMARY_ROWS=()

usage() {
  cat <<'EOF'
Usage:
  ./scripts/status-by-repo.sh
  ./scripts/status-by-repo.sh workspace-root api.charlarapp.com app.charlarapp.com

Shows a workspace-wide git dashboard from the root. With no arguments, includes the
root repo and every child repo. With arguments, limits output to the named repos.
EOF
}

is_known_repo() {
  local candidate="$1"
  local repo=""

  if [[ "$candidate" == "$ROOT_LABEL" || "$candidate" == "root" ]]; then
    return 0
  fi

  for repo in "${REPOS[@]}"; do
    if [[ "$repo" == "$candidate" ]]; then
      return 0
    fi
  done

  return 1
}

collect_requested_repos() {
  local candidate=""

  if [[ "$#" -eq 0 ]]; then
    REQUESTED_REPOS=("$ROOT_LABEL" "${REPOS[@]}")
    return
  fi

  for candidate in "$@"; do
    if [[ "$candidate" == "--help" || "$candidate" == "-h" ]]; then
      usage
      exit 0
    fi

    if ! is_known_repo "$candidate"; then
      printf 'Unknown repo: %s\n\n' "$candidate" >&2
      usage >&2
      exit 1
    fi

    if [[ "$candidate" == "root" ]]; then
      REQUESTED_REPOS+=("$ROOT_LABEL")
    else
      REQUESTED_REPOS+=("$candidate")
    fi
  done
}

repo_dir_for_label() {
  local label="$1"

  if [[ "$label" == "$ROOT_LABEL" ]]; then
    printf '%s\n' "$ROOT_DIR"
    return
  fi

  printf '%s/%s\n' "$ROOT_DIR" "$label"
}

classify_path() {
  local label="$1"
  local path="$2"

  if [[ "$label" == "$ROOT_LABEL" ]]; then
    case "$path" in
      .agents/*|.codex/*|.gitignore|AGENTS.md|scripts/*|skills/*|templates/*)
        printf 'setup\n'
        return
        ;;
    esac
  else
    case "$path" in
      AGENTS.md|.codex/config.toml|.gitignore)
        printf 'setup\n'
        return
        ;;
    esac
  fi

  printf 'work\n'
}

append_item() {
  local var_name="$1"
  local item="$2"
  local current="${!var_name:-}"

  if [[ -n "$current" ]]; then
    printf -v "$var_name" '%s\n%s' "$current" "$item"
  else
    printf -v "$var_name" '%s' "$item"
  fi
}

count_lines() {
  local value="$1"

  if [[ -z "$value" ]]; then
    printf '0\n'
  else
    printf '%s\n' "$value" | wc -l | tr -d ' '
  fi
}

print_section() {
  local title="$1"
  local body="$2"

  if [[ -z "$body" ]]; then
    return
  fi

  printf '%s\n' "$title"
  printf '%s\n' "$body"
}

collect_repo_status() {
  local label="$1"
  local repo_dir="$2"
  local status_output=""
  local branch_line=""
  local entry=""
  local xy=""
  local path=""
  local bucket=""
  local summary_state="clean"
  local setup_staged=""
  local setup_unstaged=""
  local work_staged=""
  local work_unstaged=""
  local untracked=""
  local total_changed=0

  if ! status_output="$(git -C "$repo_dir" status --porcelain=v1 --branch 2>&1)"; then
    SUMMARY_ROWS+=("$label | error")
    printf '=== %s ===\n' "$label"
    printf '%s\n\n' "$status_output"
    return
  fi

  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue

    if [[ "$entry" == '## '* ]]; then
      branch_line="$entry"
      continue
    fi

    xy="${entry:0:2}"
    path="${entry:3}"
    bucket="$(classify_path "$label" "$path")"

    case "$xy" in
      '??')
        append_item untracked "$path"
        ;;
      *)
        if [[ "${xy:0:1}" != " " ]]; then
          if [[ "$bucket" == "setup" ]]; then
            append_item setup_staged "$xy $path"
          else
            append_item work_staged "$xy $path"
          fi
        fi

        if [[ "${xy:1:1}" != " " ]]; then
          if [[ "$bucket" == "setup" ]]; then
            append_item setup_unstaged "$xy $path"
          else
            append_item work_unstaged "$xy $path"
          fi
        fi
        ;;
    esac
  done <<< "$status_output"

  total_changed=$(
    printf '%s\n' \
      "$(count_lines "$setup_staged")" \
      "$(count_lines "$setup_unstaged")" \
      "$(count_lines "$work_staged")" \
      "$(count_lines "$work_unstaged")" \
      "$(count_lines "$untracked")" |
      awk '{sum += $1} END {print sum + 0}'
  )

  if [[ "$total_changed" -gt 0 ]]; then
    summary_state="dirty"
  fi

  SUMMARY_ROWS+=(
    "$label | $summary_state | setup(staged=$(count_lines "$setup_staged"), unstaged=$(count_lines "$setup_unstaged")) | work(staged=$(count_lines "$work_staged"), unstaged=$(count_lines "$work_unstaged"), untracked=$(count_lines "$untracked"))"
  )

  printf '=== %s ===\n' "$label"
  printf '%s\n' "$branch_line"

  if [[ "$summary_state" == "clean" ]]; then
    printf 'clean\n\n'
    return
  fi

  printf 'summary: setup(staged=%s, unstaged=%s) work(staged=%s, unstaged=%s, untracked=%s)\n' \
    "$(count_lines "$setup_staged")" \
    "$(count_lines "$setup_unstaged")" \
    "$(count_lines "$work_staged")" \
    "$(count_lines "$work_unstaged")" \
    "$(count_lines "$untracked")"
  print_section 'setup staged:' "$setup_staged"
  print_section 'setup unstaged:' "$setup_unstaged"
  print_section 'work staged:' "$work_staged"
  print_section 'work unstaged:' "$work_unstaged"
  print_section 'untracked:' "$untracked"
  printf '\n'
}

print_summary() {
  local row=""

  printf '=== workspace-summary ===\n'

  for row in "${SUMMARY_ROWS[@]}"; do
    printf '%s\n' "$row"
  done

  printf '\n'
}

main() {
  local repo=""
  local repo_dir=""

  collect_requested_repos "$@"

  for repo in "${REQUESTED_REPOS[@]}"; do
    repo_dir="$(repo_dir_for_label "$repo")"
    collect_repo_status "$repo" "$repo_dir"
  done

  print_summary
}

main "$@"
