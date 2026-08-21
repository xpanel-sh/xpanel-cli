#!/usr/bin/env bash
set -euo pipefail

source "$XPANEL_CLI_DIR/lib/context.sh"

FORCE_UPDATE=false
for argument in "$@"; do
  case "$argument" in
    --force|--discard-local-changes)
      FORCE_UPDATE=true
      ;;
    *)
      echo "$(xpanel_t update_unknown_option option="$argument")" >&2
      exit 2
      ;;
  esac
done

backup_and_discard_tracked_changes() {
  local directory="$1" label="$2" safe_label backup_root backup_dir
  safe_label="${label//[^[:alnum:]._-]/_}"
  backup_root="${XPANEL_UPDATE_BACKUP_ROOT:-/var/backups/xpanel/updates}"
  [[ "$backup_root" == /* ]] || { echo "$(xpanel_t update_unsafe_backup root="$backup_root")" >&2; return 1; }
  backup_dir="$backup_root/$(date -u +%Y%m%dT%H%M%SZ)-$$"

  mkdir -p "$backup_dir"
  if ! chmod 0700 "$backup_dir" 2>/dev/null; then
    [[ "$(uname -s)" != "Linux" ]] || return 1
  fi
  git -C "$directory" status --short --untracked-files=no > "$backup_dir/$safe_label.status"
  git -C "$directory" diff --binary HEAD > "$backup_dir/$safe_label.patch"
  if ! chmod 0600 "$backup_dir/$safe_label.status" "$backup_dir/$safe_label.patch" 2>/dev/null; then
    [[ "$(uname -s)" != "Linux" ]] || return 1
  fi
  echo "$(xpanel_t update_backup_created label="$label" path="$backup_dir/$safe_label.patch")"

  # --force is intentionally limited to tracked content. New untracked files
  # are never deleted by an update and therefore do not need restoration.
  git -C "$directory" reset --hard HEAD >/dev/null
}

update_repository() {
  local directory="$1" label="$2"

  if [[ ! -d "$directory/.git" ]]; then
    echo "$(xpanel_t update_not_git label="$label" root="$directory")" >&2
    return 1
  fi
  if [[ -n "$(git -C "$directory" status --porcelain --untracked-files=no)" ]]; then
    if [[ "$FORCE_UPDATE" == "true" ]]; then
      backup_and_discard_tracked_changes "$directory" "$label"
    else
      echo "$(xpanel_t update_dirty label="$label" root="$directory")" >&2
      return 1
    fi
  fi

  echo "$(xpanel_t update_fetching label="$label")"
  git -C "$directory" pull --ff-only
}

if [[ -d "$XPANEL_CLI_DIR/.git" ]]; then
  update_repository "$XPANEL_CLI_DIR" "xpanel-cli"
  bash "$XPANEL_CLI_DIR/install.sh"
else
  echo "$(xpanel_t update_cli_unmanaged root="$XPANEL_CLI_DIR")"
fi

update_repository "$XPANEL_ROOT" "$XPANEL_SYSTEM"

if [[ -f "$XPANEL_ROOT/scripts/xpanel-update.sh" ]]; then
  (
    cd "$XPANEL_ROOT"
    bash "$XPANEL_ROOT/scripts/xpanel-update.sh"
  )
fi

echo "$(xpanel_t update_complete system="$XPANEL_SYSTEM")"
